package chainloop_test

import (
	"context"
	"fmt"
	"time"

	utils "github.com/bitnami/charts/.vib/common-tests/ginkgo-utils"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

const (
	PollingInterval = 1 * time.Second
)

// portDefinition is a struct to define a port in a service
type portDefinition struct {
	name   string
	number string
}

var _ = Describe("Chainloop", Ordered, func() {
	var c *kubernetes.Clientset
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("Chainloop chart is fully deployed", func() {
		It("cas deployment is running", func() {
			getReadyReplicas := func(ss *appsv1.Deployment) int32 { return ss.Status.ReadyReplicas }
			getOpts := metav1.GetOptions{}

			By("checking all the replicas are available")
			stsName := fmt.Sprintf("%s-cas", releaseName)
			dpl, err := c.AppsV1().Deployments(namespace).Get(ctx, stsName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			Expect(dpl.Status.Replicas).NotTo(BeZero())
			origReplicas := *dpl.Spec.Replicas

			Eventually(func() (*appsv1.Deployment, error) {
				return c.AppsV1().Deployments(namespace).Get(ctx, stsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getReadyReplicas, Equal(origReplicas)))

			By("checking all the services are available")
			svcs := []struct {
				name  string
				ports []portDefinition
			}{
				{
					name: "cas",
					ports: []portDefinition{
						{
							name:   "http",
							number: "80",
						},
					},
				},
				{
					name: "cas-api",
					ports: []portDefinition{
						{
							name:   "grpc",
							number: "80",
						},
					},
				},
			}

			for _, inSvc := range svcs {
				svcName := fmt.Sprintf("%v-%v", releaseName, inSvc.name)
				svc, err := c.CoreV1().Services(namespace).Get(ctx, svcName, metav1.GetOptions{})
				Expect(err).NotTo(HaveOccurred())

				for _, port := range inSvc.ports {
					outPort, err := utils.SvcGetPortByName(svc, port.name)
					Expect(err).NotTo(HaveOccurred())
					Expect(outPort).NotTo(BeNil())
					Expect(outPort).To(Equal(port.number))
				}
			}

			By("checking main container image is running")
			_, err = utils.DplGetContainerImage(dpl, "cas")
			Expect(err).NotTo(HaveOccurred())
		})

		It("controlplane deployment is running", func() {
			getReadyReplicas := func(ss *appsv1.Deployment) int32 { return ss.Status.ReadyReplicas }
			getOpts := metav1.GetOptions{}

			By("checking all the replicas are available")
			stsName := fmt.Sprintf("%s-controlplane", releaseName)
			dpl, err := c.AppsV1().Deployments(namespace).Get(ctx, stsName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			Expect(dpl.Status.Replicas).NotTo(BeZero())
			origReplicas := *dpl.Spec.Replicas

			Eventually(func() (*appsv1.Deployment, error) {
				return c.AppsV1().Deployments(namespace).Get(ctx, stsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getReadyReplicas, Equal(origReplicas)))

			By("checking all the services are available")
			svcs := []struct {
				name  string
				ports []portDefinition
			}{
				{
					name: "controlplane",
					ports: []portDefinition{
						{
							name:   "http",
							number: "80",
						},
					},
				},
				{
					name: "controlplane-api",
					ports: []portDefinition{
						{
							name:   "grpc",
							number: "80",
						},
					},
				},
			}

			for _, inSvc := range svcs {
				svcName := fmt.Sprintf("%v-%v", releaseName, inSvc.name)
				svc, err := c.CoreV1().Services(namespace).Get(ctx, svcName, metav1.GetOptions{})
				Expect(err).NotTo(HaveOccurred())

				for _, port := range inSvc.ports {
					outPort, err := utils.SvcGetPortByName(svc, port.name)
					Expect(err).NotTo(HaveOccurred())
					Expect(outPort).NotTo(BeNil())
					Expect(outPort).To(Equal(port.number))
				}
			}

			By("checking main container image is running")
			_, err = utils.DplGetContainerImage(dpl, "controlplane")
			Expect(err).NotTo(HaveOccurred())
		})
	})

	AfterEach(func() {
		cancel()
	})
})
