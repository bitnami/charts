// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"context"
	"flag"
	"fmt"
	"testing"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

const APP_NAME = "CertManager"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace name in which the application is deployed")

var issuerType = schema.GroupVersionResource{Group: "cert-manager.io", Version: "v1", Resource: "issuers"}
var certificateType = schema.GroupVersionResource{Group: "cert-manager.io", Version: "v1", Resource: "certificates"}

type CertificateConfig struct {
	name       string
	issuer     string
	secretName string
}

func clusterConfigOrDie() *rest.Config {
	var config *rest.Config
	var err error

	if *kubeconfig != "" {
		config, err = clientcmd.BuildConfigFromFlags("", *kubeconfig)
	} else {
		config, err = rest.InClusterConfig()
	}
	if err != nil {
		panic(err.Error())
	}

	return config
}

func createIssuerResourceOrDie(ctx context.Context, dC dynamic.Interface, name string) *unstructured.Unstructured {
	payload := &unstructured.Unstructured{
		Object: map[string]interface{}{
			"apiVersion": "cert-manager.io/v1",
			"kind":       "Issuer",
			"metadata": map[string]interface{}{
				"name":      name,
				"namespace": *namespace,
			},
			"spec": map[string]interface{}{
				"selfSigned": map[string]interface{}{},
			},
		},
	}

	res, err := dC.Resource(issuerType).Namespace(*namespace).Create(ctx, payload, metav1.CreateOptions{})
	if err != nil {
		panic(fmt.Sprintf("There was an error creating the Issuer resource: %s", err))
	}

	return res
}

func createCertificateResourceOrDie(ctx context.Context, dC dynamic.Interface, config *CertificateConfig) *unstructured.Unstructured {
	payload := &unstructured.Unstructured{
		Object: map[string]interface{}{
			"apiVersion": "cert-manager.io/v1",
			"kind":       "Certificate",
			"metadata": map[string]interface{}{
				"name":      config.name,
				"namespace": *namespace,
			},
			"spec": map[string]interface{}{
				"dnsNames": []string{
					"example.com",
				},
				"secretName": config.secretName,
				"issuerRef": map[string]interface{}{
					"name": config.issuer,
				},
			},
		},
	}

	res, err := dC.Resource(certificateType).Namespace(*namespace).Create(ctx, payload, metav1.CreateOptions{})
	if err != nil {
		panic(fmt.Sprintf("There was an error creating the Certificate resource: %s", err))
	}

	return res
}

func isCertificateReady(ctx context.Context, dC dynamic.Interface, name string) (bool, error) {
	var err error

	certificate, err := dC.Resource(certificateType).Namespace(*namespace).Get(ctx, name, metav1.GetOptions{})
	if err != nil {
		fmt.Printf("There was an error obtaining the Certificate %q", name)
		return false, err
	}
	conditions, found, err := unstructured.NestedSlice(certificate.Object, "status", "conditions")
	if !found {
		fmt.Printf("Status conditions for Certificate %q were not found", name)
		return false, err
	}

	mostRecentConditionUpdate := conditions[len(conditions)-1]
	conditionToMap, conversionOk := mostRecentConditionUpdate.(map[string]interface{})
	if !conversionOk {
		return false, fmt.Errorf("Error converting last Certificate condition to type map[string]interface{};  got %T", conditionToMap)
	}

	return conditionToMap["type"] == "Ready" && conditionToMap["status"] == "True", nil
}

func retry(name string, attempts int, sleep time.Duration, f func() (bool, error)) (res bool, err error) {
	for i := 0; i < attempts; i++ {
		fmt.Printf("[retriable] operation %q executing now [attempt %d/%d]\n", name, (i + 1), attempts)
		res, err = f()
		if res {
			fmt.Printf("[retriable] operation %q succedeed [attempt %d/%d]\n", name, (i + 1), attempts)
			return res, err
		}
		fmt.Printf("[retriable] operation %q failed, sleeping for %q now...\n", name, sleep)
		time.Sleep(sleep)
	}
	fmt.Printf("[retriable] operation %q failed [attempt %d/%d]\n", name, attempts, attempts)
	return res, err
}

func containsAllKeys[K comparable, V any](mapToCheck map[K]V, keySet []K) (res bool) {
	res = true
	for _, k := range keySet {
		if _, ok := mapToCheck[k]; !ok {
			res = false
			break
		}
	}
	return res
}

func CheckRequirements() {
	if *namespace == "" {
		panic(fmt.Sprintf("The namespace where %s is deployed must be provided. Use the '--namespace' flag", APP_NAME))
	}
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
