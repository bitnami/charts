<!--- app-name: Memcached -->

# Memcached packaged by Bitnami

Memcached is an high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load.

[Overview of Memcached](http://memcached.org)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm repo add my-repo https://charts.bitnami.com/bitnami
helm install my-release my-repo/memcached
```

## Introduction

This chart bootstraps a [Memcached](https://github.com/bitnami/containers/tree/main/bitnami/memcached) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add my-repo https://charts.bitnami.com/bitnami
helm install my-release my-repo/memcached
```

These commands deploy Memcached on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                                  | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`            | Extra objects to deploy (evaluated as a template)                                            | `[]`            |
| `commonLabels`           | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations`      | Add annotations to all the deployed resources                                                | `{}`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment/statefulset                             | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment/statefulset                                | `["infinity"]`  |

### Memcached parameters

| Name                          | Description                                                                                               | Value                 |
| ----------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`              | Memcached image registry                                                                                  | `docker.io`           |
| `image.repository`            | Memcached image repository                                                                                | `bitnami/memcached`   |
| `image.tag`                   | Memcached image tag (immutable tags are recommended)                                                      | `1.6.19-debian-11-r0` |
| `image.digest`                | Memcached image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                  |
| `image.pullPolicy`            | Memcached image pull policy                                                                               | `IfNotPresent`        |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                                                          | `[]`                  |
| `image.debug`                 | Specify if debug values should be set                                                                     | `false`               |
| `architecture`                | Memcached architecture. Allowed values: standalone or high-availability                                   | `standalone`          |
| `auth.enabled`                | Enable Memcached authentication                                                                           | `false`               |
| `auth.username`               | Memcached admin user                                                                                      | `""`                  |
| `auth.password`               | Memcached admin password                                                                                  | `""`                  |
| `auth.existingPasswordSecret` | Existing secret with Memcached credentials (must contain a value for `memcached-password` key)            | `""`                  |
| `command`                     | Override default container command (useful when using custom images)                                      | `[]`                  |
| `args`                        | Override default container args (useful when using custom images)                                         | `[]`                  |
| `extraEnvVars`                | Array with extra environment variables to add to Memcached nodes                                          | `[]`                  |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars for Memcached nodes                                  | `""`                  |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars for Memcached nodes                                     | `""`                  |

### Deployment/Statefulset parameters

| Name                                    | Description                                                                                                                                                                                       | Value           |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                          | Number of Memcached nodes                                                                                                                                                                         | `1`             |
| `containerPorts.memcached`              | Memcached container port                                                                                                                                                                          | `11211`         |
| `livenessProbe.enabled`                 | Enable livenessProbe on Memcached containers                                                                                                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                                                                           | `30`            |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                                                                                  | `10`            |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                                                                                 | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                                                                               | `6`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                                                                                               | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe on Memcached containers                                                                                                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                                                                          | `5`             |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                                                                                 | `5`             |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                                                                                | `3`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                                                                              | `6`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                                                                              | `1`             |
| `startupProbe.enabled`                  | Enable startupProbe on Memcached containers                                                                                                                                                       | `false`         |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                                                                                            | `30`            |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                                                                                                   | `10`            |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                                                                                                  | `1`             |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                                                                                                | `15`            |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                                                                                                | `1`             |
| `customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                                                                                                               | `{}`            |
| `customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                                                                                                              | `{}`            |
| `customStartupProbe`                    | Custom startupProbe that overrides the default one                                                                                                                                                | `{}`            |
| `lifecycleHooks`                        | for the Memcached container(s) to automate configuration before or after startup                                                                                                                  | `{}`            |
| `resources.limits`                      | The resources limits for the Memcached containers                                                                                                                                                 | `{}`            |
| `resources.requests.memory`             | The requested memory for the Memcached containers                                                                                                                                                 | `256Mi`         |
| `resources.requests.cpu`                | The requested cpu for the Memcached containers                                                                                                                                                    | `250m`          |
| `podSecurityContext.enabled`            | Enabled Memcached pods' Security Context                                                                                                                                                          | `true`          |
| `podSecurityContext.fsGroup`            | Set Memcached pod's Security Context fsGroup                                                                                                                                                      | `1001`          |
| `containerSecurityContext.enabled`      | Enabled Memcached containers' Security Context                                                                                                                                                    | `true`          |
| `containerSecurityContext.runAsUser`    | Set Memcached containers' Security Context runAsUser                                                                                                                                              | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set Memcached containers' Security Context runAsNonRoot                                                                                                                                           | `true`          |
| `hostAliases`                           | Add deployment host aliases                                                                                                                                                                       | `[]`            |
| `podLabels`                             | Extra labels for Memcached pods                                                                                                                                                                   | `{}`            |
| `podAnnotations`                        | Annotations for Memcached pods                                                                                                                                                                    | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                               | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                          | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                         | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match Ignored if `affinity` is set.                                                                                                                                             | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                                                                                                                         | `[]`            |
| `affinity`                              | Affinity for pod assignment                                                                                                                                                                       | `{}`            |
| `nodeSelector`                          | Node labels for pod assignment                                                                                                                                                                    | `{}`            |
| `tolerations`                           | Tolerations for pod assignment                                                                                                                                                                    | `[]`            |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                          | `[]`            |
| `podManagementPolicy`                   | StatefulSet controller supports relax its ordering guarantees while preserving its uniqueness and identity guarantees. There are two valid pod management policies: `OrderedReady` and `Parallel` | `Parallel`      |
| `priorityClassName`                     | Name of the existing priority class to be used by Memcached pods, priority class needs to be created beforehand                                                                                   | `""`            |
| `schedulerName`                         | Kubernetes pod scheduler registry                                                                                                                                                                 | `""`            |
| `terminationGracePeriodSeconds`         | In seconds, time the given to the memcached pod needs to terminate gracefully                                                                                                                     | `""`            |
| `updateStrategy.type`                   | Memcached statefulset strategy type                                                                                                                                                               | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | Memcached statefulset rolling update configuration parameters                                                                                                                                     | `{}`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for the Memcached pod(s)                                                                                                                      | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Memcached container(s)                                                                                                           | `[]`            |
| `sidecars`                              | Add additional sidecar containers to the Memcached pod(s)                                                                                                                                         | `[]`            |
| `initContainers`                        | Add additional init containers to the Memcached pod(s)                                                                                                                                            | `[]`            |
| `autoscaling.enabled`                   | Enable memcached statefulset autoscaling (requires architecture: "high-availability")                                                                                                             | `false`         |
| `autoscaling.minReplicas`               | memcached statefulset autoscaling minimum number of replicas                                                                                                                                      | `3`             |
| `autoscaling.maxReplicas`               | memcached statefulset autoscaling maximum number of replicas                                                                                                                                      | `6`             |
| `autoscaling.targetCPU`                 | memcached statefulset autoscaling target CPU percentage                                                                                                                                           | `50`            |
| `autoscaling.targetMemory`              | memcached statefulset autoscaling target CPU memory                                                                                                                                               | `50`            |
| `pdb.create`                            | Deploy a pdb object for the Memcached pod                                                                                                                                                         | `false`         |
| `pdb.minAvailable`                      | Minimum available Memcached replicas                                                                                                                                                              | `""`            |
| `pdb.maxUnavailable`                    | Maximum unavailable Memcached replicas                                                                                                                                                            | `1`             |

### Traffic Exposure parameters

| Name                               | Description                                                                             | Value       |
| ---------------------------------- | --------------------------------------------------------------------------------------- | ----------- |
| `service.type`                     | Kubernetes Service type                                                                 | `ClusterIP` |
| `service.ports.memcached`          | Memcached service port                                                                  | `11211`     |
| `service.nodePorts.memcached`      | Node port for Memcached                                                                 | `""`        |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                        | `None`      |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                             | `{}`        |
| `service.clusterIP`                | Memcached service Cluster IP                                                            | `""`        |
| `service.loadBalancerIP`           | Memcached service Load Balancer IP                                                      | `""`        |
| `service.loadBalancerSourceRanges` | Memcached service Load Balancer sources                                                 | `[]`        |
| `service.externalTrafficPolicy`    | Memcached service external traffic policy                                               | `Cluster`   |
| `service.annotations`              | Additional custom annotations for Memcached service                                     | `{}`        |
| `service.extraPorts`               | Extra ports to expose in the Memcached service (normally used with the `sidecar` value) | `[]`        |

### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Memcached pod                    | `false` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `true`  |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |

### Persistence parameters

| Name                       | Description                                                              | Value               |
| -------------------------- | ------------------------------------------------------------------------ | ------------------- |
| `persistence.enabled`      | Enable Memcached data persistence using PVC. If false, use emptyDir      | `false`             |
| `persistence.storageClass` | PVC Storage Class for Memcached data volume                              | `""`                |
| `persistence.accessModes`  | PVC Access modes                                                         | `["ReadWriteOnce"]` |
| `persistence.size`         | PVC Storage Request for Memcached data volume                            | `8Gi`               |
| `persistence.annotations`  | Annotations for the PVC                                                  | `{}`                |
| `persistence.labels`       | Labels for the PVC                                                       | `{}`                |
| `persistence.selector`     | Selector to match an existing Persistent Volume for Memcached's data PVC | `{}`                |

### Volume Permissions parameters

| Name                                                   | Description                                                                                                                       | Value                        |
| ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner and group of the persistent volume                                                   | `false`                      |
| `volumePermissions.image.registry`                     | Init container volume-permissions image registry                                                                                  | `docker.io`                  |
| `volumePermissions.image.repository`                   | Init container volume-permissions image repository                                                                                | `bitnami/bitnami-shell`      |
| `volumePermissions.image.tag`                          | Init container volume-permissions image tag (immutable tags are recommended)                                                      | `11-debian-11-r95`           |
| `volumePermissions.image.digest`                       | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                         |
| `volumePermissions.image.pullPolicy`                   | Init container volume-permissions image pull policy                                                                               | `IfNotPresent`               |
| `volumePermissions.image.pullSecrets`                  | Init container volume-permissions image pull secrets                                                                              | `[]`                         |
| `volumePermissions.resources.limits`                   | Init container volume-permissions resource limits                                                                                 | `{}`                         |
| `volumePermissions.resources.requests`                 | Init container volume-permissions resource requests                                                                               | `{}`                         |
| `volumePermissions.containerSecurityContext.runAsUser` | User ID for the init container                                                                                                    | `0`                          |
| `metrics.enabled`                                      | Start a side-car prometheus exporter                                                                                              | `false`                      |
| `metrics.image.registry`                               | Memcached exporter image registry                                                                                                 | `docker.io`                  |
| `metrics.image.repository`                             | Memcached exporter image repository                                                                                               | `bitnami/memcached-exporter` |
| `metrics.image.tag`                                    | Memcached exporter image tag (immutable tags are recommended)                                                                     | `0.11.2-debian-11-r0`        |
| `metrics.image.digest`                                 | Memcached exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                | `""`                         |
| `metrics.image.pullPolicy`                             | Image pull policy                                                                                                                 | `IfNotPresent`               |
| `metrics.image.pullSecrets`                            | Specify docker-registry secret names as an array                                                                                  | `[]`                         |
| `metrics.containerPorts.metrics`                       | Memcached Prometheus Exporter container port                                                                                      | `9150`                       |
| `metrics.resources.limits`                             | Init container volume-permissions resource limits                                                                                 | `{}`                         |
| `metrics.resources.requests`                           | Init container volume-permissions resource requests                                                                               | `{}`                         |
| `metrics.containerSecurityContext.enabled`             | Enabled Metrics containers' Security Context                                                                                      | `true`                       |
| `metrics.containerSecurityContext.runAsUser`           | Set Metrics containers' Security Context runAsUser                                                                                | `1001`                       |
| `metrics.containerSecurityContext.runAsNonRoot`        | Set Metrics containers' Security Context runAsNonRoot                                                                             | `true`                       |
| `metrics.livenessProbe.enabled`                        | Enable livenessProbe on Memcached Prometheus exporter containers                                                                  | `true`                       |
| `metrics.livenessProbe.initialDelaySeconds`            | Initial delay seconds for livenessProbe                                                                                           | `15`                         |
| `metrics.livenessProbe.periodSeconds`                  | Period seconds for livenessProbe                                                                                                  | `10`                         |
| `metrics.livenessProbe.timeoutSeconds`                 | Timeout seconds for livenessProbe                                                                                                 | `5`                          |
| `metrics.livenessProbe.failureThreshold`               | Failure threshold for livenessProbe                                                                                               | `3`                          |
| `metrics.livenessProbe.successThreshold`               | Success threshold for livenessProbe                                                                                               | `1`                          |
| `metrics.readinessProbe.enabled`                       | Enable readinessProbe on Memcached Prometheus exporter containers                                                                 | `true`                       |
| `metrics.readinessProbe.initialDelaySeconds`           | Initial delay seconds for readinessProbe                                                                                          | `5`                          |
| `metrics.readinessProbe.periodSeconds`                 | Period seconds for readinessProbe                                                                                                 | `10`                         |
| `metrics.readinessProbe.timeoutSeconds`                | Timeout seconds for readinessProbe                                                                                                | `3`                          |
| `metrics.readinessProbe.failureThreshold`              | Failure threshold for readinessProbe                                                                                              | `3`                          |
| `metrics.readinessProbe.successThreshold`              | Success threshold for readinessProbe                                                                                              | `1`                          |
| `metrics.startupProbe.enabled`                         | Enable startupProbe on Memcached Prometheus exporter containers                                                                   | `false`                      |
| `metrics.startupProbe.initialDelaySeconds`             | Initial delay seconds for startupProbe                                                                                            | `10`                         |
| `metrics.startupProbe.periodSeconds`                   | Period seconds for startupProbe                                                                                                   | `10`                         |
| `metrics.startupProbe.timeoutSeconds`                  | Timeout seconds for startupProbe                                                                                                  | `1`                          |
| `metrics.startupProbe.failureThreshold`                | Failure threshold for startupProbe                                                                                                | `15`                         |
| `metrics.startupProbe.successThreshold`                | Success threshold for startupProbe                                                                                                | `1`                          |
| `metrics.customLivenessProbe`                          | Custom livenessProbe that overrides the default one                                                                               | `{}`                         |
| `metrics.customReadinessProbe`                         | Custom readinessProbe that overrides the default one                                                                              | `{}`                         |
| `metrics.customStartupProbe`                           | Custom startupProbe that overrides the default one                                                                                | `{}`                         |
| `metrics.podAnnotations`                               | Memcached Prometheus exporter pod Annotation and Labels                                                                           | `{}`                         |
| `metrics.service.ports.metrics`                        | Prometheus metrics service port                                                                                                   | `9150`                       |
| `metrics.service.clusterIP`                            | Static clusterIP or None for headless services                                                                                    | `""`                         |
| `metrics.service.sessionAffinity`                      | Control where client requests go, to the same pod or round-robin                                                                  | `None`                       |
| `metrics.service.annotations`                          | Annotations for the Prometheus metrics service                                                                                    | `{}`                         |
| `metrics.serviceMonitor.enabled`                       | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator                                                     | `false`                      |
| `metrics.serviceMonitor.namespace`                     | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)                                                     | `""`                         |
| `metrics.serviceMonitor.interval`                      | Interval at which metrics should be scraped.                                                                                      | `""`                         |
| `metrics.serviceMonitor.scrapeTimeout`                 | Timeout after which the scrape is ended                                                                                           | `""`                         |
| `metrics.serviceMonitor.labels`                        | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                             | `{}`                         |
| `metrics.serviceMonitor.selector`                      | Prometheus instance selector labels                                                                                               | `{}`                         |
| `metrics.serviceMonitor.relabelings`                   | RelabelConfigs to apply to samples before scraping                                                                                | `[]`                         |
| `metrics.serviceMonitor.metricRelabelings`             | MetricRelabelConfigs to apply to samples before ingestion                                                                         | `[]`                         |
| `metrics.serviceMonitor.honorLabels`                   | Specify honorLabels parameter to add the scrape endpoint                                                                          | `false`                      |
| `metrics.serviceMonitor.jobLabel`                      | The name of the label on the target service to use as the job name in prometheus.                                                 | `""`                         |

The above parameters map to the environment variables defined in the [bitnami/memcached](https://github.com/bitnami/containers/tree/main/bitnami/memcached) container image. For more information please refer to the [bitnami/memcached](https://github.com/bitnami/containers/tree/main/bitnami/memcached) container image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release --set auth.username=user,auth.password=password my-repo/memcached
```

The above command sets the Memcached admin account username and password to `user` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml my-repo/memcached
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/memcached/configuration/configure-sidecar-init-containers/).

### Set Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

When using `architecture: "high-availability"` the [Bitnami Memcached](https://github.com/bitnami/containers/tree/main/bitnami/memcached) image stores the cache-state at the `/cache-state` path of the container if enabled.

Persistent Volume Claims (PVCs) are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 6.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Some affected values are:

- `memcachedUsername` and `memcachedPassword` have regrouped under the `auth` map.
- `arguments` has been renamed to `args`.
- `extraEnv` has been renamed to `extraEnvVars`.
- `service.port`, `service.internalPort` and `service.externalPort` have been regrouped under the `service.ports` map.
- `metrics.kafka.service.port` has been regrouped under the `metrics.kafka.service.ports` map.
- `metrics.jmx.service.port` has been regrouped under the `metrics.jmx.service.ports` map.
- `updateStrategy` (string) and `rollingUpdatePartition` are regrouped under the `updateStrategy` map.

### To 5.3.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 5.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/memcached/administration/upgrade-helm3/).

### To 4.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 4.0.0. The following example assumes that the release name is memcached:

```console
kubectl delete deployment  memcached --cascade=false
helm upgrade memcached my-repo/memcached
```

### To 3.0.0

This release uses the new bash based `bitnami/memcached` container which uses bash scripts for the start up logic of the container and is smaller in size.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is memcached:

```console
kubectl patch deployment memcached --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```

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