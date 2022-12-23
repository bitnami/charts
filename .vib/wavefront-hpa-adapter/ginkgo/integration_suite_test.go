package integration

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"io"
	"regexp"
	"strings"
	"testing"
	"time"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	corev1 "k8s.io/client-go/kubernetes/typed/core/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

const APP_NAME = "Wavefront HPA Adapter"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace name in which the application is deployed")
var servingPort = flag.String("servingPort", "", "port in which the application is serving")
var wavefrontURL = flag.String("wavefrontURL", "", "external Wavefront URL")
var externalMetric = flag.String("externalMetric", "", "external Wavefront Metric to watch")

type interruptableReader struct {
	ctx context.Context
	r   io.Reader
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

func getPodsByLabelOrDie(ctx context.Context, c corev1.PodsGetter, selector string) v1.PodList {

	output, err := c.Pods(*namespace).List(ctx, metav1.ListOptions{
		LabelSelector: selector,
	})
	if err != nil {
		panic(fmt.Sprintf("There was an error retrieving the list of pods with label %q: %q", selector, err))
	}
	fmt.Printf("Obtained list of pods with label %q\n", selector)

	return *output
}

func getContainerLogsOrDie(ctx context.Context, c corev1.PodsGetter, podName string, container string) []string {
	var output []string
	tailLines := int64(50)

	readCloser, err := c.Pods(*namespace).GetLogs(podName, &v1.PodLogOptions{
		Container: container,
		Follow:    false,
		TailLines: &tailLines,
	}).Stream(ctx)
	if err != nil {
		panic(fmt.Sprintf("There was an error retrieving the %q container's logs for the %q pod: %q", container, podName, err))
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

func getAdapterLogsOrDie(ctx context.Context, c corev1.PodsGetter) []string {
	const adapterPodSelector string = "app.kubernetes.io/component=wavefront-hpa-adapter"
	const adapterContainerName string = "wavefront-hpa-adapter"

	adapterPods := getPodsByLabelOrDie(ctx, c, adapterPodSelector)
	containerLogs := getContainerLogsOrDie(ctx, c, adapterPods.Items[0].GetName(), adapterContainerName)

	return containerLogs
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

func receivedExternalMetric(ctx context.Context, tC corev1.CoreV1Interface) (bool, error) {
	pattern := "received external metric request.*" + *externalMetric
	containerLogs := getAdapterLogsOrDie(ctx, tC)

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

func containsString(haystack []string, needle string) bool {
	for _, s := range haystack {
		if strings.Contains(s, needle) {
			return true
		}
	}
	return false
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
	if *servingPort == "" {
		panic(fmt.Sprintf("The serving port for %s must be provided. Use the '--servingPort' flag", APP_NAME))
	}
	if *wavefrontURL == "" {
		panic(fmt.Sprintf("The external Wavefront URL for %s must be provided. Use the '--wavefrontURL' flag", APP_NAME))
	}
	if *externalMetric == "" {
		panic(fmt.Sprintf("The external Wavefront metric for %s to watch must be provided. Use the '--externalMetric' flag", APP_NAME))
	}
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
