package mongodb_sharded_test

import (
	"flag"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var (
	kubeconfig  string
	releaseName string
	namespace   string
	username    string
	password    string
	shards      int
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&releaseName, "name", "", "name of the primary statefulset")
	flag.StringVar(&namespace, "namespace", "", "namespace where the application is running")
	flag.StringVar(&username, "username", "", "database user")
	flag.StringVar(&password, "password", "", "database password for username")
	flag.IntVar(&shards, "shards", 3, "number of shards")
}

func TestMariaDB(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "MongoDB Sharded Persistence Test Suite")
}
