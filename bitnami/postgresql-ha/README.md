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

The following table lists the configurable parameters of the PostgreSQL HA chart and the default values. They can be configured in `values.yaml` or set via `--set` flag during installation.

| Parameter                                       | Description                                                                                                                                                                                     | Default                                                      |
|-------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| **Global**                                      |                                                                                                                                                                                                 |                                                              |
| `global.imageRegistry`                          | Global Docker image registry                                                                                                                                                                    | `nil`                                                        |
| `global.imagePullSecrets`                       | Global Docker registry secret names as an array                                                                                                                                                 | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                           | Global storage class for dynamic provisioning                                                                                                                                                   | `nil`                                                        |
| `global.postgresql.existingSecret`              | Name of existing secret to use for PostgreSQL passwords (overrides `postgresql.existingSecret`)                                                                                                 | `nil`                                                        |
| `global.postgresql.username`                    | PostgreSQL username (overrides `postgresql.username`)                                                                                                                                           | `nil`                                                        |
| `global.postgresql.password`                    | PostgreSQL password (overrides `postgresql.password`)                                                                                                                                           | `nil`                                                        |
| `global.postgresql.database`                    | PostgreSQL database (overrides `postgresql.database`)                                                                                                                                           | `nil`                                                        |
| `global.postgresql.repmgrUsername`              | PostgreSQL repmgr username (overrides `postgresql.repmgrUsername`)                                                                                                                              | `nil`                                                        |
| `global.postgresql.repmgrPassword`              | PostgreSQL repmgr password (overrides `postgresql.repmgrpassword`)                                                                                                                              | `nil`                                                        |
| `global.postgresql.repmgrDatabase`              | PostgreSQL repmgr database (overrides `postgresql.repmgrDatabase`)                                                                                                                              | `nil`                                                        |
| `global.ldap.existingSecret`                    | Name of existing secret to use for LDAP passwords (overrides `ldap.existingSecret`)                                                                                                             | `nil`                                                        |
| `global.ldap.bindpw`                            | LDAP bind password (overrides `ldap.bindpw`)                                                                                                                                                    | `nil`                                                        |
| `global.pgpool.adminUsername`                   | Pgpool Admin username (overrides `pgpool.adminUsername`)                                                                                                                                        | `nil`                                                        |
| `global.pgpool.adminPassword`                   | Pgpool Admin password (overrides `pgpool.adminPassword`)                                                                                                                                        | `nil`                                                        |
| **General**                                     |                                                                                                                                                                                                 |                                                              |
| `commonLabels`                                  | Labels to add to all deployed objects                                                                                                                                                           | `nil`                                                        |
| `commonAnnotations`                             | Annotations to add to all deployed objects                                                                                                                                                      | `[]`                                                         |
| `nameOverride`                                  | String to partially override postgres-ha.fullname template with a string                                                                                                                        | `nil`                                                        |
| `fullnameOverride`                              | String to fully override postgres-ha.fullname template with a string                                                                                                                            | `nil`                                                        |
| `clusterDomain`                                 | Default Kubernetes cluster domain                                                                                                                                                               | `cluster.local`                                              |
| `extraDeploy`                                   | Array of extra objects to deploy with the release (evaluated as a template).                                                                                                                    | `nil`                                                        |
| `serviceAccount.enabled`                        | Enable service account (Note: Service Account will only be automatically created if `serviceAccount.name` is not set)                                                                           | `false`                                                      |
| `serviceAccount.name`                           | Name of existing service account                                                                                                                                                                | `nil`                                                        |
| **PostgreSQL with Repmgr**                      |                                                                                                                                                                                                 |                                                              |
| `postgresqlImage.registry`                      | Registry for PostgreSQL with Repmgr image                                                                                                                                                       | `docker.io`                                                  |
| `postgresqlImage.repository`                    | Repository for PostgreSQL with Repmgr image                                                                                                                                                     | `bitnami/postgresql-repmgr`                                  |
| `postgresqlImage.tag`                           | Tag for PostgreSQL with Repmgr image                                                                                                                                                            | `{TAG_NAME}`                                                 |
| `postgresqlImage.pullPolicy`                    | PostgreSQL with Repmgr image pull policy                                                                                                                                                        | `IfNotPresent`                                               |
| `postgresqlImage.pullSecrets`                   | Specify docker-registry secret names as an array                                                                                                                                                | `[]` (does not add image pull secrets to deployed pods)      |
| `postgresqlImage.debug`                         | Specify if debug logs should be enabled                                                                                                                                                         | `false`                                                      |
| `postgresql.hostAliases`                    | Add deployment host aliases                                                               | `[]`                                          |
| `postgresql.labels`                             | Map of labels to add to the statefulset. Evaluated as a template                                                                                                                                | `{}`                                                         |
| `postgresql.podLabels`                          | Map of labels to add to the pods. Evaluated as a template                                                                                                                                       | `{}`                                                         |
| `postgresql.replicaCount`                       | The number of replicas to deploy                                                                                                                                                                | `2`                                                          |
| `postgresql.updateStrategyType`                 | Statefulset update strategy policy                                                                                                                                                              | `RollingUpdate`                                              |
| `postgresql.podAnnotations`                     | Additional pod annotations                                                                                                                                                                      | `{}`                                                         |
| `postgresql.priorityClassName`                  | Pod priority class                                                                                                                                                                              | ``                                                           |
| `postgresql.podAffinityPreset`                  | PostgreSQL pod affinity preset. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`                                                                                       | `""`                                                         |
| `postgresql.podAntiAffinityPreset`              | PostgreSQL pod anti-affinity preset. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`                                                                                  | `soft`                                                       |
| `postgresql.nodeAffinityPreset.type`            | PostgreSQL node affinity preset type. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard`                                                                                 | `""`                                                         |
| `postgresql.nodeAffinityPreset.key`             | PostgreSQL node label key to match Ignored if `postgresql.affinity` is set.                                                                                                                     | `""`                                                         |
| `postgresql.nodeAffinityPreset.values`          | PostgreSQL node label values to match. Ignored if `postgresql.affinity` is set.                                                                                                                 | `[]`                                                         |
| `postgresql.affinity`                           | Affinity for PostgreSQL pods assignment                                                                                                                                                         | `{}` (evaluated as a template)                               |
| `postgresql.nodeSelector`                       | Node labels for PostgreSQL pods assignment                                                                                                                                                      | `{}` (evaluated as a template)                               |
| `postgresql.tolerations`                        | Tolerations for PostgreSQL pods assignment                                                                                                                                                      | `[]` (evaluated as a template)                               |
| `postgresql.securityContext.*`                  | Other pod security context to be included as-is in the pod spec                                                                                                                                 | `{}`                                                         |
| `postgresql.securityContext.enabled`            | Enable security context for PostgreSQL with Repmgr                                                                                                                                              | `true`                                                       |
| `postgresql.securityContext.fsGroup`            | Group ID for the PostgreSQL with Repmgr filesystem                                                                                                                                              | `1001`                                                       |
| `postgresql.containerSecurityContext.*`         | Other container security context to be included as-is in the container spec                                                                                                                     | `{}`                                                         |
| `postgresql.containerSecurityContext.enabled`   | Enable container security context                                                                                                                                                               | `true`                                                       |
| `postgresql.containerSecurityContext.runAsUser` | User ID for the PostgreSQL with Repmgr container                                                                                                                                                | `1001`                                                       |
| `postgresql.resources`                          | The [resources] to allocate for container                                                                                                                                                       | `{}`                                                         |
| `postgresql.livenessProbe`                      | Liveness probe configuration for PostgreSQL with Repmgr                                                                                                                                         | `Check values.yaml file`                                     |
| `postgresql.readinessProbe`                     | Readiness probe configuration for PostgreSQL with Repmgr                                                                                                                                        | `Check values.yaml file`                                     |
| `postgresql.startupProbe`                       | Startup probe configuration for PostgreSQL with Repmgr                                                                                                                                          | `Check values.yaml file`                                     |
| `postgresql.customLivenessProbe`                | Override default liveness probe                                                                                                                                                                 | `nil`                                                        |
| `postgresql.customReadinessProbe`               | Override default readiness probe                                                                                                                                                                | `nil`                                                        |
| `postgresql.customStartupProbe`                 | Override default startup probe                                                                                                                                                                  | `nil`                                                        |
| `postgresql.extraVolumeMounts`                  | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.                                                                           | `nil`                                                        |
| `postgresql.sidecars`                           | Attach additional containers to the pod (evaluated as a template)                                                                                                                               | `nil`                                                        |
| `postgresql.initContainers`                     | Add additional init containers to the pod (evaluated as a template)                                                                                                                             | `nil`                                                        |
| `postgresql.extraEnvVars`                       | Array containing extra env vars                                                                                                                                                                 | `nil`                                                        |
| `postgresql.extraEnvVarsCM`                     | ConfigMap containing extra env vars                                                                                                                                                             | `nil`                                                        |
| `postgresql.extraEnvVarsSecret`                 | Secret containing extra env vars (in case of sensitive data)                                                                                                                                    | `nil`                                                        |
| `postgresql.command`                            | Override default container command (useful when using custom images)                                                                                                                            | `nil`                                                        |
| `postgresql.args`                               | Override default container args (useful when using custom images)                                                                                                                               | `nil`                                                        |
| `postgresql.lifecycleHooks`                     | LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template                                                                              | ``                                                           |
| `postgresql.pdb.create`                         | If true, create a pod disruption budget for PostgreSQL with Repmgr pods                                                                                                                         | `false`                                                      |
| `postgresql.pdb.minAvailable`                   | Minimum number / percentage of pods that should remain scheduled                                                                                                                                | `1`                                                          |
| `postgresql.pdb.maxUnavailable`                 | Maximum number / percentage of pods that may be made unavailable                                                                                                                                | `nil`                                                        |
| `postgresql.username`                           | PostgreSQL username                                                                                                                                                                             | `postgres`                                                   |
| `postgresql.password`                           | PostgreSQL password                                                                                                                                                                             | `nil`                                                        |
| `postgresql.existingSecret`                     | Name of existing secret to use for PostgreSQL passwords                                                                                                                                         | `nil`                                                        |
| `postgresql.postgresPassword`                   | PostgreSQL password for the `postgres` user when `username` is not `postgres`                                                                                                                   | `nil`                                                        |
| `postgresql.database`                           | PostgreSQL database                                                                                                                                                                             | `postgres`                                                   |
| `postgresql.usePasswordFile`                    | Have the secrets mounted as a file instead of env vars                                                                                                                                          | `false`                                                      |
| `postgresql.upgradeRepmgrExtension`             | Upgrade repmgr extension in the database                                                                                                                                                        | `false`                                                      |
| `postgresql.pgHbaTrustAll`                      | Configures PostgreSQL HBA to trust every user                                                                                                                                                   | `false`                                                      |
| `postgresql.syncReplication`                    | Make the replication synchronous. This will wait until the data is synchronized in all the replicas before other query can be run. This ensures the data availability at the expenses of speed. | `false`                                                      |
| `postgresql.sharedPreloadLibraries`             | Shared preload libraries (comma-separated list)                                                                                                                                                 | `pgaudit, repmgr`                                            |
| `postgresql.maxConnections`                     | Maximum total connections                                                                                                                                                                       | `nil`                                                        |
| `postgresql.postgresConnectionLimit`            | Maximum total connections for the postgres user                                                                                                                                                 | `nil`                                                        |
| `postgresql.dbUserConnectionLimit`              | Maximum total connections for the non-admin user                                                                                                                                                | `nil`                                                        |
| `postgresql.tcpKeepalivesInterval`              | TCP keepalives interval                                                                                                                                                                         | `nil`                                                        |
| `postgresql.tcpKeepalivesIdle`                  | TCP keepalives idle                                                                                                                                                                             | `nil`                                                        |
| `postgresql.tcpKeepalivesCount`                 | TCP keepalives count                                                                                                                                                                            | `nil`                                                        |
| `postgresql.statementTimeout`                   | Statement timeout                                                                                                                                                                               | `nil`                                                        |
| `postgresql.pghbaRemoveFilters`                 | Comma-separated list of patterns to remove from the pg_hba.conf file                                                                                                                            | `nil`                                                        |
| `postgresql.audit.logHostname`                  | Add client hostnames to the log file                                                                                                                                                            | `true`                                                       |
| `postgresql.audit.logConnections`               | Add client log-in operations to the log file                                                                                                                                                    | `false`                                                      |
| `postgresql.audit.logDisconnections`            | Add client log-outs operations to the log file                                                                                                                                                  | `false`                                                      |
| `postgresql.audit.pgAuditLog`                   | Add operations to log using the pgAudit extension                                                                                                                                               | `nil`                                                        |
| `postgresql.audit.clientMinMessages`            | Message log level to share with the user                                                                                                                                                        | `nil`                                                        |
| `postgresql.audit.logLinePrefix`                | Template string for the log line prefix                                                                                                                                                         | `nil`                                                        |
| `postgresql.audit.logTimezone`                  | Timezone for the log timestamps                                                                                                                                                                 | `nil`                                                        |
| `postgresql.repmgrUsername`                     | PostgreSQL repmgr username                                                                                                                                                                      | `repmgr`                                                     |
| `postgresql.repmgrPassword`                     | PostgreSQL repmgr password                                                                                                                                                                      | `nil`                                                        |
| `postgresql.repmgrDatabase`                     | PostgreSQL repmgr database                                                                                                                                                                      | `repmgr`                                                     |
| `postgresql.repmgrLogLevel`                     | Repmgr log level (DEBUG, INFO, NOTICE, WARNING, ERROR, ALERT, CRIT or EMERG)                                                                                                                    | `NOTICE`                                                     |
| `postgresql.repmgrConnectTimeout`               | Repmgr backend connection timeout (in seconds)                                                                                                                                                  | `5`                                                          |
| `postgresql.repmgrReconnectAttempts`            | Repmgr backend reconnection attempts                                                                                                                                                            | `3`                                                          |
| `postgresql.repmgrReconnectInterval`            | Repmgr backend reconnection interval (in seconds)                                                                                                                                               | `5`                                                          |
| `postgresql.repmgrConfiguration`                | Repmgr Configuration                                                                                                                                                                            | `nil`                                                        |
| `postgresql.configuration`                      | PostgreSQL Configuration                                                                                                                                                                        | `nil`                                                        |
| `postgresql.pgHbaConfiguration`                 | Content of pg\_hba.conf                                                                                                                                                                         | `nil (do not create pg_hba.conf)`                            |
| `postgresql.configurationCM`                    | ConfigMap with the PostgreSQL configuration files (Note: Overrides `postgresql.repmgrConfiguration`, `postgresql.configuration` and `postgresql.pgHbaConfiguration`)                            | `nil` (The value is evaluated as a template)                 |
| `postgresql.extendedConf`                       | Extended PostgreSQL Configuration (appended to main or default configuration)                                                                                                                   | `nil`                                                        |
| `postgresql.extendedConfCM`                     | ConfigMap with the extended PostgreSQL configuration files (Note: Overrides `postgresql.extendedConf`)                                                                                          | `nil` (The value is evaluated as a template)                 |
| `postgresql.initdbScripts`                      | Dictionary of initdb scripts                                                                                                                                                                    | `nil`                                                        |
| `postgresql.initdbScriptsCM`                    | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`). The value is evaluated as a template.                                                                                      | `nil`                                                        |
| `postgresql.initdbScriptsSecret`                | Secret with initdb scripts that contain sensitive information (Note: can be used with initdbScriptsCM or initdbScripts). The value is evaluated as a template.                                  | `nil`                                                        |
| **Pgpool**                                      |                                                                                                                                                                                                 |                                                              |
| `pgpoolImage.registry`                          | Registry for Pgpool                                                                                                                                                                             | `docker.io`                                                  |
| `pgpoolImage.repository`                        | Repository for Pgpool                                                                                                                                                                           | `bitnami/pgpool`                                             |
| `pgpoolImage.tag`                               | Tag for Pgpool                                                                                                                                                                                  | `{TAG_NAME}`                                                 |
| `pgpoolImage.pullPolicy`                        | Pgpool image pull policy                                                                                                                                                                        | `IfNotPresent`                                               |
| `pgpoolImage.pullSecrets`                       | Specify docker-registry secret names as an array                                                                                                                                                | `[]` (does not add image pull secrets to deployed pods)      |
| `pgpoolImage.debug`                             | Specify if debug logs should be enabled                                                                                                                                                         | `false`                                                      |
| `pgpool.customUsers.usernames`                  | Comma or semicolon separated list of postgres usernames to be added to pgpool_passwd                                                                                                            | `nil`                                                        |
| `pgpool.customUsers.passwords`                  | Comma or semicolon separated list of the associated passwords for the users to be added to pgpool_passwd                                                                                        | `nil`                                                        |
| `pgpool.customUsersSecret`                      | Name of a secret containing the usernames and passwords of accounts that will be added to pgpool_passwd                                                                                         | `nil`                                                        |
| `pgpool.srCheckDatabase`                        | Name of the database to perform streaming replication checks                                                                                                                                    | `postgres`                                                   |
| `pgpool.hostAliases`                    | Add deployment host aliases                                                               | `[]`                                          |
| `pgpool.labels`                                 | Map of labels to add to the deployment. Evaluated as a template                                                                                                                                 | `{}`                                                         |
| `pgpool.podLabels`                              | Map of labels to add to the pods. Evaluated as a template                                                                                                                                       | `{}`                                                         |
| `pgpool.replicaCount`                           | The number of replicas to deploy                                                                                                                                                                | `1`                                                          |
| `pgpool.customLivenessProbe`                    | Override default liveness probe                                                                                                                                                                 | `nil`                                                        |
| `pgpool.customReadinessProbe`                   | Override default readiness probe                                                                                                                                                                | `nil`                                                        |
| `pgpool.customStartupProbe`                     | Override default startup probe                                                                                                                                                                  | `nil`                                                        |
| `pgpool.extraVolumeMounts`                      | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.                                                                           | `nil`                                                        |
| `pgpool.sidecars`                               | Attach additional containers to the pod (evaluated as a template)                                                                                                                               | `nil`                                                        |
| `pgpool.initContainers`                         | Add additional init containers to the pod (evaluated as a template)                                                                                                                             | `nil`                                                        |
| `pgpool.extraEnvVars`                           | Array containing extra env vars                                                                                                                                                                 | `nil`                                                        |
| `pgpool.extraEnvVarsCM`                         | ConfigMap containing extra env vars                                                                                                                                                             | `nil`                                                        |
| `pgpool.extraEnvVarsSecret`                     | Secret containing extra env vars (in case of sensitive data)                                                                                                                                    | `nil`                                                        |
| `pgpool.command`                                | Override default container command (useful when using custom images)                                                                                                                            | `nil`                                                        |
| `pgpool.args`                                   | Override default container args (useful when using custom images)                                                                                                                               | `nil`                                                        |
| `pgpool.lifecycleHooks`                         | LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template                                                                              | ``                                                           |
| `pgpool.podAnnotations`                         | Additional pod annotations                                                                                                                                                                      | `{}`                                                         |
| `pgpool.initdbScripts`                          | Dictionary of initdb scripts                                                                                                                                                                    | `nil`                                                        |
| `pgpool.initdbScriptsCM`                        | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`). The value is evaluated as a template.                                                                                      | `nil`                                                        |
| `pgpool.initdbScriptsSecret`                    | Secret with initdb scripts that contain sensitive information (Note: can be used with initdbScriptsCM or initdbScripts). The value is evaluated as a template.                                  | `nil`                                                        |
| `pgpool.priorityClassName`                      | Pod priority class                                                                                                                                                                              | ``                                                           |
| `pgpool.podAffinityPreset`                      | Pgpool pod affinity preset. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`                                                                                               | `""`                                                         |
| `pgpool.podAntiAffinityPreset`                  | Pgpool pod anti-affinity preset. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`                                                                                          | `soft`                                                       |
| `pgpool.nodeAffinityPreset.type`                | Pgpool node affinity preset type. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard`                                                                                         | `""`                                                         |
| `pgpool.nodeAffinityPreset.key`                 | Pgpool node label key to match Ignored if `pgpool.affinity` is set.                                                                                                                             | `""`                                                         |
| `pgpool.nodeAffinityPreset.values`              | Pgpool node label values to match. Ignored if `pgpool.affinity` is set.                                                                                                                         | `[]`                                                         |
| `pgpool.affinity`                               | Affinity for Pgpool pods assignment                                                                                                                                                             | `{}` (evaluated as a template)                               |
| `pgpool.nodeSelector`                           | Node labels for Pgpool pods assignment                                                                                                                                                          | `{}` (evaluated as a template)                               |
| `pgpool.tolerations`                            | Tolerations for Pgpool pods assignment                                                                                                                                                          | `[]` (evaluated as a template)                               |
| `pgpool.securityContext.*`                      | Other pod security context to be included as-is in the pod spec                                                                                                                                 | `{}`                                                         |
| `pgpool.securityContext.enabled`                | Enable security context for Pgpool                                                                                                                                                              | `true`                                                       |
| `pgpool.securityContext.fsGroup`                | Group ID for the Pgpool filesystem                                                                                                                                                              | `1001`                                                       |
| `pgpool.containerSecurityContext.*`             | Other container security context to be included as-is in the container spec                                                                                                                     | `{}`                                                         |
| `pgpool.containerSecurityContext.enabled`       | Enable container security context                                                                                                                                                               | `true`                                                       |
| `pgpool.containerSecurityContext.runAsUser`     | User ID for the Pgpool container                                                                                                                                                                | `1001`                                                       |
| `pgpool.resources`                              | The [resources] to allocate for container                                                                                                                                                       | `{}`                                                         |
| `pgpool.livenessProbe`                          | Liveness probe configuration for Pgpool                                                                                                                                                         | `Check values.yaml file`                                     |
| `pgpool.readinessProbe`                         | Readiness probe configuration for Pgpool                                                                                                                                                        | `Check values.yaml file`                                     |
| `pgpool.startupProbe`                           | Startup probe configuration for Pgpool                                                                                                                                                          | `Check values.yaml file`                                     |
| `pgpool.pdb.create`                             | If true, create a pod disruption budget for Pgpool pods.                                                                                                                                        | `false`                                                      |
| `pgpool.pdb.minAvailable`                       | Minimum number / percentage of pods that should remain scheduled                                                                                                                                | `1`                                                          |
| `pgpool.pdb.maxUnavailable`                     | Maximum number / percentage of pods that may be made unavailable                                                                                                                                | `nil`                                                        |
| `pgpool.updateStrategy`                         | Strategy used to replace old Pods by new ones                                                                                                                                                   | `{}`                                                         |
| `pgpool.minReadySeconds`                        | How many seconds a pod needs to be ready before killing the next, during update                                                                                                                 | `nil`                                                        |
| `pgpool.adminUsername`                          | Pgpool Admin username                                                                                                                                                                           | `admin`                                                      |
| `pgpool.adminPassword`                          | Pgpool Admin password                                                                                                                                                                           | `nil`                                                        |
| `pgpool.logConnections`                         | Log all client connections                                                                                                                                                                      | `false`                                                      |
| `pgpool.logHostname`                            | Log the client hostname instead of IP address                                                                                                                                                   | `true`                                                       |
| `pgpool.logPerNodeStatement`                    | Log every SQL statement for each DB node separately                                                                                                                                             | `false`                                                      |
| `pgpool.logLinePrefix`                          | Format of the log entry lines                                                                                                                                                                   | `nil`                                                        |
| `pgpool.clientMinMessages`                      | Log level for clients                                                                                                                                                                           | `error`                                                      |
| `pgpool.numInitChildren`                        | The number of preforked Pgpool-II server processes.                                                                                                                                             | `32`                                                         |
| `pgpool.maxPool`                                | The maximum number of cached connections in each child process                                                                                                                                  | `15`                                                         |
| `pgpool.childMaxConnections`                    | The maximum number of client connections in each child process                                                                                                                                   | `nil`                                                        |
| `pgpool.childLifeTime`                          | The time in seconds to terminate a Pgpool-II child process if it remains idle                                                                                                                   | `nil`                                                        |
| `pgpool.clientIdleLimit`                        | The time in seconds to disconnect a client if it remains idle since the last query                                                                                                              | `nil`                                                        |
| `pgpool.connectionLifeTime`                     | The time in seconds to terminate the cached connections to the PostgreSQL backend                                                                                                               | `nil`                                                        |
| `pgpool.useLoadBalancing`                       | If true, use Pgpool Load-Balancing                                                                                                                                                              | `true`                                                       |
| `pgpool.configuration`                          | Content of pgpool.conf                                                                                                                                                                          | `nil`                                                        |
| `pgpool.configurationCM`                        | ConfigMap with the Pgpool configuration file (Note: Overrides `pgpol.configuration`). The file used must be named `pgpool.conf`.                                                                | `nil` (The value is evaluated as a template)                 |
| `pgpool.tls.enabled`                            | Enable TLS traffic support for end-client connections                                                                                                                                           | `false`                                                      |
| `pgpool.tls.preferServerCiphers`                | Whether to use the server's TLS cipher preferences rather than the client's                                                                                                                     | `true`                                                       |
| `pgpool.tls.certificatesSecret`                 | Name of an existing secret that contains the certificates                                                                                                                                       | `nil`                                                        |
| `pgpool.tls.certFilename`                       | Certificate filename                                                                                                                                                                            | `""`                                                         |
| `pgpool.tls.certKeyFilename`                    | Certificate key filename                                                                                                                                                                        | `""`                                                         |
| `pgpool.tls.certCAFilename`                     | CA Certificate filename. If provided, PgPool will authenticate TLS/SSL clients by requesting them a certificate.                                                                                | `nil`                                                        |
| **LDAP**                                        |                                                                                                                                                                                                 |                                                              |
| `ldap.enabled`                                  | Enable LDAP support                                                                                                                                                                             | `false`                                                      |
| `ldap.existingSecret`                           | Name of existing secret to use for LDAP passwords                                                                                                                                               | `nil`                                                        |
| `ldap.uri`                                      | LDAP URL beginning in the form `ldap[s]://<hostname>:<port>`                                                                                                                                    | `nil`                                                        |
| `ldap.base`                                     | LDAP base DN                                                                                                                                                                                    | `nil`                                                        |
| `ldap.binddn`                                   | LDAP bind DN                                                                                                                                                                                    | `nil`                                                        |
| `ldap.bindpw`                                   | LDAP bind password                                                                                                                                                                              | `nil`                                                        |
| `ldap.bslookup`                                 | LDAP base lookup                                                                                                                                                                                | `nil`                                                        |
| `ldap.scope`                                    | LDAP search scope                                                                                                                                                                               | `nil`                                                        |
| `ldap.tlsReqcert`                               | LDAP TLS check on server certificates                                                                                                                                                           | `nil`                                                        |
| `ldap.nssInitgroupsIgnoreusers`                 | LDAP ignored users                                                                                                                                                                              | `root,nslcd`                                                 |
| **Prometheus metrics**                          |                                                                                                                                                                                                 |                                                              |
| `metricsImage.registry`                         | Registry for PostgreSQL Prometheus exporter                                                                                                                                                     | `docker.io`                                                  |
| `metricsImage.repository`                       | Repository for PostgreSQL Prometheus exporter                                                                                                                                                   | `bitnami/postgres-exporter`                                  |
| `metricsImage.tag`                              | Tag for PostgreSQL Prometheus exporter                                                                                                                                                          | `{TAG_NAME}`                                                 |
| `metricsImage.pullPolicy`                       | PostgreSQL Prometheus exporter image pull policy                                                                                                                                                | `IfNotPresent`                                               |
| `metricsImage.pullSecrets`                      | Specify docker-registry secret names as an array                                                                                                                                                | `[]` (does not add image pull secrets to deployed pods)      |
| `metricsImage.debug`                            | Specify if debug logs should be enabled                                                                                                                                                         | `false`                                                      |
| `metrics.securityContext.*`                     | Other container security context to be included as-is in the container spec                                                                                                                     | `{}`                                                         |
| `metrics.securityContext.enabled`               | Enable security context for PostgreSQL Prometheus exporter                                                                                                                                      | `true`                                                       |
| `metrics.securityContext.runAsUser`             | User ID for the PostgreSQL Prometheus exporter container                                                                                                                                        | `1001`                                                       |
| `metrics.resources`                             | The [resources] to allocate for container                                                                                                                                                       | `{}`                                                         |
| `metrics.livenessProbe`                         | Liveness probe configuration for PostgreSQL Prometheus exporter                                                                                                                                 | `Check values.yaml file`                                     |
| `metrics.readinessProbe`                        | Readiness probe configuration for PostgreSQL Prometheus exporter                                                                                                                                | `Check values.yaml file`                                     |
| `metrics.startupProbe`                          | Startup probe configuration for PostgreSQL Prometheus exporter                                                                                                                                  | `Check values.yaml file`                                     |
| `metrics.annotations`                           | Annotations for PostgreSQL Prometheus exporter service                                                                                                                                          | `{prometheus.io/scrape: "true", prometheus.io/port: "9187"}` |
| `metrics.serviceMonitor.enabled`                | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                          | `false`                                                      |
| `metrics.serviceMonitor.namespace`              | Optional namespace which Prometheus is running in                                                                                                                                               | `nil`                                                        |
| `metrics.serviceMonitor.interval`               | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                                                                                          | `nil`                                                        |
| `metrics.serviceMonitor.selector`               | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                                                                      | `{prometheus: "kube-prometheus"}`                            |
| `metrics.serviceMonitor.relabelings`            | ServiceMonitor relabelings. Value is evaluated as a template                                                                                                                                    | `[]`                                                         |
| `metrics.serviceMonitor.metricRelabelings`      | ServiceMonitor metricRelabelings. Value is evaluated as a template                                                                                                                              | `[]`                                                         |
| **Init Container to adapt volume permissions**  |                                                                                                                                                                                                 |                                                              |
| `volumePermissionsImage.registry`               | Init container volume-permissions image registry                                                                                                                                                | `docker.io`                                                  |
| `volumePermissionsImage.repository`             | Init container volume-permissions image repository                                                                                                                                              | `bitnami/bitnami-shell`                                      |
| `volumePermissionsImage.tag`                    | Init container volume-permissions image tag                                                                                                                                                     | `latest`                                                     |
| `volumePermissionsImage.pullPolicy`             | Init container volume-permissions image pull policy                                                                                                                                             | `Always`                                                     |
| `volumePermissionsImage.pullSecrets`            | Specify docker-registry secret names as an array                                                                                                                                                | `[]` (does not add image pull secrets to deployed pods)      |
| `volumePermissions.enabled`                     | Enable init container to adapt volume permissions                                                                                                                                               | `false`                                                      |
| `volumePermissions.securityContext.*`           | Other container security context to be included as-is in the container spec                                                                                                                     | `{}`                                                         |
| `volumePermissions.securityContext.enabled`     | Init container volume-permissions security context                                                                                                                                              | `false`                                                      |
| `volumePermissions.securityContext.runAsUser`   | Init container volume-permissions User ID                                                                                                                                                       | `0`                                                          |
| **Persistence**                                 |                                                                                                                                                                                                 |                                                              |
| `persistence.enabled`                           | Enable data persistence                                                                                                                                                                         | `true`                                                       |
| `persistence.existingClaim`                     | Use a existing PVC which must be created manually before bound. PVC will be shared between all replicas, which is useful for special cases only.                                                | `nil`                                                        |
| `persistence.storageClass`                      | Specify the `storageClass` used to provision the volume                                                                                                                                         | `nil`                                                        |
| `persistence.mountPath`                         | Path to mount data volume at                                                                                                                                                                    | `nil`                                                        |
| `persistence.accessMode`                        | Access mode of data volume                                                                                                                                                                      | `ReadWriteOnce`                                              |
| `persistence.size`                              | Size of data volume                                                                                                                                                                             | `8Gi`                                                        |
| `persistence.annotations`                       | Persistent Volume Claim annotations                                                                                                                                                             | `{}`                                                         |
| `persistence.selector`                          | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                                                                                         | `{}`                                                         |
| **Expose**                                      |                                                                                                                                                                                                 |                                                              |
| `service.type`                                  | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                                                                                             | `ClusterIP`                                                  |
| `service.port`                                  | PostgreSQL port                                                                                                                                                                                 | `5432`                                                       |
| `service.nodePort`                              | Kubernetes service nodePort                                                                                                                                                                     | `nil`                                                        |
| `service.annotations`                           | Annotations for PostgreSQL service                                                                                                                                                              | `{}`                                                         |
| `service.serviceLabels`                         | Labels for PostgreSQL service                                                                                                                                                                   | `{}`                                                         |
| `service.loadBalancerIP`                        | loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                | `nil`                                                        |
| `service.loadBalancerSourceRanges`              | Address that are allowed when service is LoadBalancer                                                                                                                                           | `[]`                                                         |
| `service.clusterIP`                             | Static clusterIP or None for headless services                                                                                                                                                  | `nil`                                                        |
| `networkPolicy.enabled`                         | Enable NetworkPolicy                                                                                                                                                                            | `false`                                                      |
| `networkPolicy.allowExternal`                   | Don't require client label for connections                                                                                                                                                      | `true`                                                       |

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

### Securing Pgpool traffic using TLS

TLS for end-client connections can be enabled in the chart by specifying the `pgpool.tls.` parameters while creating a release. The following parameters should be configured to properly enable the TLS support in the chart:

- `pgpool.tls.enabled`: Enable TLS support. Defaults to `false`
- `pgpool.tls.certificatesSecret`: Name of an existing secret that contains the certificates. No defaults.
- `pgpool.tls.certFilename`: Certificate filename. No defaults.
- `pgpool.tls.certKeyFilename`: Certificate key filename. No defaults.

For example:

- First, create the secret with the cetificates files:

    ```console
    kubectl create secret generic certificates-pgpool.tls.secret --from-file=./cert.crt --from-file=./cert.key --from-file=./ca.crt
    ```

- Then, use the following parameters:

    ```console
    pgpool.tls.enabled=true
    pgpool.tls.certificatesSecret="certificates-pgpool.tls.secret"
    pgpool.tls.certFilename="cert.crt"
    pgpool.tls.certKeyFilename="cert.key"
    ```

    > Note TLS and VolumePermissions: PgPool requires certain permissions on sensitive files (such as certificate keys) to start up. Due to an on-going [issue](https://github.com/kubernetes/kubernetes/issues/57923) regarding kubernetes permissions and the use of `containerSecurityContext.runAsUser`, the `volumePermissions` init container will ensure everything works as expected.

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
