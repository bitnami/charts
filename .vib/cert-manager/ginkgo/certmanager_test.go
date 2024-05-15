// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"context"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/dynamic"
	corev1 "k8s.io/client-go/kubernetes/typed/core/v1"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("CertManager", func() {
	var typedClient corev1.CoreV1Interface
	var dynamicClient dynamic.Interface
	var ctx context.Context

	BeforeEach(func() {
		typedClient = corev1.NewForConfigOrDie(clusterConfigOrDie())
		dynamicClient = dynamic.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("configured with a namespaced Issuer (CRD)", func() {
		var issuer = "vib-test-issuer"

		BeforeEach(func() {
			createIssuerResourceOrDie(ctx, dynamicClient, issuer)
		})
		AfterEach(func() {
			// Not need to panic here if failed, the cluster is expected to clean up with the undeployment
			dynamicClient.Resource(issuerType).Namespace(*namespace).Delete(ctx, issuer, metav1.DeleteOptions{})
		})

		When("a Certificate (CRD) is created", func() {
			var isReady bool
			var certificateConfig = CertificateConfig{
				name:       "vib-test-cert",
				issuer:     issuer,
				secretName: "vib-test-tls-secret",
			}

			BeforeEach(func() {
				createCertificateResourceOrDie(ctx, dynamicClient, &certificateConfig)
				// The Certificate resource takes some time to be ready. Wait (5*1) seconds.
				isReady, _ = retry("isCertificateReady", 5, 1*time.Second, func() (bool, error) { return isCertificateReady(ctx, dynamicClient, certificateConfig.name) })
			})
			AfterEach(func() {
				// Not need to panic here if failed, the cluster is expected to clean up with the undeployment
				dynamicClient.Resource(certificateType).Namespace(*namespace).Delete(ctx, certificateConfig.name, metav1.DeleteOptions{})
				typedClient.Secrets(*namespace).Delete(ctx, certificateConfig.secretName, metav1.DeleteOptions{})
			})

			It("should be marked as Ready", func() {
				Expect(isReady).To(BeTrue())
			})
			It("should have created a Secret with the generated certificates", func() {
				var expectedData []string = []string{"ca.crt", "tls.crt", "tls.key"}

				secret, err := typedClient.Secrets(*namespace).Get(ctx, certificateConfig.secretName, metav1.GetOptions{})
				Expect(err).ShouldNot(HaveOccurred())

				isSecretOk := containsAllKeys(secret.Data, expectedData)
				Expect(isSecretOk).To(BeTrue())
			})
		})

	})

})
