package mongodb_sharded_test

import (
	"flag"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
var releaseName = flag.String("name", "", "name of the primary statefulset")
var namespace = flag.String("namespace", "", "namespace where the application is running")
var username = flag.String("username", "", "database user")
var password = flag.String("password", "", "database password for username")
var shards = flag.Int("shards", 3, "number of shards")

func TestMariaDB(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "MongoDB Sharded Persistence Test Suite")
}
