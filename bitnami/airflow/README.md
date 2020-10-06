# Apache Airflow

[Apache Airflow](https://airflow.apache.org/) is a platform to programmatically author, schedule and monitor workflows.

## TL;DR

```console
$ helm install my-release bitnami/airflow
```

## Introduction

This chart bootstraps an [Apache Airflow](https://github.com/bitnami/bitnami-docker-airflow) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/airflow
```

These commands deploy Airflow on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Airflow chart and their default values.

| Parameter                                                                | Description                                                                                                                                                                                                                    | Default                                                      |
|--------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                                                   | Global Docker image registry                                                                                                                                                                                                   | `nil`                                                        |
| `global.imagePullSecrets`                                                | Global Docker registry secret names as an array                                                                                                                                                                                | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                                                    | Global storage class for dynamic provisioning                                                                                                                                                                                  | `nil`                                                        |
| `image.registry`                                                         | Airflow image registry                                                                                                                                                                                                         | `docker.io`                                                  |
| `image.repository`                                                       | Airflow image name                                                                                                                                                                                                             | `bitnami/airflow`                                            |
| `image.tag`                                                              | Airflow image tag                                                                                                                                                                                                              | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                                                       | Airflow image pull policy                                                                                                                                                                                                      | `IfNotPresent`                                               |
| `image.pullSecrets`                                                      | Specify docker-registry secret names as an array                                                                                                                                                                               | `[]` (does not add image pull secrets to deployed pods)      |
| `image.debug`                                                            | Specify if debug values should be set                                                                                                                                                                                          | `false`                                                      |
| `schedulerImage.registry`                                                | Airflow Scheduler image registry                                                                                                                                                                                               | `docker.io`                                                  |
| `schedulerImage.repository`                                              | Airflow Scheduler image name                                                                                                                                                                                                   | `bitnami/airflow-scheduler`                                  |
| `schedulerImage.tag`                                                     | Airflow Scheduler image tag                                                                                                                                                                                                    | `{TAG_NAME}`                                                 |
| `schedulerImage.pullPolicy`                                              | Airflow Scheduler image pull policy                                                                                                                                                                                            | `IfNotPresent`                                               |
| `schedulerImage.pullSecrets`                                             | Specify docker-registry secret names as an array                                                                                                                                                                               | `[]` (does not add image pull secrets to deployed pods)      |
| `schedulerImage.debug`                                                   | Specify if debug values should be set                                                                                                                                                                                          | `false`                                                      |
| `workerImage.registry`                                                   | Airflow Worker image registry                                                                                                                                                                                                  | `docker.io`                                                  |
| `workerImage.repository`                                                 | Airflow Worker image name                                                                                                                                                                                                      | `bitnami/airflow-worker`                                     |
| `workerImage.tag`                                                        | Airflow Worker image tag                                                                                                                                                                                                       | `{TAG_NAME}`                                                 |
| `workerImage.pullPolicy`                                                 | Airflow Worker image pull policy                                                                                                                                                                                               | `IfNotPresent`                                               |
| `workerImage.pullSecrets`                                                | Specify docker-registry secret names as an array                                                                                                                                                                               | `[]` (does not add image pull secrets to deployed pods)      |
| `workerImage.debug`                                                      | Specify if debug values should be set                                                                                                                                                                                          | `false`                                                      |
| `git.registry`                                                           | Git image registry                                                                                                                                                                                                             | `docker.io`                                                  |
| `git.repository`                                                         | Git image name                                                                                                                                                                                                                 | `bitnami/git`                                                |
| `git.tag`                                                                | Git image tag                                                                                                                                                                                                                  | `{TAG_NAME}`                                                 |
| `git.pullPolicy`                                                         | Git image pull policy                                                                                                                                                                                                          | `IfNotPresent`                                               |
| `git.pullSecrets`                                                        | Specify docker-registry secret names as an array                                                                                                                                                                               | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                                                           | String to partially override airflow.fullname template with a string (will prepend the release name)                                                                                                                           | `nil`                                                        |
| `fullnameOverride`                                                       | String to fully override ariflow.fullname template with a string                                                                                                                                                               | `nil`                                                        |
| `commonLabels`                                                           | Labels to add to all deployed objects                                                                                                                                                                                          | `{}`                                                         |
| `commonAnnotations`                                                      | Annotations to add to all deployed objects                                                                                                                                                                                     | `{}`                                                         |
| `updateStrategy`                                                         | Update strategy for the stateful set                                                                                                                                                                                           | `RollingUpdate`                                              |
| `rollingUpdatePartition`                                                 | Partition update strategy                                                                                                                                                                                                      | `nil`                                                        |
| `rbac.create`                                                            | If true, create & use RBAC resources                                                                                                                                                                                           | `false`                                                      |
| `serviceAccount.create`                                                  | If true, create a service account                                                                                                                                                                                              | `false`                                                      |
| `serviceAccount.name`                                                    | The name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                                        | ``                                                           |
| `serviceAccount.annotations`                                             | Annotations for service   account                                                                                                                                                                                              | `{}`                                                         |
| `airflow.configurationConfigMap`                                         | Name of an existing config map containing the Airflow config file                                                                                                                                                              | `nil`                                                        |
| `airflow.dagsConfigMap`                                                  | Name of an existing config map containing all the DAGs files you want to load in Airflow.                                                                                                                                      | `nil`                                                        |
| `airflow.loadExamples`                                                   | Switch to load some Airflow examples                                                                                                                                                                                           | `true`                                                       |
| `airflow.gitSyncInterval`                                                | Interval (in seconds) to pull the git repository containing the plugins and/or DAG files                                                                                                                                       | `60`                                                         |
| `airflow.gitCloneContainer.extraEnvVars`                                 | Array containing extra env vars                                                                                                                                                                                                | `nil`                                                        |
| `airflow.gitCloneContainer.extraEnvVarsCM`                               | ConfigMap containing extra env vars                                                                                                                                                                                            | `nil`                                                        |
| `airflow.gitCloneContainer.extraEnvVarsSecret`                           | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                                   | `nil`                                                        |
| `airflow.gitCloneContainer.command`                                      | Override default container command (useful when using custom images)                                                                                                                                                           | `nil`                                                        |
| `airflow.gitCloneContainer.args`                                         | Override default container args (useful when using custom images)                                                                                                                                                              | `nil`                                                        |
| `airflow.gitCloneContainer.extraVolumeMounts`                            | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`.                                                                                                                           | `nil`                                                        |
| `airflow.gitSyncContainer.extraEnvVars`                                  | Array containing extra env vars                                                                                                                                                                                                | `nil`                                                        |
| `airflow.gitSyncContainer.extraEnvVarsCM`                                | ConfigMap containing extra env vars                                                                                                                                                                                            | `nil`                                                        |
| `airflow.gitSyncContainer.extraEnvVarsSecret`                            | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                                   | `nil`                                                        |
| `airflow.gitSyncContainer.command`                                       | Override default container command (useful when using custom images)                                                                                                                                                           | `nil`                                                        |
| `airflow.gitSyncContainer.args`                                          | Override default container args (useful when using custom images)                                                                                                                                                              | `nil`                                                        |
| `airflow.gitSyncContainer.extraVolumeMounts`                             | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`.                                                                                                                           | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.enabled`                                   | Enable in order to download DAG files from git repository.                                                                                                                                                                     | `false`                                                      |
| `airflow.cloneDagFilesFromGit.repository`                                | Repository where download DAG files from                                                                                                                                                                                       | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.branch`                                    | Branch from repository to checkout                                                                                                                                                                                             | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.path`                                      | Path to a folder in the repository containing DAGs. If not set, all DAGS from the repo are loaded.                                                                                                                             | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.repositories[0].repository`                | Repository where download DAG files from                                                                                                                                                                                       | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.repositories[0].name`                      | An unique identifier for repository, must be unique for each repository                                                                                                                                                        | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.repositories[0].branch`                    | Branch from repository to checkout                                                                                                                                                                                             | `nil`                                                        |
| `airflow.cloneDagFilesFromGit.repositories[0].path`                      | Path to a folder in the repository containing DAGs. If not set, all DAGS from the repo are loaded.                                                                                                                             | `nil`                                                        |
| `airflow.clonePluginsFromGit.enabled`                                    | Enable in order to download plugins from git repository.                                                                                                                                                                       | `false`                                                      |
| `airflow.clonePluginsFromGit.repository`                                 | Repository where download plugins from                                                                                                                                                                                         | `nil`                                                        |
| `airflow.clonePluginsFromGit.branch`                                     | Branch from repository to checkout                                                                                                                                                                                             | `nil`                                                        |
| `airflow.clonePluginsFromGit.path`                                       | Path to a folder in the repository containing the plugins.                                                                                                                                                                     | `nil`                                                        |
| `airflow.baseUrl`                                                        | URL used to access to airflow web ui                                                                                                                                                                                           | `nil`                                                        |
| `airflow.worker.port`                                                    | Airflow Worker port                                                                                                                                                                                                            | `8793`                                                       |
| `airflow.worker.replicas`                                                | Number of Airflow Worker replicas                                                                                                                                                                                              | `2`                                                          |
| `airflow.worker.podManagementPolicy`                                     | podManagementPolicy for Worker replicas                                                                                                                                                                                        | `OrderedReady`                                               |
| `airflow.worker.resources.limits`                                        | The resources limits for the Worker containers                                                                                                                                                                                 | `{}`                                                         |
| `airflow.worker.resources.requests`                                      | The requested resources for the Worker containers                                                                                                                                                                              | `{}`                                                         |
| `airflow.worker.extraEnvVars`                                            | Array containing extra env vars                                                                                                                                                                                                | `nil`                                                        |
| `airflow.worker.extraEnvVarsCM`                                          | ConfigMap containing extra env vars                                                                                                                                                                                            | `nil`                                                        |
| `airflow.worker.extraEnvVarsSecret`                                      | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                                   | `nil`                                                        |
| `airflow.worker.command`                                                 | Override default container command (useful when using custom images)                                                                                                                                                           | `nil`                                                        |
| `airflow.worker.args`                                                    | Override default container args (useful when using custom images)                                                                                                                                                              | `nil`                                                        |
| `airflow.worker.podAnnotations`                                          | Additional annotations for Airflow worker pods                                                                                                                                                                                 | []                                                           |
| `airflow.worker.extraVolumeMounts`                                       | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`.                                                                                                                           | `nil`                                                        |
| `airflow.worker.extraVolumes`                                            | Array of extra volumes to be added deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                                    | `nil`                                                        |
| `airflow.auth.forcePassword`                                             | Force users to specify a password                                                                                                                                                                                              | `false`                                                      |
| `airflow.auth.username`                                                  | Username to access web UI                                                                                                                                                                                                      | `user`                                                       |
| `airflow.auth.password`                                                  | Password to access web UI                                                                                                                                                                                                      | `nil`                                                        |
| `airflow.auth.fernetKey`                                                 | Fernet key to secure connections                                                                                                                                                                                               | `nil`                                                        |
| `airflow.auth.existingSecret`                                            | Name of an existing secret containing airflow password and fernet key                                                                                                                                                          | `nil`                                                        |
| `airflow.extraEnvVars`                                                   | Extra environment variables to add to airflow web, worker and scheduler pods                                                                                                                                                   | `nil`                                                        |
| `airflow.web.resources.limits`                                           | The resources limits for the web containers                                                                                                                                                                                    | `{}`                                                         |
| `airflow.web.resources.requests`                                         | The requested resources for the web containers                                                                                                                                                                                 | `{}`                                                         |
| `airflow.web.extraEnvVars`                                               | Array containing extra env vars                                                                                                                                                                                                | `nil`                                                        |
| `airflow.web.extraEnvVarsCM`                                             | ConfigMap containing extra env vars                                                                                                                                                                                            | `nil`                                                        |
| `airflow.web.extraEnvVarsSecret`                                         | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                                   | `nil`                                                        |
| `airflow.web.command`                                                    | Override default container command (useful when using custom images)                                                                                                                                                           | `nil`                                                        |
| `airflow.web.args`                                                       | Override default container args (useful when using custom images)                                                                                                                                                              | `nil`                                                        |
| `airflow.web.extraVolumeMounts`                                          | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`.                                                                                                                           | `nil`                                                        |
| `airflow.web.extraVolumes`                                               | Array of extra volumes to be added deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                                    | `nil`                                                        |
| `airflow.scheduler.resources.limits`                                     | The resources limits for the scheduler containers                                                                                                                                                                              | `{}`                                                         |
| `airflow.scheduler.resources.requests`                                   | The requested resources for the scheduler containers                                                                                                                                                                           | `{}`                                                         |
| `airflow.scheduler.extraEnvVars`                                         | Array containing extra env vars                                                                                                                                                                                                | `nil`                                                        |
| `airflow.scheduler.extraEnvVarsCM`                                       | ConfigMap containing extra env vars                                                                                                                                                                                            | `nil`                                                        |
| `airflow.scheduler.extraEnvVarsSecret`                                   | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                                   | `nil`                                                        |
| `airflow.scheduler.command`                                              | Override default container command (useful when using custom images)                                                                                                                                                           | `nil`                                                        |
| `airflow.scheduler.args`                                                 | Override default container args (useful when using custom images)                                                                                                                                                              | `nil`                                                        |
| `airflow.scheduler.extraVolumeMounts`                                    | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`.                                                                                                                           | `nil`                                                        |
| `airflow.scheduler.extraVolumes`                                         | Array of extra volumes to be added deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                                    | `nil`                                                        |
| `airflow.webserverConfigMap`                                             | Config map name for ~/airflow/webserver_config.py                                                                                                                                                                              | `nil`                                                        |
| `ldap.enabled`                                                           | Enable LDAP support                                                                                                                                                                                                            | `false`                                                      |
| `ldap.uri`                                                               | LDAP URL beginning in the form `ldap[s]://<hostname>:<port>`                                                                                                                                                                   | `nil`                                                        |
| `ldap.base`                                                              | LDAP search base DN                                                                                                                                                                                                            | `nil`                                                        |
| `ldap.binddn`                                                            | LDAP bind DN                                                                                                                                                                                                                   | `nil`                                                        |
| `ldap.bindpw`                                                            | LDAP bind password                                                                                                                                                                                                             | `nil`                                                        |
| `ldap.uidField`                                                          | LDAP field used for uid                                                                                                                                                                                                        | `uid`                                                        |
| `ldap.tls.enabled`                                                       | Enable LDAP over TLS (LDAPS)                                                                                                                                                                                                   | `False`                                                      |
| `ldap.tls.allowSelfSigned`                                               | Allow self signed certicates for LDAPS                                                                                                                                                                                         | `True`                                                       |
| `ldap.tls.CAcertificateSecret`                                           | Name of the secret that contains the LDAPS CA cert file                                                                                                                                                                        | `uid`                                                        |
| `ldap.tls.CAcertificateFilename`                                         | LDAPS CA cert filename                                                                                                                                                                                                         | `uid`                                                        |
| `securityContext.enabled`                                                | Enable security context                                                                                                                                                                                                        | `true`                                                       |
| `securityContext.fsGroup`                                                | Group ID for the container                                                                                                                                                                                                     | `1001`                                                       |
| `securityContext.runAsUser`                                              | User ID for the container                                                                                                                                                                                                      | `1001`                                                       |
| `service.type`                                                           | Kubernetes Service type                                                                                                                                                                                                        | `ClusterIP`                                                  |
| `service.port`                                                           | Airflow Web port                                                                                                                                                                                                               | `8080`                                                       |
| `service.nodePort`                                                       | Kubernetes Service nodePort                                                                                                                                                                                                    | `nil`                                                        |
| `service.loadBalancerIP`                                                 | loadBalancerIP for Airflow Service                                                                                                                                                                                             | `nil`                                                        |
| `service.annotations`                                                    | Service annotations                                                                                                                                                                                                            | ``                                                           |
| `ingress.enabled`                                                        | Enable ingress controller resource                                                                                                                                                                                             | `false`                                                      |
| `ingress.certManager`                                                    | Add annotations for cert-manager                                                                                                                                                                                               | `false`                                                      |
| `ingress.annotations`                                                    | Ingress annotations                                                                                                                                                                                                            | `[]`                                                         |
| `ingress.hosts[0].name`                                                  | Hostname to your Airflow installation                                                                                                                                                                                          | `airflow.local`                                              |
| `ingress.hosts[0].path`                                                  | Path within the url structure                                                                                                                                                                                                  | `/`                                                          |
| `ingress.hosts[0].tls`                                                   | Utilize TLS backend in ingress                                                                                                                                                                                                 | `false`                                                      |
| `ingress.hosts[0].tlsHosts`                                              | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                                                                                                                                           | `nil`                                                        |
| `ingress.hosts[0].tlsSecret`                                             | TLS Secret (certificates)                                                                                                                                                                                                      | `airflow.local-tls`                                          |
| `ingress.secrets[0].name`                                                | TLS Secret Name                                                                                                                                                                                                                | `nil`                                                        |
| `ingress.secrets[0].certificate`                                         | TLS Secret Certificate                                                                                                                                                                                                         | `nil`                                                        |
| `ingress.secrets[0].key`                                                 | TLS Secret Key                                                                                                                                                                                                                 | `nil`                                                        |
| `podAffinityPreset`                                                      | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                            | `""`                                                         |
| `podAntiAffinityPreset`                                                  | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `soft`                                                       |
| `nodeAffinityPreset.type`                                                | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `""`                                                         |
| `nodeAffinityPreset.key`                                                 | Node label key to match Ignored if `affinity` is set.                                                                                                                                                                          | `""`                                                         |
| `nodeAffinityPreset.values`                                              | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                      | `[]`                                                         |
| `affinity`                                                               | Affinity for pod assignment                                                                                                                                                                                                    | `{}` (evaluated as a template)                               |
| `nodeSelector`                                                           | Node labels for pod assignment                                                                                                                                                                                                 | `{}` (evaluated as a template)                               |
| `tolerations`                                                            | Tolerations for pod assignment                                                                                                                                                                                                 | `[]` (evaluated as a template)                               |
| `livenessProbe.enabled`                                                  | would you like a livessProbed to be enabled                                                                                                                                                                                    | `true`                                                       |
| `livenessProbe.initialDelaySeconds`                                      | Delay before liveness probe is initiated                                                                                                                                                                                       | 180                                                          |
| `livenessProbe.periodSeconds`                                            | How often to perform the probe                                                                                                                                                                                                 | 20                                                           |
| `livenessProbe.timeoutSeconds`                                           | When the probe times out                                                                                                                                                                                                       | 5                                                            |
| `livenessProbe.failureThreshold`                                         | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                     | 6                                                            |
| `livenessProbe.successThreshold`                                         | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                                    | 1                                                            |
| `readinessProbe.enabled`                                                 | would you like a readinessProbe to be enabled                                                                                                                                                                                  | `true`                                                       |
| `readinessProbe.initialDelaySeconds`                                     | Delay before liveness probe is initiated                                                                                                                                                                                       | 30                                                           |
| `readinessProbe.periodSeconds`                                           | How often to perform the probe                                                                                                                                                                                                 | 10                                                           |
| `readinessProbe.timeoutSeconds`                                          | When the probe times out                                                                                                                                                                                                       | 5                                                            |
| `readinessProbe.failureThreshold`                                        | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                                     | 6                                                            |
| `readinessProbe.successThreshold`                                        | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                                    | 1                                                            |
| `postgresql.enabled`                                                     | Switch to enable or disable the PostgreSQL helm chart                                                                                                                                                                          | `true`                                                       |
| `postgresql.postgresqlUsername`                                          | Airflow Postgresql username                                                                                                                                                                                                    | `bn_airflow`                                                 |
| `postgresql.postgresqlPassword`                                          | Airflow Postgresql password                                                                                                                                                                                                    | `nil`                                                        |
| `postgresql.postgresqlDatabase`                                          | Airflow Postgresql database                                                                                                                                                                                                    | `bitnami_airflow`                                            |
| `postgresql.existingSecret`                                              | Name of an existing secret containing the PostgreSQL password ('postgresql-password' key) . This secret is used in case of postgresql.enabled=true and we would like to specify password for newly created postgresql instance | `nil`                                                        |
| `externalDatabase.host`                                                  | External PostgreSQL host                                                                                                                                                                                                       | `nil`                                                        |
| `externalDatabase.user`                                                  | External PostgreSQL user                                                                                                                                                                                                       | `nil`                                                        |
| `externalDatabase.password`                                              | External PostgreSQL password                                                                                                                                                                                                   | `nil`                                                        |
| `externalDatabase.database`                                              | External PostgreSQL database name                                                                                                                                                                                              | `nil`                                                        |
| `externalDatabase.port`                                                  | External PostgreSQL port                                                                                                                                                                                                       | `nil`                                                        |
| `externalDatabase.existingSecret`                                        | Name of an existing secret containing the PostgreSQL password ('postgresql-password' key)                                                                                                                                      | `nil`                                                        |
| `redis.enabled`                                                          | Switch to enable or disable the Redis helm chart                                                                                                                                                                               | `true`                                                       |
| `redis.existingSecret`                                                   | Name of an existing secret containing the Redis password ('redis-password' key) . This secret is used in case of redis.enabled=true and we would like to specify password for newly created redis instance                     | `nil`                                                        |
| `externalRedis.host`                                                     | External Redis host                                                                                                                                                                                                            | `nil`                                                        |
| `externalRedis.port`                                                     | External Redis port                                                                                                                                                                                                            | `nil`                                                        |
| `externalRedis.password`                                                 | External Redis password                                                                                                                                                                                                        | `nil`                                                        |
| `externalRedis.username`                                                 | External Redis username (not required on most Redis implementations)                                                                                                                                                           | `nil`                                                        |
| `externalRedis.existingSecret`                                           | Name of an existing secret containing the Redis password ('redis-password' key)                                                                                                                                                | `nil`                                                        |
| `metrics.enabled`                                                        | Start a side-car prometheus exporter                                                                                                                                                                                           | `false`                                                      |
| `metrics.image.registry`                                                 | Airflow exporter image registry                                                                                                                                                                                                | `docker.io`                                                  |
| `metrics.image.repository`                                               | Airflow exporter image name                                                                                                                                                                                                    | `bitnami/airflow-exporter`                                   |
| `metrics.image.tag`                                                      | Airflow exporter image tag                                                                                                                                                                                                     | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                                               | Image pull policy                                                                                                                                                                                                              | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`                                              | Specify docker-registry secret names as an array                                                                                                                                                                               | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`                                                 | Additional annotations for Metrics exporter                                                                                                                                                                                    | `{prometheus.io/scrape: "true", prometheus.io/port: "9112"}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
               --set airflow.auth.username=my-user \
               --set airflow.auth.password=my-passsword \
               --set airflow.auth.fernetKey=my-fernet-key \
               bitnami/airflow
```

The above command sets the credentials to access the Airflow web UI.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/airflow
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- URL used to access to airflow web ui:

```diff
- # airflow.baseUrl:
+ airflow.baseUrl: http://airflow.local
```

- Number of Airflow Worker replicas:

```diff
- airflow.worker.replicas: 1
+ airflow.worker.replicas: 3
```

- Force users to specify a password:

```diff
- airflow.auth.forcePassword: false
+ airflow.auth.forcePassword: true
```

- Enable ingress controller resource:

```diff
- ingress.enabled: false
+ ingress.enabled: true
```

### Generate a Fernet key

A Fernet key is required in order to encrypt password within connections. The Fernet key must be a base64-encoded 32-byte key.

Learn how to generate one [here](https://bcb.github.io/airflow/fernet-key)

### Load DAG files

There are three different ways to load your custom DAG files into the Airflow chart. All of them are compatible so you can use more than one at the same time.

#### Option 1: Load locally from the `files` folder

If you plan to deploy the chart from your filesystem, you can copy your DAG files inside the `files/dags` directory. A config map will be created with those files and it will be mounted in all airflow nodes.

#### Option 2: Specify an existing config map

You can manually create a config map containing all your DAG files and then pass the name when deploying Airflow chart. For that, you can pass the option `airflow.dagsConfigMap`.

#### Option 3: Get your DAG files from a git repository

You can store all your DAG files on GitHub repositories and then clone to the Airflow pods with an initContainer. The repositories will be periodically updated using a sidecar container. In order to do that, you can deploy airflow with the following options:

```console
airflow.cloneDagFilesFromGit.enabled=true
airflow.cloneDagFilesFromGit.repositories[0].repository=https://github.com/USERNAME/REPOSITORY
airflow.cloneDagFilesFromGit.repositories[0].name=REPO-IDENTIFIER
airflow.cloneDagFilesFromGit.repositories[0].branch=master
```

If you use a private repository from GitHub, a possible option to clone the files is using a [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) and using it as part of the URL: https://USERNAME:PERSONAL_ACCESS_TOKEN@github.com/USERNAME/REPOSITORY

### Loading Plugins

You can load plugins into the chart by specifying a git repository containing the plugin files. The repository will be periodically updated using a sidecar container. In order to do that, you can deploy airflow with the following options:

```console
airflow.clonePluginsFromGit.enabled=true
airflow.clonePluginsFromGit.repository=https://github.com/teamclairvoyant/airflow-rest-api-plugin.git
airflow.clonePluginsFromGit.branch=v1.0.9-branch
airflow.clonePluginsFromGit.path=plugins
```

### Existing Secrets

You can use an existing secret to configure your Airflow auth, external Postgres, and extern Redis passwords:

```console
postgresql.enabled=false
externalDatabase.host=my.external.postgres.host
externalDatabase.user=bn_airflow
externalDatabase.database=bitnami_airflow
externalDatabase.existingSecret=all-my-secrets

redis.enabled=false
externalRedis.host=my.external.redis.host
externalRedis.existingSecret=all-my-secrets

airflow.auth.existingSecret=all-my-secrets
```

The expected secret resource looks as follows:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: all-my-secrets
type: Opaque
data:
  airflow-password: "Smo1QTJLdGxXMg=="
  airflow-fernetKey: "YVRZeVJVWnlXbU4wY1dOalVrdE1SV3cxWWtKeFIzWkVRVTVrVjNaTFR6WT0="
  postgresql-password: "cG9zdGdyZXMK"
  redis-password: "cmVkaXMK"
```

This is useful if you plan on using [Bitnami's sealed secrets](https://github.com/bitnami-labs/sealed-secrets) to manage your passwords.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` paremeter. Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The Bitnami Airflow chart relies on the PostgreSQL chart persistence. This means that Airflow does not persist anything.

## Notable changes

### 6.5.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### 6.0.0

This release adds support for LDAP authentication.

### 1.0.0

This release updates the PostgreSQL chart dependency to use PostgreSQL 11.x. You need to migrate the existing PostgreSQL data to this version before upgrading to this release. For more information follow [this link](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#500).
