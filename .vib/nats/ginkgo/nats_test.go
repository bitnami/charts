package nats_test

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

var _ = Describe("NATS", Ordered, func() {
	var c *kubernetes.Clientset
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("a bucket is created and is scaled down to 0 replicas and back up", func() {
		It("should have access to NATS", func() {
			getAvailableReplicas := func(ss *appsv1.StatefulSet) int32 { return ss.Status.AvailableReplicas }
			getRestartedAtAnnotation := func(pod *v1.Pod) string { return pod.Annotations["kubectl.kubernetes.io/restartedAt"] }
			getSucceededJobs := func(j *batchv1.Job) int32 { return j.Status.Succeeded }
			getOpts := metav1.GetOptions{}

			By("checking all the replicas are available")
			ss, err := c.AppsV1().StatefulSets(namespace).Get(ctx, releaseName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			Expect(ss.Status.Replicas).NotTo(BeZero())
			origReplicas := *ss.Spec.Replicas

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, releaseName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			svc, err := c.CoreV1().Services(namespace).Get(ctx, releaseName, getOpts)
			Expect(err).NotTo(HaveOccurred())

			port, err := utils.SvcGetPortByName(svc, "tcp-client")
			Expect(err).NotTo(HaveOccurred())

			// Use current time for allowing the test suite to repeat
			jobSuffix := time.Now().Format("20060102150405")

			By("creating a job to create a new KV Store Bucket")
			addKVBucketJobName := fmt.Sprintf("%s-add-kv-bucket-%s",
				releaseName, jobSuffix)
			storeBucketName := fmt.Sprintf("test%s", jobSuffix)

			err = createJob(ctx, c, addKVBucketJobName, port, "add", storeBucketName)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, addKVBucketJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, addKVBucketJobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())

			By("creating a job to put some key-value pair")
			putKVJobName := fmt.Sprintf("%s-put-kv-%s",
				releaseName, jobSuffix)
			err = createJob(ctx, c, putKVJobName, port, "put", storeBucketName, "testKey", "testValue")
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, putKVJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, putKVJobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())

			// Give the application some time to sync the data
			time.Sleep(10 * time.Second)

			By("rollout restart the statefulset")
			_, err = utils.StsRolloutRestart(ctx, c, ss)
			Expect(err).NotTo(HaveOccurred())

			for i := int(origReplicas) - 1; i >= 0; i-- {
				Eventually(func() (*v1.Pod, error) {
					return c.CoreV1().Pods(namespace).Get(ctx, fmt.Sprintf("%s-%d", releaseName, i), getOpts)
				}, timeout, PollingInterval).Should(WithTransform(getRestartedAtAnnotation, Not(BeEmpty())))
			}

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, releaseName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			By("creating a job to get a value for a key")
			getKVJobName := fmt.Sprintf("%s-get-key-%s",
				releaseName, jobSuffix)
			err = createJob(ctx, c, getKVJobName, port, "get", storeBucketName, "testKey")
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, getKVJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, getKVJobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())

			By("creating a job to get the delete the KV Store Bucket")
			deleteKVBucketJobName := fmt.Sprintf("%s-del-kv-bucket-%s",
				releaseName, jobSuffix)
			err = createJob(ctx, c, deleteKVBucketJobName, port, "del", storeBucketName, "-f")
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, deleteKVBucketJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, deleteKVBucketJobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())
		})
	})

	AfterEach(func() {
		cancel()
	})
})
