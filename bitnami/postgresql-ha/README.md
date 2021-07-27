# PostgreSQL HA

This Helm chart has been developed based on [bitnami/postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) chart but including some changes to guarantee high availability such as:

- A new deployment, service have been added to deploy [Pgpool-II](Pgpool-II) to act as proxy for PostgreSQL backend. It helps to reduce connection overhead, acts as a load balancer for PostgreSQL, and ensures database node failover.
- Replacing `bitnami/postgresql` with `bitnami/postgresql-repmgr` which includes and configures [repmgr](https://repmgr.org/). Repmgr ensures standby nodes assume the primary role when the primary node is unhealthy.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/postgresql-ha
```

## Introduction

This [Helm](https://github.com/kubernetes/helm) chart installs [PostgreSQL](https://www.postgresql.org/) with HA architecture in a Kubernetes cluster. Welcome to [contribute](CONTRIBUTING.md) to Helm Chart for PostgreSQL HA.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

Install the PostgreSQL HA helm chart with a release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/postgresql-ha
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete --purge my-release
```

Additionally, if `persistence.resourcePolicy` is set to `keep`, you should manually delete the PVCs.

## Parameters

### Global parameters

| Name                               | Description                                                                                     | Value |
| ---------------------------------- | ----------------------------------------------------------------------------------------------- | ----- |
| `global.imageRegistry`             | Global Docker image registry                                                                    | `""`  |
| `global.imagePullSecrets`          | Global Docker registry secret names as an array                                                 | `[]`  |
| `global.storageClass`              | Global StorageClass for Persistent Volume(s)                                                    | `""`  |
| `global.postgresql.username`       | PostgreSQL username (overrides `postgresql.username`)                                           | `""`  |
| `global.postgresql.password`       | PostgreSQL password (overrides `postgresql.password`)                                           | `""`  |
| `global.postgresql.database`       | PostgreSQL database (overrides `postgresql.database`)                                           | `""`  |
| `global.postgresql.repmgrUsername` | PostgreSQL repmgr username (overrides `postgresql.repmgrUsername`)                              | `""`  |
| `global.postgresql.repmgrPassword` | PostgreSQL repmgr password (overrides `postgresql.repmgrpassword`)                              | `""`  |
| `global.postgresql.repmgrDatabase` | PostgreSQL repmgr database (overrides `postgresql.repmgrDatabase`)                              | `""`  |
| `global.postgresql.existingSecret` | Name of existing secret to use for PostgreSQL passwords (overrides `postgresql.existingSecret`) | `""`  |
| `global.ldap.bindpw`               | LDAP bind password (overrides `ldap.bindpw`)                                                    | `""`  |
| `global.ldap.existingSecret`       | Name of existing secret to use for LDAP passwords (overrides `ldap.existingSecret`)             | `""`  |
| `global.pgpool.adminUsername`      | Pgpool Admin username (overrides `pgpool.adminUsername`)                                        | `""`  |
| `global.pgpool.adminPassword`      | Pgpool Admin password (overrides `pgpool.adminPassword`)                                        | `""`  |
| `global.pgpool.existingSecret`     | Pgpool existing secret                                                                          | `""`  |


### General parameters

| Name                     | Description                                                                                                           | Value           |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name)                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                                               | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                                             | `cluster.local` |
| `commonAnnotations`      | Common annotations to add to all resources (sub-charts are not considered). Evaluated as a template                   | `{}`            |
| `commonLabels`           | Common labels to add to all resources (sub-charts are not considered). Evaluated as a template                        | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template)                                           | `[]`            |
| `serviceAccount.enabled` | Enable service account (Note: Service Account will only be automatically created if `serviceAccount.name` is not set) | `false`         |
| `serviceAccount.name`    | Name of an already existing service account. Setting this value disables the automatic service account creation       | `""`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                               | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                                  | `[]`            |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                                     | `[]`            |


### PostgreSQL with Repmgr parameters

| Name                                            | Description                                                                                                                                                                                                   | Value                       |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `postgresqlImage.registry`                      | PostgreSQL with Repmgr image registry                                                                                                                                                                         | `docker.io`                 |
| `postgresqlImage.repository`                    | PostgreSQL with Repmgr image repository                                                                                                                                                                       | `bitnami/postgresql-repmgr` |
| `postgresqlImage.tag`                           | PostgreSQL with Repmgr image tag                                                                                                                                                                              | `11.12.0-debian-10-r44`     |
| `postgresqlImage.pullPolicy`                    | PostgreSQL with Repmgr image pull policy                                                                                                                                                                      | `IfNotPresent`              |
| `postgresqlImage.pullSecrets`                   | Specify docker-registry secret names as an array                                                                                                                                                              | `[]`                        |
| `postgresqlImage.debug`                         | Specify if debug logs should be enabled                                                                                                                                                                       | `false`                     |
| `postgresql.labels`                             | Labels to add to the StatefulSet. Evaluated as template                                                                                                                                                       | `{}`                        |
| `postgresql.podLabels`                          | Labels to add to the StatefulSet pods. Evaluated as template                                                                                                                                                  | `{}`                        |
| `postgresql.replicaCount`                       | Number of replicas to deploy                                                                                                                                                                                  | `2`                         |
| `postgresql.updateStrategyType`                 | Update strategy for PostgreSQL statefulset                                                                                                                                                                    | `RollingUpdate`             |
| `postgresql.hostAliases`                        | Deployment pod host aliases                                                                                                                                                                                   | `[]`                        |
| `postgresql.podAnnotations`                     | Additional pod annotations                                                                                                                                                                                    | `{}`                        |
| `postgresql.priorityClassName`                  | Pod priority class                                                                                                                                                                                            | `""`                        |
| `postgresql.podAffinityPreset`                  | PostgreSQL pod affinity preset. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`                                                                                                     | `""`                        |
| `postgresql.podAntiAffinityPreset`              | PostgreSQL pod anti-affinity preset. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`                                                                                                | `soft`                      |
| `postgresql.nodeAffinityPreset.type`            | PostgreSQL node affinity preset type. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`                                                                                               | `""`                        |
| `postgresql.nodeAffinityPreset.key`             | PostgreSQL node label key to match Ignored if `postgresql.affinity` is set.                                                                                                                                   | `""`                        |
| `postgresql.nodeAffinityPreset.values`          | PostgreSQL node label values to match. Ignored if `postgresql.affinity` is set.                                                                                                                               | `[]`                        |
| `postgresql.affinity`                           | Affinity for PostgreSQL pods assignment                                                                                                                                                                       | `{}`                        |
| `postgresql.nodeSelector`                       | Node labels for PostgreSQL pods assignment                                                                                                                                                                    | `{}`                        |
| `postgresql.tolerations`                        | Tolerations for PostgreSQL pods assignment                                                                                                                                                                    | `[]`                        |
| `postgresql.securityContext.enabled`            | Enable security context for PostgreSQL with Repmgr                                                                                                                                                            | `true`                      |
| `postgresql.securityContext.fsGroup`            | Group ID for the PostgreSQL with Repmgr filesystem                                                                                                                                                            | `1001`                      |
| `postgresql.containerSecurityContext.enabled`   | Enable container security context                                                                                                                                                                             | `true`                      |
| `postgresql.containerSecurityContext.runAsUser` | User ID for the PostgreSQL with Repmgr container                                                                                                                                                              | `1001`                      |
| `postgresql.customLivenessProbe`                | Override default liveness probe                                                                                                                                                                               | `{}`                        |
| `postgresql.customReadinessProbe`               | Override default readiness probe                                                                                                                                                                              | `{}`                        |
| `postgresql.customStartupProbe`                 | Override default startup probe                                                                                                                                                                                | `{}`                        |
| `postgresql.command`                            | Override default container command (useful when using custom images)                                                                                                                                          | `[]`                        |
| `postgresql.args`                               | Override default container args (useful when using custom images)                                                                                                                                             | `[]`                        |
| `postgresql.lifecycleHooks`                     | LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template                                                                                            | `{}`                        |
| `postgresql.extraEnvVars`                       | Array containing extra environment variables                                                                                                                                                                  | `[]`                        |
| `postgresql.extraEnvVarsCM`                     | ConfigMap with extra environment variables                                                                                                                                                                    | `""`                        |
| `postgresql.extraEnvVarsSecret`                 | Secret with extra environment variables                                                                                                                                                                       | `""`                        |
| `postgresql.extraVolumes`                       | Extra volumes to add to the deployment                                                                                                                                                                        | `[]`                        |
| `postgresql.extraVolumeMounts`                  | Extra volume mounts to add to the container. Normally used with `extraVolumes`.                                                                                                                               | `[]`                        |
| `postgresql.initContainers`                     | Extra init containers to add to the deployment                                                                                                                                                                | `[]`                        |
| `postgresql.sidecars`                           | Extra sidecar containers to add to the deployment                                                                                                                                                             | `[]`                        |
| `postgresql.resources.limits`                   | The resources limits for the container                                                                                                                                                                        | `{}`                        |
| `postgresql.resources.requests`                 | The requested resources for the container                                                                                                                                                                     | `{}`                        |
| `postgresql.livenessProbe.enabled`              | Enable livenessProbe                                                                                                                                                                                          | `true`                      |
| `postgresql.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                                                                                                       | `30`                        |
| `postgresql.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                                                                                                              | `10`                        |
| `postgresql.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                                                                                                             | `5`                         |
| `postgresql.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                                                                                                           | `6`                         |
| `postgresql.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                                                                                                           | `1`                         |
| `postgresql.readinessProbe.enabled`             | Enable readinessProbe                                                                                                                                                                                         | `true`                      |
| `postgresql.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                                                                                                      | `5`                         |
| `postgresql.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                                                                                                             | `10`                        |
| `postgresql.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                                                                                                            | `5`                         |
| `postgresql.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                                                                                                          | `6`                         |
| `postgresql.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                                                                                                          | `1`                         |
| `postgresql.startupProbe.enabled`               | Enable startupProbe                                                                                                                                                                                           | `false`                     |
| `postgresql.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                                                                                                                        | `5`                         |
| `postgresql.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                                                                                                               | `10`                        |
| `postgresql.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                                                                                                              | `5`                         |
| `postgresql.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                                                                                                            | `10`                        |
| `postgresql.startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                                                                                                            | `1`                         |
| `postgresql.pdb.create`                         | Specifies whether to create a Pod disruption budget for PostgreSQL with Repmgr                                                                                                                                | `false`                     |
| `postgresql.pdb.minAvailable`                   | Minimum number / percentage of pods that should remain scheduled                                                                                                                                              | `1`                         |
| `postgresql.pdb.maxUnavailable`                 | Maximum number / percentage of pods that may be made unavailable                                                                                                                                              | `""`                        |
| `postgresql.username`                           | PostgreSQL username                                                                                                                                                                                           | `postgres`                  |
| `postgresql.password`                           | PostgreSQL password                                                                                                                                                                                           | `""`                        |
| `postgresql.database`                           | PostgreSQL database                                                                                                                                                                                           | `""`                        |
| `postgresql.existingSecret`                     | PostgreSQL password using existing secret                                                                                                                                                                     | `""`                        |
| `postgresql.postgresPassword`                   | PostgreSQL password for the `postgres` user when `username` is not `postgres`                                                                                                                                 | `""`                        |
| `postgresql.usePasswordFile`                    | Set to `true` to mount PostgreSQL secret as a file instead of passing environment variable                                                                                                                    | `""`                        |
| `postgresql.repmgrUsePassfile`                  | Set to `true` to configure repmgrl to use `passfile` instead of `password` vars*:*:*:username:password" and use it to configure Repmgr instead of using password (Requires Postgresql 10+, otherwise ignored) | `""`                        |
| `postgresql.repmgrPassfilePath`                 | Custom path where `passfile` will be stored                                                                                                                                                                   | `""`                        |
| `postgresql.upgradeRepmgrExtension`             | Upgrade repmgr extension in the database                                                                                                                                                                      | `false`                     |
| `postgresql.pgHbaTrustAll`                      | Configures PostgreSQL HBA to trust every user                                                                                                                                                                 | `false`                     |
| `postgresql.syncReplication`                    | Make the replication synchronous. This will wait until the data is synchronized in all the replicas before other query can be run. This ensures the data availability at the expenses of speed.               | `false`                     |
| `postgresql.repmgrUsername`                     | PostgreSQL Repmgr username                                                                                                                                                                                    | `repmgr`                    |
| `postgresql.repmgrPassword`                     | PostgreSQL Repmgr password                                                                                                                                                                                    | `""`                        |
| `postgresql.repmgrDatabase`                     | PostgreSQL Repmgr database                                                                                                                                                                                    | `repmgr`                    |
| `postgresql.repmgrLogLevel`                     | Repmgr log level (DEBUG, INFO, NOTICE, WARNING, ERROR, ALERT, CRIT or EMERG)                                                                                                                                  | `NOTICE`                    |
| `postgresql.repmgrConnectTimeout`               | Repmgr backend connection timeout (in seconds)                                                                                                                                                                | `5`                         |
| `postgresql.repmgrReconnectAttempts`            | Repmgr backend reconnection attempts                                                                                                                                                                          | `3`                         |
| `postgresql.repmgrReconnectInterval`            | Repmgr backend reconnection interval (in seconds)                                                                                                                                                             | `5`                         |
| `postgresql.audit.logHostname`                  | Add client hostnames to the log file                                                                                                                                                                          | `true`                      |
| `postgresql.audit.logConnections`               | Add client log-in operations to the log file                                                                                                                                                                  | `false`                     |
| `postgresql.audit.logDisconnections`            | Add client log-outs operations to the log file                                                                                                                                                                | `false`                     |
| `postgresql.audit.pgAuditLog`                   | Add operations to log using the pgAudit extension                                                                                                                                                             | `""`                        |
| `postgresql.audit.pgAuditLogCatalog`            | Log catalog using pgAudit                                                                                                                                                                                     | `off`                       |
| `postgresql.audit.clientMinMessages`            | Message log level to share with the user                                                                                                                                                                      | `error`                     |
| `postgresql.audit.logLinePrefix`                | Template string for the log line prefix                                                                                                                                                                       | `""`                        |
| `postgresql.audit.logTimezone`                  | Timezone for the log timestamps                                                                                                                                                                               | `""`                        |
| `postgresql.sharedPreloadLibraries`             | Shared preload libraries (comma-separated list)                                                                                                                                                               | `pgaudit, repmgr`           |
| `postgresql.maxConnections`                     | Maximum total connections                                                                                                                                                                                     | `""`                        |
| `postgresql.postgresConnectionLimit`            | Maximum connections for the postgres user                                                                                                                                                                     | `""`                        |
| `postgresql.dbUserConnectionLimit`              | Maximum connections for the created user                                                                                                                                                                      | `""`                        |
| `postgresql.tcpKeepalivesInterval`              | TCP keepalives interval                                                                                                                                                                                       | `""`                        |
| `postgresql.tcpKeepalivesIdle`                  | TCP keepalives idle                                                                                                                                                                                           | `""`                        |
| `postgresql.tcpKeepalivesCount`                 | TCP keepalives count                                                                                                                                                                                          | `""`                        |
| `postgresql.statementTimeout`                   | Statement timeout                                                                                                                                                                                             | `""`                        |
| `postgresql.pghbaRemoveFilters`                 | Comma-separated list of patterns to remove from the pg_hba.conf file                                                                                                                                          | `""`                        |
| `postgresql.extraInitContainers`                | Extra init containers                                                                                                                                                                                         | `[]`                        |
| `postgresql.repmgrConfiguration`                | Repmgr configuration                                                                                                                                                                                          | `""`                        |
| `postgresql.configuration`                      | PostgreSQL configuration                                                                                                                                                                                      | `""`                        |
| `postgresql.pgHbaConfiguration`                 | PostgreSQL client authentication configuration                                                                                                                                                                | `""`                        |
| `postgresql.configurationCM`                    | Name of existing ConfigMap with configuration files                                                                                                                                                           | `""`                        |
| `postgresql.extendedConf`                       | Extended PostgreSQL configuration (appended to main or default configuration). Implies `volumePermissions.enabled`.                                                                                           | `""`                        |
| `postgresql.extendedConfCM`                     | ConfigMap with PostgreSQL extended configuration                                                                                                                                                              | `""`                        |
| `postgresql.initdbScripts`                      | Dictionary of initdb scripts                                                                                                                                                                                  | `{}`                        |
| `postgresql.initdbScriptsCM`                    | ConfigMap with scripts to be run at first boot                                                                                                                                                                | `""`                        |
| `postgresql.initdbScriptsSecret`                | Secret with scripts to be run at first boot                                                                                                                                                                   | `""`                        |
| `postgresql.tls.enabled`                        | Enable TLS traffic support for end-client connections                                                                                                                                                         | `false`                     |
| `postgresql.tls.preferServerCiphers`            | Whether to use the server's TLS cipher preferences rather than the client's                                                                                                                                   | `true`                      |
| `postgresql.tls.certificatesSecret`             | Name of an existing secret that contains the certificates                                                                                                                                                     | `""`                        |
| `postgresql.tls.certFilename`                   | Certificate filename                                                                                                                                                                                          | `""`                        |
| `postgresql.tls.certKeyFilename`                | Certificate key filename                                                                                                                                                                                      | `""`                        |
| `postgresql.tls.certCAFilename`                 | CA Certificate filename                                                                                                                                                                                       | `""`                        |


### Pgpool parameters

| Name                                        | Description                                                                                                        | Value                 |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | --------------------- |
| `pgpoolImage.registry`                      | Pgpool image registry                                                                                              | `docker.io`           |
| `pgpoolImage.repository`                    | Pgpool image repository                                                                                            | `bitnami/pgpool`      |
| `pgpoolImage.tag`                           | Pgpool image tag                                                                                                   | `4.2.3-debian-10-r38` |
| `pgpoolImage.pullPolicy`                    | Pgpool image pull policy                                                                                           | `IfNotPresent`        |
| `pgpoolImage.pullSecrets`                   | Specify docker-registry secret names as an array                                                                   | `[]`                  |
| `pgpoolImage.debug`                         | Specify if debug logs should be enabled                                                                            | `false`               |
| `pgpool.customUsers`                        | Additional users that will be performing connections to the database using                                         | `{}`                  |
| `pgpool.usernames`                          | Comma or semicolon separated list of postgres usernames                                                            | `""`                  |
| `pgpool.passwords`                          | Comma or semicolon separated list of the associated passwords for the users above                                  | `""`                  |
| `pgpool.hostAliases`                        | Deployment pod host aliases                                                                                        | `[]`                  |
| `pgpool.customUsersSecret`                  | Name of a secret containing the usernames and passwords of accounts that will be added to pgpool_passwd            | `""`                  |
| `pgpool.srCheckDatabase`                    | Name of the database to perform streaming replication checks                                                       | `postgres`            |
| `pgpool.labels`                             | Labels to add to the Deployment. Evaluated as template                                                             | `{}`                  |
| `pgpool.podLabels`                          | Labels to add to the pods. Evaluated as template                                                                   | `{}`                  |
| `pgpool.serviceLabels`                      | Labels to add to the service. Evaluated as template                                                                | `{}`                  |
| `pgpool.customLivenessProbe`                | Override default liveness probe                                                                                    | `{}`                  |
| `pgpool.customReadinessProbe`               | Override default readiness probe                                                                                   | `{}`                  |
| `pgpool.customStartupProbe`                 | Override default startup probe                                                                                     | `{}`                  |
| `pgpool.command`                            | Override default container command (useful when using custom images)                                               | `[]`                  |
| `pgpool.args`                               | Override default container args (useful when using custom images)                                                  | `[]`                  |
| `pgpool.lifecycleHooks`                     | LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template | `{}`                  |
| `pgpool.extraEnvVars`                       | Array containing extra environment variables                                                                       | `[]`                  |
| `pgpool.extraEnvVarsCM`                     | ConfigMap with extra environment variables                                                                         | `""`                  |
| `pgpool.extraEnvVarsSecret`                 | Secret with extra environment variables                                                                            | `""`                  |
| `pgpool.extraVolumes`                       | Extra volumes to add to the deployment                                                                             | `[]`                  |
| `pgpool.extraVolumeMounts`                  | Extra volume mounts to add to the container. Normally used with `extraVolumes`                                     | `[]`                  |
| `pgpool.initContainers`                     | Extra init containers to add to the deployment                                                                     | `[]`                  |
| `pgpool.sidecars`                           | Extra sidecar containers to add to the deployment                                                                  | `[]`                  |
| `pgpool.replicaCount`                       | The number of replicas to deploy                                                                                   | `1`                   |
| `pgpool.podAnnotations`                     | Additional pod annotations                                                                                         | `{}`                  |
| `pgpool.priorityClassName`                  | Pod priority class                                                                                                 | `""`                  |
| `pgpool.podAffinityPreset`                  | Pgpool pod affinity preset. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`                  | `""`                  |
| `pgpool.podAntiAffinityPreset`              | Pgpool pod anti-affinity preset. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`             | `soft`                |
| `pgpool.nodeAffinityPreset.type`            | Pgpool node affinity preset type. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`            | `""`                  |
| `pgpool.nodeAffinityPreset.key`             | Pgpool node label key to match Ignored if `pgpool.affinity` is set.                                                | `""`                  |
| `pgpool.nodeAffinityPreset.values`          | Pgpool node label values to match. Ignored if `pgpool.affinity` is set.                                            | `[]`                  |
| `pgpool.affinity`                           | Affinity for Pgpool pods assignment                                                                                | `{}`                  |
| `pgpool.nodeSelector`                       | Node labels for Pgpool pods assignment                                                                             | `{}`                  |
| `pgpool.tolerations`                        | Tolerations for Pgpool pods assignment                                                                             | `[]`                  |
| `pgpool.securityContext.enabled`            | Enable security context for Pgpool                                                                                 | `true`                |
| `pgpool.securityContext.fsGroup`            | Group ID for the Pgpool filesystem                                                                                 | `1001`                |
| `pgpool.containerSecurityContext.enabled`   | Enable container security context                                                                                  | `true`                |
| `pgpool.containerSecurityContext.runAsUser` | User ID for the Pgpool container                                                                                   | `1001`                |
| `pgpool.resources.limits`                   | The resources limits for the container                                                                             | `{}`                  |
| `pgpool.resources.requests`                 | The requested resources for the container                                                                          | `{}`                  |
| `pgpool.livenessProbe.enabled`              | Enable livenessProbe                                                                                               | `true`                |
| `pgpool.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                            | `30`                  |
| `pgpool.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                   | `10`                  |
| `pgpool.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                  | `5`                   |
| `pgpool.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                | `5`                   |
| `pgpool.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                | `1`                   |
| `pgpool.readinessProbe.enabled`             | Enable readinessProbe                                                                                              | `true`                |
| `pgpool.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                           | `5`                   |
| `pgpool.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                  | `5`                   |
| `pgpool.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                 | `5`                   |
| `pgpool.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                               | `5`                   |
| `pgpool.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                               | `1`                   |
| `pgpool.startupProbe.enabled`               | Enable startupProbe                                                                                                | `false`               |
| `pgpool.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                             | `5`                   |
| `pgpool.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                    | `10`                  |
| `pgpool.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                   | `5`                   |
| `pgpool.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                 | `10`                  |
| `pgpool.startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                 | `1`                   |
| `pgpool.pdb.create`                         | Specifies whether a Pod disruption budget should be created for Pgpool pods                                        | `false`               |
| `pgpool.pdb.minAvailable`                   | Minimum number / percentage of pods that should remain scheduled                                                   | `1`                   |
| `pgpool.pdb.maxUnavailable`                 | Maximum number / percentage of pods that may be made unavailable                                                   | `""`                  |
| `pgpool.updateStrategy`                     | Strategy used to replace old Pods by new ones                                                                      | `{}`                  |
| `pgpool.minReadySeconds`                    | How many seconds a pod needs to be ready before killing the next, during update                                    | `""`                  |
| `pgpool.adminUsername`                      | Pgpool Admin username                                                                                              | `admin`               |
| `pgpool.adminPassword`                      | Pgpool Admin password                                                                                              | `""`                  |
| `pgpool.logConnections`                     | Log all client connections (PGPOOL_ENABLE_LOG_CONNECTIONS)                                                         | `false`               |
| `pgpool.logHostname`                        | Log the client hostname instead of IP address (PGPOOL_ENABLE_LOG_HOSTNAME)                                         | `true`                |
| `pgpool.logPerNodeStatement`                | Log every SQL statement for each DB node separately (PGPOOL_ENABLE_LOG_PER_NODE_STATEMENT)                         | `false`               |
| `pgpool.logLinePrefix`                      | Format of the log entry lines (PGPOOL_LOG_LINE_PREFIX)                                                             | `""`                  |
| `pgpool.clientMinMessages`                  | Log level for clients                                                                                              | `error`               |
| `pgpool.numInitChildren`                    | The number of preforked Pgpool-II server processes. It is also the concurrent                                      | `""`                  |
| `pgpool.maxPool`                            | The maximum number of cached connections in each child process (PGPOOL_MAX_POOL)                                   | `""`                  |
| `pgpool.childMaxConnections`                | The maximum number of client connections in each child process (PGPOOL_CHILD_MAX_CONNECTIONS)                      | `""`                  |
| `pgpool.childLifeTime`                      | The time in seconds to terminate a Pgpool-II child process if it remains idle (PGPOOL_CHILD_LIFE_TIME)             | `""`                  |
| `pgpool.clientIdleLimit`                    | The time in seconds to disconnect a client if it remains idle since the last query (PGPOOL_CLIENT_IDLE_LIMIT)      | `""`                  |
| `pgpool.connectionLifeTime`                 | The time in seconds to terminate the cached connections to the PostgreSQL backend (PGPOOL_CONNECTION_LIFE_TIME)    | `""`                  |
| `pgpool.useLoadBalancing`                   | Use Pgpool Load-Balancing                                                                                          | `true`                |
| `pgpool.configuration`                      | Pgpool configuration                                                                                               | `{}`                  |
| `pgpool.configurationCM`                    | ConfigMap with Pgpool configuration                                                                                | `""`                  |
| `pgpool.initdbScripts`                      | Dictionary of initdb scripts                                                                                       | `{}`                  |
| `pgpool.initdbScriptsCM`                    | ConfigMap with scripts to be run every time Pgpool container is initialized                                        | `""`                  |
| `pgpool.initdbScriptsSecret`                | Secret with scripts to be run every time Pgpool container is initialized                                           | `""`                  |
| `pgpool.tls.enabled`                        | Enable TLS traffic support for end-client connections                                                              | `false`               |
| `pgpool.tls.autoGenerated`                  | Create self-signed TLS certificates. Currently only supports PEM certificates                                      | `false`               |
| `pgpool.tls.preferServerCiphers`            | Whether to use the server's TLS cipher preferences rather than the client's                                        | `true`                |
| `pgpool.tls.certificatesSecret`             | Name of an existing secret that contains the certificates                                                          | `""`                  |
| `pgpool.tls.certFilename`                   | Certificate filename                                                                                               | `""`                  |
| `pgpool.tls.certKeyFilename`                | Certificate key filename                                                                                           | `""`                  |
| `pgpool.tls.certCAFilename`                 | CA Certificate filename                                                                                            | `""`                  |


### LDAP parameters

| Name                            | Description                                                  | Value        |
| ------------------------------- | ------------------------------------------------------------ | ------------ |
| `ldap.enabled`                  | Enable LDAP support                                          | `false`      |
| `ldap.existingSecret`           | Name of existing secret to use for LDAP passwords            | `""`         |
| `ldap.uri`                      | LDAP URL beginning in the form `ldap[s]://<hostname>:<port>` | `""`         |
| `ldap.base`                     | LDAP base DN                                                 | `""`         |
| `ldap.binddn`                   | LDAP bind DN                                                 | `""`         |
| `ldap.bindpw`                   | LDAP bind password                                           | `""`         |
| `ldap.bslookup`                 | LDAP base lookup                                             | `""`         |
| `ldap.scope`                    | LDAP search scope                                            | `""`         |
| `ldap.tlsReqcert`               | LDAP TLS check on server certificates                        | `""`         |
| `ldap.nssInitgroupsIgnoreusers` | LDAP ignored users                                           | `root,nslcd` |


### Metrics parameters

| Name                                         | Description                                                                                            | Value                       |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------ | --------------------------- |
| `metricsImage.registry`                      | PostgreSQL Prometheus exporter image registry                                                          | `docker.io`                 |
| `metricsImage.repository`                    | PostgreSQL Prometheus exporter image repository                                                        | `bitnami/postgres-exporter` |
| `metricsImage.tag`                           | PostgreSQL Prometheus exporter image tag                                                               | `0.9.0-debian-10-r108`      |
| `metricsImage.pullPolicy`                    | PostgreSQL Prometheus exporter image pull policy                                                       | `IfNotPresent`              |
| `metricsImage.pullSecrets`                   | Specify docker-registry secret names as an array                                                       | `[]`                        |
| `metricsImage.debug`                         | Specify if debug logs should be enabled                                                                | `false`                     |
| `metrics.enabled`                            | Enable PostgreSQL Prometheus exporter                                                                  | `false`                     |
| `metrics.securityContext.enabled`            | Enable security context for PostgreSQL Prometheus exporter                                             | `true`                      |
| `metrics.securityContext.runAsUser`          | User ID for the PostgreSQL Prometheus exporter container                                               | `1001`                      |
| `metrics.resources.limits`                   | The resources limits for the container                                                                 | `{}`                        |
| `metrics.resources.requests`                 | The requested resources for the container                                                              | `{}`                        |
| `metrics.livenessProbe.enabled`              | Enable livenessProbe                                                                                   | `true`                      |
| `metrics.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                | `30`                        |
| `metrics.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                       | `10`                        |
| `metrics.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                      | `5`                         |
| `metrics.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                    | `6`                         |
| `metrics.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                    | `1`                         |
| `metrics.readinessProbe.enabled`             | Enable readinessProbe                                                                                  | `true`                      |
| `metrics.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                               | `5`                         |
| `metrics.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                      | `10`                        |
| `metrics.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                     | `5`                         |
| `metrics.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                   | `6`                         |
| `metrics.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                   | `1`                         |
| `metrics.startupProbe.enabled`               | Enable startupProbe                                                                                    | `false`                     |
| `metrics.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                 | `5`                         |
| `metrics.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                        | `10`                        |
| `metrics.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                       | `5`                         |
| `metrics.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                     | `10`                        |
| `metrics.startupProbe.successThreshold`      | Success threshold for startupProbe                                                                     | `1`                         |
| `metrics.annotations`                        | Annotations for PostgreSQL Prometheus exporter service                                                 | `{}`                        |
| `metrics.customMetrics`                      | Additional custom metrics                                                                              | `""`                        |
| `metrics.extraEnvVars`                       | An array to add extra environment variables to configure postgres-exporter                             | `{}`                        |
| `metrics.serviceMonitor.enabled`             | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                     |
| `metrics.serviceMonitor.namespace`           | Optional namespace which Prometheus is running in                                                      | `""`                        |
| `metrics.serviceMonitor.interval`            | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                 | `""`                        |
| `metrics.serviceMonitor.scrapeTimeout`       | Service monitor scrape timeout                                                                         | `""`                        |
| `metrics.serviceMonitor.selector`            | (https://github.com/bitnami/charts/tree/master/bitnami/prometheus-operator#tldr)                       | `{}`                        |
| `metrics.serviceMonitor.relabelings`         | ServiceMonitor relabelings. Value is evaluated as a template                                           | `[]`                        |
| `metrics.serviceMonitor.metricRelabelings`   | ServiceMonitor metricRelabelings. Value is evaluated as a template                                     | `[]`                        |


### Volume permissions parameters

| Name                                          | Description                                         | Value                   |
| --------------------------------------------- | --------------------------------------------------- | ----------------------- |
| `volumePermissionsImage.registry`             | Init container volume-permissions image registry    | `docker.io`             |
| `volumePermissionsImage.repository`           | Init container volume-permissions image repository  | `bitnami/bitnami-shell` |
| `volumePermissionsImage.tag`                  | Init container volume-permissions image tag         | `10-debian-10-r125`     |
| `volumePermissionsImage.pullPolicy`           | Init container volume-permissions image pull policy | `Always`                |
| `volumePermissionsImage.pullSecrets`          | Specify docker-registry secret names as an array    | `[]`                    |
| `volumePermissions.enabled`                   | Enable init container to adapt volume permissions   | `false`                 |
| `volumePermissions.securityContext.runAsUser` | Init container volume-permissions User ID           | `0`                     |
| `volumePermissions.resources.limits`          | The resources limits for the container              | `{}`                    |
| `volumePermissions.resources.requests`        | The requested resources for the container           | `{}`                    |


### Persistence parameters

| Name                        | Description                                                                             | Value                 |
| --------------------------- | --------------------------------------------------------------------------------------- | --------------------- |
| `persistence.enabled`       | Enable data persistence                                                                 | `true`                |
| `persistence.existingClaim` | A manually managed Persistent Volume and Claim                                          | `""`                  |
| `persistence.storageClass`  | Persistent Volume Storage Class                                                         | `""`                  |
| `persistence.mountPath`     | The path the volume will be mounted at, useful when using different PostgreSQL images.  | `/bitnami/postgresql` |
| `persistence.accessModes`   | List of access modes of data volume                                                     | `[]`                  |
| `persistence.size`          | Persistent Volume Claim size                                                            | `8Gi`                 |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                     | `{}`                  |
| `persistence.selector`      | Selector to match an existing Persistent Volume (this value is evaluated as a template) | `{}`                  |


### Traffic Exposure parameters

| Name                               | Description                                                         | Value       |
| ---------------------------------- | ------------------------------------------------------------------- | ----------- |
| `service.type`                     | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`) | `ClusterIP` |
| `service.port`                     | PostgreSQL port                                                     | `5432`      |
| `service.nodePort`                 | Kubernetes service nodePort                                         | `""`        |
| `service.loadBalancerIP`           | Load balancer IP if service type is `LoadBalancer`                  | `""`        |
| `service.loadBalancerSourceRanges` | Addresses that are allowed when service is LoadBalancer             | `[]`        |
| `service.clusterIP`                | Set the Cluster IP to use                                           | `""`        |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                | `Cluster`   |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin    | `None`      |
| `service.annotations`              | Provide any additional annotations for PostgreSQL service           | `{}`        |
| `service.serviceLabels`            | Labels for PostgreSQL service                                       | `{}`        |
| `networkPolicy.enabled`            | Enable NetworkPolicy                                                | `false`     |
| `networkPolicy.allowExternal`      | Don't require client label for connections                          | `true`      |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
    --set postgresql.password=password \
    bitnami/postgresql-ha
```

The above command sets the password for user `postgres` to `password`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release \
    -f values.yaml \
    bitnami/postgresql-ha
```

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change PostgreSQL version

To modify the PostgreSQL version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/postgresql-repmgr/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Use a volume for /dev/shm

When working with huge databeses, `/dev/shm` can run out of space. A way to fix this is to use the `postgresql.extraVolumes` and `postgresql.extraVolumeMounts` values. In the example below, we set an `emptyDir` volume with 512Mb:

```yaml
postgresql:
  extraVolumes:
    - name: dshm
      emptyDir:
        medium: Memory
        sizeLimit: 512Mi
  extraVolumeMounts:
    - name: dshm
      mountPath: /dev/shm
```

### Configure the way how to expose PostgreSQL

- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster. Set `service.type=ClusterIP` to choose this service type.
- **NodePort**: Exposes the service on each Node's IP at a static port (the NodePort). You’ll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`. Set `service.type=NodePort` to choose this service type.
- **LoadBalancer**: Exposes the service externally using a cloud provider's load balancer. Set `service.type=LoadBalancer` to choose this service type.

### Adjust permissions of persistent volume mountpoint

As the images run as non-root by default, it is necessary to adjust the ownership of the persistent volumes so that the containers can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Securing traffic using TLS

Learn how to [configure TLS authentication](/<%= platform_path %>/infrastructure/postgresql-ha/administration/enable-tls/)

### LDAP

LDAP support can be enabled in the chart by specifying the `ldap.` parameters while creating a release. The following parameters should be configured to properly enable the LDAP support in the chart.

- **ldap.enabled**: Enable LDAP support. Defaults to `false`.
- **ldap.uri**: LDAP URL beginning in the form `ldap[s]://<hostname>:<port>`. No defaults.
- **ldap.base**: LDAP base DN. No defaults.
- **ldap.binddn**: LDAP bind DN. No defaults.
- **ldap.bindpw**: LDAP bind password. No defaults.
- **ldap.bslookup**: LDAP base lookup. No defaults.
- **ldap.nss_initgroups_ignoreusers**: LDAP ignored users. `root,nslcd`.
- **ldap.scope**: LDAP search scope. No defaults.
- **ldap.tls_reqcert**: LDAP TLS check on server certificates. No defaults.

For example:

```bash
ldap.enabled="true"
ldap.uri="ldap://my_ldap_server"
ldap.base="dc=example\,dc=org"
ldap.binddn="cn=admin\,dc=example\,dc=org"
ldap.bindpw="admin"
ldap.bslookup="ou=group-ok\,dc=example\,dc=org"
ldap.nss_initgroups_ignoreusers="root\,nslcd"
ldap.scope="sub"
ldap.tls_reqcert="demand"
```

Next, login to the PostgreSQL server using the `psql` client and add the PAM authenticated LDAP users.

> Note: Parameters including commas must be escaped as shown in the above example. More information at: https://github.com/helm/helm/blob/master/docs/using_helm.md#the-format-and-limitations-of---set

### repmgr.conf / postgresql.conf / pg_hba.conf / pgpool.conf files as configMap

This helm chart also supports to customize the whole configuration file.

You can specify the Pgpool, PostgreSQL and Repmgr configuration using the `pgpool.configuration`, `postgresql.configuration`, `postgresql.pgHbaConfiguration`, and `postgresql.repmgrConfiguration` parameters. The corresponding files will be mounted as ConfigMap to the containers and it will be used for configuring Pgpool, Repmgr and the PostgreSQL server.

In addition to this option, you can also set an external ConfigMap(s) with all the configuration files. This is done by setting the `postgresql.configurationCM` and `pgpool.configurationCM` parameters. Note that this will override the previous options.

### Allow settings to be loaded from files other than the default `postgresql.conf`

If you don't want to provide the whole PostgreSQL configuration file and only specify certain parameters, you can specify the extended configuration using the `postgresql.extendedConf` parameter. A file will be mounted as configMap to the containers adding/overwriting the default configuration using the `include_dir` directive that allows settings to be loaded from files other than the default `postgresql.conf`.

In addition to this option, you can also set an external ConfigMap with all the extra configuration files. This is done by setting the `postgresql.extendedConfCM` parameter. Note that this will override the previous option.

### Initialize a fresh instance

The [Bitnami PostgreSQL with Repmgr](https://github.com/bitnami/bitnami-docker-postgresql-repmgr) image allows you to use your custom scripts to initialize a fresh instance. You can specify custom scripts using the `initdbScripts` parameter as dict so they can be consumed as a ConfigMap.

In addition to this option, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsCM` parameter. Note that this will override the two previous options. If your initialization scripts contain sensitive information such as credentials or passwords, you can use the `initdbScriptsSecret` parameter.

The above parameters (`initdbScripts`, `initdbScriptsCM`, and `initdbScriptsSecret`) are supported in both StatefulSet by prepending `postgresql` or `pgpool` to the parameter, depending on the use case (see above parameters table).

The allowed extensions are `.sh`, `.sql` and `.sql.gz` in the **postgresql** container while only `.sh` in the case of the **pgpool** one.

+info: https://github.com/bitnami/bitnami-docker-postgresql#initializing-a-new-instance and https://github.com/bitnami/bitnami-docker-pgpool#initializing-with-custom-scripts

### Use of global variables

In more complex scenarios, we may have the following tree of dependencies

```bash
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
|PostgreSQL HA |    |  Sub-chart 1  |  |  Sub-chart 2  |
|              |    |               |  |               |
+--------------+    +---------------+  +---------------+
```

The three charts below depend on the parent chart Chart 1. However, subcharts 1 and 2 may need to connect to PostgreSQL HA as well. In order to do so, subcharts 1 and 2 need to know the PostgreSQL HA credentials, so one option for deploying could be deploy Chart 1 with the following parameters:

```bash
postgresql.postgresqlPassword=testtest
subchart1.postgresql.postgresqlPassword=testtest
subchart2.postgresql.postgresqlPassword=testtest
postgresql.postgresqlDatabase=db1
subchart1.postgresql.postgresqlDatabase=db1
subchart2.postgresql.postgresqlDatabase=db1
```

If the number of dependent sub-charts increases, installing the chart with parameters can become increasingly difficult. An alternative would be to set the credentials using global variables as follows:

```bash
global.postgresql.postgresqlPassword=testtest
global.postgresql.postgresqlDatabase=db1
```

This way, the credentials will be available in all of the subcharts.

## Persistence

The data is persisted by default using PVC templates in the PostgreSQL statefulset. You can disable the persistence setting the `persistence.enabled` parameter to `false`.
A default `StorageClass` is needed in the Kubernetes cluster to dynamically provision the volumes. Specify another StorageClass in the `persistence.storageClass` or set `persistence.existingClaim` if you have already existing persistent volumes to use.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` paremeter(s). Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to specify the existing passwords while performing a upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `postgresql.password` and `postgresql.repmgrPassword` parameters when upgrading the chart:

```bash
$ helm upgrade my-release bitnami/postgresql-ha \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD]
```

> Note: you need to substitute the placeholders _[POSTGRESQL_PASSWORD]_, and _[REPMGR_PASSWORD]_ with the values obtained from instructions in the installation notes.

> Note: As general rule, it is always wise to do a backup before the upgrading procedures.

### To 6.4.0

Support for adding custom configuration files or initialization scripts by placing them under the "files" directory in the working directory was removed. This functionality was very confusing for users since they do not usually clone the repo nor they fetch the charts to their working directories.
As an alternative to this feature, users can still use the equivalent parameters available in the `values.yaml` to load their custom configuration & scripts.

### To 6.0.0

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

### To 5.2.0

A new  version of repmgr (5.2.0) was included. To upgrade to this version, it's necessary to upgrade the repmgr extension installed on the database. To do so, follow the steps below:

- Reduce your PostgreSQL setup to one replica (primary node) and upgrade to `5.2.0`, enabling the repmgr extension upgrade:

```bash
$ helm upgrade my-release --version 5.2.0 bitnami/postgresql-ha \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD] \
    --set postgresql.replicaCount=1 \
    --set postgresql.upgradeRepmgrExtension=true
```

- Scale your PostgreSQL setup to the original number of replicas:

```bash
$ helm upgrade my-release --version 5.2.0 bitnami/postgresql-ha \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD] \
    --set postgresql.replicaCount=[NUMBER_OF_REPLICAS]
```

> Note: you need to substitute the placeholders _[POSTGRESQL_PASSWORD]_, and _[REPMGR_PASSWORD]_ with the values obtained from instructions in the installation notes (`helm get notes RELEASE_NAME`).

### To 5.0.0

This release uses parallel deployment for the postgresql statefullset. This should fix the issues related to not being able to restart the cluster under some contions where the master node is not longer node `-0`.
This version is next major version to v3.x.y

- To upgrade to this version you will need to delete the deployment, keep the PVCs and launch a new deployment keeping the deployment name.

```bash
$ # e.g. Previous deployment v3.9.1
$ helm install my-release \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD] \
    bitnami/postgresql-ha --version 3.9.1

$ # Update repository information
$ helm repo update

$ # upgrade to v5.0.0
$ helm delete my-release
$ helm install my-release \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD] \
    bitnami/postgresql-ha --version 5.0.0
```

### To 4.0.x

Due to an error handling the version numbers these versions are actually part of the 3.x versions and not a new major version.

### To 3.0.0

A new major version of repmgr (5.1.0) was included. To upgrade to this major version, it's necessary to upgrade the repmgr extension installed on the database. To do so, follow the steps below:

- Reduce your PostgreSQL setup to one replica (primary node) and upgrade to `3.0.0`, enabling the repmgr extension upgrade:

```bash
$ helm upgrade my-release --version 3.0.0 bitnami/postgresql-ha \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD] \
    --set postgresql.replicaCount=1 \
    --set postgresql.upgradeRepmgrExtension=true
```

- Scale your PostgreSQL setup to the original number of replicas:

```bash
$ helm upgrade my-release --version 3.0.0 bitnami/postgresql-ha \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD] \
    --set postgresql.replicaCount=[NUMBER_OF_REPLICAS]
```

> Note: you need to substitute the placeholders _[POSTGRESQL_PASSWORD]_, and _[REPMGR_PASSWORD]_ with the values obtained from instructions in the installation notes.

### To 2.0.0

The [Bitnami Pgpool](https://github.com/bitnami/bitnami-docker-pgpool) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Pgpool daemon was started as the `pgpool` user. From now on, both the container and the Pgpool daemon run as user `1001`. You can revert this behavior by setting the parameters `pgpool.containerSecurityContext.runAsUser`, and `pgpool.securityContext.fsGroup` to `0`.

Consequences:

- No backwards compatibility issues are expected since all the data is at PostgreSQL pods, and Pgpool uses a deployment without persistence. Therefore, upgrades should work smoothly from `1.x.x` versions.
- Environment variables related to LDAP configuration were renamed removing the `PGPOOL_` prefix. For instance, to indicate the LDAP URI to use, you must set `LDAP_URI` instead of `PGPOOL_LDAP_URI`

### To 1.0.0

A new major version of repmgr (5.0.0) was included. To upgrade to this major version, it's necessary to upgrade the repmgr extension installed on the database. To do so, follow the steps below:

- Reduce your PostgreSQL setup to one replica (primary node) and upgrade to `1.0.0`, enabling the repmgr extension upgrade:

```bash
$ helm upgrade my-release --version 1.0.0 bitnami/postgresql-ha \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD] \
    --set postgresql.replicaCount=1 \
    --set postgresql.upgradeRepmgrExtension=true
```

- Scale your PostgreSQL setup to the original number of replicas:

```bash
$ helm upgrade my-release --version 1.0.0 bitnami/postgresql-ha \
    --set postgresql.password=[POSTGRESQL_PASSWORD] \
    --set postgresql.repmgrPassword=[REPMGR_PASSWORD] \
    --set postgresql.replicaCount=[NUMBER_OF_REPLICAS]
```

> Note: you need to substitute the placeholders _[POSTGRESQL_PASSWORD]_, and _[REPMGR_PASSWORD]_ with the values obtained from instructions in the installation notes.

### To 0.4.0

In this version, the chart will use PostgreSQL-Repmgr container images with the Postgis extension included. The version used in Postgresql version 10, 11 and 12 is Postgis 2.5, and in Postgresql 9.6 is Postgis 2.3. Postgis has been compiled with the following dependencies:

- protobuf
- protobuf-c
- json-c
- geos
- proj
- gdal

## Bitnami Kubernetes Documentation

Bitnami Kubernetes documentation is available at [https://docs.bitnami.com/](https://docs.bitnami.com/). You can find there the following resources:

- [Documentation for PostgreSQL HA Helm chart](https://docs.bitnami.com/kubernetes/infrastructure/postgresql-ha/)
- [Get Started with Kubernetes guides](https://docs.bitnami.com/kubernetes/)
- [Bitnami Helm charts documentation](https://docs.bitnami.com/kubernetes/apps/)
- [Kubernetes FAQs](https://docs.bitnami.com/kubernetes/faq/)
- [Kubernetes Developer guides](https://docs.bitnami.com/tutorials/)
