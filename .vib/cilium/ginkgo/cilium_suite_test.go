package cilium_test

import (
	"context"
	"flag"
	"fmt"
	"testing"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/apimachinery/pkg/util/intstr"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/kubernetes"
)

var (
	kubeconfig     string
	releaseName    string
	namespace      string
	timeoutSeconds int
	timeout        time.Duration

	ciliumNetworkPolicyType = schema.GroupVersionResource{Group: "cilium.io", Version: "v2", Resource: "ciliumnetworkpolicies"}
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&namespace, "namespace", "", "namespace where Cilium is running")
	flag.StringVar(&releaseName, "releaseName", "", "Cilium chart release name")
	flag.IntVar(&timeoutSeconds, "timeout", 120, "timeout in seconds")
	timeout = time.Duration(timeoutSeconds) * time.Second
}

func TestCilium(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Cilium Test Suite")
}

func createAPIMockDeploy(ctx context.Context, c kubernetes.Interface, fsGroup, user *int64) error {
	podSecurityContext := &v1.PodSecurityContext{
		FSGroup: fsGroup,
	}
	containerSecurityContext := &v1.SecurityContext{
		RunAsUser: user,
	}

	deploy := &appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{
			Name: "api-mock",
		},
		TypeMeta: metav1.TypeMeta{
			Kind: "Deployment",
		},
		Spec: appsv1.DeploymentSpec{
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					"app": "api-mock",
				},
			},
			Template: v1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						"app": "api-mock",
					},
				},
				Spec: v1.PodSpec{
					SecurityContext: podSecurityContext,
					Containers: []v1.Container{{
						Name:            "api-mock",
						Image:           "docker.io/juanariza131/api-mock:latest",
						SecurityContext: containerSecurityContext,
						Env: []v1.EnvVar{
							{
								Name:  "SUB_ROUTES",
								Value: "/foo",
							},
						},
						Ports: []v1.ContainerPort{{
							Name:          "http",
							ContainerPort: int32(8080),
						}},
					}},
				},
			},
		},
	}

	_, err := c.AppsV1().Deployments(namespace).Create(ctx, deploy, metav1.CreateOptions{})

	return err
}

func createAPIMockService(ctx context.Context, c kubernetes.Interface) error {
	service := &v1.Service{
		ObjectMeta: metav1.ObjectMeta{
			Name: "api-mock",
		},
		TypeMeta: metav1.TypeMeta{
			Kind: "Service",
		},
		Spec: v1.ServiceSpec{
			Type: v1.ServiceTypeClusterIP,
			Ports: []v1.ServicePort{{
				Name:       "http",
				Port:       int32(8080),
				TargetPort: intstr.IntOrString{Type: intstr.String, StrVal: "http"},
			}},
			Selector: map[string]string{
				"app": "api-mock",
			},
		},
	}

	_, err := c.CoreV1().Services(namespace).Create(ctx, service, metav1.CreateOptions{})

	return err
}

func createAPIMockCiliumNetworkPolicy(ctx context.Context, dC dynamic.Interface) error {
	payload := &unstructured.Unstructured{
		Object: map[string]interface{}{
			"apiVersion": "cilium.io/v2",
			"kind":       "CiliumNetworkPolicy",
			"metadata": map[string]interface{}{
				"name": "api-mock",
			},
			"spec": map[string]interface{}{
				"description": "L3-L4 policy to restrict API mock",
				"endpointSelector": map[string]interface{}{
					"matchLabels": map[string]interface{}{
						"app": "api-mock",
					},
				},
				"ingress": []map[string]interface{}{{
					"fromEndpoints": []map[string]interface{}{{
						"matchLabels": map[string]interface{}{
							"api-mock-client": "true",
						},
					}},
					"toPorts": []map[string]interface{}{{
						"ports": []interface{}{
							map[string]interface{}{
								"port":     "8080",
								"protocol": "TCP",
							},
						},
					}},
				}},
			},
		},
	}

	_, err := dC.Resource(ciliumNetworkPolicyType).Namespace(namespace).Create(ctx, payload, metav1.CreateOptions{})
	if err != nil {
		panic(fmt.Sprintf("There was an error creating the CiliumNetworkPolicy resource: %s", err))
	}

	return err
}

func createAPIMockClientJob(ctx context.Context, c kubernetes.Interface, jobName string, fsGroup, user *int64, podLabels map[string]string) error {
	podSecurityContext := &v1.PodSecurityContext{
		FSGroup: fsGroup,
	}
	containerSecurityContext := &v1.SecurityContext{
		RunAsUser: user,
	}

	job := &batchv1.Job{
		ObjectMeta: metav1.ObjectMeta{
			Name: jobName,
		},
		TypeMeta: metav1.TypeMeta{
			Kind: "Job",
		},
		Spec: batchv1.JobSpec{
			Template: v1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: podLabels,
				},
				Spec: v1.PodSpec{
					RestartPolicy:   "Never",
					SecurityContext: podSecurityContext,
					Containers: []v1.Container{
						{
							Name:            "curl",
							Image:           "docker.io/bitnami/os-shell:latest",
							Command:         []string{"bash", "-ec"},
							Args:            []string{"curl --connect-timeout 5 -X GET -H 'Accept: application/json' http://api-mock:8080/v1/mock/foo"},
							SecurityContext: containerSecurityContext,
						},
					},
				},
			},
		},
	}

	_, err := c.BatchV1().Jobs(namespace).Create(ctx, job, metav1.CreateOptions{})

	return err
}
