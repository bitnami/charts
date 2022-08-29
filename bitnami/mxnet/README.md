<!--- app-name: Apache MXNet (Incubating) -->

# Apache MXNet (Incubating) packaged by Bitnami

Apache MXNet (Incubating) is a flexible and efficient library for deep learning designed to work as a neural network. Bitnami image ships OpenBLAS as math library.

[Overview of Apache MXNet (Incubating)](https://mxnet.incubator.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mxnet
```

## Introduction

This chart bootstraps an [Apache MXNet (Incubating)](https://github.com/bitnami/containers/tree/main/bitnami/mxnet) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mxnet
```

These commands deploy Apache MXNet (Incubating) on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured.

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
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace template                                     | `""`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                   | `{}`            |
| `commonLabels`           | Labels to add to all deployed objects                                                        | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                               | `cluster.local` |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)                   | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                      | `["infinity"]`  |


### Common Mxnet parameters

| Name                                  | Description                                                                                                               | Value                 |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`                      | Apache MXNet (Incubating) image registry                                                                                  | `docker.io`           |
| `image.repository`                    | Apache MXNet (Incubating) image repository                                                                                | `bitnami/mxnet`       |
| `image.tag`                           | Apache MXNet (Incubating) image tag (immutable tags are recommended)                                                      | `1.9.1-debian-11-r24` |
| `image.digest`                        | Apache MXNet (Incubating) image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                  |
| `image.pullPolicy`                    | Apache MXNet (Incubating) image pull policy                                                                               | `IfNotPresent`        |
| `image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                          | `[]`                  |
| `image.debug`                         | Specify if debug logs should be enabled                                                                                   | `false`               |
| `entrypoint`                          | The main entrypoint of your app, this will be executed as:                                                                | `{}`                  |
| `mode`                                | Apache MXNet (Incubating) deployment mode. Can be `standalone` or `distributed`                                           | `standalone`          |
| `existingSecret`                      | Name of a secret with sensitive data to mount in the pods                                                                 | `""`                  |
| `configMap`                           | Name of an existing config map containing all the files you want to load in Apache MXNet (Incubating)                     | `""`                  |
| `cloneFilesFromGit.enabled`           | Enable in order to download files from git repository                                                                     | `false`               |
| `cloneFilesFromGit.repository`        | Repository to clone                                                                                                       | `""`                  |
| `cloneFilesFromGit.revision`          | Branch name to clone                                                                                                      | `master`              |
| `cloneFilesFromGit.extraVolumeMounts` | Add extra volume mounts for the GIT container                                                                             | `[]`                  |
| `persistence.enabled`                 | Use a PVC to persist data                                                                                                 | `false`               |
| `persistence.storageClass`            | discourse & sidekiq data Persistent Volume Storage Class                                                                  | `""`                  |
| `persistence.existingClaim`           | Use a existing PVC which must be created manually before bound                                                            | `""`                  |
| `persistence.mountPath`               | Path to mount the volume at                                                                                               | `/bitnami/mxnet`      |
| `persistence.accessModes`             | Persistent Volume Access Mode                                                                                             | `["ReadWriteOnce"]`   |
| `persistence.size`                    | Size of data volume                                                                                                       | `8Gi`                 |
| `persistence.annotations`             | Persistent Volume annotations                                                                                             | `{}`                  |
| `extraEnvVars`                        | Array with extra environment variables to add to all the pods                                                             | `[]`                  |
| `extraEnvVarsCM`                      | Name of existing ConfigMap containing extra env vars for all the pods                                                     | `""`                  |
| `extraEnvVarsSecret`                  | Name of existing Secret containing extra env vars for all the pods                                                        | `""`                  |
| `extraVolumes`                        | Array to add extra volumes (evaluated as a template)                                                                      | `[]`                  |
| `extraVolumeMounts`                   | Array to add extra mounts (normally used with extraVolumes, evaluated as a template)                                      | `[]`                  |
| `sidecars`                            | Attach additional containers to the pods (scheduler, worker and server nodes)                                             | `[]`                  |
| `initContainers`                      | Attach additional init containers to the pods (scheduler, worker and server nodes)                                        | `[]`                  |


### Mxnet Standalone parameters (only for standalone mode)

| Name                                               | Description                                                                                          | Value           |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | --------------- |
| `standalone.affinity`                              | Affinity for Mxnet standalone pods assignment                                                        | `{}`            |
| `standalone.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `standalone.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `standalone.nodeAffinityPreset.key`                | Node label key to match. Ignored if `standalone.affinity` is set                                     | `""`            |
| `standalone.nodeAffinityPreset.values`             | Node label values to match. Ignored if `standalone.affinity` is set                                  | `[]`            |
| `standalone.nodeSelector`                          | Node labels for Mxnet standalone pods assignment                                                     | `{}`            |
| `standalone.podAffinityPreset`                     | Pod affinity preset. Ignored if `standalone.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `standalone.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `standalone.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `standalone.hostAliases`                           | Mxnet standalone pods host aliases                                                                   | `[]`            |
| `standalone.tolerations`                           | Tolerations for Mxnet standalone pods assignment                                                     | `[]`            |
| `standalone.podAnnotations`                        | Annotations for Mxnet standalone pods                                                                | `{}`            |
| `standalone.podLabels`                             | Extra labels for Mxnet standalone pods                                                               | `{}`            |
| `standalone.podSecurityContext.enabled`            | Enabled Mxnet standalone pods' Security Context                                                      | `true`          |
| `standalone.podSecurityContext.fsGroup`            | Set Mxnet standalone pod's Security Context fsGroup                                                  | `1001`          |
| `standalone.containerSecurityContext.enabled`      | Enabled Mxnet standalone containers' Security Context                                                | `true`          |
| `standalone.containerSecurityContext.runAsUser`    | Set Mxnet standalone containers' Security Context runAsUser                                          | `1001`          |
| `standalone.containerSecurityContext.runAsNonRoot` | Set Mxnet standalone container's Security Context runAsNonRoot                                       | `true`          |
| `standalone.command`                               | Override default container command (useful when using custom images)                                 | `[]`            |
| `standalone.args`                                  | Override default container args (useful when using custom images)                                    | `[]`            |
| `standalone.lifecycleHooks`                        | for the Mxnet standalone container(s) to automate configuration before or after startup              | `{}`            |
| `standalone.extraEnvVars`                          | Array with extra environment variables to add to Mxnet standalone nodes                              | `[]`            |
| `standalone.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for Mxnet standalone nodes                      | `""`            |
| `standalone.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for Mxnet standalone nodes                         | `""`            |
| `standalone.extraVolumes`                          | Optionally specify extra list of additional volumes for the Mxnet standalone pod(s)                  | `[]`            |
| `standalone.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Mxnet standalone container(s)       | `[]`            |
| `standalone.containerPorts.mxnet`                  | Mxnet container port                                                                                 | `9092`          |
| `standalone.sidecars`                              | Add additional sidecar containers to the Mxnet standalone pod(s)                                     | `[]`            |
| `standalone.initContainers`                        | Add additional init containers to the Mxnet standalone pod(s)                                        | `[]`            |
| `standalone.updateStrategy.type`                   | Mxnet standalone deployment strategy type.                                                           | `RollingUpdate` |
| `standalone.priorityClassName`                     | Mxnet standalone pods' priorityClassName                                                             | `""`            |
| `standalone.schedulerName`                         | Name of the k8s scheduler (other than default)                                                       | `""`            |
| `standalone.terminationGracePeriodSeconds`         | In seconds, time the given to the Mxnet standalone pod needs to terminate gracefully                 | `""`            |
| `standalone.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                       | `[]`            |
| `standalone.resources.limits`                      | The resources limits for the Mxnet container                                                         | `{}`            |
| `standalone.resources.requests`                    | The requested resources for the Mxnet container                                                      | `{}`            |
| `standalone.startupProbe.enabled`                  | Enable startupProbe                                                                                  | `false`         |
| `standalone.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                               | `5`             |
| `standalone.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                      | `5`             |
| `standalone.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                     | `15`            |
| `standalone.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                   | `5`             |
| `standalone.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                   | `1`             |
| `standalone.livenessProbe.enabled`                 | Enable livenessProbe                                                                                 | `true`          |
| `standalone.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                              | `5`             |
| `standalone.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                     | `5`             |
| `standalone.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                    | `15`            |
| `standalone.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                  | `5`             |
| `standalone.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                  | `1`             |
| `standalone.readinessProbe.enabled`                | Enable readinessProbe                                                                                | `true`          |
| `standalone.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                             | `5`             |
| `standalone.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                    | `5`             |
| `standalone.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                   | `15`            |
| `standalone.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                 | `5`             |
| `standalone.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                 | `1`             |
| `standalone.customStartupProbe`                    | Custom liveness probe for the Web component                                                          | `{}`            |
| `standalone.customLivenessProbe`                   | Custom liveness probe for the Web component                                                          | `{}`            |
| `standalone.customReadinessProbe`                  | Custom readiness probe for the Web component                                                         | `{}`            |


### Mxnet Server parameters (only for distributed mode)

| Name                                           | Description                                                                                      | Value           |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------- |
| `server.replicaCount`                          | Number of Server nodes that will execute your code                                               | `1`             |
| `server.affinity`                              | Affinity for Mxnet server pods assignment                                                        | `{}`            |
| `server.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `server.nodeAffinityPreset.key`                | Node label key to match. Ignored if `server.affinity` is set                                     | `""`            |
| `server.nodeAffinityPreset.values`             | Node label values to match. Ignored if `server.affinity` is set                                  | `[]`            |
| `server.nodeSelector`                          | Node labels for Mxnet server pods assignment                                                     | `{}`            |
| `server.podAffinityPreset`                     | Pod affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `server.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `server.hostAliases`                           | Mxnet server pods host aliases                                                                   | `[]`            |
| `server.tolerations`                           | Tolerations for Mxnet server pods assignment                                                     | `[]`            |
| `server.podAnnotations`                        | Annotations for Mxnet server pods                                                                | `{}`            |
| `server.podLabels`                             | Extra labels for Mxnet server pods                                                               | `{}`            |
| `server.podSecurityContext.enabled`            | Enabled Mxnet server pods' Security Context                                                      | `true`          |
| `server.podSecurityContext.fsGroup`            | Set Mxnet server pod's Security Context fsGroup                                                  | `1001`          |
| `server.containerSecurityContext.enabled`      | Enabled Mxnet server containers' Security Context                                                | `true`          |
| `server.containerSecurityContext.runAsUser`    | Set Mxnet server containers' Security Context runAsUser                                          | `1001`          |
| `server.containerSecurityContext.runAsNonRoot` | Set Mxnet server container's Security Context runAsNonRoot                                       | `true`          |
| `server.command`                               | Override default container command (useful when using custom images)                             | `[]`            |
| `server.args`                                  | Override default container args (useful when using custom images)                                | `[]`            |
| `server.lifecycleHooks`                        | for the Mxnet server container(s) to automate configuration before or after startup              | `{}`            |
| `server.extraEnvVars`                          | Array with extra environment variables to add to Mxnet server nodes                              | `[]`            |
| `server.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for Mxnet server nodes                      | `""`            |
| `server.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for Mxnet server nodes                         | `""`            |
| `server.extraVolumes`                          | Optionally specify extra list of additional volumes for the Mxnet server pod(s)                  | `[]`            |
| `server.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Mxnet server container(s)       | `[]`            |
| `server.sidecars`                              | Add additional sidecar containers to the Mxnet server pod(s)                                     | `[]`            |
| `server.initContainers`                        | Add additional init containers to the Mxnet server pod(s)                                        | `[]`            |
| `server.updateStrategy.type`                   | Mxnet server deployment strategy type.                                                           | `RollingUpdate` |
| `server.priorityClassName`                     | Mxnet server pods' priorityClassName                                                             | `""`            |
| `server.schedulerName`                         | Name of the k8s scheduler (other than default)                                                   | `""`            |
| `server.terminationGracePeriodSeconds`         | In seconds, time the given to the Mxnet server pod needs to terminate gracefully                 | `""`            |
| `server.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                   | `[]`            |
| `server.podManagementPolicy`                   | podManagementPolicy to manage scaling operation of Mxnet server pods                             | `""`            |
| `server.resources.limits`                      | The resources limits for the Mxnet container                                                     | `{}`            |
| `server.resources.requests`                    | The requested resources for the Mxnet container                                                  | `{}`            |
| `server.startupProbe.enabled`                  | Enable startupProbe                                                                              | `false`         |
| `server.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                           | `5`             |
| `server.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                  | `5`             |
| `server.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                 | `15`            |
| `server.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                               | `5`             |
| `server.startupProbe.successThreshold`         | Success threshold for startupProbe                                                               | `1`             |
| `server.livenessProbe.enabled`                 | Enable livenessProbe                                                                             | `true`          |
| `server.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                          | `5`             |
| `server.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                 | `5`             |
| `server.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                | `15`            |
| `server.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                              | `5`             |
| `server.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                              | `1`             |
| `server.readinessProbe.enabled`                | Enable readinessProbe                                                                            | `true`          |
| `server.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                         | `5`             |
| `server.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                | `5`             |
| `server.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                               | `15`            |
| `server.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                             | `5`             |
| `server.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                             | `1`             |
| `server.customStartupProbe`                    | Custom liveness probe for the Web component                                                      | `{}`            |
| `server.customLivenessProbe`                   | Custom liveness probe for the Web component                                                      | `{}`            |
| `server.customReadinessProbe`                  | Custom readiness probe for the Web component                                                     | `{}`            |


### Mxnet Worker parameters (only for distributed mode)

| Name                                           | Description                                                                                      | Value           |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------- |
| `worker.replicaCount`                          | Number of Worker nodes that will execute your code                                               | `1`             |
| `worker.affinity`                              | Affinity for Mxnet worker pods assignment                                                        | `{}`            |
| `worker.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `worker.nodeAffinityPreset.key`                | Node label key to match. Ignored if `worker.affinity` is set                                     | `""`            |
| `worker.nodeAffinityPreset.values`             | Node label values to match. Ignored if `worker.affinity` is set                                  | `[]`            |
| `worker.nodeSelector`                          | Node labels for Mxnet worker pods assignment                                                     | `{}`            |
| `worker.podAffinityPreset`                     | Pod affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `worker.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `worker.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `worker.hostAliases`                           | Mxnet worker pods host aliases                                                                   | `[]`            |
| `worker.tolerations`                           | Tolerations for Mxnet worker pods assignment                                                     | `[]`            |
| `worker.podAnnotations`                        | Annotations for Mxnet worker pods                                                                | `{}`            |
| `worker.podLabels`                             | Extra labels for Mxnet worker pods                                                               | `{}`            |
| `worker.podSecurityContext.enabled`            | Enabled Mxnet worker pods' Security Context                                                      | `true`          |
| `worker.podSecurityContext.fsGroup`            | Set Mxnet worker pod's Security Context fsGroup                                                  | `1001`          |
| `worker.containerSecurityContext.enabled`      | Enabled Mxnet worker containers' Security Context                                                | `true`          |
| `worker.containerSecurityContext.runAsUser`    | Set Mxnet worker containers' Security Context runAsUser                                          | `1001`          |
| `worker.containerSecurityContext.runAsNonRoot` | Set Mxnet worker container's Security Context runAsNonRoot                                       | `true`          |
| `worker.command`                               | Override default container command (useful when using custom images)                             | `[]`            |
| `worker.args`                                  | Override default container args (useful when using custom images)                                | `[]`            |
| `worker.lifecycleHooks`                        | for the Mxnet worker container(s) to automate configuration before or after startup              | `{}`            |
| `worker.extraEnvVars`                          | Array with extra environment variables to add to Mxnet worker nodes                              | `[]`            |
| `worker.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for Mxnet worker nodes                      | `""`            |
| `worker.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for Mxnet worker nodes                         | `""`            |
| `worker.extraVolumes`                          | Optionally specify extra list of additional volumes for the Mxnet worker pod(s)                  | `[]`            |
| `worker.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Mxnet worker container(s)       | `[]`            |
| `worker.sidecars`                              | Add additional sidecar containers to the Mxnet worker pod(s)                                     | `[]`            |
| `worker.initContainers`                        | Add additional init containers to the Mxnet worker pod(s)                                        | `[]`            |
| `worker.updateStrategy.type`                   | Mxnet worker deployment strategy type.                                                           | `RollingUpdate` |
| `worker.priorityClassName`                     | Mxnet worker pods' priorityClassName                                                             | `""`            |
| `worker.schedulerName`                         | Name of the k8s scheduler (other than default)                                                   | `""`            |
| `worker.terminationGracePeriodSeconds`         | In seconds, time the given to the Mxnet worker pod needs to terminate gracefully                 | `""`            |
| `worker.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                   | `[]`            |
| `worker.podManagementPolicy`                   | podManagementPolicy to manage scaling operation of Mxnet worker pods                             | `""`            |
| `worker.resources.limits`                      | The resources limits for the Mxnet container                                                     | `{}`            |
| `worker.resources.requests`                    | The requested resources for the Mxnet container                                                  | `{}`            |
| `worker.startupProbe.enabled`                  | Enable startupProbe                                                                              | `false`         |
| `worker.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                           | `5`             |
| `worker.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                  | `5`             |
| `worker.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                 | `15`            |
| `worker.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                               | `5`             |
| `worker.startupProbe.successThreshold`         | Success threshold for startupProbe                                                               | `1`             |
| `worker.livenessProbe.enabled`                 | Enable livenessProbe                                                                             | `true`          |
| `worker.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                          | `5`             |
| `worker.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                 | `5`             |
| `worker.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                | `15`            |
| `worker.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                              | `5`             |
| `worker.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                              | `1`             |
| `worker.readinessProbe.enabled`                | Enable readinessProbe                                                                            | `true`          |
| `worker.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                         | `5`             |
| `worker.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                | `5`             |
| `worker.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                               | `15`            |
| `worker.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                             | `5`             |
| `worker.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                             | `1`             |
| `worker.customStartupProbe`                    | Custom liveness probe for the Web component                                                      | `{}`            |
| `worker.customLivenessProbe`                   | Custom liveness probe for the Web component                                                      | `{}`            |
| `worker.customReadinessProbe`                  | Custom readiness probe for the Web component                                                     | `{}`            |


### Mxnet Scheduler parameters (only for distributed mode)

| Name                                              | Description                                                                                         | Value           |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | --------------- |
| `scheduler.containerPorts.mxnet`                  | The port used to communicate with the scheduler                                                     | `9092`          |
| `scheduler.affinity`                              | Affinity for Mxnet scheduler pods assignment                                                        | `{}`            |
| `scheduler.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `scheduler.nodeAffinityPreset.key`                | Node label key to match. Ignored if `scheduler.affinity` is set                                     | `""`            |
| `scheduler.nodeAffinityPreset.values`             | Node label values to match. Ignored if `scheduler.affinity` is set                                  | `[]`            |
| `scheduler.nodeSelector`                          | Node labels for Mxnet scheduler pods assignment                                                     | `{}`            |
| `scheduler.podAffinityPreset`                     | Pod affinity preset. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `scheduler.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `scheduler.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `scheduler.hostAliases`                           | Mxnet scheduler pods host aliases                                                                   | `[]`            |
| `scheduler.tolerations`                           | Tolerations for Mxnet scheduler pods assignment                                                     | `[]`            |
| `scheduler.podAnnotations`                        | Annotations for Mxnet scheduler pods                                                                | `{}`            |
| `scheduler.podLabels`                             | Extra labels for Mxnet scheduler pods                                                               | `{}`            |
| `scheduler.podSecurityContext.enabled`            | Enabled Mxnet scheduler pods' Security Context                                                      | `true`          |
| `scheduler.podSecurityContext.fsGroup`            | Set Mxnet scheduler pod's Security Context fsGroup                                                  | `1001`          |
| `scheduler.containerSecurityContext.enabled`      | Enabled Mxnet scheduler containers' Security Context                                                | `true`          |
| `scheduler.containerSecurityContext.runAsUser`    | Set Mxnet scheduler containers' Security Context runAsUser                                          | `1001`          |
| `scheduler.containerSecurityContext.runAsNonRoot` | Set Mxnet scheduler container's Security Context runAsNonRoot                                       | `true`          |
| `scheduler.command`                               | Override default container command (useful when using custom images)                                | `[]`            |
| `scheduler.args`                                  | Override default container args (useful when using custom images)                                   | `[]`            |
| `scheduler.lifecycleHooks`                        | for the Mxnet scheduler container(s) to automate configuration before or after startup              | `{}`            |
| `scheduler.extraEnvVars`                          | Array with extra environment variables to add to Mxnet scheduler nodes                              | `[]`            |
| `scheduler.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for Mxnet scheduler nodes                      | `""`            |
| `scheduler.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for Mxnet scheduler nodes                         | `""`            |
| `scheduler.extraVolumes`                          | Optionally specify extra list of additional volumes for the Mxnet scheduler pod(s)                  | `[]`            |
| `scheduler.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Mxnet scheduler container(s)       | `[]`            |
| `scheduler.sidecars`                              | Add additional sidecar containers to the Mxnet scheduler pod(s)                                     | `[]`            |
| `scheduler.initContainers`                        | Add additional init containers to the Mxnet scheduler pod(s)                                        | `[]`            |
| `scheduler.updateStrategy.type`                   | Mxnet scheduler deployment strategy type.                                                           | `RollingUpdate` |
| `scheduler.priorityClassName`                     | Mxnet scheduler pods' priorityClassName                                                             | `""`            |
| `scheduler.schedulerName`                         | Name of the k8s scheduler (other than default)                                                      | `""`            |
| `scheduler.terminationGracePeriodSeconds`         | In seconds, time the given to the Mxnet scheduler pod needs to terminate gracefully                 | `""`            |
| `scheduler.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                      | `[]`            |
| `scheduler.resources.limits`                      | The resources limits for the Mxnet container                                                        | `{}`            |
| `scheduler.resources.requests`                    | The requested resources for the Mxnet container                                                     | `{}`            |
| `scheduler.startupProbe.enabled`                  | Enable startupProbe                                                                                 | `false`         |
| `scheduler.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                              | `5`             |
| `scheduler.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                     | `5`             |
| `scheduler.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                    | `15`            |
| `scheduler.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                  | `5`             |
| `scheduler.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                  | `1`             |
| `scheduler.livenessProbe.enabled`                 | Enable livenessProbe                                                                                | `true`          |
| `scheduler.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                             | `5`             |
| `scheduler.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                    | `5`             |
| `scheduler.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                   | `15`            |
| `scheduler.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                 | `5`             |
| `scheduler.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                 | `1`             |
| `scheduler.readinessProbe.enabled`                | Enable readinessProbe                                                                               | `true`          |
| `scheduler.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                            | `5`             |
| `scheduler.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                   | `5`             |
| `scheduler.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                  | `15`            |
| `scheduler.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                | `5`             |
| `scheduler.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                | `1`             |
| `scheduler.customStartupProbe`                    | Custom liveness probe for the Web component                                                         | `{}`            |
| `scheduler.customLivenessProbe`                   | Custom liveness probe for the Web component                                                         | `{}`            |
| `scheduler.customReadinessProbe`                  | Custom readiness probe for the Web component                                                        | `{}`            |
| `scheduler.service.type`                          | Kubernetes service type                                                                             | `ClusterIP`     |
| `scheduler.service.ports.mxnet`                   | Scheduler Service port                                                                              | `9092`          |
| `scheduler.service.nodePorts.mxnet`               | Node port for Mxnet scheduler                                                                       | `""`            |
| `scheduler.service.clusterIP`                     | Scheduler service Cluster IP                                                                        | `""`            |
| `scheduler.service.loadBalancerIP`                | Scheduler service Load Balancer IP                                                                  | `""`            |
| `scheduler.service.loadBalancerSourceRanges`      | Scheduler service Load Balancer sources                                                             | `[]`            |
| `scheduler.service.externalTrafficPolicy`         | Scheduler service external traffic policy                                                           | `Cluster`       |
| `scheduler.service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                      | `[]`            |
| `scheduler.service.annotations`                   | Additional custom annotations for Scheduler service                                                 | `{}`            |
| `scheduler.service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                | `None`          |
| `scheduler.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                         | `{}`            |


### Init containers parameters

| Name                                   | Description                                                                                                                       | Value                   |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `git.registry`                         | Git image registry                                                                                                                | `docker.io`             |
| `git.repository`                       | Git image repository                                                                                                              | `bitnami/git`           |
| `git.tag`                              | Git image tag (immutable tags are recommended)                                                                                    | `2.37.1-debian-11-r10`  |
| `git.digest`                           | Git image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                               | `""`                    |
| `git.pullPolicy`                       | Git image pull policy                                                                                                             | `IfNotPresent`          |
| `git.pullSecrets`                      | Specify docker-registry secret names as an array                                                                                  | `[]`                    |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory                                                       | `false`                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                                  | `docker.io`             |
| `volumePermissions.image.repository`   | Init container volume-permissions image repository                                                                                | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag (immutable tags are recommended)                                                      | `11-debian-11-r23`      |
| `volumePermissions.image.digest`       | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                               | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                                  | `[]`                    |
| `volumePermissions.resources.limits`   | The resources limits for the container                                                                                            | `{}`                    |
| `volumePermissions.resources.requests` | The requested resources for the container                                                                                         | `{}`                    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set mode=distributed \
  --set server.replicaCount=2 \
  --set worker.replicaCount=3 \
    bitnami/mxnet
```

The above command creates 6 pods for Apache MXNet (Incubating): one scheduler, two servers, and three workers.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/mxnet
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Loading your files

The Apache MXNet (Incubating) chart supports three different ways to load your files. In order of priority, they are:

  1. Existing config map
  2. Files under the `files` directory
  3. Cloning a git repository

This means that if you specify a config map with your files, it won't look for the `files/` directory nor the git repository.

In order to use use an existing config map you can set the `configMap=my-config-map` parameter.

To load your files from the `files/` directory you don't have to set any option. Just copy your files inside and don't specify a `ConfigMap`.

Finally, if you want to clone a git repository you can use the following parameters:

```console
cloneFilesFromGit.enabled=true
cloneFilesFromGit.repository=https://github.com/my-user/my-repo
cloneFilesFromGit.revision=master
```

In case you want to add a file that includes sensitive information, pass a secret object using the `existingSecret` parameter. All the files in the secret will be mounted in the `/secrets` folder.

### Distributed training example

We will use the gluon example from the [Apache MXNet (Incubating) official repository](https://github.com/apache/incubator-mxnet/tree/master/example/gluon). Launch it with the following values:

```console
mode=distributed
cloneFilesFromGit.enabled=true
cloneFilesFromGit.repository=https://github.com/apache/incubator-mxnet.git
cloneFilesFromGit.revision=master
entrypoint.file=image_classification.py
entrypoint.args="--dataset cifar10 --model vgg11 --epochs 1 --kvstore dist_sync"
entrypoint.workDir=/app/example/gluon/
```

Check the logs of the worker node:

```console
INFO:root:Starting new image-classification task:, Namespace(batch_norm=False, batch_size=32, builtin_profiler=0, data_dir='', dataset='cifar10', dtype='float32', epochs=1, gpus='', kvstore='dist_sync', log_interval=50, lr=0.1, lr_factor=0.1, lr_steps='30,60,90', mode=None, model='vgg11', momentum=0.9, num_workers=4, prefix='', profile=False, resume='', save_frequency=10, seed=123, start_epoch=0, use_pretrained=False, use_thumbnail=False, wd=0.0001)
INFO:root:downloaded http://data.mxnet.io/mxnet/data/cifar10.zip into data/cifar10.zip successfully
[10:05:40] src/io/iter_image_recordio_2.cc:172: ImageRecordIOParser2: data/cifar/train.rec, use 1 threads for decoding..
[10:05:45] src/io/iter_image_recordio_2.cc:172: ImageRecordIOParser2: data/cifar/test.rec, use 1 threads for decoding..
```

If you want to increase the verbosity, set the environment variable `PS_VERBOSE=1` or `PS_VERBOSE=2` using the `commonEnvVars` value.

```console
mode=distributed
cloneFilesFromGit.enabled=true
cloneFilesFromGit.repository=https://github.com/apache/incubator-mxnet.git
cloneFilesFromGit.revision=master
entrypoint.file=image_classification.py
entrypoint.args="--dataset cifar10 --model vgg11 --epochs 1 --kvstore dist_sync"
entrypoint.workDir=/app/example/gluon/
commonExtraEnvVars[0].name=PS_VERBOSE
commonExtraEnvVars[0].value=1
```

You will now see log entries in the scheduler and server nodes.

```console
[14:22:44] src/van.cc:290: Bind to role=scheduler, id=1, ip=10.32.0.11, port=9092, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=9 to node role=worker, ip=10.32.0.17, port=55423, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=11 to node role=worker, ip=10.32.0.16, port=60779, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=13 to node role=worker, ip=10.32.0.15, port=39817, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=15 to node role=worker, ip=10.32.0.14, port=48119, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=8 to node role=server, ip=10.32.0.13, port=56713, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=10 to node role=server, ip=10.32.0.12, port=57099, is_recovery=0
[14:22:53] src/van.cc:83: the scheduler is connected to 4 workers and 2 servers
[14:22:53] src/van.cc:183: Barrier count for 7 : 1
[14:22:53] src/van.cc:183: Barrier count for 7 : 2
[14:22:53] src/van.cc:183: Barrier count for 7 : 3
[14:22:53] src/van.cc:183: Barrier count for 7 : 4
...
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Apache MXNet (Incubating) (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
   containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
   containerPort: 1234
```

## Persistence

The [Bitnami Apache MXNet (Incubating)](https://github.com/bitnami/containers/tree/main/bitnami/mxnet) image can persist data. If enabled, the persisted path is `/bitnami/mxnet` by default.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.0.0

This major release renames several values in this chart and adds missing features, in order to be aligned with the rest of the assets in the Bitnami charts repository.

In addition, the chart structure has been refactored for a clearer distribution and configuration.

The following values have been affected:

- `service.*` has been renamed as `scheduler.service.*`. In addition, values `service.port` and `service.nodePort` have been renamed as `scheduler.service.ports.mxnet` and `scheduler.service.nodePorts.mxnet` respectively.
- `hostAliases` has been renamed as `{standalone/server/worker/scheduler}.hostAliases`.
- `commonExtraEnvVars` has been renamed as `extraEnvVars`.
- `podManagementPolicy` has been renamed as `worker.podManagementPolicy`.
- The following have been moved under `standalone`,`server`,`worker`, and `scheduler` sections:
  - `podAffinityPreset`.
  - `podAntiAffinityPreset`.
  - `nodeAffinityPreset`.
  - `affinity`.
  - `nodeSelector`.
  - `tolerations`.
  - `resources`.
  - `livenessProbe`.
  - `readinessProbe`.
  - `securityContext` (now renamed as `podSecurityContext` and `containerSecurityContext`).
- `scheduler.port`, previously used for both containerPort and service port configuration, is now configured using `scheduler.containerPorts.mxnet` and `scheduler.service.ports.mxnet` values.

### To 2.1.0

Some parameters disappeared in favor of new ones:

- `schedulerExtraEnvVars` and `schedulerPort` -> deprecated in favor of `scheduler.extraEnvVars` and `scheduler.port`, respectively.
- `serverExtraEnvVars` and `serverCount` -> deprecated in favor of `server.extraEnvVars` and `server.replicaCount`, respectively.
- `workerExtraEnvVars` and `workerCount` -> deprecated in favor of `worker.extraEnvVars` and `worker.replicaCount`, respectively.

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 2.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

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