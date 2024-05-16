// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"context"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Kubernetes Event Exporter:", func() {
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	When("a testing pod is created", func() {
		var resourceName string
		var createdPod *v1.Pod

		BeforeEach(func() {
			resourceName = "nginx-" + *namespace
			createdPod = createPodOrDie(ctx, coreclient, resourceName, "bitnami/nginx")
		})

		AfterEach(func() {
			// Not need to panic here if failed, the cluster is expected to clean up with the undeployment
			coreclient.Pods(*namespace).Delete(ctx, createdPod.GetName(), metav1.DeleteOptions{})
		})

		Describe("the exporter logs", func() {
			It("shows its kubernetes events", func() {
				pattern := "event=.*Created container nginx-" + *namespace + ".*sink=.*dump"
				podLabel := "app.kubernetes.io/name=kubernetes-event-exporter"
				containerName := "event-exporter"

				containsPattern, _ := retry("containerLogsContainPattern", 12, 5*time.Second, func() (bool, error) {
					return containerLogsContainPattern(ctx, coreclient, podLabel, containerName, pattern)
				})
				Expect(containsPattern).To(BeTrue())
			})
		})
	})
})
