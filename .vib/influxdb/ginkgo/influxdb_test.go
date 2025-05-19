package influxdb_test

import (
	"bytes"
	"context"
	"fmt"
	"time"

	utils "github.com/bitnami/charts/.vib/common-tests/ginkgo-utils"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/kubernetes/scheme"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/remotecommand"
)

const (
	PollingInterval = 1 * time.Second
)

var _ = Describe("Influxdb", Ordered, func() {
	var c *kubernetes.Clientset
	var conf *rest.Config
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf = utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("time series data is written and Influxdb is scaled down to 0 replicas and back up", func() {
		It("should have access to query the written data", func() {
			getAvailableReplicas := func(ss *appsv1.StatefulSet) int32 { return ss.Status.AvailableReplicas }
			getSucceededJobs := func(j *batchv1.Job) int32 { return j.Status.Succeeded }
			getOpts := metav1.GetOptions{}

			By("checking all the replicas are available")
			ss, err := c.AppsV1().StatefulSets(namespace).Get(ctx, deployName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			Expect(ss.Status.Replicas).NotTo(BeZero())
			origReplicas := *ss.Spec.Replicas

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, deployName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			svc, err := c.CoreV1().Services(namespace).Get(ctx, deployName, getOpts)
			Expect(err).NotTo(HaveOccurred())

			port, err := utils.SvcGetPortByName(svc, "http")
			Expect(err).NotTo(HaveOccurred())

			image, err := utils.StsGetContainerImageByName(ss, "influxdb")
			Expect(err).NotTo(HaveOccurred())

			// Let's obtain the token from the InfluxDB pod
			pod, err := c.CoreV1().Pods(namespace).Get(ctx, fmt.Sprintf("%s-0", deployName), getOpts)
			Expect(err).NotTo(HaveOccurred())

			req := c.CoreV1().RESTClient().Post().Resource("pods").
				Name(pod.Name).
				Namespace(namespace).
				SubResource("exec").
				VersionedParams(&corev1.PodExecOptions{
					Command:   []string{"cat", "/bitnami/influxdb/.token"},
					Container: pod.Spec.Containers[0].Name,
					Stdout:    true,
					Stderr:    true,
					TTY:       false,
				}, scheme.ParameterCodec)
			exec, err := remotecommand.NewSPDYExecutor(conf, "POST", req.URL())
			Expect(err).NotTo(HaveOccurred())

			var stdout, stderr bytes.Buffer
			err = exec.StreamWithContext(ctx, remotecommand.StreamOptions{
				Stdout: &stdout,
				Stderr: &stderr,
				Tty:    false,
			})
			Expect(err).NotTo(HaveOccurred())

			token := stdout.String()
			// Use current time for allowing the test suite to repeat
			jobSuffix := time.Now().Format("20060102150405")

			By("creating a job to write data")
			createDBJobName := fmt.Sprintf("%s-write-%s",
				deployName, jobSuffix)

			err = createJob(ctx, c, createDBJobName, port, image, "write", token, `home,room=Living\ Room temp=21.1,hum=35.9,co=0i 1747036800`)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, createDBJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("scaling down to 0 replicas")
			ss, err = utils.StsScale(ctx, c, ss, 0)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, deployName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, BeZero()))

			By("scaling up to the original replicas")
			ss, err = utils.StsScale(ctx, c, ss, origReplicas)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, deployName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			By("creating a job to query the data")
			queryJobName := fmt.Sprintf("%s-query-%s",
				deployName, jobSuffix)
			err = createJob(ctx, c, queryJobName, port, image, "query", token, "SELECT * FROM home")
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, queryJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))
		})
	})

	AfterEach(func() {
		cancel()
	})
})
