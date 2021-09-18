# MongoDB&reg; packaged by Bitnami

[MongoDB&reg;](https://www.mongodb.com/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB&reg; eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide a commercial license for any of these products. This listing has an open-source license. MongoDB&reg;  is run and maintained by MongoDB, which is a completely separate project from Bitnami.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mongodb
```

## Introduction

This chart bootstraps a [MongoDB&reg;](https://github.com/bitnami/bitnami-docker-mongodb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with Fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/mongodb
```

The command deploys MongoDB&reg; on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Architecture

This chart allows installing MongoDB&reg; using two different architecture setups: `standalone` or `replicaset`. Use the `architecture` parameter to choose the one to use:

```console
architecture="standalone"
architecture="replicaset"
```

Refer to the [chart documentation for more information on each of these architectures](https://docs.bitnami.com/kubernetes/infrastructure/mongodb/get-started/understand-architecture/).

## Parameters

### Global parameters

| Name                       | Description                                                                                                            | Value |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----- |
| `global.imageRegistry`     | Global Docker image registry                                                                                           | `""`  |
| `global.imagePullSecrets`  | Global Docker registry secret names as an array                                                                        | `[]`  |
| `global.storageClass`      | Global StorageClass for Persistent Volume(s)                                                                           | `""`  |
| `global.namespaceOverride` | Override the namespace for resource deployed by the chart, but can itself be overridden by the local namespaceOverride | `""`  |


### Common parameters

| Name                     | Description                                                                                               | Value           |
| ------------------------ | --------------------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`           | String to partially override mongodb.fullname template (will maintain the release name)                   | `""`            |
| `fullnameOverride`       | String to fully override mongodb.fullname template                                                        | `""`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                                         | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                         | `[]`            |
| `commonLabels`           | Add labels to all the deployed resources (sub-charts are not considered). Evaluated as a template         | `{}`            |
| `commonAnnotations`      | Common annotations to add to all Mongo resources (sub-charts are not considered). Evaluated as a template | `{}`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                   | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                      | `[]`            |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                         | `[]`            |


### MongoDB&reg; parameters

| Name                     | Description                                                                                                                   | Value                 |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`         | MongoDB&reg; image registry                                                                                                   | `docker.io`           |
| `image.repository`       | MongoDB&reg; image registry                                                                                                   | `bitnami/mongodb`     |
| `image.tag`              | MongoDB&reg; image tag (immutable tags are recommended)                                                                       | `4.4.8-debian-10-r31` |
| `image.pullPolicy`       | MongoDB&reg; image pull policy                                                                                                | `IfNotPresent`        |
| `image.pullSecrets`      | Specify docker-registry secret names as an array                                                                              | `[]`                  |
| `image.debug`            | Set to true if you would like to see extra information on logs                                                                | `false`               |
| `schedulerName`          | Name of the scheduler (other than default) to dispatch pods                                                                   | `""`                  |
| `architecture`           | MongoDB&reg; architecture (`standalone` or `replicaset`)                                                                      | `standalone`          |
| `useStatefulSet`         | Set to true to use a StatefulSet instead of a Deployment (only when `architecture=standalone`)                                | `false`               |
| `auth.enabled`           | Enable authentication                                                                                                         | `true`                |
| `auth.rootUser`          | MongoDB&reg; root user                                                                                                        | `root`                |
| `auth.rootPassword`      | MongoDB&reg; root password                                                                                                    | `""`                  |
| `auth.username`          | MongoDB&reg; custom user (mandatory if `auth.database` is set)                                                                | `""`                  |
| `auth.password`          | MongoDB&reg; custom user password                                                                                             | `""`                  |
| `auth.database`          | MongoDB&reg; custom database                                                                                                  | `""`                  |
| `auth.replicaSetKey`     | Key used for authentication in the replicaset (only when `architecture=replicaset`)                                           | `""`                  |
| `auth.existingSecret`    | Existing secret with MongoDB&reg; credentials (keys: `mongodb-password`, `mongodb-root-password`, ` mongodb-replica-set-key`) | `""`                  |
| `tls.enabled`            | Enable MongoDB&reg; TLS support between nodes in the cluster as well as between mongo clients and nodes                       | `false`               |
| `tls.autoGenerated`      | Generate a custom CA and self-signed certificates                                                                             | `true`                |
| `tls.existingSecret`     | Existing secret with TLS certificates (keys: `mongodb-ca-cert`, `mongodb-ca-key`, `client-pem`)                               | `""`                  |
| `tls.caCert`             | Custom CA certificated (base64 encoded)                                                                                       | `""`                  |
| `tls.caKey`              | CA certificate private key (base64 encoded)                                                                                   | `""`                  |
| `tls.image.registry`     | Init container TLS certs setup image registry                                                                                 | `docker.io`           |
| `tls.image.repository`   | Init container TLS certs setup image repository                                                                               | `bitnami/nginx`       |
| `tls.image.tag`          | Init container TLS certs setup image tag (immutable tags are recommended)                                                     | `1.21.2-debian-10-r0` |
| `tls.image.pullPolicy`   | Init container TLS certs setup image pull policy                                                                              | `IfNotPresent`        |
| `hostAliases`            | Add deployment host aliases                                                                                                   | `[]`                  |
| `replicaSetName`         | Name of the replica set (only when `architecture=replicaset`)                                                                 | `rs0`                 |
| `replicaSetHostnames`    | Enable DNS hostnames in the replicaset config (only when `architecture=replicaset`)                                           | `true`                |
| `enableIPv6`             | Switch to enable/disable IPv6 on MongoDB&reg;                                                                                 | `false`               |
| `directoryPerDB`         | Switch to enable/disable DirectoryPerDB on MongoDB&reg;                                                                       | `false`               |
| `systemLogVerbosity`     | MongoDB&reg; system log verbosity level                                                                                       | `0`                   |
| `disableSystemLog`       | Switch to enable/disable MongoDB&reg; system log                                                                              | `false`               |
| `disableJavascript`      | Switch to enable/disable MongoDB&reg; server-side JavaScript execution                                                        | `false`               |
| `enableJournal`          | Switch to enable/disable MongoDB&reg; Journaling                                                                              | `true`                |
| `configuration`          | MongoDB&reg; configuration file to be used for Primary and Secondary nodes                                                    | `""`                  |
| `existingConfigmap`      | Name of existing ConfigMap with MongoDB&reg; configuration for Primary and Secondary nodes                                    | `""`                  |
| `initdbScripts`          | Dictionary of initdb scripts                                                                                                  | `{}`                  |
| `initdbScriptsConfigMap` | Existing ConfigMap with custom initdb scripts                                                                                 | `""`                  |
| `command`                | Override default container command (useful when using custom images)                                                          | `[]`                  |
| `args`                   | Override default container args (useful when using custom images)                                                             | `[]`                  |
| `extraFlags`             | MongoDB&reg; additional command line flags                                                                                    | `[]`                  |
| `extraEnvVars`           | Extra environment variables to add to MongoDB&reg; pods                                                                       | `[]`                  |
| `extraEnvVarsCM`         | Name of existing ConfigMap containing extra env vars                                                                          | `""`                  |
| `extraEnvVarsSecret`     | Name of existing Secret containing extra env vars (in case of sensitive data)                                                 | `""`                  |


### MongoDB&reg; statefulset parameters

| Name                                    | Description                                                                                            | Value           |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------ | --------------- |
| `annotations`                           | Additional labels to be added to the MongoDB&reg; statefulset. Evaluated as a template                 | `{}`            |
| `labels`                                | Annotations to be added to the MongoDB&reg; statefulset. Evaluated as a template                       | `{}`            |
| `replicaCount`                          | Number of MongoDB&reg; nodes (only when `architecture=replicaset`)                                     | `2`             |
| `strategyType`                          | StrategyType for MongoDB&reg; statefulset                                                              | `RollingUpdate` |
| `podManagementPolicy`                   | Pod management policy for MongoDB&reg;                                                                 | `OrderedReady`  |
| `podAffinityPreset`                     | MongoDB&reg; Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`                 | MongoDB&reg; Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`               | MongoDB&reg; Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`                | MongoDB&reg; Node label key to match Ignored if `affinity` is set.                                     | `""`            |
| `nodeAffinityPreset.values`             | MongoDB&reg; Node label values to match. Ignored if `affinity` is set.                                 | `[]`            |
| `affinity`                              | MongoDB&reg; Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                          | MongoDB&reg; Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                           | MongoDB&reg; Tolerations for pod assignment                                                            | `[]`            |
| `podLabels`                             | MongoDB&reg; pod labels                                                                                | `{}`            |
| `podAnnotations`                        | MongoDB&reg; Pod annotations                                                                           | `{}`            |
| `priorityClassName`                     | Name of the existing priority class to be used by MongoDB&reg; pod(s)                                  | `""`            |
| `runtimeClassName`                      | Name of the runtime class to be used by MongoDB&reg; pod(s)                                            | `""`            |
| `podSecurityContext.enabled`            | Enable MongoDB&reg; pod(s)' Security Context                                                           | `true`          |
| `podSecurityContext.fsGroup`            | Group ID for the volumes of the MongoDB&reg; pod(s)                                                    | `1001`          |
| `podSecurityContext.sysctls`            | sysctl settings of the MongoDB&reg; pod(s)'                                                            | `[]`            |
| `containerSecurityContext.enabled`      | Enable MongoDB&reg; container(s)' Security Context                                                     | `true`          |
| `containerSecurityContext.runAsUser`    | User ID for the MongoDB&reg; container                                                                 | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set MongoDB&reg; container's Security Context runAsNonRoot                                             | `true`          |
| `resources.limits`                      | The resources limits for MongoDB&reg; containers                                                       | `{}`            |
| `resources.requests`                    | The requested resources for MongoDB&reg; containers                                                    | `{}`            |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                                   | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                | `30`            |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                       | `10`            |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                      | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                    | `6`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                    | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                                  | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                               | `5`             |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                      | `10`            |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                     | `5`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                   | `6`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                   | `1`             |
| `startupProbe.enabled`                  | Enable startupProbe                                                                                    | `false`         |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                 | `5`             |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                        | `10`            |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                       | `5`             |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                     | `30`            |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                     | `1`             |
| `customLivenessProbe`                   | Override default liveness probe for MongoDB&reg; containers                                            | `{}`            |
| `customReadinessProbe`                  | Override default readiness probe for MongoDB&reg; containers                                           | `{}`            |
| `customStartupProbe`                    | Override default startup probe for MongoDB&reg; containers                                             | `{}`            |
| `initContainers`                        | Add additional init containers for the hidden node pod(s)                                              | `[]`            |
| `sidecars`                              | Add additional sidecar containers for the MongoDB&reg; pod(s)                                          | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the MongoDB&reg; container(s)             | `[]`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes to the MongoDB&reg; statefulset                    | `[]`            |
| `pdb.create`                            | Enable/disable a Pod Disruption Budget creation for MongoDB&reg; pod(s)                                | `false`         |
| `pdb.minAvailable`                      | Minimum number/percentage of MongoDB&reg; pods that must still be available after the eviction         | `1`             |
| `pdb.maxUnavailable`                    | Maximum number/percentage of MongoDB&reg; pods that may be made unavailable after the eviction         | `""`            |


### Traffic exposure parameters

| Name                                                     | Description                                                                                                                                   | Value                   |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `service.nameOverride`                                   | MongoDB&reg; service name                                                                                                                     | `""`                    |
| `service.type`                                           | Kubernetes Service type                                                                                                                       | `ClusterIP`             |
| `service.port`                                           | MongoDB&reg; service port                                                                                                                     | `27017`                 |
| `service.portName`                                       | MongoDB&reg; service port name                                                                                                                | `mongodb`               |
| `service.nodePort`                                       | Port to bind to for NodePort and LoadBalancer service types                                                                                   | `""`                    |
| `service.clusterIP`                                      | MongoDB&reg; service cluster IP                                                                                                               | `""`                    |
| `service.externalIPs`                                    | Specify the externalIP value ClusterIP service type.                                                                                          | `[]`                    |
| `service.loadBalancerIP`                                 | loadBalancerIP for MongoDB&reg; Service                                                                                                       | `""`                    |
| `service.loadBalancerSourceRanges`                       | Address(es) that are allowed when service is LoadBalancer                                                                                     | `[]`                    |
| `service.annotations`                                    | Provide any additional annotations that may be required                                                                                       | `{}`                    |
| `externalAccess.enabled`                                 | Enable Kubernetes external cluster access to MongoDB&reg; nodes (only for replicaset architecture)                                            | `false`                 |
| `externalAccess.autoDiscovery.enabled`                   | Enable using an init container to auto-detect external IPs by querying the K8s API                                                            | `false`                 |
| `externalAccess.autoDiscovery.image.registry`            | Init container auto-discovery image registry                                                                                                  | `docker.io`             |
| `externalAccess.autoDiscovery.image.repository`          | Init container auto-discovery image repository                                                                                                | `bitnami/kubectl`       |
| `externalAccess.autoDiscovery.image.tag`                 | Init container auto-discovery image tag (immutable tags are recommended)                                                                      | `1.19.14-debian-10-r20` |
| `externalAccess.autoDiscovery.image.pullPolicy`          | Init container auto-discovery image pull policy                                                                                               | `IfNotPresent`          |
| `externalAccess.autoDiscovery.image.pullSecrets`         | Init container auto-discovery image pull secrets                                                                                              | `[]`                    |
| `externalAccess.autoDiscovery.resources.limits`          | Init container auto-discovery resource limits                                                                                                 | `{}`                    |
| `externalAccess.autoDiscovery.resources.requests`        | Init container auto-discovery resource requests                                                                                               | `{}`                    |
| `externalAccess.service.type`                            | Kubernetes Service type for external access. Allowed values: NodePort, LoadBalancer or ClusterIP                                              | `LoadBalancer`          |
| `externalAccess.service.port`                            | MongoDB&reg; port used for external access when service type is LoadBalancer                                                                  | `27017`                 |
| `externalAccess.service.loadBalancerIPs`                 | Array of load balancer IPs for MongoDB&reg; nodes                                                                                             | `[]`                    |
| `externalAccess.service.loadBalancerSourceRanges`        | Address(es) that are allowed when service is LoadBalancer                                                                                     | `[]`                    |
| `externalAccess.service.nodePorts`                       | Array of node ports used to configure MongoDB&reg; advertised hostname when service type is NodePort                                          | `[]`                    |
| `externalAccess.service.domain`                          | Domain or external IP used to configure MongoDB&reg; advertised hostname when service type is NodePort                                        | `""`                    |
| `externalAccess.service.annotations`                     | Service annotations for external access                                                                                                       | `{}`                    |
| `externalAccess.hidden.enabled`                          | Enable Kubernetes external cluster access to MongoDB&reg; hidden nodes                                                                        | `false`                 |
| `externalAccess.hidden.service.type`                     | Kubernetes Service type for external access. Allowed values: NodePort or LoadBalancer                                                         | `LoadBalancer`          |
| `externalAccess.hidden.service.port`                     | MongoDB&reg; port used for external access when service type is LoadBalancer                                                                  | `27017`                 |
| `externalAccess.hidden.service.loadBalancerIPs`          | Array of load balancer IPs for MongoDB&reg; nodes                                                                                             | `[]`                    |
| `externalAccess.hidden.service.loadBalancerSourceRanges` | Address(es) that are allowed when service is LoadBalancer                                                                                     | `[]`                    |
| `externalAccess.hidden.service.nodePorts`                | Array of node ports used to configure MongoDB&reg; advertised hostname when service type is NodePort. Length must be the same as replicaCount | `[]`                    |
| `externalAccess.hidden.service.domain`                   | Domain or external IP used to configure MongoDB&reg; advertised hostname when service type is NodePort                                        | `""`                    |
| `externalAccess.hidden.service.annotations`              | Service annotations for external access                                                                                                       | `{}`                    |


### Persistence parameters

| Name                                          | Description                                                                        | Value              |
| --------------------------------------------- | ---------------------------------------------------------------------------------- | ------------------ |
| `persistence.enabled`                         | Enable MongoDB&reg; data persistence using PVC                                     | `true`             |
| `persistence.existingClaim`                   | Provide an existing `PersistentVolumeClaim` (only when `architecture=standalone`)  | `""`               |
| `persistence.storageClass`                    | PVC Storage Class for MongoDB&reg; data volume                                     | `""`               |
| `persistence.accessModes`                     | PV Access Mode                                                                     | `[]`               |
| `persistence.size`                            | PVC Storage Request for MongoDB&reg; data volume                                   | `8Gi`              |
| `persistence.annotations`                     | PVC annotations                                                                    | `{}`               |
| `persistence.mountPath`                       | Path to mount the volume at                                                        | `/bitnami/mongodb` |
| `persistence.subPath`                         | Subdirectory of the volume to mount at                                             | `""`               |
| `persistence.volumeClaimTemplates.selector`   | A label query over volumes to consider for binding (e.g. when using local volumes) | `{}`               |
| `persistence.volumeClaimTemplates.requests`   | Custom PVC requests attributes                                                     | `{}`               |
| `persistence.volumeClaimTemplates.dataSource` | Add dataSource to the VolumeClaimTemplate                                          | `{}`               |


### RBAC parameters

| Name                                         | Description                                                                          | Value   |
| -------------------------------------------- | ------------------------------------------------------------------------------------ | ------- |
| `serviceAccount.create`                      | Enable creation of ServiceAccount for MongoDB&reg; pods                              | `true`  |
| `serviceAccount.name`                        | Name of the created serviceAccount                                                   | `""`    |
| `serviceAccount.annotations`                 | Additional Service Account annotations                                               | `{}`    |
| `rbac.create`                                | Whether to create & use RBAC resources or not                                        | `false` |
| `rbac.role.rules`                            | Custom rules to create following the role specification                              | `[]`    |
| `podSecurityPolicy.create`                   | Whether to create & use PSP resource or not (Note: `rbac.create` needs to be `true`) | `false` |
| `podSecurityPolicy.allowPrivilegeEscalation` | Enable privilege escalation                                                          | `false` |
| `podSecurityPolicy.privileged`               | Allow privileged                                                                     | `false` |
| `podSecurityPolicy.spec`                     | Specify the full spec to use for Pod Security Policy                                 | `{}`    |


### Volume Permissions parameters

| Name                                          | Description                                                                                                          | Value                   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                     | `docker.io`             |
| `volumePermissions.image.repository`          | Init container volume-permissions image repository                                                                   | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag (immutable tags are recommended)                                         | `10-debian-10-r179`     |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                  | `Always`                |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                     | `[]`                    |
| `volumePermissions.resources.limits`          | Init container volume-permissions resource limits                                                                    | `{}`                    |
| `volumePermissions.resources.requests`        | Init container volume-permissions resource requests                                                                  | `{}`                    |
| `volumePermissions.securityContext.runAsUser` | User ID for the volumePermissions container                                                                          | `0`                     |


### Arbiter parameters

| Name                                         | Description                                                                                       | Value   |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------- |
| `arbiter.enabled`                            | Enable deploying the arbiter                                                                      | `true`  |
| `arbiter.configuration`                      | Arbiter configuration file to be used                                                             | `""`    |
| `arbiter.hostAliases`                        | Add deployment host aliases                                                                       | `[]`    |
| `arbiter.existingConfigmap`                  | Name of existing ConfigMap with Arbiter configuration                                             | `""`    |
| `arbiter.command`                            | Override default container command (useful when using custom images)                              | `[]`    |
| `arbiter.args`                               | Override default container args (useful when using custom images)                                 | `[]`    |
| `arbiter.extraFlags`                         | Arbiter additional command line flags                                                             | `[]`    |
| `arbiter.extraEnvVars`                       | Extra environment variables to add to Arbiter pods                                                | `[]`    |
| `arbiter.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars                                              | `""`    |
| `arbiter.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars (in case of sensitive data)                     | `""`    |
| `arbiter.annotations`                        | Additional labels to be added to the Arbiter statefulset                                          | `{}`    |
| `arbiter.labels`                             | Annotations to be added to the Arbiter statefulset                                                | `{}`    |
| `arbiter.podAffinityPreset`                  | Arbiter Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`    |
| `arbiter.podAntiAffinityPreset`              | Arbiter Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`  |
| `arbiter.nodeAffinityPreset.type`            | Arbiter Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`    |
| `arbiter.nodeAffinityPreset.key`             | Arbiter Node label key to match Ignored if `affinity` is set.                                     | `""`    |
| `arbiter.nodeAffinityPreset.values`          | Arbiter Node label values to match. Ignored if `affinity` is set.                                 | `[]`    |
| `arbiter.affinity`                           | Arbiter Affinity for pod assignment                                                               | `{}`    |
| `arbiter.nodeSelector`                       | Arbiter Node labels for pod assignment                                                            | `{}`    |
| `arbiter.tolerations`                        | Arbiter Tolerations for pod assignment                                                            | `[]`    |
| `arbiter.podLabels`                          | Arbiter pod labels                                                                                | `{}`    |
| `arbiter.podAnnotations`                     | Arbiter Pod annotations                                                                           | `{}`    |
| `arbiter.priorityClassName`                  | Name of the existing priority class to be used by Arbiter pod(s)                                  | `""`    |
| `arbiter.runtimeClassName`                   | Name of the runtime class to be used by Arbiter pod(s)                                            | `""`    |
| `arbiter.podSecurityContext.enabled`         | Enable Arbiter pod(s)' Security Context                                                           | `true`  |
| `arbiter.podSecurityContext.fsGroup`         | Group ID for the volumes of the Arbiter pod(s)                                                    | `1001`  |
| `arbiter.podSecurityContext.sysctls`         | sysctl settings of the Arbiter pod(s)'                                                            | `[]`    |
| `arbiter.containerSecurityContext.enabled`   | Enable Arbiter container(s)' Security Context                                                     | `true`  |
| `arbiter.containerSecurityContext.runAsUser` | User ID for the Arbiter container                                                                 | `1001`  |
| `arbiter.resources.limits`                   | The resources limits for Arbiter containers                                                       | `{}`    |
| `arbiter.resources.requests`                 | The requested resources for Arbiter containers                                                    | `{}`    |
| `arbiter.livenessProbe.enabled`              | Enable livenessProbe                                                                              | `true`  |
| `arbiter.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                           | `30`    |
| `arbiter.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                  | `10`    |
| `arbiter.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                 | `5`     |
| `arbiter.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                               | `6`     |
| `arbiter.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                               | `1`     |
| `arbiter.readinessProbe.enabled`             | Enable readinessProbe                                                                             | `true`  |
| `arbiter.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                          | `5`     |
| `arbiter.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                 | `10`    |
| `arbiter.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                | `5`     |
| `arbiter.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                              | `6`     |
| `arbiter.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                              | `1`     |
| `arbiter.customLivenessProbe`                | Override default liveness probe for Arbiter containers                                            | `{}`    |
| `arbiter.customReadinessProbe`               | Override default readiness probe for Arbiter containers                                           | `{}`    |
| `arbiter.initContainers`                     | Add additional init containers for the Arbiter pod(s)                                             | `[]`    |
| `arbiter.sidecars`                           | Add additional sidecar containers for the Arbiter pod(s)                                          | `[]`    |
| `arbiter.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the Arbiter container(s)             | `[]`    |
| `arbiter.extraVolumes`                       | Optionally specify extra list of additional volumes to the Arbiter statefulset                    | `[]`    |
| `arbiter.pdb.create`                         | Enable/disable a Pod Disruption Budget creation for Arbiter pod(s)                                | `false` |
| `arbiter.pdb.minAvailable`                   | Minimum number/percentage of Arbiter pods that should remain scheduled                            | `1`     |
| `arbiter.pdb.maxUnavailable`                 | Maximum number/percentage of Arbiter pods that may be made unavailable                            | `""`    |
| `arbiter.service.nameOverride`               | The arbiter service name                                                                          | `""`    |


### Hidden Node parameters

| Name                                                 | Description                                                                                          | Value              |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ------------------ |
| `hidden.enabled`                                     | Enable deploying the hidden nodes                                                                    | `false`            |
| `hidden.configuration`                               | Hidden node configuration file to be used                                                            | `""`               |
| `hidden.existingConfigmap`                           | Name of existing ConfigMap with Hidden node configuration                                            | `""`               |
| `hidden.command`                                     | Override default container command (useful when using custom images)                                 | `[]`               |
| `hidden.args`                                        | Override default container args (useful when using custom images)                                    | `[]`               |
| `hidden.extraFlags`                                  | Hidden node additional command line flags                                                            | `[]`               |
| `hidden.extraEnvVars`                                | Extra environment variables to add to Hidden node pods                                               | `[]`               |
| `hidden.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars                                                 | `""`               |
| `hidden.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars (in case of sensitive data)                        | `""`               |
| `hidden.annotations`                                 | Additional labels to be added to thehidden node statefulset                                          | `{}`               |
| `hidden.labels`                                      | Annotations to be added to the hidden node statefulset                                               | `{}`               |
| `hidden.replicaCount`                                | Number of hidden nodes (only when `architecture=replicaset`)                                         | `1`                |
| `hidden.strategyType`                                | StrategyType for hidden node statefulset                                                             | `RollingUpdate`    |
| `hidden.podManagementPolicy`                         | Pod management policy for hidden node                                                                | `OrderedReady`     |
| `hidden.podAffinityPreset`                           | Hidden node Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`      | `""`               |
| `hidden.podAntiAffinityPreset`                       | Hidden node Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `soft`             |
| `hidden.nodeAffinityPreset.type`                     | Hidden Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`     | `""`               |
| `hidden.nodeAffinityPreset.key`                      | Hidden Node label key to match Ignored if `affinity` is set.                                         | `""`               |
| `hidden.nodeAffinityPreset.values`                   | Hidden Node label values to match. Ignored if `affinity` is set.                                     | `[]`               |
| `hidden.affinity`                                    | Hidden node Affinity for pod assignment                                                              | `{}`               |
| `hidden.nodeSelector`                                | Hidden node Node labels for pod assignment                                                           | `{}`               |
| `hidden.tolerations`                                 | Hidden node Tolerations for pod assignment                                                           | `[]`               |
| `hidden.podLabels`                                   | Hidden node pod labels                                                                               | `{}`               |
| `hidden.podAnnotations`                              | Hidden node Pod annotations                                                                          | `{}`               |
| `hidden.priorityClassName`                           | Name of the existing priority class to be used by hidden node pod(s)                                 | `""`               |
| `hidden.runtimeClassName`                            | Name of the runtime class to be used by hidden node pod(s)                                           | `""`               |
| `hidden.resources.limits`                            | The resources limits for hidden node containers                                                      | `{}`               |
| `hidden.resources.requests`                          | The requested resources for hidden node containers                                                   | `{}`               |
| `hidden.livenessProbe.enabled`                       | Enable livenessProbe                                                                                 | `true`             |
| `hidden.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                              | `30`               |
| `hidden.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                     | `10`               |
| `hidden.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                    | `5`                |
| `hidden.livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                  | `6`                |
| `hidden.livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                  | `1`                |
| `hidden.readinessProbe.enabled`                      | Enable readinessProbe                                                                                | `true`             |
| `hidden.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                             | `5`                |
| `hidden.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                    | `10`               |
| `hidden.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                   | `5`                |
| `hidden.readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                 | `6`                |
| `hidden.readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                 | `1`                |
| `hidden.customLivenessProbe`                         | Override default liveness probe for hidden node containers                                           | `{}`               |
| `hidden.customReadinessProbe`                        | Override default readiness probe for hidden node containers                                          | `{}`               |
| `hidden.initContainers`                              | Add init containers to the MongoDB&reg; Hidden pods.                                                 | `[]`               |
| `hidden.sidecars`                                    | Add additional sidecar containers for the hidden node pod(s)                                         | `[]`               |
| `hidden.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for the hidden node container(s)            | `[]`               |
| `hidden.extraVolumes`                                | Optionally specify extra list of additional volumes to the hidden node statefulset                   | `[]`               |
| `hidden.pdb.create`                                  | Enable/disable a Pod Disruption Budget creation for hidden node pod(s)                               | `false`            |
| `hidden.pdb.minAvailable`                            | Minimum number/percentage of hidden node pods that should remain scheduled                           | `1`                |
| `hidden.pdb.maxUnavailable`                          | Maximum number/percentage of hidden node pods that may be made unavailable                           | `""`               |
| `hidden.persistence.enabled`                         | Enable hidden node data persistence using PVC                                                        | `true`             |
| `hidden.persistence.storageClass`                    | PVC Storage Class for hidden node data volume                                                        | `""`               |
| `hidden.persistence.accessModes`                     | PV Access Mode                                                                                       | `[]`               |
| `hidden.persistence.size`                            | PVC Storage Request for hidden node data volume                                                      | `8Gi`              |
| `hidden.persistence.annotations`                     | PVC annotations                                                                                      | `{}`               |
| `hidden.persistence.mountPath`                       | The path the volume will be mounted at, useful when using different MongoDB&reg; images.             | `/bitnami/mongodb` |
| `hidden.persistence.subPath`                         | The subdirectory of the volume to mount to, useful in dev environments                               | `""`               |
| `hidden.persistence.volumeClaimTemplates.selector`   | A label query over volumes to consider for binding (e.g. when using local volumes)                   | `{}`               |
| `hidden.persistence.volumeClaimTemplates.dataSource` | Set volumeClaimTemplate dataSource                                                                   | `{}`               |


### Metrics parameters

| Name                                         | Description                                                                                                           | Value                      |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `metrics.enabled`                            | Enable using a sidecar Prometheus exporter                                                                            | `false`                    |
| `metrics.image.registry`                     | MongoDB&reg; Prometheus exporter image registry                                                                       | `docker.io`                |
| `metrics.image.repository`                   | MongoDB&reg; Prometheus exporter image repository                                                                     | `bitnami/mongodb-exporter` |
| `metrics.image.tag`                          | MongoDB&reg; Prometheus exporter image tag (immutable tags are recommended)                                           | `0.11.2-debian-10-r266`    |
| `metrics.image.pullPolicy`                   | MongoDB&reg; Prometheus exporter image pull policy                                                                    | `IfNotPresent`             |
| `metrics.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                      | `[]`                       |
| `metrics.username`                           | String with username for the metrics exporter                                                                         | `""`                       |
| `metrics.password`                           | String with password for the metrics exporter                                                                         | `""`                       |
| `metrics.extraFlags`                         | String with extra flags to the metrics exporter                                                                       | `""`                       |
| `metrics.extraUri`                           | Additional URI options of the metrics service                                                                         | `""`                       |
| `metrics.resources.limits`                   | The resources limits for Prometheus exporter containers                                                               | `{}`                       |
| `metrics.resources.requests`                 | The requested resources for Prometheus exporter containers                                                            | `{}`                       |
| `metrics.containerPort`                      | Port of the Prometheus metrics container                                                                              | `9216`                     |
| `metrics.service.annotations`                | Annotations for Prometheus Exporter pods. Evaluated as a template.                                                    | `{}`                       |
| `metrics.service.type`                       | Type of the Prometheus metrics service                                                                                | `ClusterIP`                |
| `metrics.service.port`                       | Port of the Prometheus metrics service                                                                                | `9216`                     |
| `metrics.livenessProbe.enabled`              | Enable livenessProbe                                                                                                  | `true`                     |
| `metrics.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                               | `15`                       |
| `metrics.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                      | `5`                        |
| `metrics.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                     | `5`                        |
| `metrics.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                   | `3`                        |
| `metrics.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                   | `1`                        |
| `metrics.readinessProbe.enabled`             | Enable readinessProbe                                                                                                 | `true`                     |
| `metrics.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                              | `5`                        |
| `metrics.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                     | `5`                        |
| `metrics.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                    | `1`                        |
| `metrics.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                  | `3`                        |
| `metrics.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                  | `1`                        |
| `metrics.serviceMonitor.enabled`             | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator                                         | `false`                    |
| `metrics.serviceMonitor.namespace`           | Namespace which Prometheus is running in                                                                              | `""`                       |
| `metrics.serviceMonitor.interval`            | Interval at which metrics should be scraped                                                                           | `30s`                      |
| `metrics.serviceMonitor.scrapeTimeout`       | Specify the timeout after which the scrape is ended                                                                   | `""`                       |
| `metrics.serviceMonitor.relabellings`        | RelabelConfigs to apply to samples before scraping.                                                                   | `[]`                       |
| `metrics.serviceMonitor.metricRelabelings`   | MetricsRelabelConfigs to apply to samples before ingestion.                                                           | `[]`                       |
| `metrics.serviceMonitor.additionalLabels`    | Used to pass Labels that are used by the Prometheus installed in your cluster to select Service Monitors to work with | `{}`                       |
| `metrics.prometheusRule.enabled`             | Set this to true to create prometheusRules for Prometheus operator                                                    | `false`                    |
| `metrics.prometheusRule.additionalLabels`    | Additional labels that can be used so prometheusRules will be discovered by Prometheus                                | `{}`                       |
| `metrics.prometheusRule.namespace`           | Namespace where prometheusRules resource should be created                                                            | `""`                       |
| `metrics.prometheusRule.rules`               | Rules to be created, check values for an example                                                                      | `{}`                       |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
    --set auth.rootPassword=secretpassword,auth.username=my-user,auth.password=my-password,auth.database=my-database \
    bitnami/mongodb
```

The above command sets the MongoDB&reg; `root` account password to `secretpassword`. Additionally, it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/mongodb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Customize a new MongoDB instance

The [Bitnami MongoDB&reg; image](https://github.com/bitnami/bitnami-docker-mongodb) supports the use of custom scripts to initialize a fresh instance. In order to execute the scripts, two options are available:

* Specify them using the `initdbScripts` parameter as dict.
* Define an external Kubernetes ConfigMap with all the initialization scripts by setting the `initdbScriptsConfigMap` parameter. Note that this will override the previous option.

The allowed script extensions are `.sh` and `.js`.

### Replicaset: Access MongoDB&reg; nodes from outside the cluster

In order to access MongoDB&reg; nodes from outside the cluster when using a replicaset architecture, a specific service per MongoDB&reg; pod will be created. There are two ways of configuring external access:

- Using LoadBalancer services
- Using NodePort services.

Refer to the [chart documentation for more details and configuration examples](https://docs.bitnami.com/kubernetes/infrastructure/mongodb/configuration/configure-external-access-replicaset/).

### Add extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` properties.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/mongodb/configuration/configure-sidecar-init-containers/).

## Persistence

The [Bitnami MongoDB&reg;](https://github.com/bitnami/bitnami-docker-mongodb) image stores the MongoDB&reg; data and configurations at the `/bitnami/mongodb` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

## Use custom Prometheus rules

Custom Prometheus rules can be defined for the Prometheus Operator by using the `prometheusRule` parameter.

Refer to the [chart documentation for an example of a custom rule](https://docs.bitnami.com/kubernetes/infrastructure/mongodb/administration/use-prometheus-rules/).

## Enable SSL/TLS

This chart supports enabling SSL/TLS between nodes in the cluster, as well as between MongoDB&reg; clients and nodes, by setting the `MONGODB_EXTRA_FLAGS` and `MONGODB_CLIENT_EXTRA_FLAGS` container environment variables, together with the correct `MONGODB_ADVERTISED_HOSTNAME`. To enable full TLS encryption, set the `tls.enabled` parameter to `true`.

Refer to the [chart documentation for more information on enabling TLS](https://docs.bitnami.com/kubernetes/infrastructure/mongodb/administration/enable-tls/).

### Set Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

If authentication is enabled, it's necessary to set the `auth.rootPassword` (also `auth.replicaSetKey` when using a replicaset architecture) when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Credentials' section. Please note down the password, and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/mongodb --set auth.rootPassword=[PASSWORD] (--set auth.replicaSetKey=[REPLICASETKEY])
```

> Note: you need to substitute the placeholders [PASSWORD] and [REPLICASETKEY] with the values obtained in the installation notes.

### To 10.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/mongodb/administration/upgrade-helm3/).

### To 9.0.0

MongoDB&reg; container images were updated to `4.4.x` and it can affect compatibility with older versions of MongoDB&reg;. Refer to the following guides to upgrade your applications:

- [Standalone](https://docs.mongodb.com/manual/release-notes/4.4-upgrade-standalone/)
- [Replica Set](https://docs.mongodb.com/manual/release-notes/4.4-upgrade-replica-set/)

### To 8.0.0

- Architecture used to configure MongoDB&reg; as a replicaset was completely refactored. Now, both primary and secondary nodes are part of the same statefulset.
- Chart labels were adapted to follow the Helm charts best practices.
- This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.
- Several parameters were renamed or disappeared in favor of new ones on this major version. These are the most important ones:
  - `replicas` is renamed to `replicaCount`.
  - Authentication parameters are reorganized under the `auth.*` parameter:
    - `usePassword` is renamed to `auth.enabled`.
    - `mongodbRootPassword`, `mongodbUsername`, `mongodbPassword`, `mongodbDatabase`, and `replicaSet.key` are now `auth.rootPassword`, `auth.username`, `auth.password`, `auth.database`, and `auth.replicaSetKey` respectively.
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
  - Parameters prefixed with `mongodb` are renamed removing the prefix. E.g. `mongodbEnableIPv6` is renamed to `enableIPv6`.
  - Parameters affecting Arbiter nodes are reorganized under the `arbiter.*` parameter.

Consequences:

- Backwards compatibility is not guaranteed. To upgrade to `8.0.0`, install a new release of the MongoDB&reg; chart, and migrate your data by creating a backup of the database, and restoring it on the new release.

### To 7.0.0

From this version, the way of setting the ingress rules has changed. Instead of using `ingress.paths` and `ingress.hosts` as separate objects, you should now define the rules as objects inside the `ingress.hosts` value, for example:

```yaml
ingress:
  hosts:
  - name: mongodb.local
    path: /
```

### To 6.0.0

From this version, `mongodbEnableIPv6` is set to `false` by default in order to work properly in most k8s clusters, if you want to use IPv6 support, you need to set this variable to `true` by adding `--set mongodbEnableIPv6=true` to your `helm` command.
You can find more information in the [`bitnami/mongodb` image README](https://github.com/bitnami/bitnami-docker-mongodb/blob/master/README.md).

### To 5.0.0

When enabling replicaset configuration, backwards compatibility is not guaranteed unless you modify the labels used on the chart's statefulsets.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is `my-release`:

```console
$ kubectl delete statefulset my-release-mongodb-arbiter my-release-mongodb-primary my-release-mongodb-secondary --cascade=false
```

### Add extra deployment options

To add extra deployments (useful for advanced features like sidecars), use the `extraDeploy` property.

In the example below, you can find how to use a example here for a [MongoDB replica set pod labeler sidecar](https://github.com/combor/k8s-mongo-labeler-sidecar) to identify the primary pod and dynamically label it as the primary node:

```yaml
extraDeploy:
  - apiVersion: v1
    kind: Service
    metadata:
      name: mongodb-primary
      namespace: default
      labels:
        app.kubernetes.io/component: mongodb
        app.kubernetes.io/instance: mongodb
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/name: mongodb
    spec:
      type: NodePort
      externalTrafficPolicy: Cluster
      ports:
        - name: mongodb-primary
          port: 30001
          nodePort: 30001
          protocol: TCP
          targetPort: mongodb
      selector:
        app.kubernetes.io/component: mongodb
        app.kubernetes.io/instance: mongodb
        app.kubernetes.io/name: mongodb
        primary: "true"
```
