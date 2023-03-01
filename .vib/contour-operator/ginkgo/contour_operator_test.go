package integration

import (
	"context"
	"fmt"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/dynamic"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Contour Operator:", func() {
	var netclient netcv1.NetworkingV1Interface
	var coreclient cv1.CoreV1Interface
	var dynamicClient dynamic.Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		dynamicClient = dynamic.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("When both operator and testing resources are deployed", func() {
		var ingressHost string
		var envoySvc *v1.Service
		var hasIP, isReady bool
		var err error

		const contourName = "contour-crd-vib"
		const ingressName = "contour-ing-vib"

		BeforeAll(func() {
			// The tests evaluate the Operator by deploying both Contour and Ingress resources.
			// Their creation takes some time, so they will be deployed once and reused across the different checks.
			createContourResourceOrDie(ctx, dynamicClient, contourName)

			isReady, err = retry("isContourReady", 10, 30*time.Second, func() (bool, error) {
				return isContourReady(ctx, dynamicClient, contourName)
			})
			Expect(isReady).To(BeTrue())

			hasIP, err = retry("isServiceReady", 10, 30*time.Second, func() (bool, error) {
				return isServiceReady(ctx, coreclient, "envoy")
			})
			if err != nil {
				panic(fmt.Sprintf("There was an error checking whether the testing Envoy service had an IP assigned: %q", err))
			}
			Expect(hasIP).To(BeTrue())

			envoySvc, err = coreclient.Services(*namespace).Get(ctx, "envoy", metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the Envoy service created by contour: %q", err))
			}

			// AWS based clusters will use a host instead of an IP for the svc address
			ingressHost = returnValidHost(envoySvc.Status.LoadBalancer.Ingress[0])
			createIngressOrDie(ctx, netclient, ingressName, ingressHost)
			// Once created, the operator has to assign an IP to the managed ingress
			hasIP, err = retry("isIngressReady", 10, 30*time.Second, func() (bool, error) {
				return isIngressReady(ctx, netclient, ingressName)
			})
			if err != nil {
				panic(fmt.Sprintf("There was an error checking whether the testing ingress had a host assigned: %q", err))
			}
			Expect(hasIP).To(BeTrue())
		})

		It("the operator manages the contour resource", func() {
			controllerPods := getPodsByLabelOrDie(ctx, coreclient, "app.kubernetes.io/component=contour-operator")
			containerLogs := getContainerLogsOrDie(ctx, coreclient, controllerPods.Items[0].GetName(), "contour-operator")

			Expect(containsString(containerLogs, contourName)).To(BeTrue())
		})
		It("the ingress' asigned IP is the same as the one used by the envoy service", func() {
			testingIngress, err := netclient.Ingresses(*namespace).Get(ctx, ingressName, metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the %q Ingress resource: %q", ingressName, err))
			}
			Expect(returnValidHost(testingIngress.Status.LoadBalancer.Ingress[0])).To(Equal(returnValidHost(envoySvc.Status.LoadBalancer.Ingress[0])))

		})
		AfterAll(func() {
			// No need to panic here if failed, the cluster is expected to clean up with the undeployment
			dynamicClient.Resource(contourType).Namespace(*namespace).Delete(ctx, contourName, metav1.DeleteOptions{})
			netclient.Ingresses(*namespace).Delete(ctx, ingressName, metav1.DeleteOptions{})
		})
	})
})
