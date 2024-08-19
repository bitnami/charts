package chainloop_test

import (
	"flag"
	"testing"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var (
	kubeconfig     string
	releaseName    string
	namespace      string
	timeoutSeconds int
	timeout        time.Duration
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&releaseName, "name", "", "name of the primary statefulset")
	flag.StringVar(&namespace, "namespace", "", "namespace where the application is running")
	flag.IntVar(&timeoutSeconds, "timeout", 500, "timeout in seconds")
	timeout = time.Duration(timeoutSeconds) * time.Second
}

func TestChainloop(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Chainloop Persistence Test Suite")
}
