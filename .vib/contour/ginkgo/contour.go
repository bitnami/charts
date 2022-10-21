package integration

import (
	"context"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	netv1 "k8s.io/api/networking/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Contour", func() {
	var netclient netcv1.NetworkingV1Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("Testing ingress", func() {
		var ingresses netv1.IngressList

		BeforeEach(func() {
			ingresses = getIngressesByLabelOrDie(ctx, netclient, *namespace, "app=kuard")
		})

		It("is managed by contour", func() {
			Expect(*ingresses.Items[0].Spec.IngressClassName).To(Equal("contour"))
		})
	})
})
