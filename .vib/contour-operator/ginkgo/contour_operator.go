package integration

import (
	"context"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	v1 "k8s.io/api/core/v1"
	netv1 "k8s.io/api/networking/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Contour Operator", func() {
	var netclient netcv1.NetworkingV1Interface
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("resources data", func() {
		var podLogs, responseBody []string
		var controllerPods v1.PodList
		var ingresses netv1.IngressList

		BeforeEach(func() {
			controllerPods = getPodsByLabelOrDie(ctx, coreclient, *namespace, "app.kubernetes.io/component=contour-operator")
			podLogs = getPodLogsOrDie(ctx, coreclient, *namespace, controllerPods.Items[0].GetName(), "contour-operator")

			ingresses = getIngressesByLabelOrDie(ctx, netclient, *namespace, "app=kuard")
			responseBody = getResponseBodyOrDie(ctx, "http://"+ingresses.Items[0].Status.LoadBalancer.Ingress[0].IP)
		})

		It("checks the operator manages the contour resource", func() {
			Expect(containsString(podLogs, *contourName)).To(BeTrue())
		})
		It("the ingress' asigned IP resolves to the testing deployment", func() {
			Expect(containsString(responseBody, "kuard")).To(BeTrue())
		})
	})
})
