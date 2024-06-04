package nessie_test

import (
	"context"
	"flag"
	"fmt"
	"testing"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	batchv1 "k8s.io/api/batch/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	v1 "k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes"
)

var (
	kubeconfig     string
	dplName        string
	namespace      string
	timeoutSeconds int
	timeout        time.Duration
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&dplName, "name", "", "name of the deployment")
	flag.StringVar(&namespace, "namespace", "", "namespace where the application is running")
	flag.IntVar(&timeoutSeconds, "timeout", 500, "timeout in seconds")
	timeout = time.Duration(timeoutSeconds) * time.Second
}

func TestNessie(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "nessie Persistence Test Suite")
}

func createJob(ctx context.Context, c kubernetes.Interface, name, port, stmt string) error {
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
							Name: "nessie",
							// TODO: Change image
							Image:           "docker.io/javsalgar/nessie-utils:0.83.2-debian-12-r0",
							Command:         []string{"java", "-jar", "/opt/bitnami/nessie-utils/nessie-cli/nessie-cli.jar", "-u", fmt.Sprintf("http://%s:%s/api/v2", dplName, port), "-c", stmt, "--non-ansi"},
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
