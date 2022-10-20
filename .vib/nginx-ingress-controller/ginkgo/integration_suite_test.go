package integration

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"io"
	"strings"
	"testing"

	v1 "k8s.io/api/core/v1"
	netv1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

const APP_NAME = "NGINX Ingress Controller"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace where the resources are deployed")

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

func createIngressOrDie(ctx context.Context, c netcv1.NetworkingV1Interface, namespace string, name string, ingressClassName string, ingressRuleHost string, ingressRuleValue netv1.IngressRuleValue) netv1.Ingress {
	ingress := &netv1.Ingress{
		ObjectMeta: metav1.ObjectMeta{
			Namespace: namespace,
			Name:      name,
		},
		Spec: netv1.IngressSpec{
			IngressClassName: &ingressClassName,
			Rules: []netv1.IngressRule{
				{
					Host:             ingressRuleHost,
					IngressRuleValue: ingressRuleValue,
				},
			},
		},
	}

	result, err := c.Ingresses(namespace).Create(ctx, ingress, metav1.CreateOptions{})
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Created ingress %q.\n", result.GetObjectMeta().GetName())

	return *result
}

func getPodsByLabelOrDie(ctx context.Context, c cv1.PodsGetter, namespace string, selector string) v1.PodList {

	output, err := c.Pods(namespace).List(ctx, metav1.ListOptions{
		LabelSelector: selector,
	})
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Obtained list of pods with label %q\n", selector)

	return *output
}

func getPodLogsOrDie(ctx context.Context, c cv1.PodsGetter, namespace, podName, container string) []string {
	var output []string
	tailLines := int64(5)

	readCloser, err := c.Pods(namespace).GetLogs(podName, &v1.PodLogOptions{
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
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
