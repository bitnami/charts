package integration

import (
	"context"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	corev1 "k8s.io/client-go/kubernetes/typed/core/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Wavefront HPA Adapter", func() {
	var c corev1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		c = corev1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("is correctly configured to", func() {
		var containerLogs []string

		BeforeEach(func() {
			containerLogs = getAdapterLogsOrDie(ctx, c)
		})
		It("point to the correct Wavefront endpoint", func() {
			Expect(containsString(containerLogs, *wavefrontURL)).To(BeTrue())
		})
		It("serve in the correct port", func() {
			pattern := "Serving securely.*" + *servingPort
			Expect(containsPattern(containerLogs, pattern)).To(BeTrue())
		})
	})

	Context("recognizes HPA-defined", func() {
		It("external metrics", func() {
			// A HPA defining external metrics can take up some time to be listed when the adapter is first deployed (2 min = 12*10 sec.)
			receivedMetric, _ := retry("receivedExternalMetric", 12, 10*time.Second, func() (bool, error) { return receivedExternalMetric(ctx, c) })
			Expect(receivedMetric).To(BeTrue())
		})
	})

})
