package ginkgo_utils

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"regexp"
	"strconv"
	"time"

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

	for i := 0; i < maxRetries; i++ {
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
// SvcGetPortByName returns the port number of a svc given its name
func SvcGetPortByName(svc *v1.Service, portName string) (string, error) {
	for _, p := range svc.Spec.Ports {
		if p.Name == portName {
			return strconv.FormatInt(p.Port, 10), nil
		}
	}

	return "", fmt.Errorf("port %q not found in service %q", name, svc.Name)
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
	return n, r.ctx.Err()
}

// containsPattern checks that a given pattern is inside an array of string
func containsPattern(haystack []string, pattern string) (bool, error) {
	var err error

	for _, s := range haystack {
		match, err := regexp.MatchString(pattern, s)
		if match {
			return true, err
		}
	}
	return false, err
}

// Other functions

// Retry performs an operation a given set of attempts
func Retry(name string, attempts int, sleep time.Duration, f func() (bool, error)) (res bool, err error) {
	for i := 0; i < attempts; i++ {
		fmt.Printf("[retriable] operation %q executing now [attempt %d/%d]\n", name, (i + 1), attempts)
		res, err = f()
		if res {
			fmt.Printf("[retriable] operation %q succedeed [attempt %d/%d]\n", name, (i + 1), attempts)
			return res, err
		}
		fmt.Printf("[retriable] operation %q failed, sleeping for %q now...\n", name, sleep)
		time.Sleep(sleep)
	}
	fmt.Printf("[retriable] operation %q failed [attempt %d/%d]\n", name, attempts, attempts)
	return res, err
}
