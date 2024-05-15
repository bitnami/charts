// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"context"
	"fmt"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

var _ = Describe("NGINX Ingress Controller:", func() {
	var netclient netcv1.NetworkingV1Interface
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		netclient = netcv1.NewForConfigOrDie(clusterConfigOrDie())
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	When("a testing ingress resource is created", func() {
		var ingressName, ingressHost string
		var hasIP, resolves bool

		BeforeEach(func() {
			nicSvc, err := coreclient.Services(*namespace).Get(ctx, "nginx-ingress-controller", metav1.GetOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error retrieving the nginx ingress controller service: %q", err))
			}

			ingressName = "vib-ing-test"
			ingressHost = returnValidHost(nicSvc.Status.LoadBalancer.Ingress[0])
			createIngressOrDie(ctx, netclient, ingressName, ingressHost)

			// Once created, the controller has to assign an IP to the managed ingress
			hasIP, err = retry("hasIPAssigned", 6, 20*time.Second, func() (bool, error) {
				return hasIPAssigned(ctx, netclient, ingressName)
			})
			if err != nil {
				panic(fmt.Sprintf("There was an error checking whether the testing ingress had an IP assigned: %q", err))
			}
			Expect(hasIP).To(BeTrue())

			resolves, err = retry("resolvesToDeployment", 6, 20*time.Second, func() (bool, error) {
				return resolvesToDeployment(ctx, "http://"+ingressHost)
			})
			if err != nil {
				panic(fmt.Sprintf("There was an error resolving the ingress host: %q", err))
			}
			Expect(resolves).To(BeTrue())
		})

		AfterEach(func() {
			// Not need to panic here if failed, the cluster is expected to clean up with the undeployment
			netclient.Ingresses(*namespace).Delete(ctx, ingressName, metav1.DeleteOptions{})
		})

		It("the host resolves to the testing deployment", func() {
			responseBody := getResponseBodyOrDie(ctx, "http://"+ingressHost)
			Expect(containsString(responseBody, "dokuwiki")).To(BeTrue())
		})
	})
})
