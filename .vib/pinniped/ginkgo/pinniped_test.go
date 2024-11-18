// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

package integration

import (

	// For client auth plugins

	"context"
	"fmt"
	"time"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cv1 "k8s.io/client-go/kubernetes/typed/core/v1"

	_ "k8s.io/client-go/plugin/pkg/client/auth"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("Pinniped:", func() {
	var coreclient cv1.CoreV1Interface
	var ctx context.Context

	BeforeEach(func() {
		coreclient = cv1.NewForConfigOrDie(clusterConfigOrDie())
		ctx = context.Background()
	})

	When("a testing pod is created", func() {
		var testingPod *v1.Pod

		BeforeEach(func() {
			testingPod = createTestingPodOrDie(ctx, coreclient)

			// We need to make sure the pod is out of the "ContainerCreating" phase
			// to avoid errors when checking its logs
			isPodRunning, err := retry("isPodRunning", 5, 3*time.Second, func() (bool, error) {
				return isPodRunning(ctx, coreclient, testingPod.GetName())
			})
			if err != nil {
				panic(err.Error())
			}
			Expect(isPodRunning).To(BeTrue())
		})

		AfterEach(func() {
			// Not need to panic here if failed, the cluster is expected to clean up with the undeployment
			coreclient.Pods(*namespace).Delete(ctx, testingPod.GetName(), metav1.DeleteOptions{})
		})

		Describe("the logs show that", func() {
			var cliLogs []string

			BeforeEach(func() {
				pattern := "Script finished correctly"

				patternFound, err := retry("containerLogsContainPattern", 5, 5*time.Second, func() (bool, error) {
					return containerLogsContainPattern(ctx, coreclient, testingPod.GetName(), "vib-cli", pattern)
				})
				if err != nil {
					panic(err.Error())
				}
				cliPods := getPodsByLabelOrDie(ctx, coreclient, "app=vib-cli")
				cliLogs = getContainerLogsOrDie(ctx, coreclient, cliPods.Items[0].GetName(), "vib-cli")

				// Debug code left as is, given configuration complexity
				if !patternFound {
					fmt.Println("##### CLI LOGS: #####")
					fmt.Println(cliLogs)
					fmt.Println("###############")

					openldapPods := getPodsByLabelOrDie(ctx, coreclient, "app=openldap")
					openldapLogs := getContainerLogsOrDie(ctx, coreclient, openldapPods.Items[0].GetName(), "openldap")
					fmt.Println("##### OPENLDAP LOGS: #####")
					fmt.Println(openldapLogs)
					fmt.Println("###############")

					supervisorPods := getPodsByLabelOrDie(ctx, coreclient, "app.kubernetes.io/component=supervisor")
					supervisorLogs := getContainerLogsOrDie(ctx, coreclient, supervisorPods.Items[0].GetName(), "supervisor")
					fmt.Println("##### SUPERVISOR LOGS: #####")
					fmt.Println(supervisorLogs)
					fmt.Println("###############")
				}
				Expect(patternFound).To(BeTrue())
			})

			It("the script was executed entirely", func() {
				patternFound, _ := containsPattern(cliLogs, "Script finished correctly")
				if !patternFound {
					fmt.Println("##### CLI LOGS: #####")
					fmt.Println(cliLogs)
					fmt.Println("###############")
				}
				Expect(patternFound).To(BeTrue())
			})

			It("the pinniped cli produced the kubeconfig", func() {
				patternFound, _ := containsPattern(cliLogs, "connection to the cluster")
				if !patternFound {
					fmt.Println("##### CLI LOGS: #####")
					fmt.Println(cliLogs)
					fmt.Println("###############")
				}
				Expect(patternFound).To(BeTrue())
			})

			It("the pinniped cli configured the cluster auth", func() {
				patternFound, _ := containsPattern(cliLogs, "Username: "+*authUser)
				if !patternFound {
					fmt.Println("##### CLI LOGS: #####")
					fmt.Println(cliLogs)
					fmt.Println("###############")
				}
				Expect(patternFound).To(BeTrue())
			})
		})
	})
})
