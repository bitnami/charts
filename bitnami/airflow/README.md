<!--- app-name: Apache Airflow -->

# Apache Airflow packaged by Bitnami

Apache Airflow is a tool to express and execute workflows as directed acyclic graphs (DAGs). It includes utilities to schedule tasks, monitor task progress and handle task dependencies.

[Overview of Apache Airflow](https://airflow.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm install my-release bitnami/airflow
```

## Introduction

This chart bootstraps an [Apache Airflow](https://github.com/bitnami/bitnami-docker-airflow) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

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

| Name                     | Description                                                                                                                                    | Value                   |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `auth.username`          | Username to access web UI                                                                                                                      | `user`                  |
| `auth.password`          | Password to access web UI                                                                                                                      | `""`                    |
| `auth.fernetKey`         | Fernet key to secure connections                                                                                                               | `""`                    |
| `auth.secretKey`         | Secret key to run your flask app                                                                                                               | `""`                    |
| `auth.existingSecret`    | Name of an existing secret to use for Airflow credentials                                                                                      | `""`                    |
| `executor`               | Airflow executor. Allowed values: `SequentialExecutor`, `LocalExecutor`, `CeleryExecutor`, `KubernetesExecutor` and `CeleryKubernetesExecutor` | `CeleryExecutor`        |
| `loadExamples`           | Switch to load some Airflow examples                                                                                                           | `false`                 |
| `configuration`          | Specify content for Airflow config file (auto-generated based on other env. vars otherwise)                                                    | `""`                    |
| `existingConfigmap`      | Name of an existing ConfigMap with the Airflow config file                                                                                     | `""`                    |
| `dags.existingConfigmap` | Name of an existing ConfigMap with all the DAGs files you want to load in Airflow                                                              | `""`                    |
| `dags.image.registry`    | Init container load-dags image registry                                                                                                        | `docker.io`             |
| `dags.image.repository`  | Init container load-dags image repository                                                                                                      | `bitnami/bitnami-shell` |
| `dags.image.tag`         | Init container load-dags image tag (immutable tags are recommended)                                                                            | `10-debian-10-r400`     |
| `dags.image.pullPolicy`  | Init container load-dags image pull policy                                                                                                     | `IfNotPresent`          |
| `dags.image.pullSecrets` | Init container load-dags image pull secrets                                                                                                    | `[]`                    |
| `extraEnvVars`           | Add extra environment variables for all the Airflow pods                                                                                       | `[]`                    |
| `extraEnvVarsCM`         | ConfigMap with extra environment variables for all the Airflow pods                                                                            | `""`                    |
| `extraEnvVarsSecret`     | Secret with extra environment variables for all the Airflow pods                                                                               | `""`                    |
| `extraEnvVarsSecrets`    | List of secrets with extra environment variables for all the Airflow pods                                                                      | `[]`                    |
| `sidecars`               | Add additional sidecar containers to all the Airflow pods                                                                                      | `[]`                    |
| `initContainers`         | Add additional init containers to all the Airflow pods                                                                                         | `[]`                    |
| `extraVolumeMounts`      | Optionally specify extra list of additional volumeMounts for all the Airflow pods                                                              | `[]`                    |
| `extraVolumes`           | Optionally specify extra list of additional volumes for the all the Airflow pods                                                               | `[]`                    |


### Airflow web parameters

| Name                                        | Description                                                                                                              | Value                 |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------------- |
| `web.image.registry`                        | Airflow image registry                                                                                                   | `docker.io`           |
| `web.image.repository`                      | Airflow image repository                                                                                                 | `bitnami/airflow`     |
| `web.image.tag`                             | Airflow image tag (immutable tags are recommended)                                                                       | `2.2.5-debian-10-r14` |
| `web.image.pullPolicy`                      | Airflow image pull policy                                                                                                | `IfNotPresent`        |
| `web.image.pullSecrets`                     | Airflow image pull secrets                                                                                               | `[]`                  |
| `web.image.debug`                           | Enable image debug mode                                                                                                  | `false`               |
| `web.baseUrl`                               | URL used to access to Airflow web ui                                                                                     | `""`                  |
| `web.existingConfigmap`                     | Name of an existing config map containing the Airflow web config file                                                    | `""`                  |
| `web.command`                               | Override default container command (useful when using custom images)                                                     | `[]`                  |
| `web.args`                                  | Override default container args (useful when using custom images)                                                        | `[]`                  |
| `web.extraEnvVars`                          | Array with extra environment variables to add Airflow web pods                                                           | `[]`                  |
| `web.extraEnvVarsCM`                        | ConfigMap containing extra environment variables for Airflow web pods                                                    | `""`                  |
| `web.extraEnvVarsSecret`                    | Secret containing extra environment variables (in case of sensitive data) for Airflow web pods                           | `""`                  |
| `web.extraEnvVarsSecrets`                   | List of secrets with extra environment variables for Airflow web pods                                                    | `[]`                  |
| `web.containerPorts.http`                   | Airflow web HTTP container port                                                                                          | `8080`                |
| `web.replicaCount`                          | Number of Airflow web replicas                                                                                           | `1`                   |
| `web.livenessProbe.enabled`                 | Enable livenessProbe on Airflow web containers                                                                           | `true`                |
| `web.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                  | `180`                 |
| `web.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                         | `20`                  |
| `web.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                        | `5`                   |
| `web.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                      | `6`                   |
| `web.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                      | `1`                   |
| `web.readinessProbe.enabled`                | Enable readinessProbe on Airflow web containers                                                                          | `true`                |
| `web.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                 | `30`                  |
| `web.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                        | `10`                  |
| `web.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                       | `5`                   |
| `web.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                     | `6`                   |
| `web.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                     | `1`                   |
| `web.startupProbe.enabled`                  | Enable startupProbe on Airflow web containers                                                                            | `false`               |
| `web.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                   | `60`                  |
| `web.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                          | `10`                  |
| `web.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                         | `1`                   |
| `web.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                       | `15`                  |
| `web.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                       | `1`                   |
| `web.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                                      | `{}`                  |
| `web.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                                     | `{}`                  |
| `web.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                                       | `{}`                  |
| `web.resources.limits`                      | The resources limits for the Airflow web containers                                                                      | `{}`                  |
| `web.resources.requests`                    | The requested resources for the Airflow web containers                                                                   | `{}`                  |
| `web.podSecurityContext.enabled`            | Enabled Airflow web pods' Security Context                                                                               | `true`                |
| `web.podSecurityContext.fsGroup`            | Set Airflow web pod's Security Context fsGroup                                                                           | `1001`                |
| `web.containerSecurityContext.enabled`      | Enabled Airflow web containers' Security Context                                                                         | `true`                |
| `web.containerSecurityContext.runAsUser`    | Set Airflow web containers' Security Context runAsUser                                                                   | `1001`                |
| `web.containerSecurityContext.runAsNonRoot` | Set Airflow web containers' Security Context runAsNonRoot                                                                | `true`                |
| `web.lifecycleHooks`                        | for the Airflow web container(s) to automate configuration before or after startup                                       | `{}`                  |
| `web.hostAliases`                           | Deployment pod host aliases                                                                                              | `[]`                  |
| `web.podLabels`                             | Add extra labels to the Airflow web pods                                                                                 | `{}`                  |
| `web.podAnnotations`                        | Add extra annotations to the Airflow web pods                                                                            | `{}`                  |
| `web.affinity`                              | Affinity for Airflow web pods assignment (evaluated as a template)                                                       | `{}`                  |
| `web.nodeAffinityPreset.key`                | Node label key to match. Ignored if `web.affinity` is set.                                                               | `""`                  |
| `web.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                            | `""`                  |
| `web.nodeAffinityPreset.values`             | Node label values to match. Ignored if `web.affinity` is set.                                                            | `[]`                  |
| `web.nodeSelector`                          | Node labels for Airflow web pods assignment                                                                              | `{}`                  |
| `web.podAffinityPreset`                     | Pod affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`.                                 | `""`                  |
| `web.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`.                            | `soft`                |
| `web.tolerations`                           | Tolerations for Airflow web pods assignment                                                                              | `[]`                  |
| `web.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `{}`                  |
| `web.priorityClassName`                     | Priority Class Name                                                                                                      | `""`                  |
| `web.schedulerName`                         | Use an alternate scheduler, e.g. "stork".                                                                                | `""`                  |
| `web.terminationGracePeriodSeconds`         | Seconds Airflow web pod needs to terminate gracefully                                                                    | `""`                  |
| `web.updateStrategy.type`                   | Airflow web deployment strategy type                                                                                     | `RollingUpdate`       |
| `web.updateStrategy.rollingUpdate`          | Airflow web deployment rolling update configuration parameters                                                           | `{}`                  |
| `web.sidecars`                              | Add additional sidecar containers to the Airflow web pods                                                                | `[]`                  |
| `web.initContainers`                        | Add additional init containers to the Airflow web pods                                                                   | `[]`                  |
| `web.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Airflow web pods                                        | `[]`                  |
| `web.extraVolumes`                          | Optionally specify extra list of additional volumes for the Airflow web pods                                             | `[]`                  |
| `web.pdb.create`                            | Deploy a pdb object for the Airflow web pods                                                                             | `false`               |
| `web.pdb.minAvailable`                      | Maximum number/percentage of unavailable Airflow web replicas                                                            | `1`                   |
| `web.pdb.maxUnavailable`                    | Maximum number/percentage of unavailable Airflow web replicas                                                            | `""`                  |


### Airflow scheduler parameters

| Name                                              | Description                                                                                                              | Value                       |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------------------- |
| `scheduler.image.registry`                        | Airflow Scheduler image registry                                                                                         | `docker.io`                 |
| `scheduler.image.repository`                      | Airflow Scheduler image repository                                                                                       | `bitnami/airflow-scheduler` |
| `scheduler.image.tag`                             | Airflow Scheduler image tag (immutable tags are recommended)                                                             | `2.2.5-debian-10-r14`       |
| `scheduler.image.pullPolicy`                      | Airflow Scheduler image pull policy                                                                                      | `IfNotPresent`              |
| `scheduler.image.pullSecrets`                     | Airflow Scheduler image pull secrets                                                                                     | `[]`                        |
| `scheduler.image.debug`                           | Enable image debug mode                                                                                                  | `false`                     |
| `scheduler.replicaCount`                          | Number of scheduler replicas                                                                                             | `1`                         |
| `scheduler.command`                               | Override cmd                                                                                                             | `[]`                        |
| `scheduler.args`                                  | Override args                                                                                                            | `[]`                        |
| `scheduler.extraEnvVars`                          | Add extra environment variables                                                                                          | `[]`                        |
| `scheduler.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                                               | `""`                        |
| `scheduler.extraEnvVarsSecret`                    | Secret with extra environment variables                                                                                  | `""`                        |
| `scheduler.extraEnvVarsSecrets`                   | List of secrets with extra environment variables for Airflow scheduler pods                                              | `[]`                        |
| `scheduler.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                                      | `{}`                        |
| `scheduler.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                                     | `{}`                        |
| `scheduler.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                                       | `{}`                        |
| `scheduler.resources.limits`                      | The resources limits for the Airflow scheduler containers                                                                | `{}`                        |
| `scheduler.resources.requests`                    | The requested resources for the Airflow scheduler containers                                                             | `{}`                        |
| `scheduler.podSecurityContext.enabled`            | Enabled Airflow scheduler pods' Security Context                                                                         | `true`                      |
| `scheduler.podSecurityContext.fsGroup`            | Set Airflow scheduler pod's Security Context fsGroup                                                                     | `1001`                      |
| `scheduler.containerSecurityContext.enabled`      | Enabled Airflow scheduler containers' Security Context                                                                   | `true`                      |
| `scheduler.containerSecurityContext.runAsUser`    | Set Airflow scheduler containers' Security Context runAsUser                                                             | `1001`                      |
| `scheduler.containerSecurityContext.runAsNonRoot` | Set Airflow scheduler containers' Security Context runAsNonRoot                                                          | `true`                      |
| `scheduler.lifecycleHooks`                        | for the Airflow scheduler container(s) to automate configuration before or after startup                                 | `{}`                        |
| `scheduler.hostAliases`                           | Deployment pod host aliases                                                                                              | `[]`                        |
| `scheduler.podLabels`                             | Add extra labels to the Airflow scheduler pods                                                                           | `{}`                        |
| `scheduler.podAnnotations`                        | Add extra annotations to the Airflow scheduler pods                                                                      | `{}`                        |
| `scheduler.affinity`                              | Affinity for Airflow scheduler pods assignment (evaluated as a template)                                                 | `{}`                        |
| `scheduler.nodeAffinityPreset.key`                | Node label key to match. Ignored if `scheduler.affinity` is set.                                                         | `""`                        |
| `scheduler.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard`                      | `""`                        |
| `scheduler.nodeAffinityPreset.values`             | Node label values to match. Ignored if `scheduler.affinity` is set.                                                      | `[]`                        |
| `scheduler.nodeSelector`                          | Node labels for Airflow scheduler pods assignment                                                                        | `{}`                        |
| `scheduler.podAffinityPreset`                     | Pod affinity preset. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard`.                           | `""`                        |
| `scheduler.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard`.                      | `soft`                      |
| `scheduler.tolerations`                           | Tolerations for Airflow scheduler pods assignment                                                                        | `[]`                        |
| `scheduler.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `{}`                        |
| `scheduler.priorityClassName`                     | Priority Class Name                                                                                                      | `""`                        |
| `scheduler.schedulerName`                         | Use an alternate scheduler, e.g. "stork".                                                                                | `""`                        |
| `scheduler.terminationGracePeriodSeconds`         | Seconds Airflow scheduler pod needs to terminate gracefully                                                              | `""`                        |
| `scheduler.updateStrategy.type`                   | Airflow scheduler deployment strategy type                                                                               | `RollingUpdate`             |
| `scheduler.updateStrategy.rollingUpdate`          | Airflow scheduler deployment rolling update configuration parameters                                                     | `{}`                        |
| `scheduler.sidecars`                              | Add additional sidecar containers to the Airflow scheduler pods                                                          | `[]`                        |
| `scheduler.initContainers`                        | Add additional init containers to the Airflow scheduler pods                                                             | `[]`                        |
| `scheduler.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Airflow scheduler pods                                  | `[]`                        |
| `scheduler.extraVolumes`                          | Optionally specify extra list of additional volumes for the Airflow scheduler pods                                       | `[]`                        |
| `scheduler.pdb.create`                            | Deploy a pdb object for the Airflow scheduler pods                                                                       | `false`                     |
| `scheduler.pdb.minAvailable`                      | Maximum number/percentage of unavailable Airflow scheduler replicas                                                      | `1`                         |
| `scheduler.pdb.maxUnavailable`                    | Maximum number/percentage of unavailable Airflow scheduler replicas                                                      | `""`                        |


### Airflow worker parameters

| Name                                           | Description                                                                                                              | Value                    |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------ |
| `worker.image.registry`                        | Airflow Worker image registry                                                                                            | `docker.io`              |
| `worker.image.repository`                      | Airflow Worker image repository                                                                                          | `bitnami/airflow-worker` |
| `worker.image.tag`                             | Airflow Worker image tag (immutable tags are recommended)                                                                | `2.2.5-debian-10-r14`    |
| `worker.image.pullPolicy`                      | Airflow Worker image pull policy                                                                                         | `IfNotPresent`           |
| `worker.image.pullSecrets`                     | Airflow Worker image pull secrets                                                                                        | `[]`                     |
| `worker.image.debug`                           | Enable image debug mode                                                                                                  | `false`                  |
| `worker.command`                               | Override default container command (useful when using custom images)                                                     | `[]`                     |
| `worker.args`                                  | Override default container args (useful when using custom images)                                                        | `[]`                     |
| `worker.extraEnvVars`                          | Array with extra environment variables to add Airflow worker pods                                                        | `[]`                     |
| `worker.extraEnvVarsCM`                        | ConfigMap containing extra environment variables for Airflow worker pods                                                 | `""`                     |
| `worker.extraEnvVarsSecret`                    | Secret containing extra environment variables (in case of sensitive data) for Airflow worker pods                        | `""`                     |
| `worker.extraEnvVarsSecrets`                   | List of secrets with extra environment variables for Airflow worker pods                                                 | `[]`                     |
| `worker.containerPorts.http`                   | Airflow worker HTTP container port                                                                                       | `8793`                   |
| `worker.replicaCount`                          | Number of Airflow worker replicas                                                                                        | `1`                      |
| `worker.livenessProbe.enabled`                 | Enable livenessProbe on Airflow worker containers                                                                        | `true`                   |
| `worker.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                  | `180`                    |
| `worker.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                         | `20`                     |
| `worker.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                        | `5`                      |
| `worker.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                      | `6`                      |
| `worker.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                      | `1`                      |
| `worker.readinessProbe.enabled`                | Enable readinessProbe on Airflow worker containers                                                                       | `true`                   |
| `worker.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                 | `30`                     |
| `worker.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                        | `10`                     |
| `worker.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                       | `5`                      |
| `worker.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                     | `6`                      |
| `worker.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                     | `1`                      |
| `worker.startupProbe.enabled`                  | Enable startupProbe on Airflow worker containers                                                                         | `false`                  |
| `worker.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                   | `60`                     |
| `worker.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                          | `10`                     |
| `worker.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                         | `1`                      |
| `worker.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                       | `15`                     |
| `worker.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                       | `1`                      |
| `worker.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                                      | `{}`                     |
| `worker.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                                     | `{}`                     |
| `worker.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                                       | `{}`                     |
| `worker.resources.limits`                      | The resources limits for the Airflow worker containers                                                                   | `{}`                     |
| `worker.resources.requests`                    | The requested resources for the Airflow worker containers                                                                | `{}`                     |
| `worker.podSecurityContext.enabled`            | Enabled Airflow worker pods' Security Context                                                                            | `true`                   |
| `worker.podSecurityContext.fsGroup`            | Set Airflow worker pod's Security Context fsGroup                                                                        | `1001`                   |
| `worker.containerSecurityContext.enabled`      | Enabled Airflow worker containers' Security Context                                                                      | `true`                   |
| `worker.containerSecurityContext.runAsUser`    | Set Airflow worker containers' Security Context runAsUser                                                                | `1001`                   |
| `worker.containerSecurityContext.runAsNonRoot` | Set Airflow worker containers' Security Context runAsNonRoot                                                             | `true`                   |
| `worker.lifecycleHooks`                        | for the Airflow worker container(s) to automate configuration before or after startup                                    | `{}`                     |
| `worker.hostAliases`                           | Deployment pod host aliases                                                                                              | `[]`                     |
| `worker.podLabels`                             | Add extra labels to the Airflow worker pods                                                                              | `{}`                     |
| `worker.podAnnotations`                        | Add extra annotations to the Airflow worker pods                                                                         | `{}`                     |
| `worker.affinity`                              | Affinity for Airflow worker pods assignment (evaluated as a template)                                                    | `{}`                     |
| `worker.nodeAffinityPreset.key`                | Node label key to match. Ignored if `worker.affinity` is set.                                                            | `""`                     |
| `worker.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`                         | `""`                     |
| `worker.nodeAffinityPreset.values`             | Node label values to match. Ignored if `worker.affinity` is set.                                                         | `[]`                     |
| `worker.nodeSelector`                          | Node labels for Airflow worker pods assignment                                                                           | `{}`                     |
| `worker.podAffinityPreset`                     | Pod affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`.                              | `""`                     |
| `worker.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`.                         | `soft`                   |
| `worker.tolerations`                           | Tolerations for Airflow worker pods assignment                                                                           | `[]`                     |
| `worker.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `{}`                     |
| `worker.priorityClassName`                     | Priority Class Name                                                                                                      | `""`                     |
| `worker.schedulerName`                         | Use an alternate scheduler, e.g. "stork".                                                                                | `""`                     |
| `worker.terminationGracePeriodSeconds`         | Seconds Airflow worker pod needs to terminate gracefully                                                                 | `""`                     |
| `worker.updateStrategy.type`                   | Airflow worker deployment strategy type                                                                                  | `RollingUpdate`          |
| `worker.updateStrategy.rollingUpdate`          | Airflow worker deployment rolling update configuration parameters                                                        | `{}`                     |
| `worker.sidecars`                              | Add additional sidecar containers to the Airflow worker pods                                                             | `[]`                     |
| `worker.initContainers`                        | Add additional init containers to the Airflow worker pods                                                                | `[]`                     |
| `worker.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Airflow worker pods                                     | `[]`                     |
| `worker.extraVolumes`                          | Optionally specify extra list of additional volumes for the Airflow worker pods                                          | `[]`                     |
| `worker.extraVolumeClaimTemplates`             | Optionally specify extra list of volumesClaimTemplates for the Airflow worker statefulset                                | `[]`                     |
| `worker.podTemplate`                           | Template to replace the default one to be use when `executor=KubernetesExecutor` to create Airflow worker pods           | `{}`                     |
| `worker.pdb.create`                            | Deploy a pdb object for the Airflow worker pods                                                                          | `false`                  |
| `worker.pdb.minAvailable`                      | Maximum number/percentage of unavailable Airflow worker replicas                                                         | `1`                      |
| `worker.pdb.maxUnavailable`                    | Maximum number/percentage of unavailable Airflow worker replicas                                                         | `""`                     |
| `worker.autoscaling.enabled`                   | Whether enable horizontal pod autoscaler                                                                                 | `false`                  |
| `worker.autoscaling.minReplicas`               | Configure a minimum amount of pods                                                                                       | `1`                      |
| `worker.autoscaling.maxReplicas`               | Configure a maximum amount of pods                                                                                       | `3`                      |
| `worker.autoscaling.targetCPU`                 | Define the CPU target to trigger the scaling actions (utilization percentage)                                            | `80`                     |
| `worker.autoscaling.targetMemory`              | Define the memory target to trigger the scaling actions (utilization percentage)                                         | `80`                     |


### Airflow git sync parameters

| Name                           | Description                                                                            | Value                 |
| ------------------------------ | -------------------------------------------------------------------------------------- | --------------------- |
| `git.image.registry`           | Git image registry                                                                     | `docker.io`           |
| `git.image.repository`         | Git image repository                                                                   | `bitnami/git`         |
| `git.image.tag`                | Git image tag (immutable tags are recommended)                                         | `2.36.0-debian-10-r1` |
| `git.image.pullPolicy`         | Git image pull policy                                                                  | `IfNotPresent`        |
| `git.image.pullSecrets`        | Git image pull secrets                                                                 | `[]`                  |
| `git.dags.enabled`             | Enable in order to download DAG files from git repositories.                           | `false`               |
| `git.dags.repositories`        | Array of repositories from which to download DAG files                                 | `[]`                  |
| `git.plugins.enabled`          | Enable in order to download Plugins files from git repositories.                       | `false`               |
| `git.plugins.repositories`     | Array of repositories from which to download DAG files                                 | `[]`                  |
| `git.clone.command`            | Override cmd                                                                           | `[]`                  |
| `git.clone.args`               | Override args                                                                          | `[]`                  |
| `git.clone.extraVolumeMounts`  | Add extra volume mounts                                                                | `[]`                  |
| `git.clone.extraEnvVars`       | Add extra environment variables                                                        | `[]`                  |
| `git.clone.extraEnvVarsCM`     | ConfigMap with extra environment variables                                             | `""`                  |
| `git.clone.extraEnvVarsSecret` | Secret with extra environment variables                                                | `""`                  |
| `git.clone.resources`          | Clone init container resource requests and limits                                      | `{}`                  |
| `git.sync.interval`            | Interval in seconds to pull the git repository containing the plugins and/or DAG files | `60`                  |
| `git.sync.command`             | Override cmd                                                                           | `[]`                  |
| `git.sync.args`                | Override args                                                                          | `[]`                  |
| `git.sync.extraVolumeMounts`   | Add extra volume mounts                                                                | `[]`                  |
| `git.sync.extraEnvVars`        | Add extra environment variables                                                        | `[]`                  |
| `git.sync.extraEnvVarsCM`      | ConfigMap with extra environment variables                                             | `""`                  |
| `git.sync.extraEnvVarsSecret`  | Secret with extra environment variables                                                | `""`                  |
| `git.sync.resources`           | Sync sidecar container resource requests and limits                                    | `{}`                  |


### Airflow ldap parameters

| Name                             | Description                                                                                                                        | Value                                                                                                     |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `ldap.enabled`                   | Enable LDAP authentication                                                                                                         | `false`                                                                                                   |
| `ldap.uri`                       | Server URI, eg. ldap://ldap_server:389                                                                                             | `ldap://ldap_server:389`                                                                                  |
| `ldap.base`                      | Base of the search, eg. ou=example,o=org                                                                                           | `dc=example,dc=org`                                                                                       |
| `ldap.uidField`                  | if doing an indirect bind to ldap, this is the field that matches the username when searching for the account to bind to           | `cn`                                                                                                      |
| `ldap.binddn`                    | Bind DN                                                                                                                            | `cn=admin,dc=example,dc=org`                                                                              |
| `ldap.bindpw`                    | Bind Password                                                                                                                      | `""`                                                                                                      |
| `ldap.userRegistration`          | Set to True to enable user self registration                                                                                       | `True`                                                                                                    |
| `ldap.userRegistrationRole`      | Set role name to be assign when a user registers himself. This role must already exist. Mandatory when using ldap.userRegistration | `Public`                                                                                                  |
| `ldap.rolesMapping`              | mapping from LDAP DN to a list of roles                                                                                            | `{ "cn=All,ou=Groups,dc=example,dc=org": ["User"], "cn=Admins,ou=Groups,dc=example,dc=org": ["Admin"], }` |
| `ldap.rolesSyncAtLogin`          | replace ALL the user's roles each login, or only on registration                                                                   | `True`                                                                                                    |
| `ldap.tls.enabled`               | Enabled TLS/SSL for LDAP, you must include the CA file.                                                                            | `false`                                                                                                   |
| `ldap.tls.allowSelfSigned`       | Allow to use self signed certificates                                                                                              | `true`                                                                                                    |
| `ldap.tls.CAcertificateSecret`   | Name of the existing secret containing the certificate CA file that will be used by ldap client.                                   | `""`                                                                                                      |
| `ldap.tls.CAcertificateFilename` | LDAP CA cert filename                                                                                                              | `""`                                                                                                      |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Airflow service type                                                                                                             | `ClusterIP`              |
| `service.ports.http`               | Airflow service HTTP port                                                                                                        | `8080`                   |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
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


### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Airflow pods                     | `false` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `true`  |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |
| `rbac.create`                                 | Create Role and RoleBinding                                            | `false` |
| `rbac.rules`                                  | Custom RBAC rules to set                                               | `[]`    |


### Airflow metrics parameters

| Name                                            | Description                                                                                         | Value                        |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------- | ---------------------------- |
| `metrics.enabled`                               | Whether or not to create a standalone Airflow exporter to expose Airflow metrics                    | `false`                      |
| `metrics.image.registry`                        | Airflow exporter image registry                                                                     | `docker.io`                  |
| `metrics.image.repository`                      | Airflow exporter image repository                                                                   | `bitnami/airflow-exporter`   |
| `metrics.image.tag`                             | Airflow exporter image tag (immutable tags are recommended)                                         | `0.20220314.0-debian-10-r37` |
| `metrics.image.pullPolicy`                      | Airflow exporter image pull policy                                                                  | `IfNotPresent`               |
| `metrics.image.pullSecrets`                     | Airflow exporter image pull secrets                                                                 | `[]`                         |
| `metrics.extraEnvVars`                          | Array with extra environment variables to add Airflow exporter pods                                 | `[]`                         |
| `metrics.extraEnvVarsCM`                        | ConfigMap containing extra environment variables for Airflow exporter pods                          | `""`                         |
| `metrics.extraEnvVarsSecret`                    | Secret containing extra environment variables (in case of sensitive data) for Airflow exporter pods | `""`                         |
| `metrics.containerPorts.http`                   | Airflow exporter metrics container port                                                             | `9112`                       |
| `metrics.resources.limits`                      | The resources limits for the container                                                              | `{}`                         |
| `metrics.resources.requests`                    | The requested resources for the container                                                           | `{}`                         |
| `metrics.podSecurityContext.enabled`            | Enable security context for the pods                                                                | `true`                       |
| `metrics.podSecurityContext.fsGroup`            | Set Airflow exporter pod's Security Context fsGroup                                                 | `1001`                       |
| `metrics.containerSecurityContext.enabled`      | Enable Airflow exporter containers' Security Context                                                | `true`                       |
| `metrics.containerSecurityContext.runAsUser`    | Set Airflow exporter containers' Security Context runAsUser                                         | `1001`                       |
| `metrics.containerSecurityContext.runAsNonRoot` | Set Airflow exporter containers' Security Context runAsNonRoot                                      | `true`                       |
| `metrics.lifecycleHooks`                        | for the Airflow exporter container(s) to automate configuration before or after startup             | `{}`                         |
| `metrics.hostAliases`                           | Airflow exporter pods host aliases                                                                  | `[]`                         |
| `metrics.podLabels`                             | Extra labels for Airflow exporter pods                                                              | `{}`                         |
| `metrics.podAnnotations`                        | Extra annotations for Airflow exporter pods                                                         | `{}`                         |
| `metrics.podAffinityPreset`                     | Pod affinity preset. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`         | `""`                         |
| `metrics.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`    | `soft`                       |
| `metrics.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`   | `""`                         |
| `metrics.nodeAffinityPreset.key`                | Node label key to match Ignored if `metrics.affinity` is set.                                       | `""`                         |
| `metrics.nodeAffinityPreset.values`             | Node label values to match. Ignored if `metrics.affinity` is set.                                   | `[]`                         |
| `metrics.affinity`                              | Affinity for pod assignment                                                                         | `{}`                         |
| `metrics.nodeSelector`                          | Node labels for pod assignment                                                                      | `{}`                         |
| `metrics.tolerations`                           | Tolerations for pod assignment                                                                      | `[]`                         |
| `metrics.schedulerName`                         | Name of the k8s scheduler (other than default) for Airflow exporter                                 | `""`                         |
| `metrics.service.ports.http`                    | Airflow exporter metrics service port                                                               | `9112`                       |
| `metrics.service.clusterIP`                     | Static clusterIP or None for headless services                                                      | `""`                         |
| `metrics.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                    | `None`                       |
| `metrics.service.annotations`                   | Annotations for the Airflow exporter service                                                        | `{}`                         |
| `metrics.serviceMonitor.enabled`                | if `true`, creates a Prometheus Operator ServiceMonitor (requires `metrics.enabled` to be `true`)   | `false`                      |
| `metrics.serviceMonitor.namespace`              | Namespace in which Prometheus is running                                                            | `""`                         |
| `metrics.serviceMonitor.interval`               | Interval at which metrics should be scraped                                                         | `""`                         |
| `metrics.serviceMonitor.scrapeTimeout`          | Timeout after which the scrape is ended                                                             | `""`                         |
| `metrics.serviceMonitor.labels`                 | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus               | `{}`                         |
| `metrics.serviceMonitor.selector`               | Prometheus instance selector labels                                                                 | `{}`                         |
| `metrics.serviceMonitor.relabelings`            | RelabelConfigs to apply to samples before scraping                                                  | `[]`                         |
| `metrics.serviceMonitor.metricRelabelings`      | MetricRelabelConfigs to apply to samples before ingestion                                           | `[]`                         |
| `metrics.serviceMonitor.honorLabels`            | Specify honorLabels parameter to add the scrape endpoint                                            | `false`                      |
| `metrics.serviceMonitor.jobLabel`               | The name of the label on the target service to use as the job name in prometheus.                   | `""`                         |


### Airflow database parameters

| Name                                         | Description                                                                                            | Value             |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------- |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                                                  | `true`            |
| `postgresql.auth.enablePostgresUser`         | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user | `false`           |
| `postgresql.auth.username`                   | Name for a custom user to create                                                                       | `bn_airflow`      |
| `postgresql.auth.password`                   | Password for the custom user to create                                                                 | `""`              |
| `postgresql.auth.database`                   | Name for a custom database to create                                                                   | `bitnami_airflow` |
| `postgresql.auth.existingSecret`             | Name of existing secret to use for PostgreSQL credentials                                              | `""`              |
| `postgresql.architecture`                    | PostgreSQL architecture (`standalone` or `replication`)                                                | `standalone`      |
| `externalDatabase.host`                      | Database host                                                                                          | `localhost`       |
| `externalDatabase.port`                      | Database port number                                                                                   | `5432`            |
| `externalDatabase.user`                      | Non-root username for Airflow                                                                          | `bn_airflow`      |
| `externalDatabase.password`                  | Password for the non-root username for Airflow                                                         | `""`              |
| `externalDatabase.database`                  | Airflow database name                                                                                  | `bitnami_airflow` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials                                | `""`              |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials                                     | `""`              |
| `redis.enabled`                              | Switch to enable or disable the Redis&trade; helm                                                      | `true`            |
| `redis.auth.enabled`                         | Enable password authentication                                                                         | `true`            |
| `redis.auth.password`                        | Redis&trade; password                                                                                  | `""`              |
| `redis.auth.existingSecret`                  | The name of an existing secret with Redis&trade; credentials                                           | `""`              |
| `redis.architecture`                         | Redis&trade; architecture. Allowed values: `standalone` or `replication`                               | `standalone`      |
| `externalRedis.host`                         | Redis&trade; host                                                                                      | `localhost`       |
| `externalRedis.port`                         | Redis&trade; port number                                                                               | `6379`            |
| `externalRedis.username`                     | Redis&trade; username                                                                                  | `""`              |
| `externalRedis.password`                     | Redis&trade; password                                                                                  | `""`              |
| `externalRedis.existingSecret`               | Name of an existing secret resource containing the Redis&trade credentials                             | `""`              |
| `externalRedis.existingSecretPasswordKey`    | Name of an existing secret key containing the Redis&trade credentials                                  | `""`              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
               --set auth.username=my-user \
               --set auth.password=my-passsword \
               --set auth.fernetKey=my-fernet-key \
               --set auth.secretKey=my-secret-key \
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

You can use an existing secret to configure your Airflow auth, external Postgres, and external Redis&trade; passwords:

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

> NOTE: Redis&trade; is not needed to be deployed when using KubernetesExecutor so you must disable it using `redis.enabled=false`.

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

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

Refer to the [chart documentation for more information about how to upgrade from previous releases](https://docs.bitnami.com/kubernetes/infrastructure/airflow/administration/upgrade/).

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