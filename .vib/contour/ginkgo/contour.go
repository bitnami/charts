package integration

import (
	"context"
	"fmt"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	netv1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Contour:", func() {
	var netclient netcv1.NetworkingV1Interface
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("The testing ingress", func() {
		var testingIngress *netv1.Ingress
		var err error

		BeforeEach(func() {
			testingIngress, err = netclient.Ingresses(*namespace).Get(ctx, *ingressName, metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the %q Ingress resource: %q", *ingressName, err))
			}
		})

		It("asigned IP is the same as the one used by the envoy service", func() {
			envoySvc, err := coreclient.Services(*namespace).Get(ctx, "contour-envoy", metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the envoy service: %q", err))
			}

			Expect(testingIngress.Status.LoadBalancer.Ingress[0].IP).To(Equal(envoySvc.Status.LoadBalancer.Ingress[0].IP))
		})
		It("asigned IP resolves to the testing deployment", func() {
			responseBody := getResponseBodyOrDie(ctx, "http://"+testingIngress.Status.LoadBalancer.Ingress[0].IP)

			Expect(containsString(responseBody, "kuard")).To(BeTrue())
		})
	})
})
