package seaweedfs_test

import (
	"context"
	"errors"
	"flag"
	"testing"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	batchv1 "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/resource"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

const (
	kindDownload string = "download"
	kindUpload   string = "upload"
)

var (
	kubeconfig     string
	masterName     string
	volumeName     string
	namespace      string
	timeoutSeconds int
	timeout        time.Duration
)

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&namespace, "namespace", "", "namespace where SeaweedFS is running")
	flag.StringVar(&masterName, "masterName", "", "Master Server name")
	flag.StringVar(&volumeName, "volumeName", "", "Volume Server name")
	flag.IntVar(&timeoutSeconds, "timeout", 240, "timeout in seconds")
	timeout = time.Duration(timeoutSeconds) * time.Second
}

func TestSeaweedFS(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "SeaweedFS Persistence Test Suite")
}

func createPVC(ctx context.Context, c kubernetes.Interface, name, size string) error {
	storageRequest, err := resource.ParseQuantity(size)
	if err != nil {
		return err
	}

	pvc := &v1.PersistentVolumeClaim{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		Spec: v1.PersistentVolumeClaimSpec{
			AccessModes: []v1.PersistentVolumeAccessMode{v1.ReadWriteOnce},
			Resources: v1.ResourceRequirements{
				Requests: v1.ResourceList{
					v1.ResourceStorage: storageRequest,
				},
			},
		},
	}

	_, err = c.CoreV1().PersistentVolumeClaims(namespace).Create(ctx, pvc, metav1.CreateOptions{})

	return err
}

func createJob(ctx context.Context, c kubernetes.Interface, name, port, image, pvcName, kind string) error {
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

	args := []string{"-ec"}
	switch kind {
	case kindDownload:
		downloadCmd := `cd /tmp
cat /data/fid | xargs weed download -server ${MASTER_HOST}:${MASTER_PORT}
[ -f .spdx-seaweedfs.spdx ] && echo "successful download"
`
		args = append(args, downloadCmd)
	case kindUpload:
		// Response format: "[{"fileName":"FOO","url":"HOST:PORT/ID","fid":"ID","size":SIZE}]"
		uploadCmd := `weed upload -master ${MASTER_HOST}:${MASTER_PORT} .spdx-seaweedfs.spdx | awk -F '","' '{print $3}' | awk -F '":"' '{print $2}' | tee /data/fid`
		args = append(args, uploadCmd)
	default:
		return errors.New("job kind not supported")
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
							Name:    "seaweedfs",
							Image:   image,
							Command: []string{"bash"},
							Args:    args,
							Env: []v1.EnvVar{
								{
									Name:  "MASTER_HOST",
									Value: masterName,
								},
								{
									Name:  "MASTER_PORT",
									Value: port,
								},
							},
							SecurityContext: securityContext,
							VolumeMounts: []v1.VolumeMount{
								{
									Name:      "data",
									MountPath: "/data",
								},
							},
						},
					},
					Volumes: []v1.Volume{
						{
							Name: "data",
							VolumeSource: v1.VolumeSource{
								PersistentVolumeClaim: &v1.PersistentVolumeClaimVolumeSource{
									ClaimName: pvcName,
								},
							},
						},
					},
				},
			},
		},
	}

	_, err := c.BatchV1().Jobs(namespace).Create(ctx, job, metav1.CreateOptions{})

	return err
}
