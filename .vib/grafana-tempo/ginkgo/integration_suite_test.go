package integration

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"io"
	"net/http"
	"regexp"
	"strings"
	"testing"

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

const APP_NAME = "Grafana Tempo"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace where the resources are deployed")
var apiPort = flag.String("api-port", "", "port in which the QueryFrontend component exposes the API")

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

func containsString(haystack []string, needle string) bool {
	for _, s := range haystack {
		if strings.Contains(s, needle) {
			return true
		}
	}
	return false
}

func findFirstPattern(haystack []string, pattern string, subgroup int) string {
	var res string = ""
	re := regexp.MustCompile(pattern)

	for _, s := range haystack {
		matches := re.FindStringSubmatch(s)
		if (len(matches) - subgroup) > 0 {
			res = matches[subgroup]
		}

		if res != "" {
			break
		}
	}
	return res
}

func CheckRequirements() {
	if *namespace == "" {
		panic(fmt.Sprintf("The namespace where %s is deployed must be provided. Use the '--namespace' flag", APP_NAME))
	}
	if *apiPort == "" {
		panic("The port in which the API is exposed must be provided. Use the '--api-port' flag")
	}
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
