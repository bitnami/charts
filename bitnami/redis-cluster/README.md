
# Redis<sup>TM</sup> Cluster Chart packaged by Bitnami

[Redis<sup>TM</sup>](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

Disclaimer: REDIS® is a registered trademark of Redis Labs Ltd.Any rights therein are reserved to Redis Labs Ltd. Any use by Bitnami is for referential purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Labs Ltd.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/redis-cluster
```

## Introduction

This chart bootstraps a [Redis<sup>TM</sup>](https://github.com/bitnami/bitnami-docker-redis) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

### Choose between Redis<sup>TM</sup> Helm Chart and Redis<sup>TM</sup> Cluster Helm Chart

You can choose any of the two Redis<sup>TM</sup> Helm charts for deploying a Redis<sup>TM</sup> cluster.
While [Redis<sup>TM</sup> Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/redis) will deploy a master-slave cluster using Redis<sup>TM</sup> Sentinel, the [Redis<sup>TM</sup> Cluster Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster) will deploy a Redis<sup>TM</sup> Cluster with sharding.
The main features of each chart are the following:

| Redis<sup>TM</sup>                                     | Redis<sup>TM</sup> Cluster                                             |
|--------------------------------------------------------|------------------------------------------------------------------------|
| Supports multiple databases                            | Supports only one database. Better if you have a big dataset           |
| Single write point (single master)                     | Multiple write points (multiple masters)                               |
| ![Redis<sup>TM</sup> Topology](img/redis-topology.png) | ![Redis<sup>TM</sup> Cluster Topology](img/redis-cluster-topology.png) |

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/redis-cluster
```

The command deploys Redis<sup>TM</sup> on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

NOTE: if you get a timeout error waiting for the hook to complete increase the default timeout (300s) to a higher one, for example:

```
helm install --timeout 600s myrelease bitnami/redis-cluster
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Redis<sup>TM</sup> chart and their default values.

#### Global parameters

| Parameter                 | Description                                        | Default                                                 |
|---------------------------|----------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                       | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array    | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning      | `nil`                                                   |
| `global.redis.password`   | Redis<sup>TM</sup> password (overrides `password`) | `nil`                                                   |

#### Common parameters

| Parameter                               | Description                                                                                                                                         | Default                                                 |
|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`                        | Redis<sup>TM</sup> Image registry                                                                                                                   | `docker.io`                                             |
| `image.repository`                      | Redis<sup>TM</sup> Image name                                                                                                                       | `bitnami/redis`                                         |
| `image.tag`                             | Redis<sup>TM</sup> Image tag                                                                                                                        | `{TAG_NAME}`                                            |
| `image.pullPolicy`                      | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |
| `nameOverride`                          | String to partially override redis.fullname template with a string                                                                                  | `nil`                                                   |
| `fullnameOverride`                      | String to fully override redis.fullname template with a string                                                                                      | `nil`                                                   |
| `existingSecret`                        | Name of existing secret object (for password authentication)                                                                                        | `nil`                                                   |
| `existingSecretPasswordKey`             | Name of key containing password to be retrieved from the existing secret                                                                            | `nil`                                                   |
| `usePassword`                           | Use password                                                                                                                                        | `true`                                                  |
| `usePasswordFile`                       | Mount passwords as files instead of environment variables                                                                                           | `false`                                                 |
| `password`                              | Redis<sup>TM</sup> password (ignored if existingSecret set)                                                                                         | Randomly generated                                      |
| `configmap`                             | Additional common Redis<sup>TM</sup> node configuration (this value is evaluated as a template)                                                     | See `values.yaml`                                       |
| `networkPolicy.enabled`                 | Enable NetworkPolicy                                                                                                                                | `false`                                                 |
| `networkPolicy.allowExternal`           | Don't require client label for connections                                                                                                          | `true`                                                  |
| `networkPolicy.ingressNSMatchLabels`    | Allow connections from other namespaces                                                                                                             | `{}`                                                    |
| `networkPolicy.ingressNSPodMatchLabels` | For other namespaces match by pod labels and namespace labels                                                                                       | `{}`                                                    |
| `podSecurityContext.fsGroup`            | Group ID for the pods.                                                                                                                              | `1001`                                                  |
| `podSecurityContext.sysctls`            | Set namespaced sysctls for the pods.                                                                                                                | `nil`                                                   |
| `podDisruptionBudget`                   | Configure podDisruptionBudget policy                                                                                                                | `{}`                                                    |
| `containerSecurityContext.runAsUser`    | User ID for the containers.                                                                                                                         | `1001`                                                  |
| `containerSecurityContext.sysctls`      | Set namespaced sysctls for the containers.                                                                                                          | `nil`                                                   |
| `serviceAccount.create`                 | Specifies whether a ServiceAccount should be created                                                                                                | `false`                                                 |
| `serviceAccount.name`                   | The name of the ServiceAccount to create                                                                                                            | Generated using the `common.names.fullname` template    |
| `rbac.create`                           | Specifies whether RBAC resources should be created                                                                                                  | `false`                                                 |
| `rbac.role.rules`                       | Rules to create                                                                                                                                     | `[]`                                                    |
| `persistence.enabled`                   | Use a PVC to persist data.                                                                                                                          | `true`                                                  |
| `persistence.path`                      | Path to mount the volume at, to use other images                                                                                                    | `/bitnami/redis/data`                                   |
| `persistence.subPath`                   | Subdirectory of the volume to mount at                                                                                                              | `""`                                                    |
| `persistence.storageClass`              | Storage class of backing PVC                                                                                                                        | `generic`                                               |
| `persistence.accessModes`               | Persistent Volume Access Modes                                                                                                                      | `[ReadWriteOnce]`                                       |
| `persistence.size`                      | Size of data volume                                                                                                                                 | `8Gi`                                                   |
| `persistence.matchLabels`               | matchLabels persistent volume selector                                                                                                              | `{}`                                                    |
| `persistence.matchExpressions`          | matchExpressions persistent volume selector                                                                                                         | `{}`                                                    |
| `statefulset.updateStrategy`            | Update strategy for StatefulSet                                                                                                                     | onDelete                                                |
| `statefulset.rollingUpdatePartition`    | Partition update strategy                                                                                                                           | `nil`                                                   |
| `tls.enabled`                           | Enable TLS support for replication traffic                                                                                                          | `false`                                                 |
| `tls.authClients`                       | Require clients to authenticate or not                                                                                                              | `true`                                                  |
| `tls.certificatesSecret`                | Name of the secret that contains the certificates                                                                                                   | `nil`                                                   |
| `tls.certFilename`                      | Certificate filename                                                                                                                                | `nil`                                                   |
| `tls.certKeyFilename`                   | Certificate key filename                                                                                                                            | `nil`                                                   |
| `tls.certCAFilename`                    | CA Certificate filename                                                                                                                             | `nil`                                                   |
| `tls.dhParamsFilename`                  | DH params (in order to support DH based ciphers)                                                                                                    | `nil`                                                   |
| `podSecurityPolicy.create`              | Specifies whether a PodSecurityPolicy should be created                                                                                             | `false`                                                 |
| `service.port`                          | Kubernetes Service port.                                                                                                                            | `6379`                                                  |
| `service.annotations`                   | annotations for redis service                                                                                                                       | {}                                                      |
| `service.labels`                        | Additional labels for redis service                                                                                                                 | {}                                                      |
| `service.type`                          | Service type for default redis service                                                                                                              | `ClusterIP`                                             |
| `service.loadBalancerIP`                | loadBalancerIP if service.type is `LoadBalancer`                                                                                                    | `nil`                                                   |
| `volumePermissions.enabled`             | Enable init container that changes volume permissions in the registry (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`      | Init container volume-permissions image registry                                                                                                    | `docker.io`                                             |
| `volumePermissions.image.repository`    | Init container volume-permissions image name                                                                                                        | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`           | Init container volume-permissions image tag                                                                                                         | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`    | Init container volume-permissions image pull policy                                                                                                 | `Always`                                                |
| `volumePermissions.resources`           | Init container volume-permissions CPU/Memory resource requests/limits                                                                               | {}                                                      |
| `volumePermissions.image.pullSecrets`   | Specify docker-registry secret names as an array                                                                                                    | `[]` (does not add image pull secrets to deployed pods) |
| `commonLabels`                          | Labels to add to all deployed objects                                                                                                               | `nil`                                                   |
| `commonAnnotations`                     | Annotations to add to all deployed objects                                                                                                          | `[]`                                                    |
| `extraDeploy`                           | Array of extra objects to deploy with the release (evaluated as a template).                                                                        | `nil`                                                   |

#### Redis<sup>TM</sup> statefulset parameters

| Parameter                                  | Description                                                                                                        | Default                          |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------|----------------------------------|
| `redis.port`                               | Redis<sup>TM</sup> port.                                                                                           | `6379`                           |
| `redis.useAOFPersistence`                  | Enables AOF persistence mode                                                                                       | `"yes"`                          |
| `redis.podLabels`                          | Additional labels for Redis<sup>TM</sup> pod                                                                       | {}                               |
| `redis.command`                            | Redis<sup>TM</sup> entrypoint string. The command `redis-server` is executed if this is not provided.              | `nil`                            |
| `redis.args`                               | Arguments for the provided command if needed                                                                       | `nil`                            |
| `redis.schedulerName`                      | Name of an alternate scheduler                                                                                     | `nil`                            |
| `redis.shareProcessNamespace`              | Redis pod `shareProcessNamespace` option. Enables /pause reap zombie PIDs.                                            | `false`                          |
| `redis.configmap`                          | Additional Redis<sup>TM</sup> configuration for the nodes (this value is evaluated as a template)                  | `nil`                            |
| `redis.podAffinityPreset`                  | Redis<sup>TM</sup> pod affinity preset. Ignored if `redis.affinity` is set. Allowed values: `soft` or `hard`       | `""`                             |
| `redis.podAntiAffinityPreset`              | Redis<sup>TM</sup> pod anti-affinity preset. Ignored if `redis.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                           |
| `redis.nodeAffinityPreset.type`            | Redis<sup>TM</sup> node affinity preset type. Ignored if `redis.affinity` is set. Allowed values: `soft` or `hard` | `""`                             |
| `redis.nodeAffinityPreset.key`             | Redis<sup>TM</sup> node label key to match Ignored if `redis.affinity` is set.                                     | `""`                             |
| `redis.nodeAffinityPreset.values`          | Redis<sup>TM</sup> node label values to match. Ignored if `redis.affinity` is set.                                 | `[]`                             |
| `redis.affinity`                           | Affinity for Redis<sup>TM</sup> pods assignment                                                                    | `{}` (evaluated as a template)   |
| `redis.nodeSelector`                       | Node labels for Redis<sup>TM</sup> pods assignment                                                                 | `{}` (evaluated as a template)   |
| `redis.tolerations`                        | Tolerations for Redis<sup>TM</sup> pods assignment                                                                 | `[]` (evaluated as a template)   |
| `redis.busPort`                            | Port for the Redis<sup>TM</sup> gossip protocol                                                                    | `16379`                          |
| `redis.hostAliases`                        | Add deployment host aliases                                                                                        | `[]`                             |
| `redis.lifecycleHooks`                     | LifecycleHook to set additional configuration at startup. Evaluated as a template                                  | ``                               |
| `redis.livenessProbe.enabled`              | Turn on and off liveness probe.                                                                                    | `true`                           |
| `redis.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated.                                                                          | `30`                             |
| `redis.livenessProbe.periodSeconds`        | How often to perform the probe.                                                                                    | `30`                             |
| `redis.livenessProbe.timeoutSeconds`       | When the probe times out.                                                                                          | `5`                              |
| `redis.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.                       | `1`                              |
| `redis.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                         | `5`                              |
| `redis.readinessProbe.enabled`             | Turn on and off readiness probe.                                                                                   | `true`                           |
| `redis.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated.                                                                         | `5`                              |
| `redis.readinessProbe.periodSeconds`       | How often to perform the probe.                                                                                    | `10`                             |
| `redis.readinessProbe.timeoutSeconds`      | When the probe times out.                                                                                          | `1`                              |
| `redis.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed.                       | `1`                              |
| `redis.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                         | `5`                              |
| `redis.priorityClassName`                  | Redis<sup>TM</sup> Master pod priorityClassName                                                                    | `{}`                             |
| `redis.customLivenessProbe`                | Override default liveness probe                                                                                    | `nil`                            |
| `redis.customReadinessProbe`               | Override default readiness probe                                                                                   | `nil`                            |
| `redis.extraVolumes`                       | Array of extra volumes to be added to all pods (evaluated as a template)                                           | `[]`                             |
| `redis.extraVolumeMounts`                  | Array of extra volume mounts to be added to all pods (evaluated as a template)                                     | `[]`                             |
| `redis.affinity`                           | Affinity settings for Redis<sup>TM</sup> pod assignment                                                            | `{}`                             |
| `redis.topologySpreadConstraints`          | Pod topology spread constraints for Redis<sup>TM</sup> pod                                                         | `[]`                             |
| `redis.extraEnvVars`                       | Array containing extra env vars to be added to all pods (evaluated as a template)                                  | `[]`                             |
| `redis.extraEnvVarsCM`                     | ConfigMap containing extra env vars to be added to all pods (evaluated as a template)                              | `nil`                            |
| `redis.extraEnvVarsSecret`                 | Secret containing extra env vars to be added to all pods (evaluated as a template)                                 | `nil`                            |
| `redis.initContainers`                     | Init containers to add to the cronjob container                                                                    | `{}`                             |
| `redis.sidecars`                           | Attach additional containers to the pod (evaluated as a template)                                                  | `nil`                            |
| `redis.resources`                          | Redis<sup>TM</sup> CPU/Memory resource requests/limits                                                             | `{Memory: "256Mi", CPU: "100m"}` |

#### Cluster initialization job parameters

| Parameter                           | Description                                                                                                | Default                        |
|-------------------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------|
| `initJob.activeDeadlineSeconds`     | Maximum time (in seconds) to wait for the cluster initialization job to succeed                            | `600`                          |
| `initJob.command`                   | Entrypoint string.                                                                                         | `nil`                          |
| `initJob.args`                      | Arguments for the provided command if needed                                                               | `nil`                          |
| `initJob.annotations`               | Job annotations                                                                                            | `nil`                          |
| `initJob.hostAliases`               | Add deployment host aliases                                                                                | `[]`                           |
| `initJob.podAnnotations`            | Job pod annotations                                                                                        | `nil`                          |
| `initJob.extraEnvVars`              | Array containing extra env vars to be added to all pods (evaluated as a template)                          | `[]`                           |
| `initJob.extraEnvVarsCM`            | ConfigMap containing extra env vars to be added to all pods (evaluated as a template)                      | `nil`                          |
| `initJob.extraEnvVarsSecret`        | Secret containing extra env vars to be added to all pods (evaluated as a template)                         | `nil`                          |
| `initJob.initContainers`            | Init containers to add to the cronjob container                                                            | `{}`                           |
| `initJob.extraVolumes`              | Array of extra volumes to be added to all pods (evaluated as a template)                                   | `[]`                           |
| `initJob.extraVolumeMounts`         | Array of extra volume mounts to be added to all pods (evaluated as a template)                             | `[]`                           |
| `initJob.podLabels`                 | Additional labels                                                                                          | `{}`                           |
| `initJob.podAffinityPreset`         | Init job pod affinity preset. Ignored if `initJob.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `initJob.podAntiAffinityPreset`     | Init job pod anti-affinity preset. Ignored if `initJob.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `initJob.nodeAffinityPreset.type`   | Init job node affinity preset type. Ignored if `initJob.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `initJob.nodeAffinityPreset.key`    | Init job node label key to match Ignored if `initJob.affinity` is set.                                     | `""`                           |
| `initJob.nodeAffinityPreset.values` | Init job node label values to match. Ignored if `initJob.affinity` is set.                                 | `[]`                           |
| `initJob.affinity`                  | Affinity for init job pods assignment                                                                      | `{}` (evaluated as a template) |
| `initJob.nodeSelector`              | Node labels for init job pods assignment                                                                   | `{}` (evaluated as a template) |
| `initJob.tolerations`               | Tolerations for init job pods assignment                                                                   | `[]` (evaluated as a template) |
| `initJob.resources`                 | Redis<sup>TM</sup> CPU/Memory resource requests/limits                                                     | `nil`                          |
| `initJob.priorityClassName`         | Priority class name                                                                                        | `nil`                          |

#### Cluster update job parameters

| Parameter                             | Description                                                                                                    | Default                        |
|---------------------------------------|----------------------------------------------------------------------------------------------------------------|--------------------------------|
| `updateJob.activeDeadlineSeconds`     | Maximum time (in seconds) to wait for the cluster initialization job to succeed                                | `600`                          |
| `updateJob.command`                   | Entrypoint string.                                                                                             | `nil`                          |
| `updateJob.args`                      | Arguments for the provided command if needed                                                                   | `nil`                          |
| `updateJob.annotations`               | Job annotations                                                                                                | `nil`                          |
| `updateJob.podAnnotations`            | Job pod annotations                                                                                            | `nil`                          |
| `updateJob.extraEnvVars`              | Array containing extra env vars to be added to all pods (evaluated as a template)                              | `[]`                           |
| `updateJob.extraEnvVarsCM`            | ConfigMap containing extra env vars to be added to all pods (evaluated as a template)                          | `nil`                          |
| `updateJob.extraEnvVarsSecret`        | Secret containing extra env vars to be added to all pods (evaluated as a template)                             | `nil`                          |
| `updateJob.hostAliases`               | Add deployment host aliases                                                                                    | `[]`                           |
| `updateJob.initContainers`            | Init containers to add to the cronjob container                                                                | `{}`                           |
| `updateJob.extraVolumes`              | Array of extra volumes to be added to all pods (evaluated as a template)                                       | `[]`                           |
| `updateJob.extraVolumeMounts`         | Array of extra volume mounts to be added to all pods (evaluated as a template)                                 | `[]`                           |
| `updateJob.podLabels`                 | Additional labels                                                                                              | `{}`                           |
| `updateJob.podAffinityPreset`         | Update job pod affinity preset. Ignored if `updateJob.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `updateJob.podAntiAffinityPreset`     | Update job pod anti-affinity preset. Ignored if `updateJob.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `updateJob.nodeAffinityPreset.type`   | Update job node affinity preset type. Ignored if `updateJob.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `updateJob.nodeAffinityPreset.key`    | Update job node label key to match Ignored if `updateJob.affinity` is set.                                     | `""`                           |
| `updateJob.nodeAffinityPreset.values` | Update job node label values to match. Ignored if `updateJob.affinity` is set.                                 | `[]`                           |
| `updateJob.affinity`                  | Affinity for update job pods assignment                                                                        | `{}` (evaluated as a template) |
| `updateJob.nodeSelector`              | Node labels for update job pods assignment                                                                     | `{}` (evaluated as a template) |
| `updateJob.tolerations`               | Tolerations for update job pods assignment                                                                     | `[]` (evaluated as a template) |
| `updateJob.resources`                 | Redis<sup>TM</sup> CPU/Memory resource requests/limits                                                         | `nil`                          |
| `updateJob.priorityClassName`         | Priority class name                                                                                            | `nil`                          |

#### Cluster management parameters

| Parameter                                       | Description                                                                                                                                       | Default        |
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|----------------|
| `cluster.init`                                  | Enable the creation of a job that initializes the Redis<sup>TM</sup> Cluster                                                                      | `true`         |
| `cluster.nodes`                                 | Total Number of nodes in the Redis<sup>TM</sup> cluster including `replicas`. See the "Cluster topology" section                                                                                       | `6`            |
| `cluster.replicas`                              | Number of replicas for every master in the cluster                                                                                              | `1`            |
| `cluster.externalAccess.enabled`                | Enable access to the Redis<sup>TM</sup> cluster from Outside the Kubernetes Cluster                                                               | `false`        |
| `cluster.externalAccess.service.type`           | Type for the services used to expose every Pod                                                                                                    | `LoadBalancer` |
| `cluster.externalAccess.service.port`           | Port for the services used to expose every Pod                                                                                                    | `6379`         |
| `cluster.externalAccess.service.loadBalancerIP` | Array of LoadBalancer IPs used to expose every Pod of the Redis<sup>TM</sup> cluster when `cluster.externalAccess.service.type` is `LoadBalancer` | `[]`           |
| `cluster.externalAccess.service.annotations`    | Annotations to add to the services used to expose every Pod of the Redis<sup>TM</sup> Cluster                                                     | `{}`           |
| `cluster.update.addNodes`                       | Boolean to specify if you want to add nodes after the upgrade                                                                                     | `false`        |
| `cluster.update.currentNumberOfNodes`           | Number of currently deployed Redis<sup>TM</sup>  nodes                                                                                            | `6`            |
| `cluster.update.newExternalIPs`                 | External IPs obtained from the services for the new nodes to add to the cluster                                                                   | `nil`          |

#### Metrics sidecar parameters

| Parameter                                 | Description                                                                                                                     | Default                      |
|-------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| `metrics.enabled`                         | Start a side-car prometheus exporter                                                                                            | `false`                      |
| `metrics.image.registry`                  | Redis<sup>TM</sup> exporter image registry                                                                                      | `docker.io`                  |
| `metrics.image.repository`                | Redis<sup>TM</sup> exporter image name                                                                                          | `bitnami/redis-exporter`     |
| `metrics.image.tag`                       | Redis<sup>TM</sup> exporter image tag                                                                                           | `{TAG_NAME}`                 |
| `metrics.image.pullPolicy`                | Image pull policy                                                                                                               | `IfNotPresent`               |
| `metrics.image.pullSecrets`               | Specify docker-registry secret names as an array                                                                                | `nil`                        |
| `metrics.extraArgs`                       | Extra arguments for the binary; possible values [here](https://github.com/oliver006/redis_exporter#flags)                       | {}                           |
| `metrics.podLabels`                       | Additional labels for Metrics exporter pod                                                                                      | {}                           |
| `metrics.podAnnotations`                  | Additional annotations for Metrics exporter pod                                                                                 | {}                           |
| `metrics.resources`                       | Exporter resource requests/limit                                                                                                | Memory: `256Mi`, CPU: `100m` |
| `metrics.serviceMonitor.enabled`          | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                          | `false`                      |
| `metrics.serviceMonitor.namespace`        | Optional namespace which Prometheus is running in                                                                               | `nil`                        |
| `metrics.serviceMonitor.interval`         | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                          | `nil`                        |
| `metrics.service.type`                    | Kubernetes Service type (redis metrics)                                                                                         | `ClusterIP`                  |
| `metrics.service.annotations`             | Annotations for the services to monitor.                                                                                        | {}                           |
| `metrics.service.labels`                  | Additional labels for the metrics service                                                                                       | {}                           |
| `metrics.service.loadBalancerIP`          | loadBalancerIP if redis metrics service type is `LoadBalancer`                                                                  | `nil`                        |
| `metrics.prometheusRule.enabled`          | Set this to true to create prometheusRules for Prometheus operator                                                              | `false`                      |
| `metrics.prometheusRule.additionalLabels` | Additional labels that can be used so prometheusRules will be discovered by Prometheus                                          | `{}`                         |
| `metrics.prometheusRule.namespace`        | namespace where prometheusRules resource should be created                                                                      | Same namespace as redis      |
| `metrics.prometheusRule.rules`            | [rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) to be created, check values for an example. | `[]`                         |

#### Sysctl Image parameters

| Parameter                  | Description                                                    | Default                 |
|----------------------------|----------------------------------------------------------------|-------------------------|
| `sysctlImage.enabled`      | Enable an init container to modify Kernel settings             | `false`                 |
| `sysctlImage.command`      | sysctlImage command to execute                                 | []                      |
| `sysctlImage.registry`     | sysctlImage Init container registry                            | `docker.io`             |
| `sysctlImage.repository`   | sysctlImage Init container name                                | `bitnami/bitnami-shell` |
| `sysctlImage.tag`          | sysctlImage Init container tag                                 | `"10"`                  |
| `sysctlImage.pullPolicy`   | sysctlImage Init container pull policy                         | `Always`                |
| `sysctlImage.mountHostSys` | Mount the host `/sys` folder to `/host-sys`                    | `false`                 |
| `sysctlImage.resources`    | sysctlImage Init container CPU/Memory resource requests/limits | {}                      |
| `sysctlImage.pullSecrets`  | Specify docker-registry secret names as an array               | `nil`                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set password=secretpassword \
    bitnami/redis-cluster
```

The above command sets the Redis<sup>TM</sup> server password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/redis-cluster
```

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Note for minikube users**: Current versions of minikube (v0.24.1 at the time of writing) provision `hostPath` persistent volumes that are only writable by root. Using chart defaults cause pod failure for the Redis<sup>TM</sup> pod as it attempts to write to the `/bitnami` directory. Consider installing Redis<sup>TM</sup> with `--set persistence.enabled=false`. See minikube issue [1990](https://github.com/kubernetes/minikube/issues/1990) for more information.

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Redis<sup>TM</sup> version

To modify the Redis<sup>TM</sup> version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/redis-cluster/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Cluster topology

To successfully set the cluster up, it will need to have at least 3 master nodes. The total number of nodes is calculated like- `nodes = numOfMasterNodes + numOfMasterNodes * replicas`. Hence, the defaults `cluster.nodes = 6` and `cluster.replicas = 1` means, 3 master and 3 replica nodes will be deployed by the chart.

By default the Redis<sup>TM</sup> Cluster is not accessible from outside the Kubernetes cluster, to access the Redis<sup>TM</sup> Cluster from outside you have to set `cluster.externalAccess.enabled=true` at deployment time. It will create in the first installation only 6 LoadBalancer services, one for each Redis<sup>TM</sup> node, once you have the external IPs of each service you will need to perform an upgrade passing those IPs to the `cluster.externalAccess.service.loadbalancerIP` array.

The replicas will be read-only replicas of the masters. By default only one service is exposed (when not using the external access mode). You will connect your client to the exposed service, regardless you need to read or write. When a write operation arrives to a replica it will redirect the client to the proper master node. For example, using `redis-cli` you will need to provide the `-c` flag for `redis-cli` to follow the redirection automatically.

Using the external access mode, you can connect to any of the pods and the slaves will redirect the client in the same way as explained before, but the all the IPs will be public.

In case the master crashes, one of his slaves will be promoted to master. The slots stored by the crashed master will be unavailable until the slave finish the promotion. If a master and all his slaves crash, the cluster will be down until one of them is up again. To avoid downtime, it is possible to configure the number of Redis<sup>TM</sup> nodes with `cluster.nodes` and the number of replicas that will be assigned to each master with `cluster.replicas`. For example:

- `cluster.nodes=9` ( 3 master plus 2 replicas for each master)
- `cluster.replicas=2`

Providing the values above, the cluster will have 3 masters and, each master, will have 2 replicas.

> NOTE: By default `cluster.init` will be set to `true` in order to initialize the Redis<sup>TM</sup> Cluster in the first installation. If for testing purposes you only want to deploy or upgrade the nodes but avoiding the creation of the cluster you can set `cluster.init` to `false`.

#### Adding a new node to the cluster

There is a job that will be executed using a `post-upgrade` hook that will allow you to add a new node. To use it, you should provide some parameters to the upgrade:

- Pass as `password` the password used in the installation time. If you did not provide a password follow the instructions from the NOTES.txt to get the generated password.
- Set the desired number of nodes at `cluster.nodes`.
- Set the number of current nodes at `cluster.update.currentNumberOfNodes`.
- Set to true `cluster.update.addNodes`.

The following will be an example to add one more node:

```
helm upgrade --timeout 600s <release> --set "password=${REDIS_PASSWORD},cluster.nodes=7,cluster.update.addNodes=true,cluster.update.currentNumberOfNodes=6" bitnami/redis-cluster
```

Where `REDIS_PASSWORD` is the password obtained with the command that appears after the first installation of the Helm Chart.
The cluster will continue up while restarting pods one by one as the quorum is not lost.

##### External Access

If you are using external access, to add a new node you will need to perform two upgrades. First upgrade the release to add a new Redis<sup>TM</sup> node and to get a LoadBalancerIP service. For example:

```
helm upgrade <release> --set "password=${REDIS_PASSWORD},cluster.externalAccess.enabled=true,cluster.externalAccess.service.type=LoadBalancer,cluster.externalAccess.service.loadBalancerIP[0]=<loadBalancerip-0>,cluster.externalAccess.service.loadBalancerIP[1]=<loadbalanacerip-1>,cluster.externalAccess.service.loadBalancerIP[2]=<loadbalancerip-2>,cluster.externalAccess.service.loadBalancerIP[3]=<loadbalancerip-3>,cluster.externalAccess.service.loadBalancerIP[4]=<loadbalancerip-4>,cluster.externalAccess.service.loadBalancerIP[5]=<loadbalancerip-5>,cluster.externalAccess.service.loadBalancerIP[6]=,cluster.nodes=7,cluster.init=false bitnami/redis-cluster
```

> Important here to provide the loadBalancerIP parameters for the new nodes empty to not get an index error.

As we want to add a new node, we are setting `cluster.nodes=7` and we leave empty the LoadBalancerIP for the new node, so the cluster will provide the correct one.
`REDIS_PASSWORD` is the password obtained with the command that appears after the first installation of the Helm Chart.
At this point, you will have a new Redis<sup>TM</sup> Pod that will remain in `crashLoopBackOff` state until we provide the LoadBalancerIP for the new service.
Now, wait until the cluster provides the new LoadBalancerIP for the new service and perform the second upgrade:

```
helm upgrade <release> --set "password=${REDIS_PASSWORD},cluster.externalAccess.enabled=true,cluster.externalAccess.service.type=LoadBalancer,cluster.externalAccess.service.loadBalancerIP[0]=<loadbalancerip-0>,cluster.externalAccess.service.loadBalancerIP[1]=<loadbalancerip-1>,cluster.externalAccess.service.loadBalancerIP[2]=<loadbalancerip-2>,cluster.externalAccess.service.loadBalancerIP[3]=<loadbalancerip-3>,cluster.externalAccess.service.loadBalancerIP[4]=<loadbalancerip-4>,cluster.externalAccess.service.loadBalancerIP[5]=<loadbalancerip-5>,cluster.externalAccess.service.loadBalancerIP[6]=<loadbalancerip-6>,cluster.nodes=7,cluster.init=false,cluster.update.addNodes=true,cluster.update.newExternalIPs[0]=<load-balancerip-6>" bitnami/redis-cluster
```

Note we are providing the new IPs at `cluster.update.newExternalIPs`, the flag `cluster.update.addNodes=true` to enable the creation of the Job that adds a new node and now we are setting the LoadBalancerIP of the new service instead of leave it empty.

> NOTE: To avoid the creation of the Job that initializes the Redis<sup>TM</sup> Cluster again, you will need to provide `cluster.init=false`.

#### Scale down the cluster

To scale down the redis cluster just perform a normal upgrade setting the `cluster.nodes` value to the desired number of nodes. It should not be less than `6`. Also it is needed to provide the password using the `password`. For example, having more than 6 nodes, to scale down the cluster to 6 nodes:

```
helm upgrade --timeout 600s <release> --set "password=${REDIS_PASSWORD},cluster.nodes=6" .
```

The cluster will continue working during the update as long as the quorum is not lost.

> NOTE: To avoid the creation of the Job that initializes the Redis<sup>TM</sup> Cluster again, you will need to provide `cluster.init=false`.

### Using password file
To use a password file for Redis<sup>TM</sup> you need to create a secret containing the password.

> *NOTE*: It is important that the file with the password must be called `redis-password`

And then deploy the Helm Chart using the secret name as parameter:

```console
usePassword=true
usePasswordFile=true
existingSecret=redis-password-secret
metrics.enabled=true
```

### Securing traffic using TLS

TLS support can be enabled in the chart by specifying the `tls.` parameters while creating a release. The following parameters should be configured to properly enable the TLS support in the cluster:

- `tls.enabled`: Enable TLS support. Defaults to `false`
- `tls.certificatesSecret`: Name of the secret that contains the certificates. No defaults.
- `tls.certFilename`: Certificate filename. No defaults.
- `tls.certKeyFilename`: Certificate key filename. No defaults.
- `tls.certCAFilename`: CA Certificate filename. No defaults.

For example:

First, create the secret with the cetificates files:

```console
kubectl create secret generic certificates-tls-secret --from-file=./cert.pem --from-file=./cert.key --from-file=./ca.pem
```

Then, use the following parameters:

```console
tls.enabled="true"
tls.certificatesSecret="certificates-tls-secret"
tls.certFilename="cert.pem"
tls.certKeyFilename="cert.key"
tls.certCAFilename="ca.pem"
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Redis<sup>TM</sup> (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: REDIS_WHATEVER
    value: value
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9121) is exposed in the service. Metrics can be scraped from within the cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml). If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.

### Host Kernel Settings
Redis<sup>TM</sup> may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages.
To do so, you can set up a privileged initContainer with the `sysctlImage` config values, for example:
```
sysctlImage:
  enabled: true
  mountHostSys: true
  command:
    - /bin/sh
    - -c
    - |-
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```

Alternatively, for Kubernetes 1.12+ you can set `podSecurityContext.sysctls` which will configure sysctls for master and slave pods. Example:

```yaml
podSecurityContext:
  sysctls:
  - name: net.core.somaxconn
    value: "10000"
```

Note that this will not disable transparent huge tables.

## Helm Upgrade

By default `cluster.init` will be set to `true` in order to initialize the Redis<sup>TM</sup> Cluster in the first installation. If for testing purposes you only want to deploy or upgrade the nodes but avoiding the creation of the cluster you can set `cluster.init` to `false`.

## Persistence

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at the `/bitnami` path. The volume is created using dynamic volume provisioning.

## NetworkPolicy

To enable network policy for Redis<sup>TM</sup>, install
[a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin),
and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

With NetworkPolicy enabled, only pods with the generated client label will be
able to connect to Redis<sup>TM</sup>. This label will be displayed in the output
after a successful install.

With `networkPolicy.ingressNSMatchLabels` pods from other namespaces can connect to redis. Set `networkPolicy.ingressNSPodMatchLabels` to match pod labels in matched namespace. For example, for a namespace labeled `redis=external` and pods in that namespace labeled `redis-client=true` the fields should be set:

```yaml
networkPolicy:
  enabled: true
  ingressNSMatchLabels:
    redis: external
  ingressNSPodMatchLabels:
    redis-client: true
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` paremeter(s). Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 5.0.0

This major version updates the Redis<sup>TM</sup> docker image version used from `6.0` to `6.2`, the new stable version. There are no major changes in the chart and there shouldn't be any breaking changes in it as `6.2` breaking changes center around some command and behaviour changes. For more information, please refer to [Redis<sup>TM</sup> 6.2 release notes](https://raw.githubusercontent.com/redis/redis/6.2/00-RELEASENOTES).

### To 4.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 3.0.0

This version of the chart adapts the chart to the most recent Bitnami best practices and standards. Most of the Redis<sup>TM</sup> parameters were moved to the `redis` values section (such as extraEnvVars, sidecars, and so on). No major issues are expected during the upgrade.

### To 2.0.0

The version `1.0.0` was using a label in the Statefulset's volumeClaimTemplate that didn't allow to upgrade the chart. The version `2.0.0` fixed that issue. Also it adds more docs in the README.md.
