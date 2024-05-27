// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"context"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/client-go/dynamic"
	corev1 "k8s.io/client-go/kubernetes/typed/core/v1"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("SealedSecrets", func() {
	var typedClient corev1.CoreV1Interface
	var dynamicClient dynamic.Interface
	var ctx context.Context

	BeforeEach(func() {
		typedClient = corev1.NewForConfigOrDie(clusterConfigOrDie())
		dynamicClient = dynamic.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	When("a SealedSecret resource is created", func() {
		const sealedSecretResourceName = "vib-test-sealed-secret"
		unencryptedDataPayload := map[string]string{"foo": "bar"}
		encryptedDataPayload := &unstructured.Unstructured{
			Object: map[string]interface{}{
				"foo": "AgDXiCI/lySV5EpoffWJPrkdN7056rdkNl8UC7Jx2uBxRXdb2VliT/3HHyWfcJeFT9SlLBfuayYd6o7CD97lrr3biG6sqf7aYvZU1hvzn8D3Hsi1hSHFnUKz562dre4I57vzHFIlPqbivbSBpHg7lcMnuy1JqXwzyi/CGb+ApS53CVHT+3CcW/zW5orcUpblOBXGoXCfZOqkDqEoVBNyWHM9ZGFACJKP4ivpumyzvvAUb5hSfQEfSLzzyc08E2l8AHipjxmzOI+javMT6k1F1ctfBUICx3Ic1lUrhgzZ9qOfpx2+tcicikYz2zHpwPFVLbg67m+YBQei9mLAm/F8nN7GvBKVfNqo+tg6XJkABIY9elitUxaUA/4MfUFlDKV7e3vjJuyy7zvMT/Ywh3gA4xsFJS04aBJu8TW9Z2rgE1bnlKs8larjGzBCO5eXIFIUEgquG3OiCbZdPj0o4/v4/WC1PBOq3pqwRJylAZqIFru7W9vSb1oeekGtTgKCfzTI6qbpph5F6Xc0nVdexLWlrxEMSum+Apb2vNrfzW9j5vn46C7v1tEtwcZmVE+y/T8U04/IRt0aLfYzIxa0yICnx+bbP+Xwiu+3UQw3/RPcDwwOgCIp9XPc5D9ZRKTfJGW360drwoqT+ui89YpjXN2QPp1SlYj4QsEYjAlpnQsviDPgjdly6Qg9I5yIXXSbxiHAvIM8jxo=",
			},
		}

		BeforeEach(func() {
			createSealedSecretResourceOrDie(ctx, dynamicClient, sealedSecretResourceName, encryptedDataPayload)

			// The unsealed Secret may take some time to be created. Wait (5*1) seconds.
			isAvailable, _ := retry("isSecretAvailable", 5, 1*time.Second, func() (bool, error) { return isSecretAvailable(ctx, typedClient, sealedSecretResourceName) })
			Expect(isAvailable).To(BeTrue())
		})
		AfterEach(func() {
			// Not need to panic here if failed, the cluster is expected to clean up with the undeployment
			dynamicClient.Resource(sealedSecretType).Namespace(*namespace).Delete(ctx, sealedSecretResourceName, metav1.DeleteOptions{})
		})

		It("should have unsealed the secret correctly", func() {
			// The unsealed secret should have the same name as the SealedSecret resource
			secret, err := typedClient.Secrets(*namespace).Get(ctx, sealedSecretResourceName, metav1.GetOptions{})
			Expect(err).ShouldNot(HaveOccurred())

			for expectedK, expectedV := range unencryptedDataPayload {
				unencryptedValue, found := secret.Data[expectedK]
				Expect(found).To(BeTrue())
				Expect(expectedV == string(unencryptedValue)).To(BeTrue())
			}
		})

		When("the associated secret is deleted", func() {
			BeforeEach(func() {
				err := typedClient.Secrets(*namespace).Delete(ctx, sealedSecretResourceName, metav1.DeleteOptions{})
				Expect(err).ShouldNot(HaveOccurred())
			})

			It("should have recreated the unsealed secret", func() {
				isAvailable, _ := retry("isSecretAvailable", 5, 1*time.Second, func() (bool, error) { return isSecretAvailable(ctx, typedClient, sealedSecretResourceName) })
				Expect(isAvailable).To(BeTrue())
			})
		})
	})
})
