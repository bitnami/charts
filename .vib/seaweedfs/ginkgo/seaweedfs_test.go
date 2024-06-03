package seaweedfs_test

import (
	"context"
	"fmt"
	"time"

	utils "github.com/bitnami/charts/.vib/common-tests/ginkgo-utils"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

const (
	PollingInterval = 1 * time.Second
)

var _ = Describe("SeaweedFS", Ordered, func() {
	var c *kubernetes.Clientset
	var ctx context.Context
	var cancel context.CancelFunc

	BeforeEach(func() {
		ctx, cancel = context.WithCancel(context.Background())

		conf := utils.MustBuildClusterConfig(kubeconfig)
		c = kubernetes.NewForConfigOrDie(conf)
	})

	When("a file is uploaded and SeaweedFS is scaled down to 0 replicas and back up", func() {
		It("should have access to the uploaded file", func() {

			getAvailableReplicas := func(ss *appsv1.StatefulSet) int32 { return ss.Status.AvailableReplicas }
			getSucceededJobs := func(j *batchv1.Job) int32 { return j.Status.Succeeded }
			getOpts := metav1.GetOptions{}

			By("checking all the replicas are available")
			masterStsName := fmt.Sprintf("%s-master", releaseName)
			masterSts, err := c.AppsV1().StatefulSets(namespace).Get(ctx, masterStsName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			fsGroup := masterSts.Spec.Template.Spec.SecurityContext.FSGroup
			runAsUser := masterSts.Spec.Template.Spec.Containers[0].SecurityContext.RunAsUser
			volumeStsName := fmt.Sprintf("%s-volume", releaseName)
			volumeSts, err := c.AppsV1().StatefulSets(namespace).Get(ctx, volumeStsName, getOpts)
			Expect(err).NotTo(HaveOccurred())
			Expect(masterSts.Status.Replicas).NotTo(BeZero())
			Expect(volumeSts.Status.Replicas).NotTo(BeZero())
			masterOrigReplicas := *masterSts.Spec.Replicas
			volumeOrigReplicas := *volumeSts.Spec.Replicas

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, masterStsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(masterOrigReplicas)))
			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, volumeStsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(volumeOrigReplicas)))

			masterHeadlessSvcName := fmt.Sprintf("%s-master-headless", releaseName)
			svc, err := c.CoreV1().Services(namespace).Get(ctx, masterHeadlessSvcName, getOpts)
			Expect(err).NotTo(HaveOccurred())

			port, err := utils.SvcGetPortByName(svc, "http")
			Expect(err).NotTo(HaveOccurred())

			image, err := utils.StsGetContainerImageByName(masterSts, "seaweedfs")
			Expect(err).NotTo(HaveOccurred())

			jobSuffix := time.Now().Format("20060102150405")
			By("creating a pvc")
			pvcName := fmt.Sprintf("weed-%s", jobSuffix)
			err = createPVC(ctx, c, pvcName, "1G")
			Expect(err).NotTo(HaveOccurred())

			By("creating a job to upload a file")
			uploadJobName := fmt.Sprintf("weed-upload-%s", jobSuffix)
			err = createJob(ctx, c, uploadJobName, port, image, pvcName, kindUpload, fsGroup, runAsUser)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, uploadJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))

			By("scaling down to 0 replicas both master & volume servers")
			masterSts, err = utils.StsScale(ctx, c, masterSts, 0)
			Expect(err).NotTo(HaveOccurred())
			volumeSts, err = utils.StsScale(ctx, c, volumeSts, 0)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, masterStsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, BeZero()))
			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, volumeStsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, BeZero()))

			By("scaling up to the original replicas")
			_, err = utils.StsScale(ctx, c, masterSts, masterOrigReplicas)
			Expect(err).NotTo(HaveOccurred())
			_, err = utils.StsScale(ctx, c, volumeSts, volumeOrigReplicas)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, masterStsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(masterOrigReplicas)))
			Eventually(func() (*appsv1.StatefulSet, error) {
				return c.AppsV1().StatefulSets(namespace).Get(ctx, volumeStsName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getAvailableReplicas, Equal(volumeOrigReplicas)))

			By("creating a job to download the file")
			downloadJobName := fmt.Sprintf("weed-download-%s", jobSuffix)
			err = createJob(ctx, c, downloadJobName, port, image, pvcName, kindDownload, fsGroup, runAsUser)
			Expect(err).NotTo(HaveOccurred())

			Eventually(func() (*batchv1.Job, error) {
				return c.BatchV1().Jobs(namespace).Get(ctx, downloadJobName, getOpts)
			}, timeout, PollingInterval).Should(WithTransform(getSucceededJobs, Equal(int32(1))))
		})
	})

	AfterEach(func() {
		cancel()
	})
})
