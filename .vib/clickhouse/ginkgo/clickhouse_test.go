package clickhouse_test

import (
	"context"
	"fmt"
	"time"

	utils "github.com/bitnami/charts/.vib/common-tests/ginkgo-utils"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

const (
	PollingInterval = 1 * time.Second
)

var _ = Describe("ClickHouse", Ordered, func() {
	var c *kubernetes.Clientset
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("a database is created and ClickHouse shards are scaled down to 0 replicas and back up", func() {
		It("should have access to the created database", func() {

			getAvailableReplicas := func(ss *appsv1.StatefulSet) int32 { return ss.Status.AvailableReplicas }
			getSucceededJobs := func(j *batchv1.Job) int32 { return j.Status.Succeeded }
			getRestartedAtAnnotation := func(pod *v1.Pod) string { return pod.Annotations["kubectl.kubernetes.io/restartedAt"] }
			getOpts := metav1.GetOptions{}

			image := ""

			for i := 0; i < shards; i++ {
				By(fmt.Sprintf("checking all the shard %d replicas are available", i))
				shardName := fmt.Sprintf("%s-shard%d", releaseName, i)
				ss, err := c.AppsV1().StatefulSets(namespace).Get(ctx, shardName, getOpts)
				Expect(err).NotTo(HaveOccurred())
				Expect(ss.Status.Replicas).NotTo(BeZero())
				image, err = utils.StsGetContainerImageByName(ss, "clickhouse")
				Expect(err).NotTo(HaveOccurred())
				origReplicas := *ss.Spec.Replicas
				Eventually(func() (*appsv1.StatefulSet, error) {
					return c.AppsV1().StatefulSets(namespace).Get(ctx, shardName, getOpts)
				}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))
			}

			svc, err := c.CoreV1().Services(namespace).Get(ctx, releaseName, getOpts)
			Expect(err).NotTo(HaveOccurred())

			port, err := utils.SvcGetPortByName(svc, "tcp-secure")
			Expect(err).NotTo(HaveOccurred())

			// Use current time for allowing the test suite to repeat
			jobSuffix := time.Now().Format("20060102150405")

			By("creating a job to create a new test database")
			createDBJobName := fmt.Sprintf("%s-createdb-%s",
				releaseName, jobSuffix)
			dbName := fmt.Sprintf("test%s", jobSuffix)

			err = createJob(ctx, c, createDBJobName, port, image, fmt.Sprintf("CREATE DATABASE %s ON CLUSTER default ENGINE = Memory;", dbName))
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, createDBJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, createDBJobName, metav1.DeleteOptions{})

			for i := 0; i < shards; i++ {
				shardName := fmt.Sprintf("%s-shard%d", releaseName, i)
				ss, err := c.AppsV1().StatefulSets(namespace).Get(ctx, shardName, getOpts)
				shardOrigReplicas := *ss.Spec.Replicas

				Expect(ss.Status.Replicas).NotTo(BeZero())
				By("rollout restart the statefulset")
				_, err = utils.StsRolloutRestart(ctx, c, ss)
				Expect(err).NotTo(HaveOccurred())

				for i := 0; i < int(shardOrigReplicas); i++ {
					Eventually(func() (*v1.Pod, error) {
						return c.CoreV1().Pods(namespace).Get(ctx, fmt.Sprintf("%s-%d", shardName, i), getOpts)
					}, timeout, PollingInterval).Should(WithTransform(getRestartedAtAnnotation, Not(BeEmpty())))
				}

				Eventually(func() (*appsv1.StatefulSet, error) {
					return c.AppsV1().StatefulSets(namespace).Get(ctx, shardName, getOpts)
				}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(shardOrigReplicas)))
			}

			By("creating a job to drop the test database")
			deleteDBJobName := fmt.Sprintf("%s-deletedb-%s",
				releaseName, jobSuffix)
			err = createJob(ctx, c, deleteDBJobName, port, image, fmt.Sprintf("DROP DATABASE %s;", dbName))
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, deleteDBJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))
			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, deleteDBJobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())
		})
	})

	AfterEach(func() {
		cancel()
	})
})
