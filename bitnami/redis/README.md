# Redis<sup>TM</sup> Chart packaged by Bitnami

[Redis<sup>TM</sup>](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

Disclaimer: REDIS® is a registered trademark of Redis Labs Ltd.Any rights therein are reserved to Redis Labs Ltd. Any use by Bitnami is for referential purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Labs Ltd.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/redis
```

## Introduction

This chart bootstraps a [Redis<sup>TM</sup>](https://github.com/bitnami/bitnami-docker-redis) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

### Choose between Redis<sup>TM</sup> Helm Chart and Redis<sup>TM</sup> Cluster Helm Chart

You can choose any of the two Redis<sup>TM</sup> Helm charts for deploying a Redis<sup>TM</sup> cluster.
While [Redis<sup>TM</sup> Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/redis) will deploy a master-slave cluster using Redis<sup>TM</sup> Sentinel, the [Redis<sup>TM</sup> Cluster Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster) will deploy a Redis<sup>TM</sup> Cluster topology with sharding.
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
$ helm install my-release bitnami/redis
```

The command deploys Redis<sup>TM</sup> on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                           | Value |
| ------------------------- | ----------------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                          | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array       | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)          | `nil` |
| `global.redis.password`   | Global Redis(TM) password (overrides `auth.password`) | `nil` |


### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `nil`           |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |


### Redis(TM) Image parameters

| Name                | Description                                          | Value                 |
| ------------------- | ---------------------------------------------------- | --------------------- |
| `image.registry`    | Redis(TM) image registry                             | `docker.io`           |
| `image.repository`  | Redis(TM) image repository                           | `bitnami/redis`       |
| `image.tag`         | Redis(TM) image tag (immutable tags are recommended) | `6.2.1-debian-10-r36` |
| `image.pullPolicy`  | Redis(TM) image pull policy                          | `IfNotPresent`        |
| `image.pullSecrets` | Redis(TM) image pull secrets                         | `[]`                  |
| `image.debug`       | Enable image debug mode                              | `false`               |


### Redis(TM) common configuration parameters

| Name                             | Description                                                                          | Value         |
| -------------------------------- | ------------------------------------------------------------------------------------ | ------------- |
| `architecture`                   | Redis(TM) architecture. Allowed values: `standalone` or `replication`                | `replication` |
| `auth.enabled`                   | Enable password authentication                                                       | `true`        |
| `auth.sentinel`                  | Enable password authentication on sentinels too                                      | `true`        |
| `auth.password`                  | Redis(TM) password                                                                   | `""`          |
| `auth.existingSecret`            | The name of an existing secret with Redis(TM) credentials                            | `nil`         |
| `auth.existingSecretPasswordKey` | Password key to be retrieved from existing secret                                    | `nil`         |
| `auth.usePasswordFiles`          | Mount credentials as files instead of using an environment variable                  | `false`       |
| `existingConfigmap`              | The name of an existing ConfigMap with your custom configuration for Redis(TM) nodes | `nil`         |


### Redis(TM) master configuration parameters

| Name                                        | Description                                                                                      | Value           |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------- |
| `master.configuration`                      | Configuration for Redis(TM) master nodes                                                         | `nil`           |
| `master.disableCommands`                    | Array with Redis(TM) commands to disable on master nodes                                         | `[]`            |
| `master.command`                            | Override default container command (useful when using custom images)                             | `[]`            |
| `master.args`                               | Override default container args (useful when using custom images)                                | `[]`            |
| `master.preExecCmds`                        | Additional commands to run prior to starting Redis(TM) master                                    | `[]`            |
| `master.extraFlags`                         | Array with additional command line flags for Redis(TM) master                                    | `[]`            |
| `master.extraEnvVars`                       | Array with extra environment variables to add to Redis(TM) master nodes                          | `[]`            |
| `master.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for Redis(TM) master nodes                  | `nil`           |
| `master.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for Redis(TM) master nodes                     | `nil`           |
| `master.containerPort`                      | Container port to open on Redis(TM) master nodes                                                 | `6379`          |
| `master.livenessProbe.enabled`              | Enable livenessProbe on Redis(TM) master nodes                                                   | `true`          |
| `master.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                          | `5`             |
| `master.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                 | `5`             |
| `master.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                | `5`             |
| `master.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                              | `5`             |
| `master.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                              | `1`             |
| `master.readinessProbe.enabled`             | Enable readinessProbe on Redis(TM) master nodes                                                  | `true`          |
| `master.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                         | `5`             |
| `master.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                | `5`             |
| `master.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                               | `1`             |
| `master.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                             | `5`             |
| `master.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                             | `1`             |
| `master.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                              | `{}`            |
| `master.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                             | `{}`            |
| `master.resources.limits`                   | The resources limits for the Redis(TM) master containers                                         | `{}`            |
| `master.resources.requests`                 | The requested resources for the Redis(TM) master containers                                      | `{}`            |
| `master.podSecurityContext.enabled`         | Enabled Redis(TM) master pods' Security Context                                                  | `true`          |
| `master.podSecurityContext.fsGroup`         | Set Redis(TM) master pod's Security Context fsGroup                                              | `1001`          |
| `master.containerSecurityContext.enabled`   | Enabled Redis(TM) master containers' Security Context                                            | `true`          |
| `master.containerSecurityContext.runAsUser` | Set Redis(TM) master containers' Security Context runAsUser                                      | `1001`          |
| `master.schedulerName`                      | Alternate scheduler for Redis(TM) master pods                                                    | `nil`           |
| `master.updateStrategy.type`                | Redis(TM) master statefulset strategy type                                                       | `RollingUpdate` |
| `master.priorityClassName`                  | Redis(TM) master pods' priorityClassName                                                         | `""`            |
| `master.hostAliases`                        | Redis(TM) master pods host aliases                                                               | `[]`            |
| `master.podLabels`                          | Extra labels for Redis(TM) master pods                                                           | `{}`            |
| `master.podAnnotations`                     | Annotations for Redis(TM) master pods                                                            | `{}`            |
| `master.shareProcessNamespace`              | Share a single process namespace between all of the containers in Redis(TM) master pods          | `false`         |
| `master.podAffinityPreset`                  | Pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `master.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `master.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `master.nodeAffinityPreset.key`             | Node label key to match. Ignored if `master.affinity` is set                                     | `""`            |
| `master.nodeAffinityPreset.values`          | Node label values to match. Ignored if `master.affinity` is set                                  | `[]`            |
| `master.affinity`                           | Affinity for Redis(TM) master pods assignment                                                    | `{}`            |
| `master.nodeSelector`                       | Node labels for Redis(TM) master pods assignment                                                 | `{}`            |
| `master.tolerations`                        | Tolerations for Redis(TM) master pods assignment                                                 | `[]`            |
| `master.spreadConstraints`                  | Spread Constraints for Redis(TM) master pod assignment                                           | `{}`            |
| `master.lifecycleHooks`                     | for the Redis(TM) master container(s) to automate configuration before or after startup          | `{}`            |
| `master.extraVolumes`                       | Optionally specify extra list of additional volumes for the Redis(TM) master pod(s)              | `[]`            |
| `master.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the Redis(TM) master container(s)   | `[]`            |
| `master.sidecars`                           | Add additional sidecar containers to the Redis(TM) master pod(s)                                 | `{}`            |
| `master.initContainers`                     | Add additional init containers to the Redis(TM) master pod(s)                                    | `{}`            |
| `master.persistence.enabled`                | Enable persistence on Redis(TM) master nodes using Persistent Volume Claims                      | `true`          |
| `master.persistence.path`                   | The path the volume will be mounted at on Redis(TM) master containers                            | `/data`         |
| `master.persistence.subPath`                | The subdirectory of the volume to mount on Redis(TM) master containers                           | `""`            |
| `master.persistence.storageClass`           | Persistent Volume storage class                                                                  | `nil`           |
| `master.persistence.accessModes`            | Persistent Volume access modes                                                                   | `[]`            |
| `master.persistence.size`                   | Persistent Volume size                                                                           | `8Gi`           |
| `master.persistence.annotations`            | Additional custom annotations for the PVC                                                        | `{}`            |
| `master.persistence.selector`               | Additional labels to match for the PVC                                                           | `{}`            |
| `master.persistence.existingClaim`          | Use a existing PVC which must be created manually before bound                                   | `nil`           |
| `master.service.type`                       | Redis(TM) master service type                                                                    | `ClusterIP`     |
| `master.service.port`                       | Redis(TM) master service port                                                                    | `6379`          |
| `master.service.nodePort`                   | Node port for Redis(TM) master                                                                   | `nil`           |
| `master.service.externalTrafficPolicy`      | Redis(TM) master service external traffic policy                                                 | `Cluster`       |
| `master.service.clusterIP`                  | Redis(TM) master service Cluster IP                                                              | `nil`           |
| `master.service.loadBalancerIP`             | Redis(TM) master service Load Balancer IP                                                        | `nil`           |
| `master.service.loadBalancerSourceRanges`   | Redis(TM) master service Load Balancer sources                                                   | `[]`            |
| `master.service.annotations`                | Additional custom annotations for Redis(TM) master service                                       | `{}`            |
| `master.terminationGracePeriodSeconds`      | Integer setting the termination grace period for the redis-master pods                           | `30`            |


### Redis(TM) replicas configuration parameters

| Name                                         | Description                                                                                       | Value           |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- | --------------- |
| `replica.replicaCount`                       | Number of Redis(TM) replicas to deploy                                                            | `3`             |
| `replica.configuration`                      | Configuration for Redis(TM) replicas nodes                                                        | `nil`           |
| `replica.disableCommands`                    | Array with Redis(TM) commands to disable on replicas nodes                                        | `[]`            |
| `replica.command`                            | Override default container command (useful when using custom images)                              | `[]`            |
| `replica.args`                               | Override default container args (useful when using custom images)                                 | `[]`            |
| `replica.preExecCmds`                        | Additional commands to run prior to starting Redis(TM) replicas                                   | `[]`            |
| `replica.extraFlags`                         | Array with additional command line flags for Redis(TM) replicas                                   | `[]`            |
| `replica.extraEnvVars`                       | Array with extra environment variables to add to Redis(TM) replicas nodes                         | `[]`            |
| `replica.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for Redis(TM) replicas nodes                 | `nil`           |
| `replica.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for Redis(TM) replicas nodes                    | `nil`           |
| `replica.containerPort`                      | Container port to open on Redis(TM) replicas nodes                                                | `6379`          |
| `replica.livenessProbe.enabled`              | Enable livenessProbe on Redis(TM) replicas nodes                                                  | `true`          |
| `replica.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                           | `5`             |
| `replica.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                  | `5`             |
| `replica.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                 | `5`             |
| `replica.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                               | `5`             |
| `replica.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                               | `1`             |
| `replica.readinessProbe.enabled`             | Enable readinessProbe on Redis(TM) replicas nodes                                                 | `true`          |
| `replica.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                          | `5`             |
| `replica.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                 | `5`             |
| `replica.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                | `1`             |
| `replica.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                              | `5`             |
| `replica.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                              | `1`             |
| `replica.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                               | `{}`            |
| `replica.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                              | `{}`            |
| `replica.resources.limits`                   | The resources limits for the Redis(TM) replicas containers                                        | `{}`            |
| `replica.resources.requests`                 | The requested resources for the Redis(TM) replicas containers                                     | `{}`            |
| `replica.podSecurityContext.enabled`         | Enabled Redis(TM) replicas pods' Security Context                                                 | `true`          |
| `replica.podSecurityContext.fsGroup`         | Set Redis(TM) replicas pod's Security Context fsGroup                                             | `1001`          |
| `replica.containerSecurityContext.enabled`   | Enabled Redis(TM) replicas containers' Security Context                                           | `true`          |
| `replica.containerSecurityContext.runAsUser` | Set Redis(TM) replicas containers' Security Context runAsUser                                     | `1001`          |
| `replica.schedulerName`                      | Alternate scheduler for Redis(TM) replicas pods                                                   | `nil`           |
| `replica.updateStrategy.type`                | Redis(TM) replicas statefulset strategy type                                                      | `RollingUpdate` |
| `replica.priorityClassName`                  | Redis(TM) replicas pods' priorityClassName                                                        | `""`            |
| `replica.hostAliases`                        | Redis(TM) replicas pods host aliases                                                              | `[]`            |
| `replica.podLabels`                          | Extra labels for Redis(TM) replicas pods                                                          | `{}`            |
| `replica.podAnnotations`                     | Annotations for Redis(TM) replicas pods                                                           | `{}`            |
| `replica.shareProcessNamespace`              | Share a single process namespace between all of the containers in Redis(TM) replicas pods         | `false`         |
| `replica.podAffinityPreset`                  | Pod affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `replica.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `replica.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `replica.nodeAffinityPreset.key`             | Node label key to match. Ignored if `replica.affinity` is set                                     | `""`            |
| `replica.nodeAffinityPreset.values`          | Node label values to match. Ignored if `replica.affinity` is set                                  | `[]`            |
| `replica.affinity`                           | Affinity for Redis(TM) replicas pods assignment                                                   | `{}`            |
| `replica.nodeSelector`                       | Node labels for Redis(TM) replicas pods assignment                                                | `{}`            |
| `replica.tolerations`                        | Tolerations for Redis(TM) replicas pods assignment                                                | `[]`            |
| `replica.spreadConstraints`                  | Spread Constraints for Redis(TM) replicas pod assignment                                          | `{}`            |
| `replica.lifecycleHooks`                     | for the Redis(TM) replica container(s) to automate configuration before or after startup          | `{}`            |
| `replica.extraVolumes`                       | Optionally specify extra list of additional volumes for the Redis(TM) replicas pod(s)             | `[]`            |
| `replica.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the Redis(TM) replicas container(s)  | `[]`            |
| `replica.sidecars`                           | Add additional sidecar containers to the Redis(TM) replicas pod(s)                                | `{}`            |
| `replica.initContainers`                     | Add additional init containers to the Redis(TM) replicas pod(s)                                   | `{}`            |
| `replica.persistence.enabled`                | Enable persistence on Redis(TM) replicas nodes using Persistent Volume Claims                     | `true`          |
| `replica.persistence.path`                   | The path the volume will be mounted at on Redis(TM) replicas containers                           | `/data`         |
| `replica.persistence.subPath`                | The subdirectory of the volume to mount on Redis(TM) replicas containers                          | `""`            |
| `replica.persistence.storageClass`           | Persistent Volume storage class                                                                   | `nil`           |
| `replica.persistence.accessModes`            | Persistent Volume access modes                                                                    | `[]`            |
| `replica.persistence.size`                   | Persistent Volume size                                                                            | `8Gi`           |
| `replica.persistence.annotations`            | Additional custom annotations for the PVC                                                         | `{}`            |
| `replica.persistence.selector`               | Additional labels to match for the PVC                                                            | `{}`            |
| `replica.service.type`                       | Redis(TM) replicas service type                                                                   | `ClusterIP`     |
| `replica.service.port`                       | Redis(TM) replicas service port                                                                   | `6379`          |
| `replica.service.nodePort`                   | Node port for Redis(TM) replicas                                                                  | `nil`           |
| `replica.service.externalTrafficPolicy`      | Redis(TM) replicas service external traffic policy                                                | `Cluster`       |
| `replica.service.clusterIP`                  | Redis(TM) replicas service Cluster IP                                                             | `nil`           |
| `replica.service.loadBalancerIP`             | Redis(TM) replicas service Load Balancer IP                                                       | `nil`           |
| `replica.service.loadBalancerSourceRanges`   | Redis(TM) replicas service Load Balancer sources                                                  | `[]`            |
| `replica.service.annotations`                | Additional custom annotations for Redis(TM) replicas service                                      | `{}`            |
| `replica.terminationGracePeriodSeconds`      | Integer setting the termination grace period for the redis-replicas pods                          | `30`            |


### Redis(TM) Sentinel configuration parameters

| Name                                          | Description                                                                                      | Value                    |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------ |
| `sentinel.enabled`                            | Use Redis(TM) Sentinel on Redis(TM) pods.                                                        | `false`                  |
| `sentinel.image.registry`                     | Redis(TM) Sentinel image registry                                                                | `docker.io`              |
| `sentinel.image.repository`                   | Redis(TM) Sentinel image repository                                                              | `bitnami/redis-sentinel` |
| `sentinel.image.tag`                          | Redis(TM) Sentinel image tag (immutable tags are recommended)                                    | `6.0.9-debian-10-r38`    |
| `sentinel.image.pullPolicy`                   | Redis(TM) Sentinel image pull policy                                                             | `IfNotPresent`           |
| `sentinel.image.pullSecrets`                  | Redis(TM) Sentinel image pull secrets                                                            | `[]`                     |
| `sentinel.image.debug`                        | Enable image debug mode                                                                          | `false`                  |
| `sentinel.masterSet`                          | Master set name                                                                                  | `mymaster`               |
| `sentinel.quorum`                             | Sentinel Quorum                                                                                  | `2`                      |
| `sentinel.downAfterMilliseconds`              | Timeout for detecting a Redis(TM) node is down                                                   | `60000`                  |
| `sentinel.failoverTimeout`                    | Timeout for performing a election failover                                                       | `18000`                  |
| `sentinel.cleanDelaySeconds`                  | Delay seconds when cleaning nodes IPs                                                            | `5`                      |
| `sentinel.parallelSyncs`                      | Number of replicas that can be reconfigured in parallel to use the new master after a failover   | `1`                      |
| `sentinel.staticID`                           | Enable static Sentinel IDs for each replica                                                      | `false`                  |
| `sentinel.configuration`                      | Configuration for Redis(TM) Sentinel nodes                                                       | `nil`                    |
| `sentinel.command`                            | Override default container command (useful when using custom images)                             | `[]`                     |
| `sentinel.args`                               | Override default container args (useful when using custom images)                                | `[]`                     |
| `sentinel.preExecCmds`                        | Additional commands to run prior to starting Redis(TM) Sentinel                                  | `[]`                     |
| `sentinel.containerPort`                      | Container port to open on Redis(TM) Sentinel nodes                                               | `26379`                  |
| `sentinel.livenessProbe.enabled`              | Enable livenessProbe on Redis(TM) Sentinel nodes                                                 | `true`                   |
| `sentinel.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                          | `5`                      |
| `sentinel.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                 | `5`                      |
| `sentinel.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                | `5`                      |
| `sentinel.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                              | `5`                      |
| `sentinel.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                              | `1`                      |
| `sentinel.readinessProbe.enabled`             | Enable readinessProbe on Redis(TM) Sentinel nodes                                                | `true`                   |
| `sentinel.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                         | `5`                      |
| `sentinel.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                | `5`                      |
| `sentinel.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                               | `1`                      |
| `sentinel.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                             | `5`                      |
| `sentinel.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                             | `1`                      |
| `sentinel.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                              | `{}`                     |
| `sentinel.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                             | `{}`                     |
| `sentinel.resources.limits`                   | The resources limits for the Redis(TM) Sentinel containers                                       | `{}`                     |
| `sentinel.resources.requests`                 | The requested resources for the Redis(TM) Sentinel containers                                    | `{}`                     |
| `sentinel.containerSecurityContext.enabled`   | Enabled Redis(TM) Sentinel containers' Security Context                                          | `true`                   |
| `sentinel.containerSecurityContext.runAsUser` | Set Redis(TM) Sentinel containers' Security Context runAsUser                                    | `1001`                   |
| `sentinel.lifecycleHooks`                     | for the Redis(TM) sentinel container(s) to automate configuration before or after startup        | `{}`                     |
| `sentinel.extraVolumes`                       | Optionally specify extra list of additional volumes for the Redis(TM) Sentinel                   | `[]`                     |
| `sentinel.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the Redis(TM) Sentinel container(s) | `[]`                     |
| `sentinel.service.type`                       | Redis(TM) Sentinel service type                                                                  | `ClusterIP`              |
| `sentinel.service.port`                       | Redis(TM) service port for Redis(TM)                                                             | `6379`                   |
| `sentinel.service.sentinelPort`               | Redis(TM) service port for Sentinel                                                              | `26379`                  |
| `sentinel.service.nodePorts.redis`            | Node port for Redis(TM)                                                                          | `nil`                    |
| `sentinel.service.nodePorts.sentinel`         | Node port for Sentinel                                                                           | `nil`                    |
| `sentinel.service.externalTrafficPolicy`      | Redis(TM) Sentinel service external traffic policy                                               | `Cluster`                |
| `sentinel.service.clusterIP`                  | Redis(TM) Sentinel service Cluster IP                                                            | `nil`                    |
| `sentinel.service.loadBalancerIP`             | Redis(TM) Sentinel service Load Balancer IP                                                      | `nil`                    |
| `sentinel.service.loadBalancerSourceRanges`   | Redis(TM) Sentinel service Load Balancer sources                                                 | `[]`                     |
| `sentinel.service.annotations`                | Additional custom annotations for Redis(TM) Sentinel service                                     | `{}`                     |
| `sentinel.terminationGracePeriodSeconds`      | Integer setting the termination grace period for the redis-node pods                             | `30`                     |


### Other Parameters

| Name                                    | Description                                                         | Value   |
| --------------------------------------- | ------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                          | `false` |
| `networkPolicy.allowExternal`           | Don't require client label for connections                          | `true`  |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                        | `[]`    |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                        | `[]`    |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces              | `{}`    |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces          | `{}`    |
| `podSecurityPolicy.create`              | Specifies whether a PodSecurityPolicy should be created             | `false` |
| `rbac.create`                           | Specifies whether RBAC resources should be created                  | `false` |
| `rbac.rules`                            | Custom RBAC rules to set                                            | `[]`    |
| `serviceAccount.create`                 | Specifies whether a ServiceAccount should be created                | `true`  |
| `serviceAccount.name`                   | The name of the ServiceAccount to use.                              | `""`    |
| `serviceAccount.annotations`            | Additional custom annotations for the ServiceAccount                | `{}`    |
| `pdb.create`                            | Specifies whether a ServiceAccount should be created                | `false` |
| `pdb.minAvailable`                      | Min number of pods that must still be available after the eviction  | `1`     |
| `pdb.maxUnavailable`                    | Max number of pods that can be unavailable after the eviction       | `nil`   |
| `tls.enabled`                           | Enable TLS traffic                                                  | `false` |
| `tls.authClients`                       | Require clients to authenticate                                     | `true`  |
| `tls.certificatesSecret`                | Then name of the existing secret that contains the TLS certificates | `nil`   |
| `tls.certFilename`                      | Certificate filename                                                | `nil`   |
| `tls.certKeyFilename`                   | Certificate Key filename                                            | `nil`   |
| `tls.certCAFilename`                    | CA Certificate filename                                             | `nil`   |
| `tls.dhParamsFilename`                  | File containing DH params (in order to support DH based ciphers)    | `nil`   |


### Metrics Parameters

| Name                                                  | Description                                                                                      | Value                             |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------- |
| `metrics.enabled`                                     | Start a sidecar prometheus exporter to expose Redis(TM) metrics                                  | `false`                           |
| `metrics.image.registry`                              | Redis(TM) Exporter image registry                                                                | `docker.io`                       |
| `metrics.image.repository`                            | Redis(TM) Exporter image repository                                                              | `bitnami/redis-exporter`          |
| `metrics.image.tag`                                   | Redis(TM) Redis(TM) Exporter image tag (immutable tags are recommended)                          | `1.20.0-debian-10-r16`            |
| `metrics.image.pullPolicy`                            | Redis(TM) Exporter image pull policy                                                             | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                           | Redis(TM) Exporter image pull secrets                                                            | `[]`                              |
| `metrics.redisTargetHost`                             | A way to specify an alternative Redis(TM) hostname                                               | `localhost`                       |
| `metrics.extraArgs`                                   | Extra arguments for Redis(TM) exporter, for example:                                             | `{}`                              |
| `metrics.containerSecurityContext.enabled`            | Enabled Redis(TM) exporter containers' Security Context                                          | `true`                            |
| `metrics.containerSecurityContext.runAsUser`          | Set Redis(TM) exporter containers' Security Context runAsUser                                    | `1001`                            |
| `metrics.resources.limits`                            | The resources limits for the Redis(TM) exporter container                                        | `{}`                              |
| `metrics.resources.requests`                          | The requested resources for the Redis(TM) exporter container                                     | `{}`                              |
| `metrics.podLabels`                                   | Extra labels for Redis(TM) exporter pods                                                         | `{}`                              |
| `metrics.podAnnotations`                              | Annotations for Redis(TM) exporter pods                                                          | `{}`                              |
| `metrics.service.type`                                | Redis(TM) exporter service type                                                                  | `ClusterIP`                       |
| `metrics.service.port`                                | Redis(TM) exporter service port                                                                  | `9121`                            |
| `metrics.service.externalTrafficPolicy`               | Redis(TM) exporter service external traffic policy                                               | `Cluster`                         |
| `metrics.service.loadBalancerIP`                      | Redis(TM) exporter service Load Balancer IP                                                      | `""`                              |
| `metrics.service.loadBalancerSourceRanges`            | Redis(TM) exporter service Load Balancer sources                                                 | `[]`                              |
| `metrics.service.annotations`                         | Additional custom annotations for Redis(TM) exporter service                                     | `{}`                              |
| `metrics.sentinel.enabled`                            | Start a sidecar prometheus exporter to expose Redis(TM) Sentinel metrics                         | `false`                           |
| `metrics.sentinel.image.registry`                     | Redis(TM) Sentinel Exporter image registry                                                       | `docker.io`                       |
| `metrics.sentinel.image.repository`                   | Redis(TM) Sentinel Exporter image repository                                                     | `bitnami/redis-sentinel-exporter` |
| `metrics.sentinel.image.tag`                          | Redis(TM) Redis(TM) Sentinel Exporter image tag (immutable tags are recommended)                 | `1.7.1-debian-10-r109`            |
| `metrics.sentinel.image.pullPolicy`                   | Redis(TM) Sentinel Exporter image pull policy                                                    | `IfNotPresent`                    |
| `metrics.sentinel.image.pullSecrets`                  | Redis(TM) Sentinel Exporter image pull secrets                                                   | `[]`                              |
| `metrics.sentinel.extraArgs`                          | Extra arguments for Redis(TM) Sentinel exporter, for example:                                    | `{}`                              |
| `metrics.sentinel.containerSecurityContext.enabled`   | Enabled Redis(TM) Sentinel exporter containers' Security Context                                 | `true`                            |
| `metrics.sentinel.containerSecurityContext.runAsUser` | Set Redis(TM) Sentinel exporter containers' Security Context runAsUser                           | `1001`                            |
| `metrics.sentinel.resources.limits`                   | The resources limits for the Redis(TM) Sentinel exporter container                               | `{}`                              |
| `metrics.sentinel.resources.requests`                 | The requested resources for the Redis(TM) Sentinel exporter container                            | `{}`                              |
| `metrics.sentinel.service.type`                       | Redis(TM) Sentinel exporter service type                                                         | `ClusterIP`                       |
| `metrics.sentinel.service.port`                       | Redis(TM) Sentinel exporter service port                                                         | `9355`                            |
| `metrics.sentinel.service.externalTrafficPolicy`      | Redis(TM) Sentinel exporter service external traffic policy                                      | `Cluster`                         |
| `metrics.sentinel.service.loadBalancerIP`             | Redis(TM) Sentinel exporter service Load Balancer IP                                             | `""`                              |
| `metrics.sentinel.service.loadBalancerSourceRanges`   | Redis(TM) Sentinel exporter service Load Balancer sources                                        | `[]`                              |
| `metrics.sentinel.service.annotations`                | Additional custom annotations for Redis(TM) Sentinel exporter service                            | `{}`                              |
| `metrics.serviceMonitor.enabled`                      | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator                  | `false`                           |
| `metrics.serviceMonitor.namespace`                    | The namespace in which the ServiceMonitor will be created                                        | `nil`                             |
| `metrics.serviceMonitor.interval`                     | The interval at which metrics should be scraped                                                  | `30s`                             |
| `metrics.serviceMonitor.scrapeTimeout`                | The timeout after which the scrape is ended                                                      | `nil`                             |
| `metrics.serviceMonitor.relabellings`                 | Metrics relabellings to add to the scrape endpoint                                               | `[]`                              |
| `metrics.serviceMonitor.honorLabels`                  | Specify honorLabels parameter to add the scrape endpoint                                         | `false`                           |
| `metrics.serviceMonitor.additionalLabels`             | Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus | `{}`                              |
| `metrics.prometheusRule.enabled`                      | Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator            | `false`                           |
| `metrics.prometheusRule.namespace`                    | The namespace in which the prometheusRule will be created                                        | `nil`                             |
| `metrics.prometheusRule.additionalLabels`             | Additional labels for the prometheusRule                                                         | `{}`                              |
| `metrics.prometheusRule.rules`                        | Custom Prometheus rules                                                                          | `[]`                              |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                   |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `10`                    |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `Always`                |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |
| `sysctl.enabled`                                       | Enable init container to modify Kernel settings                                                 | `false`                 |
| `sysctl.image.registry`                                | Bitnami Shell image registry                                                                    | `docker.io`             |
| `sysctl.image.repository`                              | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `sysctl.image.tag`                                     | Bitnami Shell image tag (immutable tags are recommended)                                        | `10`                    |
| `sysctl.image.pullPolicy`                              | Bitnami Shell image pull policy                                                                 | `Always`                |
| `sysctl.image.pullSecrets`                             | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `sysctl.command`                                       | Override default init-sysctl container command (useful when using custom images)                | `[]`                    |
| `sysctl.mountHostSys`                                  | Mount the host `/sys` folder to `/host-sys`                                                     | `false`                 |
| `sysctl.resources.limits`                              | The resources limits for the init container                                                     | `{}`                    |
| `sysctl.resources.requests`                            | The requested resources for the init container                                                  | `{}`                    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set auth.password=secretpassword \
    bitnami/redis
```

The above command sets the Redis<sup>TM</sup> server password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/redis
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Redis<sup>TM</sup> version

To modify the Redis<sup>TM</sup> version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/redis/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Cluster topologies

#### Default: Master-Replicas

When installing the chart with `architecture=replication`, it will deploy a Redis<sup>TM</sup> master StatefulSet (only one master node allowed) and a Redis<sup>TM</sup> replicas StatefulSet. The replicas will be read-replicas of the master. Two services will be exposed:

- Redis<sup>TM</sup> Master service: Points to the master, where read-write operations can be performed
- Redis<sup>TM</sup> Replicas service: Points to the replicas, where only read operations are allowed.

In case the master crashes, the replicas will wait until the master node is respawned again by the Kubernetes Controller Manager.

#### Standalone

When installing the chart with `architecture=standalone`, it will deploy a standalone Redis<sup>TM</sup> StatefulSet (only one node allowed) and a Redis<sup>TM</sup> replicas StatefulSet. A single service will be exposed:

- Redis<sup>TM</sup> Master service: Points to the master, where read-write operations can be performed

#### Master-Replicas with Sentinel

When installing the chart with `architecture=replication` and `sentinel.enabled=true`, it will deploy a Redis<sup>TM</sup> master StatefulSet (only one master allowed) and a Redis<sup>TM</sup> replicas StatefulSet. In this case, the pods will contain an extra container with Redis<sup>TM</sup> Sentinel. This container will form a cluster of Redis<sup>TM</sup> Sentinel nodes, which will promote a new master in case the actual one fails. In addition to this, only one service is exposed:

- Redis<sup>TM</sup> service: Exposes port 6379 for Redis<sup>TM</sup> read-only operations and port 26379 for accessing Redis<sup>TM</sup> Sentinel.

For read-only operations, access the service using port 6379. For write operations, it's necessary to access the Redis<sup>TM</sup> Sentinel cluster and query the current master using the command below (using redis-cli or similar):

```
SENTINEL get-master-addr-by-name <name of your MasterSet. e.g: mymaster>
```

This command will return the address of the current master, which can be accessed from inside the cluster.

In case the current master crashes, the Sentinel containers will elect a new master node.

### Using password file

To use a password file for Redis<sup>TM</sup> you need to create a secret containing the password.

> *NOTE*: It is important that the file with the password must be called `redis-password`

And then deploy the Helm Chart using the secret name as parameter:

```console
auth.enabled=true
auth.usePasswordFiles=true
auth.existingSecret=redis-password-file
sentinels.enabled=true
metrics.enabled=true
```

### Securing traffic using TLS

TLS support can be enabled in the chart by specifying the `tls.` parameters while creating a release. The following parameters should be configured to properly enable the TLS support in the chart:

- `tls.enabled`: Enable TLS support. Defaults to `false`
- `tls.certificatesSecret`: Name of the secret that contains the certificates. No defaults.
- `tls.certFilename`: Certificate filename. No defaults.
- `tls.certKeyFilename`: Certificate key filename. No defaults.
- `tls.certCAFilename`: CA Certificate filename. No defaults.

For example:

First, create the secret with the certificates files:

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

### Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9121) is exposed in the service. Metrics can be scraped from within the cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml). If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.

If you have enabled TLS by specifying `tls.enabled=true` you also need to specify TLS option to the metrics exporter. You can do that via `metrics.extraArgs`. You can find the metrics exporter CLI flags for TLS [here](https://github.com/oliver006/redis_exporter#command-line-flags). For example:

You can either specify `metrics.extraArgs.skip-tls-verification=true` to skip TLS verification or providing the following values under `metrics.extraArgs` for TLS client authentication:

```console
tls-client-key-file
tls-client-cert-file
tls-ca-cert-file
```

### Host Kernel Settings

Redis<sup>TM</sup> may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages. To do so, you can set up a privileged initContainer with the `sysctlImage` config values, for example:

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

Alternatively, for Kubernetes 1.12+ you can set `securityContext.sysctls` which will configure sysctls for master and slave pods. Example:

```yaml
securityContext:
  sysctls:
  - name: net.core.somaxconn
    value: "10000"
```

Note that this will not disable transparent huge tables.

## Persistence

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at the `/data` path. The volume is created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```bash
$ helm install my-release --set master.persistence.existingClaim=PVC_NAME bitnami/redis
```

## Backup and restore

### Backup

To perform a backup you will need to connect to one of the nodes and execute:

```bash
$ kubectl exec -it my-redis-master-0 bash

$ redis-cli
127.0.0.1:6379> auth your_current_redis_password
OK
127.0.0.1:6379> save
OK
```

Then you will need to get the created dump file form the redis node:

```bash
$ kubectl cp my-redis-master-0:/data/dump.rdb dump.rdb -c redis
```

### Restore

To restore in a new cluster, you will need to change a parameter in the redis.conf file and then upload the `dump.rdb` to the volume. Follow the following steps:

- First you will need to set in the `values.yaml` the parameter `appendonly` to `no`, if it is already `no` you can skip this step.

```yaml
configmap: |-
  # Enable AOF https://redis.io/topics/persistence#append-only-file
  appendonly no
  # Disable RDB persistence, AOF persistence already enabled.
  save ""
```

- Start the new cluster to create the PVCs.

For example, :

```bash
helm install new-redis  -f values.yaml . --set architecture=replication  --set replica.replicaCount=3
```

- Now that the PVC were created, stop it and copy the `dump.rdp` on the persisted data by using a helping pod.

```
$ helm delete new-redis

$ kubectl run --generator=run-pod/v1 -i --rm --tty volpod --overrides='
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "name": "redisvolpod"
    },
    "spec": {
        "containers": [{
            "command": [
                "tail",
                "-f",
                "/dev/null"
            ],
            "image": "bitnami/minideb",
            "name": "mycontainer",
            "volumeMounts": [{
                "mountPath": "/mnt",
                "name": "redisdata"
            }]
        }],
        "restartPolicy": "Never",
        "volumes": [{
            "name": "redisdata",
            "persistentVolumeClaim": {
                "claimName": "redis-data-new-redis-master-0"
            }
        }]
    }
}' --image="bitnami/minideb"

$ kubectl cp dump.rdb redisvolpod:/mnt/dump.rdb
$ kubectl delete pod volpod
```

- Start again the cluster:

```
helm install new-redis  -f values.yaml .  --set architecture=replication  --set replica.replicaCount=3
```

## NetworkPolicy

To enable network policy for Redis<sup>TM</sup>, install [a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin), and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

With NetworkPolicy enabled, only pods with the generated client label will be able to connect to Redis<sup>TM</sup>. This label will be displayed in the output after a successful install.

With `networkPolicy.ingressNSMatchLabels` pods from other namespaces can connect to redis. Set `networkPolicy.ingressNSPodMatchLabels` to match pod labels in matched namespace. For example, for a namespace labeled `redis=external` and pods in that namespace labeled `redis-client=true` the fields should be set:

```
networkPolicy:
  enabled: true
  ingressNSMatchLabels:
    redis: external
  ingressNSPodMatchLabels:
    redis-client: true
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an
incompatible breaking change needing manual actions.

### To 14.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - The term *slave* has been replaced by the term *replica*. Therefore, parameters prefixed with `slave` are now prefixed with `replicas`.
  - Credentials parameter are reorganized under the `auth` parameter.
  - `cluster.enabled` parameter is deprecated in favor of `architecture` parameter that accepts two values: `standalone` and `replication`.
  - `securityContext.*` is deprecated in favor of `XXX.podSecurityContext` and `XXX.containerSecurityContext`.
  - `sentinel.metrics.*` parameters are deprecated in favor of `metrics.sentinel.*` ones.
- New parameters to add custom command, environment variables, sidecars, init containers, etc. were added.
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- values.yaml metadata was adapted to follow the format supported by [readmenator](https://github.com/bitnami-labs/readmenator).

Consequences:

Backwards compatibility is not guaranteed. To upgrade to `14.0.0`, install a new release of the Redis<sup>TM</sup> chart, and migrate the data from your previous release. You have 2 alternatives to do so:

- Create a backup of the database, and restore it on the new release as explained in the [Backup and restore](#backup-and-restore) section.
- Reuse the PVC used to hold the master data on your previous release. To do so, use the `master.persistence.existingClaim` parameter. The following example assumes that the release name is `redis`:

```bash
$ helm install redis bitnami/redis --set auth.password=[PASSWORD] --set master.persistence.existingClaim=[EXISTING_PVC]
```

| Note: you need to substitute the placeholder _[EXISTING_PVC]_ with the name of the PVC used on your previous release, and _[PASSWORD]_ with the password used in your previous release.

### To 13.0.0

This major version updates the Redis<sup>TM</sup> docker image version used from `6.0` to `6.2`, the new stable version. There are no major changes in the chart and there shouldn't be any breaking changes in it as `6.2` is basically a stricter superset of `6.0`. For more information, please refer to [Redis<sup>TM</sup> 6.2 release notes](https://raw.githubusercontent.com/redis/redis/6.2/00-RELEASENOTES).

### To 12.3.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 12.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 11.0.0

When deployed with sentinel enabled, only a group of nodes is deployed and the master/slave role is handled in the group. To avoid breaking the compatibility, the settings for this nodes are given through the `slave.xxxx` parameters in `values.yaml`

### To 9.0.0

The metrics exporter has been changed from a separate deployment to a sidecar container, due to the latest changes in the Redis<sup>TM</sup> exporter code. Check the [official page](https://github.com/oliver006/redis_exporter/) for more information. The metrics container image was changed from oliver006/redis_exporter to bitnami/redis-exporter (Bitnami's maintained package of oliver006/redis_exporter).

### To 7.0.0

In order to improve the performance in case of slave failure, we added persistence to the read-only slaves. That means that we moved from Deployment to StatefulSets. This should not affect upgrades from previous versions of the chart, as the deployments did not contain any persistence at all.

This version also allows enabling Redis<sup>TM</sup> Sentinel containers inside of the Redis<sup>TM</sup> Pods (feature disabled by default). In case the master crashes, a new Redis<sup>TM</sup> node will be elected as master. In order to query the current master (no redis master service is exposed), you need to query first the Sentinel cluster. Find more information [in this section](#master-slave-with-sentinel).

### To 11.0.0

When using sentinel, a new statefulset called `-node` was introduced. This will break upgrading from a previous version where the statefulsets are called master and slave. Hence the PVC will not match the new naming and won't be reused. If you want to keep your data, you will need to perform a backup and then a restore the data in this new version.

### To 10.0.0

For releases with `usePassword: true`, the value `sentinel.usePassword` controls whether the password authentication also applies to the sentinel port. This defaults to `true` for a secure configuration, however it is possible to disable to account for the following cases:

- Using a version of redis-sentinel prior to `5.0.1` where the authentication feature was introduced.
- Where redis clients need to be updated to support sentinel authentication.

If using a master/slave topology, or with `usePassword: false`, no action is required.

### To 8.0.18

For releases with `metrics.enabled: true` the default tag for the exporter image is now `v1.x.x`. This introduces many changes including metrics names. You'll want to use [this dashboard](https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json) now. Please see the [redis_exporter github page](https://github.com/oliver006/redis_exporter#upgrading-from-0x-to-1x) for more details.

### To 7.0.0

This version causes a change in the Redis<sup>TM</sup> Master StatefulSet definition, so the command helm upgrade would not work out of the box. As an alternative, one of the following could be done:

- Recommended: Create a clone of the Redis<sup>TM</sup> Master PVC (for example, using projects like [this one](https://github.com/edseymour/pvc-transfer)). Then launch a fresh release reusing this cloned PVC.

   ```
   helm install my-release bitnami/redis --set persistence.existingClaim=<NEW PVC>
   ```

- Alternative (not recommended, do at your own risk): `helm delete --purge` does not remove the PVC assigned to the Redis<sup>TM</sup> Master StatefulSet. As a consequence, the following commands can be done to upgrade the release

   ```
   helm delete --purge <RELEASE>
   helm install <RELEASE> bitnami/redis
   ```

Previous versions of the chart were not using persistence in the slaves, so this upgrade would add it to them. Another important change is that no values are inherited from master to slaves. For example, in 6.0.0 `slaves.readinessProbe.periodSeconds`, if empty, would be set to `master.readinessProbe.periodSeconds`. This approach lacked transparency and was difficult to maintain. From now on, all the slave parameters must be configured just as it is done with the masters.

Some values have changed as well:

- `master.port` and `slave.port` have been changed to `redisPort` (same value for both master and slaves)
- `master.securityContext` and `slave.securityContext` have been changed to `securityContext`(same values for both master and slaves)

By default, the upgrade will not change the cluster topology. In case you want to use Redis<sup>TM</sup> Sentinel, you must explicitly set `sentinel.enabled` to `true`.

### To 6.0.0

Previous versions of the chart were using an init-container to change the permissions of the volumes. This was done in case the `securityContext` directive in the template was not enough for that (for example, with cephFS). In this new version of the chart, this container is disabled by default (which should not affect most of the deployments). If your installation still requires that init container, execute `helm upgrade` with the `--set volumePermissions.enabled=true`.

### To 5.0.0

The default image in this release may be switched out for any image containing the `redis-server`
and `redis-cli` binaries. If `redis-server` is not the default image ENTRYPOINT, `master.command`
must be specified.

#### Breaking changes

- `master.args` and `slave.args` are removed. Use `master.command` or `slave.command` instead in order to override the image entrypoint, or `master.extraFlags` to pass additional flags to `redis-server`.
- `disableCommands` is now interpreted as an array of strings instead of a string of comma separated values.
- `master.persistence.path` now defaults to `/data`.

### 4.0.0

This version removes the `chart` label from the `spec.selector.matchLabels`
which is immutable since `StatefulSet apps/v1beta2`. It has been inadvertently
added, causing any subsequent upgrade to fail. See https://github.com/helm/charts/issues/7726.

It also fixes https://github.com/helm/charts/issues/7726 where a deployment `extensions/v1beta1` can not be upgraded if `spec.selector` is not explicitly set.

Finally, it fixes https://github.com/helm/charts/issues/7803 by removing mutable labels in `spec.VolumeClaimTemplate.metadata.labels` so that it is upgradable.

In order to upgrade, delete the Redis<sup>TM</sup> StatefulSet before upgrading:

```bash
kubectl delete statefulsets.apps --cascade=false my-release-redis-master
```

And edit the Redis<sup>TM</sup> slave (and metrics if enabled) deployment:

```bash
kubectl patch deployments my-release-redis-slave --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl patch deployments my-release-redis-metrics --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
