package integration

import (
	"context"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	v1 "k8s.io/api/core/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Wavefront:", func() {
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("The collector component", func() {
		var containerLogs, entriesToCheck []string
		var controllerPods v1.PodList
		var containsEntries bool
		var pattern string

		BeforeEach(func() {
			podLabel := "app.kubernetes.io/component=collector"
			containerName := "wavefront-collector"

			entriesToCheck = append(entriesToCheck, "Finished querying.*kstate_source")
			entriesToCheck = append(entriesToCheck, "connected to Wavefront proxy.*wavefront-proxy:"+*proxyPort)
			containsEntries, _ = retry("containerLogsContains", 6, 15*time.Second, func() (bool, error) {
				return containerLogsContains(ctx, coreclient, podLabel, containerName, entriesToCheck)
			})

			controllerPods = getPodsByLabelOrDie(ctx, coreclient, podLabel)
			containerLogs = getContainerLogsOrDie(ctx, coreclient, controllerPods.Items[0].GetName(), containerName)
		})

		It("uses the provided cluster name", func() {
			pattern = "using.*" + *clusterName
			Expect(containsPattern(containerLogs, pattern)).To(BeTrue())
		})
		It("does NOT collect event data", func() {
			Expect(containsString(containerLogs, "Events collection disabled")).To(BeTrue())
		})
		It("has discovery enabled", func() {
			Expect(containsString(containerLogs, "Starting discovery manager")).To(BeTrue())
		})
		It("uses a custom collection interval", func() {
			Expect(containsString(containerLogs, "collection_interval="+*collectionInterval)).To(BeTrue())
		})
		It("collects K8s state data", func() {
			pattern = "Adding.*kstate_metrics_provider"
			Expect(containsPattern(containerLogs, pattern)).To(BeTrue())
			Expect(containsEntries).To(BeTrue())
		})
		It("connects to the proxy", func() {
			Expect(containsEntries).To(BeTrue())
		})
	})
})
