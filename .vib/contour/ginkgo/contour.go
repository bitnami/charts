package integration

import (
	"context"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	v1 "k8s.io/api/core/v1"
	netv1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Contour", func() {
	var netclient netcv1.NetworkingV1Interface
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("Creating example ingress", func() {
		var ingress netv1.Ingress

		BeforeEach(func() {
			var pathType netv1.PathType = "Prefix"

			ingressRuleValue := netv1.IngressRuleValue{
				HTTP: &netv1.HTTPIngressRuleValue{
					Paths: []netv1.HTTPIngressPath{
						{
							Path:     "/",
							PathType: &pathType,
							Backend: netv1.IngressBackend{
								Service: &netv1.IngressServiceBackend{
									Name: "example-service",
									Port: netv1.ServiceBackendPort{
										Number: 80,
									},
								},
							},
						},
					},
				},
			}
			ingress = createIngressOrDie(ctx, netclient, *namespace, "test-ingress", "www.example.com", ingressRuleValue)
		})

		When("the example ingress is created", func() {
			var controllerPods v1.PodList
			var podLogs []string

			BeforeEach(func() {
				controllerPods = getPodsByLabelOrDie(ctx, coreclient, *namespace, "app.kubernetes.io/component=contour")
				podLogs = getPodLogsOrDie(ctx, coreclient, *namespace, controllerPods.Items[0].GetName(), "contour")
			})

			It("is managed by contour", func() {
				Expect(*ingress.Spec.IngressClassName).To(Equal("contour"))
				Expect(containsString(podLogs, ingress.GetName())).To(BeTrue())
			})
		})
		AfterEach(func() {
			netclient.Ingresses(*namespace).Delete(ctx, ingress.GetName(), metav1.DeleteOptions{})
		})
	})
})
