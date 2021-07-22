# Elasticsearch

[Elasticsearch](https://www.elastic.co/products/elasticsearch) is a highly scalable open-source full-text search and analytics engine. It allows you to store, search, and analyze big volumes of data quickly and in near real time.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/elasticsearch
```

## Introduction

This chart bootstraps a [Elasticsearch](https://github.com/bitnami/bitnami-docker-elasticsearch) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/elasticsearch
```

These commands deploy Elasticsearch on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Remove also the chart using `--purge` option:

```console
$ helm delete --purge my-release
```

## Parameters

### Global parameters

| Name                       | Description                                                        | Value               |
| -------------------------- | ------------------------------------------------------------------ | ------------------- |
| `global.imageRegistry`     | Global Docker image registry                                       | `""`                |
| `global.imagePullSecrets`  | Global Docker registry secret names as an array                    | `[]`                |
| `global.storageClass`      | Global StorageClass for Persistent Volume(s)                       | `""`                |
| `global.coordinating.name` | Coordinating name to be used in the Kibana subchart (service name) | `coordinating-only` |
| `global.kibanaEnabled`     | Whether or not to enable Kibana                                    | `false`             |


### Common parameters

| Name               | Description                                                                                  | Value           |
| ------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`     | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride` | String to fully override common.names.fullname template                                      | `""`            |
| `clusterDomain`    | Kubernetes cluster domain                                                                    | `cluster.local` |


### Elasticsearch parameters

| Name                    | Description                                                                                                                                         | Value                   |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `image.registry`        | Elasticsearch image registry                                                                                                                        | `docker.io`             |
| `image.repository`      | Elasticsearch image repository                                                                                                                      | `bitnami/elasticsearch` |
| `image.tag`             | Elasticsearch image tag (immutable tags are recommended)                                                                                            | `7.13.4-debian-10-r0`   |
| `image.pullPolicy`      | Elasticsearch image pull policy                                                                                                                     | `IfNotPresent`          |
| `image.pullSecrets`     | Elasticsearch image pull secrets                                                                                                                    | `[]`                    |
| `image.debug`           | Enable image debug mode                                                                                                                             | `false`                 |
| `name`                  | Elasticsearch cluster name                                                                                                                          | `""`                    |
| `plugins`               | Comma, semi-colon or space separated list of plugins to install at initialization                                                                   | `""`                    |
| `snapshotRepoPath`      | File System snapshot repository path                                                                                                                | `""`                    |
| `config`                | Override elasticsearch configuration                                                                                                                | `{}`                    |
| `extraConfig`           | Append extra configuration to the elasticsearch node configuration                                                                                  | `{}`                    |
| `extraVolumes`          | A list of volumes to be added to the pod                                                                                                            | `[]`                    |
| `extraVolumeMounts`     | A list of volume mounts to be added to the pod                                                                                                      | `[]`                    |
| `initScripts`           | Dictionary of init scripts. Evaluated as a template.                                                                                                | `{}`                    |
| `initScriptsCM`         | ConfigMap with the init scripts. Evaluated as a template.                                                                                           | `""`                    |
| `initScriptsSecret`     | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template. | `""`                    |
| `extraEnvVars`          | Array containing extra env vars to be added to all pods (evaluated as a template)                                                                   | `[]`                    |
| `extraEnvVarsConfigMap` | ConfigMap containing extra env vars to be added to all pods (evaluated as a template)                                                               | `""`                    |
| `extraEnvVarsSecret`    | Secret containing extra env vars to be added to all pods (evaluated as a template)                                                                  | `""`                    |


### Master parameters

| Name                                        | Description                                                                                                                                                                                                                             | Value           |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `master.name`                               | Master-eligible node pod name                                                                                                                                                                                                           | `master`        |
| `master.fullnameOverride`                   | String to fully override elasticsearch.master.fullname template with a string                                                                                                                                                           | `""`            |
| `master.replicas`                           | Desired number of Elasticsearch master-eligible nodes. Consider using an odd number of master nodes to prevent "split brain" situation.  See: https://www.elastic.co/guide/en/elasticsearch/reference/7.x/modules-discovery-voting.html | `3`             |
| `master.updateStrategy.type`                | Update strategy for Master statefulset                                                                                                                                                                                                  | `RollingUpdate` |
| `master.hostAliases`                        | Add deployment host aliases                                                                                                                                                                                                             | `[]`            |
| `master.schedulerName`                      | Name of the k8s scheduler (other than default)                                                                                                                                                                                          | `""`            |
| `master.heapSize`                           | Master-eligible node heap size                                                                                                                                                                                                          | `128m`          |
| `master.podAnnotations`                     | Annotations for master-eligible pods.                                                                                                                                                                                                   | `{}`            |
| `master.podLabels`                          | Extra labels to add to Pod                                                                                                                                                                                                              | `{}`            |
| `master.securityContext.enabled`            | Enable security context for master-eligible pods                                                                                                                                                                                        | `true`          |
| `master.securityContext.fsGroup`            | Group ID for the container for master-eligible pods                                                                                                                                                                                     | `1001`          |
| `master.securityContext.runAsUser`          | User ID for the container for master-eligible pods                                                                                                                                                                                      | `1001`          |
| `master.podAffinityPreset`                  | Master-eligible Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`            |
| `master.podAntiAffinityPreset`              | Master-eligible Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `""`            |
| `master.nodeAffinityPreset.type`            | Master-eligible Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`            |
| `master.nodeAffinityPreset.key`             | Master-eligible Node label key to match Ignored if `affinity` is set.                                                                                                                                                                   | `""`            |
| `master.nodeAffinityPreset.values`          | Master-eligible Node label values to match. Ignored if `affinity` is set.                                                                                                                                                               | `[]`            |
| `master.affinity`                           | Master-eligible Affinity for pod assignment                                                                                                                                                                                             | `{}`            |
| `master.nodeSelector`                       | Master-eligible Node labels for pod assignment                                                                                                                                                                                          | `{}`            |
| `master.tolerations`                        | Master-eligible Tolerations for pod assignment                                                                                                                                                                                          | `[]`            |
| `master.resources.limits`                   | The resources limits for the container                                                                                                                                                                                                  | `{}`            |
| `master.resources.requests`                 | The requested resources for the container                                                                                                                                                                                               | `{}`            |
| `master.startupProbe.enabled`               | Enable/disable the startup probe (master nodes pod)                                                                                                                                                                                     | `false`         |
| `master.startupProbe.initialDelaySeconds`   | Delay before startup probe is initiated (master nodes pod)                                                                                                                                                                              | `90`            |
| `master.startupProbe.periodSeconds`         | How often to perform the probe (master nodes pod)                                                                                                                                                                                       | `10`            |
| `master.startupProbe.timeoutSeconds`        | When the probe times out (master nodes pod)                                                                                                                                                                                             | `5`             |
| `master.startupProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed (master nodes pod)                                                                                                                          | `1`             |
| `master.startupProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                               | `5`             |
| `master.livenessProbe.enabled`              | Enable/disable the liveness probe (master-eligible nodes pod)                                                                                                                                                                           | `true`          |
| `master.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (master-eligible nodes pod)                                                                                                                                                                    | `90`            |
| `master.livenessProbe.periodSeconds`        | How often to perform the probe (master-eligible nodes pod)                                                                                                                                                                              | `10`            |
| `master.livenessProbe.timeoutSeconds`       | When the probe times out (master-eligible nodes pod)                                                                                                                                                                                    | `5`             |
| `master.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                                                                                                 | `1`             |
| `master.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                               | `5`             |
| `master.readinessProbe.enabled`             | Enable/disable the readiness probe (master-eligible nodes pod)                                                                                                                                                                          | `true`          |
| `master.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated (master-eligible nodes pod)                                                                                                                                                                   | `90`            |
| `master.readinessProbe.periodSeconds`       | How often to perform the probe (master-eligible nodes pod)                                                                                                                                                                              | `10`            |
| `master.readinessProbe.timeoutSeconds`      | When the probe times out (master-eligible nodes pod)                                                                                                                                                                                    | `5`             |
| `master.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                                                                                                 | `1`             |
| `master.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                                                                                               | `5`             |
| `master.customStartupProbe`                 | Override default startup probe                                                                                                                                                                                                          | `{}`            |
| `master.customLivenessProbe`                | Override default liveness probe                                                                                                                                                                                                         | `{}`            |
| `master.customReadinessProbe`               | Override default readiness probe                                                                                                                                                                                                        | `{}`            |
| `master.initContainers`                     | Extra init containers to add to the Elasticsearch master-eligible pod(s)                                                                                                                                                                | `[]`            |
| `master.sidecars`                           | Extra sidecar containers to add to the Elasticsearch master-eligible pod(s)                                                                                                                                                             | `[]`            |
| `master.persistence.enabled`                | Enable persistence using a `PersistentVolumeClaim`                                                                                                                                                                                      | `true`          |
| `master.persistence.storageClass`           | Persistent Volume Storage Class                                                                                                                                                                                                         | `""`            |
| `master.persistence.existingClaim`          | Existing Persistent Volume Claim                                                                                                                                                                                                        | `""`            |
| `master.persistence.existingVolume`         | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `master.persistence.selector` is set.                                                                                      | `""`            |
| `master.persistence.selector`               | Configure custom selector for existing Persistent Volume. Overwrites `master.persistence.existingVolume`                                                                                                                                | `{}`            |
| `master.persistence.annotations`            | Persistent Volume Claim annotations                                                                                                                                                                                                     | `{}`            |
| `master.persistence.accessModes`            | Persistent Volume Access Modes                                                                                                                                                                                                          | `[]`            |
| `master.persistence.size`                   | Persistent Volume Size                                                                                                                                                                                                                  | `8Gi`           |
| `master.service.type`                       | Kubernetes Service type (master-eligible nodes)                                                                                                                                                                                         | `ClusterIP`     |
| `master.service.port`                       | Kubernetes Service port for Elasticsearch transport port (master-eligible nodes)                                                                                                                                                        | `9300`          |
| `master.service.nodePort`                   | Kubernetes Service nodePort (master-eligible nodes)                                                                                                                                                                                     | `""`            |
| `master.service.annotations`                | Annotations for master-eligible nodes service                                                                                                                                                                                           | `{}`            |
| `master.service.loadBalancerIP`             | loadBalancerIP if master-eligible nodes service type is `LoadBalancer`                                                                                                                                                                  | `""`            |
| `master.serviceAccount.create`              | Enable creation of ServiceAccount for the master node                                                                                                                                                                                   | `false`         |
| `master.serviceAccount.name`                | Name of the created serviceAccount                                                                                                                                                                                                      | `""`            |
| `master.autoscaling.enabled`                | Enable autoscaling for master replicas                                                                                                                                                                                                  | `false`         |
| `master.autoscaling.minReplicas`            | Minimum number of master replicas                                                                                                                                                                                                       | `2`             |
| `master.autoscaling.maxReplicas`            | Maximum number of master replicas                                                                                                                                                                                                       | `11`            |
| `master.autoscaling.targetCPU`              | Target CPU utilization percentage for master replica autoscaling                                                                                                                                                                        | `""`            |
| `master.autoscaling.targetMemory`           | Target Memory utilization percentage for master replica autoscaling                                                                                                                                                                     | `""`            |


### Coordinating parameters

| Name                                              | Description                                                                                                               | Value           |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `coordinating.fullnameOverride`                   | String to fully override elasticsearch.coordinating.fullname template with a string                                       | `""`            |
| `coordinating.replicas`                           | Desired number of Elasticsearch coordinating-only nodes                                                                   | `2`             |
| `coordinating.hostAliases`                        | Add deployment host aliases                                                                                               | `[]`            |
| `coordinating.schedulerName`                      | Name of the k8s scheduler (other than default)                                                                            | `""`            |
| `coordinating.updateStrategy.type`                | Update strategy for Coordinating Deployment                                                                               | `RollingUpdate` |
| `coordinating.heapSize`                           | Coordinating-only node heap size                                                                                          | `128m`          |
| `coordinating.podAnnotations`                     | Annotations for coordinating pods.                                                                                        | `{}`            |
| `coordinating.podLabels`                          | Extra labels to add to Pod                                                                                                | `{}`            |
| `coordinating.securityContext.enabled`            | Enable security context for coordinating-only pods                                                                        | `true`          |
| `coordinating.securityContext.fsGroup`            | Group ID for the container for coordinating-only pods                                                                     | `1001`          |
| `coordinating.securityContext.runAsUser`          | User ID for the container for coordinating-only pods                                                                      | `1001`          |
| `coordinating.podAffinityPreset`                  | Coordinating Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                          | `""`            |
| `coordinating.podAntiAffinityPreset`              | Coordinating Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `""`            |
| `coordinating.nodeAffinityPreset.type`            | Coordinating Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                    | `""`            |
| `coordinating.nodeAffinityPreset.key`             | Coordinating Node label key to match Ignored if `affinity` is set.                                                        | `""`            |
| `coordinating.nodeAffinityPreset.values`          | Coordinating Node label values to match. Ignored if `affinity` is set.                                                    | `[]`            |
| `coordinating.affinity`                           | Coordinating Affinity for pod assignment                                                                                  | `{}`            |
| `coordinating.nodeSelector`                       | Coordinating Node labels for pod assignment                                                                               | `{}`            |
| `coordinating.tolerations`                        | Coordinating Tolerations for pod assignment                                                                               | `[]`            |
| `coordinating.resources.limits`                   | The resources limits for the container                                                                                    | `{}`            |
| `coordinating.resources.requests`                 | The requested resources for the container                                                                                 | `{}`            |
| `coordinating.startupProbe.enabled`               | Enable/disable the startup probe (coordinating nodes pod)                                                                 | `false`         |
| `coordinating.startupProbe.initialDelaySeconds`   | Delay before startup probe is initiated (coordinating nodes pod)                                                          | `90`            |
| `coordinating.startupProbe.periodSeconds`         | How often to perform the probe (coordinating nodes pod)                                                                   | `10`            |
| `coordinating.startupProbe.timeoutSeconds`        | When the probe times out (coordinating nodes pod)                                                                         | `5`             |
| `coordinating.startupProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded                                 | `5`             |
| `coordinating.startupProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating nodes pod)      | `1`             |
| `coordinating.livenessProbe.enabled`              | Enable/disable the liveness probe (coordinating-only nodes pod)                                                           | `true`          |
| `coordinating.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (coordinating-only nodes pod)                                                    | `90`            |
| `coordinating.livenessProbe.periodSeconds`        | How often to perform the probe (coordinating-only nodes pod)                                                              | `10`            |
| `coordinating.livenessProbe.timeoutSeconds`       | When the probe times out (coordinating-only nodes pod)                                                                    | `5`             |
| `coordinating.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                 | `5`             |
| `coordinating.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod) | `1`             |
| `coordinating.readinessProbe.enabled`             | Enable/disable the readiness probe (coordinating-only nodes pod)                                                          | `true`          |
| `coordinating.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated (coordinating-only nodes pod)                                                   | `90`            |
| `coordinating.readinessProbe.periodSeconds`       | How often to perform the probe (coordinating-only nodes pod)                                                              | `10`            |
| `coordinating.readinessProbe.timeoutSeconds`      | When the probe times out (coordinating-only nodes pod)                                                                    | `5`             |
| `coordinating.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                 | `5`             |
| `coordinating.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod) | `1`             |
| `coordinating.customStartupProbe`                 | Override default startup probe                                                                                            | `{}`            |
| `coordinating.customLivenessProbe`                | Override default liveness probe                                                                                           | `{}`            |
| `coordinating.customReadinessProbe`               | Override default readiness probe                                                                                          | `{}`            |
| `coordinating.initContainers`                     | Extra init containers to add to the Elasticsearch coordinating-only pod(s)                                                | `[]`            |
| `coordinating.sidecars`                           | Extra sidecar containers to add to the Elasticsearch coordinating-only pod(s)                                             | `[]`            |
| `coordinating.service.type`                       | Kubernetes Service type (coordinating-only nodes)                                                                         | `ClusterIP`     |
| `coordinating.service.port`                       | Kubernetes Service port for REST API (coordinating-only nodes)                                                            | `9200`          |
| `coordinating.service.nodePort`                   | Kubernetes Service nodePort (coordinating-only nodes)                                                                     | `""`            |
| `coordinating.service.annotations`                | Annotations for coordinating-only nodes service                                                                           | `{}`            |
| `coordinating.service.loadBalancerIP`             | loadBalancerIP if coordinating-only nodes service type is `LoadBalancer`                                                  | `""`            |
| `coordinating.serviceAccount.create`              | Enable creation of ServiceAccount for the coordinating-only node                                                          | `false`         |
| `coordinating.serviceAccount.name`                | Name of the created serviceAccount                                                                                        | `""`            |
| `coordinating.autoscaling.enabled`                | Enable autoscaling for coordinating replicas                                                                              | `false`         |
| `coordinating.autoscaling.minReplicas`            | Minimum number of coordinating replicas                                                                                   | `2`             |
| `coordinating.autoscaling.maxReplicas`            | Maximum number of coordinating replicas                                                                                   | `11`            |
| `coordinating.autoscaling.targetCPU`              | Target CPU utilization percentage for coordinating replica autoscaling                                                    | `""`            |
| `coordinating.autoscaling.targetMemory`           | Target Memory utilization percentage for coordinating replica autoscaling                                                 | `""`            |


### Data parameters

| Name                                         | Description                                                                                                                                       | Value           |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `data.name`                                  | Data node pod name                                                                                                                                | `data`          |
| `data.fullnameOverride`                      | String to fully override elasticsearch.data.fullname template with a string                                                                       | `""`            |
| `data.replicas`                              | Desired number of Elasticsearch data nodes                                                                                                        | `2`             |
| `data.hostAliases`                           | Add deployment host aliases                                                                                                                       | `[]`            |
| `data.schedulerName`                         | Name of the k8s scheduler (other than default)                                                                                                    | `""`            |
| `data.updateStrategy.type`                   | Update strategy for Data statefulset                                                                                                              | `RollingUpdate` |
| `data.updateStrategy.rollingUpdatePartition` | Partition update strategy for Data statefulset                                                                                                    | `""`            |
| `data.heapSize`                              | Data node heap size                                                                                                                               | `1024m`         |
| `data.podAnnotations`                        | Annotations for data pods.                                                                                                                        | `{}`            |
| `data.podLabels`                             | Extra labels to add to Pod                                                                                                                        | `{}`            |
| `data.securityContext.enabled`               | Enable security context for data pods                                                                                                             | `true`          |
| `data.securityContext.fsGroup`               | Group ID for the container for data pods                                                                                                          | `1001`          |
| `data.securityContext.runAsUser`             | User ID for the container for data pods                                                                                                           | `1001`          |
| `data.podAffinityPreset`                     | Data Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                          | `""`            |
| `data.podAntiAffinityPreset`                 | Data Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                     | `""`            |
| `data.nodeAffinityPreset.type`               | Data Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                    | `""`            |
| `data.nodeAffinityPreset.key`                | Data Node label key to match Ignored if `affinity` is set.                                                                                        | `""`            |
| `data.nodeAffinityPreset.values`             | Data Node label values to match. Ignored if `affinity` is set.                                                                                    | `[]`            |
| `data.affinity`                              | Data Affinity for pod assignment                                                                                                                  | `{}`            |
| `data.nodeSelector`                          | Data Node labels for pod assignment                                                                                                               | `{}`            |
| `data.tolerations`                           | Data Tolerations for pod assignment                                                                                                               | `[]`            |
| `data.resources.limits`                      | The resources limits for the container                                                                                                            | `{}`            |
| `data.resources.requests`                    | The requested resources for the container                                                                                                         | `{}`            |
| `data.startupProbe.enabled`                  | Enable/disable the startup probe (data nodes pod)                                                                                                 | `false`         |
| `data.startupProbe.initialDelaySeconds`      | Delay before startup probe is initiated (data nodes pod)                                                                                          | `90`            |
| `data.startupProbe.periodSeconds`            | How often to perform the probe (data nodes pod)                                                                                                   | `10`            |
| `data.startupProbe.timeoutSeconds`           | When the probe times out (data nodes pod)                                                                                                         | `5`             |
| `data.startupProbe.failureThreshold`         | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                         | `5`             |
| `data.startupProbe.successThreshold`         | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                      | `1`             |
| `data.livenessProbe.enabled`                 | Enable/disable the liveness probe (data nodes pod)                                                                                                | `true`          |
| `data.livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated (data nodes pod)                                                                                         | `90`            |
| `data.livenessProbe.periodSeconds`           | How often to perform the probe (data nodes pod)                                                                                                   | `10`            |
| `data.livenessProbe.timeoutSeconds`          | When the probe times out (data nodes pod)                                                                                                         | `5`             |
| `data.livenessProbe.failureThreshold`        | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                         | `5`             |
| `data.livenessProbe.successThreshold`        | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                      | `1`             |
| `data.readinessProbe.enabled`                | Enable/disable the readiness probe (data nodes pod)                                                                                               | `true`          |
| `data.readinessProbe.initialDelaySeconds`    | Delay before readiness probe is initiated (data nodes pod)                                                                                        | `90`            |
| `data.readinessProbe.periodSeconds`          | How often to perform the probe (data nodes pod)                                                                                                   | `10`            |
| `data.readinessProbe.timeoutSeconds`         | When the probe times out (data nodes pod)                                                                                                         | `5`             |
| `data.readinessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                         | `5`             |
| `data.readinessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                      | `1`             |
| `data.customStartupProbe`                    | Override default startup probe                                                                                                                    | `{}`            |
| `data.customLivenessProbe`                   | Override default liveness probe                                                                                                                   | `{}`            |
| `data.customReadinessProbe`                  | Override default readiness probe                                                                                                                  | `{}`            |
| `data.initContainers`                        | Extra init containers to add to the Elasticsearch data pod(s)                                                                                     | `[]`            |
| `data.sidecars`                              | Extra sidecar containers to add to the Elasticsearch data pod(s)                                                                                  | `[]`            |
| `data.persistence.enabled`                   | Enable persistence using a `PersistentVolumeClaim`                                                                                                | `true`          |
| `data.persistence.storageClass`              | Persistent Volume Storage Class                                                                                                                   | `""`            |
| `data.persistence.existingClaim`             | Existing Persistent Volume Claim                                                                                                                  | `""`            |
| `data.persistence.existingVolume`            | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `data.persistence.selector` ist set. | `""`            |
| `data.persistence.selector`                  | Configure custom selector for existing Persistent Volume. Overwrites `data.persistence.existingVolume`                                            | `{}`            |
| `data.persistence.annotations`               | Persistent Volume Claim annotations                                                                                                               | `{}`            |
| `data.persistence.accessModes`               | Persistent Volume Access Modes                                                                                                                    | `[]`            |
| `data.persistence.size`                      | Persistent Volume Size                                                                                                                            | `8Gi`           |
| `data.serviceAccount.create`                 | Enable creation of ServiceAccount for the data node                                                                                               | `false`         |
| `data.serviceAccount.name`                   | Name of the created serviceAccount                                                                                                                | `""`            |
| `data.autoscaling.enabled`                   | Enable autoscaling for data replicas                                                                                                              | `false`         |
| `data.autoscaling.minReplicas`               | Minimum number of data replicas                                                                                                                   | `2`             |
| `data.autoscaling.maxReplicas`               | Maximum number of data replicas                                                                                                                   | `11`            |
| `data.autoscaling.targetCPU`                 | Target CPU utilization percentage for data replica autoscaling                                                                                    | `""`            |
| `data.autoscaling.targetMemory`              | Target Memory utilization percentage for data replica autoscaling                                                                                 | `""`            |


### Ingest parameters

| Name                                        | Description                                                                                                    | Value       |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ----------- |
| `ingest.enabled`                            | Enable ingest nodes                                                                                            | `false`     |
| `ingest.name`                               | Ingest node pod name                                                                                           | `ingest`    |
| `ingest.fullnameOverride`                   | String to fully override elasticsearch.ingest.fullname template with a string                                  | `""`        |
| `ingest.replicas`                           | Desired number of Elasticsearch ingest nodes                                                                   | `2`         |
| `ingest.heapSize`                           | Ingest node heap size                                                                                          | `128m`      |
| `ingest.podAnnotations`                     | Annotations for ingest pods.                                                                                   | `{}`        |
| `ingest.hostAliases`                        | Add deployment host aliases                                                                                    | `[]`        |
| `ingest.schedulerName`                      | Name of the k8s scheduler (other than default)                                                                 | `""`        |
| `ingest.podLabels`                          | Extra labels to add to Pod                                                                                     | `{}`        |
| `ingest.securityContext.enabled`            | Enable security context for ingest pods                                                                        | `true`      |
| `ingest.securityContext.fsGroup`            | Group ID for the container for ingest pods                                                                     | `1001`      |
| `ingest.securityContext.runAsUser`          | User ID for the container for ingest pods                                                                      | `1001`      |
| `ingest.podAffinityPreset`                  | Ingest Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `""`        |
| `ingest.podAntiAffinityPreset`              | Ingest Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                | `""`        |
| `ingest.nodeAffinityPreset.type`            | Ingest Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`               | `""`        |
| `ingest.nodeAffinityPreset.key`             | Ingest Node label key to match Ignored if `affinity` is set.                                                   | `""`        |
| `ingest.nodeAffinityPreset.values`          | Ingest Node label values to match. Ignored if `affinity` is set.                                               | `[]`        |
| `ingest.affinity`                           | Ingest Affinity for pod assignment                                                                             | `{}`        |
| `ingest.nodeSelector`                       | Ingest Node labels for pod assignment                                                                          | `{}`        |
| `ingest.tolerations`                        | Ingest Tolerations for pod assignment                                                                          | `[]`        |
| `ingest.resources.limits`                   | The resources limits for the container                                                                         | `{}`        |
| `ingest.resources.requests`                 | The requested resources for the container                                                                      | `{}`        |
| `ingest.startupProbe.enabled`               | Enable/disable the startup probe (ingest nodes pod)                                                            | `false`     |
| `ingest.startupProbe.initialDelaySeconds`   | Delay before startup probe is initiated (ingest nodes pod)                                                     | `90`        |
| `ingest.startupProbe.periodSeconds`         | How often to perform the probe (ingest nodes pod)                                                              | `10`        |
| `ingest.startupProbe.timeoutSeconds`        | When the probe times out (ingest nodes pod)                                                                    | `5`         |
| `ingest.startupProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded                      | `5`         |
| `ingest.startupProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed (ingest nodes pod) | `1`         |
| `ingest.livenessProbe.enabled`              | Enable/disable the liveness probe (ingest nodes pod)                                                           | `true`      |
| `ingest.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (ingest nodes pod)                                                    | `90`        |
| `ingest.livenessProbe.periodSeconds`        | How often to perform the probe (ingest nodes pod)                                                              | `10`        |
| `ingest.livenessProbe.timeoutSeconds`       | When the probe times out (ingest nodes pod)                                                                    | `5`         |
| `ingest.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded                      | `5`         |
| `ingest.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (ingest nodes pod) | `1`         |
| `ingest.readinessProbe.enabled`             | Enable/disable the readiness probe (ingest nodes pod)                                                          | `true`      |
| `ingest.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated (ingest nodes pod)                                                   | `90`        |
| `ingest.readinessProbe.periodSeconds`       | How often to perform the probe (ingest nodes pod)                                                              | `10`        |
| `ingest.readinessProbe.timeoutSeconds`      | When the probe times out (ingest nodes pod)                                                                    | `5`         |
| `ingest.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded                      | `5`         |
| `ingest.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (ingest nodes pod) | `1`         |
| `ingest.customStartupProbe`                 | Override default startup probe                                                                                 | `{}`        |
| `ingest.customLivenessProbe`                | Override default liveness probe                                                                                | `{}`        |
| `ingest.customReadinessProbe`               | Override default readiness probe                                                                               | `{}`        |
| `ingest.initContainers`                     | Extra init containers to add to the Elasticsearch ingest pod(s)                                                | `[]`        |
| `ingest.sidecars`                           | Extra sidecar containers to add to the Elasticsearch ingest pod(s)                                             | `[]`        |
| `ingest.service.type`                       | Kubernetes Service type (ingest nodes)                                                                         | `ClusterIP` |
| `ingest.service.port`                       | Kubernetes Service port Elasticsearch transport port (ingest nodes)                                            | `9300`      |
| `ingest.service.nodePort`                   | Kubernetes Service nodePort (ingest nodes)                                                                     | `""`        |
| `ingest.service.annotations`                | Annotations for ingest nodes service                                                                           | `{}`        |
| `ingest.service.loadBalancerIP`             | loadBalancerIP if ingest nodes service type is `LoadBalancer`                                                  | `""`        |


### Curator parameters

| Name                                         | Description                                                                                       | Value                           |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------- |
| `curator.enabled`                            | Enable Elasticsearch Curator cron job                                                             | `false`                         |
| `curator.name`                               | Elasticsearch Curator pod name                                                                    | `curator`                       |
| `curator.image.registry`                     | Elasticsearch Curator image registry                                                              | `docker.io`                     |
| `curator.image.repository`                   | Elasticsearch Curator image repository                                                            | `bitnami/elasticsearch-curator` |
| `curator.image.tag`                          | Elasticsearch Curator image tag                                                                   | `5.8.4-debian-10-r69`           |
| `curator.image.pullPolicy`                   | Elasticsearch Curator image pull policy                                                           | `IfNotPresent`                  |
| `curator.image.pullSecrets`                  | Elasticsearch Curator image pull secrets                                                          | `[]`                            |
| `curator.cronjob.schedule`                   | Schedule for the CronJob                                                                          | `0 1 * * *`                     |
| `curator.cronjob.annotations`                | Annotations to add to the cronjob                                                                 | `{}`                            |
| `curator.cronjob.concurrencyPolicy`          | `Allow,Forbid,Replace` concurrent jobs                                                            | `""`                            |
| `curator.cronjob.failedJobsHistoryLimit`     | Specify the number of failed Jobs to keep                                                         | `""`                            |
| `curator.cronjob.successfulJobsHistoryLimit` | Specify the number of completed Jobs to keep                                                      | `""`                            |
| `curator.cronjob.jobRestartPolicy`           | Control the Job restartPolicy                                                                     | `Never`                         |
| `curator.schedulerName`                      | Name of the k8s scheduler (other than default)                                                    | `""`                            |
| `curator.podAnnotations`                     | Annotations to add to the pod                                                                     | `{}`                            |
| `curator.podLabels`                          | Extra labels to add to Pod                                                                        | `{}`                            |
| `curator.podAffinityPreset`                  | Curator Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                            |
| `curator.podAntiAffinityPreset`              | Curator Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`                            |
| `curator.nodeAffinityPreset.type`            | Curator Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                            |
| `curator.nodeAffinityPreset.key`             | Curator Node label key to match Ignored if `affinity` is set.                                     | `""`                            |
| `curator.nodeAffinityPreset.values`          | Curator Node label values to match. Ignored if `affinity` is set.                                 | `[]`                            |
| `curator.initContainers`                     | Extra init containers to add to the Elasticsearch coordinating-only pod(s)                        | `[]`                            |
| `curator.sidecars`                           | Extra sidecar containers to add to the Elasticsearch ingest pod(s)                                | `[]`                            |
| `curator.affinity`                           | Curator Affinity for pod assignment                                                               | `{}`                            |
| `curator.nodeSelector`                       | Curator Node labels for pod assignment                                                            | `{}`                            |
| `curator.tolerations`                        | Curator Tolerations for pod assignment                                                            | `[]`                            |
| `curator.rbac.enabled`                       | Enable RBAC resources                                                                             | `false`                         |
| `curator.serviceAccount.create`              | Create a default serviceaccount for elasticsearch curator                                         | `true`                          |
| `curator.serviceAccount.name`                | Name for elasticsearch curator serviceaccount                                                     | `""`                            |
| `curator.psp.create`                         | Create pod security policy resources                                                              | `false`                         |
| `curator.hooks`                              | Whether to run job on selected hooks                                                              | `{}`                            |
| `curator.dryrun`                             | Run Curator in dry-run mode                                                                       | `false`                         |
| `curator.command`                            | Command to execute                                                                                | `[]`                            |
| `curator.env`                                | Environment variables to add to the cronjob container                                             | `{}`                            |
| `curator.configMaps.action_file_yml`         | Contents of the Curator action_file.yml                                                           | `{}`                            |
| `curator.configMaps.config_yml`              | Contents of the Curator config.yml (overrides config)                                             | `{}`                            |
| `curator.resources.limits`                   | The resources limits for the container                                                            | `{}`                            |
| `curator.resources.requests`                 | The requested resources for the container                                                         | `{}`                            |
| `curator.priorityClassName`                  | Priority Class Name                                                                               | `""`                            |
| `curator.extraVolumes`                       | Extra volumes                                                                                     | `[]`                            |
| `curator.extraVolumeMounts`                  | Mount extra volume(s)                                                                             | `[]`                            |
| `curator.extraInitContainers`                | DEPRECATED. Use `curator.initContainers` instead. Init containers to add to the cronjob container | `[]`                            |


### Metrics parameters

| Name                                         | Description                                                                                               | Value                            |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `metrics.enabled`                            | Enable prometheus exporter                                                                                | `false`                          |
| `metrics.name`                               | Metrics pod name                                                                                          | `metrics`                        |
| `metrics.image.registry`                     | Metrics exporter image registry                                                                           | `docker.io`                      |
| `metrics.image.repository`                   | Metrics exporter image repository                                                                         | `bitnami/elasticsearch-exporter` |
| `metrics.image.tag`                          | Metrics exporter image tag                                                                                | `1.2.1-debian-10-r19`            |
| `metrics.image.pullPolicy`                   | Metrics exporter image pull policy                                                                        | `IfNotPresent`                   |
| `metrics.image.pullSecrets`                  | Metrics exporter image pull secrets                                                                       | `[]`                             |
| `metrics.extraArgs`                          | Extra arguments to add to the default exporter command                                                    | `[]`                             |
| `metrics.hostAliases`                        | Add deployment host aliases                                                                               | `[]`                             |
| `metrics.schedulerName`                      | Name of the k8s scheduler (other than default)                                                            | `""`                             |
| `metrics.service.type`                       | Metrics exporter endpoint service type                                                                    | `ClusterIP`                      |
| `metrics.service.annotations`                | Provide any additional annotations which may be required.                                                 | `{}`                             |
| `metrics.podAffinityPreset`                  | Metrics Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`               | `""`                             |
| `metrics.podAntiAffinityPreset`              | Metrics Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`          | `""`                             |
| `metrics.nodeAffinityPreset.type`            | Metrics Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`         | `""`                             |
| `metrics.nodeAffinityPreset.key`             | Metrics Node label key to match Ignored if `affinity` is set.                                             | `""`                             |
| `metrics.nodeAffinityPreset.values`          | Metrics Node label values to match. Ignored if `affinity` is set.                                         | `[]`                             |
| `metrics.affinity`                           | Metrics Affinity for pod assignment                                                                       | `{}`                             |
| `metrics.nodeSelector`                       | Metrics Node labels for pod assignment                                                                    | `{}`                             |
| `metrics.tolerations`                        | Metrics Tolerations for pod assignment                                                                    | `[]`                             |
| `metrics.resources.limits`                   | The resources limits for the container                                                                    | `{}`                             |
| `metrics.resources.requests`                 | The requested resources for the container                                                                 | `{}`                             |
| `metrics.livenessProbe.enabled`              | Enable/disable the liveness probe (metrics pod)                                                           | `true`                           |
| `metrics.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (metrics pod)                                                    | `60`                             |
| `metrics.livenessProbe.periodSeconds`        | How often to perform the probe (metrics pod)                                                              | `10`                             |
| `metrics.livenessProbe.timeoutSeconds`       | When the probe times out (metrics pod)                                                                    | `5`                              |
| `metrics.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded                 | `5`                              |
| `metrics.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (metrics pod) | `1`                              |
| `metrics.readinessProbe.enabled`             | Enable/disable the readiness probe (metrics pod)                                                          | `true`                           |
| `metrics.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated (metrics pod)                                                   | `5`                              |
| `metrics.readinessProbe.periodSeconds`       | How often to perform the probe (metrics pod)                                                              | `10`                             |
| `metrics.readinessProbe.timeoutSeconds`      | When the probe times out (metrics pod)                                                                    | `1`                              |
| `metrics.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded                 | `5`                              |
| `metrics.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (metrics pod) | `1`                              |
| `metrics.podAnnotations`                     | Metrics exporter pod Annotation and Labels                                                                | `{}`                             |
| `metrics.podLabels`                          | Extra labels to add to Pod                                                                                | `{}`                             |
| `metrics.serviceMonitor.enabled`             | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)    | `false`                          |
| `metrics.serviceMonitor.namespace`           | Namespace in which Prometheus is running                                                                  | `""`                             |
| `metrics.serviceMonitor.interval`            | Interval at which metrics should be scraped.                                                              | `""`                             |
| `metrics.serviceMonitor.scrapeTimeout`       | Timeout after which the scrape is ended                                                                   | `""`                             |
| `metrics.serviceMonitor.selector`            | Prometheus instance selector labels                                                                       | `{}`                             |


### Sysctl Image parameters

| Name                             | Description                                 | Value                   |
| -------------------------------- | ------------------------------------------- | ----------------------- |
| `sysctlImage.enabled`            | Enable kernel settings modifier image       | `true`                  |
| `sysctlImage.registry`           | Kernel settings modifier image registry     | `docker.io`             |
| `sysctlImage.repository`         | Kernel settings modifier image repository   | `bitnami/bitnami-shell` |
| `sysctlImage.tag`                | Kernel settings modifier image tag          | `10-debian-10-r138`     |
| `sysctlImage.pullPolicy`         | Kernel settings modifier image pull policy  | `Always`                |
| `sysctlImage.pullSecrets`        | Kernel settings modifier image pull secrets | `[]`                    |
| `sysctlImage.resources.limits`   | The resources limits for the container      | `{}`                    |
| `sysctlImage.resources.requests` | The requested resources for the container   | `{}`                    |


### VolumePermissions parameters

| Name                                   | Description                                                                                                                                               | Value                   |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                                                          | `docker.io`             |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                                                                                               | `10-debian-10-r138`     |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                                                       | `Always`                |
| `volumePermissions.image.pullSecrets`  | Init container volume-permissions image pull secrets                                                                                                      | `[]`                    |
| `volumePermissions.resources.limits`   | The resources limits for the container                                                                                                                    | `{}`                    |
| `volumePermissions.resources.requests` | The requested resources for the container                                                                                                                 | `{}`                    |
| `diagnosticMode.enabled`               | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                                   | `false`                 |
| `diagnosticMode.command`               | Command to override all containers in the deployment                                                                                                      | `[]`                    |
| `diagnosticMode.args`                  | Args to override all containers in the deployment                                                                                                         | `[]`                    |


### Kibana Parameters

| Name                         | Description                                                               | Value  |
| ---------------------------- | ------------------------------------------------------------------------- | ------ |
| `kibana.elasticsearch.hosts` | Array containing hostnames for the ES instances. Used to generate the URL | `[]`   |
| `kibana.elasticsearch.port`  | Port to connect Kibana and ES instance. Used to generate the URL          | `9200` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set name=my-elastic,client.service.port=8080 \
  bitnami/elasticsearch
```

The above command sets the Elasticsearch cluster name to `my-elastic` and REST port number to `8080`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/elasticsearch
```

> **Tip**: You can use the default [values.yaml](values.yaml).

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change ElasticSearch version

To modify the ElasticSearch version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/elasticsearch/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Default kernel settings

Currently, Elasticsearch requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the ES containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

This chart uses a **privileged** initContainer to change those settings in the Kernel by running: `sysctl -w vm.max_map_count=262144 && sysctl -w fs.file-max=65536`.
You can disable the initContainer using the `sysctlImage.enabled=false` parameter.

### Enable bundled Kibana

This Elasticsearch chart contains Kibana as subchart, you can enable it just setting the `global.kibanaEnabled=true` parameter.
To see the notes with some operational instructions from the Kibana chart, please use the `--render-subchart-notes` as part of your `helm install` command, in this way you can see the Kibana and ES notes in your terminal.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_VERSION
    value: 7.0
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsConfigMap` or the `extraEnvVarsSecret` values.

### Using custom init scripts

For advanced operations, the Bitnami Elasticsearch charts allows using custom init scripts that will be mounted inside `/docker-entrypoint.init-db`. You can include the file directly in your `values.yaml` with `initScripts`, or use a ConfigMap or a Secret (in case of sensitive data) for mounting these extra scripts. In this case you use the `initScriptsCM` and `initScriptsSecret` values.

```console
initScriptsCM=special-scripts
initScriptsSecret=special-scripts-sensitive
```

### Snapshot and restore operations

As it's described in the [official documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-filesystem-repository), it's necessary to register a snapshot repository before you can perform snapshot and restore operations.

This chart allows you to configure Elasticsearch to use a shared file system to store snapshots. To do so, you need to mount a RWX volume on every Elasticsearch node, and set the parameter `snapshotRepoPath` with the path where the volume is mounted. In the example below, you can find the values to set when using a NFS Perstitent Volume:

```yaml
extraVolumes:
  - name: snapshot-repository
    nfs:
      server: nfs.example.com # Please change this to your NFS server
      path: /share1
extraVolumeMounts:
  - name: snapshot-repository
    mountPath: /snapshots
snapshotRepoPath: "/snapshots"
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Elasticsearch components (e.g. an additional metrics or logging exporter), you can do so via the `XXX.sidecars` parameter(s), where XXX is placeholder you need to replace with the actual component(s). Simply define your container according to the Kubernetes container spec.


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
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Elasticsearch](https://github.com/bitnami/bitnami-docker-elasticsearch) image stores the Elasticsearch data at the `/bitnami/elasticsearch/data` path of the container.

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. See the [Parameters](#parameters) section to configure the PVC.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 15.0.0

From this version onwards, Elasticsearch container components are now licensed under the [Elastic License](https://www.elastic.co/licensing/elastic-license) that is not currently accepted as an Open Source license by the Open Source Initiative (OSI).

Also, from now on, the Helm Chart will include the X-Pack plugin installed by default.

Regular upgrade is compatible from previous versions.

### To 14.0.0

This version standardizes the way of defining Ingress rules in the Kibana subchart. When configuring a single hostname for the Ingress rule, set the `kibana.ingress.hostname` value. When defining more than one, set the `kibana.ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 13.0.0

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

### To 12.0.0

Several changes were introduced that breaks backwards compatibility:

- Ports names were prefixed with the protocol to comply with Istio (see https://istio.io/docs/ops/deployment/requirements/).
- Labels are adapted to follow the Helm charts best practices.
- Elasticsearch data pods are now deployed in parallel in order to bootstrap the cluster and be discovered.

### To 11.0.0

Elasticsearch master pods are now deployed in parallel in order to bootstrap the cluster and be discovered.

The field `podManagementPolicy` can't be updated in a StatefulSet, so you need to destroy it before you upgrade the chart to this version.

```console
$ kubectl delete statefulset elasticsearch-master
$ helm upgrade <DEPLOYMENT_NAME> bitnami/elasticsearch
```

### TO 10.0.0

In this version, Kibana was added as dependent chart. More info about how to enable and work with this bundled Kibana in the ["Enable bundled Kibana"](#enable-bundled-kibana) section.

### To 9.0.0

Elasticsearch master nodes store the cluster status at `/bitnami/elasticsearch/data`. Among other things this includes the UUID of the elasticsearch cluster. Without a persistent data store for this data, the UUID of a cluster could change if k8s node(s) hosting the es master nodes go down and are scheduled on some other master node. In the event that this happens, the data nodes will no longer be able to join a cluster as the uuid changed resulting in a broken cluster.

To resolve such issues, PVC's are now attached for master node data persistence.

---

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In [4dfac075aacf74405e31ae5b27df4369e84eb0b0](https://github.com/bitnami/charts/commit/4dfac075aacf74405e31ae5b27df4369e84eb0b0) the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

### To 7.4.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 7.0.0

This version enabled by default the initContainer that modify some kernel settings to meet the Elasticsearch requirements. More info in the ["Default kernel settings"](#default-kernel-settings) section.
You can disable the initContainer using the `sysctlImage.enabled=false` parameter.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is elasticsearch:

```console
$ kubectl patch deployment elasticsearch-coordinating --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl patch deployment elasticsearch-ingest --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl patch deployment elasticsearch-master --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl patch deployment elasticsearch-metrics --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset elasticsearch-data --cascade=false
```
