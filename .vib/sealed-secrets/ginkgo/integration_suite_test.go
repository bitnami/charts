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
	corev1 "k8s.io/client-go/kubernetes/typed/core/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

const APP_NAME = "SealedSecrets"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace name in which the application is deployed")

var sealedSecretType = schema.GroupVersionResource{Group: "bitnami.com", Version: "v1alpha1", Resource: "sealedsecrets"}

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

func createSealedSecretResourceOrDie(ctx context.Context, dC dynamic.Interface, name string, encryptedData *unstructured.Unstructured) *unstructured.Unstructured {
	payload := &unstructured.Unstructured{
		Object: map[string]interface{}{
			"apiVersion": "bitnami.com/v1alpha1",
			"kind":       "SealedSecret",
			"metadata": map[string]interface{}{
				"name": name,
				"annotations": map[string]interface{}{
					"sealedsecrets.bitnami.com/cluster-wide": "true",
				},
			},
			"spec": map[string]interface{}{
				"encryptedData": encryptedData,
				"metadata": map[string]interface{}{
					"name": name,
					"annotations": map[string]interface{}{
						"sealedsecrets.bitnami.com/cluster-wide": "true",
					},
				},
			},
		},
	}

	res, err := dC.Resource(sealedSecretType).Namespace(*namespace).Create(ctx, payload, metav1.CreateOptions{})
	if err != nil {
		panic(fmt.Sprintf("There was an error creating the SealedSecret resource: %s", err))
	}

	return res
}

func isSecretAvailable(ctx context.Context, tC corev1.CoreV1Interface, name string) (bool, error) {
	_, err := tC.Secrets(*namespace).Get(ctx, name, metav1.GetOptions{})
	return err == nil, err
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
