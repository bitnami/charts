package kafka_test

import (
	"flag"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var releaseName = flag.String("name", "", "name of the kafka statefulset")
var namespace = flag.String("namespace", "", "namespace where the application is running")

func TestKafka(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Kafka Persistence Test Suite")
}
