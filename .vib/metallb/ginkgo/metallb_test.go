// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"context"
	"fmt"
	"time"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/dynamic"
	corev1 "k8s.io/client-go/kubernetes/typed/core/v1"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("MetalLB", func() {
	var typedClient corev1.CoreV1Interface
	var dynamicClient dynamic.Interface
	var ctx context.Context

	BeforeEach(func() {
		typedClient = corev1.NewForConfigOrDie(clusterConfigOrDie())
		dynamicClient = dynamic.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	Context("configured via IPAddressPool & L2Advertisement resources (CRDs)", func() {
		var ipPoolConfig = IpAddressPoolConfig{
			name:        "ip-address-pool-vib-tests",
			addressFrom: "192.168.100.0",
			addressTo:   "192.168.100.255",
		}
		var advertConfig = L2AdvertisementConfig{
			name:              "l2-advertisement-vib-tests",
			ipAddressPoolName: ipPoolConfig.name,
		}

		BeforeEach(func() {
			createIpAddressPoolResourceOrDie(ctx, dynamicClient, &ipPoolConfig)
			createL2AdvertisementResourceOrDie(ctx, dynamicClient, &advertConfig)
		})
		AfterEach(func() {
			// Not need to panic here if failed, the cluster is expected to clean up with the undeployment
			dynamicClient.Resource(l2AdvertisementType).Namespace(*namespace).Delete(ctx, advertConfig.name, metav1.DeleteOptions{})
			dynamicClient.Resource(ipAddressPoolType).Namespace(*namespace).Delete(ctx, ipPoolConfig.name, metav1.DeleteOptions{})
		})

		When("a Service resource is created", func() {
			var service *v1.Service
			var serviceName string = "lb-vib-tests"
			var hasIP bool

			BeforeEach(func() {
				var err error
				createServiceOrDie(ctx, typedClient, serviceName)

				// Once created, the controller has to assign an IP to the managed ingress
				hasIP, err = retry("hasIPAssigned", 8, 15*time.Second, func() (bool, error) {
					return hasIPAssigned(ctx, typedClient, serviceName)
				})
				if err != nil {
					panic(fmt.Sprintf("There was an error checking whether the testing service had an IP assigned: %q", err))
				}
				Expect(hasIP).To(BeTrue())

				service, err = typedClient.Services(*namespace).Get(ctx, serviceName, metav1.GetOptions{})
				if err != nil {
					panic(fmt.Sprintf("There was an error retrieving the created Service resource: %s", err))
				}
			})
			AfterEach(func() {
				// Not need to panic here if failed, the cluster is expected to clean up with the undeployment
				typedClient.Services(*namespace).Delete(ctx, serviceName, metav1.DeleteOptions{})
			})

			It("should be assigned a valid IP", func() {
				Expect(len(service.Status.LoadBalancer.Ingress)).To(BeNumerically(">", 0))
				Expect(service.Status.LoadBalancer.Ingress[0].IP).NotTo(BeNil())
				Expect(checkValidIP(service.Status.LoadBalancer.Ingress[0].IP, ipPoolConfig.addressFrom, ipPoolConfig.addressTo)).To(BeTrue())
			})
		})

	})

})
