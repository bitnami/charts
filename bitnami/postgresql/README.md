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
- Helm 3.0-beta3+
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

The following tables lists the configurable parameters of the PostgreSQL chart and their default values.

| Parameter                                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Default                                                       |
|-----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| `global.imageRegistry`                        | Global Docker Image registry                                                                                                                                                                                                                                                                                                                                                                                                                                               | `nil`                                                         |
| `global.postgresql.postgresqlDatabase`        | PostgreSQL database (overrides `postgresqlDatabase`)                                                                                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `global.postgresql.postgresqlUsername`        | PostgreSQL username (overrides `postgresqlUsername`)                                                                                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `global.postgresql.existingSecret`            | Name of existing secret to use for PostgreSQL passwords (overrides `existingSecret`)                                                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `global.postgresql.postgresqlPassword`        | PostgreSQL admin password (overrides `postgresqlPassword`)                                                                                                                                                                                                                                                                                                                                                                                                                 | `nil`                                                         |
| `global.postgresql.servicePort`               | PostgreSQL port (overrides `service.port`)                                                                                                                                                                                                                                                                                                                                                                                                                                 | `nil`                                                         |
| `global.postgresql.replicationPassword`       | Replication user password (overrides `replication.password`)                                                                                                                                                                                                                                                                                                                                                                                                               | `nil`                                                         |
| `global.imagePullSecrets`                     | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                                                                                                                            | `[]` (does not add image pull secrets to deployed pods)       |
| `global.storageClass`                         | Global storage class for dynamic provisioning                                                                                                                                                                                                                                                                                                                                                                                                                              | `nil`                                                         |
| `image.registry`                              | PostgreSQL Image registry                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `docker.io`                                                   |
| `image.repository`                            | PostgreSQL Image name                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `bitnami/postgresql`                                          |
| `image.tag`                                   | PostgreSQL Image tag                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `{TAG_NAME}`                                                  |
| `image.pullPolicy`                            | PostgreSQL Image pull policy                                                                                                                                                                                                                                                                                                                                                                                                                                               | `IfNotPresent`                                                |
| `image.pullSecrets`                           | Specify Image pull secrets                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `nil` (does not add image pull secrets to deployed pods)      |
| `image.debug`                                 | Specify if debug values should be set                                                                                                                                                                                                                                                                                                                                                                                                                                      | `false`                                                       |
| `nameOverride`                                | String to partially override common.names.fullname template with a string (will prepend the release name)                                                                                                                                                                                                                                                                                                                                                                    | `nil`                                                         |
| `fullnameOverride`                            | String to fully override common.names.fullname template with a string                                                                                                                                                                                                                                                                                                                                                                                                        | `nil`                                                         |
| `volumePermissions.enabled`                   | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                                                                                                                                                                                                                                                  | `false`                                                       |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                                                                                                                                                                                                                                                                                                                                                                           | `docker.io`                                                   |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                                                                                                                                                                                                                                                                                                                                                                               | `bitnami/minideb`                                             |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                                                                                                                                                                                                                                                                                                                                                                                | `buster`                                                      |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                                                                                                                                                                                                                                                                                                                                                                        | `Always`                                                      |
| `volumePermissions.securityContext.*`         | Other container security context to be included as-is in the container spec                                                                                                                                                                                                                                                                                                                                                                                                | `{}`                                                          |
| `volumePermissions.securityContext.runAsUser` | User ID for the init container (when facing issues in OpenShift or uid unknown, try value "auto")                                                                                                                                                                                                                                                                                                                                                                          | `0`                                                           |
| `usePasswordFile`                             | Have the secrets mounted as a file instead of env vars                                                                                                                                                                                                                                                                                                                                                                                                                     | `false`                                                       |
| `ldap.enabled`                                | Enable LDAP support                                                                                                                                                                                                                                                                                                                                                                                                                                                        | `false`                                                       |
| `ldap.existingSecret`                         | Name of existing secret to use for LDAP passwords                                                                                                                                                                                                                                                                                                                                                                                                                          | `nil`                                                         |
| `ldap.url`                                    | LDAP URL beginning in the form `ldap[s]://host[:port]/basedn[?[attribute][?[scope][?[filter]]]]`                                                                                                                                                                                                                                                                                                                                                                           | `nil`                                                         |
| `ldap.server`                                 | IP address or name of the LDAP server.                                                                                                                                                                                                                                                                                                                                                                                                                                     | `nil`                                                         |
| `ldap.port`                                   | Port number on the LDAP server to connect to                                                                                                                                                                                                                                                                                                                                                                                                                               | `nil`                                                         |
| `ldap.scheme`                                 | Set to `ldaps` to use LDAPS.                                                                                                                                                                                                                                                                                                                                                                                                                                               | `nil`                                                         |
| `ldap.tls`                                    | Set to `1` to use TLS encryption                                                                                                                                                                                                                                                                                                                                                                                                                                           | `nil`                                                         |
| `ldap.prefix`                                 | String to prepend to the user name when forming the DN to bind                                                                                                                                                                                                                                                                                                                                                                                                             | `nil`                                                         |
| `ldap.suffix`                                 | String to append to the user name when forming the DN to bind                                                                                                                                                                                                                                                                                                                                                                                                              | `nil`                                                         |
| `ldap.search_attr`                            | Attribute to match against the user name in the search                                                                                                                                                                                                                                                                                                                                                                                                                      | `nil`                                                         |
| `ldap.search_filter`                          | The search filter to use when doing search+bind authentication                                                                                                                                                                                                                                                                                                                                                                                                             | `nil`                                                         |
| `ldap.baseDN`                                 | Root DN to begin the search for the user in                                                                                                                                                                                                                                                                                                                                                                                                                                | `nil`                                                         |
| `ldap.bindDN`                                 | DN of user to bind to LDAP                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `nil`                                                         |
| `ldap.bind_password`                          | Password for the user to bind to LDAP                                                                                                                                                                                                                                                                                                                                                                                                                                      | `nil`                                                         |
| `replication.enabled`                         | Enable replication                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `false`                                                       |
| `replication.user`                            | Replication user                                                                                                                                                                                                                                                                                                                                                                                                                                                           | `repl_user`                                                   |
| `replication.password`                        | Replication user password                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `repl_password`                                               |
| `replication.readReplicas`                   | Number of read replicas replicas                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `1`                                                           |
| `replication.synchronousCommit`               | Set synchronous commit mode. Allowed values: `on`, `remote_apply`, `remote_write`, `local` and `off`                                                                                                                                                                                                                                                                                                                                                                       | `off`                                                         |
| `replication.numSynchronousReplicas`          | Number of replicas that will have synchronous replication. Note: Cannot be greater than `replication.readReplicas`.                                                                                                                                                                                                                                                                                                                                                       | `0`                                                           |
| `replication.applicationName`                 | Cluster application name. Useful for advanced replication settings                                                                                                                                                                                                                                                                                                                                                                                                         | `my_application`                                              |
| `existingSecret`                              | Name of existing secret to use for PostgreSQL passwords. The secret has to contain the keys `postgresql-password` which is the password for `postgresqlUsername` when it is different of `postgres`, `postgresql-postgres-password` which will override `postgresqlPassword`, `postgresql-replication-password` which will override `replication.password` and `postgresql-ldap-password` which will be sed to authenticate on LDAP. The value is evaluated as a template. | `nil`                                                         |
| `postgresqlPostgresPassword`                  | PostgreSQL admin password (used when `postgresqlUsername` is not `postgres`, in which case`postgres` is the admin username).                                                                                                                                                                                                                                                                                                                                               | _random 10 character alphanumeric string_                     |
| `postgresqlUsername`                          | PostgreSQL user (creates a non-admin user when `postgresqlUsername` is not `postgres`)                                                                                                                                                                                                                                                                                                                                                                                     | `postgres`                                                    |
| `postgresqlPassword`                          | PostgreSQL user password                                                                                                                                                                                                                                                                                                                                                                                                                                                   | _random 10 character alphanumeric string_                     |
| `postgresqlDatabase`                          | PostgreSQL database                                                                                                                                                                                                                                                                                                                                                                                                                                                        | `nil`                                                         |
| `postgresqlDataDir`                           | PostgreSQL data dir folder                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `/bitnami/postgresql` (same value as persistence.mountPath)   |
| `extraEnv`                                    | Any extra environment variables you would like to pass on to the pod. The value is evaluated as a template.                                                                                                                                                                                                                                                                                                                                                                | `[]`                                                          |
| `extraEnvVarsCM`                              | Name of a Config Map containing extra environment variables you would like to pass on to the pod. The value is evaluated as a template.                                                                                                                                                                                                                                                                                                                                    | `nil`                                                         |
| `postgresqlInitdbArgs`                        | PostgreSQL initdb extra arguments                                                                                                                                                                                                                                                                                                                                                                                                                                          | `nil`                                                         |
| `postgresqlInitdbWalDir`                      | PostgreSQL location for transaction log                                                                                                                                                                                                                                                                                                                                                                                                                                    | `nil`                                                         |
| `postgresqlConfiguration`                     | Runtime Config Parameters                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `nil`                                                         |
| `postgresqlExtendedConf`                      | Extended Runtime Config Parameters (appended to main or default configuration)                                                                                                                                                                                                                                                                                                                                                                                             | `nil`                                                         |
| `pgHbaConfiguration`                          | Content of pg_hba.conf                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `nil (do not create pg_hba.conf)`                             |
| `postgresqlSharedPreloadLibraries`            | Shared preload libraries (comma-separated list)                                                                                                                                                                                                                                                                                                                                                                                                                            | `pgaudit`                                                     |
| `postgresqlMaxConnections`                    | Maximum total connections                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `nil`                                                         |
| `postgresqlPostgresConnectionLimit`           | Maximum total connections for the postgres user                                                                                                                                                                                                                                                                                                                                                                                                                            | `nil`                                                         |
| `postgresqlDbUserConnectionLimit`             | Maximum total connections for the non-admin user                                                                                                                                                                                                                                                                                                                                                                                                                           | `nil`                                                         |
| `postgresqlTcpKeepalivesInterval`             | TCP keepalives interval                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `nil`                                                         |
| `postgresqlTcpKeepalivesIdle`                 | TCP keepalives idle                                                                                                                                                                                                                                                                                                                                                                                                                                                        | `nil`                                                         |
| `postgresqlTcpKeepalivesCount`                | TCP keepalives count                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `postgresqlStatementTimeout`                  | Statement timeout                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `nil`                                                         |
| `postgresqlPghbaRemoveFilters`                | Comma-separated list of patterns to remove from the pg_hba.conf file                                                                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `customLivenessProbe`                         | Override default liveness probe                                                                                                                                                                                                                                                                                                                                                                                                                                            | `nil`                                                         |
| `customReadinessProbe`                        | Override default readiness probe                                                                                                                                                                                                                                                                                                                                                                                                                                           | `nil`                                                         |
| `audit.logHostname`                           | Add client hostnames to the log file                                                                                                                                                                                                                                                                                                                                                                                                                                       | `false`                                                       |
| `audit.logConnections`                        | Add client log-in operations to the log file                                                                                                                                                                                                                                                                                                                                                                                                                               | `false`                                                       |
| `audit.logDisconnections`                     | Add client log-outs operations to the log file                                                                                                                                                                                                                                                                                                                                                                                                                             | `false`                                                       |
| `audit.pgAuditLog`                            | Add operations to log using the pgAudit extension                                                                                                                                                                                                                                                                                                                                                                                                                          | `nil`                                                         |
| `audit.clientMinMessages`                     | Message log level to share with the user                                                                                                                                                                                                                                                                                                                                                                                                                                   | `nil`                                                         |
| `audit.logLinePrefix`                         | Template string for the log line prefix                                                                                                                                                                                                                                                                                                                                                                                                                                    | `nil`                                                         |
| `audit.logTimezone`                           | Timezone for the log timestamps                                                                                                                                                                                                                                                                                                                                                                                                                                            | `nil`                                                         |
| `configurationConfigMap`                      | ConfigMap with the PostgreSQL configuration files (Note: Overrides `postgresqlConfiguration` and `pgHbaConfiguration`). The value is evaluated as a template.                                                                                                                                                                                                                                                                                                              | `nil`                                                         |
| `extendedConfConfigMap`                       | ConfigMap with the extended PostgreSQL configuration files. The value is evaluated as a template.                                                                                                                                                                                                                                                                                                                                                                          | `nil`                                                         |
| `initdbScripts`                               | Dictionary of initdb scripts                                                                                                                                                                                                                                                                                                                                                                                                                                               | `nil`                                                         |
| `initdbUser`                                  | PostgreSQL user to execute the .sql and sql.gz scripts                                                                                                                                                                                                                                                                                                                                                                                                                     | `nil`                                                         |
| `initdbPassword`                              | Password for the user specified in `initdbUser`                                                                                                                                                                                                                                                                                                                                                                                                                            | `nil`                                                         |
| `initdbScriptsConfigMap`                      | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`). The value is evaluated as a template.                                                                                                                                                                                                                                                                                                                                                                 | `nil`                                                         |
| `initdbScriptsSecret`                         | Secret with initdb scripts that contain sensitive information (Note: can be used with `initdbScriptsConfigMap` or `initdbScripts`). The value is evaluated as a template.                                                                                                                                                                                                                                                                                                  | `nil`                                                         |
| `service.type`                                | Kubernetes Service type                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `ClusterIP`                                                   |
| `service.port`                                | PostgreSQL port                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `5432`                                                        |
| `service.nodePort`                            | Kubernetes Service nodePort                                                                                                                                                                                                                                                                                                                                                                                                                                                | `nil`                                                         |
| `service.annotations`                         | Annotations for PostgreSQL service                                                                                                                                                                                                                                                                                                                                                                                                                                         | `{}` (evaluated as a template)                                |
| `service.loadBalancerIP`                      | loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                                                                                                                                                                                                                                                                           | `nil`                                                         |
| `service.loadBalancerSourceRanges`            | Address that are allowed when svc is LoadBalancer                                                                                                                                                                                                                                                                                                                                                                                                                          | `[]` (evaluated as a template)                                |
| `schedulerName`                               | Name of the k8s scheduler (other than default)                                                                                                                                                                                                                                                                                                                                                                                                                             | `nil`                                                         |
| `shmVolume.enabled`                           | Enable emptyDir volume for /dev/shm for primary and read replica(s) Pod(s)                                                                                                                                                                                                                                                                                                                                                                                                         | `true`                                                        |
| `shmVolume.chmod.enabled`                     | Run at init chmod 777 of the /dev/shm (ignored if `volumePermissions.enabled` is `false`)                                                                                                                                                                                                                                                                                                                                                                                  | `true`                                                        |
| `persistence.enabled`                         | Enable persistence using PVC                                                                                                                                                                                                                                                                                                                                                                                                                                               | `true`                                                        |
| `persistence.existingClaim`                   | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template.                                                                                                                                                                                                                                                                                                                                                                                         | `nil`                                                         |
| `persistence.mountPath`                       | Path to mount the volume at                                                                                                                                                                                                                                                                                                                                                                                                                                                | `/bitnami/postgresql`                                         |
| `persistence.subPath`                         | Subdirectory of the volume to mount at                                                                                                                                                                                                                                                                                                                                                                                                                                     | `""`                                                          |
| `persistence.storageClass`                    | PVC Storage Class for PostgreSQL volume                                                                                                                                                                                                                                                                                                                                                                                                                                    | `nil`                                                         |
| `persistence.accessModes`                     | PVC Access Mode for PostgreSQL volume                                                                                                                                                                                                                                                                                                                                                                                                                                      | `[ReadWriteOnce]`                                             |
| `persistence.size`                            | PVC Storage Request for PostgreSQL volume                                                                                                                                                                                                                                                                                                                                                                                                                                  | `8Gi`                                                         |
| `persistence.annotations`                     | Annotations for the PVC                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `{}`                                                          |
| `persistence.selector`                        | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                                                                                                                                                                                                                                                                                                                                                                    | `{}`                                                          |
| `commonAnnotations`                           | Annotations to be added to all deployed resources (rendered as a template)                                                                                                                                                                                                                                                                                                                                                                                                 | `{}`                                                          |
| `primary.podAffinityPreset`                  | PostgreSQL primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`            | `""`                                                         |
| `primary.podAntiAffinityPreset`              | PostgreSQL primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`       | `soft`                                                       |
| `primary.nodeAffinityPreset.type`            | PostgreSQL primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`      | `""`                                                         |
| `primary.nodeAffinityPreset.key`             | PostgreSQL primary node label key to match Ignored if `primary.affinity` is set.                                          | `""`                                                         |
| `primary.nodeAffinityPreset.values`          | PostgreSQL primary node label values to match. Ignored if `primary.affinity` is set.                                      | `[]`                                                         |
| `primary.affinity`                           | Affinity for PostgreSQL primary pods assignment                                                                           | `{}` (evaluated as a template)                               |
| `primary.nodeSelector`                       | Node labels for PostgreSQL primary pods assignment                                                                        | `{}` (evaluated as a template)                               |
| `primary.tolerations`                        | Tolerations for PostgreSQL primary pods assignment                                                                        | `[]` (evaluated as a template)                               |

| `primary.anotations`                           | Map of annotations to add to the statefulset (postgresql primary)                                                                                                                                                                                                                                                                                                                                                                                                           | `{}`                                                          |
| `primary.labels`                               | Map of labels to add to the statefulset (postgresql primary)                                                                                                                                                                                                                                                                                                                                                                                                                | `{}`                                                          |
| `primary.podAnnotations`                       | Map of annotations to add to the pods (postgresql primary)                                                                                                                                                                                                                                                                                                                                                                                                                  | `{}`                                                          |
| `primary.podLabels`                            | Map of labels to add to the pods (postgresql primary)                                                                                                                                                                                                                                                                                                                                                                                                                       | `{}`                                                          |
| `primary.priorityClassName`                    | Priority Class to use for each pod (postgresql primary)                                                                                                                                                                                                                                                                                                                                                                                                                     | `nil`                                                         |
| `primary.extraInitContainers`                  | Additional init containers to add to the pods (postgresql primary)                                                                                                                                                                                                                                                                                                                                                                                                          | `[]`                                                          |
| `primary.extraVolumeMounts`                    | Additional volume mounts to add to the pods (postgresql primary)                                                                                                                                                                                                                                                                                                                                                                                                            | `[]`                                                          |
| `primary.extraVolumes`                         | Additional volumes to add to the pods (postgresql primary)                                                                                                                                                                                                                                                                                                                                                                                                                  | `[]`                                                          |
| `primary.sidecars`                             | Add additional containers to the pod                                                                                                                                                                                                                                                                                                                                                                                                                                       | `[]`                                                          |
| `primary.service.type`                         | Allows using a different service type for primary                                                                                                                                                                                                                                                                                                                                                                                                                           | `nil`                                                         |
| `primary.service.nodePort`                     | Allows using a different nodePort for primary                                                                                                                                                                                                                                                                                                                                                                                                                               | `nil`                                                         |
| `primary.service.clusterIP`                    | Allows using a different clusterIP for primary                                                                                                                                                                                                                                                                                                                                                                                                                              | `nil`                                                         |
| `primaryAsStandBy.enabled`                     | Whether to enable current cluster's primary as standby server of another cluster or not.                                                                                                                                                                                                                                                                                                                                                                                    | `false`                                                       |
| `primaryAsStandBy.primaryHost`                  | The Host of replication primary in the other cluster.                                                                                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `primaryAsStandBy.primaryPort `                 | The Port of replication primary in the other cluster.                                                                                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `readReplicas.podAffinityPreset`                  | PostgreSQL read only pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`            | `""`                                                         |
| `readReplicas.podAntiAffinityPreset`              | PostgreSQL read only pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`       | `soft`                                                       |
| `readReplicas.nodeAffinityPreset.type`            | PostgreSQL read only node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`      | `""`                                                         |
| `readReplicas.nodeAffinityPreset.key`             | PostgreSQL read only node label key to match Ignored if `primary.affinity` is set.                                          | `""`                                                         |
| `readReplicas.nodeAffinityPreset.values`          | PostgreSQL read only node label values to match. Ignored if `primary.affinity` is set.                                      | `[]`                                                         |
| `readReplicas.affinity`                           | Affinity for PostgreSQL read only pods assignment                                                                           | `{}` (evaluated as a template)                               |
| `readReplicas.nodeSelector`                       | Node labels for PostgreSQL read only pods assignment                                                                        | `{}` (evaluated as a template)                               |
| `readReplicas.anotations`                            | Map of annotations to add to the statefulsets (postgresql readReplicas)                                                                                                                                                                                                                                                                                                                                                                                                           | `{}`                                                          |
| `readReplicas.resources`                             | CPU/Memory resource requests/limits override for readReplicass. Will fallback to `values.resources` if not defined.                                                                                                                                                                                                                                                                                                                                                               | `{}`                                                          |
| `readReplicas.labels`                                | Map of labels to add to the statefulsets (postgresql readReplicas)                                                                                                                                                                                                                                                                                                                                                                                                                | `{}`                                                          |
| `readReplicas.podAnnotations`                        | Map of annotations to add to the pods (postgresql readReplicas)                                                                                                                                                                                                                                                                                                                                                                                                                   | `{}`                                                          |
| `readReplicas.podLabels`                             | Map of labels to add to the pods (postgresql readReplicas)                                                                                                                                                                                                                                                                                                                                                                                                                        | `{}`                                                          |
| `readReplicas.priorityClassName`                     | Priority Class to use for each pod (postgresql readReplicas)                                                                                                                                                                                                                                                                                                                                                                                                                      | `nil`                                                         |
| `readReplicas.extraInitContainers`                   | Additional init containers to add to the pods (postgresql readReplicas)                                                                                                                                                                                                                                                                                                                                                                                                           | `[]`                                                          |
| `readReplicas.extraVolumeMounts`                     | Additional volume mounts to add to the pods (postgresql readReplicas)                                                                                                                                                                                                                                                                                                                                                                                                             | `[]`                                                          |
| `readReplicas.extraVolumes`                          | Additional volumes to add to the pods (postgresql readReplicas)                                                                                                                                                                                                                                                                                                                                                                                                                   | `[]`                                                          |
| `readReplicas.sidecars`                              | Add additional containers to the pod                                                                                                                                                                                                                                                                                                                                                                                                                                       | `[]`                                                          |
| `readReplicas.service.type`                          | Allows using a different service type for readReplicas                                                                                                                                                                                                                                                                                                                                                                                                                            | `nil`                                                         |
| `readReplicas.service.nodePort`                      | Allows using a different nodePort for readReplicas                                                                                                                                                                                                                                                                                                                                                                                                                                | `nil`                                                         |
| `readReplicas.service.clusterIP`                     | Allows using a different clusterIP for readReplicas                                                                                                                                                                                                                                                                                                                                                                                                                               | `nil`                                                         |
| `readReplicas.persistence.enabled`                   | Whether to enable readReplicas replicas persistence                                                                                                                                                                                                                                                                                                                                                                                                                               | `true`                                                        |
| `terminationGracePeriodSeconds`               | Seconds the pod needs to terminate gracefully                                                                                                                                                                                                                                                                                                                                                                                                                              | `nil`                                                         |
| `resources`                                   | CPU/Memory resource requests/limits                                                                                                                                                                                                                                                                                                                                                                                                                                        | Memory: `256Mi`, CPU: `250m`                                  |
| `securityContext.*`                           | Other pod security context to be included as-is in the pod spec                                                                                                                                                                                                                                                                                                                                                                                                            | `{}`                                                          |
| `securityContext.enabled`                     | Enable security context                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `true`                                                        |
| `securityContext.fsGroup`                     | Group ID for the pod                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `1001`                                                        |
| `containerSecurityContext.*`                  | Other container security context to be included as-is in the container spec                                                                                                                                                                                                                                                                                                                                                                                                | `{}`                                                          |
| `containerSecurityContext.enabled`            | Enable container security context                                                                                                                                                                                                                                                                                                                                                                                                                                          | `true`                                                        |
| `containerSecurityContext.runAsUser`          | User ID for the container                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `1001`                                                        |
| `serviceAccount.enabled`                      | Enable service account (Note: Service Account will only be automatically created if `serviceAccount.name` is not set)                                                                                                                                                                                                                                                                                                                                                      | `false`                                                       |
| `serviceAccount.name`                         | Name of existing service account                                                                                                                                                                                                                                                                                                                                                                                                                                           | `nil`                                                         |
| `livenessProbe.enabled`                       | Would you like a livenessProbe to be enabled                                                                                                                                                                                                                                                                                                                                                                                                                               | `true`                                                        |
| `networkPolicy.enabled`                       | Enable NetworkPolicy                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `false`                                                       |
| `networkPolicy.allowExternal`                 | Don't require client label for connections                                                                                                                                                                                                                                                                                                                                                                                                                                 | `true`                                                        |
| `networkPolicy.explicitNamespacesSelector`    | A Kubernetes LabelSelector to explicitly select namespaces from which ingress traffic could be allowed                                                                                                                                                                                                                                                                                                                                                                     | `{}`                                                          |
| `livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated                                                                                                                                                                                                                                                                                                                                                                                                                                   | 30                                                            |
| `livenessProbe.periodSeconds`                 | How often to perform the probe                                                                                                                                                                                                                                                                                                                                                                                                                                             | 10                                                            |
| `livenessProbe.timeoutSeconds`                | When the probe times out                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 5                                                             |
| `livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                                                                                                                                                                                                                                                 | 6                                                             |
| `livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                                                                                                                                                                                                                                                                                | 1                                                             |
| `readinessProbe.enabled`                      | would you like a readinessProbe to be enabled                                                                                                                                                                                                                                                                                                                                                                                                                              | `true`                                                        |
| `readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated                                                                                                                                                                                                                                                                                                                                                                                                                                  | 5                                                             |
| `readinessProbe.periodSeconds`                | How often to perform the probe                                                                                                                                                                                                                                                                                                                                                                                                                                             | 10                                                            |
| `readinessProbe.timeoutSeconds`               | When the probe times out                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 5                                                             |
| `readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                                                                                                                                                                                                                                                 | 6                                                             |
| `readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                                                                                                                                                                                                                                                                                | 1                                                             |
| `tls.enabled`                                 | Enable TLS traffic support                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `false`                                                       |
| `tls.preferServerCiphers`                     | Whether to use the server's TLS cipher preferences rather than the client's                                                                                                                                                                                                                                                                                                                                                                                                | `true`                                                        |
| `tls.certificatesSecret`                      | Name of an existing secret that contains the certificates                                                                                                                                                                                                                                                                                                                                                                                                                  | `nil`                                                         |
| `tls.certFilename`                            | Certificate filename                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `""`                                                          |
| `tls.certKeyFilename`                         | Certificate key filename                                                                                                                                                                                                                                                                                                                                                                                                                                                   | `""`                                                          |
| `tls.certCAFilename`                          | CA Certificate filename. If provided, PostgreSQL will authenticate TLS/SSL clients by requesting them a certificate.                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `tls.crlFilename`                             | File containing a Certificate Revocation List                                                                                                                                                                                                                                                                                                                                                                                                                              | `nil`                                                         |
| `metrics.enabled`                             | Start a prometheus exporter                                                                                                                                                                                                                                                                                                                                                                                                                                                | `false`                                                       |
| `metrics.service.type`                        | Kubernetes Service type                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `ClusterIP`                                                   |
| `service.clusterIP`                           | Static clusterIP or None for headless services                                                                                                                                                                                                                                                                                                                                                                                                                             | `nil`                                                         |
| `metrics.service.annotations`                 | Additional annotations for metrics exporter pod                                                                                                                                                                                                                                                                                                                                                                                                                            | `{ prometheus.io/scrape: "true", prometheus.io/port: "9187"}` |
| `metrics.service.loadBalancerIP`              | loadBalancerIP if redis metrics service type is `LoadBalancer`                                                                                                                                                                                                                                                                                                                                                                                                             | `nil`                                                         |
| `metrics.serviceMonitor.enabled`              | Set this to `true` to create ServiceMonitor for Prometheus operator                                                                                                                                                                                                                                                                                                                                                                                                        | `false`                                                       |
| `metrics.serviceMonitor.additionalLabels`     | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                                                                                                                                                                                                                                                                                                                                                                      | `{}`                                                          |
| `metrics.serviceMonitor.namespace`            | Optional namespace in which to create ServiceMonitor                                                                                                                                                                                                                                                                                                                                                                                                                       | `nil`                                                         |
| `metrics.serviceMonitor.interval`             | Scrape interval. If not set, the Prometheus default scrape interval is used                                                                                                                                                                                                                                                                                                                                                                                                | `nil`                                                         |
| `metrics.serviceMonitor.scrapeTimeout`        | Scrape timeout. If not set, the Prometheus default scrape timeout is used                                                                                                                                                                                                                                                                                                                                                                                                  | `nil`                                                         |
| `metrics.prometheusRule.enabled`              | Set this to true to create prometheusRules for Prometheus operator                                                                                                                                                                                                                                                                                                                                                                                                         | `false`                                                       |
| `metrics.prometheusRule.additionalLabels`     | Additional labels that can be used so prometheusRules will be discovered by Prometheus                                                                                                                                                                                                                                                                                                                                                                                     | `{}`                                                          |
| `metrics.prometheusRule.namespace`            | namespace where prometheusRules resource should be created                                                                                                                                                                                                                                                                                                                                                                                                                 | the same namespace as postgresql                              |
| `metrics.prometheusRule.rules`                | [rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) to be created, check values for an example.                                                                                                                                                                                                                                                                                                                                            | `[]`                                                          |
| `metrics.image.registry`                      | PostgreSQL Exporter Image registry                                                                                                                                                                                                                                                                                                                                                                                                                                         | `docker.io`                                                   |
| `metrics.image.repository`                    | PostgreSQL Exporter Image name                                                                                                                                                                                                                                                                                                                                                                                                                                             | `bitnami/postgres-exporter`                                   |
| `metrics.image.tag`                           | PostgreSQL Exporter Image tag                                                                                                                                                                                                                                                                                                                                                                                                                                              | `{TAG_NAME}`                                                  |
| `metrics.image.pullPolicy`                    | PostgreSQL Exporter Image pull policy                                                                                                                                                                                                                                                                                                                                                                                                                                      | `IfNotPresent`                                                |
| `metrics.image.pullSecrets`                   | Specify Image pull secrets                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `nil` (does not add image pull secrets to deployed pods)      |
| `metrics.customMetrics`                       | Additional custom metrics                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `nil`                                                         |
| `metrics.extraEnvVars`                        | Extra environment variables to add to exporter                                                                                                                                                                                                                                                                                                                                                                                                                             | `{}` (evaluated as a template)                                |
| `metrics.securityContext.*`                   | Other container security context to be included as-is in the container spec                                                                                                                                                                                                                                                                                                                                                                                                | `{}`                                                          |
| `metrics.securityContext.enabled`             | Enable security context for metrics                                                                                                                                                                                                                                                                                                                                                                                                                                        | `false`                                                       |
| `metrics.securityContext.runAsUser`           | User ID for the container for metrics                                                                                                                                                                                                                                                                                                                                                                                                                                      | `1001`                                                        |
| `metrics.livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                                                                                                                                                                                                                                                                                                                                                                                                   | 30                                                            |
| `metrics.livenessProbe.periodSeconds`         | How often to perform the probe                                                                                                                                                                                                                                                                                                                                                                                                                                             | 10                                                            |
| `metrics.livenessProbe.timeoutSeconds`        | When the probe times out                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 5                                                             |
| `metrics.livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                                                                                                                                                                                                                                                 | 6                                                             |
| `metrics.livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                                                                                                                                                                                                                                                                                | 1                                                             |
| `metrics.readinessProbe.enabled`              | would you like a readinessProbe to be enabled                                                                                                                                                                                                                                                                                                                                                                                                                              | `true`                                                        |
| `metrics.readinessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                                                                                                                                                                                                                                                                                                                                                   | 5                                                             |
| `metrics.readinessProbe.periodSeconds`        | How often to perform the probe                                                                                                                                                                                                                                                                                                                                                                                                                                             | 10                                                            |
| `metrics.readinessProbe.timeoutSeconds`       | When the probe times out                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 5                                                             |
| `metrics.readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                                                                                                                                                                                                                                                                 | 6                                                             |
| `metrics.readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                                                                                                                                                                                                                                                                                | 1                                                             |
| `updateStrategy`                              | Update strategy policy                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `{type: "RollingUpdate"}`                                     |
| `psp.create`                                  | Create Pod Security Policy                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `false`                                                       |
| `rbac.create`                                 | Create Role and RoleBinding (required for PSP to work)                                                                                                                                                                                                                                                                                                                                                                                                                     | `false`                                                       |
| `extraDeploy`                                 | Array of extra objects to deploy with the release (evaluated as a template).                                                                                                                                                                                                                                                                                                                                                                                               | `nil`                                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set postgresqlPassword=secretpassword,postgresqlDatabase=my-database \
    bitnami/postgresql
```

The above command sets the PostgreSQL `postgres` account password to `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/postgresql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Enable replication:
```diff
- replication.enabled: false
+ replication.enabled: true
```

- Number of read replicas:
```diff
- replication.readReplicas: 1
+ replication.readReplicas: 2
```

- Set synchronous commit mode:
```diff
- replication.synchronousCommit: "off"
+ replication.synchronousCommit: "on"
```

- Number of replicas that will have synchronous replication:
```diff
- replication.numSynchronousReplicas: 0
+ replication.numSynchronousReplicas: 1
```

- Start a prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

To horizontally scale this chart, you can use the `--replicas` flag to modify the number of nodes in your PostgreSQL deployment. Also you can use the `values-production.yaml` file or modify the parameters shown above.

### Customizing primary and read replica services in a replicated configuration

At the top level, there is a service object which defines the services for both primary and readReplicas. For deeper customization, there are service objects for both the primary and read types individually. This allows you to override the values in the top level service object so that the primary and read can be of different service types and with different clusterIPs / nodePorts. Also in the case you want the primary and read to be of type nodePort, you will need to set the nodePorts to different values to prevent a collision. The values that are deeper in the primary.service or readReplicas.service objects will take precedence over the top level service object.

### Change PostgreSQL version

To modify the PostgreSQL version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/postgresql/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### postgresql.conf / pg_hba.conf files as configMap

This helm chart also supports to customize the whole configuration file.

Add your custom file to "files/postgresql.conf" in your working directory. This file will be mounted as configMap to the containers and it will be used for configuring the PostgreSQL server.

Alternatively, you can specify PostgreSQL configuration parameters using the `postgresqlConfiguration` parameter as a dict, using camelCase, e.g. {"sharedBuffers": "500MB"}.

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

### Use of global variables

In more complex scenarios, we may have the following tree of dependencies

```
                     +--------------+
                     |              |
        +------------+   Chart 1    +-----------+
        |            |              |           |
        |            --------+------+           |
        |                    |                  |
        |                    |                  |
        |                    |                  |
        |                    |                  |
        v                    v                  v
+-------+------+    +--------+------+  +--------+------+
|              |    |               |  |               |
|  PostgreSQL  |    |  Sub-chart 1  |  |  Sub-chart 2  |
|              |    |               |  |               |
+--------------+    +---------------+  +---------------+
```

The three charts below depend on the parent chart Chart 1. However, subcharts 1 and 2 may need to connect to PostgreSQL as well. In order to do so, subcharts 1 and 2 need to know the PostgreSQL credentials, so one option for deploying could be deploy Chart 1 with the following parameters:

```
postgresql.postgresqlPassword=testtest
subchart1.postgresql.postgresqlPassword=testtest
subchart2.postgresql.postgresqlPassword=testtest
postgresql.postgresqlDatabase=db1
subchart1.postgresql.postgresqlDatabase=db1
subchart2.postgresql.postgresqlDatabase=db1
```

If the number of dependent sub-charts increases, installing the chart with parameters can become increasingly difficult. An alternative would be to set the credentials using global variables as follows:

```
global.postgresql.postgresqlPassword=testtest
global.postgresql.postgresqlDatabase=db1
```

This way, the credentials will be available in all of the subcharts.

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
persistence.mountPath=/data/
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` paremeter(s). Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to specify the existing passwords while performing an upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `postgresqlPassword` and `replication.password` parameters when upgrading the chart:

```bash
$ helm upgrade my-release bitnami/postgresql \
    --set postgresqlPassword=[POSTGRESQL_PASSWORD] \
    --set replication.password=[REPLICATION_PASSWORD]
```

> Note: you need to substitute the placeholders _[POSTGRESQL_PASSWORD]_, and _[REPLICATION_PASSWORD]_ with the values obtained from instructions in the installation notes.

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

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

```console
$ kubectl delete pod postgresql-postgresql-0
```

Finally, you should see the lines below in MariaDB container logs:

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
