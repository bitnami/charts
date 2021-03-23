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

The following tables lists the configurable parameters of the Airflow chart and their default values.

| Parameter                 | Description                                     | Default                                                 |
| ------------------------- | ----------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter                            | Description                                                                                                             | Default                        |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `affinity`                           | Affinity for pod assignment (evaluated as a template)                                                                   | `{}`                           |
| `commonAnnotations`                  | Annotations to add to all deployed objects                                                                              | `{}`                           |
| `commonLabels`                       | Labels to add to all deployed objects                                                                                   | `{}`                           |
| `containerSecurityContext.enabled`   | Enable container security context                                                                                       | `true`                         |
| `containerSecurityContext.runAsUser` | User ID for the container                                                                                               | `1001`                         |
| `extraDeploy`                        | A list of extra kubernetes resources to be deployed                                                                     | `[]`                           |
| `kubeVersion`                        | Force target Kubernetes version (using Helm capabilities if not set)                                                    | `nil`                          |
| `extraEnvVars`                       | Extra environment variables to add to web, worker and scheduler pods                                                    | `nil`                          |
| `extraEnvVarsCM`                     | ConfigMap containing extra env vars to add to web, worker and scheduler pods                                            | `nil`                          |
| `extraEnvVarsSecret`                 | Secret containing extra env vars to add to web, worker and scheduler pods                                               | `nil`                          |
| `fullnameOverride`                   | String to fully override airflow.fullname template with a string                                                        | `nil`                          |
| `initContainers`                     | List of init containers to be added to the web, worker and scheduler pods                                               | `nil`                          |
| `nameOverride`                       | String to partially override airflow.fullname template with a string (will prepend the release name)                    | `nil`                          |
| `networkPolicies.enabled`            | Switch to enable network policies                                                                                       | `false`                        |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                                                   | `""`                           |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                               | `""`                           |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                               | `[]`                           |
| `nodeSelector`                       | Node labels for pod assignment                                                                                          | `{}` (evaluated as a template) |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                     | `""`                           |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `soft`                         |
| `podSecurityContext.enabled`         | Enable pod security context                                                                                             | `true`                         |
| `podSecurityContext.fsGroup`         | fsGroup ID for the pod                                                                                                  | `1001`                         |
| `rbac.create`                        | If true, create & use RBAC resources                                                                                    | `false`                        |
| `serviceAccount.annotations`         | Annotations for service account                                                                                         | `{}`                           |
| `serviceAccount.create`              | If true, create a service account                                                                                       | `false`                        |
| `serviceAccount.name`                | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | ``                             |
| `sidecars`                           | List of sidecar containers to be adde to web, worker and scheduler pods                                                 | `nil`                          |
| `tolerations`                        | Tolerations for pod assignment                                                                                          | `[]` (evaluated as a template) |

### Airflow common parameters

| Parameter                | Description                                                                                                          | Default            |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------- | ------------------ |
| `auth.existingSecret`    | Name of an existing secret containing password and fernet key ('airflow-password and 'airflow-fernetKey' keys)       | `nil`              |
| `auth.fernetKey`         | Fernet key to secure connections                                                                                     | `nil`              |
| `auth.forcePassword`     | Force users to specify a password                                                                                    | `false`            |
| `auth.password`          | Password to access web UI                                                                                            | `nil`              |
| `auth.username`          | Username to access web UI                                                                                            | `user`             |
| `configurationConfigMap` | Name of an existing config map containing the Airflow config file                                                    | `nil`              |
| `dagsConfigMap`          | Name of an existing config map containing all the DAGs files you want to load in Airflow.                            | `nil`              |
| `executor`               | Airflow executor, it should be one of `SequentialExecutor`, `Local Executor`, `CeleryExecutor`, `KubernetesExecutor` | `"CeleryExecutor"` |
| `loadExamples`           | Switch to load some Airflow examples                                                                                 | `false`            |

## Airflow web parameters

| Parameter                                | Description                                                                                          | Default                                                 |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `web.args`                               | Override default container args (useful when using custom images)                                    | `nil`                                                   |
| `web.baseUrl`                            | URL used to access to airflow web ui                                                                 | `nil`                                                   |
| `web.command`                            | Override default container command (useful when using custom images)                                 | `nil`                                                   |
| `web.configMap`                          | Config map name for ~/airflow/webserver_config.py                                                    | `nil`                                                   |
| `web.containerPort`                      | Container port to be used for exposing http server.                                                  | `8080`                                                  |
| `web.customLivenessProbe`                | Custom liveness probe for the web component                                                          | `{}`                                                    |
| `web.customReadinessProbe`               | Custom rediness probe for the web component                                                          | `{}`                                                    |
| `web.extraEnvVars`                       | Array containing extra env vars                                                                      | `nil`                                                   |
| `web.extraEnvVarsCM`                     | ConfigMap containing extra env vars                                                                  | `nil`                                                   |
| `web.extraEnvVarsSecret`                 | Secret containing extra env vars (in case of sensitive data)                                         | `nil`                                                   |
| `web.hostAliases`                        | Add deployment host aliases                                                                          | `[]`                                                    |
| `web.extraVolumeMounts`                  | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`. | `nil`                                                   |
| `web.extraVolumes`                       | Array of extra volumes to be added (evaluated as template).                                          | `nil`                                                   |
| `web.image.debug`                        | Specify if debug values should be set                                                                | `false`                                                 |
| `web.image.pullPolicy`                   | Airflow web image pull policy                                                                        | `IfNotPresent`                                          |
| `web.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `web.image.registry`                     | Airflow web image registry                                                                           | `docker.io`                                             |
| `web.image.repository`                   | Airflow web image name                                                                               | `bitnami/airflow`                                       |
| `web.image.tag`                          | Airflow web image tag                                                                                | `{TAG_NAME}`                                            |
| `web.initContainers`                     | List of init containers to be added to the web's pods                                                | `nil`                                                   |
| `web.livenessProbe.enabled`              | Switch to enable livess probe                                                                        | `true`                                                  |
| `web.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.           | 6                                                       |
| `web.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                             | 180                                                     |
| `web.livenessProbe.periodSeconds`        | How often to perform the probe                                                                       | 20                                                      |
| `web.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed          | 1                                                       |
| `web.livenessProbe.timeoutSeconds`       | When the probe times out                                                                             | 5                                                       |
| `web.nodeSelector`                       | Node labels for pod assignment                                                                       | `{}` (evaluated as a template)                          |
| `web.podAnnotations`                     | Annotations to add to the web's pods                                                                 | `nil`                                                   |
| `web.podDisruptionBudget.enabled`        | Switch to enable Pod Disruption Budget for Airflow web component                                     | `false`                                                 |
| `web.podDisruptionBudget.minAvailable`   | Set the minimum amount of pods available                                                             | `1`                                                     |
| `web.podLabels`                          | Labels to add to the web's pods                                                                      | `nil`                                                   |
| `web.priorityClassName`                  | Priority class name for the web's pods                                                               | `""`                                                    |
| `web.readinessProbe.enabled`             | would you like a readinessProbe to be enabled                                                        | `true`                                                  |
| `web.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.           | 6                                                       |
| `web.readinessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                                                             | 30                                                      |
| `web.readinessProbe.periodSeconds`       | How often to perform the probe                                                                       | 10                                                      |
| `web.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed          | 1                                                       |
| `web.readinessProbe.timeoutSeconds`      | When the probe times out                                                                             | 5                                                       |
| `web.replicaCount`                       | Number of Airflow web replicas                                                                       | `2`                                                     |
| `web.resources.limits`                   | The resources limits for the web containers                                                          | `{}`                                                    |
| `web.resources.requests`                 | The requested resources for the web containers                                                       | `{}`                                                    |
| `web.sidecars`                           | List of sidecar containers to be added to the web's pods                                             | `nil`                                                   |
| `service.type`                           | Kubernetes Service type                                                                              | `ClusterIP`                                             |
| `service.port`                           | Airflow Web port                                                                                     | `8080`                                                  |
| `service.nodePort`                       | Kubernetes Service nodePort                                                                          | `nil`                                                   |
| `service.loadBalancerIP`                 | loadBalancerIP for Airflow Service                                                                   | `nil`                                                   |
| `service.annotations`                    | Service annotations                                                                                  | ``                                                      |

### Airflow scheduler parameters

| Parameter                                    | Description                                                                                          | Default                                                 |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `scheduler.args`                             | Override default container args (useful when using custom images)                                    | `nil`                                                   |
| `scheduler.command`                          | Override default container command (useful when using custom images)                                 | `nil`                                                   |
| `scheduler.customLivenessProbe`              | Custom liveness probe for the Airflow scheduler component                                            | `{}`                                                    |
| `scheduler.customReadinessProbe`             | Custom rediness probe for the Airflow scheduler component                                            | `{}`                                                    |
| `scheduler.extraEnvVars`                     | Array containing extra env vars                                                                      | `nil`                                                   |
| `scheduler.extraEnvVarsCM`                   | ConfigMap containing extra env vars                                                                  | `nil`                                                   |
| `scheduler.extraEnvVarsSecret`               | Secret containing extra env vars (in case of sensitive data)                                         | `nil`                                                   |
| `scheduler.extraVolumeMounts`                | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`. | `nil`                                                   |
| `scheduler.hostAliases`                      | Add deployment host aliases                                                                          | `[]`                                                    |
| `scheduler.extraVolumes`                     | Array of extra volumes to be added (evaluated as template).                                          | `nil`                                                   |
| `scheduler.image.debug`                      | Specify if debug values should be set                                                                | `false`                                                 |
| `scheduler.image.pullPolicy`                 | Airflow Scheduler image pull policy                                                                  | `IfNotPresent`                                          |
| `scheduler.image.pullSecrets`                | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `scheduler.image.registry`                   | Airflow Scheduler image registry                                                                     | `docker.io`                                             |
| `scheduler.image.repository`                 | Airflow Scheduler image name                                                                         | `bitnami/airflow-scheduler`                             |
| `scheduler.image.tag`                        | Airflow Scheduler image tag                                                                          | `{TAG_NAME}`                                            |
| `scheduler.initContainers`                   | List of init containers to be added to the scheduler's pods                                          | `nil`                                                   |
| `scheduler.nodeSelector`                     | Node labels for pod assignment                                                                       | `{}` (evaluated as a template)                          |
| `scheduler.podAnnotations`                   | Annotations to add to the scheduler's pods                                                           | `nil`                                                   |
| `scheduler.podDisruptionBudget.enabled`      | Switch to enable Pod Disruption Budget for Airflow scheduler component                               | `false`                                                 |
| `scheduler.podDisruptionBudget.minAvailable` | Set the minimum amount of pods available                                                             | `1`                                                     |
| `scheduler.podLabels`                        | Labels to add to the scheduler's pods                                                                | `nil`                                                   |
| `scheduler.priorityClassName`                | Priority class name for the scheduler's pods                                                         | `""`                                                    |
| `scheduler.replicaCount`                     | Number of Airflow scheduler replicas                                                                 | `2`                                                     |
| `scheduler.resources.limits`                 | The resources limits for the scheduler containers                                                    | `{}`                                                    |
| `scheduler.resources.requests`               | The requested resources for the scheduler containers                                                 | `{}`                                                    |
| `scheduler.sidecars`                         | List of sidecar containers to be added to the scheduler's pods                                       | `nil`                                                   |

### Airflow worker parameters

| Parameter                                   | Description                                                                                                                                                            | Default                                                 |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `worker.args`                               | Override default container args (useful when using custom images)                                                                                                      | `nil`                                                   |
| `worker.autoscaling.enabled`                | Switch to enable Horizontal Pod Autoscaler for Airflow worker component (only when executor is `CeleryExecutor`). When enable you should also set `resources.requests` | `false`                                                 |
| `worker.autoscaling.replicas.max`           | Maximum amount of replicas                                                                                                                                             | `3`                                                     |
| `worker.autoscaling.replicas.min`           | Minimum amount of replicas                                                                                                                                             | `1`                                                     |
| `worker.autoscaling.targets.cpu`            | Target cpu that will trigger an scaling action (unit: %)                                                                                                               | `80`                                                    |
| `worker.autoscaling.targets.memory`         | Target memory that will trigger an scaling action (unit: %)                                                                                                            | `80`                                                    |
| `worker.command`                            | Override default container command (useful when using custom images)                                                                                                   | `nil`                                                   |
| `worker.hostAliases`                        | Add deployment host aliases                                                                                                                                            | `[]`                                                    |
| `worker.customLivenessProbe`                | Custom liveness probe for the Airflow worker component                                                                                                                 | `{}`                                                    |
| `worker.customReadinessProbe`               | Custom rediness probe for the Airflow worker component                                                                                                                 | `{}`                                                    |
| `worker.extraEnvVars`                       | Array containing extra env vars                                                                                                                                        | `nil`                                                   |
| `worker.extraEnvVarsCM`                     | ConfigMap containing extra env vars                                                                                                                                    | `nil`                                                   |
| `worker.extraEnvVarsSecret`                 | Secret containing extra env vars (in case of sensitive data)                                                                                                           | `nil`                                                   |
| `worker.extraVolumeMounts`                  | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`.                                                                   | `nil`                                                   |
| `worker.extraVolumes`                       | Array of extra volumes to be added (evaluated as template).                                                                                                            | `nil`                                                   |
| `worker.image.debug`                        | Specify if debug values should be set                                                                                                                                  | `false`                                                 |
| `worker.image.pullPolicy`                   | Airflow worker image pull policy                                                                                                                                       | `IfNotPresent`                                          |
| `worker.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                                                                       | `[]` (does not add image pull secrets to deployed pods) |
| `worker.image.registry`                     | Airflow worker image registry                                                                                                                                          | `docker.io`                                             |
| `worker.image.repository`                   | Airflow worker image name                                                                                                                                              | `bitnami/airflow-worker`                                |
| `worker.image.tag`                          | Airflow worker image tag                                                                                                                                               | `{TAG_NAME}`                                            |
| `worker.initContainers`                     | List of init containers to be added to the worker's pods                                                                                                               | `nil`                                                   |
| `worker.livenessProbe.enabled`              | Switch to enable livess probe                                                                                                                                          | `true`                                                  |
| `worker.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                             | 6                                                       |
| `worker.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                                               | 180                                                     |
| `worker.livenessProbe.periodSeconds`        | How often to perform the probe                                                                                                                                         | 20                                                      |
| `worker.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                                                                            | 1                                                       |
| `worker.livenessProbe.timeoutSeconds`       | When the probe times out                                                                                                                                               | 5                                                       |
| `worker.nodeSelector`                       | Node labels for pod assignment                                                                                                                                         | `{}` (evaluated as a template)                          |
| `worker.podAnnotations`                     | Annotations to add to the worker's pods                                                                                                                                | `nil`                                                   |
| `worker.podDisruptionBudget.enabled`        | Switch to enable Pod Disruption Budget for Airflow worker component                                                                                                    | `false`                                                 |
| `worker.podDisruptionBudget.minAvailable`   | Set the minimum amount of pods available                                                                                                                               | `1`                                                     |
| `worker.podLabels`                          | Labels to add to the worker's pods                                                                                                                                     | `nil`                                                   |
| `worker.podManagementPolicy`                | Pod management policy to manage scaling operation of worker pods                                                                                                       | `nil`                                                   |
| `worker.port`                               | Port to bind Arflow workers                                                                                                                                            | `8793`                                                  |
| `worker.priorityClassName`                  | Priority class name for the worker's pods                                                                                                                              | `""`                                                    |
| `worker.readinessProbe.enabled`             | would you like a readinessProbe to be enabled                                                                                                                          | `true`                                                  |
| `worker.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                             | 6                                                       |
| `worker.readinessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                                                                                                                               | 30                                                      |
| `worker.readinessProbe.periodSeconds`       | How often to perform the probe                                                                                                                                         | 10                                                      |
| `worker.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed                                                                            | 1                                                       |
| `worker.readinessProbe.timeoutSeconds`      | When the probe times out                                                                                                                                               | 5                                                       |
| `worker.replicaCount`                       | Number of Airflow worker replicas                                                                                                                                      | `2`                                                     |
| `worker.resources.limits`                   | The resources limits for the worker containers                                                                                                                         | `{}`                                                    |
| `worker.resources.requests`                 | The requested resources for the worker containers                                                                                                                      | `{}`                                                    |
| `worker.rollingUpdatePartition`             | Partition update strategy                                                                                                                                              | `nil`                                                   |
| `worker.sidecars`                           | List of sidecar containers to be added to the worker's pods                                                                                                            | `nil`                                                   |
| `worker.updateStrategy`                     | pdate strategy for the statefulset                                                                                                                                     | `"RollingUpdate"`                                       |

### Airflow database parameters

| Parameter                                    | Description                                                                                                                                                                                                                    | Default           |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------- |
| `externalDatabase.database`                  | External PostgreSQL database name                                                                                                                                                                                              | `nil`             |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the PostgreSQL password                                                                                                                                                         | `nil`             |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the PostgreSQL password                                                                                                                                                              | `nil`             |
| `externalDatabase.host`                      | External PostgreSQL host                                                                                                                                                                                                       | `nil`             |
| `externalDatabase.password`                  | External PostgreSQL password                                                                                                                                                                                                   | `nil`             |
| `externalDatabase.port`                      | External PostgreSQL port                                                                                                                                                                                                       | `nil`             |
| `externalDatabase.user`                      | External PostgreSQL user                                                                                                                                                                                                       | `nil`             |
| `externalRedis.existingSecret`               | Name of an existing secret containing the Redis<sup>TM</sup> password ('redis-password' key)                                                                                                                                   | `nil`             |
| `externalRedis.host`                         | External Redis<sup>TM</sup> host                                                                                                                                                                                               | `nil`             |
| `externalRedis.password`                     | External Redis<sup>TM</sup> password                                                                                                                                                                                           | `nil`             |
| `externalRedis.port`                         | External Redis<sup>TM</sup> port                                                                                                                                                                                               | `nil`             |
| `externalRedis.username`                     | External Redis<sup>TM</sup> username (not required on most Redis<sup>TM</sup> implementations)                                                                                                                                 | `nil`             |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                                                                                                                                                                          | `true`            |
| `postgresql.existingSecret`                  | Name of an existing secret containing the PostgreSQL password ('postgresql-password' key) . This secret is used in case of postgresql.enabled=true and we would like to specify password for newly created postgresql instance | `nil`             |
| `postgresql.postgresqlDatabase`              | Airflow Postgresql database                                                                                                                                                                                                    | `bitnami_airflow` |
| `postgresql.postgresqlPassword`              | Airflow Postgresql password                                                                                                                                                                                                    | `nil`             |
| `postgresql.postgresqlUsername`              | Airflow Postgresql username                                                                                                                                                                                                    | `bn_airflow`      |
| `redis.cluster.enabled`                      | Switch to enable a clustered redis                                                                                                                                                                                             | `false`           |
| `redis.enabled`                              | Switch to enable or disable the Redis<sup>TM</sup> helm chart                                                                                                                                                                  | `true`            |
| `redis.existingSecret`                       | Name of an existing secret containing the Redis<sup>TM</sup> password ('redis-password' key) . This secret is used in case of redis.enabled=true and we would like to specify password for newly created redis instance        | `nil`             |

### Airflow exposing parameters

| Parameter                        | Description                                                                          | Default                  |
| -------------------------------- | ------------------------------------------------------------------------------------ | ------------------------ |
| `ingress.annotations`            | Ingress annotations                                                                  | `[]`                     |
| `ingress.apiVersion`             | Force Ingress API version (automatically detected if not set)                        | ``                       |
| `ingress.pathType`               | Ingress path type                                                                    | `ImplementationSpecific` |
| `ingress.certManager`            | Add annotations for cert-manager                                                     | `false`                  |
| `ingress.enabled`                | Enable ingress controller resource                                                   | `false`                  |
| `ingress.hosts[0].name`          | Hostname to your Airflow installation                                                | `airflow.local`          |
| `ingress.hosts[0].path`          | Path within the url structure                                                        | `/`                      |
| `ingress.hosts[0].tls`           | Utilize TLS backend in ingress                                                       | `false`                  |
| `ingress.hosts[0].tlsHosts`      | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`) | `nil`                    |
| `ingress.hosts[0].tlsSecret`     | TLS Secret (certificates)                                                            | `airflow.local-tls`      |
| `ingress.secrets[0].name`        | TLS Secret Name                                                                      | `nil`                    |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                                               | `nil`                    |
| `ingress.secrets[0].key`         | TLS Secret Key                                                                       | `nil`                    |

### Airflow metrics parameters

| Parameter                   | Description                                      | Default                                                 |
| --------------------------- | ------------------------------------------------ | ------------------------------------------------------- |
| `metrics.enabled`           | Start a side-car prometheus exporter             | `false`                                                 |
| `metrics.image.pullPolicy`  | Image pull policy                                | `IfNotPresent`                                          |
| `metrics.image.pullSecrets` | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.image.registry`    | Airflow exporter image registry                  | `docker.io`                                             |
| `metrics.image.repository`  | Airflow exporter image name                      | `bitnami/airflow-exporter`                              |
| `metrics.image.tag`         | Airflow exporter image tag                       | `{TAG_NAME}`                                            |
| `metrics.nodeSelector`      | Node labels for pod assignment                   | `{}` (evaluated as a template)                          |
| `metrics.podAnnotations`    | Annotations to add to the metrics's pods         | `nil`                                                   |
| `metrics.hostAliases`       | Add deployment host aliases                      | `[]`                                                    |
| `metrics.podLabels`         | Labels to add to the worker's pods               | `{}`                                                    |
| `metrics.resources`         | The resources for the metrics containers         | `{}`                                                    |
| `metrics.tolerations`       | The tolerations for the metrics pod              | `[]`                                                    |

### Airflow ldap parameters

| Parameter                        | Description                                                  | Default |
| -------------------------------- | ------------------------------------------------------------ | ------- |
| `ldap.base`                      | LDAP search base DN                                          | `nil`   |
| `ldap.binddn`                    | LDAP bind DN                                                 | `nil`   |
| `ldap.bindpw`                    | LDAP bind password                                           | `nil`   |
| `ldap.enabled`                   | Enable LDAP support                                          | `false` |
| `ldap.tls.enabled`               | Enable LDAP over TLS (LDAPS)                                 | `False` |
| `ldap.tls.allowSelfSigned`       | Allow self signed certificates for LDAPS                     | `True`  |
| `ldap.tls.CAcertificateSecret`   | Name of the secret that contains the LDAPS CA cert file      | `uid`   |
| `ldap.tls.CAcertificateFilename` | LDAPS CA cert filename                                       | `uid`   |
| `ldap.uidField`                  | LDAP field used for uid                                      | `uid`   |
| `ldap.uri`                       | LDAP URL beginning in the form `ldap[s]://<hostname>:<port>` | `nil`   |

### Airflow git sync parameters

| Parameter                                | Description                                                                                                       | Default                 |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `git.clone.args`                         | Override default container args (useful when using custom images)                                                 | `nil`                   |
| `git.clone.command`                      | Override default container command (useful when using custom images)                                              | `nil`                   |
| `git.clone.extraEnvVars`                 | Array containing extra env vars                                                                                   | `nil`                   |
| `git.clone.extraEnvVarsCM`               | ConfigMap containing extra env vars                                                                               | `nil`                   |
| `git.clone.extraEnvVarsSecret`           | Secret containing extra env vars (in case of sensitive data)                                                      | `nil`                   |
| `git.clone.extraVolumeMounts`            | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`.              | `nil`                   |
| `git.dags.enabled`                       | Enable in order to download DAG files from git repository.                                                        | `false`                 |
| `git.dags.repositories[0].branch`        | Branch from repository to checkout                                                                                | `nil`                   |
| `git.dags.repositories[0].name`          | An unique identifier for repository, must be unique for each repository, by default: `[0].repository` in kebacase | `nil`                   |
| `git.dags.repositories[0].path`          | Path to a folder in the repository containing the dags.                                                           | `nil`                   |
| `git.dags.repositories[0].repository`    | Repository where download plugins from                                                                            | `nil`                   |
| `git.image.pullPolicy`                   | Git image pull policy                                                                                             | `"IfNotPresent"`        |
| `git.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                  | `[]`                    |
| `git.image.registry`                     | Git image registry                                                                                                | `"docker.io"`           |
| `git.image.repository`                   | Git image name                                                                                                    | `"bitnami/git"`         |
| `git.image.tag`                          | Git image tag                                                                                                     | `"2.29.0-debian-10-r0"` |
| `git.plugins.enabled`                    | Enable in order to download plugins from git repository.                                                          | `false`                 |
| `git.plugins.repositories[0].branch`     | Branch from repository to checkout                                                                                | `nil`                   |
| `git.plugins.repositories[0].name`       | An unique identifier for repository, must be unique for each repository, by default: `[0].repository` in kebacase | `nil`                   |
| `git.plugins.repositories[0].path`       | Path to a folder in the repository containing the plugins.                                                        | `nil`                   |
| `git.plugins.repositories[0].repository` | Repository where download plugins from                                                                            | `nil`                   |
| `git.sync.args`                          | Override default container args (useful when using custom images)                                                 | `nil`                   |
| `git.sync.command`                       | Override default container command (useful when using custom images)                                              | `nil`                   |
| `git.sync.extraEnvVars`                  | Array containing extra env vars                                                                                   | `nil`                   |
| `git.sync.extraEnvVarsCM`                | ConfigMap containing extra env vars                                                                               | `nil`                   |
| `git.sync.extraEnvVarsSecret`            | Secret containing extra env vars (in case of sensitive data)                                                      | `nil`                   |
| `git.sync.extraVolumeMounts`             | Array of extra volume mounts to be added (evaluated as template). Normally used with `extraVolumes`.              | `nil`                   |
| `git.sync.interval`                      | Interval (in seconds) to pull the git repository containing the plugins and/or DAG files                          | `60`                    |

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

### 7.0.0

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
  - Liveness and rediness probe have been separated by components `airflow.livenessProbe.*` and `airflow.redinessProbe` have been removed in favour of `web.livenessProbe`, `worker.livenessProbe`, `web.redinessProbe` and `worker.redinessProbe`.
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
$ export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")
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

### 6.5.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### 6.0.0

This release adds support for LDAP authentication.

### 1.0.0

This release updates the PostgreSQL chart dependency to use PostgreSQL 11.x. You need to migrate the existing PostgreSQL data to this version before upgrading to this release. For more information follow [this link](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#500).
