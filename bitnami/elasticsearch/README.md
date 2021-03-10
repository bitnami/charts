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

The following table lists the configurable parameters of the Elasticsearch chart and their default values.

| Parameter                                         | Description                                                                                                                                                       | Default                                                      |
|---------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                            | Global Docker image registry                                                                                                                                      | `nil`                                                        |
| `global.imagePullSecrets`                         | Global Docker registry secret names as an array                                                                                                                   | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                             | Global storage class for dynamic provisioning                                                                                                                     | `nil`                                                        |
| `global.coordinating.name`                        | Coordinating-only node pod name at global level to be used also in the Kibana subchart                                                                            | `coordinating-only`                                          |
| `image.registry`                                  | Elasticsearch image registry                                                                                                                                      | `docker.io`                                                  |
| `image.repository`                                | Elasticsearch image repository                                                                                                                                    | `bitnami/elasticsearch`                                      |
| `image.tag`                                       | Elasticsearch image tag                                                                                                                                           | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                                | Image pull policy                                                                                                                                                 | `IfNotPresent`                                               |
| `image.pullSecrets`                               | Specify docker-registry secret names as an array                                                                                                                  | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                                    | String to partially override common.names.fullname template with a string (will prepend the release name)                                                        | `nil`                                                        |
| `fullnameOverride`                                | String to fully override common.names.fullname template with a string                                                                                            | `nil`                                                        |
| `name`                                            | Elasticsearch cluster name                                                                                                                                        | `elastic`                                                    |
| `plugins`                                         | Comma, semi-colon or space separated list of plugins to install at initialization                                                                                 | `nil`                                                        |
| `snapshotRepoPath`                                | File System snapshot repository path                                                                                                                              | `nil`                                                        |
| `config`                                          | Elasticsearch node custom configuration                                                                                                                           | ``                                                           |
| `extraVolumes`                                    | Extra volumes                                                                                                                                                     |                                                              |
| `extraVolumeMounts`                               | Mount extra volume(s),                                                                                                                                            |                                                              |
| `initScripts`                                     | Dictionary of init scripts. Evaluated as a template.                                                                                                              | `nil`                                                        |
| `initScriptsCM`                                   | ConfigMap with the init scripts. Evaluated as a template.                                                                                                         | `nil`                                                        |
| `initScriptsSecret`                               | Secret containing `/docker-entrypoint-initdb.d` scripts to be executed at initialization time that contain sensitive data. Evaluated as a template.               | `nil`                                                        |
| `extraEnvVars`                                    | Array containing extra env vars to be added to all pods (evaluated as a template)                                                                                 | `[]`                                                         |
| `extraEnvVarsConfigMap`                           | ConfigMap containing extra env vars to be added to all pods (evaluated as a template)                                                                             | `nil`                                                        |
| `extraEnvVarsSecret`                              | Secret containing extra env vars to be added to all pods (evaluated as a template)                                                                                | `nil`                                                        |
| `master.name`                                     | Master-eligible node pod name                                                                                                                                     | `master`                                                     |
| `master.replicas`                                 | Desired number of Elasticsearch master-eligible nodes                                                                                                             | `2`                                                          |
| `master.updateStrategy.type`                      | Update strategy for Master statefulset                                                                                                                            | `RollingUpdate`                                              |
| `master.heapSize`                                 | Master-eligible node heap size                                                                                                                                    | `128m`                                                       |
| `master.service.type`                             | Kubernetes Service type (master-eligible nodes)                                                                                                                   | `ClusterIP`                                                  |
| `master.service.port`                             | Kubernetes Service port for Elasticsearch transport port (master-eligible nodes)                                                                                  | `9300`                                                       |
| `master.service.nodePort`                         | Kubernetes Service nodePort (master-eligible nodes)                                                                                                               | `nil`                                                        |
| `master.service.annotations`                      | Annotations for master-eligible nodes service                                                                                                                     | `{}`                                                         |
| `master.service.loadBalancerIP`                   | loadBalancerIP if master-eligible nodes service type is `LoadBalancer`                                                                                            | `nil`                                                        |
| `master.resources`                                | CPU/Memory resource requests/limits for master-eligible nodes pods                                                                                                | `requests: { cpu: "25m", memory: "256Mi" }`                  |
| `master.podAnnotations`                           | Annotations for master pods.                                                                                                                                      | `{}`                                                         |
| `master.hostAliases`                              | Add deployment host aliases                                                                                                                                       | `[]`                                                         |
| `master.podAffinityPreset`                        | Master-eligible Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                               | `""`                                                         |
| `master.podAntiAffinityPreset`                    | Master-eligible Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                          | `soft`                                                       |
| `master.nodeAffinityPreset.type`                  | Master-eligible Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                         | `""`                                                         |
| `master.nodeAffinityPreset.key`                   | Master-eligible Node label key to match Ignored if `affinity` is set.                                                                                             | `""`                                                         |
| `master.nodeAffinityPreset.values`                | Master-eligible Node label values to match. Ignored if `affinity` is set.                                                                                         | `[]`                                                         |
| `master.affinity`                                 | Master-eligible Affinity for pod assignment                                                                                                                       | `{}` (evaluated as a template)                               |
| `master.nodeSelector`                             | Master-eligible Node labels for pod assignment                                                                                                                    | `{}` (evaluated as a template)                               |
| `master.tolerations`                              | Master-eligible Tolerations for pod assignment                                                                                                                    | `[]` (evaluated as a template)                               |
| `master.persistence.enabled`                      | Enable persistence using a `PersistentVolumeClaim`                                                                                                                | `true`                                                       |
| `master.persistence.annotations`                  | Persistent Volume Claim annotations                                                                                                                               | `{}`                                                         |
| `master.persistence.storageClass`                 | Persistent Volume Storage Class                                                                                                                                   | ``                                                           |
| `master.persistence.existingClaim`                | Existing Persistent Volume Claim                                                                                                                                  | `nil`                                                        |
| `master.persistence.existingVolume`               | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `master.persistence.selector` ist set.               | `nil`                                                        |
| `master.persistence.selector`                     | Configure custom selector for existing Persistent Volume. Overwrites `master.persistence.existingVolume`                                                          | `nil`                                                        |
| `master.persistence.accessModes`                  | Persistent Volume Access Modes                                                                                                                                    | `[ReadWriteOnce]`                                            |
| `master.persistence.size`                         | Persistent Volume Size                                                                                                                                            | `8Gi`                                                        |
| `master.schedulerName`                            | Name of the k8s scheduler (other than default)                                                                                                                    | `nil`                                                        |
| `master.securityContext.enabled`                  | Enable security context for master-eligible pods                                                                                                                  | `true`                                                       |
| `master.securityContext.fsGroup`                  | Group ID for the container for master-eligible pods                                                                                                               | `1001`                                                       |
| `master.securityContext.runAsUser`                | User ID for the container for master-eligible pods                                                                                                                | `1001`                                                       |
| `master.livenessProbe.enabled`                    | Enable/disable the liveness probe (master-eligible nodes pod)                                                                                                     | `true`                                                       |
| `master.livenessProbe.initialDelaySeconds`        | Delay before liveness probe is initiated (master-eligible nodes pod)                                                                                              | `90`                                                         |
| `master.livenessProbe.periodSeconds`              | How often to perform the probe (master-eligible nodes pod)                                                                                                        | `10`                                                         |
| `master.livenessProbe.timeoutSeconds`             | When the probe times out (master-eligible nodes pod)                                                                                                              | `5`                                                          |
| `master.livenessProbe.successThreshold`           | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                           | `1`                                                          |
| `master.livenessProbe.failureThreshold`           | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                         | `5`                                                          |
| `master.readinessProbe.enabled`                   | Enable/disable the readiness probe (master-eligible nodes pod)                                                                                                    | `true`                                                       |
| `master.readinessProbe.initialDelaySeconds`       | Delay before readiness probe is initiated (master-eligible nodes pod)                                                                                             | `90`                                                         |
| `master.readinessProbe.periodSeconds`             | How often to perform the probe (master-eligible nodes pod)                                                                                                        | `10`                                                         |
| `master.readinessProbe.timeoutSeconds`            | When the probe times out (master-eligible nodes pod)                                                                                                              | `5`                                                          |
| `master.readinessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                           | `1`                                                          |
| `master.readinessProbe.failureThreshold`          | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                         | `5`                                                          |
| `master.serviceAccount.create`                    | Enable creation of ServiceAccount for the master node                                                                                                             | `false`                                                      |
| `master.serviceAccount.name`                      | Name of the created serviceAccount                                                                                                                                | Generated using the `elasticsearch.master.fullname` template |
| `clusterDomain`                                   | Kubernetes cluster domain                                                                                                                                         | `cluster.local`                                              |
| `coordinating.replicas`                           | Desired number of Elasticsearch coordinating-only nodes                                                                                                           | `2`                                                          |
| `coordinating.hostAliases`                        | Add deployment host aliases                                                                                                                                       | `[]`                                                         |
| `coordinating.updateStrategy.type`                | Update strategy for Coordinating Deployment                                                                                                                       | `RollingUpdate`                                              |
| `coordinating.heapSize`                           | Coordinating-only node heap size                                                                                                                                  | `128m`                                                       |
| `coordinating.podAnnotations`                     | Annotations for coordniating pods.                                                                                                                                | `{}`                                                         |
| `coordinating.podAffinityPreset`                  | Coordinating Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `""`                                                         |
| `coordinating.podAntiAffinityPreset`              | Coordinating Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                             | `soft`                                                       |
| `coordinating.nodeAffinityPreset.type`            | Coordinating Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                            | `""`                                                         |
| `coordinating.nodeAffinityPreset.key`             | Coordinating Node label key to match Ignored if `affinity` is set.                                                                                                | `""`                                                         |
| `coordinating.nodeAffinityPreset.values`          | Coordinating Node label values to match. Ignored if `affinity` is set.                                                                                            | `[]`                                                         |
| `coordinating.affinity`                           | Coordinating Affinity for pod assignment                                                                                                                          | `{}` (evaluated as a template)                               |
| `coordinating.nodeSelector`                       | Coordinating Node labels for pod assignment                                                                                                                       | `{}` (evaluated as a template)                               |
| `coordinating.tolerations`                        | Coordinating Tolerations for pod assignment                                                                                                                       | `[]` (evaluated as a template)                               |
| `coordinating.schedulerName`                      | Name of the k8s scheduler (other than default)                                                                                                                    | `nil`                                                        |
| `coordinating.service.type`                       | Kubernetes Service type (coordinating-only nodes)                                                                                                                 | `ClusterIP`                                                  |
| `coordinating.service.port`                       | Kubernetes Service port for REST API (coordinating-only nodes)                                                                                                    | `9200`                                                       |
| `coordinating.service.nodePort`                   | Kubernetes Service nodePort (coordinating-only nodes)                                                                                                             | `nil`                                                        |
| `coordinating.service.annotations`                | Annotations for coordinating-only nodes service                                                                                                                   | `{}`                                                         |
| `coordinating.service.loadBalancerIP`             | loadBalancerIP if coordinating-only nodes service type is `LoadBalancer`                                                                                          | `nil`                                                        |
| `coordinating.resources`                          | CPU/Memory resource requests/limits for coordinating-only nodes pods                                                                                              | `requests: { cpu: "25m", memory: "256Mi" }`                  |
| `coordinating.securityContext.enabled`            | Enable security context for coordinating-only pods                                                                                                                | `true`                                                       |
| `coordinating.securityContext.fsGroup`            | Group ID for the container for coordinating-only pods                                                                                                             | `1001`                                                       |
| `coordinating.securityContext.runAsUser`          | User ID for the container for coordinating-only pods                                                                                                              | `1001`                                                       |
| `coordinating.livenessProbe.enabled`              | Enable/disable the liveness probe (coordinating-only nodes pod)                                                                                                   | `true`                                                       |
| `coordinating.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (coordinating-only nodes pod)                                                                                            | `90`                                                         |
| `coordinating.livenessProbe.periodSeconds`        | How often to perform the probe (coordinating-only nodes pod)                                                                                                      | `10`                                                         |
| `coordinating.livenessProbe.timeoutSeconds`       | When the probe times out (coordinating-only nodes pod)                                                                                                            | `5`                                                          |
| `coordinating.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                         | `1`                                                          |
| `coordinating.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                         | `5`                                                          |
| `coordinating.readinessProbe.enabled`             | Enable/disable the readiness probe (coordinating-only nodes pod)                                                                                                  | `true`                                                       |
| `coordinating.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated (coordinating-only nodes pod)                                                                                           | `90`                                                         |
| `coordinating.readinessProbe.periodSeconds`       | How often to perform the probe (coordinating-only nodes pod)                                                                                                      | `10`                                                         |
| `coordinating.readinessProbe.timeoutSeconds`      | When the probe times out (coordinating-only nodes pod)                                                                                                            | `5`                                                          |
| `coordinating.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                         | `1`                                                          |
| `coordinating.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                         | `5`                                                          |
| `coordinating.serviceAccount.create`              | Enable creation of ServiceAccount for the coordinating-only node                                                                                                  | `false`                                                      |
| `coordinating.serviceAccount.name`                | Name of the created serviceAccount                                                                                                                                | Generated using the `elasticsearch.coordinating.fullname`    |
| `data.name`                                       | Data node pod name                                                                                                                                                | `data`                                                       |
| `data.replicas`                                   | Desired number of Elasticsearch data nodes                                                                                                                        | `3`                                                          |
| `data.hostAliases`                                | Add deployment host aliases                                                                                                                                       | `[]`                                                         |
| `data.updateStrategy.type`                        | Update strategy for Data statefulset                                                                                                                              | `RollingUpdate`                                              |
| `data.updateStrategy.rollingUpdatePartition`      | Partition update strategy for Data statefulset                                                                                                                    | `nil`                                                        |
| `data.heapSize`                                   | Data node heap size                                                                                                                                               | `1024m`                                                      |
| `data.resources`                                  | CPU/Memory resource requests/limits for data nodes                                                                                                                | `requests: { cpu: "25m", memory: "2048Mi" }`                 |
| `data.persistence.enabled`                        | Enable persistence using a `PersistentVolumeClaim`                                                                                                                | `true`                                                       |
| `data.persistence.annotations`                    | Persistent Volume Claim annotations                                                                                                                               | `{}`                                                         |
| `data.persistence.existingClaim`                  | Existing Persistent Volume Claim                                                                                                                                  | `nil`                                                        |
| `data.persistence.existingVolume`                 | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `data.persistence.selector` ist set.                 | `nil`                                                        |
| `data.persistence.selector`                       | Configure custom selector for existing Persistent Volume. Overwrites `data.persistence.existingVolume`                                                            | `nil`                                                        |
| `data.persistence.storageClass`                   | Persistent Volume Storage Class                                                                                                                                   | ``                                                           |
| `data.persistence.accessModes`                    | Persistent Volume Access Modes                                                                                                                                    | `[ReadWriteOnce]`                                            |
| `data.persistence.size`                           | Persistent Volume Size                                                                                                                                            | `8Gi`                                                        |
| `data.schedulerName`                              | Name of the k8s scheduler (other than default)                                                                                                                    | `nil`                                                        |
| `data.securityContext.enabled`                    | Enable security context for data pods                                                                                                                             | `true`                                                       |
| `data.securityContext.fsGroup`                    | Group ID for the container for data pods                                                                                                                          | `1001`                                                       |
| `data.securityContext.runAsUser`                  | User ID for the container for data pods                                                                                                                           | `1001`                                                       |
| `data.livenessProbe.enabled`                      | Enable/disable the liveness probe (data nodes pod)                                                                                                                | `true`                                                       |
| `data.livenessProbe.initialDelaySeconds`          | Delay before liveness probe is initiated (data nodes pod)                                                                                                         | `90`                                                         |
| `data.livenessProbe.periodSeconds`                | How often to perform the probe (data nodes pod)                                                                                                                   | `10`                                                         |
| `data.livenessProbe.timeoutSeconds`               | When the probe times out (data nodes pod)                                                                                                                         | `5`                                                          |
| `data.livenessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                      | `1`                                                          |
| `data.livenessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                         | `5`                                                          |
| `data.podAnnotations`                             | Annotations for data pods.                                                                                                                                        | `{}`                                                         |
| `data.podAffinityPreset`                          | Data Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                          | `""`                                                         |
| `data.podAntiAffinityPreset`                      | Data Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                     | `soft`                                                       |
| `data.nodeAffinityPreset.type`                    | Data Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                    | `""`                                                         |
| `data.nodeAffinityPreset.key`                     | Data Node label key to match Ignored if `affinity` is set.                                                                                                        | `""`                                                         |
| `data.nodeAffinityPreset.values`                  | Data Node label values to match. Ignored if `affinity` is set.                                                                                                    | `[]`                                                         |
| `data.affinity`                                   | Data Affinity for pod assignment                                                                                                                                  | `{}` (evaluated as a template)                               |
| `data.nodeSelector`                               | Data Node labels for pod assignment                                                                                                                               | `{}` (evaluated as a template)                               |
| `data.tolerations`                                | Data Tolerations for pod assignment                                                                                                                               | `[]` (evaluated as a template)                               |
| `data.readinessProbe.enabled`                     | Enable/disable the readiness probe (data nodes pod)                                                                                                               | `true`                                                       |
| `data.readinessProbe.initialDelaySeconds`         | Delay before readiness probe is initiated (data nodes pod)                                                                                                        | `90`                                                         |
| `data.readinessProbe.periodSeconds`               | How often to perform the probe (data nodes pod)                                                                                                                   | `10`                                                         |
| `data.readinessProbe.timeoutSeconds`              | When the probe times out (data nodes pod)                                                                                                                         | `5`                                                          |
| `data.readinessProbe.successThreshold`            | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                                      | `1`                                                          |
| `data.readinessProbe.failureThreshold`            | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                         | `5`                                                          |
| `data.serviceAccount.create`                      | Enable creation of ServiceAccount for the data node                                                                                                               | `false`                                                      |
| `data.serviceAccount.name`                        | Name of the created serviceAccount                                                                                                                                | Generated using the `elasticsearch.data.fullname` template   |
| `ingest.enabled`                                  | Enable ingest nodes                                                                                                                                               | `false`                                                      |
| `ingest.name`                                     | Ingest node pod name                                                                                                                                              | `ingest`                                                     |
| `ingest.replicas`                                 | Desired number of Elasticsearch ingest nodes                                                                                                                      | `2`                                                          |
| `ingest.heapSize`                                 | Ingest node heap size                                                                                                                                             | `128m`                                                       |
| `ingest.hostAliases`                              | Add deployment host aliases                                                                                                                                       | `[]`                                                         |
| `ingest.schedulerName`                            | Name of the k8s scheduler (other than default)                                                                                                                    | `nil`                                                        |
| `ingest.service.type`                             | Kubernetes Service type (ingest nodes)                                                                                                                            | `ClusterIP`                                                  |
| `ingest.service.port`                             | Kubernetes Service port Elasticsearch transport port (ingest nodes)                                                                                               | `9300`                                                       |
| `ingest.service.nodePort`                         | Kubernetes Service nodePort (ingest nodes)                                                                                                                        | `nil`                                                        |
| `ingest.service.annotations`                      | Annotations for ingest nodes service                                                                                                                              | `{}`                                                         |
| `ingest.service.loadBalancerIP`                   | loadBalancerIP if ingest nodes service type is `LoadBalancer`                                                                                                     | `nil`                                                        |
| `ingest.resources`                                | CPU/Memory resource requests/limits for ingest nodes pods                                                                                                         | `requests: { cpu: "25m", memory: "256Mi" }`                  |
| `ingest.securityContext.enabled`                  | Enable security context for ingest pods                                                                                                                           | `true`                                                       |
| `ingest.securityContext.fsGroup`                  | Group ID for the container for ingest pods                                                                                                                        | `1001`                                                       |
| `ingest.securityContext.runAsUser`                | User ID for the container for ingest pods                                                                                                                         | `1001`                                                       |
| `ingest.livenessProbe.enabled`                    | Enable/disable the liveness probe (ingest nodes pod)                                                                                                              | `true`                                                       |
| `ingest.livenessProbe.initialDelaySeconds`        | Delay before liveness probe is initiated (ingest nodes pod)                                                                                                       | `90`                                                         |
| `ingest.livenessProbe.periodSeconds`              | How often to perform the probe (ingest nodes pod)                                                                                                                 | `10`                                                         |
| `ingest.livenessProbe.timeoutSeconds`             | When the probe times out (ingest nodes pod)                                                                                                                       | `5`                                                          |
| `ingest.livenessProbe.successThreshold`           | Minimum consecutive successes for the probe to be considered successful after having failed (ingest nodes pod)                                                    | `1`                                                          |
| `ingest.livenessProbe.failureThreshold`           | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                         | `5`                                                          |
| `ingest.podAnnotations`                           | Annotations for ingest pods.                                                                                                                                      | `{}`                                                         |
| `ingest.podAffinityPreset`                        | Ingest Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                        | `""`                                                         |
| `ingest.podAntiAffinityPreset`                    | Ingest Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                   | `soft`                                                       |
| `ingest.nodeAffinityPreset.type`                  | Ingest Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `""`                                                         |
| `ingest.nodeAffinityPreset.key`                   | Ingest Node label key to match Ignored if `affinity` is set.                                                                                                      | `""`                                                         |
| `ingest.nodeAffinityPreset.values`                | Ingest Node label values to match. Ignored if `affinity` is set.                                                                                                  | `[]`                                                         |
| `ingest.affinity`                                 | Ingest Affinity for pod assignment                                                                                                                                | `{}` (evaluated as a template)                               |
| `ingest.nodeSelector`                             | Ingest Node labels for pod assignment                                                                                                                             | `{}` (evaluated as a template)                               |
| `ingest.tolerations`                              | Ingest Tolerations for pod assignment                                                                                                                             | `[]` (evaluated as a template)                               |
| `ingest.readinessProbe.enabled`                   | Enable/disable the readiness probe (ingest nodes pod)                                                                                                             | `true`                                                       |
| `ingest.readinessProbe.initialDelaySeconds`       | Delay before readiness probe is initiated (ingest nodes pod)                                                                                                      | `90`                                                         |
| `ingest.readinessProbe.periodSeconds`             | How often to perform the probe (ingest nodes pod)                                                                                                                 | `10`                                                         |
| `ingest.readinessProbe.timeoutSeconds`            | When the probe times out (ingest nodes pod)                                                                                                                       | `5`                                                          |
| `ingest.readinessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed (ingest nodes pod)                                                    | `1`                                                          |
| `ingest.readinessProbe.failureThreshold`          | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                         | `5`                                                          |
| `curator.enabled`                                 | Enable Elasticsearch Curator cron job                                                                                                                             | `false`                                                      |
| `curator.name`                                    | Elasticsearch Curator pod name                                                                                                                                    | `curator`                                                    |
| `curator.image.registry`                          | Elasticsearch Curator image registry                                                                                                                              | `docker.io`                                                  |
| `curator.image.repository`                        | Elasticsearch Curator image repository                                                                                                                            | `bitnami/elasticsearch-curator`                              |
| `curator.image.tag`                               | Elasticsearch Curator image tag                                                                                                                                   | `{TAG_NAME}`                                                 |
| `curator.image.pullPolicy`                        | Elasticsearch Curator image pull policy                                                                                                                           | `{TAG_NAME}`                                                 |
| `curator.cronjob.schedule`                        | Schedule for the CronJob                                                                                                                                          | `0 1 * * *`                                                  |
| `curator.cronjob.annotations`                     | Annotations to add to the cronjob                                                                                                                                 | `{}`                                                         |
| `curator.cronjob.concurrencyPolicy`               | `Allow,Forbid,Replace` concurrent jobs                                                                                                                            | `nil`                                                        |
| `curator.cronjob.failedJobsHistoryLimit`          | Specify the number of failed Jobs to keep                                                                                                                         | `nil`                                                        |
| `curator.cronjob.successfulJobsHistoryLimit`      | Specify the number of completed Jobs to keep                                                                                                                      | `nil`                                                        |
| `curator.cronjob.jobRestartPolicy`                | Control the Job restartPolicy                                                                                                                                     | `Never`                                                      |
| `curator.podAnnotations`                          | Annotations to add to the pod                                                                                                                                     | `{}`                                                         |
| `curator.podAffinityPreset`                       | Curator Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                                                         |
| `curator.podAntiAffinityPreset`                   | Curator Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `soft`                                                       |
| `curator.nodeAffinityPreset.type`                 | Curator Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                 | `""`                                                         |
| `curator.nodeAffinityPreset.key`                  | Curator Node label key to match Ignored if `affinity` is set.                                                                                                     | `""`                                                         |
| `curator.nodeAffinityPreset.values`               | Curator Node label values to match. Ignored if `affinity` is set.                                                                                                 | `[]`                                                         |
| `curator.affinity`                                | Curator Affinity for pod assignment                                                                                                                               | `{}` (evaluated as a template)                               |
| `curator.nodeSelector`                            | Curator Node labels for pod assignment                                                                                                                            | `{}` (evaluated as a template)                               |
| `curator.tolerations`                             | Curator Tolerations for pod assignment                                                                                                                            | `[]` (evaluated as a template)                               |
| `curator.rbac.enabled`                            | Enable RBAC resources                                                                                                                                             | `false`                                                      |
| `curator.schedulerName`                           | Name of the k8s scheduler (other than default)                                                                                                                    | `nil`                                                        |
| `curator.serviceAccount.create`                   | Create a default serviceaccount for elasticsearch curator                                                                                                         | `true`                                                       |
| `curator.serviceAccount.name`                     | Name for elasticsearch curator serviceaccount                                                                                                                     | `""`                                                         |
| `curator.hooks`                                   | Whether to run job on selected hooks                                                                                                                              | `{ "install": false, "upgrade": false }`                     |
| `curator.psp.create`                              | Create pod security policy resources                                                                                                                              | `false`                                                      |
| `curator.dryrun`                                  | Run Curator in dry-run mode                                                                                                                                       | `false`                                                      |
| `curator.command`                                 | Command to execute                                                                                                                                                | `["/curator/curator"]`                                       |
| `curator.env`                                     | Environment variables to add to the cronjob container                                                                                                             | `{}`                                                         |
| `curator.configMaps.action_file_yml`              | Contents of the Curator action_file.yml                                                                                                                           | See values.yaml                                              |
| `curator.configMaps.config_yml`                   | Contents of the Curator config.yml (overrides config)                                                                                                             | See values.yaml                                              |
| `curator.resources`                               | Resource requests and limits                                                                                                                                      | `{}`                                                         |
| `curator.priorityClassName`                       | priorityClassName                                                                                                                                                 | `nil`                                                        |
| `curator.extraVolumes`                            | Extra volumes                                                                                                                                                     |                                                              |
| `curator.extraVolumeMounts`                       | Mount extra volume(s),                                                                                                                                            |                                                              |
| `curator.extraInitContainers`                     | Init containers to add to the cronjob container                                                                                                                   | `{}`                                                         |
| `curator.envFromSecrets`                          | Environment variables from secrets to the cronjob container                                                                                                       | `{}`                                                         |
| `curator.envFromSecrets.*.from.secret`            | - `secretKeyRef.name` used for environment variable                                                                                                               |                                                              |
| `curator.envFromSecrets.*.from.key`               | - `secretKeyRef.key` used for environment variable                                                                                                                |                                                              |
| `metrics.enabled`                                 | Enable prometheus exporter                                                                                                                                        | `false`                                                      |
| `metrics.name`                                    | Metrics pod name                                                                                                                                                  | `metrics`                                                    |
| `metrics.hostAliases`                             | Add deployment host aliases                                                                                                                                       | `[]`                                                         |
| `metrics.image.registry`                          | Metrics exporter image registry                                                                                                                                   | `docker.io`                                                  |
| `metrics.image.repository`                        | Metrics exporter image repository                                                                                                                                 | `bitnami/elasticsearch-exporter`                             |
| `metrics.image.tag`                               | Metrics exporter image tag                                                                                                                                        | `1.0.2`                                                      |
| `metrics.image.pullPolicy`                        | Metrics exporter image pull policy                                                                                                                                | `IfNotPresent`                                               |
| `metrics.service.type`                            | Metrics exporter endpoint service type                                                                                                                            | `ClusterIP`                                                  |
| `metrics.service.annotations`                     | Annotations for metrics service.                                                                                                                                  | `{prometheus.io/scrape: "true", prometheus.io/port: "8080"}` |
| `metrics.resources`                               | Metrics exporter resource requests/limit                                                                                                                          | `requests: { cpu: "25m" }`                                   |
| `metrics.podAnnotations`                          | Annotations for metrics pods.                                                                                                                                     | `{prometheus.io/scrape: "true", prometheus.io/port: "8080"}` |
| `metrics.podAffinityPreset`                       | Metrics Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                                                         |
| `metrics.podAntiAffinityPreset`                   | Metrics Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `soft`                                                       |
| `metrics.nodeAffinityPreset.type`                 | Metrics Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                 | `""`                                                         |
| `metrics.nodeAffinityPreset.key`                  | Metrics Node label key to match Ignored if `affinity` is set.                                                                                                     | `""`                                                         |
| `metrics.nodeAffinityPreset.values`               | Metrics Node label values to match. Ignored if `affinity` is set.                                                                                                 | `[]`                                                         |
| `metrics.affinity`                                | Metrics Affinity for pod assignment                                                                                                                               | `{}` (evaluated as a template)                               |
| `metrics.nodeSelector`                            | Metrics Node labels for pod assignment                                                                                                                            | `{}` (evaluated as a template)                               |
| `metrics.tolerations`                             | Metrics Tolerations for pod assignment                                                                                                                            | `[]` (evaluated as a template)                               |
| `metrics.schedulerName`                           | Name of the k8s scheduler (other than default)                                                                                                                    | `nil`                                                        |
| `metrics.serviceMonitor.enabled`                  | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                            | `false`                                                      |
| `metrics.serviceMonitor.namespace`                | Namespace in which Prometheus is running                                                                                                                          | `nil`                                                        |
| `metrics.serviceMonitor.interval`                 | Interval at which metrics should be scraped.                                                                                                                      | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.scrapeTimeout`            | Timeout after which the scrape is ended                                                                                                                           | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.selector`                 | Prometheus instance selector labels                                                                                                                               | `nil`                                                        |
| `sysctlImage.enabled`                             | Enable kernel settings modifier image                                                                                                                             | `true`                                                       |
| `sysctlImage.registry`                            | Kernel settings modifier image registry                                                                                                                           | `docker.io`                                                  |
| `sysctlImage.repository`                          | Kernel settings modifier image repository                                                                                                                         | `bitnami/bitnami-shell`                                      |
| `sysctlImage.tag`                                 | Kernel settings modifier image tag                                                                                                                                | `"10"`                                                       |
| `sysctlImage.pullPolicy`                          | Kernel settings modifier image pull policy                                                                                                                        | `Always`                                                     |
| `sysctlImage.resources`                           | Init container resource requests/limit                                                                                                                            | `requests: {}, limits: {}`                                   |
| `volumePermissions.enabled`                       | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work        ) | `false`                                                      |
| `volumePermissions.image.registry`                | Init container volume-permissions image registry                                                                                                                  | `docker.io`                                                  |
| `volumePermissions.image.repository`              | Init container volume-permissions image name                                                                                                                      | `bitnami/bitnami-shell`                                      |
| `volumePermissions.image.tag`                     | Init container volume-permissions image tag                                                                                                                       | `"10"`                                                       |
| `volumePermissions.image.pullPolicy`              | Init container volume-permissions image pull policy                                                                                                               | `Always`                                                     |
| `volumePermissions.resources`                     | Init container resource requests/limit                                                                                                                            | `requests: {}, limits: {}`                                   |

### Kibana Parameters

| Parameter                    | Description                                                               | Default                                                                                 |
|------------------------------|---------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| `global.kibanaEnabled`       | Use bundled Kibana                                                        | `false`                                                                                 |
| `kibana.elasticsearch.hosts` | Array containing hostnames for the ES instances. Used to generate the URL | `{{ include "elasticsearch.coordinating.fullname" . }}` Coordinating service (fullname) |
| `kibana.elasticsearch.port`  | Port to connect Kibana and ES instance. Used to generate the URL          | `9200`                                                                                  |

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
