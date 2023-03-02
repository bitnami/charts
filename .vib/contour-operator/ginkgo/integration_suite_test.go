package integration

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"io"
	"strings"
	"testing"
	"time"

	v1 "k8s.io/api/core/v1"
	netv1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/client-go/dynamic"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	// For client auth plugins
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

const APP_NAME = "Contour Operator"

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var namespace = flag.String("namespace", "", "namespace where the resources are deployed")
var svcName = flag.String("service-name", "", "service name used to serve the apache deployment")
var secretName = flag.String("secret-name", "", "secret name with TLS certs")

var contourType = schema.GroupVersionResource{Group: "operator.projectcontour.io", Version: "v1alpha1", Resource: "contours"}

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

func createIngressOrDie(ctx context.Context, c netcv1.NetworkingV1Interface, name string, ingressRuleHost string) {
	var pathType netv1.PathType = "Prefix"

	ingressRuleValue := netv1.IngressRuleValue{
		HTTP: &netv1.HTTPIngressRuleValue{
			Paths: []netv1.HTTPIngressPath{
				{
					Path:     "/",
					PathType: &pathType,
					Backend: netv1.IngressBackend{
						Service: &netv1.IngressServiceBackend{
							Name: *svcName,
							Port: netv1.ServiceBackendPort{
								Number: int32(80),
							},
						},
					},
				},
			},
		},
	}
	ingress := &netv1.Ingress{
		ObjectMeta: metav1.ObjectMeta{
			Namespace: *namespace,
			Name:      name,
			Annotations: map[string]string{
				"kubernetes.io/ingress.class": "contour",
			},
		},
		Spec: netv1.IngressSpec{
			TLS: []netv1.IngressTLS{
				{
					Hosts: []string{
						ingressRuleHost,
					},
					SecretName: *secretName,
				},
			},
			Rules: []netv1.IngressRule{
				{
					Host:             ingressRuleHost,
					IngressRuleValue: ingressRuleValue,
				},
			},
			DefaultBackend: &netv1.IngressBackend{
				Service: &netv1.IngressServiceBackend{
					Name: *svcName,
					Port: netv1.ServiceBackendPort{
						Number: int32(80),
					},
				},
			},
		},
	}

	result, err := c.Ingresses(*namespace).Create(ctx, ingress, metav1.CreateOptions{})
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Created ingress %q.\n", result.GetObjectMeta().GetName())
}

func createContourResourceOrDie(ctx context.Context, dC dynamic.Interface, name string) *unstructured.Unstructured {
	payload := &unstructured.Unstructured{
		Object: map[string]interface{}{
			"apiVersion": "operator.projectcontour.io/v1alpha1",
			"kind":       "Contour",
			"metadata": map[string]interface{}{
				"name": name,
			},
			"spec": map[string]interface{}{
				"namespace": map[string]interface{}{
					"name": *namespace,
				},
			},
		},
	}

	res, err := dC.Resource(contourType).Namespace(*namespace).Create(ctx, payload, metav1.CreateOptions{})
	if err != nil {
		panic(fmt.Sprintf("There was an error creating the Contour object: %s", err))
	}

	return res
}

func isContourReady(ctx context.Context, dC dynamic.Interface, name string) (bool, error) {
	var err error

	contour, err := dC.Resource(contourType).Namespace(*namespace).Get(ctx, name, metav1.GetOptions{})
	if err != nil {
		fmt.Printf("There was an error obtaining the Contour object %q", name)
		return false, err
	}
	conditions, found, err := unstructured.NestedSlice(contour.Object, "status", "conditions")
	if !found {
		fmt.Printf("Status conditions for Contour %q were not found", name)
		return false, err
	}

	mostRecentConditionUpdate := conditions[len(conditions)-1]
	conditionToMap, conversionOk := mostRecentConditionUpdate.(map[string]interface{})
	if !conversionOk {
		return false, fmt.Errorf("Error converting last Contour condition to type map[string]interface{};  got %T", conditionToMap)
	}

	return conditionToMap["type"] == "Available" && conditionToMap["status"] == "True", nil
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

func getContainerLogsOrDie(ctx context.Context, c cv1.PodsGetter, podName string, container string) []string {
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

func isServiceReady(ctx context.Context, c cv1.CoreV1Interface, resourceName string) (bool, error) {
	var err error

	netResource, err := c.Services(*namespace).Get(ctx, resourceName, metav1.GetOptions{})

	if netResource != nil && len(netResource.Status.LoadBalancer.Ingress) > 0 {
		return true, err
	} else {
		return false, err
	}
}

func isIngressReady(ctx context.Context, c netcv1.NetworkingV1Interface, resourceName string) (bool, error) {
	var err error

	netResource, err := c.Ingresses(*namespace).Get(ctx, resourceName, metav1.GetOptions{})

	if netResource != nil && len(netResource.Status.LoadBalancer.Ingress) > 0 {
		return true, err
	} else {
		return false, err
	}
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
	if *svcName == "" {
		panic(fmt.Sprintln("The testing service name used to serve the apache deployment must be provided. Use the '--service-name' flag"))
	}
	if *secretName == "" {
		panic(fmt.Sprintln("The testing secret name with TLS certs must be provided. Use the '--secret-name' flag"))
	}
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
