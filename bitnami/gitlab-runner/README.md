<!--- app-name: Gitlab Runner -->

# Bitnami package for Gitlab Runner

Gitlab Runner is an auxiliary application for Gitlab installations. Written in Go, it allows to run CI/CD jobs and send the results back to Gitlab.

[Overview of Gitlab Runner](https://gitlab.com/gitlab-org/gitlab-runner/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/gitlab-runner
```

Looking to use Gitlab Runner in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [Gitlab Runner](https://github.com/bitnami/containers/tree/main/bitnami/gitlab-runner) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/gitlab-runner
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Gitlab Runner on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Connect to Gitlab instance

Gitlab Runner requires connecting to an existing Gitlab installation. Follow these steps in your Gitlab installation:

- Create a runner in the [CI/CD admin panel](https://docs.gitlab.com/ci/runners/runners_scope/#create-an-instance-runner-with-a-runner-authentication-token)
- Obtain the registration token
- Deploy Gitlab Runner setting the `runnerToken` (or provide a secret with `existingSecret`) value with the previously obtained token, as well as the `gitlabUrl` value with the URL of the Gitlab instance.
- Check the registration status in your Gitlab instance.

### Setting the runner configuration

The Gitlab Runner chart deploys a runner with `kubernetes` as the executor. It is possible to modify the default configuration by changing the `runners.config` value. In the example below we change the default job image:

```yaml
runners:
  config: |
    [[runners]]
      [runners.kubernetes]
        namespace = "{{ include "common.names.namespace" . }}"
        image = "bitnami/os-shell"
```

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to true. This will expose the Gitlab Runner native Prometheus endpoint in a `metrics` service, which can be configured under the `metrics.service` section. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Enable RBAC security

In order to enable Role-Based Access Control (RBAC) for Gitlab Runner, use the following parameter: `rbac.create=true`.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Ingress

This chart provides support for Ingress resources for the session server. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `sessionServer.ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `sessionServer.ingress.hostname` property can be used to set the host name. The `sessionServer.ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `sessionServer.ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `sessionServer.ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `sessionServer.ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `apiVersions`            | Override Kubernetes API versions reported by .Capabilities                                   | `[]`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                              | `""`            |
| `commonLabels`           | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations`      | Add annotations to all the deployed resources                                                | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)                   | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                      | `["infinity"]`  |

### Gitlab Runner parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                           |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `image.registry`                                    | Gitlab Runner image registry                                                                                                                                                                                      | `REGISTRY_NAME`                 |
| `image.repository`                                  | Gitlab Runner image repository                                                                                                                                                                                    | `REPOSITORY_NAME/gitlab-runner` |
| `image.digest`                                      | Gitlab Runner image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                     | `""`                            |
| `image.pullPolicy`                                  | Gitlab Runner image pull policy                                                                                                                                                                                   | `IfNotPresent`                  |
| `image.pullSecrets`                                 | Gitlab Runner image pull secrets                                                                                                                                                                                  | `[]`                            |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`                          |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                            |
| `replicaCount`                                      | Number of gitlab-runner nodes to deploy                                                                                                                                                                           | `1`                             |
| `gitlabUrl`                                         | GitLab Server URL (with protocol) to register the runner                                                                                                                                                          | `""`                            |
| `runnerToken`                                       | Token for adding new Runners to the GitLab Server                                                                                                                                                                 | `""`                            |
| `existingSecret`                                    | Name of a secret containing the runner token                                                                                                                                                                      | `""`                            |
| `existingCacheSecret`                               | Name of a secret containing the distributed cache credentials                                                                                                                                                     | `""`                            |
| `existingConfigMap`                                 | Name of a ConfigMap containing the configuration and scripts                                                                                                                                                      | `""`                            |
| `extraConfig`                                       | Append extra configuration to the default config file                                                                                                                                                             | `""`                            |
| `unregisterRunners`                                 | Unregister all runners before termination                                                                                                                                                                         | `true`                          |
| `existingCertsSecret`                               | Name of a secret containing custom certificates to connect to the Gitlab instance.                                                                                                                                | `""`                            |
| `concurrent`                                        | Maximum number of concurrent jobs                                                                                                                                                                                 | `10`                            |
| `shutdownTimeout`                                   | Time in seconds before a forceful shutdown                                                                                                                                                                        | `0`                             |
| `checkInterval`                                     | Time in seconds to check for Gitlab builds                                                                                                                                                                        | `3`                             |
| `logLevel`                                          | Runner logging level                                                                                                                                                                                              | `info`                          |
| `logFormat`                                         | Runner logging format                                                                                                                                                                                             | `runner`                        |
| `sentryDsn`                                         | Runner's Sentry DSN.                                                                                                                                                                                              | `""`                            |
| `connectionMaxAge`                                  | Maximum connection age for TLS keepalive connections.                                                                                                                                                             | `15m`                           |
| `preEntrypointScript`                               | Commands to execute prior to the entrypoint                                                                                                                                                                       | `""`                            |
| `updateStrategy.type`                               | Set up update strategy for gitlab-runner installation.                                                                                                                                                            | `RollingUpdate`                 |
| `autoscaling.vpa.enabled`                           | Enable VPA                                                                                                                                                                                                        | `false`                         |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                      | `{}`                            |
| `autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                    | `[]`                            |
| `autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                             | `{}`                            |
| `autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                             | `{}`                            |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod                                            | `Auto`                          |
| `autoscaling.hpa.enabled`                           | Enable autoscaling for operator                                                                                                                                                                                   | `false`                         |
| `autoscaling.hpa.minReplicas`                       | Minimum number of operator replicas                                                                                                                                                                               | `""`                            |
| `autoscaling.hpa.maxReplicas`                       | Maximum number of operator replicas                                                                                                                                                                               | `""`                            |
| `autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                 | `""`                            |
| `autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                              | `""`                            |
| `rbac.create`                                       | Enable RBAC authentication                                                                                                                                                                                        | `true`                          |
| `rbac.clusterWideAccess`                            | Allow runner cluster-wide access                                                                                                                                                                                  | `false`                         |
| `rbac.rules`                                        | Define list of rules to be added to the rbac role permissions                                                                                                                                                     | `[]`                            |
| `serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                              | `true`                          |
| `serviceAccount.name`                               | The name of the ServiceAccount to create                                                                                                                                                                          | `""`                            |
| `serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account                                                                                                                                                                   | `false`                         |
| `serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                        | `{}`                            |
| `containerPorts.metrics`                            | Port where gitlab-runner will expose metrics                                                                                                                                                                      | `9252`                          |
| `containerPorts.sessionServer`                      | Port where gitlab-runner will use the sessionServer                                                                                                                                                               | `8093`                          |
| `dnsPolicy`                                         | Default dnsPolicy setting                                                                                                                                                                                         | `ClusterFirst`                  |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                            |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                            |
| `lifecycleHooks`                                    | for the gitlab-runner container(s) to automate configuration before or after startup                                                                                                                              | `{}`                            |
| `extraEnvVars`                                      | Array with extra environment variables to add to gitlab-runner nodes                                                                                                                                              | `[]`                            |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for gitlab-runner nodes                                                                                                                                      | `""`                            |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for gitlab-runner nodes                                                                                                                                         | `""`                            |
| `extraArgs`                                         | Extra arguments to pass to gitlab-runner on start up                                                                                                                                                              | `[]`                            |
| `sidecars`                                          | Add additional sidecar containers to the gitlab-runner pod(s)                                                                                                                                                     | `[]`                            |
| `initContainers`                                    | Add additional init containers to the gitlab-runner pod(s)                                                                                                                                                        | `[]`                            |
| `podLabels`                                         | Pod labels                                                                                                                                                                                                        | `{}`                            |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                            |
| `priorityClassName`                                 | Priority class for pod scheduling                                                                                                                                                                                 | `""`                            |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                            |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the gitlab-runner pod needs to terminate gracefully                                                                                                                                 | `""`                            |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                            |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                          |
| `pdb.create`                                        | Create a PodDisruptionBudget                                                                                                                                                                                      | `true`                          |
| `pdb.minAvailable`                                  | Minimum available instances                                                                                                                                                                                       | `""`                            |
| `pdb.maxUnavailable`                                | Maximum unavailable instances                                                                                                                                                                                     | `""`                            |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                            |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`                            |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                            |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                            |
| `topologySpreadConstraints`                         | Topology spread constraints for pod                                                                                                                                                                               | `[]`                            |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                            |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                            |
| `networkPolicy.enabled`                             | Enable creation of NetworkPolicy resources                                                                                                                                                                        | `true`                          |
| `networkPolicy.allowExternal`                       | The Policy model to apply                                                                                                                                                                                         | `true`                          |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                   | `true`                          |
| `networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kubernetes components like kube-apiserver or kubelet (limit to your cluster settings to increase security)                                                                          | `[]`                            |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                            |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                            |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                            | `{}`                            |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                        | `{}`                            |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `small`                         |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                            |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                         |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `0`                             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                            |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`                             |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `3`                             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                             |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                          |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `0`                             |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                            |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`                             |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `3`                             |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                             |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                          |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `0`                             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                            |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                             |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`                             |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                             |
| `customStartupProbe`                                | Custom liveness probe for the Web component                                                                                                                                                                       | `{}`                            |
| `customLivenessProbe`                               | Custom Liveness probes for gitlab-runner                                                                                                                                                                          | `{}`                            |
| `customReadinessProbe`                              | Custom Readiness probes gitlab-runner                                                                                                                                                                             | `{}`                            |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                          |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                            |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                          |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                          |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                          |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                         |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                          |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                         |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                       |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                |
| `podSecurityContext.enabled`                        | Pod security context                                                                                                                                                                                              | `true`                          |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                        |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                            |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                            |
| `podSecurityContext.fsGroup`                        | Set Pod's Security Context fsGroup                                                                                                                                                                                | `1001`                          |
| `extraVolumes`                                      | Extra volumes                                                                                                                                                                                                     | `[]`                            |
| `extraVolumeMounts`                                 | Mount extra volume(s)                                                                                                                                                                                             | `[]`                            |
| `runners.config`                                    | configuration for the pods created by the runner                                                                                                                                                                  | `""`                            |
| `runners.configPath`                                | Absolute path for an existing runner configuration file (to be used with volumes/extraVolumes)                                                                                                                    | `""`                            |
| `runners.executor`                                  | Executor to be used by the runner                                                                                                                                                                                 | `kubernetes`                    |
| `runners.name`                                      | Name of the runner.                                                                                                                                                                                               | `""`                            |
| `runners.maximumTimeout`                            | Specify the maximum timeout (in seconds) that will be set for job when using this Runner                                                                                                                          | `""`                            |
| `runners.runUntagged`                               | Allow running jobs without tags                                                                                                                                                                                   | `true`                          |
| `runners.protected`                                 | Run only in protected branches                                                                                                                                                                                    | `true`                          |

### Session Server Parameters

| Name                                             | Description                                                                                                                      | Value                    |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `sessionServer.enabled`                          | Enable Session Server                                                                                                            | `false`                  |
| `sessionServer.sessionTimeout`                   | Session timeout in seconds                                                                                                       | `1800`                   |
| `sessionServer.service.type`                     | Session Server service type                                                                                                      | `ClusterIP`              |
| `sessionServer.service.ports.sessionServer`      | Session Server service port                                                                                                      | `9000`                   |
| `sessionServer.service.nodePorts.sessionServer`  | Node port for the Session Server                                                                                                 | `""`                     |
| `sessionServer.service.labels`                   | Service labels                                                                                                                   | `{}`                     |
| `sessionServer.service.clusterIP`                | Session Server service Cluster IP                                                                                                | `""`                     |
| `sessionServer.service.loadBalancerIP`           | Session Server service Load Balancer IP                                                                                          | `""`                     |
| `sessionServer.service.loadBalancerSourceRanges` | Session Server service Load Balancer sources                                                                                     | `[]`                     |
| `sessionServer.service.externalTrafficPolicy`    | Session Server service external traffic policy                                                                                   | `Cluster`                |
| `sessionServer.service.annotations`              | Additional custom annotations for Session Server service                                                                         | `{}`                     |
| `sessionServer.service.extraPorts`               | Extra ports to expose in Session Server service (normally used with the `sidecars` value)                                        | `[]`                     |
| `sessionServer.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `sessionServer.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `sessionServer.ingress.enabled`                  | Enable ingress record generation for Session Server                                                                              | `false`                  |
| `sessionServer.ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `sessionServer.ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `sessionServer.ingress.hostname`                 | Default host for the ingress record                                                                                              | `session-server.local`   |
| `sessionServer.ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `sessionServer.ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `sessionServer.ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `sessionServer.ingress.tls`                      | Enable TLS configuration for the host defined at `sessionServer.ingress.hostname` parameter                                      | `false`                  |
| `sessionServer.ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `sessionServer.ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `sessionServer.ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `sessionServer.ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `sessionServer.ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `sessionServer.ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `metrics.enabled`                                | Enable the export of Prometheus metrics                                                                                          | `false`                  |
| `metrics.service.type`                           | Session Server service type                                                                                                      | `ClusterIP`              |
| `metrics.service.ports.metrics`                  | Session Server service http port                                                                                                 | `9252`                   |
| `metrics.service.nodePorts.metrics`              | Node port for HTTP                                                                                                               | `""`                     |
| `metrics.service.labels`                         | Service labels                                                                                                                   | `{}`                     |
| `metrics.service.clusterIP`                      | Session Server service Cluster IP                                                                                                | `""`                     |
| `metrics.service.loadBalancerIP`                 | Session Server service Load Balancer IP                                                                                          | `""`                     |
| `metrics.service.loadBalancerSourceRanges`       | Session Server service Load Balancer sources                                                                                     | `[]`                     |
| `metrics.service.externalTrafficPolicy`          | Session Server service external traffic policy                                                                                   | `Cluster`                |
| `metrics.service.annotations`                    | Additional custom annotations for Session Server service                                                                         | `{}`                     |
| `metrics.service.extraPorts`                     | Extra ports to expose in Session Server service (normally used with the `sidecars` value)                                        | `[]`                     |
| `metrics.service.sessionAffinity`                | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `metrics.service.sessionAffinityConfig`          | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `metrics.serviceMonitor.enabled`                 | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                           | `false`                  |
| `metrics.serviceMonitor.namespace`               | Namespace in which Prometheus is running                                                                                         | `""`                     |
| `metrics.serviceMonitor.annotations`             | Additional custom annotations for the ServiceMonitor                                                                             | `{}`                     |
| `metrics.serviceMonitor.labels`                  | Extra labels for the ServiceMonitor                                                                                              | `{}`                     |
| `metrics.serviceMonitor.jobLabel`                | The name of the label on the target service to use as the job name in Prometheus                                                 | `""`                     |
| `metrics.serviceMonitor.honorLabels`             | honorLabels chooses the metric's labels on collisions with target labels                                                         | `false`                  |
| `metrics.serviceMonitor.interval`                | Interval at which metrics should be scraped.                                                                                     | `""`                     |
| `metrics.serviceMonitor.scrapeTimeout`           | Timeout after which the scrape is ended                                                                                          | `""`                     |
| `metrics.serviceMonitor.metricRelabelings`       | Specify additional relabeling of metrics                                                                                         | `[]`                     |
| `metrics.serviceMonitor.relabelings`             | Specify general relabeling                                                                                                       | `[]`                     |
| `metrics.serviceMonitor.selector`                | Prometheus instance selector labels                                                                                              | `{}`                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set rbac.create=true oci://REGISTRY_NAME/REPOSITORY_NAME/gitlab-runner
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command enables RBAC authentication.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/gitlab-runner
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/gitlab-runner/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.