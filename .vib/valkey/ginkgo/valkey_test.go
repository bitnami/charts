package valkey_test

import (
	"context"
	"fmt"
	"time"

	utils "github.com/bitnami/charts/.vib/common-tests/ginkgo-utils"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

const (
	PollingInterval = 1 * time.Second
)

var _ = Describe("Valkey", Ordered, func() {
	var c *kubernetes.Clientset
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("a key-value is created and Valkey is scaled down to 0 replicas and back up", func() {
		It("should have access to the created key-value", func() {

			getAvailableReplicas := func(ss *appsv1.StatefulSet) int32 { return ss.Status.AvailableReplicas }
			getSucceededJobs := func(j *batchv1.Job) int32 { return j.Status.Succeeded }
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

			port, err := utils.SvcGetPortByName(svc, "tcp-redis")
			Expect(err).NotTo(HaveOccurred())

			image, err := utils.StsGetContainerImageByName(ss, "valkey")
			Expect(err).NotTo(HaveOccurred())

			jobSuffix := time.Now().Format("20060102150405")

			By("creating a job to create a new test key-value")
			createKEYJobName := fmt.Sprintf("%s-createkey-%s",
				stsName, jobSuffix)
			keyName := fmt.Sprintf("test%s", jobSuffix)
			keyValue := fmt.Sprintf("v%s", jobSuffix)

			err = createJob(ctx, c, createKEYJobName, port, image, fmt.Sprintf("SET %s %s", keyName, keyValue))
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, createKEYJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("scaling down to 0 replicas")
			ss, err = utils.StsScale(ctx, c, ss, 0)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, stsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, BeZero()))

			By("scaling up to the original replicas")
			ss, err = utils.StsScale(ctx, c, ss, origReplicas)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, stsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			By("creating a job to drop the test key-value")
			deleteKeyJobName := fmt.Sprintf("%s-deletekey-%s",
				stsName, jobSuffix)
			err = createJob(ctx, c, deleteKeyJobName, port, image, fmt.Sprintf("DEL %s", keyName))
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, deleteKeyJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))
		})
	})

	AfterEach(func() {
		cancel()
	})
})
