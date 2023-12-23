<!--- app-name: PostgreSQL -->

# Bitnami package for PostgreSQL

PostgreSQL (Postgres) is an open source object-relational database known for reliability and data integrity. ACID-compliant, it supports foreign keys, joins, views, triggers and stored procedures.

[Overview of PostgreSQL](http://www.postgresql.org)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/postgresql
```

Looking to use PostgreSQL in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [PostgreSQL](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

For HA, please see [this repo](https://github.com/bitnami/charts/tree/main/bitnami/postgresql-ha)

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/postgresql
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys PostgreSQL on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components but PVC's associated with the chart and deletes the release.

To delete the PVC's associated with `my-release`:

```console
kubectl delete pvc -l release=my-release
```

> **Note**: Deleting the PVC's will delete postgresql data as well. Please be cautious before doing it.

## Parameters

### Global parameters

| Name                                                       | Description                                                                                                                                                                           | Value |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `global.imageRegistry`                                     | Global Docker image registry                                                                                                                                                          | `""`  |
| `global.imagePullSecrets`                                  | Global Docker registry secret names as an array                                                                                                                                       | `[]`  |
| `global.storageClass`                                      | Global StorageClass for Persistent Volume(s)                                                                                                                                          | `""`  |
| `global.postgresql.auth.postgresPassword`                  | Password for the "postgres" admin user (overrides `auth.postgresPassword`)                                                                                                            | `""`  |
| `global.postgresql.auth.username`                          | Name for a custom user to create (overrides `auth.username`)                                                                                                                          | `""`  |
| `global.postgresql.auth.password`                          | Password for the custom user to create (overrides `auth.password`)                                                                                                                    | `""`  |
| `global.postgresql.auth.database`                          | Name for a custom database to create (overrides `auth.database`)                                                                                                                      | `""`  |
| `global.postgresql.auth.existingSecret`                    | Name of existing secret to use for PostgreSQL credentials (overrides `auth.existingSecret`).                                                                                          | `""`  |
| `global.postgresql.auth.secretKeys.adminPasswordKey`       | Name of key in existing secret to use for PostgreSQL credentials (overrides `auth.secretKeys.adminPasswordKey`). Only used when `global.postgresql.auth.existingSecret` is set.       | `""`  |
| `global.postgresql.auth.secretKeys.userPasswordKey`        | Name of key in existing secret to use for PostgreSQL credentials (overrides `auth.secretKeys.userPasswordKey`). Only used when `global.postgresql.auth.existingSecret` is set.        | `""`  |
| `global.postgresql.auth.secretKeys.replicationPasswordKey` | Name of key in existing secret to use for PostgreSQL credentials (overrides `auth.secretKeys.replicationPasswordKey`). Only used when `global.postgresql.auth.existingSecret` is set. | `""`  |
| `global.postgresql.service.ports.postgresql`               | PostgreSQL service port (overrides `service.ports.postgresql`)                                                                                                                        | `""`  |

### Common parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                                  | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template)                  | `[]`            |
| `commonLabels`           | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations`      | Add annotations to all the deployed resources                                                | `{}`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the statefulset                                        | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the statefulset                                           | `["infinity"]`  |

### PostgreSQL common parameters

| Name                                     | Description                                                                                                                                                                                                                                                                                                                                   | Value                        |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `image.registry`                         | PostgreSQL image registry                                                                                                                                                                                                                                                                                                                     | `REGISTRY_NAME`              |
| `image.repository`                       | PostgreSQL image repository                                                                                                                                                                                                                                                                                                                   | `REPOSITORY_NAME/postgresql` |
| `image.digest`                           | PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                                                                                                    | `""`                         |
| `image.pullPolicy`                       | PostgreSQL image pull policy                                                                                                                                                                                                                                                                                                                  | `IfNotPresent`               |
| `image.pullSecrets`                      | Specify image pull secrets                                                                                                                                                                                                                                                                                                                    | `[]`                         |
| `image.debug`                            | Specify if debug values should be set                                                                                                                                                                                                                                                                                                         | `false`                      |
| `auth.enablePostgresUser`                | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user                                                                                                                                                                                                                                        | `true`                       |
| `auth.postgresPassword`                  | Password for the "postgres" admin user. Ignored if `auth.existingSecret` is provided                                                                                                                                                                                                                                                          | `""`                         |
| `auth.username`                          | Name for a custom user to create                                                                                                                                                                                                                                                                                                              | `""`                         |
| `auth.password`                          | Password for the custom user to create. Ignored if `auth.existingSecret` is provided                                                                                                                                                                                                                                                          | `""`                         |
| `auth.database`                          | Name for a custom database to create                                                                                                                                                                                                                                                                                                          | `""`                         |
| `auth.replicationUsername`               | Name of the replication user                                                                                                                                                                                                                                                                                                                  | `repl_user`                  |
| `auth.replicationPassword`               | Password for the replication user. Ignored if `auth.existingSecret` is provided                                                                                                                                                                                                                                                               | `""`                         |
| `auth.existingSecret`                    | Name of existing secret to use for PostgreSQL credentials. `auth.postgresPassword`, `auth.password`, and `auth.replicationPassword` will be ignored and picked up from this secret. The secret might also contains the key `ldap-password` if LDAP is enabled. `ldap.bind_password` will be ignored and picked from this secret in this case. | `""`                         |
| `auth.secretKeys.adminPasswordKey`       | Name of key in existing secret to use for PostgreSQL credentials. Only used when `auth.existingSecret` is set.                                                                                                                                                                                                                                | `postgres-password`          |
| `auth.secretKeys.userPasswordKey`        | Name of key in existing secret to use for PostgreSQL credentials. Only used when `auth.existingSecret` is set.                                                                                                                                                                                                                                | `password`                   |
| `auth.secretKeys.replicationPasswordKey` | Name of key in existing secret to use for PostgreSQL credentials. Only used when `auth.existingSecret` is set.                                                                                                                                                                                                                                | `replication-password`       |
| `auth.usePasswordFiles`                  | Mount credentials as a files instead of using an environment variable                                                                                                                                                                                                                                                                         | `false`                      |
| `architecture`                           | PostgreSQL architecture (`standalone` or `replication`)                                                                                                                                                                                                                                                                                       | `standalone`                 |
| `replication.synchronousCommit`          | Set synchronous commit mode. Allowed values: `on`, `remote_apply`, `remote_write`, `local` and `off`                                                                                                                                                                                                                                          | `off`                        |
| `replication.numSynchronousReplicas`     | Number of replicas that will have synchronous replication. Note: Cannot be greater than `readReplicas.replicaCount`.                                                                                                                                                                                                                          | `0`                          |
| `replication.applicationName`            | Cluster application name. Useful for advanced replication settings                                                                                                                                                                                                                                                                            | `my_application`             |
| `containerPorts.postgresql`              | PostgreSQL container port                                                                                                                                                                                                                                                                                                                     | `5432`                       |
| `audit.logHostname`                      | Log client hostnames                                                                                                                                                                                                                                                                                                                          | `false`                      |
| `audit.logConnections`                   | Add client log-in operations to the log file                                                                                                                                                                                                                                                                                                  | `false`                      |
| `audit.logDisconnections`                | Add client log-outs operations to the log file                                                                                                                                                                                                                                                                                                | `false`                      |
| `audit.pgAuditLog`                       | Add operations to log using the pgAudit extension                                                                                                                                                                                                                                                                                             | `""`                         |
| `audit.pgAuditLogCatalog`                | Log catalog using pgAudit                                                                                                                                                                                                                                                                                                                     | `off`                        |
| `audit.clientMinMessages`                | Message log level to share with the user                                                                                                                                                                                                                                                                                                      | `error`                      |
| `audit.logLinePrefix`                    | Template for log line prefix (default if not set)                                                                                                                                                                                                                                                                                             | `""`                         |
| `audit.logTimezone`                      | Timezone for the log timestamps                                                                                                                                                                                                                                                                                                               | `""`                         |
| `ldap.enabled`                           | Enable LDAP support                                                                                                                                                                                                                                                                                                                           | `false`                      |
| `ldap.server`                            | IP address or name of the LDAP server.                                                                                                                                                                                                                                                                                                        | `""`                         |
| `ldap.port`                              | Port number on the LDAP server to connect to                                                                                                                                                                                                                                                                                                  | `""`                         |
| `ldap.prefix`                            | String to prepend to the user name when forming the DN to bind                                                                                                                                                                                                                                                                                | `""`                         |
| `ldap.suffix`                            | String to append to the user name when forming the DN to bind                                                                                                                                                                                                                                                                                 | `""`                         |
| `ldap.basedn`                            | Root DN to begin the search for the user in                                                                                                                                                                                                                                                                                                   | `""`                         |
| `ldap.binddn`                            | DN of user to bind to LDAP                                                                                                                                                                                                                                                                                                                    | `""`                         |
| `ldap.bindpw`                            | Password for the user to bind to LDAP                                                                                                                                                                                                                                                                                                         | `""`                         |
| `ldap.searchAttribute`                   | Attribute to match against the user name in the search                                                                                                                                                                                                                                                                                        | `""`                         |
| `ldap.searchFilter`                      | The search filter to use when doing search+bind authentication                                                                                                                                                                                                                                                                                | `""`                         |
| `ldap.scheme`                            | Set to `ldaps` to use LDAPS                                                                                                                                                                                                                                                                                                                   | `""`                         |
| `ldap.tls.enabled`                       | Se to true to enable TLS encryption                                                                                                                                                                                                                                                                                                           | `false`                      |
| `ldap.uri`                               | LDAP URL beginning in the form `ldap[s]://host[:port]/basedn`. If provided, all the other LDAP parameters will be ignored.                                                                                                                                                                                                                    | `""`                         |
| `postgresqlDataDir`                      | PostgreSQL data dir folder                                                                                                                                                                                                                                                                                                                    | `/bitnami/postgresql/data`   |
| `postgresqlSharedPreloadLibraries`       | Shared preload libraries (comma-separated list)                                                                                                                                                                                                                                                                                               | `pgaudit`                    |
| `shmVolume.enabled`                      | Enable emptyDir volume for /dev/shm for PostgreSQL pod(s)                                                                                                                                                                                                                                                                                     | `true`                       |
| `shmVolume.sizeLimit`                    | Set this to enable a size limit on the shm tmpfs                                                                                                                                                                                                                                                                                              | `""`                         |
| `tls.enabled`                            | Enable TLS traffic support                                                                                                                                                                                                                                                                                                                    | `false`                      |
| `tls.autoGenerated`                      | Generate automatically self-signed TLS certificates                                                                                                                                                                                                                                                                                           | `false`                      |
| `tls.preferServerCiphers`                | Whether to use the server's TLS cipher preferences rather than the client's                                                                                                                                                                                                                                                                   | `true`                       |
| `tls.certificatesSecret`                 | Name of an existing secret that contains the certificates                                                                                                                                                                                                                                                                                     | `""`                         |
| `tls.certFilename`                       | Certificate filename                                                                                                                                                                                                                                                                                                                          | `""`                         |
| `tls.certKeyFilename`                    | Certificate key filename                                                                                                                                                                                                                                                                                                                      | `""`                         |
| `tls.certCAFilename`                     | CA Certificate filename                                                                                                                                                                                                                                                                                                                       | `""`                         |
| `tls.crlFilename`                        | File containing a Certificate Revocation List                                                                                                                                                                                                                                                                                                 | `""`                         |

### PostgreSQL Primary parameters

| Name                                                        | Description                                                                                                              | Value                 |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------------- |
| `primary.name`                                              | Name of the primary database (eg primary, master, leader, ...)                                                           | `primary`             |
| `primary.configuration`                                     | PostgreSQL Primary main configuration to be injected as ConfigMap                                                        | `""`                  |
| `primary.pgHbaConfiguration`                                | PostgreSQL Primary client authentication configuration                                                                   | `""`                  |
| `primary.existingConfigmap`                                 | Name of an existing ConfigMap with PostgreSQL Primary configuration                                                      | `""`                  |
| `primary.extendedConfiguration`                             | Extended PostgreSQL Primary configuration (appended to main or default configuration)                                    | `""`                  |
| `primary.existingExtendedConfigmap`                         | Name of an existing ConfigMap with PostgreSQL Primary extended configuration                                             | `""`                  |
| `primary.initdb.args`                                       | PostgreSQL initdb extra arguments                                                                                        | `""`                  |
| `primary.initdb.postgresqlWalDir`                           | Specify a custom location for the PostgreSQL transaction log                                                             | `""`                  |
| `primary.initdb.scripts`                                    | Dictionary of initdb scripts                                                                                             | `{}`                  |
| `primary.initdb.scriptsConfigMap`                           | ConfigMap with scripts to be run at first boot                                                                           | `""`                  |
| `primary.initdb.scriptsSecret`                              | Secret with scripts to be run at first boot (in case it contains sensitive information)                                  | `""`                  |
| `primary.initdb.user`                                       | Specify the PostgreSQL username to execute the initdb scripts                                                            | `""`                  |
| `primary.initdb.password`                                   | Specify the PostgreSQL password to execute the initdb scripts                                                            | `""`                  |
| `primary.standby.enabled`                                   | Whether to enable current cluster's primary as standby server of another cluster or not                                  | `false`               |
| `primary.standby.primaryHost`                               | The Host of replication primary in the other cluster                                                                     | `""`                  |
| `primary.standby.primaryPort`                               | The Port of replication primary in the other cluster                                                                     | `""`                  |
| `primary.extraEnvVars`                                      | Array with extra environment variables to add to PostgreSQL Primary nodes                                                | `[]`                  |
| `primary.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for PostgreSQL Primary nodes                                        | `""`                  |
| `primary.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for PostgreSQL Primary nodes                                           | `""`                  |
| `primary.command`                                           | Override default container command (useful when using custom images)                                                     | `[]`                  |
| `primary.args`                                              | Override default container args (useful when using custom images)                                                        | `[]`                  |
| `primary.livenessProbe.enabled`                             | Enable livenessProbe on PostgreSQL Primary containers                                                                    | `true`                |
| `primary.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `30`                  |
| `primary.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`                  |
| `primary.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `5`                   |
| `primary.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `6`                   |
| `primary.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`                   |
| `primary.readinessProbe.enabled`                            | Enable readinessProbe on PostgreSQL Primary containers                                                                   | `true`                |
| `primary.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `5`                   |
| `primary.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`                  |
| `primary.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `5`                   |
| `primary.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `6`                   |
| `primary.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`                   |
| `primary.startupProbe.enabled`                              | Enable startupProbe on PostgreSQL Primary containers                                                                     | `false`               |
| `primary.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `30`                  |
| `primary.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `10`                  |
| `primary.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `1`                   |
| `primary.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `15`                  |
| `primary.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`                   |
| `primary.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`                  |
| `primary.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`                  |
| `primary.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`                  |
| `primary.lifecycleHooks`                                    | for the PostgreSQL Primary container to automate configuration before or after startup                                   | `{}`                  |
| `primary.resources.limits`                                  | The resources limits for the PostgreSQL Primary containers                                                               | `{}`                  |
| `primary.resources.requests.memory`                         | The requested memory for the PostgreSQL Primary containers                                                               | `256Mi`               |
| `primary.resources.requests.cpu`                            | The requested cpu for the PostgreSQL Primary containers                                                                  | `250m`                |
| `primary.podSecurityContext.enabled`                        | Enable security context                                                                                                  | `true`                |
| `primary.podSecurityContext.fsGroup`                        | Group ID for the pod                                                                                                     | `1001`                |
| `primary.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                     | `true`                |
| `primary.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                               | `1001`                |
| `primary.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                            | `true`                |
| `primary.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                              | `false`               |
| `primary.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                  | `false`               |
| `primary.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                | `false`               |
| `primary.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                       | `["ALL"]`             |
| `primary.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                         | `RuntimeDefault`      |
| `primary.hostAliases`                                       | PostgreSQL primary pods host aliases                                                                                     | `[]`                  |
| `primary.hostNetwork`                                       | Specify if host network should be enabled for PostgreSQL pod (postgresql primary)                                        | `false`               |
| `primary.hostIPC`                                           | Specify if host IPC should be enabled for PostgreSQL pod (postgresql primary)                                            | `false`               |
| `primary.labels`                                            | Map of labels to add to the statefulset (postgresql primary)                                                             | `{}`                  |
| `primary.annotations`                                       | Annotations for PostgreSQL primary pods                                                                                  | `{}`                  |
| `primary.podLabels`                                         | Map of labels to add to the pods (postgresql primary)                                                                    | `{}`                  |
| `primary.podAnnotations`                                    | Map of annotations to add to the pods (postgresql primary)                                                               | `{}`                  |
| `primary.podAffinityPreset`                                 | PostgreSQL primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`           | `""`                  |
| `primary.podAntiAffinityPreset`                             | PostgreSQL primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`      | `soft`                |
| `primary.nodeAffinityPreset.type`                           | PostgreSQL primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`     | `""`                  |
| `primary.nodeAffinityPreset.key`                            | PostgreSQL primary node label key to match Ignored if `primary.affinity` is set.                                         | `""`                  |
| `primary.nodeAffinityPreset.values`                         | PostgreSQL primary node label values to match. Ignored if `primary.affinity` is set.                                     | `[]`                  |
| `primary.affinity`                                          | Affinity for PostgreSQL primary pods assignment                                                                          | `{}`                  |
| `primary.nodeSelector`                                      | Node labels for PostgreSQL primary pods assignment                                                                       | `{}`                  |
| `primary.tolerations`                                       | Tolerations for PostgreSQL primary pods assignment                                                                       | `[]`                  |
| `primary.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                  |
| `primary.priorityClassName`                                 | Priority Class to use for each pod (postgresql primary)                                                                  | `""`                  |
| `primary.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                | `""`                  |
| `primary.terminationGracePeriodSeconds`                     | Seconds PostgreSQL primary pod needs to terminate gracefully                                                             | `""`                  |
| `primary.updateStrategy.type`                               | PostgreSQL Primary statefulset strategy type                                                                             | `RollingUpdate`       |
| `primary.updateStrategy.rollingUpdate`                      | PostgreSQL Primary statefulset rolling update configuration parameters                                                   | `{}`                  |
| `primary.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the PostgreSQL Primary container(s)                         | `[]`                  |
| `primary.extraVolumes`                                      | Optionally specify extra list of additional volumes for the PostgreSQL Primary pod(s)                                    | `[]`                  |
| `primary.sidecars`                                          | Add additional sidecar containers to the PostgreSQL Primary pod(s)                                                       | `[]`                  |
| `primary.initContainers`                                    | Add additional init containers to the PostgreSQL Primary pod(s)                                                          | `[]`                  |
| `primary.extraPodSpec`                                      | Optionally specify extra PodSpec for the PostgreSQL Primary pod(s)                                                       | `{}`                  |
| `primary.service.type`                                      | Kubernetes Service type                                                                                                  | `ClusterIP`           |
| `primary.service.ports.postgresql`                          | PostgreSQL service port                                                                                                  | `5432`                |
| `primary.service.nodePorts.postgresql`                      | Node port for PostgreSQL                                                                                                 | `""`                  |
| `primary.service.clusterIP`                                 | Static clusterIP or None for headless services                                                                           | `""`                  |
| `primary.service.annotations`                               | Annotations for PostgreSQL primary service                                                                               | `{}`                  |
| `primary.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                                       | `""`                  |
| `primary.service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                     | `Cluster`             |
| `primary.service.loadBalancerSourceRanges`                  | Addresses that are allowed when service is LoadBalancer                                                                  | `[]`                  |
| `primary.service.extraPorts`                                | Extra ports to expose in the PostgreSQL primary service                                                                  | `[]`                  |
| `primary.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                     | `None`                |
| `primary.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                              | `{}`                  |
| `primary.service.headless.annotations`                      | Additional custom annotations for headless PostgreSQL primary service                                                    | `{}`                  |
| `primary.persistence.enabled`                               | Enable PostgreSQL Primary data persistence using PVC                                                                     | `true`                |
| `primary.persistence.existingClaim`                         | Name of an existing PVC to use                                                                                           | `""`                  |
| `primary.persistence.mountPath`                             | The path the volume will be mounted at                                                                                   | `/bitnami/postgresql` |
| `primary.persistence.subPath`                               | The subdirectory of the volume to mount to                                                                               | `""`                  |
| `primary.persistence.storageClass`                          | PVC Storage Class for PostgreSQL Primary data volume                                                                     | `""`                  |
| `primary.persistence.accessModes`                           | PVC Access Mode for PostgreSQL volume                                                                                    | `["ReadWriteOnce"]`   |
| `primary.persistence.size`                                  | PVC Storage Request for PostgreSQL volume                                                                                | `8Gi`                 |
| `primary.persistence.annotations`                           | Annotations for the PVC                                                                                                  | `{}`                  |
| `primary.persistence.labels`                                | Labels for the PVC                                                                                                       | `{}`                  |
| `primary.persistence.selector`                              | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                  | `{}`                  |
| `primary.persistence.dataSource`                            | Custom PVC data source                                                                                                   | `{}`                  |
| `primary.persistentVolumeClaimRetentionPolicy.enabled`      | Enable Persistent volume retention policy for Primary Statefulset                                                        | `false`               |
| `primary.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                           | `Retain`              |
| `primary.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                   | `Retain`              |

### PostgreSQL read only replica parameters (only used when `architecture` is set to `replication`)

| Name                                                             | Description                                                                                                              | Value                 |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------------- |
| `readReplicas.name`                                              | Name of the read replicas database (eg secondary, slave, ...)                                                            | `read`                |
| `readReplicas.replicaCount`                                      | Number of PostgreSQL read only replicas                                                                                  | `1`                   |
| `readReplicas.extendedConfiguration`                             | Extended PostgreSQL read only replicas configuration (appended to main or default configuration)                         | `""`                  |
| `readReplicas.extraEnvVars`                                      | Array with extra environment variables to add to PostgreSQL read only nodes                                              | `[]`                  |
| `readReplicas.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for PostgreSQL read only nodes                                      | `""`                  |
| `readReplicas.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for PostgreSQL read only nodes                                         | `""`                  |
| `readReplicas.command`                                           | Override default container command (useful when using custom images)                                                     | `[]`                  |
| `readReplicas.args`                                              | Override default container args (useful when using custom images)                                                        | `[]`                  |
| `readReplicas.livenessProbe.enabled`                             | Enable livenessProbe on PostgreSQL read only containers                                                                  | `true`                |
| `readReplicas.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `30`                  |
| `readReplicas.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`                  |
| `readReplicas.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `5`                   |
| `readReplicas.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `6`                   |
| `readReplicas.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`                   |
| `readReplicas.readinessProbe.enabled`                            | Enable readinessProbe on PostgreSQL read only containers                                                                 | `true`                |
| `readReplicas.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `5`                   |
| `readReplicas.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`                  |
| `readReplicas.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `5`                   |
| `readReplicas.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `6`                   |
| `readReplicas.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`                   |
| `readReplicas.startupProbe.enabled`                              | Enable startupProbe on PostgreSQL read only containers                                                                   | `false`               |
| `readReplicas.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `30`                  |
| `readReplicas.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `10`                  |
| `readReplicas.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `1`                   |
| `readReplicas.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `15`                  |
| `readReplicas.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`                   |
| `readReplicas.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`                  |
| `readReplicas.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`                  |
| `readReplicas.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`                  |
| `readReplicas.lifecycleHooks`                                    | for the PostgreSQL read only container to automate configuration before or after startup                                 | `{}`                  |
| `readReplicas.resources.limits`                                  | The resources limits for the PostgreSQL read only containers                                                             | `{}`                  |
| `readReplicas.resources.requests.memory`                         | The requested memory for the PostgreSQL read only containers                                                             | `256Mi`               |
| `readReplicas.resources.requests.cpu`                            | The requested cpu for the PostgreSQL read only containers                                                                | `250m`                |
| `readReplicas.podSecurityContext.enabled`                        | Enable security context                                                                                                  | `true`                |
| `readReplicas.podSecurityContext.fsGroup`                        | Group ID for the pod                                                                                                     | `1001`                |
| `readReplicas.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                     | `true`                |
| `readReplicas.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                               | `1001`                |
| `readReplicas.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                            | `true`                |
| `readReplicas.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                              | `false`               |
| `readReplicas.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                  | `false`               |
| `readReplicas.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                | `false`               |
| `readReplicas.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                       | `["ALL"]`             |
| `readReplicas.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                         | `RuntimeDefault`      |
| `readReplicas.hostAliases`                                       | PostgreSQL read only pods host aliases                                                                                   | `[]`                  |
| `readReplicas.hostNetwork`                                       | Specify if host network should be enabled for PostgreSQL pod (PostgreSQL read only)                                      | `false`               |
| `readReplicas.hostIPC`                                           | Specify if host IPC should be enabled for PostgreSQL pod (postgresql primary)                                            | `false`               |
| `readReplicas.labels`                                            | Map of labels to add to the statefulset (PostgreSQL read only)                                                           | `{}`                  |
| `readReplicas.annotations`                                       | Annotations for PostgreSQL read only pods                                                                                | `{}`                  |
| `readReplicas.podLabels`                                         | Map of labels to add to the pods (PostgreSQL read only)                                                                  | `{}`                  |
| `readReplicas.podAnnotations`                                    | Map of annotations to add to the pods (PostgreSQL read only)                                                             | `{}`                  |
| `readReplicas.podAffinityPreset`                                 | PostgreSQL read only pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`         | `""`                  |
| `readReplicas.podAntiAffinityPreset`                             | PostgreSQL read only pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`    | `soft`                |
| `readReplicas.nodeAffinityPreset.type`                           | PostgreSQL read only node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`   | `""`                  |
| `readReplicas.nodeAffinityPreset.key`                            | PostgreSQL read only node label key to match Ignored if `primary.affinity` is set.                                       | `""`                  |
| `readReplicas.nodeAffinityPreset.values`                         | PostgreSQL read only node label values to match. Ignored if `primary.affinity` is set.                                   | `[]`                  |
| `readReplicas.affinity`                                          | Affinity for PostgreSQL read only pods assignment                                                                        | `{}`                  |
| `readReplicas.nodeSelector`                                      | Node labels for PostgreSQL read only pods assignment                                                                     | `{}`                  |
| `readReplicas.tolerations`                                       | Tolerations for PostgreSQL read only pods assignment                                                                     | `[]`                  |
| `readReplicas.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                  |
| `readReplicas.priorityClassName`                                 | Priority Class to use for each pod (PostgreSQL read only)                                                                | `""`                  |
| `readReplicas.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                | `""`                  |
| `readReplicas.terminationGracePeriodSeconds`                     | Seconds PostgreSQL read only pod needs to terminate gracefully                                                           | `""`                  |
| `readReplicas.updateStrategy.type`                               | PostgreSQL read only statefulset strategy type                                                                           | `RollingUpdate`       |
| `readReplicas.updateStrategy.rollingUpdate`                      | PostgreSQL read only statefulset rolling update configuration parameters                                                 | `{}`                  |
| `readReplicas.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the PostgreSQL read only container(s)                       | `[]`                  |
| `readReplicas.extraVolumes`                                      | Optionally specify extra list of additional volumes for the PostgreSQL read only pod(s)                                  | `[]`                  |
| `readReplicas.sidecars`                                          | Add additional sidecar containers to the PostgreSQL read only pod(s)                                                     | `[]`                  |
| `readReplicas.initContainers`                                    | Add additional init containers to the PostgreSQL read only pod(s)                                                        | `[]`                  |
| `readReplicas.extraPodSpec`                                      | Optionally specify extra PodSpec for the PostgreSQL read only pod(s)                                                     | `{}`                  |
| `readReplicas.service.type`                                      | Kubernetes Service type                                                                                                  | `ClusterIP`           |
| `readReplicas.service.ports.postgresql`                          | PostgreSQL service port                                                                                                  | `5432`                |
| `readReplicas.service.nodePorts.postgresql`                      | Node port for PostgreSQL                                                                                                 | `""`                  |
| `readReplicas.service.clusterIP`                                 | Static clusterIP or None for headless services                                                                           | `""`                  |
| `readReplicas.service.annotations`                               | Annotations for PostgreSQL read only service                                                                             | `{}`                  |
| `readReplicas.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                                       | `""`                  |
| `readReplicas.service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                     | `Cluster`             |
| `readReplicas.service.loadBalancerSourceRanges`                  | Addresses that are allowed when service is LoadBalancer                                                                  | `[]`                  |
| `readReplicas.service.extraPorts`                                | Extra ports to expose in the PostgreSQL read only service                                                                | `[]`                  |
| `readReplicas.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                     | `None`                |
| `readReplicas.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                              | `{}`                  |
| `readReplicas.service.headless.annotations`                      | Additional custom annotations for headless PostgreSQL read only service                                                  | `{}`                  |
| `readReplicas.persistence.enabled`                               | Enable PostgreSQL read only data persistence using PVC                                                                   | `true`                |
| `readReplicas.persistence.existingClaim`                         | Name of an existing PVC to use                                                                                           | `""`                  |
| `readReplicas.persistence.mountPath`                             | The path the volume will be mounted at                                                                                   | `/bitnami/postgresql` |
| `readReplicas.persistence.subPath`                               | The subdirectory of the volume to mount to                                                                               | `""`                  |
| `readReplicas.persistence.storageClass`                          | PVC Storage Class for PostgreSQL read only data volume                                                                   | `""`                  |
| `readReplicas.persistence.accessModes`                           | PVC Access Mode for PostgreSQL volume                                                                                    | `["ReadWriteOnce"]`   |
| `readReplicas.persistence.size`                                  | PVC Storage Request for PostgreSQL volume                                                                                | `8Gi`                 |
| `readReplicas.persistence.annotations`                           | Annotations for the PVC                                                                                                  | `{}`                  |
| `readReplicas.persistence.labels`                                | Labels for the PVC                                                                                                       | `{}`                  |
| `readReplicas.persistence.selector`                              | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                  | `{}`                  |
| `readReplicas.persistence.dataSource`                            | Custom PVC data source                                                                                                   | `{}`                  |
| `readReplicas.persistentVolumeClaimRetentionPolicy.enabled`      | Enable Persistent volume retention policy for read only Statefulset                                                      | `false`               |
| `readReplicas.persistentVolumeClaimRetentionPolicy.whenScaled`   | Volume retention behavior when the replica count of the StatefulSet is reduced                                           | `Retain`              |
| `readReplicas.persistentVolumeClaimRetentionPolicy.whenDeleted`  | Volume retention behavior that applies when the StatefulSet is deleted                                                   | `Retain`              |

### Backup parameters

| Name                                                               | Description                                                                                                                           | Value                                                                                                                                                                                |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `backup.enabled`                                                   | Enable the logical dump of the database "regularly"                                                                                   | `false`                                                                                                                                                                              |
| `backup.cronjob.schedule`                                          | Set the cronjob parameter schedule                                                                                                    | `@daily`                                                                                                                                                                             |
| `backup.cronjob.timeZone`                                          | Set the cronjob parameter timeZone                                                                                                    | `""`                                                                                                                                                                                 |
| `backup.cronjob.concurrencyPolicy`                                 | Set the cronjob parameter concurrencyPolicy                                                                                           | `Allow`                                                                                                                                                                              |
| `backup.cronjob.failedJobsHistoryLimit`                            | Set the cronjob parameter failedJobsHistoryLimit                                                                                      | `1`                                                                                                                                                                                  |
| `backup.cronjob.successfulJobsHistoryLimit`                        | Set the cronjob parameter successfulJobsHistoryLimit                                                                                  | `3`                                                                                                                                                                                  |
| `backup.cronjob.startingDeadlineSeconds`                           | Set the cronjob parameter startingDeadlineSeconds                                                                                     | `""`                                                                                                                                                                                 |
| `backup.cronjob.ttlSecondsAfterFinished`                           | Set the cronjob parameter ttlSecondsAfterFinished                                                                                     | `""`                                                                                                                                                                                 |
| `backup.cronjob.restartPolicy`                                     | Set the cronjob parameter restartPolicy                                                                                               | `OnFailure`                                                                                                                                                                          |
| `backup.cronjob.podSecurityContext.enabled`                        | Enable PodSecurityContext for CronJob/Backup                                                                                          | `true`                                                                                                                                                                               |
| `backup.cronjob.podSecurityContext.fsGroup`                        | Group ID for the CronJob                                                                                                              | `1001`                                                                                                                                                                               |
| `backup.cronjob.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                  | `true`                                                                                                                                                                               |
| `backup.cronjob.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                            | `1001`                                                                                                                                                                               |
| `backup.cronjob.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                         | `true`                                                                                                                                                                               |
| `backup.cronjob.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                           | `false`                                                                                                                                                                              |
| `backup.cronjob.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                               | `false`                                                                                                                                                                              |
| `backup.cronjob.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                             | `false`                                                                                                                                                                              |
| `backup.cronjob.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                    | `["ALL"]`                                                                                                                                                                            |
| `backup.cronjob.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                      | `RuntimeDefault`                                                                                                                                                                     |
| `backup.cronjob.command`                                           | Set backup container's command to run                                                                                                 | `["/bin/sh","-c","pg_dumpall --clean --if-exists --load-via-partition-root --quote-all-identifiers --no-password --file=${PGDUMP_DIR}/pg_dumpall-$(date '+%Y-%m-%d-%H-%M').pgdump"]` |
| `backup.cronjob.labels`                                            | Set the cronjob labels                                                                                                                | `{}`                                                                                                                                                                                 |
| `backup.cronjob.annotations`                                       | Set the cronjob annotations                                                                                                           | `{}`                                                                                                                                                                                 |
| `backup.cronjob.nodeSelector`                                      | Node labels for PostgreSQL backup CronJob pod assignment                                                                              | `{}`                                                                                                                                                                                 |
| `backup.cronjob.storage.existingClaim`                             | Provide an existing `PersistentVolumeClaim` (only when `architecture=standalone`)                                                     | `""`                                                                                                                                                                                 |
| `backup.cronjob.storage.resourcePolicy`                            | Setting it to "keep" to avoid removing PVCs during a helm delete operation. Leaving it empty will delete PVCs after the chart deleted | `""`                                                                                                                                                                                 |
| `backup.cronjob.storage.storageClass`                              | PVC Storage Class for the backup data volume                                                                                          | `""`                                                                                                                                                                                 |
| `backup.cronjob.storage.accessModes`                               | PV Access Mode                                                                                                                        | `["ReadWriteOnce"]`                                                                                                                                                                  |
| `backup.cronjob.storage.size`                                      | PVC Storage Request for the backup data volume                                                                                        | `8Gi`                                                                                                                                                                                |
| `backup.cronjob.storage.annotations`                               | PVC annotations                                                                                                                       | `{}`                                                                                                                                                                                 |
| `backup.cronjob.storage.mountPath`                                 | Path to mount the volume at                                                                                                           | `/backup/pgdump`                                                                                                                                                                     |
| `backup.cronjob.storage.subPath`                                   | Subdirectory of the volume to mount at                                                                                                | `""`                                                                                                                                                                                 |
| `backup.cronjob.storage.volumeClaimTemplates.selector`             | A label query over volumes to consider for binding (e.g. when using local volumes)                                                    | `{}`                                                                                                                                                                                 |

### NetworkPolicy parameters

| Name                                                                      | Description                                                                                                                                        | Value   |
| ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                                   | Enable network policies                                                                                                                            | `false` |
| `networkPolicy.metrics.enabled`                                           | Enable network policies for metrics (prometheus)                                                                                                   | `false` |
| `networkPolicy.metrics.namespaceSelector`                                 | Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                                             | `{}`    |
| `networkPolicy.metrics.podSelector`                                       | Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                                         | `{}`    |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.enabled`                | Enable ingress rule that makes PostgreSQL primary node only accessible from a particular origin.                                                   | `false` |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.namespaceSelector`      | Namespace selector label that is allowed to access the PostgreSQL primary node. This label will be used to identified the allowed namespace(s).    | `{}`    |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.podSelector`            | Pods selector label that is allowed to access the PostgreSQL primary node. This label will be used to identified the allowed pod(s).               | `{}`    |
| `networkPolicy.ingressRules.primaryAccessOnlyFrom.customRules`            | Custom network policy for the PostgreSQL primary node.                                                                                             | `[]`    |
| `networkPolicy.ingressRules.readReplicasAccessOnlyFrom.enabled`           | Enable ingress rule that makes PostgreSQL read-only nodes only accessible from a particular origin.                                                | `false` |
| `networkPolicy.ingressRules.readReplicasAccessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access the PostgreSQL read-only nodes. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.readReplicasAccessOnlyFrom.podSelector`       | Pods selector label that is allowed to access the PostgreSQL read-only nodes. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.readReplicasAccessOnlyFrom.customRules`       | Custom network policy for the PostgreSQL read-only nodes.                                                                                          | `[]`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`                     | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                                                     | `false` |
| `networkPolicy.egressRules.customRules`                                   | Custom network policy rule                                                                                                                         | `[]`    |

### Volume Permissions parameters

| Name                                                             | Description                                                                                                                       | Value                      |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                      | Enable init container that changes the owner and group of the persistent volume                                                   | `false`                    |
| `volumePermissions.image.registry`                               | Init container volume-permissions image registry                                                                                  | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                             | Init container volume-permissions image repository                                                                                | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                                 | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                       |
| `volumePermissions.image.pullPolicy`                             | Init container volume-permissions image pull policy                                                                               | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                            | Init container volume-permissions image pull secrets                                                                              | `[]`                       |
| `volumePermissions.resources.limits`                             | Init container volume-permissions resource limits                                                                                 | `{}`                       |
| `volumePermissions.resources.requests`                           | Init container volume-permissions resource requests                                                                               | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser`           | User ID for the init container                                                                                                    | `0`                        |
| `volumePermissions.containerSecurityContext.runAsGroup`          | Group ID for the init container                                                                                                   | `0`                        |
| `volumePermissions.containerSecurityContext.runAsNonRoot`        | runAsNonRoot for the init container                                                                                               | `false`                    |
| `volumePermissions.containerSecurityContext.seccompProfile.type` | seccompProfile.type for the init container                                                                                        | `RuntimeDefault`           |

### Other Parameters

| Name                                          | Description                                                                                                                                 | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceBindings.enabled`                     | Create secret for service binding (Experimental)                                                                                            | `false` |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for PostgreSQL pod                                                                                        | `false` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                      | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                      | `true`  |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                                                        | `{}`    |
| `rbac.create`                                 | Create Role and RoleBinding (required for PSP to work)                                                                                      | `false` |
| `rbac.rules`                                  | Custom RBAC rules to set                                                                                                                    | `[]`    |
| `psp.create`                                  | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later | `false` |

### Metrics Parameters

| Name                                                        | Description                                                                                                | Value                               |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `metrics.enabled`                                           | Start a prometheus exporter                                                                                | `false`                             |
| `metrics.image.registry`                                    | PostgreSQL Prometheus Exporter image registry                                                              | `REGISTRY_NAME`                     |
| `metrics.image.repository`                                  | PostgreSQL Prometheus Exporter image repository                                                            | `REPOSITORY_NAME/postgres-exporter` |
| `metrics.image.digest`                                      | PostgreSQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                |
| `metrics.image.pullPolicy`                                  | PostgreSQL Prometheus Exporter image pull policy                                                           | `IfNotPresent`                      |
| `metrics.image.pullSecrets`                                 | Specify image pull secrets                                                                                 | `[]`                                |
| `metrics.collectors`                                        | Control enabled collectors                                                                                 | `{}`                                |
| `metrics.customMetrics`                                     | Define additional custom metrics                                                                           | `{}`                                |
| `metrics.extraEnvVars`                                      | Extra environment variables to add to PostgreSQL Prometheus exporter                                       | `[]`                                |
| `metrics.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                       | `true`                              |
| `metrics.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                 | `1001`                              |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                              | `true`                              |
| `metrics.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                | `false`                             |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                    | `false`                             |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                  | `false`                             |
| `metrics.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                         | `["ALL"]`                           |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                           | `RuntimeDefault`                    |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe on PostgreSQL Prometheus exporter containers                                          | `true`                              |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                    | `5`                                 |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                           | `10`                                |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                          | `5`                                 |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                        | `6`                                 |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                        | `1`                                 |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe on PostgreSQL Prometheus exporter containers                                         | `true`                              |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                   | `5`                                 |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                          | `10`                                |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                         | `5`                                 |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                       | `6`                                 |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                       | `1`                                 |
| `metrics.startupProbe.enabled`                              | Enable startupProbe on PostgreSQL Prometheus exporter containers                                           | `false`                             |
| `metrics.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                     | `10`                                |
| `metrics.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                            | `10`                                |
| `metrics.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                           | `1`                                 |
| `metrics.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                         | `15`                                |
| `metrics.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                         | `1`                                 |
| `metrics.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                        | `{}`                                |
| `metrics.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                       | `{}`                                |
| `metrics.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                         | `{}`                                |
| `metrics.containerPorts.metrics`                            | PostgreSQL Prometheus exporter metrics container port                                                      | `9187`                              |
| `metrics.resources.limits`                                  | The resources limits for the PostgreSQL Prometheus exporter container                                      | `{}`                                |
| `metrics.resources.requests`                                | The requested resources for the PostgreSQL Prometheus exporter container                                   | `{}`                                |
| `metrics.service.ports.metrics`                             | PostgreSQL Prometheus Exporter service port                                                                | `9187`                              |
| `metrics.service.clusterIP`                                 | Static clusterIP or None for headless services                                                             | `""`                                |
| `metrics.service.sessionAffinity`                           | Control where client requests go, to the same pod or round-robin                                           | `None`                              |
| `metrics.service.annotations`                               | Annotations for Prometheus to auto-discover the metrics endpoint                                           | `{}`                                |
| `metrics.serviceMonitor.enabled`                            | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator                              | `false`                             |
| `metrics.serviceMonitor.namespace`                          | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)                              | `""`                                |
| `metrics.serviceMonitor.interval`                           | Interval at which metrics should be scraped.                                                               | `""`                                |
| `metrics.serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                    | `""`                                |
| `metrics.serviceMonitor.labels`                             | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                      | `{}`                                |
| `metrics.serviceMonitor.selector`                           | Prometheus instance selector labels                                                                        | `{}`                                |
| `metrics.serviceMonitor.relabelings`                        | RelabelConfigs to apply to samples before scraping                                                         | `[]`                                |
| `metrics.serviceMonitor.metricRelabelings`                  | MetricRelabelConfigs to apply to samples before ingestion                                                  | `[]`                                |
| `metrics.serviceMonitor.honorLabels`                        | Specify honorLabels parameter to add the scrape endpoint                                                   | `false`                             |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in prometheus.                          | `""`                                |
| `metrics.prometheusRule.enabled`                            | Create a PrometheusRule for Prometheus Operator                                                            | `false`                             |
| `metrics.prometheusRule.namespace`                          | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                              | `""`                                |
| `metrics.prometheusRule.labels`                             | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                      | `{}`                                |
| `metrics.prometheusRule.rules`                              | PrometheusRule definitions                                                                                 | `[]`                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    --set auth.postgresPassword=secretpassword
    oci://REGISTRY_NAME/REPOSITORY_NAME/postgresql
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the PostgreSQL `postgres` account password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.
> **Warning** Setting a password will be ignored on new installation in case when previous PostgreSQL release was deleted through the helm command. In that case, old PVC will have an old password, and setting it through helm won't take effect. Deleting persistent volumes (PVs) will solve the issue. Refer to [issue 2061](https://github.com/bitnami/charts/issues/2061) for more details

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/postgresql
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/postgresql/values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Customizing primary and read replica services in a replicated configuration

At the top level, there is a service object which defines the services for both primary and readReplicas. For deeper customization, there are service objects for both the primary and read types individually. This allows you to override the values in the top level service object so that the primary and read can be of different service types and with different clusterIPs / nodePorts. Also in the case you want the primary and read to be of type nodePort, you will need to set the nodePorts to different values to prevent a collision. The values that are deeper in the primary.service or readReplicas.service objects will take precedence over the top level service object.

### Use a different PostgreSQL version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter. Refer to the [chart documentation for more information on these parameters and how to use them with images from a private registry](https://docs.bitnami.com/kubernetes/infrastructure/postgresql/configuration/change-image-version/).

### postgresql.conf / pg_hba.conf files as configMap

This helm chart also supports to customize the PostgreSQL configuration file. You can add additional PostgreSQL configuration parameters using the `primary.extendedConfiguration`/`readReplicas.extendedConfiguration` parameters as a string. Alternatively, to replace the entire default configuration use `primary.configuration`.

You can also add a custom pg_hba.conf using the `primary.pgHbaConfiguration` parameter.

In addition to these options, you can also set an external ConfigMap with all the configuration files. This is done by setting the `primary.existingConfigmap` parameter. Note that this will override the two previous options.

### Initialize a fresh instance

The [Bitnami PostgreSQL](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify custom scripts using the `primary.initdb.scripts` parameter as a string.

In addition, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `primary.initdb.scriptsConfigMap` parameter. Note that this will override the two previous options. If your initialization scripts contain sensitive information such as credentials or passwords, you can use the `primary.initdb.scriptsSecret` parameter.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

### Securing traffic using TLS

TLS support can be enabled in the chart by specifying the `tls.` parameters while creating a release. The following parameters should be configured to properly enable the TLS support in the chart:

- `tls.enabled`: Enable TLS support. Defaults to `false`
- `tls.certificatesSecret`: Name of an existing secret that contains the certificates. No defaults.
- `tls.certFilename`: Certificate filename. No defaults.
- `tls.certKeyFilename`: Certificate key filename. No defaults.

For example:

- First, create the secret with the cetificates files:

    ```console
    kubectl create secret generic certificates-tls-secret --from-file=./cert.crt --from-file=./cert.key --from-file=./ca.crt
    ```

- Then, use the following parameters:

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

```text
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

```text
postgresql.auth.username=testuser
subchart1.postgresql.auth.username=testuser
subchart2.postgresql.auth.username=testuser
postgresql.auth.password=testpass
subchart1.postgresql.auth.password=testpass
subchart2.postgresql.auth.password=testpass
postgresql.auth.database=testdb
subchart1.postgresql.auth.database=testdb
subchart2.postgresql.auth.database=testdb
```

If the number of dependent sub-charts increases, installing the chart with parameters can become increasingly difficult. An alternative would be to set the credentials using global variables as follows:

```text
global.postgresql.auth.username=testuser
global.postgresql.auth.password=testpass
global.postgresql.auth.database=testdb
```

This way, the credentials will be available in all of the subcharts.

## Persistence

The [Bitnami PostgreSQL](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) image stores the PostgreSQL data and configurations at the `/bitnami/postgresql` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

If you already have data in it, you will fail to sync to standby nodes for all commits, details can refer to the [code present in the container repository](https://github.com/bitnami/containers/tree/main/bitnami/postgresql). If you need to use those data, please covert them to sql and import after `helm install` finished.

## NetworkPolicy

To enable network policy for PostgreSQL, install [a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin), and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

```console
kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"
```

With NetworkPolicy enabled, traffic will be limited to just port 5432.

For more precise policy, set `networkPolicy.allowExternal=false`. This will only allow pods with the generated client label to connect to PostgreSQL.
This label will be displayed in the output of a successful install.

## Differences between Bitnami PostgreSQL image and [Docker Official](https://hub.docker.com/_/postgres) image

- The Docker Official PostgreSQL image does not support replication. If you pass any replication environment variable, this would be ignored. The only environment variables supported by the Docker Official image are POSTGRES_USER, POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_INITDB_ARGS, POSTGRES_INITDB_WALDIR and PGDATA. All the remaining environment variables are specific to the Bitnami PostgreSQL image.
- The Bitnami PostgreSQL image is non-root by default. This requires that you run the pod with `securityContext` and updates the permissions of the volume with an `initContainer`. A key benefit of this configuration is that the pod follows security best practices and is prepared to run on Kubernetes distributions with hard security constraints like OpenShift.
- For OpenShift up to 4.10, let set the volume permissions, security context, runAsUser and fsGroup automatically by OpenShift and disable the predefined settings of the helm chart: primary.securityContext.enabled=false,primary.containerSecurityContext.enabled=false,volumePermissions.enabled=false,shmVolume.enabled=false
- For OpenShift 4.11 and higher, let set OpenShift the runAsUser and fsGroup automatically. Configure the pod and container security context to restrictive defaults and disable the volume permissions setup: primary.
    podSecurityContext.fsGroup=null,primary.podSecurityContext.seccompProfile.type=RuntimeDefault,primary.containerSecurityContext.runAsUser=null,primary.containerSecurityContext.allowPrivilegeEscalation=false,primary.containerSecurityContext.runAsNonRoot=true,primary.containerSecurityContext.seccompProfile.type=RuntimeDefault,primary.containerSecurityContext.capabilities.drop=['ALL'],volumePermissions.enabled=false,shmVolume.enabled=false

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 13.0.0

This major version changes the default PostgreSQL image from 15.x to 16.x. Follow the [official instructions](https://www.postgresql.org/docs/16/upgrading.html) to upgrade to 16.x.

### To 12.0.0

This major version changes the default PostgreSQL image from 14.x to 15.x. Follow the [official instructions](https://www.postgresql.org/docs/15/upgrading.html) to upgrade to 15.x.

### To any previous version

Refer to the [chart documentation for more information about how to upgrade from previous releases](https://docs.bitnami.com/kubernetes/infrastructure/postgresql/administration/upgrade/).

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