# PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance.

For HA, please see [this repo](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha)

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/postgresql
```

## Introduction

This chart bootstraps a [PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart
To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/postgresql
```

The command deploys PostgreSQL on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components but PVC's associated with the chart and deletes the release.

To delete the PVC's associated with `my-release`:

```console
$ kubectl delete pvc -l release=my-release
```

> **Note**: Deleting the PVC's will delete postgresql data as well. Please be cautious before doing it.

## Parameters

### Global parameters

| Name                      | Description                                     | Value       |
| ------------------------- | ----------------------------------------------- | ----------- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil`       |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `undefined` |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil`       |


### PostgreSQL Image parameters

| Name                | Description                                           | Value                  |
| ------------------- | ----------------------------------------------------- | ---------------------- |
| `image.registry`    | PostgreSQL image registry                             | `docker.io`            |
| `image.repository`  | PostgreSQL image repository                           | `bitnami/postgresql`   |
| `image.tag`         | PostgreSQL image tag (immutable tags are recommended) | `13.3.0-debian-10-r46` |
| `image.pullPolicy`  | PostgreSQL image pull policy                          | `IfNotPresent`         |
| `image.pullSecrets` | PostgreSQL image pull secrets                         | `undefined`            |
| `image.debug`       | Enable image debug mode                               | `false`                |


### Common parameters

| Name                | Description                                                        | Value           |
| ------------------- | ------------------------------------------------------------------ | --------------- |
| `kubeVersion`       | Override Kubernetes version                                        | `nil`           |
| `nameOverride`      | String to partially override common.names.fullname                 | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname                     | `nil`           |
| `commonLabels`      | Labels to add to all deployed objects                              | `undefined`     |
| `commonAnnotations` | Annotations to add to all deployed objects                         | `undefined`     |
| `clusterDomain`     | Kubernetes cluster domain name                                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                  | `undefined`     |
| `architecture`      | PostgreSQL architecture. Allowed values: standalone or replication | `standalone`    |


### Authentication configuration

| Name                       | Description                                                         | Value           |
| -------------------------- | ------------------------------------------------------------------- | --------------- |
| `auth.rootPassword`        | PostgreSQL admin password                                           | `""`            |
| `auth.database`            | PostgreSQL custom database                                          | `""`            |
| `auth.username`            | PostgreSQL custom user                                              | `postgres`      |
| `auth.password`            | PostgreSQL password                                                 | `""`            |
| `auth.replicationUser`     | PostgreSQL replication user                                         | `repl_user`     |
| `auth.replicationPassword` | PostgreSQL replication password                                     | `repl_password` |
| `auth.existingSecret`      | Existing secret with PostgreSQL credentials                         | `nil`           |
| `auth.forcePassword`       | Force users to specify required passwords                           | `false`         |
| `auth.usePasswordFiles`    | Mount credentials as files instead of using an environment variable | `false`         |


### Primary configuration parameters

| Name                                         | Description                                                                                    | Value                 |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------- | --------------------- |
| `primary.primaryAsStandBy.enabled`           | Whether to enable current cluster's primary as standby server of another cluster or not.       | `false`               |
| `primary.primaryAsStandBy.primaryHost`       | The Host of replication primary in the other cluster.                                          | `nil`                 |
| `primary.primaryAsStandBy.primaryPort`       | The Port of replication primary in the other cluster.                                          | `nil`                 |
| `primary.command`                            | Override default container command (useful when using custom images)                           | `undefined`           |
| `primary.args`                               | Override default container args (useful when using custom images)                              | `undefined`           |
| `primary.hostAliases`                        | Deployment pod host aliases                                                                    | `undefined`           |
| `primary.updateStrategy.type`                | PostgreSQL primary statefulset strategy type                                                   | `RollingUpdate`       |
| `primary.podAffinityPreset`                  | PostgreSQL Primary pod affinity preset                                                         | `""`                  |
| `primary.podAntiAffinityPreset`              | PostgreSQL Primary pod anti-affinity preset                                                    | `soft`                |
| `primary.nodeAffinityPreset.type`            | Node affinity type                                                                             | `""`                  |
| `primary.nodeAffinityPreset.key`             | Node label key to match                                                                        | `""`                  |
| `primary.nodeAffinityPreset.values`          | Node label values to match                                                                     | `undefined`           |
| `primary.affinity`                           | Affinity for PostgreSQL primary pods assignment                                                | `undefined`           |
| `primary.nodeSelector`                       | Node labels for PostgreSQL primary pods assignment                                             | `undefined`           |
| `primary.tolerations`                        | Tolerations for PostgreSQL primary pods assignment                                             | `undefined`           |
| `primary.labels`                             | Provide any additional labels which may be required.                                           | `undefined`           |
| `primary.annotations`                        | Job annotations for PostgreSQL primary pods assignment                                         | `undefined`           |
| `primary.podLabels`                          | Pod extra labels for PostgreSQL primary pods assignment                                        | `undefined`           |
| `primary.podAnnotations`                     | Annotations for PostgreSQL primary pods                                                        | `undefined`           |
| `primary.priorityClassName`                  | Priority class for PostgreSQL primary pods assignment                                          | `""`                  |
| `primary.securityContext.enabled`            | Enabled PostgreSQL primary containers' Security Context                                        | `true`                |
| `primary.securityContext.fsGroup`            | Set PostgreSQL primary containers' Security Context runAsUser                                  | `1001`                |
| `primary.containerSecurityContext.enabled`   | Enabled PostgreSQL primary containers' Security Context                                        | `true`                |
| `primary.containerSecurityContext.runAsUser` | Set PostgreSQL primary containers' Security Context runAsUser                                  | `1001`                |
| `primary.schedulerName`                      | Alternate scheduler for PostgreSQL primary pods                                                | `nil`                 |
| `primary.resources.limits`                   | The resources limits for the PostgreSQL primary containers                                     | `undefined`           |
| `primary.resources.requests`                 | The requested resources for the PostgreSQL primary containers                                  | `undefined`           |
| `primary.startupProbe.enabled`               | Enable startupProbe on PostgreSQL primary nodes                                                | `false`               |
| `primary.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                         | `30`                  |
| `primary.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                | `15`                  |
| `primary.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                               | `5`                   |
| `primary.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                             | `10`                  |
| `primary.startupProbe.successThreshold`      | Success threshold for startupProbe                                                             | `1`                   |
| `primary.livenessProbe.enabled`              | Enable livenessProbe on PostgreSQL primary nodes                                               | `true`                |
| `primary.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                        | `30`                  |
| `primary.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                               | `10`                  |
| `primary.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                              | `5`                   |
| `primary.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                            | `6`                   |
| `primary.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                            | `1`                   |
| `primary.readinessProbe.enabled`             | Enable readinessProbe on PostgreSQL primary nodes                                              | `true`                |
| `primary.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                       | `5`                   |
| `primary.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                              | `10`                  |
| `primary.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                             | `5`                   |
| `primary.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                           | `6`                   |
| `primary.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                           | `1`                   |
| `primary.customStartupProbe`                 | PostgreSQL primary custom startup probe                                                        | `undefined`           |
| `primary.customLivenessProbe`                | PostgreSQL primary custom liveness probe                                                       | `undefined`           |
| `primary.customReadinessProbe`               | PostgreSQL primary custom rediness probe                                                       | `undefined`           |
| `primary.extraEnvVars`                       | An array to add extra environment variables on PostgreSQL primary containers                   | `undefined`           |
| `primary.extraEnvVarsCM`                     | ConfigMap with extra env vars for PostgreSQL primary containers:                               | `""`                  |
| `primary.extraEnvVarsSecret`                 | Secret with extra env vars for PostgreSQL primary containers:                                  | `""`                  |
| `primary.extraVolumes`                       | Extra volumes to add to the PostgreSQL Primary pod(s)                                          | `undefined`           |
| `primary.extraVolumeMounts`                  | Extra volume mounts to add to the PostgreSQL Primary container(s)                              | `undefined`           |
| `primary.initContainers`                     | Extra init containers to add to the PostgreSQL Primary pod(s)                                  | `undefined`           |
| `primary.sidecars`                           | Extra sidecar containers to add to the PostgreSQL Primary pod(s)                               | `undefined`           |
| `primary.persistence.enabled`                | Enable persistence on PostgreSQL primary nodes using Persistent Volume Claims                  | `true`                |
| `primary.persistence.mountPath`              | The path the volume will be mounted at on PostgreSQL primary containers                        | `/bitnami/postgresql` |
| `primary.persistence.subPath`                | The subdirectory of the volume to mount on PostgreSQL primary containers                       | `""`                  |
| `primary.persistence.storageClass`           | Persistent Volume storage class                                                                | `nil`                 |
| `primary.persistence.accessModes`            | Persistent Volume Access Mode                                                                  | `[]`                  |
| `primary.persistence.size`                   | Persistent Volume size                                                                         | `8Gi`                 |
| `primary.persistence.annotations`            | Persistent Volume Claim annotations                                                            | `undefined`           |
| `primary.persistence.selector`               | Additional labels to match for the PVC                                                         | `undefined`           |
| `primary.persistence.existingClaim`          | Use a existing PVC which must be created manually before bound                                 | `nil`                 |
| `primary.service.type`                       | PostgreSQL primary service type                                                                | `ClusterIP`           |
| `primary.service.port`                       | PostgreSQL primary service port                                                                | `5432`                |
| `primary.service.nodePort`                   | Node port for PostgreSQL primary                                                               | `nil`                 |
| `primary.service.externalTrafficPolicy`      | PostgreSQL primary service external traffic policy                                             | `Cluster`             |
| `primary.service.clusterIP`                  | PostgreSQL primary service Cluster IP                                                          | `nil`                 |
| `primary.service.loadBalancerIP`             | PostgreSQL primary service Load Balancer IP                                                    | `nil`                 |
| `primary.service.loadBalancerSourceRanges`   | PostgreSQL primary service Load Balancer sources                                               | `undefined`           |
| `primary.service.annotations`                | Additional custom annotations for PostgreSQL primary service                                   | `undefined`           |
| `primary.pdb.enabled`                        | Whether to enable Pod Disruption Budget for PostgreSQL primary pods                            | `false`               |
| `primary.pdb.minAvailable`                   | Min number of pods that must still be available after the eviction for PostgreSQL primary pods | `1`                   |
| `primary.pdb.maxUnavailable`                 | Max number of pods that can be unavailable after the eviction for PostgreSQL primary pods      | `nil`                 |
| `primary.terminationGracePeriodSeconds`      | Integer setting the termination grace period for PostgreSQL primary pods                       | `30`                  |


### Read-only replicas configuration parameters

| Name                                              | Description                                                                                                     | Value                 |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------- |
| `readReplicas.replicaCount`                       | Number of PostgreSQL replicas to deploy                                                                         | `1`                   |
| `readReplicas.synchronousCommit`                  | Set synchronous commit mode: on, off, remote_apply, remote_write and local                                      | `off`                 |
| `readReplicas.numSynchronousReplicas`             | From the number of `readReplicas` defined above, set the number of those that will have synchronous replication | `0`                   |
| `readReplicas.applicationName`                    | Replication Cluster application name. Useful for defining multiple replication policies                         | `my_application`      |
| `readReplicas.command`                            | Override default container command (useful when using custom images)                                            | `undefined`           |
| `readReplicas.args`                               | Override default container args (useful when using custom images)                                               | `undefined`           |
| `readReplicas.hostAliases`                        | Deployment pod host aliases                                                                                     | `undefined`           |
| `readReplicas.updateStrategy.type`                | PostgreSQL replica statefulset strategy type                                                                    | `RollingUpdate`       |
| `readReplicas.podAffinityPreset`                  | PostgreSQL replica pod affinity preset                                                                          | `""`                  |
| `readReplicas.podAntiAffinityPreset`              | PostgreSQL replica pod anti-affinity preset                                                                     | `soft`                |
| `readReplicas.nodeAffinityPreset.type`            | Node affinity type                                                                                              | `""`                  |
| `readReplicas.nodeAffinityPreset.key`             | Node label key to match                                                                                         | `""`                  |
| `readReplicas.nodeAffinityPreset.values`          | Node label values to match                                                                                      | `undefined`           |
| `readReplicas.affinity`                           | Affinity for PostgreSQL replica pods assignment                                                                 | `undefined`           |
| `readReplicas.nodeSelector`                       | Node labels for PostgreSQL replica pods assignment                                                              | `undefined`           |
| `readReplicas.tolerations`                        | Tolerations for PostgreSQL replica pods assignment                                                              | `undefined`           |
| `readReplicas.labels`                             | Provide any additional labels which may be required.                                                            | `undefined`           |
| `readReplicas.annotations`                        | Job annotations for PostgreSQL replica pods assignment                                                          | `undefined`           |
| `readReplicas.podLabels`                          | Pod extra labels for PostgreSQL replica pods assignment                                                         | `undefined`           |
| `readReplicas.podAnnotations`                     | Annotations for PostgreSQL replica pods                                                                         | `undefined`           |
| `readReplicas.priorityClassName`                  | Priority class for PostgreSQL replica pods assignment                                                           | `""`                  |
| `readReplicas.securityContext.enabled`            | Enabled PostgreSQL replica containers' Security Context                                                         | `true`                |
| `readReplicas.securityContext.fsGroup`            | Set PostgreSQL replica containers' Security Context runAsUser                                                   | `1001`                |
| `readReplicas.containerSecurityContext.enabled`   | Enabled PostgreSQL replica containers' Security Context                                                         | `true`                |
| `readReplicas.containerSecurityContext.runAsUser` | Set PostgreSQL replica containers' Security Context runAsUser                                                   | `1001`                |
| `readReplicas.schedulerName`                      | Alternate scheduler for PostgreSQL replica pods                                                                 | `nil`                 |
| `readReplicas.resources.limits`                   | The resources limits for the PostgreSQL replica containers                                                      | `undefined`           |
| `readReplicas.resources.requests`                 | The requested resources for the PostgreSQL replica containers                                                   | `undefined`           |
| `readReplicas.startupProbe.enabled`               | Enable startupProbe on PostgreSQL replica nodes                                                                 | `false`               |
| `readReplicas.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                          | `30`                  |
| `readReplicas.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                 | `15`                  |
| `readReplicas.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                | `5`                   |
| `readReplicas.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                              | `10`                  |
| `readReplicas.startupProbe.successThreshold`      | Success threshold for startupProbe                                                                              | `1`                   |
| `readReplicas.livenessProbe.enabled`              | Enable livenessProbe on PostgreSQL replica nodes                                                                | `true`                |
| `readReplicas.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                         | `30`                  |
| `readReplicas.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                | `10`                  |
| `readReplicas.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                               | `5`                   |
| `readReplicas.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                             | `6`                   |
| `readReplicas.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                             | `1`                   |
| `readReplicas.readinessProbe.enabled`             | Enable readinessProbe on PostgreSQL replica nodes                                                               | `true`                |
| `readReplicas.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                        | `5`                   |
| `readReplicas.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                               | `10`                  |
| `readReplicas.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                              | `5`                   |
| `readReplicas.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                            | `6`                   |
| `readReplicas.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                            | `1`                   |
| `readReplicas.customStartupProbe`                 | PostgreSQL replica custom startup probe                                                                         | `undefined`           |
| `readReplicas.customLivenessProbe`                | PostgreSQL replica custom liveness probe                                                                        | `undefined`           |
| `readReplicas.customReadinessProbe`               | PostgreSQL replica custom rediness probe                                                                        | `undefined`           |
| `readReplicas.extraEnvVars`                       | An array to add extra environment variables on PostgreSQL replica containers                                    | `undefined`           |
| `readReplicas.extraEnvVarsCM`                     | ConfigMap with extra env vars for PostgreSQL replica containers:                                                | `""`                  |
| `readReplicas.extraEnvVarsSecret`                 | Secret with extra env vars for PostgreSQL replica containers:                                                   | `""`                  |
| `readReplicas.extraVolumes`                       | Extra volumes to add to the PostgreSQL replica pod(s)                                                           | `undefined`           |
| `readReplicas.extraVolumeMounts`                  | Extra volume mounts to add to the PostgreSQL replica container(s)                                               | `undefined`           |
| `readReplicas.initContainers`                     | Extra init containers to add to the PostgreSQL replica pod(s)                                                   | `undefined`           |
| `readReplicas.sidecars`                           | Extra sidecar containers to add to the PostgreSQL replica pod(s)                                                | `undefined`           |
| `readReplicas.persistence.enabled`                | Enable persistence on PostgreSQL replica nodes using Persistent Volume Claims                                   | `true`                |
| `readReplicas.persistence.mountPath`              | The path the volume will be mounted at on PostgreSQL replica containers                                         | `/bitnami/postgresql` |
| `readReplicas.persistence.subPath`                | The subdirectory of the volume to mount on PostgreSQL replica containers                                        | `""`                  |
| `readReplicas.persistence.storageClass`           | Persistent Volume storage class                                                                                 | `nil`                 |
| `readReplicas.persistence.accessModes`            | Persistent Volume Access Mode                                                                                   | `[]`                  |
| `readReplicas.persistence.size`                   | Persistent Volume size                                                                                          | `8Gi`                 |
| `readReplicas.persistence.annotations`            | Persistent Volume Claim annotations                                                                             | `undefined`           |
| `readReplicas.persistence.selector`               | Additional labels to match for the PVC                                                                          | `undefined`           |
| `readReplicas.persistence.existingClaim`          | Use a existing PVC which must be created manually before bound                                                  | `nil`                 |
| `readReplicas.service.type`                       | PostgreSQL replica service type                                                                                 | `ClusterIP`           |
| `readReplicas.service.port`                       | PostgreSQL replica service port                                                                                 | `5432`                |
| `readReplicas.service.nodePort`                   | Node port for PostgreSQL replica                                                                                | `nil`                 |
| `readReplicas.service.externalTrafficPolicy`      | PostgreSQL replica service external traffic policy                                                              | `Cluster`             |
| `readReplicas.service.clusterIP`                  | PostgreSQL replica service Cluster IP                                                                           | `nil`                 |
| `readReplicas.service.loadBalancerIP`             | PostgreSQL replica service Load Balancer IP                                                                     | `nil`                 |
| `readReplicas.service.loadBalancerSourceRanges`   | PostgreSQL replica service Load Balancer sources                                                                | `undefined`           |
| `readReplicas.service.annotations`                | Additional custom annotations for PostgreSQL replica service                                                    | `undefined`           |
| `readReplicas.pdb.enabled`                        | Whether to enable Pod Disruption Budget for PostgreSQL replica pods                                             | `false`               |
| `readReplicas.pdb.minAvailable`                   | Min number of pods that must still be available after the eviction for PostgreSQL replica pods                  | `1`                   |
| `readReplicas.pdb.maxUnavailable`                 | Max number of pods that can be unavailable after the eviction for PostgreSQL replica pods                       | `nil`                 |
| `readReplicas.terminationGracePeriodSeconds`      | Integer setting the termination grace period for PostgreSQL replica pods                                        | `30`                  |


### Common database configuration

| Name                                | Description                                                                             | Value                      |
| ----------------------------------- | --------------------------------------------------------------------------------------- | -------------------------- |
| `postgresqlDataDir`                 | PostgreSQL data dir                                                                     | `/bitnami/postgresql/data` |
| `postgresqlInitdbArgs`              | Specify extra initdb args                                                               | `nil`                      |
| `postgresqlInitdbWalDir`            | Specify a custom location for the PostgreSQL transaction log                            | `nil`                      |
| `postgresqlConfiguration`           | PostgreSQL configuration                                                                | `nil`                      |
| `postgresqlExtendedConf`            | PostgreSQL extended configuration                                                       | `nil`                      |
| `pgHbaConfiguration`                | PostgreSQL client authentication configuration                                          | `undefined`                |
| `configurationConfigMap`            | ConfigMap with PostgreSQL configuration                                                 | `nil`                      |
| `extendedConfConfigMap`             | ConfigMap with PostgreSQL extended configuration                                        | `nil`                      |
| `initdbScripts`                     | initdb scripts                                                                          | `undefined`                |
| `initdbScriptsConfigMap`            | ConfigMap with scripts to be run at first boot                                          | `nil`                      |
| `initdbScriptsSecret`               | Secret with scripts to be run at first boot (in case it contains sensitive information) | `nil`                      |
| `initdbUser`                        | PostgreSQL username to execute the initdb scripts                                       | `nil`                      |
| `initdbPassword`                    | PostgreSQL password to execute the initdb scripts                                       | `nil`                      |
| `postgresqlSharedPreloadLibraries`  | Shared preload libraries                                                                | `pgaudit`                  |
| `postgresqlMaxConnections`          | Maximum total connections                                                               | `nil`                      |
| `postgresqlPostgresConnectionLimit` | Maximum connections for the postgres user                                               | `nil`                      |
| `postgresqlDbUserConnectionLimit`   | Maximum connections for the created user                                                | `nil`                      |
| `postgresqlTcpKeepalivesInterval`   | TCP keepalives interval                                                                 | `nil`                      |
| `postgresqlTcpKeepalivesIdle`       | TCP keepalives idle                                                                     | `nil`                      |
| `postgresqlTcpKeepalivesCount`      | TCP keepalives count                                                                    | `nil`                      |
| `postgresqlStatementTimeout`        | Statement timeout                                                                       | `nil`                      |
| `postgresqlPghbaRemoveFilters`      | Remove pg_hba.conf lines with the following comma-separated patterns                    | `nil`                      |


### Audit settings

| Name                      | Description                                           | Value   |
| ------------------------- | ----------------------------------------------------- | ------- |
| `audit.logHostname`       | Log client hostnames                                  | `false` |
| `audit.logConnections`    | Log connections to the server                         | `false` |
| `audit.logDisconnections` | Log disconnections                                    | `false` |
| `audit.pgAuditLog`        | Operation to audit using pgAudit (default if not set) | `""`    |
| `audit.pgAuditLogCatalog` | Log catalog using pgAudit                             | `off`   |
| `audit.clientMinMessages` | Log level for clients                                 | `error` |
| `audit.logLinePrefix`     | Template for log line prefix (default if not set)     | `""`    |
| `audit.logTimezone`       | Log timezone                                          | `""`    |


### LDAP configuration

| Name                 | Description                  | Value       |
| -------------------- | ---------------------------- | ----------- |
| `ldap.enabled`       | Enables LDAP                 | `false`     |
| `ldap.url`           | LDAP service url             | `""`        |
| `ldap.server`        | LDAP server                  | `""`        |
| `ldap.port`          | LDAP port                    | `""`        |
| `ldap.prefix`        | LDAP prefix                  | `""`        |
| `ldap.suffix`        | LDAP suffix                  | `""`        |
| `ldap.baseDN`        | LDAP base distinguished name | `""`        |
| `ldap.bindDN`        | LDAP bind distinguished name | `""`        |
| `ldap.bind_password` | LDAP bind password           | `nil`       |
| `ldap.search_attr`   | LDAP search attributes       | `""`        |
| `ldap.search_filter` | LDAP search filter           | `""`        |
| `ldap.scheme`        | LDAP scheme                  | `""`        |
| `ldap.tls`           | LDAP TLS configuration       | `undefined` |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                   |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `10-debian-10-r112`     |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `Always`                |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `undefined`             |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `undefined`             |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `undefined`             |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |


### ServiceAccount configuration

| Name                                          | Description                                          | Value       |
| --------------------------------------------- | ---------------------------------------------------- | ----------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created | `true`      |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.               | `""`        |
| `serviceAccount.automountServiceAccountToken` | Whether to auto mount the service account token      | `true`      |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount | `undefined` |


### TLS configuration

| Name                      | Description                                                                  | Value   |
| ------------------------- | ---------------------------------------------------------------------------- | ------- |
| `tls.enabled`             | Enable TLS traffic                                                           | `false` |
| `tls.autoGenerated`       | Enable autogenerated certificates                                            | `false` |
| `tls.preferServerCiphers` | Whether to use the server's TLS cipher preferences rather than the client's. | `true`  |
| `tls.certificatesSecret`  | Name of the Secret that contains the certificates                            | `nil`   |
| `tls.certFilename`        | Certificate filename                                                         | `nil`   |
| `tls.certKeyFilename`     | Certificate Key filename                                                     | `nil`   |
| `tls.certCAFilename`      | CA Certificate filename                                                      | `nil`   |
| `tls.crlFilename`         | File containing a Certificate Revocation List                                | `nil`   |


### Other parameters

| Name                                    | Description                                                             | Value       |
| --------------------------------------- | ----------------------------------------------------------------------- | ----------- |
| `podSecurityPolicy.create`              | Specifies whether a PodSecurityPolicy should be created                 | `false`     |
| `rbac.create`                           | Specifies whether RBAC resources should be created                      | `false`     |
| `rbac.rules`                            | Custom RBAC rules to set                                                | `undefined` |
| `shmVolume.enabled`                     | Enable to mount a new tmpfs volume to remove limitations on shm memory. | `true`      |
| `shmVolume.chmod.enabled`               | Enable to `chmod 777 /dev/shm` on a initContainer.                      | `true`      |
| `shmVolume.sizeLimit`                   | Set this to enable a size limit on the shm tmpfs.                       | `nil`       |
| `networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                              | `false`     |
| `networkPolicy.allowExternal`           | Don't require client label for connections                              | `true`      |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                            | `undefined` |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                  | `undefined` |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces              | `undefined` |


### Metrics Parameters

| Name                                         | Description                                                                                      | Value                       |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------------------- |
| `metrics.enabled`                            | Start a sidecar prometheus exporter to expose PostgreSQL metrics                                 | `false`                     |
| `metrics.image.registry`                     | PostgreSQL Exporter image registry                                                               | `docker.io`                 |
| `metrics.image.repository`                   | PostgreSQL Exporter image repository                                                             | `bitnami/postgres-exporter` |
| `metrics.image.tag`                          | PostgreSQL PostgreSQL Exporter image tag (immutable tags are recommended)                        | `0.9.0-debian-10-r102`      |
| `metrics.image.pullPolicy`                   | PostgreSQL Exporter image pull policy                                                            | `IfNotPresent`              |
| `metrics.image.pullSecrets`                  | PostgreSQL Exporter image pull secrets                                                           | `undefined`                 |
| `metrics.resources.limits`                   | The resources limits for the PostgreSQL exporter container                                       | `undefined`                 |
| `metrics.resources.requests`                 | The requested resources for the PostgreSQL exporter container                                    | `undefined`                 |
| `metrics.service.type`                       | PostgreSQL Sentinel exporter service type                                                        | `ClusterIP`                 |
| `metrics.service.loadBalancerIP`             | PostgreSQL Sentinel exporter service Load Balancer IP                                            | `nil`                       |
| `metrics.serviceMonitor.enabled`             | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator                  | `false`                     |
| `metrics.serviceMonitor.namespace`           | The namespace in which the ServiceMonitor will be created                                        | `nil`                       |
| `metrics.serviceMonitor.interval`            | The interval at which metrics should be scraped                                                  | `nil`                       |
| `metrics.serviceMonitor.scrapeTimeout`       | The timeout after which the scrape is ended                                                      | `nil`                       |
| `metrics.serviceMonitor.additionalLabels`    | Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus | `undefined`                 |
| `metrics.prometheusRule.enabled`             | Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator            | `false`                     |
| `metrics.prometheusRule.namespace`           | The namespace in which the prometheusRule will be created                                        | `nil`                       |
| `metrics.prometheusRule.additionalLabels`    | Additional labels for the prometheusRule                                                         | `undefined`                 |
| `metrics.prometheusRule.rules`               | Custom Prometheus rules                                                                          | `undefined`                 |
| `metrics.extraEnvVars`                       | An array to add extra env vars to configure postgres-exporter                                    | `undefined`                 |
| `metrics.securityContext.enabled`            | Enabled PostgreSQL metrics containers' Security Context                                          | `false`                     |
| `metrics.securityContext.runAsUser`          | Set PostgreSQL metrics containers' Security Context runAsUser                                    | `1001`                      |
| `metrics.livenessProbe.enabled`              | Enable livenessProbe on PostgreSQL metrics nodes                                                 | `true`                      |
| `metrics.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                          | `5`                         |
| `metrics.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                 | `10`                        |
| `metrics.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                | `5`                         |
| `metrics.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                              | `6`                         |
| `metrics.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                              | `1`                         |
| `metrics.readinessProbe.enabled`             | Enable readinessProbe on PostgreSQL metrics nodes                                                | `true`                      |
| `metrics.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                         | `5`                         |
| `metrics.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                | `10`                        |
| `metrics.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                               | `5`                         |
| `metrics.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                             | `6`                         |
| `metrics.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                             | `1`                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set postgresqlPassword=secretpassword,postgresqlDatabase=my-database \
    bitnami/postgresql
```

The above command sets the PostgreSQL `postgres` account password to `secretpassword`. Additionally it creates a database named `my-database`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/postgresql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Customizing primary and read replica services in a replicated configuration

At the top level, there is a service object which defines the services for both primary and readReplicas. For deeper customization, there are service objects for both the primary and read types individually. This allows you to override the values in the top level service object so that the primary and read can be of different service types and with different clusterIPs / nodePorts. Also in the case you want the primary and read to be of type nodePort, you will need to set the nodePorts to different values to prevent a collision. The values that are deeper in the primary.service or readReplicas.service objects will take precedence over the top level service object.

### Change PostgreSQL version

To modify the PostgreSQL version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/postgresql/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### postgresql.conf / pg_hba.conf files as configMap

This helm chart also supports to customize the whole configuration file.

Add your custom file to "files/postgresql.conf" in your working directory. This file will be mounted as configMap to the containers and it will be used for configuring the PostgreSQL server.

Alternatively, you can add additional PostgreSQL configuration parameters using the `postgresqlExtendedConf` parameter as a dict, using camelCase, e.g. {"sharedBuffers": "500MB"}. Alternatively, to replace the entire default configuration use `postgresqlConfiguration`.

In addition to these options, you can also set an external ConfigMap with all the configuration files. This is done by setting the `configurationConfigMap` parameter. Note that this will override the two previous options.

### Allow settings to be loaded from files other than the default `postgresql.conf`

If you don't want to provide the whole PostgreSQL configuration file and only specify certain parameters, you can add your extended `.conf` files to "files/conf.d/" in your working directory.
Those files will be mounted as configMap to the containers adding/overwriting the default configuration using the `include_dir` directive that allows settings to be loaded from files other than the default `postgresql.conf`.

Alternatively, you can also set an external ConfigMap with all the extra configuration files. This is done by setting the `extendedConfConfigMap` parameter. Note that this will override the previous option.

### Initialize a fresh instance

The [Bitnami PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

Alternatively, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to these options, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the two previous options. If your initialization scripts contain sensitive information such as credentials or passwords, you can use the `initdbScriptsSecret` parameter.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

### Securing traffic using TLS

TLS support can be enabled in the chart by specifying the `tls.` parameters while creating a release. The following parameters should be configured to properly enable the TLS support in the chart:

- `tls.enabled`: Enable TLS support. Defaults to `false`
- `tls.certificatesSecret`: Name of an existing secret that contains the certificates. No defaults.
- `tls.certFilename`: Certificate filename. No defaults.
- `tls.certKeyFilename`: Certificate key filename. No defaults.

For example:

* First, create the secret with the cetificates files:

    ```console
    kubectl create secret generic certificates-tls-secret --from-file=./cert.crt --from-file=./cert.key --from-file=./ca.crt
    ```

* Then, use the following parameters:

    ```console
    volumePermissions.enabled=true
    tls.enabled=true
    tls.certificatesSecret="certificates-tls-secret"
    tls.certFilename="cert.crt"
    tls.certKeyFilename="cert.key"
    ```

    > Note TLS and VolumePermissions: PostgreSQL requires certain permissions on sensitive files (such as certificate keys) to start up. Due to an on-going [issue](https://github.com/kubernetes/kubernetes/issues/57923) regarding kubernetes permissions and the use of `containerSecurityContext.runAsUser`, you must enable `volumePermissions` to ensure everything works as expected.

### Sidecars

If you need  additional containers to run within the same pod as PostgreSQL (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
# For the PostgreSQL primary
primary:
  sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
    - name: portname
     containerPort: 1234
# For the PostgreSQL replicas
readReplicas:
  sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
    - name: portname
     containerPort: 1234
```

### Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9187) is not exposed and it is expected that the metrics are collected from inside the k8s cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml).

The exporter allows to create custom metrics from additional SQL queries. See the Chart's `values.yaml` for an example and consult the [exporters documentation](https://github.com/wrouesnel/postgres_exporter#adding-new-metrics-via-a-config-file) for more details.

## Persistence

The [Bitnami PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) image stores the PostgreSQL data and configurations at the `/bitnami/postgresql` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

If you already have data in it, you will fail to sync to standby nodes for all commits, details can refer to [code](https://github.com/bitnami/bitnami-docker-postgresql/blob/8725fe1d7d30ebe8d9a16e9175d05f7ad9260c93/9.6/debian-9/rootfs/libpostgresql.sh#L518-L556). If you need to use those data, please covert them to sql and import after `helm install` finished.

## NetworkPolicy

To enable network policy for PostgreSQL, install [a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin), and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

```console
$ kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"
```

With NetworkPolicy enabled, traffic will be limited to just port 5432.

For more precise policy, set `networkPolicy.allowExternal=false`. This will only allow pods with the generated client label to connect to PostgreSQL.
This label will be displayed in the output of a successful install.

## Differences between Bitnami PostgreSQL image and [Docker Official](https://hub.docker.com/_/postgres) image

- The Docker Official PostgreSQL image does not support replication. If you pass any replication environment variable, this would be ignored. The only environment variables supported by the Docker Official image are POSTGRES_USER, POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_INITDB_ARGS, POSTGRES_INITDB_WALDIR and PGDATA. All the remaining environment variables are specific to the Bitnami PostgreSQL image.
- The Bitnami PostgreSQL image is non-root by default. This requires that you run the pod with `securityContext` and updates the permissions of the volume with an `initContainer`. A key benefit of this configuration is that the pod follows security best practices and is prepared to run on Kubernetes distributions with hard security constraints like OpenShift.
- For OpenShift, one may either define the runAsUser and fsGroup accordingly, or try this more dynamic option: volumePermissions.securityContext.runAsUser="auto",securityContext.enabled=false,containerSecurityContext.enabled=false,shmVolume.chmod.enabled=false

### Deploy chart using Docker Official PostgreSQL Image

From chart version 4.0.0, it is possible to use this chart with the Docker Official PostgreSQL image.
Besides specifying the new Docker repository and tag, it is important to modify the PostgreSQL data directory and volume mount point. Basically, the PostgreSQL data dir cannot be the mount point directly, it has to be a subdirectory.

```
image.repository=postgres
image.tag=10.6
postgresqlDataDir=/data/pgdata
primary.persistence.mountPath=/data/
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` paremeter(s). Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to specify the existing passwords while performing an upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `auth.password` and `auth.replicationPassword` parameters when upgrading the chart:

```bash
$ helm upgrade my-release bitnami/postgresql \
    --set auth.password=[POSTGRESQL_PASSWORD] \
    --set auth.replicationPassword=[REPLICATION_PASSWORD]
```

> Note: you need to substitute the placeholders _[POSTGRESQL_PASSWORD]_, and _[REPLICATION_PASSWORD]_ with the values obtained from instructions in the installation notes.

### To 11.0.0

This version updates PostgreSQL to its major version 13 and performs a series of additional breaking changes. In this version, the **chart is using PostgreSQL 13 instead of PostgreSQL 11**. You can check both PostgreSQL 12 and 13 releases notes and notable changes in the following links:

- PostgreSQL 12: [https://www.postgresql.org/docs/12/release-12.html](https://www.postgresql.org/docs/12/release-12.html)
- PostgreSQL 13: [https://www.postgresql.org/docs/13/release-13.html](https://www.postgresql.org/docs/13/release-13.html)
- PostgreSQL's feature matrix: [https://www.postgresql.org/about/featurematrix/](https://www.postgresql.org/about/featurematrix/)

For major releases of PostgreSQL, the internal data storage format is subject to change, thus complicating upgrades, you can see some errors like the following one in the logs:

```console
Welcome to the Bitnami postgresql container
Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-postgresql
Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-postgresql/issues
INFO  ==> ** Starting PostgreSQL setup **
INFO  ==> Validating settings in POSTGRESQL_* env vars..
INFO  ==> Loading custom pre-init scripts...
INFO  ==> Initializing PostgreSQL database...
INFO  ==> pg_hba.conf file not detected. Generating it...
INFO  ==> Generating local authentication configuration
INFO  ==> Deploying PostgreSQL with persisted data...
INFO  ==> Configuring replication parameters
INFO  ==> Configuring fsync
INFO  ==> Loading custom scripts...
INFO  ==> Enabling remote connections
INFO  ==> ** PostgreSQL setup finished! **
INFO  ==> ** Starting PostgreSQL **
 GMT [1] FATAL:  database files are incompatible with server
 GMT [1] DETAIL:  The data directory was initialized by PostgreSQL version 11, which is not compatible with this version 13.3.
```
In this case, you should migrate the data from the old chart to the new one following an approach similar to that described in [this section](https://www.postgresql.org/docs/current/upgrading.html#UPGRADING-VIA-PGDUMPALL) from the official documentation. As an overview, the process entails creating a database dump in the old chart, moving it to the new chart version's pod, and restoring it in there.

Given that `helm upgrade` can't be used for this chart major, we have introduced a series of additional breaking changes:

- Refactored [authentication configuration](#authentication-configuration), now under `auth.XXX`.
- Now using the `architecture` parameter to configure `standalone/replication` chart architecture.
- Removed `service.XXX`, making `primary.service.XXX` and `readReplicas.service.XXX` the default ones.
- Moved PostgreSQL pods probes under `primary.XXX` and `readReplicas.XXX`.
- Moved `replication.XXX` parameters under `readReplicas.XXX`.
- Removed `global.postgresql` parameters.

### To 10.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Chart.

**Considerations when upgrading to this version**

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

#### Breaking changes

- The term `master` has been replaced with `primary` and `slave` with `readReplicas` throughout the chart. Role names have changed from `master` and `slave` to `primary` and `read`.

To upgrade to `10.0.0`, it should be done reusing the PVCs used to hold the PostgreSQL data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `postgresql`):

> NOTE: Please, create a backup of your database before running any of those actions.

Obtain the credentials and the names of the PVCs used to hold the PostgreSQL data on your current release:

```console
$ export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
$ export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")
```

Delete the PostgreSQL statefulset. Notice the option `--cascade=false`:

```console
$ kubectl delete statefulsets.apps postgresql-postgresql --cascade=false
```

Now the upgrade works:

```console
$ helm upgrade postgresql bitnami/postgresql --set postgresqlPassword=$POSTGRESQL_PASSWORD --set persistence.existingClaim=$POSTGRESQL_PVC
```

You will have to delete the existing PostgreSQL pod and the new statefulset is going to create a new one

```console
$ kubectl delete pod postgresql-postgresql-0
```

Finally, you should see the lines below in PostgreSQL container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=postgresql,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
...
postgresql 08:05:12.59 INFO  ==> Deploying PostgreSQL with persisted data...
...
```

### To 9.0.0

In this version the chart was adapted to follow the Helm label best practices, see [PR 3021](https://github.com/bitnami/charts/pull/3021). That means the backward compatibility is not guarantee when upgrading the chart to this major version.

As a workaround, you can delete the existing statefulset (using the `--cascade=false` flag pods are not deleted) before upgrade the chart. For example, this can be a valid workflow:

- Deploy an old version (8.X.X)

```console
$ helm install postgresql bitnami/postgresql --version 8.10.14
```

- Old version is up and running

```console
$ helm ls
NAME      	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART             	APP VERSION
postgresql	default  	1       	2020-08-04 13:39:54.783480286 +0000 UTC	deployed	postgresql-8.10.14	11.8.0

$ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
postgresql-postgresql-0   1/1     Running   0          76s
```

- The upgrade to the latest one (9.X.X) is going to fail

```console
$ helm upgrade postgresql bitnami/postgresql
Error: UPGRADE FAILED: cannot patch "postgresql-postgresql" with kind StatefulSet: StatefulSet.apps "postgresql-postgresql" is invalid: spec: Forbidden: updates to statefulset spec for fields other than 'replicas', 'template', and 'updateStrategy' are forbidden
```

- Delete the statefulset

```console
$ kubectl delete statefulsets.apps --cascade=false postgresql-postgresql
statefulset.apps "postgresql-postgresql" deleted
```

- Now the upgrade works

```console
$ helm upgrade postgresql bitnami/postgresql
$ helm ls
NAME      	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART           	APP VERSION
postgresql	default  	3       	2020-08-04 13:42:08.020385884 +0000 UTC	deployed	postgresql-9.1.2	11.8.0
```

- We can kill the existing pod and the new statefulset is going to create a new one:

```console
$ kubectl delete pod postgresql-postgresql-0
pod "postgresql-postgresql-0" deleted

$ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
postgresql-postgresql-0   1/1     Running   0          19s
```

Please, note that without the `--cascade=false` both objects (statefulset and pod) are going to be removed and both objects will be deployed again with the `helm upgrade` command

### To 8.0.0

Prefixes the port names with their protocols to comply with Istio conventions.

If you depend on the port names in your setup, make sure to update them to reflect this change.

### To 7.1.0

Adds support for LDAP configuration.

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17281 the `apiVersion` of the statefulset resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version bump signifies this change.

### To 6.5.7

In this version, the chart will use PostgreSQL with the Postgis extension included. The version used with Postgresql version 10, 11 and 12 is Postgis 2.5. It has been compiled with the following dependencies:

- protobuf
- protobuf-c
- json-c
- geos
- proj

### To 5.0.0

In this version, the **chart is using PostgreSQL 11 instead of PostgreSQL 10**. You can find the main difference and notable changes in the following links: [https://www.postgresql.org/about/news/1894/](https://www.postgresql.org/about/news/1894/) and [https://www.postgresql.org/about/featurematrix/](https://www.postgresql.org/about/featurematrix/).

For major releases of PostgreSQL, the internal data storage format is subject to change, thus complicating upgrades, you can see some errors like the following one in the logs:

```console
Welcome to the Bitnami postgresql container
Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-postgresql
Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-postgresql/issues
Send us your feedback at containers@bitnami.com

INFO  ==> ** Starting PostgreSQL setup **
NFO  ==> Validating settings in POSTGRESQL_* env vars..
INFO  ==> Initializing PostgreSQL database...
INFO  ==> postgresql.conf file not detected. Generating it...
INFO  ==> pg_hba.conf file not detected. Generating it...
INFO  ==> Deploying PostgreSQL with persisted data...
INFO  ==> Configuring replication parameters
INFO  ==> Loading custom scripts...
INFO  ==> Enabling remote connections
INFO  ==> Stopping PostgreSQL...
INFO  ==> ** PostgreSQL setup finished! **

INFO  ==> ** Starting PostgreSQL **
  [1] FATAL:  database files are incompatible with server
  [1] DETAIL:  The data directory was initialized by PostgreSQL version 10, which is not compatible with this version 11.3.
```

In this case, you should migrate the data from the old chart to the new one following an approach similar to that described in [this section](https://www.postgresql.org/docs/current/upgrading.html#UPGRADING-VIA-PGDUMPALL) from the official documentation. Basically, create a database dump in the old chart, move and restore it in the new one.

### To 4.0.0

This chart will use by default the Bitnami PostgreSQL container starting from version `10.7.0-r68`. This version moves the initialization logic from node.js to bash. This new version of the chart requires setting the `POSTGRES_PASSWORD` in the slaves as well, in order to properly configure the `pg_hba.conf` file. Users from previous versions of the chart are advised to upgrade immediately.

IMPORTANT: If you do not want to upgrade the chart version then make sure you use the `10.7.0-r68` version of the container. Otherwise, you will get this error

```
The POSTGRESQL_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development
```

### To 3.0.0

This releases make it possible to specify different nodeSelector, affinity and tolerations for master and slave pods.
It also fixes an issue with `postgresql.master.fullname` helper template not obeying fullnameOverride.

#### Breaking changes

- `affinty` has been renamed to `master.affinity` and `slave.affinity`.
- `tolerations` has been renamed to `master.tolerations` and `slave.tolerations`.
- `nodeSelector` has been renamed to `master.nodeSelector` and `slave.nodeSelector`.

### To 2.0.0

In order to upgrade from the `0.X.X` branch to `1.X.X`, you should follow the below steps:

- Obtain the service name (`SERVICE_NAME`) and password (`OLD_PASSWORD`) of the existing postgresql chart. You can find the instructions to obtain the password in the NOTES.txt, the service name can be obtained by running

```console
$ kubectl get svc
```

- Install (not upgrade) the new version

```console
$ helm repo update
$ helm install my-release bitnami/postgresql
```

- Connect to the new pod (you can obtain the name by running `kubectl get pods`):

```console
$ kubectl exec -it NAME bash
```

- Once logged in, create a dump file from the previous database using `pg_dump`, for that we should connect to the previous postgresql chart:

```console
$ pg_dump -h SERVICE_NAME -U postgres DATABASE_NAME > /tmp/backup.sql
```

After run above command you should be prompted for a password, this password is the previous chart password (`OLD_PASSWORD`).
This operation could take some time depending on the database size.

- Once you have the backup file, you can restore it with a command like the one below:

```console
$ psql -U postgres DATABASE_NAME < /tmp/backup.sql
```

In this case, you are accessing to the local postgresql, so the password should be the new one (you can find it in NOTES.txt).

If you want to restore the database and the database schema does not exist, it is necessary to first follow the steps described below.

```console
$ psql -U postgres
postgres=# drop database DATABASE_NAME;
postgres=# create database DATABASE_NAME;
postgres=# create user USER_NAME;
postgres=# alter role USER_NAME with password 'BITNAMI_USER_PASSWORD';
postgres=# grant all privileges on database DATABASE_NAME to USER_NAME;
postgres=# alter database DATABASE_NAME owner to USER_NAME;
```
