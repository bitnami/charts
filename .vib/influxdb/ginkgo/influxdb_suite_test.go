package influxdb_test

import (
	"context"
	"flag"
	"fmt"
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
	deployName     string
	namespace      string
	username       string
	password       string
	token          string
	org            string
	bucket         string
	timeoutSeconds int
	timeout        time.Duration
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&deployName, "name", "", "name of the primary statefulset")
	flag.StringVar(&namespace, "namespace", "", "namespace where the application is running")
	flag.StringVar(&org, "org", "", "admin organization")
	flag.StringVar(&token, "token", "", "token for accessing the installation")
	flag.StringVar(&bucket, "bucket", "", "bucket for inserting the data")
	flag.IntVar(&timeoutSeconds, "timeout", 120, "timeout in seconds")
	timeout = time.Duration(timeoutSeconds) * time.Second
}

func TestInfluxdb(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Influxdb Persistence Test Suite")
}

func createJob(ctx context.Context, c kubernetes.Interface, name string, port string, image string, stmt string) error {
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
							Name:  "influxdb",
							Image: image,
							Command: []string{
								"bash", "-ec",
								stmt},
							Env: []v1.EnvVar{
								{
									Name:  "INFLUX_TOKEN",
									Value: token,
								},
								{
									Name:  "INFLUX_ORG",
									Value: org,
								},
								{
									Name:  "INFLUX_BUCKET_NAME",
									Value: bucket,
								},
								{
									Name:  "INFLUX_HOST",
									Value: fmt.Sprintf("http://%s:%s", deployName, port),
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
