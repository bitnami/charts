package influxdb_test

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

var _ = Describe("Influxdb", Ordered, func() {
	var c *kubernetes.Clientset
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("time series data is written and Influxdb is scaled down to 0 replicas and back up", func() {
		It("should have access to query the written data", func() {
			getAvailableReplicas := func(ss *appsv1.Deployment) int32 { return ss.Status.AvailableReplicas }
			getSucceededJobs := func(j *batchv1.Job) int32 { return j.Status.Succeeded }
			getOpts := metav1.GetOptions{}

			By("checking all the replicas are available")
			ss, err := c.AppsV1().Deployments(namespace).Get(ctx, deployName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			Expect(ss.Status.Replicas).NotTo(BeZero())
			origReplicas := *ss.Spec.Replicas

			Eventually(func() (*appsv1.Deployment, error) {
				return c.AppsV1().Deployments(namespace).Get(ctx, deployName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			svc, err := c.CoreV1().Services(namespace).Get(ctx, deployName, getOpts)
			Expect(err).NotTo(HaveOccurred())

			port, err := utils.SvcGetPortByName(svc, "http")
			Expect(err).NotTo(HaveOccurred())

			image, err := utils.DplGetContainerImage(ss, "influxdb")
			Expect(err).NotTo(HaveOccurred())

			// Use current time for allowing the test suite to repeat
			jobSuffix := time.Now().Format("20060102150405")

			By("creating a job to write data")
			createDBJobName := fmt.Sprintf("%s-write-%s",
				deployName, jobSuffix)

			err = createJob(ctx, c, createDBJobName, port, image, "write", `home,room=Living\ Room temp=21.1,hum=35.9,co=0i 1747036800`)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, createDBJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("scaling down to 0 replicas")
			ss, err = utils.DplScale(ctx, c, ss, 0)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.Deployment, error) {
				return c.AppsV1().Deployments(namespace).Get(ctx, deployName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, BeZero()))

			By("scaling up to the original replicas")
			ss, err = utils.DplScale(ctx, c, ss, origReplicas)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.Deployment, error) {
				return c.AppsV1().Deployments(namespace).Get(ctx, deployName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(origReplicas)))

			By("creating a job to query the data")
			queryJobName := fmt.Sprintf("%s-query-%s",
				deployName, jobSuffix)
			err = createJob(ctx, c, queryJobName, port, image, "query", "SELECT * FROM home")
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
