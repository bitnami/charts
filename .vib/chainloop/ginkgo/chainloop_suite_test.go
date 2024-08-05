package chainloop_test

import (
	"flag"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var (
	kubeconfig     string
	releaseName    string
	namespace      string
	timeoutSeconds int
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&releaseName, "name", "", "name of the primary statefulset")
	flag.StringVar(&namespace, "namespace", "", "namespace where the application is running")
	flag.IntVar(&timeoutSeconds, "timeout", 180, "timeout in seconds")
}

func TestChainloop(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Chainloop Persistence Test Suite")
}
