// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"context"
	"fmt"
	"strings"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	netv1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("Contour:", func() {
	var netclient netcv1.NetworkingV1Interface
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("The testing ingress", func() {
		var testingIngress *netv1.Ingress
		var ingressHost string
		var resolves bool
		var err error

		BeforeEach(func() {
			testingIngress, err = netclient.Ingresses(*namespace).Get(ctx, *ingressName, metav1.GetOptions{})
			ingressHost = returnValidHost(testingIngress.Status.LoadBalancer.Ingress[0])
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the %q Ingress resource: %q", *ingressName, err))
			}
			resolves, err = retry("resolvesToDeployment", 6, 15*time.Second, func() (bool, error) {
				return resolvesToDeployment(ctx, "http://"+ingressHost)
			})
			if err != nil {
				panic(fmt.Sprintf("There was an error resolving the ingress host: %q", err))
			}
			Expect(resolves).To(BeTrue())
		})

		It("asigned IP is the same as the one used by the envoy service", func() {
			envoySvc, err := coreclient.Services(*namespace).Get(ctx, "contour-envoy", metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the envoy service: %q", err))
			}
			Expect(ingressHost).To(Equal(returnValidHost(envoySvc.Status.LoadBalancer.Ingress[0])))
		})
		It("asigned IP resolves to the testing deployment", func() {
			responseBody := getResponseBodyOrDie(ctx, "http://"+ingressHost)

			Expect(containsString(responseBody, "It works")).To(BeTrue())
		})
		It("contour and envoy container versions are in sync", func() {
			var envoyVersion string
			var contourVersion string
			var envoyCompatibleVersion string

			pods, err := coreclient.Pods(*namespace).List(ctx, metav1.ListOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error getting the list of pods: %q", err))
			}
			for _, pod := range pods.Items {
				if strings.Contains(pod.Name, "contour-envoy") {
					for _, container := range pod.Spec.Containers {
						switch container.Name {
						case "shutdown-manager":
							contourVersion = getImageVersion(container.Image)
						case "envoy":
							envoyVersion = getImageVersion(container.Image)
						}
					}
				}
			}

			if contourVersion == "" {
				panic(fmt.Sprintf("There Contour image version could not be retrieved"))
			}
			if envoyVersion == "" {
				panic(fmt.Sprintf("There Envoy image version could not be retrieved"))
			}

			// Compatibility Table https://projectcontour.io/resources/compatibility-matrix/
			switch contourVersion {
			case "1.29.1":
				envoyCompatibleVersion = "1.30.2"
			case "1.29.0":
				envoyCompatibleVersion = "1.30.1"
			}
			Expect(envoyVersion).To(Equal(envoyCompatibleVersion))
		})
	})
})
