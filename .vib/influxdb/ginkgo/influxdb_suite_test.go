package influxdb_test

import (
	"flag"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var deployName = flag.String("name", "", "name of the primary statefulset")
var namespace = flag.String("namespace", "", "namespace where the application is running")
var token = flag.String("token", "", "token for accessing the installation")
var bucket = flag.String("bucket", "", "bucket for inserting the data")
var org = flag.String("org", "", "admin organization")

func TestInfluxdb(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Influxdb Persistence Test Suite")
}
