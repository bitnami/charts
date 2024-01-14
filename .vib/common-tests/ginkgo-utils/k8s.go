package ginkgo_utils

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"strconv"

	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

// Cluster initialization functions

// MustBuildClusterConfig builds the Kubernetes rest API configuration handler using a
// given kubeconfig file
func MustBuildClusterConfig(kubeconfig string) *rest.Config {
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

// StsScale scales a StatefulSet instance to the number of replicas
func StsScale(ctx context.Context, c kubernetes.Interface, ss *appsv1.StatefulSet, count int32) (*appsv1.StatefulSet, error) {
	name := ss.Name
	ns := ss.Namespace
	const maxRetries = 3

	for i := 0; i < maxRetries; i++ {
		ss, err := c.AppsV1().StatefulSets(ns).Get(ctx, name, metav1.GetOptions{})
		if err != nil {
			return nil, fmt.Errorf("failed to get statefulset %q: %v", name, err)
		}
		if ss.Status.Replicas == count && ss.Status.AvailableReplicas == count {
			return ss, nil
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

// StsGetContainerImageByName returns the container image given the container name of a StatefulSet instance
func StsGetContainerImageByName(ss *appsv1.StatefulSet, name string) (string, error) {
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
		currentDpl, err := c.AppsV1().Deployments(ns).Get(ctx, name, metav1.GetOptions{})
		if err != nil {
			return nil, fmt.Errorf("failed to get deployment %q: %v", name, err)
		}
		if currentDpl.Status.Replicas == count && currentDpl.Status.AvailableReplicas == count {
			return currentDpl, nil
		}
		*(currentDpl.Spec.Replicas) = count
		currentDpl, err = c.AppsV1().Deployments(ns).Update(ctx, currentDpl, metav1.UpdateOptions{})
		if err == nil {
			return currentDpl, nil
		}
		if !apierrors.IsConflict(err) && !apierrors.IsServerTimeout(err) {
			return nil, fmt.Errorf("failed to update statefulset %q: %v", name, err)
		}
	}

	return nil, fmt.Errorf("too many retries draining statefulset %q", name)
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

// SvcGetPortByName returns the port number of a svc given its name
func SvcGetPortByName(svc *v1.Service, portName string) (string, error) {
	for _, p := range svc.Spec.Ports {
		if p.Name == portName {
			return strconv.FormatInt(int64(p.Port), 10), nil
		}
	}

	return "", fmt.Errorf("port %q not found in service %q", portName, svc.Name)
}

// Pod functions

// IsPodRunning returns a boolean value indicating if a given pod is running
func IsPodRunning(ctx context.Context, c cv1.PodsGetter, namespace string, podName string) (bool, error) {
	pod, err := c.Pods(namespace).Get(ctx, podName, metav1.GetOptions{})
	if err != nil {
		fmt.Printf("There was an error obtaining the Pod %q", podName)
		return false, err
	}
	return pod.Status.Phase == "Running", nil
}

// GetPodsByLabelOrDie returns the list of pods wih a given selector, exiting in case of failure
func GetPodsByLabelOrDie(ctx context.Context, c cv1.PodsGetter, namespace string, selector string) v1.PodList {
	output, err := c.Pods(namespace).List(ctx, metav1.ListOptions{
		LabelSelector: selector,
	})
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Obtained list of pods with label %q\n", selector)

	return *output
}

// GetContainerLogsOrDie returns container logs, exiting in case of failure
func GetContainerLogsOrDie(ctx context.Context, c cv1.PodsGetter, namespace string, podName string, containerName string) []string {
	var output []string
	tailLines := int64(100)

	readCloser, err := c.Pods(namespace).GetLogs(podName, &v1.PodLogOptions{
		Container: containerName,
		Follow:    false,
		TailLines: &tailLines,
	}).Stream(ctx)
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("Obtained %q pod's logs\n", podName)

	defer readCloser.Close()

	scanner := bufio.NewScanner(interruptableReader{ctx, readCloser})
	for scanner.Scan() {
		output = append(output, scanner.Text())
	}
	if scanner.Err() != nil {
		panic(scanner.Err())
	}
	return output
}

// ContainerLogsContainPattern returns a boolean indicating if the container logs have a given pattern
func ContainerLogsContainPattern(ctx context.Context, c cv1.PodsGetter, namespace string, podName string, containerName string, pattern string) (bool, error) {
	containerLogs := GetContainerLogsOrDie(ctx, c, namespace, podName, containerName)
	return containsPattern(containerLogs, pattern)
}

// interruptableReader is a scanner that reads from Kubernetes container logs
type interruptableReader struct {
	ctx context.Context
	r   io.Reader
}

// Read returns content from the Kubernetes logs
func (r interruptableReader) Read(p []byte) (int, error) {
	if err := r.ctx.Err(); err != nil {
		return 0, err
	}
	n, err := r.r.Read(p)
	if err != nil {
		return n, err
	}
	return n, nil
}
