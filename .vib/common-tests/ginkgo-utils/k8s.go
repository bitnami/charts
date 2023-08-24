package ginkgo_utils

import (
	"context"
	"fmt"
	"strconv"

	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

// Cluster initialization functions

// ClusterConfigOrDie builds the Kubernetes rest API configuration handler using a
// given kubeconfig file
func ClusterConfigOrDie(kubeconfig string) *rest.Config {
	if kubeconfig == "" {
		panic("kubeconfig must be supplied")
	}

	config, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
	if err != nil {
		panic(err.Error())
	}

	return config
}

// StatefulSet functions

// StsGetAvailableReplicas returns the available replicas in a
// StatefulSet instance
func StsGetAvailableReplicas(ss *appsv1.StatefulSet) int32 {
	return ss.Status.AvailableReplicas
}

// StsScale scales a StatefulSet instance to the number of replicas
func StsScale(ctx context.Context, c kubernetes.Interface, ss *appsv1.StatefulSet, count int32) (*appsv1.StatefulSet, error) {
	name := ss.Name
	ns := ss.Namespace

	for i := 0; i < 3; i++ {
		ss, err := c.AppsV1().StatefulSets(ns).Get(ctx, name, metav1.GetOptions{})
		if err != nil {
			return nil, fmt.Errorf("failed to get deployment %q: %v", name, err)
		}
		*(ss.Spec.Replicas) = count
		ss, err = c.AppsV1().StatefulSets(ns).Update(ctx, ss, metav1.UpdateOptions{})
		if err == nil {
			return ss, nil
		}
		if !apierrors.IsConflict(err) && !apierrors.IsServerTimeout(err) {
			return nil, fmt.Errorf("failed to update statefulset %q: %v", name, err)
		}
	}

	return nil, fmt.Errorf("too many retries draining statefulset %q", name)
}

// StsGetContainerImage returns the image inside a container of a StatefulSet instance
func StsGetContainerImage(ss *appsv1.StatefulSet, name string) (string, error) {
	containers := ss.Spec.Template.Spec.Containers

	for _, c := range containers {
		if c.Name == name {
			return c.Image, nil
		}
	}

	return "", fmt.Errorf("container %q not found in statefulset %q", name, ss.Name)
}

// Deployment functions

// DplScale scales a Deployment instance to the number of replicas
func DplScale(ctx context.Context, c kubernetes.Interface, dpl *appsv1.Deployment, count int32) (*appsv1.Deployment, error) {
	name := dpl.Name
	ns := dpl.Namespace

	for i := 0; i < 3; i++ {
		ss, err := c.AppsV1().Deployments(ns).Get(ctx, name, metav1.GetOptions{})
		if err != nil {
			return nil, fmt.Errorf("failed to get deployment %q: %v", name, err)
		}
		*(dpl.Spec.Replicas) = count
		dpl, err = c.AppsV1().Deployments(ns).Update(ctx, ss, metav1.UpdateOptions{})
		if err == nil {
			return dpl, nil
		}
		if !apierrors.IsConflict(err) && !apierrors.IsServerTimeout(err) {
			return nil, fmt.Errorf("failed to update statefulset %q: %v", name, err)
		}
	}

	return nil, fmt.Errorf("too many retries draining statefulset %q", name)
}

// DplGetAvailableReplicas returns the available replicas in a
// Deployment instance
func DplGetAvailableReplicas(dpl *appsv1.Deployment) int32 {
	return dpl.Status.AvailableReplicas
}

// DplGetContainerImage returns the image inside a container of a Deployment instance
func DplGetContainerImage(dpl *appsv1.Deployment, name string) (string, error) {
	containers := dpl.Spec.Template.Spec.Containers

	for _, c := range containers {
		if c.Name == name {
			return c.Image, nil
		}
	}

	return "", fmt.Errorf("container %q not found in deployment %q", name, dpl.Name)
}

// Job functions

// JobGetSucceededPods returs the number of succeded runs in a
// Job instance
func JobGetSucceededPods(j *batchv1.Job) int32 {
	return j.Status.Succeeded
}

// Service functions

// SvcGetPort returns the port number of a Service
func SvcGetPort(svc *v1.Service, name string) (string, error) {
	ports := svc.Spec.Ports

	for _, p := range ports {
		if p.Name == name {
			return strconv.Itoa(int(p.Port)), nil
		}
	}

	return "", fmt.Errorf("port %q not found in service %q", name, svc.Name)
}
