package postgresql_ha_test

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

func TestPostgreSQL(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "PostgreSQL HA Persistence Test Suite")
}
