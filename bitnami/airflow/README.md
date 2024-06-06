<!--- app-name: Apache Airflow -->

# Bitnami package for Apache Airflow

Apache Airflow is a tool to express and execute workflows as directed acyclic graphs (DAGs). It includes utilities to schedule tasks, monitor task progress and handle task dependencies.

[Overview of Apache Airflow](https://airflow.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/airflow
```

Looking to use Apache Airflow in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps an [Apache Airflow](https://github.com/bitnami/containers/tree/main/bitnami/airflow) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Generate a Fernet key

A Fernet key is required in order to encrypt password within connections. The Fernet key must be a base64-encoded 32-byte key.

Learn how to generate one [here](https://airflow.apache.org/docs/apache-airflow/stable/security/secrets/fernet.html#generating-fernet-key)

### Generate a Secret key

Secret key used to run your flask app. It should be as random as possible. However, when running more than 1 instances of webserver, make sure all of them use the same secret_key otherwise one of them will error with "CSRF session token is missing".

### Load DAG files

There are two different ways to load your custom DAG files into the Airflow chart. All of them are compatible so you can use more than one at the same time.

#### Option 1: Specify an existing config map

You can manually create a config map containing all your DAG files and then pass the name when deploying Airflow chart. For that, you can pass the option `dags.existingConfigmap`.

#### Option 2: Get your DAG files from a git repository

You can store all your DAG files on GitHub repositories and then clone to the Airflow pods with an initContainer. The repositories will be periodically updated using a sidecar container. In order to do that, you can deploy airflow with the following options:

> NOTE: When enabling git synchronization, an init container and sidecar container will be added for all the pods running airflow, this will allow scheduler, worker and web component to reach dags if it was needed.

```console
git.dags.enabled=true
git.dags.repositories[0].repository=https://github.com/USERNAME/REPOSITORY
git.dags.repositories[0].name=REPO-IDENTIFIER
git.dags.repositories[0].branch=master
```

If you use a private repository from GitHub, a possible option to clone the files is using a [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) and using it as part of the URL: `https://USERNAME:PERSONAL_ACCESS_TOKEN@github.com/USERNAME/REPOSITORY`

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

You can use an existing secret to configure your Airflow auth, external Postgres, and external Redis&reg; passwords:

```console
postgresql.enabled=false
externalDatabase.host=my.external.postgres.host
externalDatabase.user=bn_airflow
externalDatabase.database=bitnami_airflow
externalDatabase.existingSecret=all-my-secrets
externalDatabase.existingSecretPasswordKey=postgresql-password

redis.enabled=false
externalRedis.host=my.external.redis.host
externalRedis.existingSecret=all-my-secrets
externalRedis.existingSecretPasswordKey=redis-password

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
  airflow-fernet-key: "YVRZeVJVWnlXbU4wY1dOalVrdE1SV3cxWWtKeFIzWkVRVTVrVjNaTFR6WT0="
  airflow-secret-key: "a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08="
  postgresql-password: "cG9zdGdyZXMK"
  redis-password: "cmVkaXMK"
```

This is useful if you plan on using [Bitnami's sealed secrets](https://github.com/bitnami-labs/sealed-secrets) to manage your passwords.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Install extra python packages

This chart allows you to mount volumes using `extraVolumes` and `extraVolumeMounts` in all 3 airflow components (web, scheduler, worker). Mounting a requirements.txt using these options to `/bitnami/python/requirements.txt` will execute `pip install -r /bitnami/python/requirements.txt` on container start.

### Enabling network policies

This chart allows you to set network policies that will rectrict the access to the deployed pods in the cluster. Basically, no other pods apart from Scheduler's pods may access Worker's pods and no other pods apart from Web's pods may access Worker's ones. To do so, set `networkPolicies.enabled=true`.

### Executors

Airflow supports different executors runtimes and this chart provides support for the following ones.

#### CeleryExecutor

Celery executor is the default value for this chart with it you can scale out the number of workers. To point the `executor` parameter to `CeleryExecutor` you need to do something, you just install the chart with default parameters.

#### KubernetesExecutor

The kubernetes executor is introduced in Apache Airflow 1.10.0. The Kubernetes executor will create a new pod for every task instance using the `pod_template.yaml` that you can find [templates/config/configmap.yaml](https://github.com/bitnami/charts/blob/main/bitnami/airflow/templates/config/configmap.yaml), otherwise you can override this template using `worker.podTemplate`. To enable `KubernetesExecutor` set the following parameters.

> NOTE: Redis&reg; is not needed to be deployed when using KubernetesExecutor so you must disable it using `redis.enabled=false`.

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

### LocalKubernetesExecutor

The LocalKubernetesExecutor is introduced in Airflow 2.3 and is a combination of both the Local and the Kubernetes executors. Tasks will be executed in the scheduler by default, but those tasks that require it can be executed in a Kubernetes pod using the 'kubernetes' queue.

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

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                                  | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`            | Extra objects to deploy (evaluated as a template)                                            | `[]`            |
| `commonLabels`           | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations`      | Add annotations to all the deployed resources                                                | `{}`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)                   | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                      | `["infinity"]`  |

### Airflow common parameters

| Name                     | Description                                                                                                                                                               | Value                      |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `auth.username`          | Username to access web UI                                                                                                                                                 | `user`                     |
| `auth.password`          | Password to access web UI                                                                                                                                                 | `""`                       |
| `auth.fernetKey`         | Fernet key to secure connections                                                                                                                                          | `""`                       |
| `auth.secretKey`         | Secret key to run your flask app                                                                                                                                          | `""`                       |
| `auth.existingSecret`    | Name of an existing secret to use for Airflow credentials                                                                                                                 | `""`                       |
| `executor`               | Airflow executor. Allowed values: `SequentialExecutor`, `LocalExecutor`, `CeleryExecutor`, `KubernetesExecutor`, `CeleryKubernetesExecutor` and `LocalKubernetesExecutor` | `CeleryExecutor`           |
| `loadExamples`           | Switch to load some Airflow examples                                                                                                                                      | `false`                    |
| `configuration`          | Specify content for Airflow config file (auto-generated based on other env. vars otherwise)                                                                               | `""`                       |
| `existingConfigmap`      | Name of an existing ConfigMap with the Airflow config file                                                                                                                | `""`                       |
| `dags.existingConfigmap` | Name of an existing ConfigMap with all the DAGs files you want to load in Airflow                                                                                         | `""`                       |
| `dags.image.registry`    | Init container load-dags image registry                                                                                                                                   | `REGISTRY_NAME`            |
| `dags.image.repository`  | Init container load-dags image repository                                                                                                                                 | `REPOSITORY_NAME/os-shell` |
| `dags.image.digest`      | Init container load-dags image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                  | `""`                       |
| `dags.image.pullPolicy`  | Init container load-dags image pull policy                                                                                                                                | `IfNotPresent`             |
| `dags.image.pullSecrets` | Init container load-dags image pull secrets                                                                                                                               | `[]`                       |
| `extraEnvVars`           | Add extra environment variables for all the Airflow pods                                                                                                                  | `[]`                       |
| `extraEnvVarsCM`         | ConfigMap with extra environment variables for all the Airflow pods                                                                                                       | `""`                       |
| `extraEnvVarsSecret`     | Secret with extra environment variables for all the Airflow pods                                                                                                          | `""`                       |
| `extraEnvVarsSecrets`    | List of secrets with extra environment variables for all the Airflow pods                                                                                                 | `[]`                       |
| `sidecars`               | Add additional sidecar containers to all the Airflow pods                                                                                                                 | `[]`                       |
| `initContainers`         | Add additional init containers to all the Airflow pods                                                                                                                    | `[]`                       |
| `extraVolumeMounts`      | Optionally specify extra list of additional volumeMounts for all the Airflow pods                                                                                         | `[]`                       |
| `extraVolumes`           | Optionally specify extra list of additional volumes for the all the Airflow pods                                                                                          | `[]`                       |

### Airflow web parameters

| Name                                                    | Description                                                                                                                                                                                                               | Value                     |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `web.image.registry`                                    | Airflow image registry                                                                                                                                                                                                    | `REGISTRY_NAME`           |
| `web.image.repository`                                  | Airflow image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/airflow` |
| `web.image.digest`                                      | Airflow image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                      |
| `web.image.pullPolicy`                                  | Airflow image pull policy                                                                                                                                                                                                 | `IfNotPresent`            |
| `web.image.pullSecrets`                                 | Airflow image pull secrets                                                                                                                                                                                                | `[]`                      |
| `web.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                   | `false`                   |
| `web.baseUrl`                                           | URL used to access to Airflow web ui                                                                                                                                                                                      | `""`                      |
| `web.existingConfigmap`                                 | Name of an existing config map containing the Airflow web config file                                                                                                                                                     | `""`                      |
| `web.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                      | `[]`                      |
| `web.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                         | `[]`                      |
| `web.extraEnvVars`                                      | Array with extra environment variables to add Airflow web pods                                                                                                                                                            | `[]`                      |
| `web.extraEnvVarsCM`                                    | ConfigMap containing extra environment variables for Airflow web pods                                                                                                                                                     | `""`                      |
| `web.extraEnvVarsSecret`                                | Secret containing extra environment variables (in case of sensitive data) for Airflow web pods                                                                                                                            | `""`                      |
| `web.extraEnvVarsSecrets`                               | List of secrets with extra environment variables for Airflow web pods                                                                                                                                                     | `[]`                      |
| `web.containerPorts.http`                               | Airflow web HTTP container port                                                                                                                                                                                           | `8080`                    |
| `web.replicaCount`                                      | Number of Airflow web replicas                                                                                                                                                                                            | `1`                       |
| `web.livenessProbe.enabled`                             | Enable livenessProbe on Airflow web containers                                                                                                                                                                            | `true`                    |
| `web.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                   | `180`                     |
| `web.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                          | `20`                      |
| `web.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                         | `5`                       |
| `web.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                       | `6`                       |
| `web.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                       | `1`                       |
| `web.readinessProbe.enabled`                            | Enable readinessProbe on Airflow web containers                                                                                                                                                                           | `true`                    |
| `web.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                  | `30`                      |
| `web.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                         | `10`                      |
| `web.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                        | `5`                       |
| `web.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                      | `6`                       |
| `web.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                      | `1`                       |
| `web.startupProbe.enabled`                              | Enable startupProbe on Airflow web containers                                                                                                                                                                             | `false`                   |
| `web.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                    | `60`                      |
| `web.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                           | `10`                      |
| `web.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                          | `1`                       |
| `web.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                        | `15`                      |
| `web.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                        | `1`                       |
| `web.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                       | `{}`                      |
| `web.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                      | `{}`                      |
| `web.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                        | `{}`                      |
| `web.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if web.resources is set (web.resources is recommended for production). | `medium`                  |
| `web.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                         | `{}`                      |
| `web.podSecurityContext.enabled`                        | Enabled Airflow web pods' Security Context                                                                                                                                                                                | `true`                    |
| `web.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                        | `Always`                  |
| `web.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                            | `[]`                      |
| `web.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                               | `[]`                      |
| `web.podSecurityContext.fsGroup`                        | Set Airflow web pod's Security Context fsGroup                                                                                                                                                                            | `1001`                    |
| `web.containerSecurityContext.enabled`                  | Enabled Airflow web containers' Security Context                                                                                                                                                                          | `true`                    |
| `web.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                          | `{}`                      |
| `web.containerSecurityContext.runAsUser`                | Set Airflow web containers' Security Context runAsUser                                                                                                                                                                    | `1001`                    |
| `web.containerSecurityContext.runAsGroup`               | Set Airflow web containers' Security Context runAsGroup                                                                                                                                                                   | `1001`                    |
| `web.containerSecurityContext.runAsNonRoot`             | Set Airflow web containers' Security Context runAsNonRoot                                                                                                                                                                 | `true`                    |
| `web.containerSecurityContext.privileged`               | Set web container's Security Context privileged                                                                                                                                                                           | `false`                   |
| `web.containerSecurityContext.allowPrivilegeEscalation` | Set web container's Security Context allowPrivilegeEscalation                                                                                                                                                             | `false`                   |
| `web.containerSecurityContext.readOnlyRootFilesystem`   | Set web container's Security Context readOnlyRootFilesystem                                                                                                                                                               | `true`                    |
| `web.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                        | `["ALL"]`                 |
| `web.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                          | `RuntimeDefault`          |
| `web.lifecycleHooks`                                    | for the Airflow web container(s) to automate configuration before or after startup                                                                                                                                        | `{}`                      |
| `web.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                        | `false`                   |
| `web.hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                               | `[]`                      |
| `web.podLabels`                                         | Add extra labels to the Airflow web pods                                                                                                                                                                                  | `{}`                      |
| `web.podAnnotations`                                    | Add extra annotations to the Airflow web pods                                                                                                                                                                             | `{}`                      |
| `web.affinity`                                          | Affinity for Airflow web pods assignment (evaluated as a template)                                                                                                                                                        | `{}`                      |
| `web.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `web.affinity` is set.                                                                                                                                                                | `""`                      |
| `web.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `""`                      |
| `web.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `web.affinity` is set.                                                                                                                                                             | `[]`                      |
| `web.nodeSelector`                                      | Node labels for Airflow web pods assignment                                                                                                                                                                               | `{}`                      |
| `web.podAffinityPreset`                                 | Pod affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`.                                                                                                                                  | `""`                      |
| `web.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`.                                                                                                                             | `soft`                    |
| `web.tolerations`                                       | Tolerations for Airflow web pods assignment                                                                                                                                                                               | `[]`                      |
| `web.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                  | `[]`                      |
| `web.priorityClassName`                                 | Priority Class Name                                                                                                                                                                                                       | `""`                      |
| `web.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                 | `""`                      |
| `web.terminationGracePeriodSeconds`                     | Seconds Airflow web pod needs to terminate gracefully                                                                                                                                                                     | `""`                      |
| `web.updateStrategy.type`                               | Airflow web deployment strategy type                                                                                                                                                                                      | `RollingUpdate`           |
| `web.updateStrategy.rollingUpdate`                      | Airflow web deployment rolling update configuration parameters                                                                                                                                                            | `{}`                      |
| `web.sidecars`                                          | Add additional sidecar containers to the Airflow web pods                                                                                                                                                                 | `[]`                      |
| `web.initContainers`                                    | Add additional init containers to the Airflow web pods                                                                                                                                                                    | `[]`                      |
| `web.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Airflow web pods                                                                                                                                         | `[]`                      |
| `web.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Airflow web pods                                                                                                                                              | `[]`                      |
| `web.pdb.create`                                        | Deploy a pdb object for the Airflow web pods                                                                                                                                                                              | `true`                    |
| `web.pdb.minAvailable`                                  | Maximum number/percentage of unavailable Airflow web replicas                                                                                                                                                             | `""`                      |
| `web.pdb.maxUnavailable`                                | Maximum number/percentage of unavailable Airflow web replicas                                                                                                                                                             | `""`                      |
| `web.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                       | `true`                    |
| `web.networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                                | `true`                    |
| `web.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                           | `true`                    |
| `web.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                              | `[]`                      |
| `web.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                              | `[]`                      |
| `web.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                    | `{}`                      |
| `web.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                | `{}`                      |

### Airflow scheduler parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value                               |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `scheduler.image.registry`                                    | Airflow Scheduler image registry                                                                                                                                                                                                      | `REGISTRY_NAME`                     |
| `scheduler.image.repository`                                  | Airflow Scheduler image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/airflow-scheduler` |
| `scheduler.image.digest`                                      | Airflow Schefuler image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                                |
| `scheduler.image.pullPolicy`                                  | Airflow Scheduler image pull policy                                                                                                                                                                                                   | `IfNotPresent`                      |
| `scheduler.image.pullSecrets`                                 | Airflow Scheduler image pull secrets                                                                                                                                                                                                  | `[]`                                |
| `scheduler.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                               | `false`                             |
| `scheduler.replicaCount`                                      | Number of scheduler replicas                                                                                                                                                                                                          | `1`                                 |
| `scheduler.command`                                           | Override cmd                                                                                                                                                                                                                          | `[]`                                |
| `scheduler.args`                                              | Override args                                                                                                                                                                                                                         | `[]`                                |
| `scheduler.extraEnvVars`                                      | Add extra environment variables                                                                                                                                                                                                       | `[]`                                |
| `scheduler.extraEnvVarsCM`                                    | ConfigMap with extra environment variables                                                                                                                                                                                            | `""`                                |
| `scheduler.extraEnvVarsSecret`                                | Secret with extra environment variables                                                                                                                                                                                               | `""`                                |
| `scheduler.extraEnvVarsSecrets`                               | List of secrets with extra environment variables for Airflow scheduler pods                                                                                                                                                           | `[]`                                |
| `scheduler.livenessProbe.enabled`                             | Enable livenessProbe on Airflow scheduler containers                                                                                                                                                                                  | `true`                              |
| `scheduler.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `180`                               |
| `scheduler.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `20`                                |
| `scheduler.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `15`                                |
| `scheduler.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `6`                                 |
| `scheduler.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`                                 |
| `scheduler.readinessProbe.enabled`                            | Enable readinessProbe on Airflow scheduler containers                                                                                                                                                                                 | `true`                              |
| `scheduler.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `30`                                |
| `scheduler.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`                                |
| `scheduler.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `15`                                |
| `scheduler.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `6`                                 |
| `scheduler.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`                                 |
| `scheduler.startupProbe.enabled`                              | Enable startupProbe on Airflow scheduler containers                                                                                                                                                                                   | `false`                             |
| `scheduler.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `60`                                |
| `scheduler.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `10`                                |
| `scheduler.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `1`                                 |
| `scheduler.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `15`                                |
| `scheduler.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`                                 |
| `scheduler.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                   | `{}`                                |
| `scheduler.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                  | `{}`                                |
| `scheduler.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                    | `{}`                                |
| `scheduler.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if scheduler.resources is set (scheduler.resources is recommended for production). | `small`                             |
| `scheduler.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                                |
| `scheduler.podSecurityContext.enabled`                        | Enabled Airflow scheduler pods' Security Context                                                                                                                                                                                      | `true`                              |
| `scheduler.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`                            |
| `scheduler.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`                                |
| `scheduler.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`                                |
| `scheduler.podSecurityContext.fsGroup`                        | Set Airflow scheduler pod's Security Context fsGroup                                                                                                                                                                                  | `1001`                              |
| `scheduler.containerSecurityContext.enabled`                  | Enabled Airflow scheduler containers' Security Context                                                                                                                                                                                | `true`                              |
| `scheduler.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `{}`                                |
| `scheduler.containerSecurityContext.runAsUser`                | Set Airflow scheduler containers' Security Context runAsUser                                                                                                                                                                          | `1001`                              |
| `scheduler.containerSecurityContext.runAsGroup`               | Set Airflow scheduler containers' Security Context runAsGroup                                                                                                                                                                         | `1001`                              |
| `scheduler.containerSecurityContext.runAsNonRoot`             | Set Airflow scheduler containers' Security Context runAsNonRoot                                                                                                                                                                       | `true`                              |
| `scheduler.containerSecurityContext.privileged`               | Set scheduler container's Security Context privileged                                                                                                                                                                                 | `false`                             |
| `scheduler.containerSecurityContext.allowPrivilegeEscalation` | Set scheduler container's Security Context allowPrivilegeEscalation                                                                                                                                                                   | `false`                             |
| `scheduler.containerSecurityContext.readOnlyRootFilesystem`   | Set scheduler container's Security Context readOnlyRootFilesystem                                                                                                                                                                     | `true`                              |
| `scheduler.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`                           |
| `scheduler.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`                    |
| `scheduler.lifecycleHooks`                                    | for the Airflow scheduler container(s) to automate configuration before or after startup                                                                                                                                              | `{}`                                |
| `scheduler.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `false`                             |
| `scheduler.hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                                           | `[]`                                |
| `scheduler.podLabels`                                         | Add extra labels to the Airflow scheduler pods                                                                                                                                                                                        | `{}`                                |
| `scheduler.podAnnotations`                                    | Add extra annotations to the Airflow scheduler pods                                                                                                                                                                                   | `{}`                                |
| `scheduler.affinity`                                          | Affinity for Airflow scheduler pods assignment (evaluated as a template)                                                                                                                                                              | `{}`                                |
| `scheduler.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `scheduler.affinity` is set.                                                                                                                                                                      | `""`                                |
| `scheduler.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`                                |
| `scheduler.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `scheduler.affinity` is set.                                                                                                                                                                   | `[]`                                |
| `scheduler.nodeSelector`                                      | Node labels for Airflow scheduler pods assignment                                                                                                                                                                                     | `{}`                                |
| `scheduler.podAffinityPreset`                                 | Pod affinity preset. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard`.                                                                                                                                        | `""`                                |
| `scheduler.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard`.                                                                                                                                   | `soft`                              |
| `scheduler.tolerations`                                       | Tolerations for Airflow scheduler pods assignment                                                                                                                                                                                     | `[]`                                |
| `scheduler.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                              | `[]`                                |
| `scheduler.priorityClassName`                                 | Priority Class Name                                                                                                                                                                                                                   | `""`                                |
| `scheduler.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                             | `""`                                |
| `scheduler.terminationGracePeriodSeconds`                     | Seconds Airflow scheduler pod needs to terminate gracefully                                                                                                                                                                           | `""`                                |
| `scheduler.updateStrategy.type`                               | Airflow scheduler deployment strategy type                                                                                                                                                                                            | `RollingUpdate`                     |
| `scheduler.updateStrategy.rollingUpdate`                      | Airflow scheduler deployment rolling update configuration parameters                                                                                                                                                                  | `{}`                                |
| `scheduler.sidecars`                                          | Add additional sidecar containers to the Airflow scheduler pods                                                                                                                                                                       | `[]`                                |
| `scheduler.initContainers`                                    | Add additional init containers to the Airflow scheduler pods                                                                                                                                                                          | `[]`                                |
| `scheduler.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Airflow scheduler pods                                                                                                                                               | `[]`                                |
| `scheduler.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Airflow scheduler pods                                                                                                                                                    | `[]`                                |
| `scheduler.pdb.create`                                        | Deploy a pdb object for the Airflow scheduler pods                                                                                                                                                                                    | `true`                              |
| `scheduler.pdb.minAvailable`                                  | Maximum number/percentage of unavailable Airflow scheduler replicas                                                                                                                                                                   | `""`                                |
| `scheduler.pdb.maxUnavailable`                                | Maximum number/percentage of unavailable Airflow scheduler replicas                                                                                                                                                                   | `""`                                |
| `scheduler.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                   | `true`                              |
| `scheduler.networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                                            | `true`                              |
| `scheduler.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                       | `true`                              |
| `scheduler.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                                |
| `scheduler.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                                |
| `scheduler.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                | `{}`                                |
| `scheduler.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`                                |

### Airflow worker parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value                            |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `worker.image.registry`                                    | Airflow Worker image registry                                                                                                                                                                                                   | `REGISTRY_NAME`                  |
| `worker.image.repository`                                  | Airflow Worker image repository                                                                                                                                                                                                 | `REPOSITORY_NAME/airflow-worker` |
| `worker.image.digest`                                      | Airflow Worker image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                  | `""`                             |
| `worker.image.pullPolicy`                                  | Airflow Worker image pull policy                                                                                                                                                                                                | `IfNotPresent`                   |
| `worker.image.pullSecrets`                                 | Airflow Worker image pull secrets                                                                                                                                                                                               | `[]`                             |
| `worker.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                         | `false`                          |
| `worker.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`                             |
| `worker.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                               | `[]`                             |
| `worker.extraEnvVars`                                      | Array with extra environment variables to add Airflow worker pods                                                                                                                                                               | `[]`                             |
| `worker.extraEnvVarsCM`                                    | ConfigMap containing extra environment variables for Airflow worker pods                                                                                                                                                        | `""`                             |
| `worker.extraEnvVarsSecret`                                | Secret containing extra environment variables (in case of sensitive data) for Airflow worker pods                                                                                                                               | `""`                             |
| `worker.extraEnvVarsSecrets`                               | List of secrets with extra environment variables for Airflow worker pods                                                                                                                                                        | `[]`                             |
| `worker.containerPorts.http`                               | Airflow worker HTTP container port                                                                                                                                                                                              | `8793`                           |
| `worker.replicaCount`                                      | Number of Airflow worker replicas                                                                                                                                                                                               | `1`                              |
| `worker.livenessProbe.enabled`                             | Enable livenessProbe on Airflow worker containers                                                                                                                                                                               | `true`                           |
| `worker.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `180`                            |
| `worker.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `20`                             |
| `worker.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `5`                              |
| `worker.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `6`                              |
| `worker.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`                              |
| `worker.readinessProbe.enabled`                            | Enable readinessProbe on Airflow worker containers                                                                                                                                                                              | `true`                           |
| `worker.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `30`                             |
| `worker.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `10`                             |
| `worker.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `5`                              |
| `worker.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `6`                              |
| `worker.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`                              |
| `worker.startupProbe.enabled`                              | Enable startupProbe on Airflow worker containers                                                                                                                                                                                | `false`                          |
| `worker.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `60`                             |
| `worker.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `10`                             |
| `worker.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `1`                              |
| `worker.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `15`                             |
| `worker.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`                              |
| `worker.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                             | `{}`                             |
| `worker.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                            | `{}`                             |
| `worker.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                              | `{}`                             |
| `worker.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if worker.resources is set (worker.resources is recommended for production). | `large`                          |
| `worker.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                             |
| `worker.podSecurityContext.enabled`                        | Enabled Airflow worker pods' Security Context                                                                                                                                                                                   | `true`                           |
| `worker.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`                         |
| `worker.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`                             |
| `worker.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`                             |
| `worker.podSecurityContext.fsGroup`                        | Set Airflow worker pod's Security Context fsGroup                                                                                                                                                                               | `1001`                           |
| `worker.containerSecurityContext.enabled`                  | Enabled Airflow worker containers' Security Context                                                                                                                                                                             | `true`                           |
| `worker.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`                             |
| `worker.containerSecurityContext.runAsUser`                | Set Airflow worker containers' Security Context runAsUser                                                                                                                                                                       | `1001`                           |
| `worker.containerSecurityContext.runAsGroup`               | Set Airflow worker containers' Security Context runAsGroup                                                                                                                                                                      | `1001`                           |
| `worker.containerSecurityContext.runAsNonRoot`             | Set Airflow worker containers' Security Context runAsNonRoot                                                                                                                                                                    | `true`                           |
| `worker.containerSecurityContext.privileged`               | Set worker container's Security Context privileged                                                                                                                                                                              | `false`                          |
| `worker.containerSecurityContext.allowPrivilegeEscalation` | Set worker container's Security Context allowPrivilegeEscalation                                                                                                                                                                | `false`                          |
| `worker.containerSecurityContext.readOnlyRootFilesystem`   | Set worker container's Security Context readOnlyRootFilesystem                                                                                                                                                                  | `true`                           |
| `worker.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`                        |
| `worker.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault`                 |
| `worker.lifecycleHooks`                                    | for the Airflow worker container(s) to automate configuration before or after startup                                                                                                                                           | `{}`                             |
| `worker.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `false`                          |
| `worker.hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                                     | `[]`                             |
| `worker.podLabels`                                         | Add extra labels to the Airflow worker pods                                                                                                                                                                                     | `{}`                             |
| `worker.podAnnotations`                                    | Add extra annotations to the Airflow worker pods                                                                                                                                                                                | `{}`                             |
| `worker.affinity`                                          | Affinity for Airflow worker pods assignment (evaluated as a template)                                                                                                                                                           | `{}`                             |
| `worker.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `worker.affinity` is set.                                                                                                                                                                   | `""`                             |
| `worker.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `""`                             |
| `worker.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `worker.affinity` is set.                                                                                                                                                                | `[]`                             |
| `worker.nodeSelector`                                      | Node labels for Airflow worker pods assignment                                                                                                                                                                                  | `{}`                             |
| `worker.podAffinityPreset`                                 | Pod affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`.                                                                                                                                     | `""`                             |
| `worker.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`.                                                                                                                                | `soft`                           |
| `worker.tolerations`                                       | Tolerations for Airflow worker pods assignment                                                                                                                                                                                  | `[]`                             |
| `worker.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`                             |
| `worker.priorityClassName`                                 | Priority Class Name                                                                                                                                                                                                             | `""`                             |
| `worker.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                       | `""`                             |
| `worker.terminationGracePeriodSeconds`                     | Seconds Airflow worker pod needs to terminate gracefully                                                                                                                                                                        | `""`                             |
| `worker.updateStrategy.type`                               | Airflow worker deployment strategy type                                                                                                                                                                                         | `RollingUpdate`                  |
| `worker.updateStrategy.rollingUpdate`                      | Airflow worker deployment rolling update configuration parameters                                                                                                                                                               | `{}`                             |
| `worker.sidecars`                                          | Add additional sidecar containers to the Airflow worker pods                                                                                                                                                                    | `[]`                             |
| `worker.initContainers`                                    | Add additional init containers to the Airflow worker pods                                                                                                                                                                       | `[]`                             |
| `worker.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Airflow worker pods                                                                                                                                            | `[]`                             |
| `worker.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Airflow worker pods                                                                                                                                                 | `[]`                             |
| `worker.extraVolumeClaimTemplates`                         | Optionally specify extra list of volumesClaimTemplates for the Airflow worker statefulset                                                                                                                                       | `[]`                             |
| `worker.podTemplate`                                       | Template to replace the default one to be use when `executor=KubernetesExecutor` to create Airflow worker pods                                                                                                                  | `{}`                             |
| `worker.pdb.create`                                        | Deploy a pdb object for the Airflow worker pods                                                                                                                                                                                 | `true`                           |
| `worker.pdb.minAvailable`                                  | Maximum number/percentage of unavailable Airflow worker replicas                                                                                                                                                                | `""`                             |
| `worker.pdb.maxUnavailable`                                | Maximum number/percentage of unavailable Airflow worker replicas                                                                                                                                                                | `""`                             |
| `worker.autoscaling.enabled`                               | Whether enable horizontal pod autoscaler                                                                                                                                                                                        | `false`                          |
| `worker.autoscaling.minReplicas`                           | Configure a minimum amount of pods                                                                                                                                                                                              | `1`                              |
| `worker.autoscaling.maxReplicas`                           | Configure a maximum amount of pods                                                                                                                                                                                              | `3`                              |
| `worker.autoscaling.targetCPU`                             | Define the CPU target to trigger the scaling actions (utilization percentage)                                                                                                                                                   | `80`                             |
| `worker.autoscaling.targetMemory`                          | Define the memory target to trigger the scaling actions (utilization percentage)                                                                                                                                                | `80`                             |
| `worker.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                             | `true`                           |
| `worker.networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                                      | `true`                           |
| `worker.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                 | `true`                           |
| `worker.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                             |
| `worker.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                             |
| `worker.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`                             |
| `worker.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                      | `{}`                             |

### Airflow git sync parameters

| Name                           | Description                                                                                                                                                                                                                           | Value                 |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `git.image.registry`           | Git image registry                                                                                                                                                                                                                    | `REGISTRY_NAME`       |
| `git.image.repository`         | Git image repository                                                                                                                                                                                                                  | `REPOSITORY_NAME/git` |
| `git.image.digest`             | Git image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                   | `""`                  |
| `git.image.pullPolicy`         | Git image pull policy                                                                                                                                                                                                                 | `IfNotPresent`        |
| `git.image.pullSecrets`        | Git image pull secrets                                                                                                                                                                                                                | `[]`                  |
| `git.dags.enabled`             | Enable in order to download DAG files from git repositories.                                                                                                                                                                          | `false`               |
| `git.dags.repositories`        | Array of repositories from which to download DAG files                                                                                                                                                                                | `[]`                  |
| `git.plugins.enabled`          | Enable in order to download Plugins files from git repositories.                                                                                                                                                                      | `false`               |
| `git.plugins.repositories`     | Array of repositories from which to download DAG files                                                                                                                                                                                | `[]`                  |
| `git.clone.command`            | Override cmd                                                                                                                                                                                                                          | `[]`                  |
| `git.clone.args`               | Override args                                                                                                                                                                                                                         | `[]`                  |
| `git.clone.extraVolumeMounts`  | Add extra volume mounts                                                                                                                                                                                                               | `[]`                  |
| `git.clone.extraEnvVars`       | Add extra environment variables                                                                                                                                                                                                       | `[]`                  |
| `git.clone.extraEnvVarsCM`     | ConfigMap with extra environment variables                                                                                                                                                                                            | `""`                  |
| `git.clone.extraEnvVarsSecret` | Secret with extra environment variables                                                                                                                                                                                               | `""`                  |
| `git.clone.resources`          | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                  |
| `git.clone.resourcesPreset`    | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if git.clone.resources is set (git.clone.resources is recommended for production). | `nano`                |
| `git.sync.interval`            | Interval in seconds to pull the git repository containing the plugins and/or DAG files                                                                                                                                                | `60`                  |
| `git.sync.command`             | Override cmd                                                                                                                                                                                                                          | `[]`                  |
| `git.sync.args`                | Override args                                                                                                                                                                                                                         | `[]`                  |
| `git.sync.extraVolumeMounts`   | Add extra volume mounts                                                                                                                                                                                                               | `[]`                  |
| `git.sync.extraEnvVars`        | Add extra environment variables                                                                                                                                                                                                       | `[]`                  |
| `git.sync.extraEnvVarsCM`      | ConfigMap with extra environment variables                                                                                                                                                                                            | `""`                  |
| `git.sync.extraEnvVarsSecret`  | Secret with extra environment variables                                                                                                                                                                                               | `""`                  |
| `git.sync.resourcesPreset`     | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if git.sync.resources is set (git.sync.resources is recommended for production).   | `nano`                |
| `git.sync.resources`           | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                  |

### Airflow ldap parameters

| Name                             | Description                                                                                                                        | Value                                                                                                     |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `ldap.enabled`                   | Enable LDAP authentication                                                                                                         | `false`                                                                                                   |
| `ldap.uri`                       | Server URI, eg. ldap://ldap_server:389                                                                                             | `ldap://ldap_server:389`                                                                                  |
| `ldap.basedn`                    | Base of the search, eg. ou=example,o=org.                                                                                          | `dc=example,dc=org`                                                                                       |
| `ldap.searchAttribute`           | if doing an indirect bind to ldap, this is the field that matches the username when searching for the account to bind to           | `cn`                                                                                                      |
| `ldap.binddn`                    | DN of the account used to search in the LDAP server.                                                                               | `cn=admin,dc=example,dc=org`                                                                              |
| `ldap.bindpw`                    | Bind Password                                                                                                                      | `""`                                                                                                      |
| `ldap.userRegistration`          | Set to True to enable user self registration                                                                                       | `True`                                                                                                    |
| `ldap.userRegistrationRole`      | Set role name to be assign when a user registers himself. This role must already exist. Mandatory when using ldap.userRegistration | `Public`                                                                                                  |
| `ldap.rolesMapping`              | mapping from LDAP DN to a list of roles                                                                                            | `{ "cn=All,ou=Groups,dc=example,dc=org": ["User"], "cn=Admins,ou=Groups,dc=example,dc=org": ["Admin"], }` |
| `ldap.rolesSyncAtLogin`          | replace ALL the user's roles each login, or only on registration                                                                   | `True`                                                                                                    |
| `ldap.tls.enabled`               | Enabled TLS/SSL for LDAP, you must include the CA file.                                                                            | `false`                                                                                                   |
| `ldap.tls.allowSelfSigned`       | Allow to use self signed certificates                                                                                              | `true`                                                                                                    |
| `ldap.tls.certificatesSecret`    | Name of the existing secret containing the certificate CA file that will be used by ldap client                                    | `""`                                                                                                      |
| `ldap.tls.certificatesMountPath` | Where LDAP certifcates are mounted.                                                                                                | `/opt/bitnami/airflow/conf/certs`                                                                         |
| `ldap.tls.CAFilename`            | LDAP CA cert filename                                                                                                              | `""`                                                                                                      |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Airflow service type                                                                                                             | `ClusterIP`              |
| `service.ports.http`               | Airflow service HTTP port                                                                                                        | `8080`                   |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Airflow service Cluster IP                                                                                                       | `""`                     |
| `service.loadBalancerIP`           | Airflow service Load Balancer IP                                                                                                 | `""`                     |
| `service.loadBalancerSourceRanges` | Airflow service Load Balancer sources                                                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | Airflow service external traffic policy                                                                                          | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Airflow service                                                                                | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Airflow service                                                                                          | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Airflow                                                                                     | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `airflow.local`          |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Airflow pods                     | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |
| `rbac.create`                                 | Create Role and RoleBinding                                            | `false` |
| `rbac.rules`                                  | Custom RBAC rules to set                                               | `[]`    |

### Airflow metrics parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                              |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `metrics.enabled`                                           | Whether or not to create a standalone Airflow exporter to expose Airflow metrics                                                                                                                                                  | `false`                            |
| `metrics.image.registry`                                    | Airflow exporter image registry                                                                                                                                                                                                   | `REGISTRY_NAME`                    |
| `metrics.image.repository`                                  | Airflow exporter image repository                                                                                                                                                                                                 | `REPOSITORY_NAME/airflow-exporter` |
| `metrics.image.digest`                                      | Airflow exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                  | `""`                               |
| `metrics.image.pullPolicy`                                  | Airflow exporter image pull policy                                                                                                                                                                                                | `IfNotPresent`                     |
| `metrics.image.pullSecrets`                                 | Airflow exporter image pull secrets                                                                                                                                                                                               | `[]`                               |
| `metrics.extraEnvVars`                                      | Array with extra environment variables to add Airflow exporter pods                                                                                                                                                               | `[]`                               |
| `metrics.extraEnvVarsCM`                                    | ConfigMap containing extra environment variables for Airflow exporter pods                                                                                                                                                        | `""`                               |
| `metrics.extraEnvVarsSecret`                                | Secret containing extra environment variables (in case of sensitive data) for Airflow exporter pods                                                                                                                               | `""`                               |
| `metrics.containerPorts.http`                               | Airflow exporter metrics container port                                                                                                                                                                                           | `9112`                             |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                             |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                               |
| `metrics.podSecurityContext.enabled`                        | Enable security context for the pods                                                                                                                                                                                              | `true`                             |
| `metrics.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`                           |
| `metrics.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`                               |
| `metrics.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`                               |
| `metrics.podSecurityContext.fsGroup`                        | Set Airflow exporter pod's Security Context fsGroup                                                                                                                                                                               | `1001`                             |
| `metrics.containerSecurityContext.enabled`                  | Enable Airflow exporter containers' Security Context                                                                                                                                                                              | `true`                             |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                               |
| `metrics.containerSecurityContext.runAsUser`                | Set Airflow exporter containers' Security Context runAsUser                                                                                                                                                                       | `1001`                             |
| `metrics.containerSecurityContext.runAsGroup`               | Set Airflow exporter containers' Security Context runAsGroup                                                                                                                                                                      | `1001`                             |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set Airflow exporter containers' Security Context runAsNonRoot                                                                                                                                                                    | `true`                             |
| `metrics.containerSecurityContext.privileged`               | Set metrics container's Security Context privileged                                                                                                                                                                               | `false`                            |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set metrics container's Security Context allowPrivilegeEscalation                                                                                                                                                                 | `false`                            |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set metrics container's Security Context readOnlyRootFilesystem                                                                                                                                                                   | `true`                             |
| `metrics.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                          |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`                   |
| `metrics.lifecycleHooks`                                    | for the Airflow exporter container(s) to automate configuration before or after startup                                                                                                                                           | `{}`                               |
| `metrics.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`                            |
| `metrics.hostAliases`                                       | Airflow exporter pods host aliases                                                                                                                                                                                                | `[]`                               |
| `metrics.podLabels`                                         | Extra labels for Airflow exporter pods                                                                                                                                                                                            | `{}`                               |
| `metrics.podAnnotations`                                    | Extra annotations for Airflow exporter pods                                                                                                                                                                                       | `{}`                               |
| `metrics.podAffinityPreset`                                 | Pod affinity preset. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`                               |
| `metrics.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `soft`                             |
| `metrics.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`                               |
| `metrics.nodeAffinityPreset.key`                            | Node label key to match Ignored if `metrics.affinity` is set.                                                                                                                                                                     | `""`                               |
| `metrics.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `metrics.affinity` is set.                                                                                                                                                                 | `[]`                               |
| `metrics.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                       | `{}`                               |
| `metrics.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                    | `{}`                               |
| `metrics.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                    | `[]`                               |
| `metrics.schedulerName`                                     | Name of the k8s scheduler (other than default) for Airflow exporter                                                                                                                                                               | `""`                               |
| `metrics.service.ports.http`                                | Airflow exporter metrics service port                                                                                                                                                                                             | `9112`                             |
| `metrics.service.clusterIP`                                 | Static clusterIP or None for headless services                                                                                                                                                                                    | `""`                               |
| `metrics.service.sessionAffinity`                           | Control where client requests go, to the same pod or round-robin                                                                                                                                                                  | `None`                             |
| `metrics.service.annotations`                               | Annotations for the Airflow exporter service                                                                                                                                                                                      | `{}`                               |
| `metrics.serviceMonitor.enabled`                            | if `true`, creates a Prometheus Operator ServiceMonitor (requires `metrics.enabled` to be `true`)                                                                                                                                 | `false`                            |
| `metrics.serviceMonitor.namespace`                          | Namespace in which Prometheus is running                                                                                                                                                                                          | `""`                               |
| `metrics.serviceMonitor.interval`                           | Interval at which metrics should be scraped                                                                                                                                                                                       | `""`                               |
| `metrics.serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                                                                                           | `""`                               |
| `metrics.serviceMonitor.labels`                             | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                                                                                                                             | `{}`                               |
| `metrics.serviceMonitor.selector`                           | Prometheus instance selector labels                                                                                                                                                                                               | `{}`                               |
| `metrics.serviceMonitor.relabelings`                        | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                               |
| `metrics.serviceMonitor.metricRelabelings`                  | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                         | `[]`                               |
| `metrics.serviceMonitor.honorLabels`                        | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                            |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                 | `""`                               |
| `metrics.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                               | `true`                             |
| `metrics.networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                                        | `true`                             |
| `metrics.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                   | `true`                             |
| `metrics.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`                               |
| `metrics.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`                               |
| `metrics.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`                               |
| `metrics.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                        | `{}`                               |

### Airflow database parameters

| Name                                         | Description                                                                                                                                                                                                                | Value             |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                                                                                                                                                                      | `true`            |
| `postgresql.auth.enablePostgresUser`         | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user                                                                                                                     | `true`            |
| `postgresql.auth.username`                   | Name for a custom user to create                                                                                                                                                                                           | `bn_airflow`      |
| `postgresql.auth.password`                   | Password for the custom user to create                                                                                                                                                                                     | `""`              |
| `postgresql.auth.database`                   | Name for a custom database to create                                                                                                                                                                                       | `bitnami_airflow` |
| `postgresql.auth.existingSecret`             | Name of existing secret to use for PostgreSQL credentials                                                                                                                                                                  | `""`              |
| `postgresql.architecture`                    | PostgreSQL architecture (`standalone` or `replication`)                                                                                                                                                                    | `standalone`      |
| `postgresql.primary.resourcesPreset`         | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `nano`            |
| `postgresql.primary.resources`               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`              |
| `externalDatabase.host`                      | Database host                                                                                                                                                                                                              | `localhost`       |
| `externalDatabase.port`                      | Database port number                                                                                                                                                                                                       | `5432`            |
| `externalDatabase.user`                      | Non-root username for Airflow                                                                                                                                                                                              | `bn_airflow`      |
| `externalDatabase.password`                  | Password for the non-root username for Airflow                                                                                                                                                                             | `""`              |
| `externalDatabase.database`                  | Airflow database name                                                                                                                                                                                                      | `bitnami_airflow` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials                                                                                                                                                    | `""`              |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials                                                                                                                                                         | `""`              |
| `redis.enabled`                              | Switch to enable or disable the Redis&reg; helm                                                                                                                                                                            | `true`            |
| `redis.auth.enabled`                         | Enable password authentication                                                                                                                                                                                             | `true`            |
| `redis.auth.password`                        | Redis&reg; password                                                                                                                                                                                                        | `""`              |
| `redis.auth.existingSecret`                  | The name of an existing secret with Redis&reg; credentials                                                                                                                                                                 | `""`              |
| `redis.architecture`                         | Redis&reg; architecture. Allowed values: `standalone` or `replication`                                                                                                                                                     | `standalone`      |
| `redis.master.resourcesPreset`               | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production).   | `nano`            |
| `redis.master.resources`                     | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`              |
| `externalRedis.host`                         | Redis&reg; host                                                                                                                                                                                                            | `localhost`       |
| `externalRedis.port`                         | Redis&reg; port number                                                                                                                                                                                                     | `6379`            |
| `externalRedis.username`                     | Redis&reg; username                                                                                                                                                                                                        | `""`              |
| `externalRedis.password`                     | Redis&reg; password                                                                                                                                                                                                        | `""`              |
| `externalRedis.existingSecret`               | Name of an existing secret resource containing the Redis&trade credentials                                                                                                                                                 | `""`              |
| `externalRedis.existingSecretPasswordKey`    | Name of an existing secret key containing the Redis&trade credentials                                                                                                                                                      | `""`              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
               --set auth.username=my-user \
               --set auth.password=my-passsword \
               --set auth.fernetKey=my-fernet-key \
               --set auth.secretKey=my-secret-key \
               oci://REGISTRY_NAME/REPOSITORY_NAME/airflow
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the credentials to access the Airflow web UI.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/airflow
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/airflow/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 18.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 17.0.0

This major release bumps the PostgreSQL chart version to [14.x.x](https://github.com/bitnami/charts/pull/22750); no major issues are expected during the upgrade.

### To 16.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### To 15.0.0

This major updates the Redis&reg; subchart to its newest major, 18.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1800) you can find more information about the changes introduced in that version.

NOTE: Due to an error in our release process, Redis&reg;' chart versions higher or equal than 17.15.4 already use Redis&reg; 7.2 by default.

### To 14.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

### To 13.0.0

This major update the Redis&reg; subchart to its newest major, 17.0.0, which updates Redis&reg; from its version 6.2 to the latest 7.0.

### To 12.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository. Additionally updates the PostgreSQL & Redis subcharts to their newest major 11.x.x and 16.x.x, respectively, which contain similar changes.

- *auth.forcePassword* parameter is deprecated. The new version uses Helm's lookup functionalities and forcing passwords isn't required anymore.
- *config* and *configurationConfigMap* have been renamed to *configuration* and *existingConfigmap*, respectively.
- *dags.configMap* and *web.configMap* have been renamed to *dags.existingConfigmap* and *web.existingConfigmap*, respectively.
- *web.containerPort* and *worker.port* have been regrouped under the *web.containerPorts* and *worker.containerPorts* maps, respectively.
- *web.podDisruptionBudget*, *scheduler.podDisruptionBudget* and *worker.podDisruptionBudget* maps have been renamed to *web.pdb*, *scheduler.pdb* and *worker.pdb*, respectively.
- *worker.autoscaling.replicas.min*, *worker.autoscaling.replicas.max*, *worker.autoscaling.targets.cpu* and *worker.autoscaling.targets.memory* have been renamed to *worker.autoscaling.minReplicas*, *worker.autoscaling.maxReplicas*, *worker.autoscaling.targetCPU* and *.Values.worker.autoscaling.targetMemory*, respectively.
- *service.port* and *service.httpsPort* have been regrouped under the *service.ports* map.
- *ingress* map is completely redefined.
- *metrics.service.port* has been regrouped under the *metrics.service.ports* map.
- Support for Network Policies is dropped and it'll be properly added in the future.
- The secret keys *airflow-fernetKey* and *airflow-secretKey* were renamed to *airflow-fernet-key* and *airflow-secret-key*, respectively.

#### How to upgrade to version 12.0.0

To upgrade to *12.0.0* from *11.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *airflow* and the release namespace *default*):

> NOTE: Please, create a backup of your database before running any of those actions.

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
        export AIRFLOW_PASSWORD=$(kubectl get secret --namespace default airflow -o jsonpath="{.data.airflow-password}" | base64 --decode)
        export AIRFLOW_FERNET_KEY=$(kubectl get secret --namespace default airflow -o jsonpath="{.data.airflow-fernetKey}" | base64 --decode)
        export AIRFLOW_SECRET_KEY=$(kubectl get secret --namespace default airflow -o jsonpath="{.data.airflow-secretKey}" | base64 --decode)
        export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default airflow-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
        export REDIS_PASSWORD=$(kubectl get secret --namespace default airflow-redis -o jsonpath="{.data.redis-password}" | base64 --decode)
        export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=airflow,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the Airflow worker & PostgreSQL statefulset (notice the option *--cascade=false*) and secrets:

```console
        kubectl delete statefulsets.apps --cascade=false airflow-postgresql
        kubectl delete statefulsets.apps --cascade=false airflow-worker
        kubectl delete secret postgresql --namespace default
        kubectl delete secret airflow --namespace default
```

1. Upgrade your release using the same PostgreSQL version:

```console
        CURRENT_PG_VERSION=$(kubectl exec airflow-postgresql-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
        helm upgrade airflow bitnami/airflow \
          --set loadExamples=true \
          --set web.baseUrl=http://127.0.0.1:8080 \
          --set auth.password=$AIRFLOW_PASSWORD \
          --set auth.fernetKey=$AIRFLOW_FERNET_KEY \
          --set auth.secretKey=$AIRFLOW_SECRET_KEY \
          --set postgresql.image.tag=$CURRENT_VERSION \
          --set postgresql.auth.password=$POSTGRESQL_PASSWORD \
          --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
          --set redis.password=$REDIS_PASSWORD \
          --set redis.cluster.enabled=true
```

1. Delete the existing Airflow worker & PostgreSQL pods and the new statefulset will create a new one:

```console
        kubectl delete pod airflow-postgresql-0
        kubectl delete pod airflow-worker-0
```

### To 11.0.0

This major update the Redis&reg; subchart to its newest major, 15.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1500) you can find more info about the specific changes.

### To 10.0.0

This major updates the Redis&reg; subchart to it newest major, 14.0.0, which contains breaking changes. For more information on this subchart's major and the steps needed to migrate your data from your previous release, please refer to [Redis&reg; upgrade notes.](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1400).

### To 7.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL. The following changes were introduced in this version:

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running *helm dependency update*, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Chart.
- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - The image objects have been moved to its corresponding component object, e.g: *workerImage* now is located at *worker.image*.
  - The prefix *airflow* has been removed. Therefore, parameters prefixed with *airflow* are now at root level, e.g. *airflow.loadExamples* now is *loadExamples* or *airflow.worker.resources* now is *worker.resources*.
  - Parameters related to the *git* features has completely been refactored:
    - They have been regrouped under the *git* map.
    - *airflow.cloneDagsFromGit* no longer exists, instead you must use *git.dags* and *git.dags.repositories* has been introduced that will add support for multiple repositories.
    - *airflow.clonePluginsFromGit* no longer exists, instead you must use *git.plugins*. *airflow.clonePluginsFromGit.repository*, *airflow.clonePluginsFromGit.branch* and *airflow.clonePluginsFromGit.path* have been removed in favour of *git.dags.repositories*.
  - Liveness and readiness probe have been separated by components *airflow.livenessProbe.** and *airflow.readinessProbe* have been removed in favour of *web.livenessProbe*, *worker.livenessProbe*, *web.readinessProbe* and *worker.readinessProbe*.
  - *airflow.baseUrl* has been moved to *web.baseUrl*.
  - Security context has been migrated to the bitnami standard way so that *securityContext* has been divided into *podSecurityContext* that will define the **fsGroup** for all the containers in the pod and *containerSecurityContext* that will define the user id that will run the main containers.
  - *./files/dags/*.py* will not be include in the deployment any more.
- Additionally updates the PostgreSQL & Redis subcharts to their newest major 10.x.x and 11.x.x, respectively, which contain similar changes.

#### Considerations when upgrading to this version

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version does not support Helm v2 anymore.
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3.

#### Useful links

- [Bitnami Tutorial](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html)
- [Helm docs](https://helm.sh/docs/topics/v2_v3_migration)
- [Helm Blog](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3)

#### How to upgrade to version 7.0.0

To upgrade to *7.0.0* from *6.x*, it should be done reusing the PVC(s) used to hold the data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is *airflow* and the release namespace *default*):

> NOTE: Please, create a backup of your database before running any of those actions.

1. Obtain the credentials and the names of the PVCs used to hold the data on your current release:

```console
        export AIRFLOW_PASSWORD=$(kubectl get secret --namespace default airflow -o jsonpath="{.data.airflow-password}" | base64 --decode)
        export AIRFLOW_FERNET_KEY=$(kubectl get secret --namespace default airflow -o jsonpath="{.data.airflow-fernetKey}" | base64 --decode)
        export AIRFLOW_SECRET_KEY=$(kubectl get secret --namespace default airflow -o jsonpath="{.data.airflow-secretKey}" | base64 --decode)
        export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default airflow-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
        export REDIS_PASSWORD=$(kubectl get secret --namespace default airflow-redis -o jsonpath="{.data.redis-password}" | base64 --decode)
        export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=airflow,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
```

1. Delete the Airflow worker & PostgreSQL statefulset (notice the option *--cascade=false*):

```console
        kubectl delete statefulsets.apps --cascade=false airflow-postgresql
        kubectl delete statefulsets.apps --cascade=false airflow-worker
```

1. Upgrade your release:

> NOTE: Please remember to migrate all the values to its new path following the above notes, e.g: `airflow.loadExamples` -> `loadExamples` or `airflow.baseUrl=http://127.0.0.1:8080` -> `web.baseUrl=http://127.0.0.1:8080`.

```console
        helm upgrade airflow bitnami/airflow \
          --set loadExamples=true \
          --set web.baseUrl=http://127.0.0.1:8080 \
          --set auth.password=$AIRFLOW_PASSWORD \
          --set auth.fernetKey=$AIRFLOW_FERNET_KEY \
          --set auth.secretKey=$AIRFLOW_SECRET_KEY \
          --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
          --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
          --set redis.password=$REDIS_PASSWORD \
          --set redis.cluster.enabled=true
```

1. Delete the existing Airflow worker & PostgreSQL pods and the new statefulset will create a new one:

```console
        kubectl delete pod airflow-postgresql-0
        kubectl delete pod airflow-worker-0
```

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.