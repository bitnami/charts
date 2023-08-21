package postgresql_ha_test

import (
	"context"
	"fmt"
	"strconv"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

const (
	Timeout         = 90 * time.Second
	PollingInterval = 1 * time.Second
)

var _ = Describe("Postgresql", Ordered, func() {
	var c *kubernetes.Clientset
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := clusterConfigOrDie()
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("a database is created and PostgreSQL is scaled down to 0 replicas and back up", func() {
		It("should have access to the created database", func() {
			stsName := fmt.Sprintf("%s-postgresql", *releaseName)
			pgPoolName := fmt.Sprintf("%s-pgpool", *releaseName)

			By("checking all the replicas are available")
			ss, err := c.AppsV1().StatefulSets(*namespace).Get(ctx, stsName, metav1.GetOptions{})
			Expect(err).NotTo(HaveOccurred())
			Expect(ss.Status.Replicas).NotTo(BeZero())
			origReplicas := *ss.Spec.Replicas

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(*namespace).Get(ctx, stsName, metav1.GetOptions{})
			}, Timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			svc, err := c.CoreV1().Services(*namespace).Get(ctx, pgPoolName, metav1.GetOptions{})
			Expect(err).NotTo(HaveOccurred())

			port, err := getPort(svc, "postgresql")
			Expect(err).NotTo(HaveOccurred())

			image, err := getContainerImage(ss, "postgresql")
			Expect(err).NotTo(HaveOccurred())

			// Use current time for allowing the test suite to repeat
			currentTime := time.Now()
			jobSuffix := fmt.Sprintf("%d%d%d%d%d%d",
				currentTime.Year(), currentTime.Month(),
				currentTime.Day(), currentTime.Hour(),
				currentTime.Minute(), currentTime.Second())

			By("creating a job to create a new test database")
			createDBJobName := fmt.Sprintf("%s-createdb-%s",
				*releaseName, jobSuffix)
			dbName := fmt.Sprintf("test%s", jobSuffix)

			err = createJob(ctx, c, createDBJobName, pgPoolName, port, image, fmt.Sprintf("CREATE DATABASE %s;", dbName))
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(*namespace).Get(ctx, createDBJobName, metav1.GetOptions{})
			}, Timeout, PollingInterval).Should(WithTransform(getSucceededPods, Equal(int32(1))))

			By("scaling down to 0 replicas")
			ss, err = scale(ctx, c, ss, 0)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(*namespace).Get(ctx, stsName, metav1.GetOptions{})
			}, Timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, BeZero()))

			By("scaling up to the original replicas")
			ss, err = scale(ctx, c, ss, origReplicas)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(*namespace).Get(ctx, stsName, metav1.GetOptions{})
			}, Timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			By("creating a job to drop the test database")
			deleteDBJobName := fmt.Sprintf("%s-deletedb-%s",
				*releaseName, jobSuffix)
			err = createJob(ctx, c, deleteDBJobName, pgPoolName, port, image, fmt.Sprintf("DROP DATABASE %s;", dbName))
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(*namespace).Get(ctx, deleteDBJobName, metav1.GetOptions{})
			}, Timeout, PollingInterval).Should(WithTransform(getSucceededPods, Equal(int32(1))))
		})
	})

	AfterEach(func() {
		cancel()
	})
})

func clusterConfigOrDie() *rest.Config {
	if *kubeconfig == "" {
		panic("kubeconfig must be supplied")
	}

	config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
	if err != nil {
		panic(err.Error())
	}

	return config
}

func getAvailableReplicas(ss *appsv1.StatefulSet) int32 {
	return ss.Status.AvailableReplicas
}

func getSucceededPods(j *batchv1.Job) int32 {
	return j.Status.Succeeded
}

func createJob(ctx context.Context, c kubernetes.Interface, name, pgPoolName, port, image, stmt string) error {
	job := &batchv1.Job{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		TypeMeta: metav1.TypeMeta{
			Kind: "Job",
		},
		Spec: batchv1.JobSpec{
			Template: v1.PodTemplateSpec{
				Spec: v1.PodSpec{
					RestartPolicy: "Never",
					Containers: []v1.Container{
						{
							Name:    "psql",
							Image:   image,
							Command: []string{"psql", "-h", pgPoolName, "-p", port, "-U", *username, "-c", stmt},
							Env: []v1.EnvVar{
								{
									Name:  "PGPASSWORD",
									Value: *password,
								},
							},
						},
					},
				},
			},
		},
	}

	_, err := c.BatchV1().Jobs(*namespace).Create(ctx, job, metav1.CreateOptions{})

	return err
}

func scale(ctx context.Context, c kubernetes.Interface, ss *appsv1.StatefulSet, count int32) (*appsv1.StatefulSet, error) {
	name := ss.Name
	ns := ss.Namespace

	for i := 0; i < 3; i++ {
		ss, err := c.AppsV1().StatefulSets(ns).Get(ctx, name, metav1.GetOptions{})
		if err != nil {
			return nil, fmt.Errorf("failed to get statefulset %q: %v", name, err)
		}
		*(ss.Spec.Replicas) = count
		ss, err = c.AppsV1().StatefulSets(ns).Update(ctx, ss, metav1.UpdateOptions{})
		if err == nil {
			return ss, nil
		}
		if !apierrors.IsConflict(err) && !apierrors.IsServerTimeout(err) {
			return nil, fmt.Errorf("failed to update statefulset %q: %v", name, err)
		}
	}

	return nil, fmt.Errorf("too many retries draining statefulset %q", name)
}

func getContainerImage(ss *appsv1.StatefulSet, name string) (string, error) {
	containers := ss.Spec.Template.Spec.Containers

	for _, c := range containers {
		if c.Name == name {
			return c.Image, nil
		}
	}

	return "", fmt.Errorf("container %q not found in statefulset %q", name, ss.Name)
}

func getPort(svc *v1.Service, name string) (string, error) {
	ports := svc.Spec.Ports

	for _, p := range ports {
		if p.Name == name {
			return strconv.Itoa(int(p.Port)), nil
		}
	}

	return "", fmt.Errorf("port %q not found in service %q", name, svc.Name)
}
