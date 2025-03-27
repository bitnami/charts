package rabbitmq_test

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

var _ = Describe("Rabbitmq", Ordered, func() {
	var c *kubernetes.Clientset
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("a queue is created and Rabbitmq is scaled down to 0 replicas and back up", func() {
		It("should have access to the created queue", func() {

			getAvailableReplicas := func(ss *appsv1.StatefulSet) int32 { return ss.Status.AvailableReplicas }
			getSucceededJobs := func(j *batchv1.Job) int32 { return j.Status.Succeeded }
			getRestartedAtAnnotation := func(pod *v1.Pod) string { return pod.Annotations["kubectl.kubernetes.io/restartedAt"] }
			getOpts := metav1.GetOptions{}
			By("checking all the replicas are available")
			ss, err := c.AppsV1().StatefulSets(namespace).Get(ctx, stsName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			Expect(ss.Status.Replicas).NotTo(BeZero())
			origReplicas := *ss.Spec.Replicas

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, stsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			svc, err := c.CoreV1().Services(namespace).Get(ctx, stsName, getOpts)
			Expect(err).NotTo(HaveOccurred())

			port, err := utils.SvcGetPortByName(svc, "http-stats")
			Expect(err).NotTo(HaveOccurred())

			image, err := utils.StsGetContainerImageByName(ss, "rabbitmq")
			Expect(err).NotTo(HaveOccurred())

			// Use current time for allowing the test suite to repeat
			jobSuffix := time.Now().Format("20060102150405")

			By("creating a job to create a new test queue")
			createQueueJobName := fmt.Sprintf("%s-createq-%s",
				stsName, jobSuffix)
			queueName := fmt.Sprintf("test%s", jobSuffix)

			err = createJob(ctx, c, createQueueJobName, port, image,
				fmt.Sprintf("curl -X PUT -u \"$RABBITMQ_USERNAME:$RABBITMQ_PASSWORD\" -d '{\"durable\": true}' http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/queues/%%2f/%s", queueName))
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, createQueueJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, createQueueJobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())

			By("rollout restart the statefulset")
			_, err = utils.StsRolloutRestart(ctx, c, ss)
			Expect(err).NotTo(HaveOccurred())

			for i := 0; i < int(origReplicas); i++ {
				Eventually(func() (*v1.Pod, error) {
					return c.CoreV1().Pods(namespace).Get(ctx, fmt.Sprintf("%s-%d", stsName, i), getOpts)
				}, timeout, PollingInterval).Should(WithTransform(getRestartedAtAnnotation, Not(BeEmpty())))
			}

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, stsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			By("creating a job to drop the test queue")
			deleteQueueJobName := fmt.Sprintf("%s-deleteq-%s",
				stsName, jobSuffix)
			err = createJob(ctx, c, deleteQueueJobName, port, image,
				fmt.Sprintf("curl -I -X DELETE -u \"$RABBITMQ_USERNAME:$RABBITMQ_PASSWORD\" http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/queues/%%2f/%s | grep 204", queueName))
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, deleteQueueJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, deleteQueueJobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())
		})
	})

	AfterEach(func() {
		cancel()
	})
})
