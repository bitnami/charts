# MongoDB&reg; Sharded packaged by Bitnami

[MongoDB&reg; Sharded](https://www.mongodb.com/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB&reg; eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

This chart uses the [sharding method](https://docs.mongodb.com/manual/sharding/) for distributing data across multiple machines. This is meant for deployments with very large data sets and high throughput operations.

Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide a commercial license for any of these products. This listing has an open-source license. MongoDB&reg;  is run and maintained by MongoDB, which is a completely separate project from Bitnami.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mongodb-sharded
```

## Introduction

This chart bootstraps a [MongoDB&reg; Sharded](https://github.com/bitnami/bitnami-docker-mongodb-sharded) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/mongodb-sharded
```

The command deploys MongoDB&reg; on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`           | String to partially override mongodb.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override mongodb.fullname template                                      | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                               | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### MongoDB&reg; Sharded parameters

| Name                                  | Description                                                                                                                                               | Value                     |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`                      | MongoDB&reg; Sharded image registry                                                                                                                       | `docker.io`               |
| `image.repository`                    | MongoDB&reg; Sharded Image name                                                                                                                           | `bitnami/mongodb-sharded` |
| `image.tag`                           | MongoDB&reg; Sharded image tag (immutable tags are recommended)                                                                                           | `4.4.10-debian-10-r45`    |
| `image.pullPolicy`                    | MongoDB&reg; Sharded image pull policy                                                                                                                    | `IfNotPresent`            |
| `image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                                                          | `[]`                      |
| `image.debug`                         | Specify if debug logs should be enabled                                                                                                                   | `false`                   |
| `mongodbRootPassword`                 | MongoDB&reg; root password                                                                                                                                | `""`                      |
| `replicaSetKey`                       | Replica Set key (shared for shards and config servers)                                                                                                    | `""`                      |
| `existingSecret`                      | Existing secret with MongoDB&reg; credentials                                                                                                             | `""`                      |
| `usePasswordFile`                     | Mount credentials as files instead of using environment variables                                                                                         | `false`                   |
| `shards`                              | Number of shards to be created                                                                                                                            | `2`                       |
| `common.mongodbEnableNumactl`         | Enable launch MongoDB instance prefixed with "numactl --interleave=all"                                                                                   | `false`                   |
| `common.useHostnames`                 | Enable DNS hostnames in the replica set config                                                                                                            | `true`                    |
| `common.mongodbEnableIPv6`            | Switch to enable/disable IPv6 on MongoDB&reg;                                                                                                             | `false`                   |
| `common.mongodbDirectoryPerDB`        | Switch to enable/disable DirectoryPerDB on MongoDB&reg;                                                                                                   | `false`                   |
| `common.mongodbSystemLogVerbosity`    | MongoDB&reg; system log verbosity level                                                                                                                   | `0`                       |
| `common.mongodbDisableSystemLog`      | Whether to disable MongoDB&reg; system log or not                                                                                                         | `false`                   |
| `common.mongodbMaxWaitTimeout`        | Maximum time (in seconds) for MongoDB&reg; nodes to wait for another MongoDB&reg; node to be ready                                                        | `120`                     |
| `common.initScriptsCM`                | Configmap with init scripts to execute                                                                                                                    | `""`                      |
| `common.initScriptsSecret`            | Secret with init scripts to execute (for sensitive data)                                                                                                  | `""`                      |
| `common.extraEnvVars`                 | An array to add extra env vars                                                                                                                            | `[]`                      |
| `common.extraEnvVarsCM`               | Name of a ConfigMap containing extra env vars                                                                                                             | `""`                      |
| `common.extraEnvVarsSecret`           | Name of a Secret containing extra env vars                                                                                                                | `""`                      |
| `common.sidecars`                     | Add sidecars to the pod                                                                                                                                   | `[]`                      |
| `common.initContainers`               | Add init containers to the pod                                                                                                                            | `[]`                      |
| `common.podAnnotations`               | Additional pod annotations                                                                                                                                | `{}`                      |
| `common.podLabels`                    | Additional pod labels                                                                                                                                     | `{}`                      |
| `common.extraVolumes`                 | Array to add extra volumes                                                                                                                                | `[]`                      |
| `common.extraVolumeMounts`            | Array to add extra mounts (normally used with extraVolumes)                                                                                               | `[]`                      |
| `common.containerPorts.mongo`         | MongoDB container port                                                                                                                                    | `27017`                   |
| `common.serviceAccount.create`        | Whether to create a Service Account for all pods automatically                                                                                            | `false`                   |
| `common.serviceAccount.name`          | Name of a Service Account to be used by all Pods                                                                                                          | `""`                      |
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                   |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                          | `docker.io`               |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell`   |
| `volumePermissions.image.tag`         | Init container volume-permissions image tag                                                                                                               | `10-debian-10-r265`       |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                       | `IfNotPresent`            |
| `volumePermissions.image.pullSecrets` | Init container volume-permissions image pull secrets                                                                                                      | `[]`                      |
| `volumePermissions.resources`         | Init container resource requests/limit                                                                                                                    | `{}`                      |
| `securityContext.enabled`             | Enable security context                                                                                                                                   | `true`                    |
| `securityContext.fsGroup`             | Group ID for the container                                                                                                                                | `1001`                    |
| `securityContext.runAsUser`           | User ID for the container                                                                                                                                 | `1001`                    |
| `securityContext.runAsNonRoot`        | Run containers as non-root users                                                                                                                          | `true`                    |
| `service.name`                        | Specify an explicit service name                                                                                                                          | `""`                      |
| `service.annotations`                 | Additional service annotations (evaluate as a template)                                                                                                   | `{}`                      |
| `service.type`                        | Service type                                                                                                                                              | `ClusterIP`               |
| `service.externalTrafficPolicy`       | External traffic policy                                                                                                                                   | `Cluster`                 |
| `service.port`                        | MongoDB&reg; service port                                                                                                                                 | `27017`                   |
| `service.clusterIP`                   | Static clusterIP or None for headless services                                                                                                            | `""`                      |
| `service.nodePort`                    | Specify the nodePort value for the LoadBalancer and NodePort service types.                                                                               | `""`                      |
| `service.externalIPs`                 | External IP list to use with ClusterIP service type                                                                                                       | `[]`                      |
| `service.loadBalancerIP`              | Static IP Address to use for LoadBalancer service type                                                                                                    | `""`                      |
| `service.loadBalancerSourceRanges`    | List of IP ranges allowed access to load balancer (if supported)                                                                                          | `[]`                      |
| `service.extraPorts`                  | Extra ports to expose (normally used with the `sidecar` value)                                                                                            | `[]`                      |
| `service.sessionAffinity`             | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                      | `None`                    |
| `livenessProbe.enabled`               | Enable livenessProbe                                                                                                                                      | `true`                    |
| `livenessProbe.initialDelaySeconds`   | Initial delay seconds for livenessProbe                                                                                                                   | `60`                      |
| `livenessProbe.periodSeconds`         | Period seconds for livenessProbe                                                                                                                          | `10`                      |
| `livenessProbe.timeoutSeconds`        | Timeout seconds for livenessProbe                                                                                                                         | `5`                       |
| `livenessProbe.failureThreshold`      | Failure threshold for livenessProbe                                                                                                                       | `6`                       |
| `livenessProbe.successThreshold`      | Success threshold for livenessProbe                                                                                                                       | `1`                       |
| `readinessProbe.enabled`              | Enable readinessProbe                                                                                                                                     | `true`                    |
| `readinessProbe.initialDelaySeconds`  | Initial delay seconds for readinessProbe                                                                                                                  | `60`                      |
| `readinessProbe.periodSeconds`        | Period seconds for readinessProbe                                                                                                                         | `10`                      |
| `readinessProbe.timeoutSeconds`       | Timeout seconds for readinessProbe                                                                                                                        | `5`                       |
| `readinessProbe.failureThreshold`     | Failure threshold for readinessProbe                                                                                                                      | `6`                       |
| `readinessProbe.successThreshold`     | Success threshold for readinessProbe                                                                                                                      | `1`                       |


### Config Server parameters

| Name                                  | Description                                                                                             | Value               |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `configsvr.replicas`                  | Number of nodes in the replica set (the first node will be primary)                                     | `1`                 |
| `configsvr.resources`                 | Configure pod resources                                                                                 | `{}`                |
| `configsvr.hostAliases`               | Deployment pod host aliases                                                                             | `[]`                |
| `configsvr.mongodbExtraFlags`         | MongoDB&reg; additional command line flags                                                              | `[]`                |
| `configsvr.priorityClassName`         | Pod priority class name                                                                                 | `""`                |
| `configsvr.podAffinityPreset`         | Config Server Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                |
| `configsvr.podAntiAffinityPreset`     | Config Server Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`              |
| `configsvr.nodeAffinityPreset.type`   | Config Server Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                |
| `configsvr.nodeAffinityPreset.key`    | Config Server Node label key to match Ignored if `affinity` is set.                                     | `""`                |
| `configsvr.nodeAffinityPreset.values` | Config Server Node label values to match. Ignored if `affinity` is set.                                 | `[]`                |
| `configsvr.affinity`                  | Config Server Affinity for pod assignment                                                               | `{}`                |
| `configsvr.nodeSelector`              | Config Server Node labels for pod assignment                                                            | `{}`                |
| `configsvr.tolerations`               | Config Server Tolerations for pod assignment                                                            | `[]`                |
| `configsvr.podManagementPolicy`       | Statefulset's pod management policy, allows parallel startup of pods                                    | `OrderedReady`      |
| `configsvr.updateStrategy.type`       | updateStrategy for MongoDB&reg; Primary, Secondary and Arbiter statefulsets                             | `RollingUpdate`     |
| `configsvr.config`                    | MongoDB&reg; configuration file                                                                         | `""`                |
| `configsvr.configCM`                  | ConfigMap name with Config Server configuration file (cannot be used with configsvr.config)             | `""`                |
| `configsvr.extraEnvVars`              | An array to add extra env vars                                                                          | `[]`                |
| `configsvr.extraEnvVarsCM`            | Name of a ConfigMap containing extra env vars                                                           | `""`                |
| `configsvr.extraEnvVarsSecret`        | Name of a Secret containing extra env vars                                                              | `""`                |
| `configsvr.sidecars`                  | Add sidecars to the pod                                                                                 | `[]`                |
| `configsvr.initContainers`            | Add init containers to the pod                                                                          | `[]`                |
| `configsvr.podAnnotations`            | Additional pod annotations                                                                              | `{}`                |
| `configsvr.podLabels`                 | Additional pod labels                                                                                   | `{}`                |
| `configsvr.extraVolumes`              | Array to add extra volumes. Requires setting `extraVolumeMounts`                                        | `[]`                |
| `configsvr.extraVolumeMounts`         | Array to add extra mounts (normally used with extraVolumes). Normally used with `extraVolumes`          | `[]`                |
| `configsvr.schedulerName`             | Use an alternate scheduler, e.g. "stork".                                                               | `""`                |
| `configsvr.pdb.enabled`               | Enable pod disruption budget                                                                            | `false`             |
| `configsvr.pdb.minAvailable`          | Minimum number of available config pods allowed (`0` to disable)                                        | `0`                 |
| `configsvr.pdb.maxUnavailable`        | Maximum number of unavailable config pods allowed (`0` to disable)                                      | `1`                 |
| `configsvr.persistence.enabled`       | Use a PVC to persist data                                                                               | `true`              |
| `configsvr.persistence.mountPath`     | Path to mount the volume at                                                                             | `/bitnami/mongodb`  |
| `configsvr.persistence.subPath`       | Subdirectory of the volume to mount at                                                                  | `""`                |
| `configsvr.persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                |
| `configsvr.persistence.accessModes`   | Use volume as ReadOnly or ReadWrite                                                                     | `["ReadWriteOnce"]` |
| `configsvr.persistence.size`          | PersistentVolumeClaim size                                                                              | `8Gi`               |
| `configsvr.persistence.annotations`   | Persistent Volume annotations                                                                           | `{}`                |
| `configsvr.serviceAccount.create`     | Specifies whether a ServiceAccount should be created for Config Server                                  | `false`             |
| `configsvr.serviceAccount.name`       | Name of a Service Account to be used by Config Server                                                   | `""`                |
| `configsvr.external.host`             | Primary node of an external Config Server replicaset                                                    | `""`                |
| `configsvr.external.rootPassword`     | Root password of the external Config Server replicaset                                                  | `""`                |
| `configsvr.external.replicasetName`   | Replicaset name of an external Config Server                                                            | `""`                |
| `configsvr.external.replicasetKey`    | Replicaset key of an external Config Server                                                             | `""`                |


### Mongos parameters

| Name                                                | Description                                                                                      | Value           |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------- |
| `mongos.replicas`                                   | Number of replicas                                                                               | `1`             |
| `mongos.resources`                                  | Configure pod resources                                                                          | `{}`            |
| `mongos.hostAliases`                                | Deployment pod host aliases                                                                      | `[]`            |
| `mongos.mongodbExtraFlags`                          | MongoDB&reg; additional command line flags                                                       | `[]`            |
| `mongos.priorityClassName`                          | Pod priority class name                                                                          | `""`            |
| `mongos.podAffinityPreset`                          | Mongos Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `mongos.podAntiAffinityPreset`                      | Mongos Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `mongos.nodeAffinityPreset.type`                    | Mongos Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `mongos.nodeAffinityPreset.key`                     | Mongos Node label key to match Ignored if `affinity` is set.                                     | `""`            |
| `mongos.nodeAffinityPreset.values`                  | Mongos Node label values to match. Ignored if `affinity` is set.                                 | `[]`            |
| `mongos.affinity`                                   | Mongos Affinity for pod assignment                                                               | `{}`            |
| `mongos.nodeSelector`                               | Mongos Node labels for pod assignment                                                            | `{}`            |
| `mongos.tolerations`                                | Mongos Tolerations for pod assignment                                                            | `[]`            |
| `mongos.podManagementPolicy`                        | Statefulsets pod management policy, allows parallel startup of pods                              | `OrderedReady`  |
| `mongos.updateStrategy.type`                        | updateStrategy for MongoDB&reg; Primary, Secondary and Arbiter statefulsets                      | `RollingUpdate` |
| `mongos.config`                                     | MongoDB&reg; configuration file                                                                  | `""`            |
| `mongos.configCM`                                   | ConfigMap name with MongoDB&reg; configuration file (cannot be used with mongos.config)          | `""`            |
| `mongos.extraEnvVars`                               | An array to add extra env vars                                                                   | `[]`            |
| `mongos.extraEnvVarsCM`                             | Name of a ConfigMap containing extra env vars                                                    | `""`            |
| `mongos.extraEnvVarsSecret`                         | Name of a Secret containing extra env vars                                                       | `""`            |
| `mongos.sidecars`                                   | Add sidecars to the pod                                                                          | `[]`            |
| `mongos.initContainers`                             | Add init containers to the pod                                                                   | `[]`            |
| `mongos.podAnnotations`                             | Additional pod annotations                                                                       | `{}`            |
| `mongos.podLabels`                                  | Additional pod labels                                                                            | `{}`            |
| `mongos.extraVolumes`                               | Array to add extra volumes. Requires setting `extraVolumeMounts`                                 | `[]`            |
| `mongos.extraVolumeMounts`                          | Array to add extra volume mounts. Normally used with `extraVolumes`.                             | `[]`            |
| `mongos.schedulerName`                              | Use an alternate scheduler, e.g. "stork".                                                        | `""`            |
| `mongos.useStatefulSet`                             | Use StatefulSet instead of Deployment                                                            | `false`         |
| `mongos.servicePerReplica.enabled`                  | Create one service per mongos replica (must be used with statefulset)                            | `false`         |
| `mongos.servicePerReplica.annotations`              | Additional service annotations (evaluate as a template)                                          | `{}`            |
| `mongos.servicePerReplica.type`                     | Service type                                                                                     | `ClusterIP`     |
| `mongos.servicePerReplica.externalTrafficPolicy`    | External traffic policy                                                                          | `Cluster`       |
| `mongos.servicePerReplica.port`                     | MongoDB&reg; service port                                                                        | `27017`         |
| `mongos.servicePerReplica.clusterIP`                | Static clusterIP or None for headless services                                                   | `""`            |
| `mongos.servicePerReplica.nodePort`                 | Specify the nodePort value for the LoadBalancer and NodePort service types                       | `""`            |
| `mongos.servicePerReplica.externalIPs`              | External IP list to use with ClusterIP service type                                              | `[]`            |
| `mongos.servicePerReplica.loadBalancerIP`           | Static IP Address to use for LoadBalancer service type                                           | `""`            |
| `mongos.servicePerReplica.loadBalancerSourceRanges` | List of IP ranges allowed access to load balancer (if supported)                                 | `[]`            |
| `mongos.servicePerReplica.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                   | `[]`            |
| `mongos.servicePerReplica.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                             | `None`          |
| `mongos.pdb.enabled`                                | Enable pod disruption budget                                                                     | `false`         |
| `mongos.pdb.minAvailable`                           | Minimum number of available mongo pods allowed (`0` to disable)                                  | `0`             |
| `mongos.pdb.maxUnavailable`                         | Maximum number of unavailable mongo pods allowed (`0` to disable)                                | `1`             |
| `mongos.serviceAccount.create`                      | Whether to create a Service Account for mongos automatically                                     | `false`         |
| `mongos.serviceAccount.name`                        | Name of a Service Account to be used by mongos                                                   | `""`            |


### Shard configuration: Data node parameters

| Name                                          | Description                                                                                          | Value           |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------- | --------------- |
| `shardsvr.dataNode.replicas`                  | Number of nodes in each shard replica set (the first node will be primary)                           | `1`             |
| `shardsvr.dataNode.resources`                 | Configure pod resources                                                                              | `{}`            |
| `shardsvr.dataNode.mongodbExtraFlags`         | MongoDB&reg; additional command line flags                                                           | `[]`            |
| `shardsvr.dataNode.priorityClassName`         | Pod priority class name                                                                              | `""`            |
| `shardsvr.dataNode.podAffinityPreset`         | Data nodes Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `shardsvr.dataNode.podAntiAffinityPreset`     | Data nodes Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `shardsvr.dataNode.nodeAffinityPreset.type`   | Data nodes Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `shardsvr.dataNode.nodeAffinityPreset.key`    | Data nodes Node label key to match Ignored if `affinity` is set.                                     | `""`            |
| `shardsvr.dataNode.nodeAffinityPreset.values` | Data nodes Node label values to match. Ignored if `affinity` is set.                                 | `[]`            |
| `shardsvr.dataNode.affinity`                  | Data nodes Affinity for pod assignment                                                               | `{}`            |
| `shardsvr.dataNode.nodeSelector`              | Data nodes Node labels for pod assignment                                                            | `{}`            |
| `shardsvr.dataNode.tolerations`               | Data nodes Tolerations for pod assignment                                                            | `[]`            |
| `shardsvr.dataNode.podManagementPolicy`       | podManagementPolicy for the statefulset, allows parallel startup of pods                             | `OrderedReady`  |
| `shardsvr.dataNode.updateStrategy.type`       | updateStrategy for MongoDB&reg; Primary, Secondary and Arbiter statefulsets                          | `RollingUpdate` |
| `shardsvr.dataNode.hostAliases`               | Deployment pod host aliases                                                                          | `[]`            |
| `shardsvr.dataNode.config`                    | Entries for the MongoDB&reg; config file                                                             | `""`            |
| `shardsvr.dataNode.configCM`                  | ConfigMap name with MongoDB&reg; configuration (cannot be used with shardsvr.dataNode.config)        | `""`            |
| `shardsvr.dataNode.extraEnvVars`              | An array to add extra env vars                                                                       | `[]`            |
| `shardsvr.dataNode.extraEnvVarsCM`            | Name of a ConfigMap containing extra env vars                                                        | `""`            |
| `shardsvr.dataNode.extraEnvVarsSecret`        | Name of a Secret containing extra env vars                                                           | `""`            |
| `shardsvr.dataNode.sidecars`                  | Attach additional containers (evaluated as a template)                                               | `[]`            |
| `shardsvr.dataNode.initContainers`            | Add init containers to the pod                                                                       | `[]`            |
| `shardsvr.dataNode.podAnnotations`            | Additional pod annotations                                                                           | `{}`            |
| `shardsvr.dataNode.podLabels`                 | Additional pod labels                                                                                | `{}`            |
| `shardsvr.dataNode.extraVolumes`              | Array to add extra volumes. Requires setting `extraVolumeMounts`                                     | `[]`            |
| `shardsvr.dataNode.extraVolumeMounts`         | Array to add extra mounts. Normally used with `extraVolumes`                                         | `[]`            |
| `shardsvr.dataNode.schedulerName`             | Use an alternate scheduler, e.g. "stork".                                                            | `""`            |
| `shardsvr.dataNode.pdb.enabled`               | Enable pod disruption budget                                                                         | `false`         |
| `shardsvr.dataNode.pdb.minAvailable`          | Minimum number of available data pods allowed (`0` to disable)                                       | `0`             |
| `shardsvr.dataNode.pdb.maxUnavailable`        | Maximum number of unavailable data pods allowed (`0` to disable)                                     | `1`             |
| `shardsvr.dataNode.serviceAccount.create`     | Specifies whether a ServiceAccount should be created for shardsvr                                    | `false`         |
| `shardsvr.dataNode.serviceAccount.name`       | Name of a Service Account to be used by shardsvr data pods                                           | `""`            |


### Shard configuration: Persistence parameters

| Name                                | Description                                                                              | Value               |
| ----------------------------------- | ---------------------------------------------------------------------------------------- | ------------------- |
| `shardsvr.persistence.enabled`      | Use a PVC to persist data                                                                | `true`              |
| `shardsvr.persistence.mountPath`    | The path the volume will be mounted at, useful when using different MongoDB&reg; images. | `/bitnami/mongodb`  |
| `shardsvr.persistence.subPath`      | Subdirectory of the volume to mount at                                                   | `""`                |
| `shardsvr.persistence.storageClass` | Storage class of backing PVC                                                             | `""`                |
| `shardsvr.persistence.accessModes`  | Use volume as ReadOnly or ReadWrite                                                      | `["ReadWriteOnce"]` |
| `shardsvr.persistence.size`         | PersistentVolumeClaim size                                                               | `8Gi`               |
| `shardsvr.persistence.annotations`  | Additional volume annotations                                                            | `{}`                |


### Shard configuration: Arbiter parameters

| Name                                         | Description                                                                                         | Value           |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------- | --------------- |
| `shardsvr.arbiter.replicas`                  | Number of arbiters in each shard replica set (the first node will be primary)                       | `0`             |
| `shardsvr.arbiter.hostAliases`               | Deployment pod host aliases                                                                         | `[]`            |
| `shardsvr.arbiter.resources`                 | Configure pod resources                                                                             | `{}`            |
| `shardsvr.arbiter.mongodbExtraFlags`         | MongoDB&reg; additional command line flags                                                          | `[]`            |
| `shardsvr.arbiter.priorityClassName`         | Pod priority class name                                                                             | `""`            |
| `shardsvr.arbiter.podAffinityPreset`         | Arbiter's Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `shardsvr.arbiter.podAntiAffinityPreset`     | Arbiter's Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `shardsvr.arbiter.nodeAffinityPreset.type`   | Arbiter's Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `shardsvr.arbiter.nodeAffinityPreset.key`    | Arbiter's Node label key to match Ignored if `affinity` is set.                                     | `""`            |
| `shardsvr.arbiter.nodeAffinityPreset.values` | Arbiter's Node label values to match. Ignored if `affinity` is set.                                 | `[]`            |
| `shardsvr.arbiter.affinity`                  | Arbiter's Affinity for pod assignment                                                               | `{}`            |
| `shardsvr.arbiter.nodeSelector`              | Arbiter's Node labels for pod assignment                                                            | `{}`            |
| `shardsvr.arbiter.tolerations`               | Arbiter's Tolerations for pod assignment                                                            | `[]`            |
| `shardsvr.arbiter.podManagementPolicy`       | Statefulset's pod management policy, allows parallel startup of pods                                | `OrderedReady`  |
| `shardsvr.arbiter.updateStrategy.type`       | updateStrategy for MongoDB&reg; Primary, Secondary and Arbiter statefulsets                         | `RollingUpdate` |
| `shardsvr.arbiter.config`                    | MongoDB&reg; configuration file                                                                     | `""`            |
| `shardsvr.arbiter.configCM`                  | ConfigMap name with MongoDB&reg; configuration file (cannot be used with shardsvr.arbiter.config)   | `""`            |
| `shardsvr.arbiter.extraEnvVars`              | An array to add extra env vars                                                                      | `[]`            |
| `shardsvr.arbiter.extraEnvVarsCM`            | Name of a ConfigMap containing extra env vars                                                       | `""`            |
| `shardsvr.arbiter.extraEnvVarsSecret`        | Name of a Secret containing extra env vars                                                          | `""`            |
| `shardsvr.arbiter.sidecars`                  | Add sidecars to the pod                                                                             | `[]`            |
| `shardsvr.arbiter.initContainers`            | Add init containers to the pod                                                                      | `[]`            |
| `shardsvr.arbiter.podAnnotations`            | Additional pod annotations                                                                          | `{}`            |
| `shardsvr.arbiter.podLabels`                 | Additional pod labels                                                                               | `{}`            |
| `shardsvr.arbiter.extraVolumes`              | Array to add extra volumes                                                                          | `[]`            |
| `shardsvr.arbiter.extraVolumeMounts`         | Array to add extra mounts (normally used with extraVolumes)                                         | `[]`            |
| `shardsvr.arbiter.schedulerName`             | Use an alternate scheduler, e.g. "stork".                                                           | `""`            |
| `shardsvr.arbiter.serviceAccount.create`     | Specifies whether a ServiceAccount should be created for shardsvr arbiter nodes                     | `false`         |
| `shardsvr.arbiter.serviceAccount.name`       | Name of a Service Account to be used by shardsvr arbiter pods                                       | `""`            |


### Metrics parameters

| Name                                         | Description                                                                        | Value                      |
| -------------------------------------------- | ---------------------------------------------------------------------------------- | -------------------------- |
| `metrics.enabled`                            | Start a side-car prometheus exporter                                               | `false`                    |
| `metrics.image.registry`                     | MongoDB&reg; exporter image registry                                               | `docker.io`                |
| `metrics.image.repository`                   | MongoDB&reg; exporter image name                                                   | `bitnami/mongodb-exporter` |
| `metrics.image.tag`                          | MongoDB&reg; exporter image tag                                                    | `0.11.2-debian-10-r354`    |
| `metrics.image.pullPolicy`                   | MongoDB&reg; exporter image pull policy                                            | `Always`                   |
| `metrics.image.pullSecrets`                  | MongoDB&reg; exporter image pull secrets                                           | `[]`                       |
| `metrics.extraArgs`                          | String with extra arguments to the metrics exporter                                | `""`                       |
| `metrics.resources`                          | Metrics exporter resource requests and limits                                      | `{}`                       |
| `metrics.livenessProbe.enabled`              | Enable livenessProbe                                                               | `false`                    |
| `metrics.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                            | `15`                       |
| `metrics.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                   | `5`                        |
| `metrics.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                  | `5`                        |
| `metrics.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                | `3`                        |
| `metrics.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                | `1`                        |
| `metrics.readinessProbe.enabled`             | Enable readinessProbe                                                              | `false`                    |
| `metrics.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                           | `5`                        |
| `metrics.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                  | `5`                        |
| `metrics.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                 | `1`                        |
| `metrics.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                               | `3`                        |
| `metrics.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                               | `1`                        |
| `metrics.containerPort`                      | Port of the Prometheus metrics container                                           | `9216`                     |
| `metrics.podAnnotations`                     | Metrics exporter pod Annotation                                                    | `{}`                       |
| `metrics.podMonitor.enabled`                 | Create PodMonitor Resource for scraping metrics using PrometheusOperator           | `false`                    |
| `metrics.podMonitor.namespace`               | Namespace where podmonitor resource should be created                              | `monitoring`               |
| `metrics.podMonitor.interval`                | Specify the interval at which metrics should be scraped                            | `30s`                      |
| `metrics.podMonitor.scrapeTimeout`           | Specify the timeout after which the scrape is ended                                | `""`                       |
| `metrics.podMonitor.additionalLabels`        | Additional labels that can be used so PodMonitors will be discovered by Prometheus | `{}`                       |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set shards=4,configsvr.replicas=3,shardsvr.dataNode.replicas=2 \
    bitnami/mongodb-sharded
```

The above command sets the number of shards to 4, the number of replicas for the config servers to 3 and number of replicas for data nodes to 2.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/mongodb-sharded
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change MongoDB&reg; version

To modify the MongoDB&reg; version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/mongodb-sharded/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Sharding

This chart deploys a sharded cluster by default. Some characteristics of this chart are:

- It allows HA by enabling replication on the shards and the config servers. The mongos instances can be scaled horizontally as well.
- The number of secondary and arbiter nodes can be scaled out independently.

### Initialize a fresh instance

The [Bitnami MongoDB&reg;](https://github.com/bitnami/bitnami-docker-mongodb-sharded) image allows you to use your custom scripts to initialize a fresh instance. You can create a custom config map and give it via `initScriptsCM`(check options for more details).

The allowed extensions are `.sh`, and `.js`.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Kibana (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter (available in the `mongos`, `shardsvr.dataNode`, `shardsvr.arbiter`, `configsvr` and `common` sections). Simply define your container according to the Kubernetes container spec.

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

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` (available in the `mongos`, `shardsvr.dataNode`, `shardsvr.arbiter`, `configsvr` and `common` sections) property.

```yaml
extraEnvVars:
  - name: MONGODB_VERSION
    value: 4.0
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Using an external config server

It is possible to not deploy any shards or a config server. For example, it is possible to simply deploy `mongos` instances that point to an external MongoDB&reg; sharded database. If that is the case, set the `configsvr.external.host` and `configsvr.external.replicasetName` for the mongos instances to connect. For authentication, set the `configsvr.external.rootPassword` and `configsvr.external.replicasetKey` values.

## Persistence

The [Bitnami MongoDB&reg;](https://github.com/bitnami/bitnami-docker-mongodb-sharded) image stores the MongoDB&reg; data and configurations at the `/bitnami/mongodb` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Adding extra volumes

The Bitnami Kibana chart supports mounting extra volumes (either PVCs, secrets or configmaps) by using the `extraVolumes` and `extraVolumeMounts` properties (available in the `mongos`, `shardsvr.dataNode`, `shardsvr.arbiter`, `configsvr` and `common` sections). This can be combined with advanced operations like adding extra init containers and sidecars.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

If authentication is enabled, it's necessary to set the `mongodbRootPassword` and `replicaSetKey` when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use. Please note down the password, and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/mongodb-sharded --set mongodbRootPassword=[PASSWORD] (--set replicaSetKey=[REPLICASETKEY])
```

> Note: you need to substitute the placeholders [PASSWORD] and [REPLICASETKEY] with the values obtained in the installation notes.

### To 3.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 3.0.0

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

### To 2.0.0

MongoDB&reg; container images were updated to `4.4.x` and it can affect compatibility with older versions of MongoDB&reg;. Refer to the following guide to upgrade your applications:

- [Upgrade a Sharded Cluster to 4.4](https://docs.mongodb.com/manual/release-notes/4.4-upgrade-sharded-cluster/)
