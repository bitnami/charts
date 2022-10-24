package integration

import (
	"context"
	"fmt"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	netv1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Contour:", func() {
	var netclient netcv1.NetworkingV1Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("Testing ingress", func() {
		var ingress *netv1.Ingress
		var err error

		BeforeEach(func() {
			ingress, err = netclient.Ingresses(*namespace).Get(ctx, *ingressName, metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the %q Ingress resource: %q", *ingressName, err))
			}
		})

		It("is managed by contour", func() {
			Expect(*ingress.Spec.IngressClassName).To(Equal("contour"))
		})
	})
})
