package clickhouse_test

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
	releaseName    string
	namespace      string
	username       string
	password       string
	shards         int
	timeoutSeconds int
	timeout        time.Duration
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&releaseName, "name", "", "name of the primary statefulset")
	flag.StringVar(&namespace, "namespace", "", "namespace where the application is running")
	flag.StringVar(&username, "username", "", "database user")
	flag.StringVar(&password, "password", "", "database password for username")
	flag.IntVar(&shards, "shards", 2, "number of shards")
	flag.IntVar(&timeoutSeconds, "timeout", 300, "timeout in seconds")
	timeout = time.Duration(timeoutSeconds) * time.Second
}

func TestClickHouse(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "ClickHouse Persistence Test Suite")
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
							Name:  "clickhouse",
							Image: image,
							Command: []string{
								"clickhouse-client",
								"--host", releaseName, "--port", port,
								"--config", "/opt/bitnami/clickhouse/etc/config.d/06-tls.xml", "--secure",
								"--user", username, "--password", password, "--multiquery",
								"--query", stmt,
							},
							SecurityContext: securityContext,
							Env: []v1.EnvVar{{
								Name:  "CLICKHOUSE_TCP_SECURE_PORT",
								Value: port,
							}, {
								Name: "CLICKHOUSE_HTTPS_PORT",
								// We can set any number here, it's not used
								Value: "1234",
							}},
							VolumeMounts: []v1.VolumeMount{{
								Name:      "ca-cert",
								MountPath: "/opt/bitnami/clickhouse/certs/ca",
							}, {
								Name:      "configd-configuration",
								MountPath: "/opt/bitnami/clickhouse/etc/config.d",
							}},
						},
					},
					Volumes: []v1.Volume{{
						Name: "ca-cert",
						VolumeSource: v1.VolumeSource{
							Secret: &v1.SecretVolumeSource{
								SecretName: fmt.Sprintf("%s-ca-crt", releaseName),
							},
						},
					}, {
						Name: "configd-configuration",
						VolumeSource: v1.VolumeSource{
							ConfigMap: &v1.ConfigMapVolumeSource{
								LocalObjectReference: v1.LocalObjectReference{
									Name: fmt.Sprintf("%s-configd", releaseName),
								},
							},
						},
					}},
				},
			},
		},
	}

	_, err := c.BatchV1().Jobs(namespace).Create(ctx, job, metav1.CreateOptions{})

	return err
}
