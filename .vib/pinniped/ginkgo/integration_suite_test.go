// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (
	"bufio"
	"context"
	b64 "encoding/base64"
	"flag"
	"fmt"
	"io"
	"math/rand"
	"os"
	"regexp"
	"testing"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	// For client auth plugins

	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

const APP_NAME = "Pinniped"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace where the resources are deployed")
var authUser = flag.String("auth-user", "", "LDAP username used to login")
var authPassword = flag.String("auth-password", "", "LDAP password used to login")

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

func createTestingPodOrDie(ctx context.Context, c cv1.PodsGetter) *v1.Pod {
	kubeconfigContent, _ := os.ReadFile(*kubeconfig)
	scriptContent, _ := os.ReadFile("./scripts/pinniped-auth.sh")

	podData := &v1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Namespace: *namespace,
			Name:      "vib-cli-" + fmt.Sprint(rand.Intn(100)),
			Labels: map[string]string{
				"app": "vib-cli",
			},
		},
		Spec: v1.PodSpec{
			Containers: []v1.Container{
				{
					Name:       "vib-cli",
					Image:      "docker.io/bitnami/pinniped-cli",
					WorkingDir: "/tmp",
					Command: []string{
						"/bin/bash", "-c", "printenv PINNIPED_SCRIPT | base64 -d > pinniped-script.sh && chmod +x pinniped-script.sh && ./pinniped-script.sh && sleep infinity"},
					Env: []v1.EnvVar{
						{
							Name:  "KUBECONFIG",
							Value: fmt.Sprint(b64.StdEncoding.EncodeToString([]byte(kubeconfigContent))),
						},
						{
							Name:  "PINNIPED_SCRIPT",
							Value: fmt.Sprint(b64.StdEncoding.EncodeToString([]byte(scriptContent))),
						},
						{
							Name:  "PINNIPED_USERNAME",
							Value: *authUser,
						},
						{
							Name:  "PINNIPED_PASSWORD",
							Value: *authPassword,
						},
					},
				},
			},
		},
	}
	result, err := c.Pods(*namespace).Create(ctx, podData, metav1.CreateOptions{})
	if err != nil {
		panic(fmt.Sprintf("There was an error creating the Pod: %s", err))
	}
	return result
}

func isPodRunning(ctx context.Context, c cv1.PodsGetter, podName string) (bool, error) {
	pod, err := c.Pods(*namespace).Get(ctx, podName, metav1.GetOptions{})
	if err != nil {
		fmt.Printf("There was an error obtaining the Pod %q", podName)
		return false, err
	}
	if pod.Status.Phase == "Running" {
		return true, nil
	} else {
		return false, nil
	}
}

func getPodsByLabelOrDie(ctx context.Context, c cv1.PodsGetter, selector string) v1.PodList {
	output, err := c.Pods(*namespace).List(ctx, metav1.ListOptions{
		LabelSelector: selector,
	})
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Obtained list of pods with label %q\n", selector)

	return *output
}

func getContainerLogsOrDie(ctx context.Context, c cv1.PodsGetter, podName string, containerName string) []string {
	var output []string
	tailLines := int64(100)

	readCloser, err := c.Pods(*namespace).GetLogs(podName, &v1.PodLogOptions{
		Container: containerName,
		Follow:    false,
		TailLines: &tailLines,
	}).Stream(ctx)
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Obtained %q pod's logs\n", podName)

	defer readCloser.Close()

	scanner := bufio.NewScanner(interruptableReader{ctx, readCloser})
	for scanner.Scan() {
		output = append(output, scanner.Text())
	}
	if scanner.Err() != nil {
		panic(scanner.Err())
	}
	return output
}

func containerLogsContainPattern(ctx context.Context, c cv1.PodsGetter, podName string, containerName string, pattern string) (bool, error) {
	containerLogs := getContainerLogsOrDie(ctx, c, podName, containerName)
	return containsPattern(containerLogs, pattern)
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

func containsPattern(haystack []string, pattern string) (bool, error) {
	var err error

	for _, s := range haystack {
		match, err := regexp.MatchString(pattern, s)
		if match {
			return true, err
		}
	}
	return false, err
}

func CheckRequirements() {
	if *namespace == "" {
		panic(fmt.Sprintf("The namespace where %s is deployed must be provided. Use the '--namespace' flag", APP_NAME))
	}
	if *authUser == "" {
		panic("The LDAP username used to login must be provided. Use the '--auth-user' flag")
	}
	if *authPassword == "" {
		panic("The LDAP password used to login must be provided. Use the '--auth-password' flag")
	}
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
