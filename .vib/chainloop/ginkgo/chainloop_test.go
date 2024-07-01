package chainloop_test

import (
	"context"
	"fmt"
	"time"

	utils "github.com/bitnami/charts/.vib/common-tests/ginkgo-utils"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

const (
	PollingInterval = 1 * time.Second
)

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
		It("all services exposes expected ports", func() {
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
				{
					name: "postgresql",
					ports: []portDefinition{
						{
							name:   "tcp-postgresql",
							number: "5432",
						},
					},
				},
				{
					name: "vault-server",
					ports: []portDefinition{
						{
							name:   "http",
							number: "8200",
						}, {
							name:   "https-internal",
							number: "8201",
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
		})

		It("all pods are running", func() {
			pods, err := c.CoreV1().Pods(namespace).List(ctx, metav1.ListOptions{})
			Expect(err).NotTo(HaveOccurred())

			for _, pod := range pods.Items {
				_, err := utils.IsPodRunning(ctx, c.CoreV1(), namespace, pod.Name)
				Expect(err).NotTo(HaveOccurred())
			}
		})
	})

	AfterEach(func() {
		cancel()
	})
})
