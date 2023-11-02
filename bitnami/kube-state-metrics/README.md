<!--- app-name: Kube State Metrics -->

# Kube State Metrics packaged by Bitnami

kube-state-metrics is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects.

[Overview of Kube State Metrics](https://github.com/kubernetes/kube-state-metrics)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kube-state-metrics
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## Introduction

This chart bootstraps [kube-state-metrics](https://github.com/bitnami/containers/tree/main/bitnami/kube-state-metrics) on [Kubernetes](https://kubernetes.io) using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

Looking to use Kube State Metrics in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kube-state-metrics
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys kube-state-metrics on the Kubernetes cluster in the default configuration. The [configuration](#configuration-and-installation-details) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                     | Description                                                                                                   | Value          |
| ------------------------ | ------------------------------------------------------------------------------------------------------------- | -------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                          | `""`           |
| `nameOverride`           | String to partially override `kube-state-metrics.name` template with a string (will prepend the release name) | `""`           |
| `fullnameOverride`       | String to fully override `kube-state-metrics.fullname` template with a string                                 | `""`           |
| `namespaceOverride`      | String to fully override common.names.namespace                                                               | `""`           |
| `commonLabels`           | Add labels to all the deployed resources                                                                      | `{}`           |
| `commonAnnotations`      | Add annotations to all the deployed resources                                                                 | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                             | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                       | `false`        |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)                                    | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                                       | `["infinity"]` |

### kube-state-metrics parameters

| Name                                                | Description                                                                                                                                                        | Value                                |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------ |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                        | `[]`                                 |
| `rbac.create`                                       | Whether to create & use RBAC resources or not                                                                                                                      | `true`                               |
| `rbac.pspEnabled`                                   | Whether to create a PodSecurityPolicy and bound it with RBAC. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later | `true`                               |
| `serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                               | `true`                               |
| `serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                | `""`                                 |
| `serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                     | `true`                               |
| `serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                         | `{}`                                 |
| `image.registry`                                    | kube-state-metrics image registry                                                                                                                                  | `REGISTRY_NAME`                      |
| `image.repository`                                  | kube-state-metrics image repository                                                                                                                                | `REPOSITORY_NAME/kube-state-metrics` |
| `image.digest`                                      | kube-state-metrics image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                 | `""`                                 |
| `image.pullPolicy`                                  | kube-state-metrics image pull policy                                                                                                                               | `IfNotPresent`                       |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                   | `[]`                                 |
| `extraArgs`                                         | Additional command line arguments to pass to kube-state-metrics                                                                                                    | `{}`                                 |
| `command`                                           | Override default container command (useful when using custom images)                                                                                               | `[]`                                 |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                  | `[]`                                 |
| `lifecycleHooks`                                    | for the kube-state-metrics container(s) to automate configuration before or after startup                                                                          | `{}`                                 |
| `extraEnvVars`                                      | Array with extra environment variables to add to kube-state-metrics nodes                                                                                          | `[]`                                 |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for kube-state-metrics pod(s)                                                                                 | `""`                                 |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for kube-state-metrics pod(s)                                                                                    | `""`                                 |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the kube-state-metrics pod(s)                                                                              | `[]`                                 |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the kube-state-metrics container(s)                                                                   | `[]`                                 |
| `sidecars`                                          | Add additional sidecar containers to the kube-state-metrics pod(s)                                                                                                 | `[]`                                 |
| `initContainers`                                    | Add additional init containers to the kube-state-metrics pod(s)                                                                                                    | `[]`                                 |
| `namespaces`                                        | Comma-separated list of namespaces to be enabled. Defaults to all namespaces. Evaluated as a template.                                                             | `""`                                 |
| `kubeResources.certificatesigningrequests`          | Enable the `certificatesigningrequests` resource                                                                                                                   | `true`                               |
| `kubeResources.configmaps`                          | Enable the `configmaps` resource                                                                                                                                   | `true`                               |
| `kubeResources.cronjobs`                            | Enable the `cronjobs` resource                                                                                                                                     | `true`                               |
| `kubeResources.daemonsets`                          | Enable the `daemonsets` resource                                                                                                                                   | `true`                               |
| `kubeResources.deployments`                         | Enable the `deployments` resource                                                                                                                                  | `true`                               |
| `kubeResources.endpoints`                           | Enable the `endpoints` resource                                                                                                                                    | `true`                               |
| `kubeResources.horizontalpodautoscalers`            | Enable the `horizontalpodautoscalers` resource                                                                                                                     | `true`                               |
| `kubeResources.ingresses`                           | Enable the `ingresses` resource                                                                                                                                    | `true`                               |
| `kubeResources.jobs`                                | Enable the `jobs` resource                                                                                                                                         | `true`                               |
| `kubeResources.limitranges`                         | Enable the `limitranges` resource                                                                                                                                  | `true`                               |
| `kubeResources.mutatingwebhookconfigurations`       | Enable the `mutatingwebhookconfigurations` resource                                                                                                                | `true`                               |
| `kubeResources.namespaces`                          | Enable the `namespaces` resource                                                                                                                                   | `true`                               |
| `kubeResources.networkpolicies`                     | Enable the `networkpolicies` resource                                                                                                                              | `true`                               |
| `kubeResources.nodes`                               | Enable the `nodes` resource                                                                                                                                        | `true`                               |
| `kubeResources.persistentvolumeclaims`              | Enable the `persistentvolumeclaims` resource                                                                                                                       | `true`                               |
| `kubeResources.persistentvolumes`                   | Enable the `persistentvolumes` resource                                                                                                                            | `true`                               |
| `kubeResources.poddisruptionbudgets`                | Enable the `poddisruptionbudgets` resource                                                                                                                         | `true`                               |
| `kubeResources.pods`                                | Enable the `pods` resource                                                                                                                                         | `true`                               |
| `kubeResources.replicasets`                         | Enable the `replicasets` resource                                                                                                                                  | `true`                               |
| `kubeResources.replicationcontrollers`              | Enable the `replicationcontrollers` resource                                                                                                                       | `true`                               |
| `kubeResources.resourcequotas`                      | Enable the `resourcequotas` resource                                                                                                                               | `true`                               |
| `kubeResources.secrets`                             | Enable the `secrets` resource                                                                                                                                      | `true`                               |
| `kubeResources.services`                            | Enable the `services` resource                                                                                                                                     | `true`                               |
| `kubeResources.statefulsets`                        | Enable the `statefulsets` resource                                                                                                                                 | `true`                               |
| `kubeResources.storageclasses`                      | Enable the `storageclasses` resource                                                                                                                               | `true`                               |
| `kubeResources.verticalpodautoscalers`              | Enable the `verticalpodautoscalers` resource                                                                                                                       | `false`                              |
| `kubeResources.validatingwebhookconfigurations`     | Enable the `validatingwebhookconfigurations` resource                                                                                                              | `false`                              |
| `kubeResources.volumeattachments`                   | Enable the `volumeattachments` resource                                                                                                                            | `true`                               |
| `podSecurityContext.enabled`                        | Enabled kube-state-metrics pods' Security Context                                                                                                                  | `true`                               |
| `podSecurityContext.fsGroup`                        | Set kube-state-metrics pod's Security Context fsGroup                                                                                                              | `1001`                               |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                               | `true`                               |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                         | `1001`                               |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                      | `true`                               |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                        | `false`                              |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                            | `false`                              |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                          | `false`                              |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                 | `["ALL"]`                            |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                   | `RuntimeDefault`                     |
| `service.type`                                      | Kubernetes service type                                                                                                                                            | `ClusterIP`                          |
| `service.ports.http`                                | kube-state-metrics service port                                                                                                                                    | `8080`                               |
| `service.nodePorts.http`                            | Specify the nodePort value for the LoadBalancer and NodePort service types.                                                                                        | `""`                                 |
| `service.clusterIP`                                 | Specific cluster IP when service type is cluster IP. Use `None` for headless service                                                                               | `""`                                 |
| `service.loadBalancerIP`                            | `loadBalancerIP` if service type is `LoadBalancer`                                                                                                                 | `""`                                 |
| `service.loadBalancerSourceRanges`                  | Address that are allowed when svc is `LoadBalancer`                                                                                                                | `[]`                                 |
| `service.externalTrafficPolicy`                     | kube-state-metrics service external traffic policy                                                                                                                 | `Cluster`                            |
| `service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                     | `[]`                                 |
| `service.annotations`                               | Additional annotations for kube-state-metrics service                                                                                                              | `{}`                                 |
| `service.labels`                                    | Additional labels for kube-state-metrics service                                                                                                                   | `{}`                                 |
| `service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                               | `None`                               |
| `service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                        | `{}`                                 |
| `hostNetwork`                                       | Enable hostNetwork mode                                                                                                                                            | `false`                              |
| `priorityClassName`                                 | Priority class assigned to the Pods                                                                                                                                | `""`                                 |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                     | `""`                                 |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the kube-state-metrics pod needs to terminate gracefully                                                                             | `""`                                 |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                     | `[]`                                 |
| `resources.limits`                                  | The resources limits for the container                                                                                                                             | `{}`                                 |
| `resources.requests`                                | The requested resources for the container                                                                                                                          | `{}`                                 |
| `replicaCount`                                      | Desired number of controller pods                                                                                                                                  | `1`                                  |
| `podLabels`                                         | Pod labels                                                                                                                                                         | `{}`                                 |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                    | `{}`                                 |
| `updateStrategy`                                    | Allows setting of `RollingUpdate` strategy                                                                                                                         | `{}`                                 |
| `minReadySeconds`                                   | How many seconds a pod needs to be ready before killing the next, during update                                                                                    | `0`                                  |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                | `""`                                 |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                           | `soft`                               |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                          | `""`                                 |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                             | `""`                                 |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                          | `[]`                                 |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                        | `{}`                                 |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                     | `{}`                                 |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                     | `[]`                                 |
| `livenessProbe.enabled`                             | Turn on and off liveness probe                                                                                                                                     | `true`                               |
| `livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated                                                                                                                           | `120`                                |
| `livenessProbe.periodSeconds`                       | How often to perform the probe                                                                                                                                     | `10`                                 |
| `livenessProbe.timeoutSeconds`                      | When the probe times out                                                                                                                                           | `5`                                  |
| `livenessProbe.failureThreshold`                    | Minimum consecutive failures for the probe                                                                                                                         | `6`                                  |
| `livenessProbe.successThreshold`                    | Minimum consecutive successes for the probe                                                                                                                        | `1`                                  |
| `readinessProbe.enabled`                            | Turn on and off readiness probe                                                                                                                                    | `true`                               |
| `readinessProbe.initialDelaySeconds`                | Delay before readiness probe is initiated                                                                                                                          | `30`                                 |
| `readinessProbe.periodSeconds`                      | How often to perform the probe                                                                                                                                     | `10`                                 |
| `readinessProbe.timeoutSeconds`                     | When the probe times out                                                                                                                                           | `5`                                  |
| `readinessProbe.failureThreshold`                   | Minimum consecutive failures for the probe                                                                                                                         | `6`                                  |
| `readinessProbe.successThreshold`                   | Minimum consecutive successes for the probe                                                                                                                        | `1`                                  |
| `startupProbe.enabled`                              | Turn on and off startup probe                                                                                                                                      | `false`                              |
| `startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated                                                                                                                            | `30`                                 |
| `startupProbe.periodSeconds`                        | How often to perform the probe                                                                                                                                     | `10`                                 |
| `startupProbe.timeoutSeconds`                       | When the probe times out                                                                                                                                           | `5`                                  |
| `startupProbe.failureThreshold`                     | Minimum consecutive failures for the probe                                                                                                                         | `6`                                  |
| `startupProbe.successThreshold`                     | Minimum consecutive successes for the probe                                                                                                                        | `1`                                  |
| `customStartupProbe`                                | Custom liveness probe for the Web component                                                                                                                        | `{}`                                 |
| `customLivenessProbe`                               | Custom liveness probe for the Web component                                                                                                                        | `{}`                                 |
| `customReadinessProbe`                              | Custom readiness probe for the Web component                                                                                                                       | `{}`                                 |
| `serviceMonitor.enabled`                            | Creates a ServiceMonitor to monitor kube-state-metrics                                                                                                             | `false`                              |
| `serviceMonitor.namespace`                          | Namespace in which Prometheus is running                                                                                                                           | `""`                                 |
| `serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in prometheus.                                                                                  | `""`                                 |
| `serviceMonitor.interval`                           | Scrape interval (use by default, falling back to Prometheus' default)                                                                                              | `""`                                 |
| `serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                            | `""`                                 |
| `serviceMonitor.selector`                           | ServiceMonitor selector labels                                                                                                                                     | `{}`                                 |
| `serviceMonitor.honorLabels`                        | Honor metrics labels                                                                                                                                               | `false`                              |
| `serviceMonitor.relabelings`                        | ServiceMonitor relabelings                                                                                                                                         | `[]`                                 |
| `serviceMonitor.metricRelabelings`                  | ServiceMonitor metricRelabelings                                                                                                                                   | `[]`                                 |
| `serviceMonitor.labels`                             | Extra labels for the ServiceMonitor                                                                                                                                | `{}`                                 |
| `serviceMonitor.extraParameters`                    | Any extra parameter to be added to the endpoint configured in the ServiceMonitor                                                                                   | `{}`                                 |
| `serviceMonitor.sampleLimit`                        | Per-scrape limit on number of scraped samples that will be accepted.                                                                                               | `""`                                 |
| `selfMonitor.enabled`                               | Creates a selfMonitor to monitor kube-state-metrics itself                                                                                                         | `false`                              |
| `selfMonitor.telemetryPort`                         | Kube-state-metrics telemetry Port                                                                                                                                  | `8081`                               |
| `selfMonitor.telemetryNodePort`                     | Kube-state-metrics Node Port                                                                                                                                       | `""`                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example the following command sets the `replicas` of the kube-state-metrics Pods to `2`.

```console
helm install my-release --set replicas=2 oci://REGISTRY_NAME/REPOSITORY_NAME/kube-state-metrics
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/kube-state-metrics
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/apps/kube-state-metrics/configuration/configure-sidecar-init-containers/).

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/kube-state-metrics
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 3.0.0

This major release renames several values in this chart and adds missing features, in order to be aligned with the rest of the assets in the Bitnami charts repository.

Affected values:

- `service.port` was renamed as `service.ports.metrics`.
- `service.nodePort` was renamed as `service.nodePorts.metrics`.
- `securityContext` was split in `podSecurityContext` and `containerSecurityContext`.
- Removed unused value `rbac.apiVersion`.

### To 2.0.0

This version updates kube-state-metrics to its new major, 2.0.0. There have been some value's name changes to acommodate to the naming used in 2.0.0:

- `.Values.namespace` -> `.Values.namespaces`
- `.Values.collectors` -> `.Values.kubeResources`

For more information, please refer to [kube-state-metrics 2 release notes](https://kubernetes.io/blog/2021/04/13/kube-state-metrics-v-2-0/).

### To 1.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 1.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/kube-state-metrics/administration/upgrade-helm3/).

## License

Copyright &copy; 2023 VMware, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.