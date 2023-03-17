<!--- app-name: Prometheus -->

# Prometheus packaged by Bitnami

Prometheus is an open source monitoring and alerting system. It enables sysadmins to monitor their infrastructures by collecting metrics from configured targets at given intervals.

[Overview of Prometheus](https://prometheus.io/")

## TL;DR

```console
helm repo add my-repo https://charts.bitnami.com/bitnami
helm install my-release my-repo/prometheus
```

## Introduction

TODO

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release my-repo/prometheus
```

The command deploys Prometheus on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

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

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Prometheus Parameters

| Name                                              | Description                                                                                                                                           | Value                  |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `image.registry`                                  | Prometheus image registry                                                                                                                             | `docker.io`            |
| `image.repository`                                | Prometheus image repository                                                                                                                           | `bitnami/prometheus`   |
| `image.tag`                                       | Prometheus image tag (immutable tags are recommended)                                                                                                 | `2.42.0-debian-11-r13` |
| `image.digest`                                    | Prometheus image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                   |
| `image.pullPolicy`                                | Prometheus image pull policy                                                                                                                          | `IfNotPresent`         |
| `image.pullSecrets`                               | Prometheus image pull secrets                                                                                                                         | `[]`                   |
| `configuration`                                   | Promethus configuration. This content will be stored in the the prometheus.yaml file and the content can be a template.                               | `{}`                   |
| `replicaCount`                                    | Number of Prometheus replicas to deploy                                                                                                               | `1`                    |
| `containerPorts.http`                             | Prometheus HTTP container port                                                                                                                        | `9090`                 |
| `containerPorts.https`                            | Prometheus HTTPS container port                                                                                                                       | `443`                  |
| `livenessProbe.enabled`                           | Enable livenessProbe on Prometheus containers                                                                                                         | `true`                 |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                                               | `5`                    |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                                                      | `20`                   |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                                                     | `3`                    |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                                                   | `3`                    |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                                                   | `1`                    |
| `readinessProbe.enabled`                          | Enable readinessProbe on Prometheus containers                                                                                                        | `true`                 |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                                              | `5`                    |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                                                     | `10`                   |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                                                    | `2`                    |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                                                  | `5`                    |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                                                  | `1`                    |
| `startupProbe.enabled`                            | Enable startupProbe on Prometheus containers                                                                                                          | `false`                |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                                                | `2`                    |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                                                       | `5`                    |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                                                      | `2`                    |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                                                    | `10`                   |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                                                    | `1`                    |
| `customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                                                   | `{}`                   |
| `customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                                                  | `{}`                   |
| `customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                                                    | `{}`                   |
| `resources.limits`                                | The resources limits for the Prometheus containers                                                                                                    | `{}`                   |
| `resources.requests`                              | The requested resources for the Prometheus containers                                                                                                 | `{}`                   |
| `podSecurityContext.enabled`                      | Enabled Prometheus pods' Security Context                                                                                                             | `true`                 |
| `podSecurityContext.fsGroup`                      | Set Prometheus pod's Security Context fsGroup                                                                                                         | `1001`                 |
| `containerSecurityContext.enabled`                | Enabled Prometheus containers' Security Context                                                                                                       | `true`                 |
| `containerSecurityContext.runAsUser`              | Set Prometheus containers' Security Context runAsUser                                                                                                 | `1001`                 |
| `containerSecurityContext.runAsNonRoot`           | Set Prometheus containers' Security Context runAsNonRoot                                                                                              | `true`                 |
| `containerSecurityContext.readOnlyRootFilesystem` | Set Prometheus containers' Security Context runAsNonRoot                                                                                              | `false`                |
| `existingConfigmap`                               | The name of an existing ConfigMap with your custom configuration for Prometheus                                                                       | `""`                   |
| `existingConfigmapKey`                            | The name of the key with the Prometheus config file                                                                                                   | `""`                   |
| `command`                                         | Override default container command (useful when using custom images)                                                                                  | `[]`                   |
| `args`                                            | Override default container args (useful when using custom images)                                                                                     | `[]`                   |
| `hostAliases`                                     | Prometheus pods host aliases                                                                                                                          | `[]`                   |
| `podLabels`                                       | Extra labels for Prometheus pods                                                                                                                      | `{}`                   |
| `podAnnotations`                                  | Annotations for Prometheus pods                                                                                                                       | `{}`                   |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                   | `""`                   |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                              | `soft`                 |
| `pdb.create`                                      | Enable/disable a Pod Disruption Budget creation                                                                                                       | `false`                |
| `pdb.minAvailable`                                | Minimum number/percentage of pods that should remain scheduled                                                                                        | `1`                    |
| `pdb.maxUnavailable`                              | Maximum number/percentage of pods that may be made unavailable                                                                                        | `""`                   |
| `autoscaling.enabled`                             | Enable autoscaling for Prometheus                                                                                                                     | `false`                |
| `autoscaling.minReplicas`                         | Minimum number of Prometheus replicas                                                                                                                 | `""`                   |
| `autoscaling.maxReplicas`                         | Maximum number of Prometheus replicas                                                                                                                 | `""`                   |
| `autoscaling.targetCPU`                           | Target CPU utilization percentage                                                                                                                     | `""`                   |
| `autoscaling.targetMemory`                        | Target Memory utilization percentage                                                                                                                  | `""`                   |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                             | `""`                   |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                                                 | `""`                   |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                                              | `[]`                   |
| `affinity`                                        | Affinity for Prometheus pods assignment                                                                                                               | `{}`                   |
| `nodeSelector`                                    | Node labels for Prometheus pods assignment                                                                                                            | `{}`                   |
| `tolerations`                                     | Tolerations for Prometheus pods assignment                                                                                                            | `[]`                   |
| `updateStrategy.type`                             | Prometheus statefulset strategy type                                                                                                                  | `RollingUpdate`        |
| `podManagementPolicy`                             | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join                                                    | `OrderedReady`         |
| `priorityClassName`                               | Prometheus pods' priorityClassName                                                                                                                    | `""`                   |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                              | `[]`                   |
| `schedulerName`                                   | Name of the k8s scheduler (other than default) for Prometheus pods                                                                                    | `""`                   |
| `terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                                                     | `""`                   |
| `lifecycleHooks`                                  | for the Prometheus container(s) to automate configuration before or after startup                                                                     | `{}`                   |
| `extraEnvVars`                                    | Array with extra environment variables to add to Prometheus nodes                                                                                     | `[]`                   |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for Prometheus nodes                                                                             | `""`                   |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for Prometheus nodes                                                                                | `""`                   |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the Prometheus pod(s)                                                                         | `[]`                   |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the Prometheus container(s)                                                              | `[]`                   |
| `sidecars`                                        | Add additional sidecar containers to the Prometheus pod(s)                                                                                            | `[]`                   |
| `initContainers`                                  | Add additional init containers to the Prometheus pod(s)                                                                                               | `[]`                   |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Prometheus service type                                                                                                          | `LoadBalancer`           |
| `service.ports.http`               | Prometheus service HTTP port                                                                                                     | `80`                     |
| `service.ports.https`              | Prometheus service HTTPS port                                                                                                    | `443`                    |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                     |
| `service.clusterIP`                | Prometheus service Cluster IP                                                                                                    | `""`                     |
| `service.loadBalancerIP`           | Prometheus service Load Balancer IP                                                                                              | `""`                     |
| `service.loadBalancerSourceRanges` | Prometheus service Load Balancer sources                                                                                         | `[]`                     |
| `service.externalTrafficPolicy`    | Prometheus service external traffic policy                                                                                       | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Prometheus service                                                                             | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in Prometheus service (normally used with the `sidecars` value)                                            | `[]`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation for Prometheus                                                                                  | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `prometheus.local`       |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Persistence Parameters

| Name                        | Description                                                                                             | Value                      |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | -------------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `true`                     |
| `persistence.mountPath`     | Path to mount the volume at.                                                                            | `/bitnami/prometheus/data` |
| `persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                       |
| `persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                       |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                       |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]`        |
| `persistence.size`          | Size of data volume                                                                                     | `8Gi`                      |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                       |
| `persistence.selector`      | Selector to match an existing Persistent Volume for WordPress data PVC                                  | `{}`                       |
| `persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                       |

### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                              |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ---------------------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                            |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`                        |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell`            |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `11-debian-11-r%%IMAGE_REVISION%%` |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `IfNotPresent`                     |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                               |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                               |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                               |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                                |

### Other Parameters

| Name                                          | Description                                                                                            | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                     | `false` |
| `rbac.rules`                                  | Custom RBAC rules to set                                                                               | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                   | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                 | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)                                       | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                         | `true`  |
| `metrics.enabled`                             | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`            | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.annotations`          | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `metrics.serviceMonitor.labels`               | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `metrics.serviceMonitor.jobLabel`             | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `metrics.serviceMonitor.honorLabels`          | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `metrics.serviceMonitor.interval`             | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.metricRelabelings`    | Specify additional relabeling of metrics                                                               | `[]`    |
| `metrics.serviceMonitor.relabelings`          | Specify general relabeling                                                                             | `[]`    |
| `metrics.serviceMonitor.selector`             | Prometheus instance selector labels                                                                    | `{}`    |

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
