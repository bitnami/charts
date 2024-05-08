<!--- app-name: Kubernetes Event Exporter -->

# Bitnami package for Kubernetes Event Exporter

Kubernetes Event Exporter makes it easy to export Kubernetes events to other tools, thereby enabling better event observability, custom alerts and aggregation.

[Overview of Kubernetes Event Exporter](https://github.com/resmoio/kubernetes-event-exporter)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/kubernetes-event-exporter
```

Looking to use Kubernetes Event Exporter in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Kubernetes Event Exporter](https://github.com/resmoio/kubernetes-event-exporter) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kubernetes-event-exporter
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Kubernetes Event Exporter on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list` or `helm ls --all-namespaces`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                                              | Value          |
| ------------------------ | -------------------------------------------------------------------------------------------------------- | -------------- |
| `kubeVersion`            | Override Kubernetes version                                                                              | `""`           |
| `nameOverride`           | String to partially override kubernetes-event-exporter.fullname include (will maintain the release name) | `""`           |
| `fullnameOverride`       | String to fully override kubernetes-event-exporter.fullname template                                     | `""`           |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                               | `{}`           |
| `commonLabels`           | Labels to add to all deployed objects                                                                    | `{}`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                  | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                     | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                        | `["infinity"]` |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template)                              | `[]`           |

### Kubernetes Event Exporter parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                                       |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `replicaCount`                                      | Desired number of pod replicas                                                                                                                                                                                    | `1`                                         |
| `revisionHistoryLimit`                              | Desired number of old ReplicaSets to retain                                                                                                                                                                       | `10`                                        |
| `containerPorts.http`                               | HTTP container port                                                                                                                                                                                               | `2112`                                      |
| `extraContainerPorts`                               | Optionally specify extra list of additional port-mappings for the container                                                                                                                                       | `[]`                                        |
| `image.registry`                                    | Container image registry                                                                                                                                                                                          | `REGISTRY_NAME`                             |
| `image.repository`                                  | Container image name                                                                                                                                                                                              | `REPOSITORY_NAME/kubernetes-event-exporter` |
| `image.digest`                                      | Container image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                         | `""`                                        |
| `image.pullPolicy`                                  | Container image pull policy                                                                                                                                                                                       | `IfNotPresent`                              |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                                        |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`                                      |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                                        |
| `config.logLevel`                                   | Verbosity of the logs (options: `fatal`, `error`, `warn`, `info` or `debug`)                                                                                                                                      | `debug`                                     |
| `config.logFormat`                                  | How the logs are formatted. Allowed values: `pretty` or `json`                                                                                                                                                    | `pretty`                                    |
| `config.receivers`                                  | Array containing event receivers                                                                                                                                                                                  | `[]`                                        |
| `config.route.routes`                               | Array containing event route configuration                                                                                                                                                                        | `[]`                                        |
| `rbac.create`                                       | Create the RBAC roles for API accessibility                                                                                                                                                                       | `true`                                      |
| `rbac.rules`                                        | List of rules for the cluster role                                                                                                                                                                                | `[]`                                        |
| `serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                              | `true`                                      |
| `serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                               | `""`                                        |
| `serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                    | `false`                                     |
| `serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                        | `{}`                                        |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                                        |
| `podLabels`                                         | Pod labels                                                                                                                                                                                                        | `{}`                                        |
| `podSecurityContext.enabled`                        | Enable security context                                                                                                                                                                                           | `true`                                      |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                                    |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                                        |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                                        |
| `podSecurityContext.fsGroup`                        | Group ID for the container                                                                                                                                                                                        | `1001`                                      |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                                      |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                                        |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                                      |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                                      |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                                      |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                                     |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                                      |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                                     |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                                   |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                            |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                                        |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                                        |
| `lifecycleHooks`                                    | Lifecycle for the container to automate configuration before or after startup                                                                                                                                     | `{}`                                        |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                                      |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                                        |
| `networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                               | `true`                                      |
| `networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                | `[]`                                        |
| `networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                        | `true`                                      |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                   | `true`                                      |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                                        |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                                        |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                            | `{}`                                        |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                        | `{}`                                        |
| `livenessProbe.enabled`                             | Enable livenessProbe on Kubernetes event exporter container                                                                                                                                                       | `true`                                      |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `5`                                         |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `5`                                         |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `2`                                         |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `5`                                         |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                                         |
| `readinessProbe.enabled`                            | Enable readinessProbe on Kubernetes event exporter container                                                                                                                                                      | `true`                                      |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `5`                                         |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `5`                                         |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `2`                                         |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `1`                                         |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                                         |
| `startupProbe.enabled`                              | Enable startupProbe on Kubernetes event exporter container                                                                                                                                                        | `false`                                     |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `40`                                        |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                                        |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `15`                                        |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `15`                                        |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                                         |
| `customStartupProbe`                                | Configure startup probe for Kubernetes event exporter pod                                                                                                                                                         | `{}`                                        |
| `customLivenessProbe`                               | Configure liveness probe for Kubernetes event exporter pod                                                                                                                                                        | `{}`                                        |
| `customReadinessProbe`                              | Configure readiness probe for Kubernetes event exporter pod                                                                                                                                                       | `{}`                                        |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                                        |
| `priorityClassName`                                 | Set Priority Class Name to allow priority control over other pods                                                                                                                                                 | `""`                                        |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                                        |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                                        |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                                        |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                                        |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                                      |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                                        |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`                                        |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                                        |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                                        |
| `updateStrategy.type`                               | Deployment strategy type.                                                                                                                                                                                         | `RollingUpdate`                             |
| `extraEnvVars`                                      | Array containing extra env vars to be added to all containers                                                                                                                                                     | `[]`                                        |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars to be added to all containers                                                                                                                                                 | `""`                                        |
| `extraEnvVarsSecret`                                | Secret containing extra env vars to be added to all containers                                                                                                                                                    | `""`                                        |
| `extraVolumeMounts`                                 | Array to add extra mounts (normally used with extraVolumes)                                                                                                                                                       | `[]`                                        |
| `extraVolumes`                                      | Array to add extra volumes                                                                                                                                                                                        | `[]`                                        |
| `initContainers`                                    | Attach additional init containers to pods                                                                                                                                                                         | `[]`                                        |
| `sidecars`                                          | Add additional sidecar containers to pods                                                                                                                                                                         | `[]`                                        |
| `metrics.enabled`                                   | Enable exposing  statistics                                                                                                                                                                                       | `false`                                     |
| `metrics.service.ports.http`                        | Metrics service HTTP port                                                                                                                                                                                         | `2112`                                      |
| `metrics.service.annotations`                       | Annotations for enabling prometheus to access the metrics endpoints                                                                                                                                               | `{}`                                        |
| `metrics.serviceMonitor.enabled`                    | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                                                                                                      | `false`                                     |
| `metrics.serviceMonitor.port`                       | Metrics service HTTP port                                                                                                                                                                                         | `http`                                      |
| `metrics.serviceMonitor.endpoints`                  | The endpoint configuration of the ServiceMonitor. Path is mandatory. Interval, timeout and labellings can be overwritten.                                                                                         | `[]`                                        |
| `metrics.serviceMonitor.path`                       | Metrics service HTTP path. Deprecated: Use @param metrics.serviceMonitor.endpoints instead                                                                                                                        | `""`                                        |
| `metrics.serviceMonitor.namespace`                  | Namespace which Prometheus is running in                                                                                                                                                                          | `""`                                        |
| `metrics.serviceMonitor.interval`                   | Interval at which metrics should be scraped                                                                                                                                                                       | `30s`                                       |
| `metrics.serviceMonitor.scrapeTimeout`              | Specify the timeout after which the scrape is ended                                                                                                                                                               | `""`                                        |
| `metrics.serviceMonitor.labels`                     | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                                                                                                             | `{}`                                        |
| `metrics.serviceMonitor.selector`                   | Prometheus instance selector labels                                                                                                                                                                               | `{}`                                        |
| `metrics.serviceMonitor.relabelings`                | RelabelConfigs to apply to samples before scraping                                                                                                                                                                | `[]`                                        |
| `metrics.serviceMonitor.metricRelabelings`          | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                         | `[]`                                        |
| `metrics.serviceMonitor.honorLabels`                | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                          | `false`                                     |
| `metrics.serviceMonitor.jobLabel`                   | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                 | `""`                                        |
| `metrics.prometheusRule.enabled`                    | Create PrometheusRule Resource for scraping metrics using PrometheusOperator                                                                                                                                      | `false`                                     |
| `metrics.prometheusRule.namespace`                  | Namespace which Prometheus is running in                                                                                                                                                                          | `""`                                        |
| `metrics.prometheusRule.labels`                     | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                                                                                             | `{}`                                        |
| `metrics.prometheusRule.groups`                     | Groups, containing the alert rules.                                                                                                                                                                               | `[]`                                        |

### Autoscaling

| Name                                  | Description                                                                                    | Value   |
| ------------------------------------- | ---------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.vpa.enabled`             | Enable VPA                                                                                     | `false` |
| `autoscaling.vpa.annotations`         | Annotations for VPA resource                                                                   | `{}`    |
| `autoscaling.vpa.recommenders`        | Recommender responsible for generating recommendation for the object.                          | `[]`    |
| `autoscaling.vpa.controlledResources` | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory | `[]`    |
| `autoscaling.vpa.maxAllowed`          | VPA Max allowed resources for the pod                                                          | `{}`    |
| `autoscaling.vpa.minAllowed`          | VPA Min allowed resources for the pod                                                          | `{}`    |

### VPA update policy

| Name                                       | Description                                                                                                                                                            | Value  |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `autoscaling.vpa.updatePolicy.minReplicas` | Specifies minimal number of replicas which need to be alive for VPA Updater to attempt pod eviction                                                                    | `1`    |
| `autoscaling.vpa.updatePolicy.updateMode`  | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto` |

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.0.0

This major bump changes the following security defaults:

- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.