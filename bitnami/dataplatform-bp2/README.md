<!--- app-name: Data Platform Blueprint 2 -->

# Data Platform Blueprint 2 with Kafka-Spark-Elasticsearch

This Helm chart enables the fully automated Kubernetes deployment of such multi-stack data platform, covering the following software components: Kafka, Spark, Elasticsearch, Kibana, Logstash and Signature state controller

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/dataplatform-bp2
```

## Introduction

Enterprise applications increasingly rely on large amounts of data, that needs be distributed, processed, and stored.
Open source and commercial supported software stacks are available to implement a data platform, that can offer common data management services, accelerating the development and deployment of data hungry business applications.

This Helm chart enables the fully automated Kubernetes deployment of such multi-stack data platform, covering the following software components:

-   Apache Kafka              – Data distribution bus with buffering capabilities
-   Apache Spark              – In-memory data analytics
-   Elasticsearch with Kibana – Data persistence and search
-   Logstash                  - Data Processing Pipeline
-   Data Platform Signature State Controller - Kubernetes controller that emits data platform health and state metrics in Prometheus format.

These containerized stateful software stacks are deployed in multi-node cluster configurations, which is defined by the Helm Chart blueprint for this data platform deployment, covering:

-   Pod placement rules – Affinity rules to ensure placement diversity to prevent single point of failures and optimize load distribution
-   Pod resource sizing rules – Optimized Pod and JVM sizing settings for optimal performance and efficient resource usage
-   Default settings to ensure Pod access security
-   Optional [Tanzu Observability](https://docs.wavefront.com/kubernetes.html) framework configuration.

In addition to the Pod resource optimizations, this blueprint is validated and tested to provide Kubernetes node count and sizing recommendations [(see Kubernetes Cluster Requirements)](#kubernetes-cluster-requirements) to facilitate cloud platform capacity planning. The goal is optimize the number of required Kubernetes nodes in order to optimize server resource usage and, at the same time, ensuring runtime and resource diversity.

This blueprint, in its default configuration, deploys the data platform on a Kubernetes cluster with three worker nodes. Use cases for this data platform setup include: data and application evaluation, development, and functional testing.

This chart bootstraps Data Platform Blueprint-2 deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Once the chart is installed, the deployed data platform cluster comprises of:
1. Zookeeper with 3 nodes to be used for both Kafka
2. Kafka with 3 nodes using the zookeeper deployed above
3. Elasticsearch with 3 master nodes, 2 data nodes, 2 coordinating nodes and 1 kibana node
4. Logstash with 2 nodes
5. Spark with 1 Master and 2 worker nodes
6. Data Platform Metrics emitter and Prometheus exporter

The data platform can be optionally deployed with the Tanzu observability framework. In that case, the wavefront collectors will be set up as a DaemonSet to collect the Kubernetes cluster metrics to enable runtime feed into the Tanzu Observability service.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Kubernetes Cluster requirements

Below are the minimum Kubernetes Cluster requirements for "Small" size data platform:

| Data Platform Size | Kubernetes Cluster Size                                                      | Usage                                                                       |
|:-------------------|:-----------------------------------------------------------------------------|:----------------------------------------------------------------------------|
| Small              | 1 Master Node (2 CPU, 4Gi Memory) <br /> 3 Worker Nodes (4 CPU, 32Gi Memory) | Data and application evaluation, development, and functional testing <br /> |

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/dataplatform-bp2
```

These commands deploy Data Platform on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists recommended configurations of the parameters to bring up an optimal and resilient data platform. Please refer the individual charts for the remaining set of configurable parameters.

> **Tip**: List all releases using `helm list`

> **Recommendation**: It is a recommended best practice to create a dedicated namespace for the data platform cluster and deploy the data platform helm chart in the same.

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

| Name                | Description                                       | Value |
| ------------------- | ------------------------------------------------- | ----- |
| `commonLabels`      | Labels to add to all deployed objects             | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects        | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release | `[]`  |


### Data Platform Chart parameters

| Name                                                          | Description                                                                                                      | Value                           |
| ------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `dataplatform.serviceAccount.create`                          | Specifies whether a ServiceAccount should be created                                                             | `true`                          |
| `dataplatform.serviceAccount.name`                            | The name of the ServiceAccount to create                                                                         | `""`                            |
| `dataplatform.serviceAccount.automountServiceAccountToken`    | Allows auto mount of ServiceAccountToken on the serviceAccount created                                           | `true`                          |
| `dataplatform.rbac.create`                                    | Whether to create & use RBAC resources or not                                                                    | `true`                          |
| `dataplatform.exporter.enabled`                               | Start a prometheus exporter                                                                                      | `true`                          |
| `dataplatform.exporter.image.registry`                        | dataplatform exporter image registry                                                                             | `docker.io`                     |
| `dataplatform.exporter.image.repository`                      | dataplatform exporter image repository                                                                           | `bitnami/dataplatform-exporter` |
| `dataplatform.exporter.image.tag`                             | dataplatform exporter image tag (immutable tags are recommended)                                                 | `1.0.1-scratch-r0`              |
| `dataplatform.exporter.image.pullPolicy`                      | dataplatform exporter image pull policy                                                                          | `IfNotPresent`                  |
| `dataplatform.exporter.image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                 | `[]`                            |
| `dataplatform.exporter.config`                                | Data Platform Metrics Configuration emitted in Prometheus format                                                 | `""`                            |
| `dataplatform.exporter.livenessProbe.enabled`                 | Enable livenessProbe                                                                                             | `true`                          |
| `dataplatform.exporter.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                          | `10`                            |
| `dataplatform.exporter.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                 | `5`                             |
| `dataplatform.exporter.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                | `15`                            |
| `dataplatform.exporter.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                              | `15`                            |
| `dataplatform.exporter.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                              | `1`                             |
| `dataplatform.exporter.readinessProbe.enabled`                | Enable readinessProbe                                                                                            | `true`                          |
| `dataplatform.exporter.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                         | `10`                            |
| `dataplatform.exporter.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                | `5`                             |
| `dataplatform.exporter.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                               | `15`                            |
| `dataplatform.exporter.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                             | `15`                            |
| `dataplatform.exporter.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                             | `15`                            |
| `dataplatform.exporter.startupProbe.enabled`                  | Enable startupProbe                                                                                              | `false`                         |
| `dataplatform.exporter.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                           | `10`                            |
| `dataplatform.exporter.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                  | `5`                             |
| `dataplatform.exporter.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                 | `15`                            |
| `dataplatform.exporter.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                               | `15`                            |
| `dataplatform.exporter.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                               | `15`                            |
| `dataplatform.exporter.containerPorts.http`                   | Data Platform Prometheus exporter port                                                                           | `9090`                          |
| `dataplatform.exporter.priorityClassName`                     | exporter priorityClassName                                                                                       | `""`                            |
| `dataplatform.exporter.command`                               | Override Data Platform Exporter entrypoint string.                                                               | `[]`                            |
| `dataplatform.exporter.args`                                  | Arguments for the provided command if needed                                                                     | `[]`                            |
| `dataplatform.exporter.resources.limits`                      | The resources limits for the container                                                                           | `{}`                            |
| `dataplatform.exporter.resources.requests`                    | The requested resources for the container                                                                        | `{}`                            |
| `dataplatform.exporter.containerSecurityContext.enabled`      | Enable Data Platform exporter containers' Security Context                                                       | `true`                          |
| `dataplatform.exporter.containerSecurityContext.runAsUser`    | User ID for the containers.                                                                                      | `1001`                          |
| `dataplatform.exporter.containerSecurityContext.runAsNonRoot` | Enable Data Platform exporter containers' Security Context runAsNonRoot                                          | `true`                          |
| `dataplatform.exporter.podSecurityContext.enabled`            | Enable Data Platform exporter pods' Security Context                                                             | `true`                          |
| `dataplatform.exporter.podSecurityContext.fsGroup`            | Group ID for the pods.                                                                                           | `1001`                          |
| `dataplatform.exporter.podAffinityPreset`                     | Data Platform exporter pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                            |
| `dataplatform.exporter.podAntiAffinityPreset`                 | Data Platform exporter pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                          |
| `dataplatform.exporter.nodeAffinityPreset.type`               | Data Platform exporter node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                            |
| `dataplatform.exporter.nodeAffinityPreset.key`                | Data Platform exporter node label key to match Ignored if `affinity` is set.                                     | `""`                            |
| `dataplatform.exporter.nodeAffinityPreset.values`             | Data Platform exporter node label values to match. Ignored if `affinity` is set.                                 | `[]`                            |
| `dataplatform.exporter.affinity`                              | Affinity settings for exporter pod assignment. Evaluated as a template                                           | `{}`                            |
| `dataplatform.exporter.nodeSelector`                          | Node labels for exporter pods assignment. Evaluated as a template                                                | `{}`                            |
| `dataplatform.exporter.tolerations`                           | Tolerations for exporter pods assignment. Evaluated as a template                                                | `[]`                            |
| `dataplatform.exporter.podLabels`                             | Additional labels for Metrics exporter pod                                                                       | `{}`                            |
| `dataplatform.exporter.podAnnotations`                        | Additional annotations for Metrics exporter pod                                                                  | `{}`                            |
| `dataplatform.exporter.customLivenessProbe`                   | Override default liveness probe                                                                                  | `{}`                            |
| `dataplatform.exporter.customReadinessProbe`                  | Override default readiness probe                                                                                 | `{}`                            |
| `dataplatform.exporter.customStartupProbe`                    | Override default startup probe                                                                                   | `{}`                            |
| `dataplatform.exporter.updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached                                   | `RollingUpdate`                 |
| `dataplatform.exporter.updateStrategy.rollingUpdate`          | Deployment rolling update configuration parameters                                                               | `{}`                            |
| `dataplatform.exporter.extraEnvVars`                          | Additional environment variables to set                                                                          | `[]`                            |
| `dataplatform.exporter.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                                       | `""`                            |
| `dataplatform.exporter.extraEnvVarsSecret`                    | Secret with extra environment variables                                                                          | `""`                            |
| `dataplatform.exporter.extraVolumes`                          | Extra volumes to add to the deployment                                                                           | `[]`                            |
| `dataplatform.exporter.extraVolumeMounts`                     | Extra volume mounts to add to the container                                                                      | `[]`                            |
| `dataplatform.exporter.initContainers`                        | Add init containers to the %%MAIN_CONTAINER_NAME%% pods                                                          | `[]`                            |
| `dataplatform.exporter.sidecars`                              | Add sidecars to the %%MAIN_CONTAINER_NAME%% pods                                                                 | `[]`                            |
| `dataplatform.exporter.service.type`                          | Service type for default Data Platform Prometheus exporter service                                               | `ClusterIP`                     |
| `dataplatform.exporter.service.annotations`                   | Exporter service annotations                                                                                     | `{}`                            |
| `dataplatform.exporter.service.labels`                        | Additional labels for Data Platform exporter service                                                             | `{}`                            |
| `dataplatform.exporter.service.ports.http`                    | Kubernetes Service port                                                                                          | `9090`                          |
| `dataplatform.exporter.service.loadBalancerIP`                | Load balancer IP for the Data Platform Exporter Service (optional, cloud specific)                               | `""`                            |
| `dataplatform.exporter.service.nodePorts.http`                | Node ports for the HTTP exporter service                                                                         | `""`                            |
| `dataplatform.exporter.service.loadBalancerSourceRanges`      | Exporter Load Balancer Source ranges                                                                             | `[]`                            |
| `dataplatform.exporter.hostAliases`                           | Deployment pod host aliases                                                                                      | `[]`                            |
| `dataplatform.emitter.enabled`                                | Start Data Platform metrics emitter                                                                              | `true`                          |
| `dataplatform.emitter.image.registry`                         | Data Platform emitter image registry                                                                             | `docker.io`                     |
| `dataplatform.emitter.image.repository`                       | Data Platform emitter image repository                                                                           | `bitnami/dataplatform-emitter`  |
| `dataplatform.emitter.image.tag`                              | Data Platform emitter image tag (immutable tags are recommended)                                                 | `1.0.1-scratch-r1`              |
| `dataplatform.emitter.image.pullPolicy`                       | Data Platform emitter image pull policy                                                                          | `IfNotPresent`                  |
| `dataplatform.emitter.image.pullSecrets`                      | Specify docker-registry secret names as an array                                                                 | `[]`                            |
| `dataplatform.emitter.livenessProbe.enabled`                  | Enable livenessProbe                                                                                             | `true`                          |
| `dataplatform.emitter.livenessProbe.initialDelaySeconds`      | Initial delay seconds for livenessProbe                                                                          | `10`                            |
| `dataplatform.emitter.livenessProbe.periodSeconds`            | Period seconds for livenessProbe                                                                                 | `5`                             |
| `dataplatform.emitter.livenessProbe.timeoutSeconds`           | Timeout seconds for livenessProbe                                                                                | `15`                            |
| `dataplatform.emitter.livenessProbe.failureThreshold`         | Failure threshold for livenessProbe                                                                              | `15`                            |
| `dataplatform.emitter.livenessProbe.successThreshold`         | Success threshold for livenessProbe                                                                              | `1`                             |
| `dataplatform.emitter.readinessProbe.enabled`                 | Enable readinessProbe                                                                                            | `true`                          |
| `dataplatform.emitter.readinessProbe.initialDelaySeconds`     | Initial delay seconds for readinessProbe                                                                         | `10`                            |
| `dataplatform.emitter.readinessProbe.periodSeconds`           | Period seconds for readinessProbe                                                                                | `5`                             |
| `dataplatform.emitter.readinessProbe.timeoutSeconds`          | Timeout seconds for readinessProbe                                                                               | `15`                            |
| `dataplatform.emitter.readinessProbe.failureThreshold`        | Failure threshold for readinessProbe                                                                             | `15`                            |
| `dataplatform.emitter.readinessProbe.successThreshold`        | Success threshold for readinessProbe                                                                             | `15`                            |
| `dataplatform.emitter.startupProbe.enabled`                   | Enable startupProbe                                                                                              | `false`                         |
| `dataplatform.emitter.startupProbe.initialDelaySeconds`       | Initial delay seconds for startupProbe                                                                           | `10`                            |
| `dataplatform.emitter.startupProbe.periodSeconds`             | Period seconds for startupProbe                                                                                  | `5`                             |
| `dataplatform.emitter.startupProbe.timeoutSeconds`            | Timeout seconds for startupProbe                                                                                 | `15`                            |
| `dataplatform.emitter.startupProbe.failureThreshold`          | Failure threshold for startupProbe                                                                               | `15`                            |
| `dataplatform.emitter.startupProbe.successThreshold`          | Success threshold for startupProbe                                                                               | `15`                            |
| `dataplatform.emitter.containerPorts.http`                    | Data Platform emitter port                                                                                       | `8091`                          |
| `dataplatform.emitter.priorityClassName`                      | exporter priorityClassName                                                                                       | `""`                            |
| `dataplatform.emitter.command`                                | Override Data Platform entrypoint string.                                                                        | `[]`                            |
| `dataplatform.emitter.args`                                   | Arguments for the provided command if needed                                                                     | `[]`                            |
| `dataplatform.emitter.resources.limits`                       | The resources limits for the container                                                                           | `{}`                            |
| `dataplatform.emitter.resources.requests`                     | The requested resources for the container                                                                        | `{}`                            |
| `dataplatform.emitter.containerSecurityContext.enabled`       | Enable Data Platform emitter containers' Security Context                                                        | `true`                          |
| `dataplatform.emitter.containerSecurityContext.runAsUser`     | User ID for the containers.                                                                                      | `1001`                          |
| `dataplatform.emitter.containerSecurityContext.runAsNonRoot`  | Enable Data Platform emitter containers' Security Context runAsNonRoot                                           | `true`                          |
| `dataplatform.emitter.podSecurityContext.enabled`             | Enable Data Platform emitter pods' Security Context                                                              | `true`                          |
| `dataplatform.emitter.podSecurityContext.fsGroup`             | Group ID for the pods.                                                                                           | `1001`                          |
| `dataplatform.emitter.podAffinityPreset`                      | Data Platform emitter pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                            |
| `dataplatform.emitter.podAntiAffinityPreset`                  | Data Platform emitter pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`                          |
| `dataplatform.emitter.nodeAffinityPreset.type`                | Data Platform emitter node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`                            |
| `dataplatform.emitter.nodeAffinityPreset.key`                 | Data Platform emitter node label key to match Ignored if `affinity` is set.                                      | `""`                            |
| `dataplatform.emitter.nodeAffinityPreset.values`              | Data Platform emitter node label values to match. Ignored if `affinity` is set.                                  | `[]`                            |
| `dataplatform.emitter.affinity`                               | Affinity settings for emitter pod assignment. Evaluated as a template                                            | `{}`                            |
| `dataplatform.emitter.nodeSelector`                           | Node labels for emitter pods assignment. Evaluated as a template                                                 | `{}`                            |
| `dataplatform.emitter.tolerations`                            | Tolerations for emitter pods assignment. Evaluated as a template                                                 | `[]`                            |
| `dataplatform.emitter.podLabels`                              | Additional labels for Metrics emitter pod                                                                        | `{}`                            |
| `dataplatform.emitter.podAnnotations`                         | Additional annotations for Metrics emitter pod                                                                   | `{}`                            |
| `dataplatform.emitter.customLivenessProbe`                    | Override default liveness probe%%MAIN_CONTAINER_NAME%%                                                           | `{}`                            |
| `dataplatform.emitter.customReadinessProbe`                   | Override default readiness probe%%MAIN_CONTAINER_NAME%%                                                          | `{}`                            |
| `dataplatform.emitter.customStartupProbe`                     | Override default startup probe                                                                                   | `{}`                            |
| `dataplatform.emitter.updateStrategy.type`                    | Update strategy - only really applicable for deployments with RWO PVs attached                                   | `RollingUpdate`                 |
| `dataplatform.emitter.updateStrategy.rollingUpdate`           | Deployment rolling update configuration parameters                                                               | `{}`                            |
| `dataplatform.emitter.extraEnvVars`                           | Additional environment variables to set                                                                          | `[]`                            |
| `dataplatform.emitter.extraEnvVarsCM`                         | ConfigMap with extra environment variables                                                                       | `""`                            |
| `dataplatform.emitter.extraEnvVarsSecret`                     | Secret with extra environment variables                                                                          | `""`                            |
| `dataplatform.emitter.extraVolumes`                           | Extra volumes to add to the deployment                                                                           | `[]`                            |
| `dataplatform.emitter.extraVolumeMounts`                      | Extra volume mounts to add to the container                                                                      | `[]`                            |
| `dataplatform.emitter.initContainers`                         | Add init containers to the %%MAIN_CONTAINER_NAME%% pods                                                          | `[]`                            |
| `dataplatform.emitter.sidecars`                               | Add sidecars to the %%MAIN_CONTAINER_NAME%% pods                                                                 | `[]`                            |
| `dataplatform.emitter.service.type`                           | Service type for default Data Platform metrics emitter service                                                   | `ClusterIP`                     |
| `dataplatform.emitter.service.annotations`                    | annotations for Data Platform emitter service                                                                    | `{}`                            |
| `dataplatform.emitter.service.labels`                         | Additional labels for Data Platform emitter service                                                              | `{}`                            |
| `dataplatform.emitter.service.ports.http`                     | Kubernetes Service port                                                                                          | `8091`                          |
| `dataplatform.emitter.service.loadBalancerIP`                 | Load balancer IP for the dataplatform emitter Service (optional, cloud specific)                                 | `""`                            |
| `dataplatform.emitter.service.nodePorts.http`                 | Node ports for the HTTP emitter service                                                                          | `""`                            |
| `dataplatform.emitter.service.loadBalancerSourceRanges`       | Data Platform Emitter Load Balancer Source ranges                                                                | `[]`                            |
| `dataplatform.emitter.hostAliases`                            | Deployment pod host aliases                                                                                      | `[]`                            |


### Kafka parameters

| Name                                            | Description                                                                                                                        | Value                 |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `kafka.enabled`                                 | Enable Kafka subchart                                                                                                              | `true`                |
| `kafka.replicaCount`                            | Number of Kafka brokers                                                                                                            | `3`                   |
| `kafka.heapOpts`                                | Kafka Java Heap size                                                                                                               | `-Xmx4096m -Xms4096m` |
| `kafka.resources.limits`                        | Resource limits for Kafka                                                                                                          | `{}`                  |
| `kafka.resources.requests.cpu`                  | CPU capacity request for Kafka nodes                                                                                               | `250m`                |
| `kafka.resources.requests.memory`               | Memory capacity request for Kafka nodes                                                                                            | `5120Mi`              |
| `kafka.affinity.podAntiAffinity`                | Kafka anti affinity rules                                                                                                          | `{}`                  |
| `kafka.affinity.podAffinity`                    | Kafka affinity rules                                                                                                               | `{}`                  |
| `kafka.metrics.kafka.enabled`                   | Enable prometheus exporter for Kafka                                                                                               | `false`               |
| `kafka.metrics.kafka.resources.limits`          | Resource limits for kafka prometheus exporter                                                                                      | `{}`                  |
| `kafka.metrics.kafka.resources.requests.cpu`    | CPU capacity request for Kafka prometheus nodes                                                                                    | `100m`                |
| `kafka.metrics.kafka.resources.requests.memory` | Memory capacity request for Kafka prometheus nodes                                                                                 | `128Mi`               |
| `kafka.metrics.kafka.service.port`              | Kafka Exporter Prometheus port to be used in wavefront configuration                                                               | `9308`                |
| `kafka.metrics.jmx.enabled`                     | Enable JMX exporter for Kafka                                                                                                      | `false`               |
| `kafka.metrics.jmx.resources.limits`            | Resource limits for kafka prometheus exporter                                                                                      | `{}`                  |
| `kafka.metrics.jmx.resources.requests.cpu`      | CPU capacity request for Kafka prometheus nodes                                                                                    | `100m`                |
| `kafka.metrics.jmx.resources.requests.memory`   | Memory capacity request for Kafka prometheus nodes                                                                                 | `128Mi`               |
| `kafka.metrics.jmx.service.port`                | JMX Prometheus exporter service port                                                                                               | `5556`                |
| `kafka.metrics.jmx.service.annotations`         | Exporter service annotations                                                                                                       | `{}`                  |
| `kafka.zookeeper.enabled`                       | Enable the Kafka subchart's Zookeeper                                                                                              | `true`                |
| `kafka.zookeeper.replicaCount`                  | Number of Zookeeper nodes                                                                                                          | `3`                   |
| `kafka.zookeeper.heapSize`                      | Size in MB for the Java Heap options (Xmx and XMs) in Zookeeper. This env var is ignored if Xmx an Xms are configured via JVMFLAGS | `4096`                |
| `kafka.zookeeper.resources.limits`              | Resource limits for zookeeper                                                                                                      | `{}`                  |
| `kafka.zookeeper.resources.requests.cpu`        | CPU capacity request for zookeeper                                                                                                 | `250m`                |
| `kafka.zookeeper.resources.requests.memory`     | Memory capacity request for zookeeper                                                                                              | `5Gi`                 |
| `kafka.zookeeper.affinity.podAntiAffinity`      | Zookeeper pod anti affinity rules                                                                                                  | `{}`                  |
| `kafka.externalZookeeper.servers`               | Array of external Zookeeper servers                                                                                                | `[]`                  |


### Spark parameters

| Name                                     | Description                            | Value   |
| ---------------------------------------- | -------------------------------------- | ------- |
| `spark.enabled`                          | Enable Spark subchart                  | `true`  |
| `spark.master.webPort`                   | Web port for spark master              | `8080`  |
| `spark.master.resources.limits`          | Spark master resource limits           | `{}`    |
| `spark.master.resources.requests.cpu`    | Spark master CPUs                      | `250m`  |
| `spark.master.resources.requests.memory` | Spark master requested memory          | `5Gi`   |
| `spark.master.affinity.podAntiAffinity`  | Anti affinity rules set for resiliency | `{}`    |
| `spark.worker.replicaCount`              | Number of spark workers                | `2`     |
| `spark.worker.webPort`                   | Web port for spark master              | `8081`  |
| `spark.worker.resources.limits`          | Spark master resource limits           | `{}`    |
| `spark.worker.resources.requests.cpu`    | Spark master CPUs                      | `250m`  |
| `spark.worker.resources.requests.memory` | Spark master requested memory          | `5Gi`   |
| `spark.worker.affinity.podAntiAffinity`  | Anti affinity rules set for resiliency | `{}`    |
| `spark.metrics.enabled`                  | Enable Prometheus exporter for Spark   | `false` |
| `spark.metrics.masterAnnotations`        | Annotations for Spark master exporter  | `{}`    |
| `spark.metrics.workerAnnotations`        | Annotations for Spark worker exporter  | `{}`    |


### Elasticsearch parameters

| Name                                                   | Description                                  | Value   |
| ------------------------------------------------------ | -------------------------------------------- | ------- |
| `elasticsearch.enabled`                                | Enable Elasticsearch                         | `true`  |
| `elasticsearch.global.kibanaEnabled`                   | Enable Kibana                                | `true`  |
| `elasticsearch.master.replicas`                        | Number of Elasticsearch replicas             | `3`     |
| `elasticsearch.master.heapSize`                        | Heap Size for Elasticsearch master           | `768m`  |
| `elasticsearch.master.affinity.podAntiAffinity`        | Elasticsearch pod anti affinity              | `{}`    |
| `elasticsearch.master.resources.limits`                | Elasticsearch master resource limits         | `{}`    |
| `elasticsearch.master.resources.requests.cpu`          | Elasticsearch master CPUs                    | `250m`  |
| `elasticsearch.master.resources.requests.memory`       | Elasticsearch master requested memory        | `1Gi`   |
| `elasticsearch.master.affinity.podAntiAffinity`        | Anti affinity rules set for resiliency       | `{}`    |
| `elasticsearch.data.name`                              | Elasticsearch data node name                 | `data`  |
| `elasticsearch.data.replicas`                          | Number of Elasticsearch replicas             | `2`     |
| `elasticsearch.data.heapSize`                          | Heap Size for Elasticsearch data node        | `4096m` |
| `elasticsearch.data.affinity.podAntiAffinity`          | Anti affinity rules set for resiliency       | `{}`    |
| `elasticsearch.data.resources.limits`                  | Elasticsearch data node resource limits      | `{}`    |
| `elasticsearch.data.resources.requests.cpu`            | Elasticsearch data node CPUs                 | `250m`  |
| `elasticsearch.data.resources.requests.memory`         | Elasticsearch data node requested memory     | `5Gi`   |
| `elasticsearch.coordinating.replicas`                  | Number of Elasticsearch replicas             | `2`     |
| `elasticsearch.coordinating.heapSize`                  | Heap Size for Elasticsearch coordinating     | `768m`  |
| `elasticsearch.coordinating.affinity.podAntiAffinity`  | Anti affinity rules set for resiliency       | `{}`    |
| `elasticsearch.coordinating.resources.limits`          | Elasticsearch coordinating resource limits   | `{}`    |
| `elasticsearch.coordinating.resources.requests.cpu`    | Elasticsearch coordinating CPUs              | `250m`  |
| `elasticsearch.coordinating.resources.requests.memory` | Elasticsearch coordinating requested memory  | `1Gi`   |
| `elasticsearch.metrics.enabled`                        | Enable Prometheus exporter for Elasticsearch | `false` |
| `elasticsearch.metrics.resources.limits`               | Elasticsearch metrics resource limits        | `{}`    |
| `elasticsearch.metrics.resources.requests.cpu`         | Elasticsearch metrics CPUs                   | `100m`  |
| `elasticsearch.metrics.resources.requests.memory`      | Elasticsearch metrics requested memory       | `128Mi` |
| `elasticsearch.metrics.service.annotations`            | Elasticsearch metrics service annotations    | `{}`    |


### Logstash parameters

| Name                                         | Description                                           | Value    |
| -------------------------------------------- | ----------------------------------------------------- | -------- |
| `logstash.enabled`                           | Enable Logstash                                       | `true`   |
| `logstash.replicaCount`                      | Number of Logstash replicas                           | `2`      |
| `logstash.affinity.podAntiAffinity`          | Logstash pod anti affinity                            | `{}`     |
| `logstash.extraEnvVars`                      | Array containing extra env vars to configure Logstash | `[]`     |
| `logstash.resources.limits`                  | Elasticsearch metrics resource limits                 | `{}`     |
| `logstash.resources.requests.cpu`            | Elasticsearch metrics CPUs                            | `250m`   |
| `logstash.resources.requests.memory`         | Elasticsearch metrics requested memory                | `1500Mi` |
| `logstash.metrics.enabled`                   | Enable metrics for logstash                           | `false`  |
| `logstash.metrics.resources.limits`          | Elasticsearch metrics resource limits                 | `{}`     |
| `logstash.metrics.resources.requests.cpu`    | Elasticsearch metrics CPUs                            | `100m`   |
| `logstash.metrics.resources.requests.memory` | Elasticsearch metrics requested memory                | `128Mi`  |
| `logstash.metrics.service.port`              | Logstash Prometheus port                              | `9198`   |


### Tanzu Observability (Wavefront) parameters

| Name                                                 | Description                                         | Value                                |
| ---------------------------------------------------- | --------------------------------------------------- | ------------------------------------ |
| `wavefront.enabled`                                  | Enable Tanzu Observability Framework                | `false`                              |
| `wavefront.clusterName`                              | Cluster name                                        | `KUBERNETES_CLUSTER_NAME`            |
| `wavefront.wavefront.url`                            | Tanzu Observability cluster URL                     | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.wavefront.token`                          | Tanzu Observability access token                    | `YOUR_API_TOKEN`                     |
| `wavefront.wavefront.existingSecret`                 | Tanzu Observability existing secret                 | `""`                                 |
| `wavefront.collector.resources.limits`               | Wavefront collector metrics resource limits         | `{}`                                 |
| `wavefront.collector.resources.requests.cpu`         | Wavefront collector metrics CPUs                    | `200m`                               |
| `wavefront.collector.resources.requests.memory`      | Wavefront collector metrics requested memory        | `10Mi`                               |
| `wavefront.collector.discovery.enabled`              | Enable wavefront discovery                          | `true`                               |
| `wavefront.collector.discovery.enableRuntimeConfigs` | Enable runtime configs for wavefront discovery      | `true`                               |
| `wavefront.collector.discovery.config`               | Wavefront discovery config                          | `[]`                                 |
| `wavefront.collector.discovery.enabled`              | Rules based and Prometheus endpoints auto-discovery | `true`                               |
| `wavefront.collector.discovery.enableRuntimeConfigs` | Enable runtime discovery rules                      | `true`                               |
| `wavefront.collector.discovery.config`               | Configuration for rules based auto-discovery        | `[]`                                 |
| `wavefront.proxy.resources.limits`                   | Wavefront Proxy metrics resource limits             | `{}`                                 |
| `wavefront.proxy.resources.requests.cpu`             | Wavefront Proxy metrics CPUs                        | `100m`                               |
| `wavefront.proxy.resources.requests.memory`          | Wavefront Proxy metrics requested memory            | `5Gi`                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set kafka.replicaCount=3 \
  bitnami/dataplatform-bp2
```

The above command deploys the data platform with Kafka with 3 nodes (replicas).

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example

```console
$ helm install my-release -f values.yaml bitnami/dataplatform-bp2
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Data Platform Deployment with Observability Framework

In the default deployment, the helm chart deploys the data platform with [Metrics Emitter](https://hub.docker.com/r/bitnami/dataplatform-emitter) and [Prometheus Exporter](https://hub.docker.com/r/bitnami/dataplatform-exporter) which emit the health metrics of the data platform which can be integrated with your observability solution.

- To deploy the data platform with Tanzu Observability Framework with the Wavefront Collector with enabled annotation based discovery feature for all the applications (Kafka/Spark/Elasticsearch/Logstash) in the data platform, make sure that auto discovery `wavefront.collector.discovery.enabled=true` is enabled, It should be enabled by default and specify the 'enabled' parameter using the ` --set <component>.metrics.enabled=true` argument to helm install. For Example,

```console
$ helm install my-release bitnami/dataplatform-bp2 \
    --set kafka.metrics.kafka.enabled=true \
    --set kafka.metrics.jmx.enabled=true \
    --set spark.metrics.enabled=true \
    --set elasticsearch.metrics.enabled=true \
    --set logstash.metrics.enabled=true \
    --set wavefront.enabled=true \
    --set wavefront.clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```
> **NOTE**: When Annotation based discovery feature is enabled in the Wavefront Collector, it scrapes metrics from all the pods in the cluster that have Prometheus annotation enabled.

- To deploy the data platform with Tanzu Observability Framework without the annotation based discovery feature in Wavefront Collector for all the applications (Kafka/Spark/Elasticsearch/Logstash) in the data platform, uncomment the config section in the wavefront deployment from the data platform values.yml file, and specify the 'enable' parameter to 'false' using the `--set wavefront.collector.discovery.enabled=false`  with `helm install` command, below is an example:

```console
$ helm install my-release bitnami/dataplatform-bp2 \
    --set kafka.metrics.kafka.enabled=true \
    --set kafka.metrics.jmx.enabled=true \
    --set spark.metrics.enabled=true \
    --set elasticsearch.metrics.enabled=true \
    --set logstash.metrics.enabled=true \
    --set wavefront.enabled=true \
    --set wavefront.collector.discovery.enabled=false \
    --set wavefront.clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```
### For using an existing Wavefront deployment

- To enable the auto discovery feature in wavefront for the existing wavefront deployment, make sure that auto discovery `enableDiscovery: true` and annotation based discovery `discovery.disable_annotation_discovery: false` are enabled in the Wavefront Collector ConfigMap. They should be enabled by default.

- To not use the annotation based discovery feature in wavefront, edit the Wavefront Collector ConfigMap and add the following snippet under discovery plugins. Once done, restart the wavefront collectors DaemonSet.

```console
$ kubectl edit configmap wavefront-collector-config -n wavefront
```

Add the below config:

```console
      discovery:
        enable_runtime_plugins: true
        plugins:
        ## auto-discover kafka-exporter
        - name: kafka-discovery
          type: prometheus
          selectors:
            images:
              - '*bitnami/kafka-exporter*'
          port: 9308
          path: /metrics
          scheme: http

        ## auto-discover jmx exporter
        - name: kafka-jmx-discovery
          type: prometheus
          selectors:
            images:
              - '*bitnami/jmx-exporter*'
          port: 5556
          path: /metrics
          scheme: http
          prefix: kafkajmx.

        ## auto-discover elasticsearch
        - name: elasticsearch-discovery
          type: prometheus
          selectors:
            images:
              - '*bitnami/elasticsearch-exporter*'
          port: 9114
          path: /metrics
          scheme: http

        ## auto-discover logstash
        - name: logstash-discovery
          type: prometheus
          selectors:
            images:
              - '*bitnami/logstash-exporter*'
          port: 9198
          path: /metrics
          scheme: http

        ## auto-discover spark
        - name: spark-worker-discovery
          type: prometheus
          selectors:
            images:
              - '*bitnami/spark*'
          port: 8081
          path: /metrics/
          scheme: http
          prefix: spark.

        ## auto-discover spark
        - name: spark-master-discovery
          type: prometheus
          selectors:
            images:
              - '*bitnami/spark*'
          port: 8080
          path: /metrics/
          scheme: http
          prefix: spark.
```

Below is the command to restart the DaemonSets

```console
$ kubectl rollout restart daemonsets wavefront-collector -n wavefront
```

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

In order to render complete information about the deployment including all the sub-charts, please use --render-subchart-notes flag while installing the chart.

## Notable changes

### 0.3.0

Elasticsearch dependency version was bumped to a new major version changing the license of some of its components to the [Elastic License](https://www.elastic.co/licensing/elastic-license) that is not currently accepted as an Open Source license by the Open Source Initiative (OSI). Check [Elasticsearch Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch#to-1500) for more information.

Regular upgrade is compatible from previous versions.

## Upgrading

### To 9.0.0

This major adds annotation based discovery feature in wavefront and updates to newest versions of the exporter/emitter to the chart.

### To 8.0.0

This major adds the data platform metrics emitter and Prometheus exporters to the chart which emit health metrics of the data platform.

### To 7.0.0

This major updates the Elasticsearch subchart to its newest major, 17.0.0, which adds support for X-pack security features such as SSL/TLS encryption and password protection. Check [Elasticsearch Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch#to-1700) for more information.

### To 6.0.0

This major version updates resources for elasticsearch and logstash values. Also updates the README file with instructions on how to enable existing Wavefront deployment for the data platform blueprint.

### To 5.0.0

This major updates the Kafka subchart its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1400) you can find more information about the changes introduced in this version.

### To 4.0.0

This major updates the Kafka subchart to its newest major 13.0.0. For more information on this subchart's major, please refer to [kafka upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1300).

### To 3.0.0

This major version updates the prefixes of individual applications metrics in Wavefront Collectors which are fed to Tanzu observability in order to light up the individual dashboards of Kafka, Spark ElasticSearch and Logstash on Tanzu Observability platform.

### To 2.0.0

This major updates the wavefront subchart to it newest major, 3.0.0, which contains a new major for kube-state-metrics. For more information on this subchart's major, please refer to [wavefront upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/wavefront#to-300).

### To 1.0.0

The affinity rules have been updated to allow deploying this chart and the `dataplatform-bp1` chart in the same cluster.

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
