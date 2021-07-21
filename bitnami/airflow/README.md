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
- Helm 3.1.0

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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                                 | Description                                                                                                         | Value   |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------- | ------- |
| `kubeVersion`                        | Force target Kubernetes version (using Helm capabilities if not set)                                                | `""`    |
| `nameOverride`                       | String to partially override airflow.fullname template with a string (will prepend the release name)                | `""`    |
| `fullnameOverride`                   | String to fully override airflow.fullname template with a string                                                    | `""`    |
| `affinity`                           | Affinity for pod assignment (evaluated as a template)                                                               | `{}`    |
| `commonAnnotations`                  | Annotations to add to all deployed objects                                                                          | `{}`    |
| `commonLabels`                       | Labels to add to all deployed objects                                                                               | `{}`    |
| `containerSecurityContext.enabled`   | Enable container security context                                                                                   | `true`  |
| `containerSecurityContext.runAsUser` | User ID for the container                                                                                           | `1001`  |
| `extraDeploy`                        | A list of extra kubernetes resources to be deployed                                                                 | `[]`    |
| `extraEnvVars`                       | Extra environment variables to add to web, worker and scheduler pods                                                | `[]`    |
| `extraEnvVarsCM`                     | ConfigMap containing extra env vars to add to web, worker and scheduler pods                                        | `""`    |
| `extraEnvVarsSecret`                 | Secret containing extra env vars to add to web, worker and scheduler pods                                           | `""`    |
| `initContainers`                     | List of init containers to be added to the web, worker and scheduler pods                                           | `[]`    |
| `networkPolicies.enabled`            | Switch to enable network policies                                                                                   | `false` |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set.                                                              | `""`    |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                           | `""`    |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                           | `[]`    |
| `nodeSelector`                       | Node labels for pod assignment                                                                                      | `{}`    |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`.                                | `""`    |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`.                           | `soft`  |
| `podSecurityContext.enabled`         | Enable pod security context                                                                                         | `true`  |
| `podSecurityContext.fsGroup`         | fsGroup ID for the pod                                                                                              | `1001`  |
| `rbac.create`                        | If true, create & use RBAC resources                                                                                | `false` |
| `serviceAccount.annotations`         | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                          | `{}`    |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                                                | `false` |
| `serviceAccount.name`                | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |
| `sidecars`                           | List of sidecar containers to be added to web, worker and scheduler pods                                            | `[]`    |
| `tolerations`                        | Tolerations for pod assignment                                                                                      | `[]`    |


### Airflow common parameters

| Name                     | Description                                                                                                                                     | Value            |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `auth.existingSecret`    | Name of an existing secret containing password and fernet key ('airflow-password and 'airflow-fernetKey' keys)                                  | `""`             |
| `auth.fernetKey`         | Fernet key to secure connections                                                                                                                | `""`             |
| `auth.forcePassword`     | Force users to specify a password                                                                                                               | `false`          |
| `auth.password`          | Password to access web UI                                                                                                                       | `""`             |
| `auth.username`          | Username to access web UI                                                                                                                       | `user`           |
| `configurationConfigMap` | Name of an existing config map containing the Airflow config file                                                                               | `""`             |
| `executor`               | Airflow executor, it should be one of 'SequentialExecutor', 'LocalExecutor', 'CeleryExecutor', 'KubernetesExecutor', 'CeleryKubernetesExecutor' | `CeleryExecutor` |
| `dagsConfigMap`          | Name of an existing config map containing all the DAGs files you want to load in Airflow                                                        | `""`             |
| `loadExamples`           | Switch to load some Airflow examples                                                                                                            | `false`          |


### Airflow web parameters

| Name                                     | Description                                                                 | Value                |
| ---------------------------------------- | --------------------------------------------------------------------------- | -------------------- |
| `web.image.registry`                     | Airflow image registry                                                      | `docker.io`          |
| `web.image.repository`                   | Airflow image repository                                                    | `bitnami/airflow`    |
| `web.image.tag`                          | Airflow image tag (immutable tags are recommended)                          | `2.1.2-debian-10-r0` |
| `web.image.pullPolicy`                   | Airflow image pull policy                                                   | `IfNotPresent`       |
| `web.image.pullSecrets`                  | Airflow image pull secrets                                                  | `[]`                 |
| `web.image.debug`                        | Enable image debug mode                                                     | `false`              |
| `web.replicaCount`                       | Number of web replicas                                                      | `1`                  |
| `web.hostAliases`                        | Deployment pod host aliases                                                 | `[]`                 |
| `web.baseUrl`                            | URL used to access to airflow web ui                                        | `""`                 |
| `web.configMap`                          | Name of an existing config map containing the Airflow webserver config file | `""`                 |
| `web.command`                            | Override default container command (useful when using custom images)        | `[]`                 |
| `web.args`                               | Override default container args (useful when using custom images)           | `[]`                 |
| `web.podLabels`                          | Add extra labels to the web's pods                                          | `{}`                 |
| `web.podAnnotations`                     | Add extra annotations to the web's pods                                     | `{}`                 |
| `web.containerPort`                      | Container port to be used for exposing http server                          | `8080`               |
| `web.extraVolumeMounts`                  | Add extra volume mounts                                                     | `[]`                 |
| `web.extraVolumes`                       | Add extra volumes                                                           | `[]`                 |
| `web.extraEnvVars`                       | Array containing extra environment variables                                | `[]`                 |
| `web.extraEnvVarsCM`                     | ConfigMap containing extra environment variables                            | `""`                 |
| `web.extraEnvVarsSecret`                 | Secret containing extra environment variables (in case of sensitive data)   | `""`                 |
| `web.resources.limits`                   | The resources limits for the Web container                                  | `{}`                 |
| `web.resources.requests`                 | The requested resources for the Web container                               | `{}`                 |
| `web.livenessProbe.enabled`              | Enable livenessProbe                                                        | `true`               |
| `web.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                     | `180`                |
| `web.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                            | `20`                 |
| `web.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                           | `5`                  |
| `web.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                         | `6`                  |
| `web.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                         | `1`                  |
| `web.readinessProbe.enabled`             | Enable readinessProbe                                                       | `true`               |
| `web.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                    | `30`                 |
| `web.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                           | `10`                 |
| `web.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                          | `5`                  |
| `web.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                        | `6`                  |
| `web.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                        | `1`                  |
| `web.customLivenessProbe`                | Custom liveness probe for the Web component                                 | `{}`                 |
| `web.customReadinessProbe`               | Custom rediness probe for the Web component                                 | `{}`                 |
| `web.podDisruptionBudget.enabled`        | Enable PodDisruptionBudget for web pods                                     | `false`              |
| `web.podDisruptionBudget.minAvailable`   | Minimum available instances; ignored if there is no PodDisruptionBudget     | `1`                  |
| `web.podDisruptionBudget.maxUnavailable` | Maximum available instances; ignored if there is no PodDisruptionBudget     | `""`                 |
| `web.sidecars`                           | Add sidecars to the Web pods                                                | `[]`                 |
| `web.initContainers`                     | Add initContainers to the Web pods                                          | `[]`                 |
| `web.priorityClassName`                  | Priority Class Name                                                         | `""`                 |
| `web.nodeSelector`                       | Node labels for pod assignment                                              | `{}`                 |
| `service.type`                           | Airflow service type                                                        | `ClusterIP`          |
| `service.port`                           | Airflow service HTTP port                                                   | `8080`               |
| `service.nodePort`                       | Airflow service NodePort                                                    | `""`                 |
| `service.loadBalancerIP`                 | loadBalancerIP if service type is `LoadBalancer` (optional, cloud specific) | `""`                 |
| `service.annotations`                    | Additional custom annotations for Airflow service                           | `{}`                 |


### Airflow scheduler parameters

| Name                                         | Description                                                             | Value                       |
| -------------------------------------------- | ----------------------------------------------------------------------- | --------------------------- |
| `scheduler.image.registry`                   | Airflow Scheduler image registry                                        | `docker.io`                 |
| `scheduler.image.repository`                 | Airflow Scheduler image repository                                      | `bitnami/airflow-scheduler` |
| `scheduler.image.tag`                        | Airflow Scheduler image tag (immutable tags are recommended)            | `2.1.1-debian-10-r10`       |
| `scheduler.image.pullPolicy`                 | Airflow Scheduler image pull policy                                     | `IfNotPresent`              |
| `scheduler.image.pullSecrets`                | Airflow Scheduler image pull secrets                                    | `[]`                        |
| `scheduler.image.debug`                      | Enable image debug mode                                                 | `false`                     |
| `scheduler.replicaCount`                     | Number of scheduler replicas                                            | `1`                         |
| `scheduler.command`                          | Override cmd                                                            | `[]`                        |
| `scheduler.args`                             | Override args                                                           | `[]`                        |
| `scheduler.hostAliases`                      | Deployment pod host aliases                                             | `[]`                        |
| `scheduler.podLabels`                        | Add extra labels to the web's pods                                      | `{}`                        |
| `scheduler.podAnnotations`                   | Add extra annotations to the web's pods                                 | `{}`                        |
| `scheduler.extraVolumeMounts`                | Add extra volume mounts                                                 | `[]`                        |
| `scheduler.extraVolumes`                     | Add extra volumes                                                       | `[]`                        |
| `scheduler.extraEnvVars`                     | Add extra environment variables                                         | `[]`                        |
| `scheduler.extraEnvVarsCM`                   | ConfigMap with extra environment variables                              | `""`                        |
| `scheduler.extraEnvVarsSecret`               | Secret with extra environment variables                                 | `""`                        |
| `scheduler.resources.limits`                 | The resources limits for the Scheduler container                        | `{}`                        |
| `scheduler.resources.requests`               | The requested resources for the Scheduler container                     | `{}`                        |
| `scheduler.customLivenessProbe`              | Custom Liveness probe                                                   | `{}`                        |
| `scheduler.customReadinessProbe`             | Custom Liveness probe                                                   | `{}`                        |
| `scheduler.podDisruptionBudget.enabled`      | Enable PodDisruptionBudget for scheduler pods                           | `false`                     |
| `scheduler.podDisruptionBudget.minAvailable` | Minimum available instances; ignored if there is no PodDisruptionBudget | `1`                         |
| `scheduler.sidecars`                         | Add sidecars to the scheduler pods.                                     | `[]`                        |
| `scheduler.initContainers`                   | Add initContainers to the scheduler pods.                               | `[]`                        |
| `scheduler.priorityClassName`                | Priority Class Name                                                     | `""`                        |
| `scheduler.nodeSelector`                     | Node labels for pod assignment                                          | `{}`                        |


### Airflow worker parameters

| Name                                        | Description                                                                                                          | Value                    |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `worker.image.registry`                     | Airflow Worker image registry                                                                                        | `docker.io`              |
| `worker.image.repository`                   | Airflow Worker image repository                                                                                      | `bitnami/airflow-worker` |
| `worker.image.tag`                          | Airflow Worker image tag (immutable tags are recommended)                                                            | `2.1.1-debian-10-r9`     |
| `worker.image.pullPolicy`                   | Airflow Worker image pull policy                                                                                     | `IfNotPresent`           |
| `worker.image.pullSecrets`                  | Airflow Worker image pull secrets                                                                                    | `[]`                     |
| `worker.image.debug`                        | Enable image debug mode                                                                                              | `false`                  |
| `worker.port`                               | Port where the worker will be exposed                                                                                | `8793`                   |
| `worker.replicaCount`                       | Number of worker replicas                                                                                            | `1`                      |
| `worker.hostAliases`                        | Deployment pod host aliases                                                                                          | `[]`                     |
| `worker.podTemplate`                        | Template to replace the default one to be use when `executor=KubernetesExecutor` to create worker pods               | `{}`                     |
| `worker.podManagementPolicy`                | podManagementPolicy to manage scaling operation of worker pods                                                       | `""`                     |
| `worker.command`                            | Override cmd                                                                                                         | `[]`                     |
| `worker.args`                               | Override args                                                                                                        | `[]`                     |
| `worker.podAnnotations`                     | Add annotations to the worker pods                                                                                   | `{}`                     |
| `worker.podLabels`                          | Add extra labels to the web's pods                                                                                   | `{}`                     |
| `worker.extraVolumeMounts`                  | Add extra volume mounts                                                                                              | `[]`                     |
| `worker.extraVolumes`                       | Add extra volumes                                                                                                    | `[]`                     |
| `worker.extraEnvVars`                       | Add extra environment variables                                                                                      | `[]`                     |
| `worker.extraEnvVarsCM`                     | ConfigMap with extra environment variables                                                                           | `""`                     |
| `worker.extraEnvVarsSecret`                 | Secret with extra environment variables                                                                              | `""`                     |
| `worker.resources.limits`                   | The resources limits for the Worker container                                                                        | `{}`                     |
| `worker.resources.requests`                 | The requested resources for the Worker container                                                                     | `{}`                     |
| `worker.livenessProbe.enabled`              | Enable livenessProbe                                                                                                 | `true`                   |
| `worker.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                              | `180`                    |
| `worker.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                     | `20`                     |
| `worker.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                    | `5`                      |
| `worker.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                  | `6`                      |
| `worker.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                  | `1`                      |
| `worker.readinessProbe.enabled`             | Enable readinessProbe                                                                                                | `true`                   |
| `worker.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                             | `30`                     |
| `worker.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                    | `10`                     |
| `worker.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                   | `5`                      |
| `worker.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                 | `6`                      |
| `worker.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                 | `1`                      |
| `worker.customLivenessProbe`                | Custom Liveness probe                                                                                                | `{}`                     |
| `worker.customReadinessProbe`               | Custom Liveness probe                                                                                                | `{}`                     |
| `worker.podDisruptionBudget.enabled`        | Enable PodDisruptionBudget for worker pods                                                                           | `false`                  |
| `worker.podDisruptionBudget.minAvailable`   | Minimum available instances; ignored if there is no PodDisruptionBudget                                              | `1`                      |
| `worker.podDisruptionBudget.maxUnavailable` | Maximum available instances; ignored if there is no PodDisruptionBudget                                              | `""`                     |
| `worker.autoscaling.enabled`                | Whether enable horizontal pod autoscale                                                                              | `false`                  |
| `worker.autoscaling.replicas.min`           | Configure a minimum amount of pods                                                                                   | `1`                      |
| `worker.autoscaling.replicas.max`           | Configure a maximum amount of pods                                                                                   | `3`                      |
| `worker.autoscaling.targets.cpu`            | Define the CPU target to trigger the scaling actions (utilization percentage)                                        | `80`                     |
| `worker.autoscaling.targets.memory`         | Define the memory target to trigger the scaling actions (utilization percentage)                                     | `80`                     |
| `worker.updateStrategy`                     | StatefulSet controller supports automated updates. There are two valid update strategies: RollingUpdate and OnDelete | `RollingUpdate`          |
| `worker.rollingUpdatePartition`             | Partition update strategy                                                                                            | `""`                     |
| `worker.sidecars`                           | Add sidecars to the worker pods.                                                                                     | `[]`                     |
| `worker.initContainers`                     | Add initContainers to the worker pods.                                                                               | `[]`                     |
| `worker.priorityClassName`                  | Priority Class Name                                                                                                  | `""`                     |
| `worker.nodeSelector`                       | Node labels for pod assignment                                                                                       | `{}`                     |
| `worker.affinity`                           | Affinity for worker pod assignment                                                                                   | `{}`                     |
| `worker.tolerations`                        | Tolerations for worker pod assignment                                                                                | `[]`                     |


### Airflow git sync parameters

| Name                           | Description                                                                            | Value                  |
| ------------------------------ | -------------------------------------------------------------------------------------- | ---------------------- |
| `git.image.registry`           | Git image registry                                                                     | `docker.io`            |
| `git.image.repository`         | Git image repository                                                                   | `bitnami/git`          |
| `git.image.tag`                | Git image tag (immutable tags are recommended)                                         | `2.32.0-debian-10-r33` |
| `git.image.pullPolicy`         | Git image pull policy                                                                  | `IfNotPresent`         |
| `git.image.pullSecrets`        | Git image pull secrets                                                                 | `[]`                   |
| `git.dags.enabled`             | Enable in order to download DAG files from git repositories.                           | `false`                |
| `git.dags.repositories`        | Array of repositories from which to download DAG files                                 | `[]`                   |
| `git.plugins.enabled`          | Enable in order to download Plugins files from git repositories.                       | `false`                |
| `git.plugins.repositories`     | Array of repositories from which to download DAG files                                 | `[]`                   |
| `git.clone.command`            | Override cmd                                                                           | `[]`                   |
| `git.clone.args`               | Override args                                                                          | `[]`                   |
| `git.clone.extraVolumeMounts`  | Add extra volume mounts                                                                | `[]`                   |
| `git.clone.extraEnvVars`       | Add extra environment variables                                                        | `[]`                   |
| `git.clone.extraEnvVarsCM`     | ConfigMap with extra environment variables                                             | `""`                   |
| `git.clone.extraEnvVarsSecret` | Secret with extra environment variables                                                | `""`                   |
| `git.clone.resources`          | Clone init container resource requests and limits                                      | `{}`                   |
| `git.sync.interval`            | Interval in seconds to pull the git repository containing the plugins and/or DAG files | `60`                   |
| `git.sync.command`             | Override cmd                                                                           | `[]`                   |
| `git.sync.args`                | Override args                                                                          | `[]`                   |
| `git.sync.extraVolumeMounts`   | Add extra volume mounts                                                                | `[]`                   |
| `git.sync.extraEnvVars`        | Add extra environment variables                                                        | `[]`                   |
| `git.sync.extraEnvVarsCM`      | ConfigMap with extra environment variables                                             | `""`                   |
| `git.sync.extraEnvVarsSecret`  | Secret with extra environment variables                                                | `""`                   |
| `git.sync.resources`           | Sync sidecar container resource requests and limits                                    | `{}`                   |


### Airflow ldap parameters

| Name                             | Description                                                                                      | Value                      |
| -------------------------------- | ------------------------------------------------------------------------------------------------ | -------------------------- |
| `ldap.enabled`                   | Enable LDAP authentication                                                                       | `false`                    |
| `ldap.uri`                       | Server URI, eg. ldap://ldap_server:389                                                           | `ldap://ldap_server:389`   |
| `ldap.base`                      | Base of the search, eg. ou=example,o=org                                                         | `ou=example,o=org`         |
| `ldap.binddn`                    | Bind DN                                                                                          | `cn=user,ou=example,o=org` |
| `ldap.bindpw`                    | Bind Password                                                                                    | `""`                       |
| `ldap.uidField`                  | Field used for uid                                                                               | `uid`                      |
| `ldap.tls.enabled`               | Enabled TLS/SSL for LDAP, you must include the CA file.                                          | `false`                    |
| `ldap.tls.allowSelfSigned`       | Allow to use self signed certificates                                                            | `true`                     |
| `ldap.tls.CAcertificateSecret`   | Name of the existing secret containing the certificate CA file that will be used by ldap client. | `""`                       |
| `ldap.tls.CAcertificateFilename` | LDAP CA cert filename                                                                            | `""`                       |


### Airflow exposing parameters

| Name                  | Description                                                                            | Value                    |
| --------------------- | -------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`     | Set to true to enable ingress record generation                                        | `false`                  |
| `ingress.apiVersion`  | Override API Version (automatically detected if not set)                               | `""`                     |
| `ingress.pathType`    | Ingress Path type                                                                      | `ImplementationSpecific` |
| `ingress.certManager` | Set this to true in order to add the corresponding annotations for cert-manager        | `false`                  |
| `ingress.annotations` | Ingress annotations done as key:value pairs                                            | `{}`                     |
| `ingress.hosts`       | The list of hostnames to be covered with this ingress record.                          | `[]`                     |
| `ingress.secrets`     | If you're providing your own certificates, use this to add the certificates as secrets | `[]`                     |


### Airflow database parameters

| Name                                         | Description                                                                                     | Value             |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------- |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                                           | `true`            |
| `postgresql.postgresqlUsername`              | Airflow Postgresql username                                                                     | `bn_airflow`      |
| `postgresql.postgresqlPassword`              | Airflow Postgresql password                                                                     | `""`              |
| `postgresql.postgresqlDatabase`              | Airflow Postgresql database                                                                     | `bitnami_airflow` |
| `postgresql.existingSecret`                  | Name of an existing secret containing the PostgreSQL password ('postgresql-password' key)       | `""`              |
| `externalDatabase.host`                      | Database host                                                                                   | `localhost`       |
| `externalDatabase.user`                      | non-root Username for Airflow Database                                                          | `bn_airflow`      |
| `externalDatabase.password`                  | Database password                                                                               | `""`              |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the DB password                                  | `""`              |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the DB password                                       | `""`              |
| `externalDatabase.database`                  | Database name                                                                                   | `bitnami_airflow` |
| `externalDatabase.port`                      | Database port number                                                                            | `5432`            |
| `redis.enabled`                              | Switch to enable or disable the Redis(TM) helm                                                  | `true`            |
| `redis.auth.enabled`                         | Switch to enable or disable authentication                                                      | `true`            |
| `redis.auth.password`                        | Redis(TM) password                                                                              | `""`              |
| `redis.auth.existingSecret`                  | Name of existing secret object containing the password                                          | `""`              |
| `redis.architecture`                         | Cluster settings                                                                                | `standalone`      |
| `externalRedis.host`                         | Redis(TM) host                                                                                  | `localhost`       |
| `externalRedis.port`                         | Redis(TM) port number                                                                           | `6379`            |
| `externalRedis.password`                     | Redis(TM) password                                                                              | `""`              |
| `externalRedis.existingSecret`               | Name of an existing secret resource containing the Redis(TM) password in a 'redis-password' key | `""`              |
| `externalRedis.username`                     | Redis(TM) username                                                                              | `""`              |


### Airflow metrics parameters

| Name                                   | Description                                                 | Value                         |
| -------------------------------------- | ----------------------------------------------------------- | ----------------------------- |
| `metrics.enabled`                      | Start a side-car prometheus exporter                        | `false`                       |
| `metrics.image.registry`               | Airflow Exporter image registry                             | `docker.io`                   |
| `metrics.image.repository`             | Airflow Exporter image repository                           | `bitnami/airflow-exporter`    |
| `metrics.image.tag`                    | Airflow Exporter image tag (immutable tags are recommended) | `0.20210126.0-debian-10-r153` |
| `metrics.image.pullPolicy`             | Airflow Exporter image pull policy                          | `IfNotPresent`                |
| `metrics.image.pullSecrets`            | Airflow Exporter image pull secrets                         | `[]`                          |
| `metrics.hostAliases`                  | Deployment pod host aliases                                 | `[]`                          |
| `metrics.serviceMonitor.enabled`       | Create ServiceMonitor resource                              | `false`                       |
| `metrics.serviceMonitor.namespace`     | The namespace in which the ServiceMonitor will be created   | `""`                          |
| `metrics.serviceMonitor.interval`      | Interval in which prometheus scrapes                        | `60s`                         |
| `metrics.serviceMonitor.scrapeTimeout` | Scrape Timeout duration for prometheus                      | `10s`                         |
| `metrics.serviceMonitor.labels`        | Additional labels to attach                                 | `{}`                          |
| `metrics.resources`                    | Metrics exporter resource requests and limits               | `{}`                          |
| `metrics.tolerations`                  | Metrics exporter labels and tolerations for pod assignment  | `[]`                          |
| `metrics.podLabels`                    | Metrics exporter pod Annotation and Labels                  | `{}`                          |
| `metrics.nodeSelector`                 | Node labels for pod assignment                              | `{}`                          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
               --set auth.username=my-user \
               --set auth.password=my-passsword \
               --set auth.fernetKey=my-fernet-key \
               bitnami/airflow
```

The above command sets the credentials to access the Airflow web UI.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/airflow
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Generate a Fernet key

A Fernet key is required in order to encrypt password within connections. The Fernet key must be a base64-encoded 32-byte key.

Learn how to generate one [here](https://bcb.github.io/airflow/fernet-key)

### Load DAG files

There are two different ways to load your custom DAG files into the Airflow chart. All of them are compatible so you can use more than one at the same time.

#### Option 1: Specify an existing config map

You can manually create a config map containing all your DAG files and then pass the name when deploying Airflow chart. For that, you can pass the option `dagsConfigMap`.

#### Option 2: Get your DAG files from a git repository

You can store all your DAG files on GitHub repositories and then clone to the Airflow pods with an initContainer. The repositories will be periodically updated using a sidecar container. In order to do that, you can deploy airflow with the following options:

> NOTE: When enabling git synchronization, an init container and sidecar container will be added for all the pods running airflow, this will allow scheduler, worker and web component to reach dags if it was needed.

```console
git.dags.enabled=true
git.dags.repositories[0].repository=https://github.com/USERNAME/REPOSITORY
git.dags.repositories[0].name=REPO-IDENTIFIER
git.dags.repositories[0].branch=master
```

If you use a private repository from GitHub, a possible option to clone the files is using a [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) and using it as part of the URL: https://USERNAME:PERSONAL_ACCESS_TOKEN@github.com/USERNAME/REPOSITORY

### Loading Plugins

You can load plugins into the chart by specifying a git repository containing the plugin files. The repository will be periodically updated using a sidecar container. In order to do that, you can deploy airflow with the following options:

> NOTE: When enabling git synchronization, an init container and sidecar container will be added for all the pods running airflow, this will allow scheduler, worker and web component to reach plugins if it was needed.

```console
git.plugins.enabled=true
git.plugins.repositories[0].repository=https://github.com/teamclairvoyant/airflow-rest-api-plugin.git
git.plugins.repositories[0].branch=v1.0.9-branch
git.plugins.repositories[0].path=plugins
```

### Existing Secrets

You can use an existing secret to configure your Airflow auth, external Postgres, and external Redis<sup>TM</sup> passwords:

```console
postgresql.enabled=false
externalDatabase.host=my.external.postgres.host
externalDatabase.user=bn_airflow
externalDatabase.database=bitnami_airflow
externalDatabase.existingSecret=all-my-secrets

redis.enabled=false
externalRedis.host=my.external.redis.host
externalRedis.existingSecret=all-my-secrets

auth.existingSecret=all-my-secrets
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

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Install extra python packages

This chart allows you to mount volumes using `extraVolumes` and `extraVolumeMounts` in all 3 airflow components (web, scheduler, worker). Mounting a requirements.txt using these options to `/bitnami/python/requirements.txt` will execute `pip install -r /bitnami/python/requirements.txt` on container start. [Reference](https://github.com/bitnami/bitnami-docker-airflow/blob/cafc8eab1efddb5efda5a00cc861ef10f35f1d49/1/debian-10/rootfs/run.sh#L14)

### Enabling network policies

This chart allows you to set network policies that will rectrict the access to the deployed pods in the cluster. Basically, no other pods apart from Scheduler's pods may access Worker's pods and no other pods apart from Web's pods may access Worker's ones. To do so, set `networkPolicies.enabled=true`.

### Executors

Airflow supports different executors runtimes and this chart provides support for the following ones.

#### CeleryExecutor

Celery executor is the default value for this chart with it you can scale out the number of workers. To point the `executor` parameter to `CeleryExecutor` you need to do something, you just install the chart with default parameters.

#### KubernetesExecutor

The kubernetes executor is introduced in Apache Airflow 1.10.0. The Kubernetes executor will create a new pod for every task instance using the `pod_template.yaml` that you can find [templates/config/configmap.yaml](https://github.com/bitnami/charts/blob/master/bitnami/airflow/templates/config/configmap.yaml), otherwise you can override this template using `worker.podTemplate`. To enable `KubernetesExecutor` set the following parameters.

> NOTE: Redis<sup>TM</sup> is not needed to be deployed when using KubernetesExecutor so you must disable it using `redis.enabled=false`.

```console
executor=KubernetesExecutor
redis.enabled=false
rbac.create=true
serviceaccount.create=true
```

### CeleryKubernetesExecutor

The CeleryKubernetesExecutor is introduced in Airflow 2.0 and is a combination of both the Celery and the Kubernetes executors. Tasks will be executed using Celery by default, but those tasks that require it can be executed in a Kubernetes pod using the 'kubernetes' queue.

#### LocalExecutor

Local executor runs tasks by spawning processes in the Scheduler pods. To enable `LocalExecutor` set the following parameters.

```console
executor=LocalExecutor
redis.enabled=false
```

#### SequentialExecutor

This executor will only run one task instance at a time in the Scheduler pods. For production use case, please use other executors. To enable `SequentialExecutor` set the following parameters.

```console
executor=SequentialExecutor
redis.enabled=false
```

### Scaling worker pods

Sometime when using large workloads a fixed number of worker pods may make task to take a long time to be executed. This chart provide two ways for scaling worker pods.

- If you are using `KubernetesExecutor` auto scaling pods would be done by the Scheduler without adding anything more.
- If you are using `SequentialExecutor` you would have to enable `worker.autoscaling` to do so, please, set the following parameters. It will use autoscaling by default configuration that you can change using `worker.autoscaling.replicas.*` and `worker.autoscaling.targets.*`.

```console
worker.autoscaling.enabled=true
worker.resources.requests.cpu=200m
worker.resources.requests.memory=250Mi
```

## Persistence

The Bitnami Airflow chart relies on the PostgreSQL chart persistence. This means that Airflow does not persist anything.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Notable changes

### To 10.0.0

This major updates the Redis<sup>TM</sup> subchart to it newest major, 14.0.0, which contains breaking changes. For more information on this subchart's major and the steps needed to migrate your data from your previous release, please refer to [Redis<sup>TM</sup> upgrade notes.](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1400).

### To 7.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the _requirements.yaml_ to the _Chart.yaml_.
- After running `helm dependency update`, a _Chart.lock_ file is generated containing the same structure used in the previous _requirements.lock_.
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts.
- Several parameters were renamed or disappeared in favor of new ones on this major version:

  - The image objects have been moved to its corresponding component object, e.g: `workerImage.*` now is located at `worker.image.*`.
  - The prefix _airflow_ has been removed. Therefore, parameters prefixed with `airflow` are now at root level, e.g. `airflow.loadExamples` now is `loadExamples` or `airflow.worker.resources` now is `worker.resources`.
  - Parameters related to the _git_ features has completely been refactored, please see how to configure git for [dags](#loaddagfiles) and [plugins](#loadingplugins) sections for more details.
    - They have been moved to `git.*` prefix.
    - `airflow.cloneDagsFromGit.*` no longer exists, instead you must use `git.dags.*` and `git.dags.repositories[*]` has been introduced that will add support for multiple repositories.
    - `airflow.clonePluginsFromGit.*` no longer exists, instead you must use `git.plugins.*`. `airflow.clonePluginsFromGit.repository`, `airflow.clonePluginsFromGit.branch` and `airflow.clonePluginsFromGit.path` have been removed in favour of `git.dags.repositories[*].*`.
  - Liveness and readiness probe have been separated by components `airflow.livenessProbe.*` and `airflow.readinessProbe` have been removed in favour of `web.livenessProbe`, `worker.livenessProbe`, `web.readinessProbe` and `worker.readinessProbe`.
  - `airflow.baseUrl` has been moved to `web.baseUrl`.
  - Security context has been migrated to the bitnami standard way so that `securityContext.*` has been divided into `podSecurityContext.*` that will define the `fsGroup` for all the containers in the pod and `containerSecurityContext.*` that will define the user id that will run the main containers.
  - Both `bitnami/postgresql` and `bitnami/redis` have been upgraded to their latest major versions, `10.x.x` and `11.x.x` respectively, find more info in their READMEs [`bitnami/postgresql`](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1000) and [`bitnami/redis`](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1100)
  - `./files/dags/*.py` will not be include in the deployment any more.

- Some new features:
  - The folder structure has changed, we separated yaml manifest into folders by components.
  - Network policies has been added see more in the [Enabling network policies](#enablingnetworkpolicies) section.
  - Executors, this new version add support for the different executors that airflow implements, see more in the [Executors](#executors) section.
  - Worker scaling functionality has been added, see more in the [Scaling worker pods](#scalingworkerpods).
  - Pod disruption budget has been added.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3
- If you want to upgrade to this version from a previous one installed with Helm v3, you can try to follow the following steps:

> NOTE: Please, create a backup of your database before running any of those actions.

Having an already existing chart release called `airflow` and deployed like

```console
$ helm install airflow bitnami/airflow \
    --set airflow.loadExamples=true \
    --set airflow.baseUrl=http://127.0.0.1:8080
```

##### Export secrets and required values to update

```console
$ export AIRFLOW_PASSWORD=$(kubectl get secret --namespace default airflow -o jsonpath="{.data.airflow-password}" | base64 --decode)
$ export AIRFLOW_FERNETKEY=$(kubectl get secret --namespace default airflow -o jsonpath="{.data.airflow-fernetKey}" | base64 --decode)
$ export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default airflow-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
$ export REDIS_PASSWORD=$(kubectl get secret --namespace default airflow-redis -o jsonpath="{.data.redis-password}" | base64 --decode)
$ export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=airflow,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

##### Delete statefulsets

Once the new version change fields in the statefulset that will make the upgrade action to fail you will need to remove them

> NOTE: Don't forget to set `--cascade=false`

```
$ kubectl delete statefulsets.apps --cascade=false airflow-postgresql
$ kubectl delete statefulsets.apps --cascade=false airflow-worker
```

##### Upgrade the chart release

> NOTE: Please remember to migrate all the values to its new path following the above notes, e.g: `airflow.loadExamples` -> `loadExamples` or `airflow.baseUrl=http://127.0.0.1:8080` -> `web.baseUrl=http://127.0.0.1:8080`.

```console
$ helm upgrade airflow bitnami/airflow \
    --set loadExamples=true \
    --set web.baseUrl=http://127.0.0.1:8080 \
    --set auth.password=$AIRFLOW_PASSWORD \
    --set auth.fernetKey=$AIRFLOW_FERNETKEY \
    --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
    --set redis.password=$REDIS_PASSWORD \
    --set redis.cluster.enabled=true
```

##### Force new statefulset to create a new pod for postgresql

```console
$ kubectl delete pod airflow-postgresql-0
```

#### Useful links

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 6.5.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 6.0.0

This release adds support for LDAP authentication.

### To 1.0.0

This release updates the PostgreSQL chart dependency to use PostgreSQL 11.x. You need to migrate the existing PostgreSQL data to this version before upgrading to this release. For more information follow [this link](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#500).
