package integration

import (
	"context"
	"fmt"

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

var _ = Describe("Contour Operator:", func() {
	var netclient netcv1.NetworkingV1Interface
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("When both operator and testing resources are deployed", func() {
		var containerLogs, responseBody []string
		var controllerPods v1.PodList
		var ingress *netv1.Ingress
		var err error

		BeforeEach(func() {
			controllerPods = getPodsByLabelOrDie(ctx, coreclient, *namespace, "app.kubernetes.io/component=contour-operator")
			containerLogs = getContainerLogsOrDie(ctx, coreclient, *namespace, controllerPods.Items[0].GetName(), "contour-operator")

			ingress, err = netclient.Ingresses(*namespace).Get(ctx, *ingressName, metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the %q Ingress resource: %q", *ingressName, err))
			}
			responseBody = getResponseBodyOrDie(ctx, "http://"+ingress.Status.LoadBalancer.Ingress[0].IP)
		})

		It("the operator manages the contour resource", func() {
			Expect(containsString(containerLogs, *contourName)).To(BeTrue())
		})
		It("the ingress' asigned IP resolves to the testing deployment", func() {
			Expect(containsString(responseBody, "kuard")).To(BeTrue())
		})
	})
})
