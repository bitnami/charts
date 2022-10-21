package integration

import (
	"context"
	"flag"
	"fmt"
	"testing"

	netv1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	netcv1 "k8s.io/client-go/kubernetes/typed/networking/v1"
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

func getIngressesByLabelOrDie(ctx context.Context, c netcv1.NetworkingV1Interface, namespace string, selector string) netv1.IngressList {

	output, err := c.Ingresses(namespace).List(ctx, metav1.ListOptions{
		LabelSelector: selector,
	})
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Obtained list of ingresses with label %q\n", selector)

	return *output
}

func CheckRequirements() {
	if *namespace == "" {
		panic(fmt.Sprintf("The namespace where %s is deployed must be provided. Use the '--namespace' flag", APP_NAME))
	}
	if *ingressName == "" {
		panic("The resource name of the testing ingress. Use the '--ingress-name' flag")
	}
}

func TestIntegration(t *testing.T) {
	RegisterFailHandler(Fail)
	CheckRequirements()
	RunSpecs(t, fmt.Sprintf("%s Integration Tests", APP_NAME))
}
