// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"io"
	"net/http"
	"strings"
	"testing"
	"time"

	v1 "k8s.io/api/core/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

const APP_NAME = "Contour"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace where the resources are deployed")
var ingressName = flag.String("ingress-name", "", "resource name of the testing ingress")

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

func resolvesToDeployment(ctx context.Context, address string) (bool, error) {
	var client http.Client
	resp, err := client.Get(address)
	if err != nil {
		fmt.Printf("There was an error during the GET request: %q", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {
		return true, err
	} else {
		return false, err
	}
}

func getResponseBodyOrDie(ctx context.Context, address string) []string {
	var output []string
	var client http.Client

	resp, err := client.Get(address)
	if err != nil {
		panic(fmt.Sprintf("There was an error during the GET request: %q", err))
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {
		scanner := bufio.NewScanner(interruptableReader{ctx, resp.Body})
		for scanner.Scan() {
			output = append(output, scanner.Text())
		}
		if scanner.Err() != nil {
			panic(scanner.Err())
		}
	}
	return output
}

type interruptableReader struct {
	ctx context.Context
	r   io.Reader
}

func (r interruptableReader) Read(p []byte) (int, error) {
	if err := r.ctx.Err(); err != nil {
		return 0, err
	}
	n, err := r.r.Read(p)
	if err != nil {
		return n, err
	}
	return n, r.ctx.Err()
}

func returnValidHost(ingress v1.LoadBalancerIngress) string {
	if ingress.IP != "" {
		return ingress.IP + ".nip.io"
	} else if ingress.Hostname != "" {
		return ingress.Hostname
	} else {
		panic("No valid host found for the provided ingress")
	}
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

func containsString(haystack []string, needle string) bool {
	for _, s := range haystack {
		if strings.Contains(s, needle) {
			return true
		}
	}
	return false
}

func CheckRequirements() {
	if *namespace == "" {
		panic(fmt.Sprintf("The namespace where %s is deployed must be provided. Use the '--namespace' flag", APP_NAME))
	}
	if *ingressName == "" {
		panic("The resource name of the testing ingress must be provided. Use the '--ingress-name' flag")
	}
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
