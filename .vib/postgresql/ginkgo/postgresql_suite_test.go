package postgresql_test

import (
	"context"
	"flag"
	"testing"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	batchv1 "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

var (
	kubeconfig     string
	stsName        string
	namespace      string
	username       string
	password       string
	timeoutSeconds int
	timeout        time.Duration
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&stsName, "name", "", "name of the primary statefulset")
	flag.StringVar(&namespace, "namespace", "", "namespace where the application is running")
	flag.StringVar(&username, "username", "", "database user")
	flag.StringVar(&password, "password", "", "database password for username")
	flag.IntVar(&timeoutSeconds, "timeout", 300, "timeout in seconds")
	timeout = time.Duration(timeoutSeconds) * time.Second
}

func TestPostgreSQL(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "PostgreSQL Persistence Test Suite")
}

func createJob(ctx context.Context, c kubernetes.Interface, name, port, image, stmt string) error {
	securityContext := &v1.SecurityContext{
		Privileged:               &[]bool{false}[0],
		AllowPrivilegeEscalation: &[]bool{false}[0],
		RunAsNonRoot:             &[]bool{true}[0],
		Capabilities: &v1.Capabilities{
			Drop: []v1.Capability{"ALL"},
		},
		SeccompProfile: &v1.SeccompProfile{
			Type: "RuntimeDefault",
		},
	}
	job := &batchv1.Job{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		TypeMeta: metav1.TypeMeta{
			Kind: "Job",
		},
		Spec: batchv1.JobSpec{
			Template: v1.PodTemplateSpec{
				Spec: v1.PodSpec{
					RestartPolicy: "Never",
					Containers: []v1.Container{
						{
							Name:    "psql",
							Image:   image,
							Command: []string{"psql", "-h", stsName, "-p", port, "-U", username, "-c", stmt},
							Env: []v1.EnvVar{
								{
									Name:  "PGPASSWORD",
									Value: password,
								},
							},
							SecurityContext: securityContext,
						},
					},
				},
			},
		},
	}

	_, err := c.BatchV1().Jobs(namespace).Create(ctx, job, metav1.CreateOptions{})

	return err
}
