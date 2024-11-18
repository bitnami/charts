package cilium_test

import (
	"context"
	"fmt"
	"time"

	utils "github.com/bitnami/charts/.vib/common-tests/ginkgo-utils"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	batchv1 "k8s.io/api/batch/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/kubernetes"
)

const (
	PollingInterval = 1 * time.Second
)

var _ = Describe("Cilium", Ordered, func() {
	var c *kubernetes.Clientset
	var dC dynamic.Interface
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
		dC = dynamic.NewForConfigOrDie(conf)
	})

	When("a CiliumNetworkPolicy is created", func() {
		AfterEach(func() {
			cancel()
		})

		It("should restrict the traffic", func() {
			getSucceededJobs := func(j *batchv1.Job) int32 { return j.Status.Succeeded }
			getFailedJobs := func(j *batchv1.Job) int32 { return j.Status.Failed }
			getOpts := metav1.GetOptions{}

			By("checking Cilium Agent is available")
			agentDsName := fmt.Sprintf("%s-agent", releaseName)
			agentDs, err := c.AppsV1().DaemonSets(namespace).Get(ctx, agentDsName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			fsGroup := agentDs.Spec.Template.Spec.SecurityContext.FSGroup
			runAsUser := agentDs.Spec.Template.Spec.Containers[0].SecurityContext.RunAsUser
			Expect(err).NotTo(HaveOccurred())

			By("creating a deployment and a service to expose a mock API")
			err = createAPIMockDeploy(ctx, c, fsGroup, runAsUser)
			Expect(err).NotTo(HaveOccurred())
			err = createAPIMockService(ctx, c)
			Expect(err).NotTo(HaveOccurred())

			By("creating a CiliumNetworkPolicy to restrict the traffic")
			err = createAPIMockCiliumNetworkPolicy(ctx, dC)
			Expect(err).NotTo(HaveOccurred())

			By("creating a job to access the mock API with required labels")
			jobName := "api-client-labelled"
			err = createAPIMockClientJob(ctx, c, jobName, fsGroup, runAsUser, map[string]string{"api-mock-client": "true"})
			Expect(err).NotTo(HaveOccurred())

			By("waiting for the job to succeed")
			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, jobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("deleting the job once it has succeeded")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, jobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())

			By("creating a 2nd job to access the mock API without required labels")
			jobName = "api-client-no-labels"
			err = createAPIMockClientJob(ctx, c, jobName, fsGroup, runAsUser, map[string]string{})
			Expect(err).NotTo(HaveOccurred())

			By("waiting for the job to fail")
			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, jobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getFailedJobs, Equal(int32(1))))

			By("deleting the job once it has failed")
			err = c.BatchV1().Jobs(namespace).Delete(ctx, jobName, metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())

			By("deleting the CiliumNetworkPolicy")
			dC.Resource(ciliumNetworkPolicyType).Namespace(namespace).Delete(ctx, "api-mock", metav1.DeleteOptions{})

			By("deleting the mock API deployment and services")
			err = c.CoreV1().Services(namespace).Delete(ctx, "api-mock", metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())
			err = c.AppsV1().Deployments(namespace).Delete(ctx, "api-mock", metav1.DeleteOptions{})
			Expect(err).NotTo(HaveOccurred())
		})
	})
})
