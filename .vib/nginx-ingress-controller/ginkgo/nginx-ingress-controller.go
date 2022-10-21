package integration

import (
	"context"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	v1 "k8s.io/api/core/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("NGINX Ingress Controller", func() {
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("Testing ingress", func() {
		var controllerPods v1.PodList
		var containerLogs []string

		BeforeEach(func() {
			controllerPods = getPodsByLabelOrDie(ctx, coreclient, *namespace, "app.kubernetes.io/component=controller")
			containerLogs = getContainerLogsOrDie(ctx, coreclient, *namespace, controllerPods.Items[0].GetName(), "controller")
		})

		It("is managed by nginx-ingress-controller", func() {
			var toCheck = "Found valid IngressClass\" ingress=\"default/" + *ingressName
			Expect(containsString(containerLogs, toCheck)).To(BeTrue())
		})
	})
})
