# Elasticsearch

[Elasticsearch](https://www.elastic.co/products/elasticsearch) is a highly scalable open-source full-text search and analytics engine. It allows you to store, search, and analyze big volumes of data quickly and in near real time.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/elasticsearch
```

## Introduction

This chart bootstraps a [Elasticsearch](https://github.com/bitnami/bitnami-docker-elasticsearch) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
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

|                     Parameter                     |                                                                        Description                                                                        |                           Default                            |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                            | Global Docker image registry                                                                                                                              | `nil`                                                        |
| `global.imagePullSecrets`                         | Global Docker registry secret names as an array                                                                                                           | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                             | Global storage class for dynamic provisioning                                                                                                             | `nil`                                                        |
| `global.coordinating.name`                        | Coordinating-only node pod name at global level to be used also in the Kibana subchart                                                                    | `coordinating-only`                                          |
| `image.registry`                                  | Elasticsearch image registry                                                                                                                              | `docker.io`                                                  |
| `image.repository`                                | Elasticsearch image repository                                                                                                                            | `bitnami/elasticsearch`                                      |
| `image.tag`                                       | Elasticsearch image tag                                                                                                                                   | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                                | Image pull policy                                                                                                                                         | `IfNotPresent`                                               |
| `image.pullSecrets`                               | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                                    | String to partially override elasticsearch.fullname template with a string (will prepend the release name)                                                | `nil`                                                        |
| `fullnameOverride`                                | String to fully override elasticsearch.fullname template with a string                                                                                    | `nil`                                                        |
| `name`                                            | Elasticsearch cluster name                                                                                                                                | `elastic`                                                    |
| `plugins`                                         | Comma, semi-colon or space separated list of plugins to install at initialization                                                                         | `nil`                                                        |
| `config`                                          | Elasticsearch node custom configuration                                                                                                                   | ``                                                           |
| `extraVolumes`                                    | Extra volumes                                                                                                                                             |                                                              |
| `extraVolumeMounts`                               | Mount extra volume(s),                                                                                                                                    |                                                              |
| `master.name`                                     | Master-eligible node pod name                                                                                                                             | `master`                                                     |
| `master.replicas`                                 | Desired number of Elasticsearch master-eligible nodes                                                                                                     | `2`                                                          |
| `master.updateStrategy.type`                      | Update strategy for Master statefulset                                                                                                                    | `RollingUpdate`                                              |
| `master.heapSize`                                 | Master-eligible node heap size                                                                                                                            | `128m`                                                       |
| `master.service.type`                             | Kubernetes Service type (master-eligible nodes)                                                                                                           | `ClusterIP`                                                  |
| `master.service.port`                             | Kubernetes Service port for Elasticsearch transport port (master-eligible nodes)                                                                          | `9300`                                                       |
| `master.service.nodePort`                         | Kubernetes Service nodePort (master-eligible nodes)                                                                                                       | `nil`                                                        |
| `master.service.annotations`                      | Annotations for master-eligible nodes service                                                                                                             | `{}`                                                         |
| `master.service.loadBalancerIP`                   | loadBalancerIP if master-eligible nodes service type is `LoadBalancer`                                                                                    | `nil`                                                        |
| `master.resources`                                | CPU/Memory resource requests/limits for master-eligible nodes pods                                                                                        | `requests: { cpu: "25m", memory: "256Mi" }`                  |
| `master.podAnnotations`                           | Annotations for master pods.                                                                                                                              | `{}`                                                         |
| `master.persistence.enabled`                      | Enable persistence using a `PersistentVolumeClaim`                                                                                                        | `true`                                                       |
| `master.persistence.annotations`                  | Persistent Volume Claim annotations                                                                                                                       | `{}`                                                         |
| `master.persistence.storageClass`                 | Persistent Volume Storage Class                                                                                                                           | ``                                                           |
| `master.persistence.accessModes`                  | Persistent Volume Access Modes                                                                                                                            | `[ReadWriteOnce]`                                            |
| `master.persistence.size`                         | Persistent Volume Size                                                                                                                                    | `8Gi`                                                        |
| `master.securityContext.enabled`                  | Enable security context for master-eligible pods                                                                                                          | `true`                                                       |
| `master.securityContext.fsGroup`                  | Group ID for the container for master-eligible pods                                                                                                       | `1001`                                                       |
| `master.securityContext.runAsUser`                | User ID for the container for master-eligible pods                                                                                                        | `1001`                                                       |
| `master.livenessProbe.enabled`                    | Enable/disable the liveness probe (master-eligible nodes pod)                                                                                             | `true`                                                       |
| `master.livenessProbe.initialDelaySeconds`        | Delay before liveness probe is initiated (master-eligible nodes pod)                                                                                      | `90`                                                         |
| `master.livenessProbe.periodSeconds`              | How often to perform the probe (master-eligible nodes pod)                                                                                                | `10`                                                         |
| `master.livenessProbe.timeoutSeconds`             | When the probe times out (master-eligible nodes pod)                                                                                                      | `5`                                                          |
| `master.livenessProbe.successThreshold`           | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                   | `1`                                                          |
| `master.livenessProbe.failureThreshold`           | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                 | `5`                                                          |
| `master.readinessProbe.enabled`                   | Enable/disable the readiness probe (master-eligible nodes pod)                                                                                            | `true`                                                       |
| `master.readinessProbe.initialDelaySeconds`       | Delay before readiness probe is initiated (master-eligible nodes pod)                                                                                     | `90`                                                         |
| `master.readinessProbe.periodSeconds`             | How often to perform the probe (master-eligible nodes pod)                                                                                                | `10`                                                         |
| `master.readinessProbe.timeoutSeconds`            | When the probe times out (master-eligible nodes pod)                                                                                                      | `5`                                                          |
| `master.readinessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed (master-eligible nodes pod)                                   | `1`                                                          |
| `master.readinessProbe.failureThreshold`          | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                 | `5`                                                          |
| `master.serviceAccount.create`                    | Enable creation of ServiceAccount for the master node                                                                                                     | `false`                                                      |
| `master.serviceAccount.name`                      | Name of the created serviceAccount                                                                                                                        | Generated using the `elasticsearch.master.fullname` template |
| `clusterDomain`                                   | Kubernetes cluster domain                                                                                                                                 | `cluster.local`                                              |
| `discovery.name`                                  | Discover node pod name                                                                                                                                    | `discovery`                                                  |
| `coordinating.replicas`                           | Desired number of Elasticsearch coordinating-only nodes                                                                                                   | `2`                                                          |
| `coordinating.updateStrategy.type`                | Update strategy for Coordinating Deployment                                                                                                               | `RollingUpdate`                                              |
| `coordinating.heapSize`                           | Coordinating-only node heap size                                                                                                                          | `128m`                                                       |
| `coordinating.podAnnotations`                     | Annotations for coordniating pods.                                                                                                                        | `{}`                                                         |
| `coordinating.service.type`                       | Kubernetes Service type (coordinating-only nodes)                                                                                                         | `ClusterIP`                                                  |
| `coordinating.service.port`                       | Kubernetes Service port for REST API (coordinating-only nodes)                                                                                            | `9200`                                                       |
| `coordinating.service.nodePort`                   | Kubernetes Service nodePort (coordinating-only nodes)                                                                                                     | `nil`                                                        |
| `coordinating.service.annotations`                | Annotations for coordinating-only nodes service                                                                                                           | `{}`                                                         |
| `coordinating.service.loadBalancerIP`             | loadBalancerIP if coordinating-only nodes service type is `LoadBalancer`                                                                                  | `nil`                                                        |
| `coordinating.resources`                          | CPU/Memory resource requests/limits for coordinating-only nodes pods                                                                                      | `requests: { cpu: "25m", memory: "256Mi" }`                  |
| `coordinating.securityContext.enabled`            | Enable security context for coordinating-only pods                                                                                                        | `true`                                                       |
| `coordinating.securityContext.fsGroup`            | Group ID for the container for coordinating-only pods                                                                                                     | `1001`                                                       |
| `coordinating.securityContext.runAsUser`          | User ID for the container for coordinating-only pods                                                                                                      | `1001`                                                       |
| `coordinating.livenessProbe.enabled`              | Enable/disable the liveness probe (coordinating-only nodes pod)                                                                                           | `true`                                                       |
| `coordinating.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (coordinating-only nodes pod)                                                                                    | `90`                                                         |
| `coordinating.livenessProbe.periodSeconds`        | How often to perform the probe (coordinating-only nodes pod)                                                                                              | `10`                                                         |
| `coordinating.livenessProbe.timeoutSeconds`       | When the probe times out (coordinating-only nodes pod)                                                                                                    | `5`                                                          |
| `coordinating.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                 | `1`                                                          |
| `coordinating.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                 | `5`                                                          |
| `coordinating.readinessProbe.enabled`             | Enable/disable the readiness probe (coordinating-only nodes pod)                                                                                          | `true`                                                       |
| `coordinating.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated (coordinating-only nodes pod)                                                                                   | `90`                                                         |
| `coordinating.readinessProbe.periodSeconds`       | How often to perform the probe (coordinating-only nodes pod)                                                                                              | `10`                                                         |
| `coordinating.readinessProbe.timeoutSeconds`      | When the probe times out (coordinating-only nodes pod)                                                                                                    | `5`                                                          |
| `coordinating.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (coordinating-only nodes pod)                                 | `1`                                                          |
| `coordinating.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                 | `5`                                                          |
| `coordinating.serviceAccount.create`              | Enable creation of ServiceAccount for the coordinating-only node                                                                                          | `false`                                                      |
| `coordinating.serviceAccount.name`                | Name of the created serviceAccount                                                                                                                        | Generated using the `elasticsearch.coordinating.fullname`    |
| `data.name`                                       | Data node pod name                                                                                                                                        | `data`                                                       |
| `data.replicas`                                   | Desired number of Elasticsearch data nodes                                                                                                                | `3`                                                          |
| `data.updateStrategy.type`                        | Update strategy for Data statefulset                                                                                                                      | `RollingUpdate`                                              |
| `data.updateStrategy.rollingUpdatePartition`      | Partition update strategy for Data statefulset                                                                                                            | `nil`                                                        |
| `data.heapSize`                                   | Data node heap size                                                                                                                                       | `1024m`                                                      |
| `data.resources`                                  | CPU/Memory resource requests/limits for data nodes                                                                                                        | `requests: { cpu: "25m", memory: "1152Mi" }`                 |
| `data.persistence.enabled`                        | Enable persistence using a `PersistentVolumeClaim`                                                                                                        | `true`                                                       |
| `data.persistence.annotations`                    | Persistent Volume Claim annotations                                                                                                                       | `{}`                                                         |
| `data.persistence.storageClass`                   | Persistent Volume Storage Class                                                                                                                           | ``                                                           |
| `data.persistence.accessModes`                    | Persistent Volume Access Modes                                                                                                                            | `[ReadWriteOnce]`                                            |
| `data.persistence.size`                           | Persistent Volume Size                                                                                                                                    | `8Gi`                                                        |
| `data.securityContext.enabled`                    | Enable security context for data pods                                                                                                                     | `true`                                                       |
| `data.securityContext.fsGroup`                    | Group ID for the container for data pods                                                                                                                  | `1001`                                                       |
| `data.securityContext.runAsUser`                  | User ID for the container for data pods                                                                                                                   | `1001`                                                       |
| `data.livenessProbe.enabled`                      | Enable/disable the liveness probe (data nodes pod)                                                                                                        | `true`                                                       |
| `data.livenessProbe.initialDelaySeconds`          | Delay before liveness probe is initiated (data nodes pod)                                                                                                 | `90`                                                         |
| `data.livenessProbe.periodSeconds`                | How often to perform the probe (data nodes pod)                                                                                                           | `10`                                                         |
| `data.livenessProbe.timeoutSeconds`               | When the probe times out (data nodes pod)                                                                                                                 | `5`                                                          |
| `data.livenessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                              | `1`                                                          |
| `data.livenessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                 | `5`                                                          |
| `data.podAnnotations`                             | Annotations for data pods.                                                                                                                                | `{}`                                                         |
| `data.readinessProbe.enabled`                     | Enable/disable the readiness probe (data nodes pod)                                                                                                       | `true`                                                       |
| `data.readinessProbe.initialDelaySeconds`         | Delay before readiness probe is initiated (data nodes pod)                                                                                                | `90`                                                         |
| `data.readinessProbe.periodSeconds`               | How often to perform the probe (data nodes pod)                                                                                                           | `10`                                                         |
| `data.readinessProbe.timeoutSeconds`              | When the probe times out (data nodes pod)                                                                                                                 | `5`                                                          |
| `data.readinessProbe.successThreshold`            | Minimum consecutive successes for the probe to be considered successful after having failed (data nodes pod)                                              | `1`                                                          |
| `data.readinessProbe.failureThreshold`            | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                 | `5`                                                          |
| `data.serviceAccount.create`                      | Enable creation of ServiceAccount for the data node                                                                                                     | `false`                                                        |
| `data.serviceAccount.name`                        | Name of the created serviceAccount                                                                                                                        | Generated using the `elasticsearch.data.fullname` template   |
| `ingest.enabled`                                  | Enable ingest nodes                                                                                                                                       | `false`                                                      |
| `ingest.name`                                     | Ingest node pod name                                                                                                                                      | `ingest`                                                     |
| `ingest.replicas`                                 | Desired number of Elasticsearch ingest nodes                                                                                                              | `2`                                                          |
| `ingest.heapSize`                                 | Ingest node heap size                                                                                                                                     | `128m`                                                       |
| `ingest.service.type`                             | Kubernetes Service type (ingest nodes)                                                                                                                    | `ClusterIP`                                                  |
| `ingest.service.port`                             | Kubernetes Service port Elasticsearch transport port (ingest nodes)                                                                                       | `9300`                                                       |
| `ingest.service.nodePort`                         | Kubernetes Service nodePort (ingest nodes)                                                                                                                | `nil`                                                        |
| `ingest.service.annotations`                      | Annotations for ingest nodes service                                                                                                                      | `{}`                                                         |
| `ingest.service.loadBalancerIP`                   | loadBalancerIP if ingest nodes service type is `LoadBalancer`                                                                                             | `nil`                                                        |
| `ingest.resources`                                | CPU/Memory resource requests/limits for ingest nodes pods                                                                                                 | `requests: { cpu: "25m", memory: "256Mi" }`                  |
| `ingest.securityContext.enabled`                  | Enable security context for ingest pods                                                                                                                   | `true`                                                       |
| `ingest.securityContext.fsGroup`                  | Group ID for the container for ingest pods                                                                                                                | `1001`                                                       |
| `ingest.securityContext.runAsUser`                | User ID for the container for ingest pods                                                                                                                 | `1001`                                                       |
| `ingest.livenessProbe.enabled`                    | Enable/disable the liveness probe (ingest nodes pod)                                                                                                      | `true`                                                       |
| `ingest.livenessProbe.initialDelaySeconds`        | Delay before liveness probe is initiated (ingest nodes pod)                                                                                               | `90`                                                         |
| `ingest.livenessProbe.periodSeconds`              | How often to perform the probe (ingest nodes pod)                                                                                                         | `10`                                                         |
| `ingest.livenessProbe.timeoutSeconds`             | When the probe times out (ingest nodes pod)                                                                                                               | `5`                                                          |
| `ingest.livenessProbe.successThreshold`           | Minimum consecutive successes for the probe to be considered successful after having failed (ingest nodes pod)                                            | `1`                                                          |
| `ingest.livenessProbe.failureThreshold`           | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                 | `5`                                                          |
| `ingest.podAnnotations`                           | Annotations for ingest pods.                                                                                                                              | `{}`                                                         |
| `ingest.readinessProbe.enabled`                   | Enable/disable the readiness probe (ingest nodes pod)                                                                                                     | `true`                                                       |
| `ingest.readinessProbe.initialDelaySeconds`       | Delay before readiness probe is initiated (ingest nodes pod)                                                                                              | `90`                                                         |
| `ingest.readinessProbe.periodSeconds`             | How often to perform the probe (ingest nodes pod)                                                                                                         | `10`                                                         |
| `ingest.readinessProbe.timeoutSeconds`            | When the probe times out (ingest nodes pod)                                                                                                               | `5`                                                          |
| `ingest.readinessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed (ingest nodes pod)                                            | `1`                                                          |
| `ingest.readinessProbe.failureThreshold`          | Minimum consecutive failures for the probe to be considered failed after having succeeded                                                                 | `5`                                                          |
| `curator.enabled`                                 | Enable Elasticsearch Curator cron job                                                                                                                     | `false`                                                      |
| `curator.name`                                    | Elasticsearch Curator pod name                                                                                                                            | `curator`                                                    |
| `curator.image.registry`                          | Elasticsearch Curator image registry                                                                                                                      | `docker.io`                                                  |
| `curator.image.repository`                        | Elasticsearch Curator image repository                                                                                                                    | `bitnami/elasticsearch-curator`                              |
| `curator.image.tag`                               | Elasticsearch Curator image tag                                                                                                                           | `{TAG_NAME}`                                                 |
| `curator.image.pullPolicy`                        | Elasticsearch Curator image pull policy                                                                                                                   | `{TAG_NAME}`                                                 |
| `curator.cronjob.schedule`                        | Schedule for the CronJob                                                                                                                                  | `0 1 * * *`                                                  |
| `curator.cronjob.annotations`                     | Annotations to add to the cronjob                                                                                                                         | `{}`                                                         |
| `curator.cronjob.concurrencyPolicy`               | `Allow,Forbid,Replace` concurrent jobs                                                                                                                    | `nil`                                                        |
| `curator.cronjob.failedJobsHistoryLimit`          | Specify the number of failed Jobs to keep                                                                                                                 | `nil`                                                        |
| `curator.cronjob.successfulJobsHistoryLimit`      | Specify the number of completed Jobs to keep                                                                                                              | `nil`                                                        |
| `curator.cronjob.jobRestartPolicy`                | Control the Job restartPolicy                                                                                                                             | `Never`                                                      |
| `curator.podAnnotations`                          | Annotations to add to the pod                                                                                                                             | `{}`                                                         |
| `curator.rbac.enabled`                            | Enable RBAC resources                                                                                                                                     | `false`                                                      |
| `curator.serviceAccount.create`                   | Create a default serviceaccount for elasticsearch curator                                                                                                 | `true`                                                       |
| `curator.serviceAccount.name`                     | Name for elasticsearch curator serviceaccount                                                                                                             | `""`                                                         |
| `curator.hooks`                                   | Whether to run job on selected hooks                                                                                                                      | `{ "install": false, "upgrade": false }`                     |
| `curator.psp.create`                              | Create pod security policy resources                                                                                                                      | `false`                                                      |
| `curator.dryrun`                                  | Run Curator in dry-run mode                                                                                                                               | `false`                                                      |
| `curator.command`                                 | Command to execute                                                                                                                                        | `["/curator/curator"]`                                       |
| `curator.env`                                     | Environment variables to add to the cronjob container                                                                                                     | `{}`                                                         |
| `curator.configMaps.action_file_yml`              | Contents of the Curator action_file.yml                                                                                                                   | See values.yaml                                              |
| `curator.configMaps.config_yml`                   | Contents of the Curator config.yml (overrides config)                                                                                                     | See values.yaml                                              |
| `curator.resources`                               | Resource requests and limits                                                                                                                              | `{}`                                                         |
| `curator.priorityClassName`                       | priorityClassName                                                                                                                                         | `nil`                                                        |
| `curator.extraVolumes`                            | Extra volumes                                                                                                                                             |                                                              |
| `curator.extraVolumeMounts`                       | Mount extra volume(s),                                                                                                                                    |                                                              |
| `curator.extraInitContainers`                     | Init containers to add to the cronjob container                                                                                                           | `{}`                                                         |
| `curator.envFromSecrets`                          | Environment variables from secrets to the cronjob container                                                                                               | `{}`                                                         |
| `curator.envFromSecrets.*.from.secret`            | - `secretKeyRef.name` used for environment variable                                                                                                       |                                                              |
| `curator.envFromSecrets.*.from.key`               | - `secretKeyRef.key` used for environment variable                                                                                                        |                                                              |
| `metrics.enabled`                                 | Enable prometheus exporter                                                                                                                                | `false`                                                      |
| `metrics.name`                                    | Metrics pod name                                                                                                                                          | `metrics`                                                    |
| `metrics.image.registry`                          | Metrics exporter image registry                                                                                                                           | `docker.io`                                                  |
| `metrics.image.repository`                        | Metrics exporter image repository                                                                                                                         | `bitnami/elasticsearch-exporter`                             |
| `metrics.image.tag`                               | Metrics exporter image tag                                                                                                                                | `1.0.2`                                                      |
| `metrics.image.pullPolicy`                        | Metrics exporter image pull policy                                                                                                                        | `IfNotPresent`                                               |
| `metrics.service.type`                            | Metrics exporter endpoint service type                                                                                                                    | `ClusterIP`                                                  |
| `metrics.service.annotations`                     | Annotations for metrics service.                                                                                                                          | `{prometheus.io/scrape: "true", prometheus.io/port: "8080"}` |
| `metrics.resources`                               | Metrics exporter resource requests/limit                                                                                                                  | `requests: { cpu: "25m" }`                                   |
| `metrics.podAnnotations`                          | Annotations for metrics pods.                                                                                                                             | `{prometheus.io/scrape: "true", prometheus.io/port: "8080"}` |
| `metrics.serviceMonitor.enabled`                  | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                    | `false`                                                      |
| `metrics.serviceMonitor.namespace`                | Namespace in which Prometheus is running                                                                                                                  | `nil`                                                        |
| `metrics.serviceMonitor.interval`                 | Interval at which metrics should be scraped.                                                                                                              | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.scrapeTimeout`            | Timeout after which the scrape is ended                                                                                                                   | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.selector`                 | Prometheus instance selector labels                                                                                                                       | `nil`                                                        |
| `sysctlImage.enabled`                             | Enable kernel settings modifier image                                                                                                                     | `true`                                                       |
| `sysctlImage.registry`                            | Kernel settings modifier image registry                                                                                                                   | `docker.io`                                                  |
| `sysctlImage.repository`                          | Kernel settings modifier image repository                                                                                                                 | `bitnami/minideb`                                            |
| `sysctlImage.tag`                                 | Kernel settings modifier image tag                                                                                                                        | `buster`                                                     |
| `sysctlImage.pullPolicy`                          | Kernel settings modifier image pull policy                                                                                                                | `Always`                                                     |
| `volumePermissions.enabled`                       | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                      |
| `volumePermissions.image.registry`                | Init container volume-permissions image registry                                                                                                          | `docker.io`                                                  |
| `volumePermissions.image.repository`              | Init container volume-permissions image name                                                                                                              | `bitnami/minideb`                                            |
| `volumePermissions.image.tag`                     | Init container volume-permissions image tag                                                                                                               | `buster`                                                     |
| `volumePermissions.image.pullPolicy`              | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                     |
| `volumePermissions.resources`                     | Init container resource requests/limit                                                                                                                    | `nil`                                                        |

### Kibana Parameters

|            Parameter           |                                    Description                                      |                                         Default                                         |
|--------------------------------|-------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| `global.kibanaEnabled`         | Use bundled Kibana                                                                  | `false`                                                                                 |
| `kibana.elasticsearch.hosts`   | Array containing hostnames for the ES instances. Used to generate the URL           | `{{ include "elasticsearch.coordinating.fullname" . }}` Coordinating service (fullname) |
| `kibana.elasticsearch.port`    | Port to connect Kibana and ES instance. Used to generate the URL                    | `9200`                                                                                  |

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

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Init container that performs the sysctl operation to modify Kernel settings (needed sometimes to avoid boot errors):
```diff
- sysctlImage.enabled: true
+ sysctlImage.enabled: false
```

- Desired number of Elasticsearch master-eligible nodes:
```diff
- master.replicas: 2
+ master.replicas: 3
```

- Enable the liveness probe (master-eligible nodes pod):
```diff
- master.livenessProbe.enabled: false
-   #  initialDelaySeconds: 90
-   #  periodSeconds: 10
-   #  timeoutSeconds: 5
-   #  successThreshold: 1
-   #  failureThreshold: 5
+ master.livenessProbe.enabled: true
+   initialDelaySeconds: 90
+   periodSeconds: 10
+   timeoutSeconds: 5
+   successThreshold: 1
+   failureThreshold: 5
```

- Enable the readiness probe (master-eligible nodes pod):
```diff
- master.readinessProbe.enabled: false
-   #  initialDelaySeconds: 90
-   #  periodSeconds: 10
-   #  timeoutSeconds: 5
-   #  successThreshold: 1
-   #  failureThreshold: 5
+ master.readinessProbe.enabled: true
+   initialDelaySeconds: 90
+   periodSeconds: 10
+   timeoutSeconds: 5
+   successThreshold: 1
+   failureThreshold: 5
```

- Enable the liveness probe (coordinating-only nodes pod):
```diff
- coordinating.livenessProbe.enabled: false
-   #  initialDelaySeconds: 90
-   #  periodSeconds: 10
-   #  timeoutSeconds: 5
-   #  successThreshold: 1
-   #  failureThreshold: 5
+ coordinating.livenessProbe.enabled: true
+   initialDelaySeconds: 90
+   periodSeconds: 10
+   timeoutSeconds: 5
+   successThreshold: 1
+   failureThreshold: 5
```

- Enable the readiness probe (coordinating-only nodes pod):
```diff
- coordinating.readinessProbe.enabled: false
-   #  initialDelaySeconds: 90
-   #  periodSeconds: 10
-   #  timeoutSeconds: 5
-   #  successThreshold: 1
-   #  failureThreshold: 5
+ coordinating.readinessProbe.enabled: true
+   initialDelaySeconds: 90
+   periodSeconds: 10
+   timeoutSeconds: 5
+   successThreshold: 1
+   failureThreshold: 5
```

- Desired number of Elasticsearch data nodes:
```diff
- data.replicas: 2
+ data.replicas: 3
```

- Enable the liveness probe (data nodes pod):
```diff
- data.livenessProbe.enabled: false
-   #  initialDelaySeconds: 90
-   #  periodSeconds: 10
-   #  timeoutSeconds: 5
-   #  successThreshold: 1
-   #  failureThreshold: 5
+ data.livenessProbe.enabled: true
+   initialDelaySeconds: 90
+   periodSeconds: 10
+   timeoutSeconds: 5
+   successThreshold: 1
+   failureThreshold: 5
```

- Enable the readiness probe (data nodes pod):
```diff
- data.readinessProbe.enabled: false
-   #  initialDelaySeconds: 90
-   #  periodSeconds: 10
-   #  timeoutSeconds: 5
-   #  successThreshold: 1
-   #  failureThreshold: 5
+ data.readinessProbe.enabled: true
+   initialDelaySeconds: 90
+   periodSeconds: 10
+   timeoutSeconds: 5
+   successThreshold: 1
+   failureThreshold: 5
```

- Enable ingest nodes:
```diff
- ingest.enabled: false
+ ingest.enabled: true
```

- Enable the liveness probe (ingest nodes pod):
```diff
- ingest.livenessProbe.enabled: false
-   #  initialDelaySeconds: 90
-   #  periodSeconds: 10
-   #  timeoutSeconds: 5
-   #  successThreshold: 1
-   #  failureThreshold: 5
+ ingest.livenessProbe.enabled: true
+   initialDelaySeconds: 90
+   periodSeconds: 10
+   timeoutSeconds: 5
+   successThreshold: 1
+   failureThreshold: 5
```

- Enable the readiness probe (ingest nodes pod):
```diff
- ingest.readinessProbe.enabled: false
-   #  initialDelaySeconds: 90
-   #  periodSeconds: 10
-   #  timeoutSeconds: 5
-   #  successThreshold: 1
-   #  failureThreshold: 5
+ ingest.readinessProbe.enabled: true
+   initialDelaySeconds: 90
+   periodSeconds: 10
+   timeoutSeconds: 5
+   successThreshold: 1
+   failureThreshold: 5
```

- Enable prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

- Enable bundled Kibana:
```diff
- global.kibanaEnabled: false
+ global.kibanaEnabled: true
```

### Default kernel settings

Currently, Elasticsearch requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the ES containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

This chart uses a **privileged** initContainer to change those settings in the Kernel by running: `sysctl -w vm.max_map_count=262144 && sysctl -w fs.file-max=65536`.
You can disable the initContainer using the `sysctlImage.enabled=false` parameter.

### Enable bundled Kibana

This Elasticsearch chart contains Kibana as subchart, you can enable it just setting the `global.kibanaEnabled=true` parameter. It is enabled by default using the `values-production.yaml` file.
To see the notes with some operational instructions from the Kibana chart, please use the `--render-subchart-notes` as part of your `helm install` command, in this way you can see the Kibana and ES notes in your terminal.

## Persistence

The [Bitnami Elasticsearch](https://github.com/bitnami/bitnami-docker-elasticsearch) image stores the Elasticsearch data at the `/bitnami/elasticsearch/data` path of the container.

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. See the [Parameters](#parameters) section to configure the PVC.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Notable changes

### 11.0.0

Elasticsearch master pods are now deployed in parallel in order to bootstrap the cluster and be discovered.

The field `podManagementPolicy` can't be updated in a StatefulSet, so you need to destroy it before you upgrade the chart to this version.

```console
$ kubectl delete statefulset elasticsearch-master
$ helm upgrade <DEPLOYMENT_NAME> bitnami/elasticsearch
```

### 10.0.0

In this version, Kibana was added as dependant chart. More info about how to enable and work with this bundled Kibana in the ["Enable bundled Kibana"](#enable-bundled-kibana) section.

### 9.0.0

Elasticsearch master nodes store the cluster status at `/bitnami/elasticsearch/data`. Among other things this includes the UUID of the elasticsearch cluster. Without a persistent data store for this data, the UUID of a cluster could change if k8s node(s) hosting the es master nodes go down and are scheduled on some other master node. In the event that this happens, the data nodes will no longer be able to join a cluster as the uuid changed resulting in a broken cluster.

To resolve such issues, PVC's are now attached for master node data persistence.

---

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In [4dfac075aacf74405e31ae5b27df4369e84eb0b0](https://github.com/bitnami/charts/commit/4dfac075aacf74405e31ae5b27df4369e84eb0b0) the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

### 7.0.0

This version enabled by default the initContainer that modify some kernel settings to meet the Elasticsearch requirements. More info in the ["Default kernel settings"](#default-kernel-settings) section.
You can disable the initContainer using the `sysctlImage.enabled=false` parameter.

## Upgrading

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
