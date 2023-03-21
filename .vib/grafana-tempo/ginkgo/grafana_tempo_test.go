package integration

import (
	"context"
	"fmt"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Grafana Tempo", func() {
	var c cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		c = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("through its API", func() {
		var frontendHost, serviceName string

		BeforeEach(func() {
			serviceName = "grafana-tempo-query-frontend"

			isReady, err := retry("isServiceReady", 6, 20*time.Second, func() (bool, error) {
				return isServiceReady(ctx, c, serviceName)
			})
			if err != nil {
				panic(fmt.Sprintf("There was an error checking whether the testing service had an IP assigned: %q", err))
			}
			Expect(isReady).To(BeTrue())

			frontendSvc, err := c.Services(*namespace).Get(ctx, serviceName, metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the Query Frontend service: %q", err))
			}

			frontendHost = returnValidHost(frontendSvc.Status.LoadBalancer.Ingress[0])
		})

		It("allows to access registered tracing spans", func() {
			// Obtain a sample traceID and route gerenerated by the synthetic app
			var traceID, route string
			lgPods := getPodsByLabelOrDie(ctx, c, "app=vib-synthetic-load-generator")
			containerLogs := getContainerLogsOrDie(ctx, c, lgPods.Items[0].GetName(), "synthetic-load-generator")

			traceID = findFirstPattern(containerLogs, "traceId ([a-z0-9]+)", 1)
			Expect(traceID).NotTo(BeEmpty())

			route = findFirstPattern(containerLogs, `route (\/\w+)`, 1)
			Expect(route).NotTo(BeEmpty())

			responseBody := getResponseBodyOrDie(ctx, fmt.Sprintf("http://%s:%s/api/traces/%s", frontendHost, *apiPort, traceID))
			Expect(containsString(responseBody, route)).To(BeTrue())
		})
	})
})
