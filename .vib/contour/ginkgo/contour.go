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

	// To parse matrix compatibility yaml
	"gopkg.in/yaml.v3"
)

type compatibilityMatrix struct {
	Metadata struct {
		Name        string
		Description string
		Website     string
		Repository  string
	}
	Versions []struct {
		Version      string
		Supported    string
		Dependencies struct {
			Envoy      string
			Kubernetes []string
			Gateway    []string
		}
	}
}

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
			var envoyPodVersion string
			var contourPodVersion string
			var envoyCompatibleVersion bool = false
			var contourVersionFound bool = false

			pods, err := coreclient.Pods(*namespace).List(ctx, metav1.ListOptions{})
			if err != nil {
				panic(fmt.Sprintf("There was an error getting the list of pods: %q", err))
			}
			for _, pod := range pods.Items {
				if strings.Contains(pod.Name, "contour-envoy") {
					for _, container := range pod.Spec.Containers {
						switch container.Name {
						case "shutdown-manager":
							contourPodVersion = getImageVersion(container.Image)
						case "envoy":
							envoyPodVersion = getImageVersion(container.Image)
						}
					}
				}
			}

			if contourPodVersion == "" {
				panic(fmt.Sprintf("Contour image version could not be retrieved"))
			}
			if envoyPodVersion == "" {
				panic(fmt.Sprintf("Envoy image version could not be retrieved"))
			}

			// Compatibility Table https://projectcontour.io/resources/compatibility-matrix/
			body, err := getBody("https://raw.githubusercontent.com/projectcontour/contour/main/versions.yaml")
			if err != nil {
				panic(fmt.Sprintf("Error when retriving compatibility matrix"))
			}

			compatibilityMatrixSRC := compatibilityMatrix{}

			err = yaml.Unmarshal([]byte(body), &compatibilityMatrixSRC)
			if err != nil {
				panic(fmt.Sprintf("Error when parsing compatibility matrix yaml"))
			}

			// Look for the versions in the compatibility
			for _, contourVersion := range compatibilityMatrixSRC.Versions {
				if contourVersion.Version == ("v" + contourPodVersion) {
					contourVersionFound = true
					envoyDepVersionParts := strings.Split(contourVersion.Dependencies.Envoy, ".")
					envoyPodVersionParts := strings.Split(envoyPodVersion, ".")
					// Check that Envoy uses the same branch and it is greater or equal than the version listed in the compatibility matrix
					if envoyPodVersionParts[0] == envoyDepVersionParts[0] && envoyPodVersionParts[1] == envoyDepVersionParts[1] && envoyPodVersionParts[2] >= envoyDepVersionParts[2] {
						envoyCompatibleVersion = true
					}
				}
			}
			if !contourVersionFound {
				panic(fmt.Sprintf("Error: The contour version was not found in the compatibility matrix"))
			}
			Expect(envoyCompatibleVersion).To(BeTrue())
		})
	})
})
