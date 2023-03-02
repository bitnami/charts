package integration

import (
	"context"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Wavefront Prometheus Adapter:", func() {
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	It("The adapter connects to the proxy", func() {
		var entriesToCheck []string

		entriesToCheck = append(entriesToCheck, "connected to Wavefront proxy.*wavefront-prometheus-storage-adapter-proxy:"+*proxyPort)
		podLabel := "app.kubernetes.io/component=wavefront-prometheus-storage-adapter"
		containerName := "wavefront-prometheus-storage-adapter"

		containsEntries, _ := retry("containerLogsContains", 6, 5*time.Second, func() (bool, error) {
			return containerLogsContains(ctx, coreclient, podLabel, containerName, entriesToCheck)
		})
		Expect(containsEntries).To(BeTrue())
	})
})
