<!--- app-name: MariaDB -->

# MariaDB

[MariaDB](https://mariadb.org) is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, Facebook and Google.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mariadb
```

## Introduction

This chart bootstraps a [MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) replication cluster deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/mariadb
```

The command deploys MariaDB on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `global.imageRegistry`    | Global Docker Image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `nameOverride`           | String to partially override mariadb.fullname                                           | `""`            |
| `fullnameOverride`       | String to fully override mariadb.fullname                                               | `""`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `commonAnnotations`      | Common annotations to add to all MariaDB resources (sub-charts are not considered)      | `{}`            |
| `commonLabels`           | Common labels to add to all MariaDB resources (sub-charts are not considered)           | `{}`            |
| `schedulerName`          | Name of the scheduler (other than default) to dispatch pods                             | `""`            |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template)             | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### MariaDB common parameters

| Name                       | Description                                                                                                                                                                                                                                                                   | Value                   |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `image.registry`           | MariaDB image registry                                                                                                                                                                                                                                                        | `docker.io`             |
| `image.repository`         | MariaDB image repository                                                                                                                                                                                                                                                      | `bitnami/mariadb`       |
| `image.tag`                | MariaDB image tag (immutable tags are recommended)                                                                                                                                                                                                                            | `10.5.13-debian-10-r58` |
| `image.pullPolicy`         | MariaDB image pull policy                                                                                                                                                                                                                                                     | `IfNotPresent`          |
| `image.pullSecrets`        | Specify docker-registry secret names as an array                                                                                                                                                                                                                              | `[]`                    |
| `image.debug`              | Specify if debug logs should be enabled                                                                                                                                                                                                                                       | `false`                 |
| `architecture`             | MariaDB architecture (`standalone` or `replication`)                                                                                                                                                                                                                          | `standalone`            |
| `auth.rootPassword`        | Password for the `root` user. Ignored if existing secret is provided.                                                                                                                                                                                                         | `""`                    |
| `auth.database`            | Name for a custom database to create                                                                                                                                                                                                                                          | `my_database`           |
| `auth.username`            | Name for a custom user to create                                                                                                                                                                                                                                              | `""`                    |
| `auth.password`            | Password for the new user. Ignored if existing secret is provided                                                                                                                                                                                                             | `""`                    |
| `auth.replicationUser`     | MariaDB replication user                                                                                                                                                                                                                                                      | `replicator`            |
| `auth.replicationPassword` | MariaDB replication user password. Ignored if existing secret is provided                                                                                                                                                                                                     | `""`                    |
| `auth.existingSecret`      | Use existing secret for password details (`auth.rootPassword`, `auth.password`, `auth.replicationPassword` will be ignored and picked up from this secret). The secret has to contain the keys `mariadb-root-password`, `mariadb-replication-password` and `mariadb-password` | `""`                    |
| `auth.forcePassword`       | Force users to specify required passwords                                                                                                                                                                                                                                     | `false`                 |
| `auth.usePasswordFiles`    | Mount credentials as a files instead of using an environment variable                                                                                                                                                                                                         | `false`                 |
| `auth.customPasswordFiles` | Use custom password files when `auth.usePasswordFiles` is set to `true`. Define path for keys `root` and `user`, also define `replicator` if `architecture` is set to `replication`                                                                                           | `{}`                    |
| `initdbScripts`            | Dictionary of initdb scripts                                                                                                                                                                                                                                                  | `{}`                    |
| `initdbScriptsConfigMap`   | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                                                                                                           | `""`                    |


### MariaDB Primary parameters

| Name                                            | Description                                                                                                       | Value               |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------- |
| `primary.command`                               | Override default container command on MariaDB Primary container(s) (useful when using custom images)              | `[]`                |
| `primary.args`                                  | Override default container args on MariaDB Primary container(s) (useful when using custom images)                 | `[]`                |
| `primary.lifecycleHooks`                        | for the MariaDB Primary container(s) to automate configuration before or after startup                            | `{}`                |
| `primary.hostAliases`                           | Add deployment host aliases                                                                                       | `[]`                |
| `primary.configuration`                         | MariaDB Primary configuration to be injected as ConfigMap                                                         | `""`                |
| `primary.existingConfigmap`                     | Name of existing ConfigMap with MariaDB Primary configuration.                                                    | `""`                |
| `primary.updateStrategy.type`                   | MariaDB primary statefulset strategy type                                                                         | `RollingUpdate`     |
| `primary.rollingUpdatePartition`                | Partition update strategy for Mariadb Primary statefulset                                                         | `""`                |
| `primary.podAnnotations`                        | Additional pod annotations for MariaDB primary pods                                                               | `{}`                |
| `primary.podLabels`                             | Extra labels for MariaDB primary pods                                                                             | `{}`                |
| `primary.podAffinityPreset`                     | MariaDB primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`       | `""`                |
| `primary.podAntiAffinityPreset`                 | MariaDB primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`  | `soft`              |
| `primary.nodeAffinityPreset.type`               | MariaDB primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard` | `""`                |
| `primary.nodeAffinityPreset.key`                | MariaDB primary node label key to match Ignored if `primary.affinity` is set.                                     | `""`                |
| `primary.nodeAffinityPreset.values`             | MariaDB primary node label values to match. Ignored if `primary.affinity` is set.                                 | `[]`                |
| `primary.affinity`                              | Affinity for MariaDB primary pods assignment                                                                      | `{}`                |
| `primary.nodeSelector`                          | Node labels for MariaDB primary pods assignment                                                                   | `{}`                |
| `primary.tolerations`                           | Tolerations for MariaDB primary pods assignment                                                                   | `[]`                |
| `primary.schedulerName`                         | Name of the k8s scheduler (other than default)                                                                    | `""`                |
| `primary.podManagementPolicy`                   | podManagementPolicy to manage scaling operation of MariaDB primary pods                                           | `""`                |
| `primary.topologySpreadConstraints`             | Topology Spread Constraints for MariaDB primary pods assignment                                                   | `{}`                |
| `primary.priorityClassName`                     | Priority class for MariaDB primary pods assignment                                                                | `""`                |
| `primary.podSecurityContext.enabled`            | Enable security context for MariaDB primary pods                                                                  | `true`              |
| `primary.podSecurityContext.fsGroup`            | Group ID for the mounted volumes' filesystem                                                                      | `1001`              |
| `primary.containerSecurityContext.enabled`      | MariaDB primary container securityContext                                                                         | `true`              |
| `primary.containerSecurityContext.runAsUser`    | User ID for the MariaDB primary container                                                                         | `1001`              |
| `primary.containerSecurityContext.runAsNonRoot` | Set Controller container's Security Context runAsNonRoot                                                          | `true`              |
| `primary.resources.limits`                      | The resources limits for MariaDB primary containers                                                               | `{}`                |
| `primary.resources.requests`                    | The requested resources for MariaDB primary containers                                                            | `{}`                |
| `primary.startupProbe.enabled`                  | Enable startupProbe                                                                                               | `false`             |
| `primary.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                            | `120`               |
| `primary.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                   | `15`                |
| `primary.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                  | `5`                 |
| `primary.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                | `10`                |
| `primary.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                | `1`                 |
| `primary.livenessProbe.enabled`                 | Enable livenessProbe                                                                                              | `true`              |
| `primary.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                           | `120`               |
| `primary.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                  | `10`                |
| `primary.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                 | `1`                 |
| `primary.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                               | `3`                 |
| `primary.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                               | `1`                 |
| `primary.readinessProbe.enabled`                | Enable readinessProbe                                                                                             | `true`              |
| `primary.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                          | `30`                |
| `primary.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                 | `10`                |
| `primary.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                | `1`                 |
| `primary.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                              | `3`                 |
| `primary.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                              | `1`                 |
| `primary.customStartupProbe`                    | Override default startup probe for MariaDB primary containers                                                     | `{}`                |
| `primary.customLivenessProbe`                   | Override default liveness probe for MariaDB primary containers                                                    | `{}`                |
| `primary.customReadinessProbe`                  | Override default readiness probe for MariaDB primary containers                                                   | `{}`                |
| `primary.startupWaitOptions`                    | Override default builtin startup wait check options for MariaDB primary containers                                | `{}`                |
| `primary.extraFlags`                            | MariaDB primary additional command line flags                                                                     | `""`                |
| `primary.extraEnvVars`                          | Extra environment variables to be set on MariaDB primary containers                                               | `[]`                |
| `primary.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for MariaDB primary containers                               | `""`                |
| `primary.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for MariaDB primary containers                                  | `""`                |
| `primary.persistence.enabled`                   | Enable persistence on MariaDB primary replicas using a `PersistentVolumeClaim`. If false, use emptyDir            | `true`              |
| `primary.persistence.existingClaim`             | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                                          | `""`                |
| `primary.persistence.subPath`                   | Subdirectory of the volume to mount at                                                                            | `""`                |
| `primary.persistence.storageClass`              | MariaDB primary persistent volume storage Class                                                                   | `""`                |
| `primary.persistence.annotations`               | MariaDB primary persistent volume claim annotations                                                               | `{}`                |
| `primary.persistence.accessModes`               | MariaDB primary persistent volume access Modes                                                                    | `["ReadWriteOnce"]` |
| `primary.persistence.size`                      | MariaDB primary persistent volume size                                                                            | `8Gi`               |
| `primary.persistence.selector`                  | Selector to match an existing Persistent Volume                                                                   | `{}`                |
| `primary.extraVolumes`                          | Optionally specify extra list of additional volumes to the MariaDB Primary pod(s)                                 | `[]`                |
| `primary.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the MariaDB Primary container(s)                     | `[]`                |
| `primary.initContainers`                        | Add additional init containers for the MariaDB Primary pod(s)                                                     | `[]`                |
| `primary.sidecars`                              | Add additional sidecar containers for the MariaDB Primary pod(s)                                                  | `[]`                |
| `primary.service.type`                          | MariaDB Primary Kubernetes service type                                                                           | `ClusterIP`         |
| `primary.service.ports.mysql`                   | MariaDB Primary Kubernetes service port                                                                           | `3306`              |
| `primary.service.nodePorts.mysql`               | MariaDB Primary Kubernetes service node port                                                                      | `""`                |
| `primary.service.clusterIP`                     | MariaDB Primary Kubernetes service clusterIP IP                                                                   | `""`                |
| `primary.service.loadBalancerIP`                | MariaDB Primary loadBalancerIP if service type is `LoadBalancer`                                                  | `""`                |
| `primary.service.externalTrafficPolicy`         | Enable client source IP preservation                                                                              | `Cluster`           |
| `primary.service.loadBalancerSourceRanges`      | Address that are allowed when MariaDB Primary service is LoadBalancer                                             | `[]`                |
| `primary.service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                    | `[]`                |
| `primary.service.annotations`                   | Provide any additional annotations which may be required                                                          | `{}`                |
| `primary.service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                              | `None`              |
| `primary.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                       | `{}`                |
| `primary.pdb.create`                            | Enable/disable a Pod Disruption Budget creation for MariaDB primary pods                                          | `false`             |
| `primary.pdb.minAvailable`                      | Minimum number/percentage of MariaDB primary pods that must still be available after the eviction                 | `1`                 |
| `primary.pdb.maxUnavailable`                    | Maximum number/percentage of MariaDB primary pods that can be unavailable after the eviction                      | `""`                |
| `primary.revisionHistoryLimit`                  | Maximum number of revisions that will be maintained in the StatefulSet                                            | `10`                |


### MariaDB Secondary parameters

| Name                                              | Description                                                                                                           | Value               |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `secondary.replicaCount`                          | Number of MariaDB secondary replicas                                                                                  | `1`                 |
| `secondary.command`                               | Override default container command on MariaDB Secondary container(s) (useful when using custom images)                | `[]`                |
| `secondary.args`                                  | Override default container args on MariaDB Secondary container(s) (useful when using custom images)                   | `[]`                |
| `secondary.lifecycleHooks`                        | for the MariaDB Secondary container(s) to automate configuration before or after startup                              | `{}`                |
| `secondary.hostAliases`                           | Add deployment host aliases                                                                                           | `[]`                |
| `secondary.configuration`                         | MariaDB Secondary configuration to be injected as ConfigMap                                                           | `""`                |
| `secondary.existingConfigmap`                     | Name of existing ConfigMap with MariaDB Secondary configuration.                                                      | `""`                |
| `secondary.updateStrategy.type`                   | MariaDB secondary statefulset strategy type                                                                           | `RollingUpdate`     |
| `secondary.rollingUpdatePartition`                | Partition update strategy for Mariadb Secondary statefulset                                                           | `""`                |
| `secondary.podAnnotations`                        | Additional pod annotations for MariaDB secondary pods                                                                 | `{}`                |
| `secondary.podLabels`                             | Extra labels for MariaDB secondary pods                                                                               | `{}`                |
| `secondary.podAffinityPreset`                     | MariaDB secondary pod affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`       | `""`                |
| `secondary.podAntiAffinityPreset`                 | MariaDB secondary pod anti-affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`  | `soft`              |
| `secondary.nodeAffinityPreset.type`               | MariaDB secondary node affinity preset type. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard` | `""`                |
| `secondary.nodeAffinityPreset.key`                | MariaDB secondary node label key to match Ignored if `secondary.affinity` is set.                                     | `""`                |
| `secondary.nodeAffinityPreset.values`             | MariaDB secondary node label values to match. Ignored if `secondary.affinity` is set.                                 | `[]`                |
| `secondary.affinity`                              | Affinity for MariaDB secondary pods assignment                                                                        | `{}`                |
| `secondary.nodeSelector`                          | Node labels for MariaDB secondary pods assignment                                                                     | `{}`                |
| `secondary.tolerations`                           | Tolerations for MariaDB secondary pods assignment                                                                     | `[]`                |
| `secondary.topologySpreadConstraints`             | Topology Spread Constraints for MariaDB secondary pods assignment                                                     | `{}`                |
| `secondary.priorityClassName`                     | Priority class for MariaDB secondary pods assignment                                                                  | `""`                |
| `secondary.schedulerName`                         | Name of the k8s scheduler (other than default)                                                                        | `""`                |
| `secondary.podManagementPolicy`                   | podManagementPolicy to manage scaling operation of MariaDB secondary pods                                             | `""`                |
| `secondary.podSecurityContext.enabled`            | Enable security context for MariaDB secondary pods                                                                    | `true`              |
| `secondary.podSecurityContext.fsGroup`            | Group ID for the mounted volumes' filesystem                                                                          | `1001`              |
| `secondary.containerSecurityContext.enabled`      | MariaDB secondary container securityContext                                                                           | `true`              |
| `secondary.containerSecurityContext.runAsUser`    | User ID for the MariaDB secondary container                                                                           | `1001`              |
| `secondary.containerSecurityContext.runAsNonRoot` | Set Controller container's Security Context runAsNonRoot                                                              | `true`              |
| `secondary.resources.limits`                      | The resources limits for MariaDB secondary containers                                                                 | `{}`                |
| `secondary.resources.requests`                    | The requested resources for MariaDB secondary containers                                                              | `{}`                |
| `secondary.startupProbe.enabled`                  | Enable startupProbe                                                                                                   | `false`             |
| `secondary.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                | `120`               |
| `secondary.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                       | `15`                |
| `secondary.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                      | `5`                 |
| `secondary.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                    | `10`                |
| `secondary.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                    | `1`                 |
| `secondary.livenessProbe.enabled`                 | Enable livenessProbe                                                                                                  | `true`              |
| `secondary.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                               | `120`               |
| `secondary.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                      | `10`                |
| `secondary.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                     | `1`                 |
| `secondary.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                   | `3`                 |
| `secondary.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                   | `1`                 |
| `secondary.readinessProbe.enabled`                | Enable readinessProbe                                                                                                 | `true`              |
| `secondary.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                              | `30`                |
| `secondary.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                     | `10`                |
| `secondary.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                    | `1`                 |
| `secondary.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                  | `3`                 |
| `secondary.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                  | `1`                 |
| `secondary.customStartupProbe`                    | Override default startup probe for MariaDB secondary containers                                                       | `{}`                |
| `secondary.customLivenessProbe`                   | Override default liveness probe for MariaDB secondary containers                                                      | `{}`                |
| `secondary.customReadinessProbe`                  | Override default readiness probe for MariaDB secondary containers                                                     | `{}`                |
| `secondary.startupWaitOptions`                    | Override default builtin startup wait check options for MariaDB secondary containers                                  | `{}`                |
| `secondary.extraFlags`                            | MariaDB secondary additional command line flags                                                                       | `""`                |
| `secondary.extraEnvVars`                          | Extra environment variables to be set on MariaDB secondary containers                                                 | `[]`                |
| `secondary.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for MariaDB secondary containers                                 | `""`                |
| `secondary.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for MariaDB secondary containers                                    | `""`                |
| `secondary.persistence.enabled`                   | Enable persistence on MariaDB secondary replicas using a `PersistentVolumeClaim`                                      | `true`              |
| `secondary.persistence.subPath`                   | Subdirectory of the volume to mount at                                                                                | `""`                |
| `secondary.persistence.storageClass`              | MariaDB secondary persistent volume storage Class                                                                     | `""`                |
| `secondary.persistence.annotations`               | MariaDB secondary persistent volume claim annotations                                                                 | `{}`                |
| `secondary.persistence.accessModes`               | MariaDB secondary persistent volume access Modes                                                                      | `["ReadWriteOnce"]` |
| `secondary.persistence.size`                      | MariaDB secondary persistent volume size                                                                              | `8Gi`               |
| `secondary.persistence.selector`                  | Selector to match an existing Persistent Volume                                                                       | `{}`                |
| `secondary.extraVolumes`                          | Optionally specify extra list of additional volumes to the MariaDB secondary pod(s)                                   | `[]`                |
| `secondary.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the MariaDB secondary container(s)                       | `[]`                |
| `secondary.initContainers`                        | Add additional init containers for the MariaDB secondary pod(s)                                                       | `[]`                |
| `secondary.sidecars`                              | Add additional sidecar containers for the MariaDB secondary pod(s)                                                    | `[]`                |
| `secondary.service.type`                          | MariaDB secondary Kubernetes service type                                                                             | `ClusterIP`         |
| `secondary.service.ports.mysql`                   | MariaDB secondary Kubernetes service port                                                                             | `3306`              |
| `secondary.service.nodePorts.mysql`               | MariaDB secondary Kubernetes service node port                                                                        | `""`                |
| `secondary.service.clusterIP`                     | MariaDB secondary Kubernetes service clusterIP IP                                                                     | `""`                |
| `secondary.service.loadBalancerIP`                | MariaDB secondary loadBalancerIP if service type is `LoadBalancer`                                                    | `""`                |
| `secondary.service.externalTrafficPolicy`         | Enable client source IP preservation                                                                                  | `Cluster`           |
| `secondary.service.loadBalancerSourceRanges`      | Address that are allowed when MariaDB secondary service is LoadBalancer                                               | `[]`                |
| `secondary.service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                        | `[]`                |
| `secondary.service.annotations`                   | Provide any additional annotations which may be required                                                              | `{}`                |
| `secondary.service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                  | `None`              |
| `secondary.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                           | `{}`                |
| `secondary.pdb.create`                            | Enable/disable a Pod Disruption Budget creation for MariaDB secondary pods                                            | `false`             |
| `secondary.pdb.minAvailable`                      | Minimum number/percentage of MariaDB secondary pods that should remain scheduled                                      | `1`                 |
| `secondary.pdb.maxUnavailable`                    | Maximum number/percentage of MariaDB secondary pods that may be made unavailable                                      | `""`                |
| `secondary.revisionHistoryLimit`                  | Maximum number of revisions that will be maintained in the StatefulSet                                                | `10`                |


### RBAC parameters

| Name                                          | Description                                                    | Value   |
| --------------------------------------------- | -------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for MariaDB pods       | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount                             | `""`    |
| `serviceAccount.annotations`                  | Annotations for MariaDB Service Account                        | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account | `false` |
| `rbac.create`                                 | Whether to create and use RBAC resources or not                | `false` |


### Volume Permissions parameters

| Name                                   | Description                                                                                                          | Value                   |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`            | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                     | `docker.io`             |
| `volumePermissions.image.repository`   | Init container volume-permissions image repository                                                                   | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag (immutable tags are recommended)                                         | `10-debian-10-r305`     |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                  | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                     | `[]`                    |
| `volumePermissions.resources.limits`   | Init container volume-permissions resource limits                                                                    | `{}`                    |
| `volumePermissions.resources.requests` | Init container volume-permissions resource requests                                                                  | `{}`                    |


### Metrics parameters

| Name                                         | Description                                                                                                                               | Value                     |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `metrics.enabled`                            | Start a side-car prometheus exporter                                                                                                      | `false`                   |
| `metrics.image.registry`                     | Exporter image registry                                                                                                                   | `docker.io`               |
| `metrics.image.repository`                   | Exporter image repository                                                                                                                 | `bitnami/mysqld-exporter` |
| `metrics.image.tag`                          | Exporter image tag (immutable tags are recommended)                                                                                       | `0.13.0-debian-10-r209`   |
| `metrics.image.pullPolicy`                   | Exporter image pull policy                                                                                                                | `IfNotPresent`            |
| `metrics.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                                          | `[]`                      |
| `metrics.annotations`                        | Annotations for the Exporter pod                                                                                                          | `{}`                      |
| `metrics.extraArgs`                          | Extra args to be passed to mysqld_exporter                                                                                                | `{}`                      |
| `metrics.containerSecurityContext.enabled`   | Enable security context for MariaDB metrics container                                                                                     | `false`                   |
| `metrics.resources.limits`                   | The resources limits for MariaDB prometheus exporter containers                                                                           | `{}`                      |
| `metrics.resources.requests`                 | The requested resources for MariaDB prometheus exporter containers                                                                        | `{}`                      |
| `metrics.livenessProbe.enabled`              | Enable livenessProbe                                                                                                                      | `true`                    |
| `metrics.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                                   | `120`                     |
| `metrics.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                                          | `10`                      |
| `metrics.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                                         | `1`                       |
| `metrics.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                                       | `3`                       |
| `metrics.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                                       | `1`                       |
| `metrics.readinessProbe.enabled`             | Enable readinessProbe                                                                                                                     | `true`                    |
| `metrics.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                                  | `30`                      |
| `metrics.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                                         | `10`                      |
| `metrics.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                                        | `1`                       |
| `metrics.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                                      | `3`                       |
| `metrics.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                                      | `1`                       |
| `metrics.serviceMonitor.enabled`             | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                              | `false`                   |
| `metrics.serviceMonitor.namespace`           | Namespace which Prometheus is running in                                                                                                  | `""`                      |
| `metrics.serviceMonitor.jobLabel`            | The name of the label on the target service to use as the job name in prometheus.                                                         | `""`                      |
| `metrics.serviceMonitor.interval`            | Interval at which metrics should be scraped                                                                                               | `30s`                     |
| `metrics.serviceMonitor.scrapeTimeout`       | Specify the timeout after which the scrape is ended                                                                                       | `""`                      |
| `metrics.serviceMonitor.relabelings`         | RelabelConfigs to apply to samples before scraping                                                                                        | `[]`                      |
| `metrics.serviceMonitor.metricRelabelings`   | MetricRelabelConfigs to apply to samples before ingestion                                                                                 | `[]`                      |
| `metrics.serviceMonitor.honorLabels`         | honorLabels chooses the metric's labels on collisions with target labels                                                                  | `false`                   |
| `metrics.serviceMonitor.selector`            | ServiceMonitor selector labels                                                                                                            | `{}`                      |
| `metrics.serviceMonitor.labels`              | Extra labels for the ServiceMonitor                                                                                                       | `{}`                      |
| `metrics.prometheusRule.enabled`             | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`) | `false`                   |
| `metrics.prometheusRule.namespace`           | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                             | `""`                      |
| `metrics.prometheusRule.additionalLabels`    | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                     | `{}`                      |
| `metrics.prometheusRule.rules`               | Prometheus Rule definitions                                                                                                               | `[]`                      |


### NetworkPolicy parameters

| Name                                                                   | Description                                                                                                                            | Value   |
| ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                                | Enable network policies                                                                                                                | `false` |
| `networkPolicy.metrics.enabled`                                        | Enable network policy for metrics (prometheus)                                                                                         | `false` |
| `networkPolicy.metrics.namespaceSelector`                              | Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                                 | `{}`    |
| `networkPolicy.metrics.podSelector`                                    | Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                             | `{}`    |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.enabled`             | Enable ingress rule that makes primary mariadb nodes only accessible from a particular origin.                                         | `false` |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.namespaceSelector`   | Namespace selector label that is allowed to access the primary node. This label will be used to identified the allowed namespace(s).   | `{}`    |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.podSelector`         | Pods selector label that is allowed to access the primary node. This label will be used to identified the allowed pod(s).              | `{}`    |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.customRules`         | Custom network policy for the primary node.                                                                                            | `{}`    |
| `networkPolicy.ingressRules.secondaryAccessOnlyFrom.enabled`           | Enable ingress rule that makes primary mariadb nodes only accessible from a particular origin.                                         | `false` |
| `networkPolicy.ingressRules.secondaryAccessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to acces the secondary nodes. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.secondaryAccessOnlyFrom.podSelector`       | Pods selector label that is allowed to access the secondary nodes. This label will be used to identified the allowed pod(s).           | `{}`    |
| `networkPolicy.ingressRules.secondaryAccessOnlyFrom.customRules`       | Custom network policy for the secondary nodes.                                                                                         | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`                  | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                                         | `false` |
| `networkPolicy.egressRules.customRules`                                | Custom network policy rule                                                                                                             | `{}`    |


The above parameters map to the env variables defined in [bitnami/mariadb](https://github.com/bitnami/bitnami-docker-mariadb). For more information please refer to the [bitnami/mariadb](https://github.com/bitnami/bitnami-docker-mariadb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set auth.rootPassword=secretpassword,auth.database=app_database \
    bitnami/mariadb
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a database named `my_database`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/mariadb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change MariaDB version

To modify the MariaDB version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/mariadb/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Initialize a fresh instance

The [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image allows you to use your custom scripts to initialize a fresh instance. Custom scripts may be specified using the `initdbScripts` parameter. Alternatively, an external ConfigMap may be created with all the initialization scripts and the ConfigMap passed to the chart via the `initdbScriptsConfigMap` parameter. Note that this will override the `initdbScripts` parameter.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

These scripts are treated differently depending on their extension. While `.sh` scripts are executed on all the nodes, `.sql` and `.sql.gz` scripts are only executed on the primary nodes. This is because `.sh` scripts support conditional tests to identify the type of node they are running on, while such tests are not supported in `.sql` or `.sql.gz` files.

[Refer to the chart documentation for more information and a usage example](https://docs.bitnami.com/kubernetes/infrastructure/mariadb/configuration/customize-new-instance/).

### Sidecars and Init Containers

If additional containers are needed in the same pod as MariaDB (such as additional metrics or logging exporters), they can be defined using the sidecars parameter.

The Helm chart already includes sidecar containers for the Prometheus exporters. These can be activated by adding the `–enable-metrics=true` parameter at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers. [See an example of configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/infrastructure/mariadb/configuration/configure-sidecar-init-containers/).

Similarly, additional containers can be added to MariaDB pods using the `initContainers` parameter. [See an example of configuring and using init containers](https://docs.bitnami.com/kubernetes/infrastructure/mariadb/configuration/configure-sidecar-init-containers/).

## Persistence

The [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image stores the MariaDB data and configurations at the `/bitnami/mariadb` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can also be defined.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.

As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination. You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to set the `auth.rootPassword` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Administrator credentials' section. Please note down the password and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/mariadb --set auth.rootPassword=[ROOT_PASSWORD]
```

| Note: you need to substitute the placeholder _[ROOT_PASSWORD]_ with the value obtained in the installation notes.

### To 10.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `primary.service.port` was deprecated, we recommend using `primary.service.ports.mysql` instead.
- `primary.service.nodePort` was deprecated, we recommend using `primary.service.nodePorts.mysql` instead.
- `secondary.service.port` was deprecated, we recommend using `secondary.service.ports.mysql` instead.
- `secondary.service.nodePort` was deprecated, we recommend using `secondary.service.nodePorts.mysql` instead.
- `metrics.serviceMonitor.additionalLabels` was deprecated, we recommend using `metrics.serviceMonitor.selector` instead.
- `primary.pdb.enabled` renamed as `primary.pdb.create`.
- `secondary.pdb.enabled` renamed as `secondary.pdb.create`.
- `primary.updateStrategy` changed from String type (previously default to 'rollingUpdate') to Object type, allowing users to configure other updateStrategy parameters, similar to other charts.
- Removed value `primary.rollingUpdatePartition`, now configured using `primary.updateStrategy` setting `primary.updateStrategy.rollingUpdate.partition`.
- `secondary.updateStrategy` changed from String type (previously default to 'rollingUpdate') to Object type, allowing users to configure other updateStrategy parameters, similar to other charts.
- Removed value `secondary.rollingUpdatePartition`, now configured using `secondary.updateStrategy` setting `secondary.updateStrategy.rollingUpdate.partition`.
- `metrics.serviceMonitor.relabellings`, previously used to configure ServiceMonitor metricRelabelings, has been replaced with the value `metrics.serviceMonitor.metricRelabelings`, and new value `metrics.serviceMonitor.relabelings` can be used to set ServiceMonitor relabelings parameter

### To 9.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/mariadb/administration/upgrade-helm3/).

### To 8.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - The terms _master_ and _slave_ have been replaced by the terms _primary_ and _secondary_. Therefore, parameters prefixed with `master` or `slave` are now prefixed with `primary` or `secondary`, respectively.
  - `securityContext.*` is deprecated in favor of `primary.podSecurityContext`, `primary.containerSecurityContext`, `secondary.podSecurityContext`, and `secondary.containerSecurityContext`.
  - Credentials parameter are reorganized under the `auth` parameter.
  - `replication.enabled` parameter is deprecated in favor of `architecture` parameter that accepts two values: `standalone` and `replication`.
- The default MariaDB version was updated from 10.3 to 10.5. According to the official documentation, upgrading from 10.3 should be painless. However, there are some things that have changed which could affect an upgrade:
  - [Incompatible changes upgrading from MariaDB 10.3 to MariaDB 10.4](https://mariadb.com/kb/en/upgrading-from-mariadb-103-to-mariadb-104/#incompatible-changes-between-103-and-104).
  - [Incompatible changes upgrading from MariaDB 10.4 to MariaDB 10.5](https://mariadb.com/kb/en/upgrading-from-mariadb-104-to-mariadb-105/#incompatible-changes-between-104-and-105).
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

Backwards compatibility is not guaranteed. To upgrade to `8.0.0`, install a new release of the MariaDB chart, and migrate the data from your previous release. You have 2 alternatives to do so:

- Create a backup of the database, and restore it on the new release using tools such as [mysqldump](https://mariadb.com/kb/en/mysqldump/).
- Reuse the PVC used to hold the master data on your previous release. To do so, use the `primary.persistence.existingClaim` parameter. The following example assumes that the release name is `mariadb`:

```bash
$ helm install mariadb bitnami/mariadb --set auth.rootPassword=[ROOT_PASSWORD] --set primary.persistence.existingClaim=[EXISTING_PVC]
```

| Note: you need to substitute the placeholder _[EXISTING_PVC]_ with the name of the PVC used on your previous release, and _[ROOT_PASSWORD]_ with the root password used in your previous release.

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17308 the `apiVersion` of the statefulset resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version bump signifies this change.

### To 6.0.0

MariaDB version was updated from 10.1 to 10.3, there are no changes in the chart itself. According to the official documentation, upgrading from 10.1 should be painless. However, there are some things that have changed which could affect an upgrade:

- [Incompatible changes upgrading from MariaDB 10.1 to MariaDB 10.2](https://mariadb.com/kb/en/library/upgrading-from-mariadb-101-to-mariadb-102//#incompatible-changes-between-101-and-102)
- [Incompatible changes upgrading from MariaDB 10.2 to MariaDB 10.3](https://mariadb.com/kb/en/library/upgrading-from-mariadb-102-to-mariadb-103/#incompatible-changes-between-102-and-103)

### To 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is mariadb:

```console
$ kubectl delete statefulset opencart-mariadb --cascade=false
```

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
