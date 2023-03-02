package integration

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"io"
	"regexp"
	"testing"
	"time"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

const APP_NAME = "Wavefront"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace where the resources are deployed")
var proxyPort = flag.String("proxy-port", "", "port number the proxy will listen on for metrics")

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

func getContainerLogsOrDie(ctx context.Context, c cv1.PodsGetter, podName string, container string) []string {
	var output []string
	tailLines := int64(20)

	readCloser, err := c.Pods(*namespace).GetLogs(podName, &v1.PodLogOptions{
		Container: container,
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

func getPodsByLabelOrDie(ctx context.Context, c cv1.PodsGetter, selector string) v1.PodList {

	output, err := c.Pods(*namespace).List(ctx, metav1.ListOptions{
		LabelSelector: selector,
	})
	if err != nil {
		panic(fmt.Sprintf("There was an error retrieving the list of pods with label %q: %q", selector, err))
	}
	fmt.Printf("Obtained list of pods with label %q\n", selector)

	return *output
}

func containerLogsContains(ctx context.Context, c cv1.PodsGetter, podLabel string, containerName string, entries []string) (res bool, err error) {
	var pods v1.PodList
	var containerLogs []string

	pods = getPodsByLabelOrDie(ctx, c, podLabel)
	containerLogs = getContainerLogsOrDie(ctx, c, pods.Items[0].GetName(), containerName)

	for _, pattern := range entries {
		res, err = containsPattern(containerLogs, pattern)

		if !res {
			return res, err
		}
	}

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
		panic(fmt.Sprintf("The namespace where %s is deployed must be provided. Use the '--namespace' flag\n", APP_NAME))
	}
	if *proxyPort == "" {
		panic(fmt.Sprintln("The port number the proxy will listen on for metrics must be provided. Use the '--proxy-port' flag"))
	}
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
