<!--- app-name: Data Platform Blueprint 1 -->

# Data Platform Blueprint 1 with Kafka-Spark-Solr

This Helm chart enables the fully automated Kubernetes deployment of such multi-stack data platform including Zookeeper, Kafka, Solr, Spark and dataplatform exporters

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/dataplatform-bp1
```

## Introduction

Enterprise applications increasingly rely on large amounts of data, that needs be distributed, processed, and stored.
Open source and commercial supported software stacks are available to implement a data platform, that can offer
common data management services, accelerating the development and deployment of data hungry business applications.

This Helm chart enables the fully automated Kubernetes deployment of such multi-stack data platform, covering the following software components:

-   Apache Kafka – Data distribution bus with buffering capabilities
-   Apache Spark – In-memory data analytics
-   Solr – Data persistence and search
-   Data Platform Signature State Controller – Kubernetes controller that emits data platform health and state metrics in Prometheus format.

These containerized stateful software stacks are deployed in multi-node cluster configurations, which is defined by the
Helm chart blueprint for this data platform deployment, covering:

-   Pod placement rules – Affinity rules to ensure placement diversity to prevent single point of failures and optimize load distribution
-   Pod resource sizing rules – Optimized Pod and JVM sizing settings for optimal performance and efficient resource usage
-   Default settings to ensure Pod access security
-   Optional [Tanzu Observability](https://docs.wavefront.com/kubernetes.html) framework configuration

In addition to the Pod resource optimizations, this blueprint is validated and tested to provide Kubernetes node count and sizing recommendations [(see Kubernetes Cluster Requirements)](#kubernetes-cluster-requirements) to facilitate cloud platform capacity planning. The goal is optimize the number of required Kubernetes nodes in order to optimize server resource usage and, at the same time, ensuring runtime and resource diversity.

This blueprint, in its default configuration, deploys the data platform, on a Kubernetes cluster with three worker nodes. Use cases for this data platform setup include: data and application evaluation, development, and functional testing.

This chart bootstraps Data Platform Blueprint-1 deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Once the chart is installed, the deployed data platform cluster comprises of:
1. Zookeeper with 3 nodes to be used for both Kafka and Solr
2. Kafka with 3 nodes using the zookeeper deployed above
3. Solr with 2 nodes using the zookeeper deployed above
4. Spark with 1 Master and 2 worker nodes
5. Data Platform Metrics emitter and Prometheus exporter

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
$ helm install my-release bitnami/dataplatform-bp1
```

These commands deploy Data Platform on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists recommended configurations of the parameters to bring up an optimal and resilient data platform. Please refer the individual charts for the remaining set of configurable parameters.

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
| `dataplatform.exporter.service.annotations`                   | Metrics exporter service annotations                                                                             | `{}`                            |
| `dataplatform.exporter.service.labels`                        | Additional labels for Data Platform exporter service                                                             | `{}`                            |
| `dataplatform.exporter.service.ports.http`                    | Kubernetes Service port                                                                                          | `9090`                          |
| `dataplatform.exporter.service.loadBalancerIP`                | Load balancer IP for the Data Platform Exporter Service (optional, cloud specific)                               | `""`                            |
| `dataplatform.exporter.service.nodePorts.http`                | Node ports for the HTTP exporter service                                                                         | `""`                            |
| `dataplatform.exporter.service.loadBalancerSourceRanges`      | Exporter Load Balancer Source ranges                                                                             | `[]`                            |
| `dataplatform.exporter.hostAliases`                           | Deployment pod host aliases                                                                                      | `[]`                            |
| `dataplatform.emitter.enabled`                                | Start Data Platform metrics emitter                                                                              | `true`                          |
| `dataplatform.emitter.image.registry`                         | Data Platform emitter image registry                                                                             | `docker.io`                     |
| `dataplatform.emitter.image.repository`                       | Data Platform emitter image repository                                                                           | `bitnami/dataplatform-emitter`  |
| `dataplatform.emitter.image.tag`                              | Data Platform emitter image tag (immutable tags are recommended)                                                 | `1.0.1-scratch-r0`              |
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


### Zookeeper chart parameters

| Name                                 | Description                                                                               | Value  |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | ------ |
| `zookeeper.enabled`                  | Switch to enable or disable the Zookeeper helm chart                                      | `true` |
| `zookeeper.replicaCount`             | Number of Zookeeper replicas                                                              | `3`    |
| `zookeeper.heapSize`                 | Size in MB for the Java Heap options (Xmx and XMs).                                       | `4096` |
| `zookeeper.resources.limits`         | The resources limits for Zookeeper containers                                             | `{}`   |
| `zookeeper.resources.requests`       | The requested resources for Zookeeper containers                                          | `{}`   |
| `zookeeper.affinity.podAntiAffinity` | Zookeeper pods Anti Affinity rules for best possible resiliency (evaluated as a template) | `{}`   |


### Kafka chart parameters

| Name                                     | Description                                                                               | Value                               |
| ---------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------- |
| `kafka.enabled`                          | Switch to enable or disable the Kafka helm chart                                          | `true`                              |
| `kafka.replicaCount`                     | Number of Kafka replicas                                                                  | `3`                                 |
| `kafka.heapOpts`                         | Kafka's Java Heap size                                                                    | `-Xmx4096m -Xms4096m`               |
| `kafka.resources.limits`                 | The resources limits for Kafka containers                                                 | `{}`                                |
| `kafka.resources.requests`               | The requested resources for Kafka containers                                              | `{}`                                |
| `kafka.affinity.podAntiAffinity`         | Zookeeper pods Anti Affinity rules for best possible resiliency (evaluated as a template) | `{}`                                |
| `kafka.affinity.podAffinity`             | Zookeeper pods Affinity rules for best possible resiliency (evaluated as a template)      | `{}`                                |
| `kafka.metrics.kafka.enabled`            | Whether or not to create a standalone Kafka exporter to expose Kafka metrics              | `false`                             |
| `kafka.metrics.kafka.resources.limits`   | The resources limits for the container                                                    | `{}`                                |
| `kafka.metrics.kafka.resources.requests` | Kafka Exporter container resource requests                                                | `{}`                                |
| `kafka.metrics.kafka.service.port`       | Kafka Exporter Prometheus port to be used in Wavefront configuration                      | `9308`                              |
| `kafka.metrics.jmx.enabled`              | Whether or not to expose JMX metrics to Prometheus                                        | `false`                             |
| `kafka.metrics.jmx.resources.limits`     | The resources limits for the container                                                    | `{}`                                |
| `kafka.metrics.jmx.resources.requests`   | JMX Exporter container resource requests                                                  | `{}`                                |
| `kafka.metrics.jmx.service.port`         | JMX Exporter Prometheus port                                                              | `5556`                              |
| `kafka.metrics.jmx.service.annotations`  | Exporter service annotation                                                               | `{}`                                |
| `kafka.zookeeper.enabled`                | Switch to enable or disable the Zookeeper helm chart                                      | `false`                             |
| `kafka.externalZookeeper.servers`        | Server or list of external Zookeeper servers to use                                       | `["{{ .Release.Name }}-zookeeper"]` |


### Solr chart parameters

| Name                                 | Description                                                                                    | Value                               |
| ------------------------------------ | ---------------------------------------------------------------------------------------------- | ----------------------------------- |
| `solr.enabled`                       | Switch to enable or disable the Solr helm chart                                                | `true`                              |
| `solr.replicaCount`                  | Number of Solr replicas                                                                        | `2`                                 |
| `solr.authentication.enabled`        | Enable Solr authentication. BUG: Exporter deployment does not work with authentication enabled | `false`                             |
| `solr.javaMem`                       | Java recommended memory options to pass to the Solr container                                  | `-Xmx4096m -Xms4096m`               |
| `solr.affinity.podAntiAffinity`      | Zookeeper pods Anti Affinity rules for best possible resiliency (evaluated as a template)      | `{}`                                |
| `solr.resources.limits`              | The resources limits for Solr containers                                                       | `{}`                                |
| `solr.resources.requests`            | The requested resources for Solr containers                                                    | `{}`                                |
| `solr.exporter.enabled`              | Start a prometheus exporter                                                                    | `false`                             |
| `solr.exporter.port`                 | Solr exporter port                                                                             | `9983`                              |
| `solr.exporter.affinity.podAffinity` | Zookeeper pods Affinity rules for best possible resiliency (evaluated as a template)           | `{}`                                |
| `solr.exporter.resources.limits`     | The resources limits for the container                                                         | `{}`                                |
| `solr.exporter.resources.requests`   | The requested resources for the container                                                      | `{}`                                |
| `solr.exporter.service.annotations`  | Exporter service annotations                                                                   | `{}`                                |
| `solr.zookeeper.enabled`             | Enable Zookeeper deployment. Needed for Solr cloud.                                            | `false`                             |
| `solr.externalZookeeper.servers`     | Servers for an already existing Zookeeper.                                                     | `["{{ .Release.Name }}-zookeeper"]` |


### Spark chart parameters

| Name                                    | Description                                                                               | Value   |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | ------- |
| `spark.enabled`                         | Switch to enable or disable the Spark helm chart                                          | `true`  |
| `spark.master.webPort`                  | Specify the port where the web interface will listen on the master                        | `8080`  |
| `spark.master.resources.limits`         | The resources limits for the container                                                    | `{}`    |
| `spark.master.resources.requests`       | The resources limits for the container                                                    | `{}`    |
| `spark.master.affinity.podAntiAffinity` | Zookeeper pods Anti Affinity rules for best possible resiliency (evaluated as a template) | `{}`    |
| `spark.worker.replicaCount`             | Set the number of workers                                                                 | `2`     |
| `spark.worker.webPort`                  | Specify the port where the web interface will listen on the worker                        | `8081`  |
| `spark.worker.affinity.podAntiAffinity` | Zookeeper pods Anti Affinity rules for best possible resiliency (evaluated as a template) | `{}`    |
| `spark.worker.resources.limits`         | The resources limits for the container                                                    | `{}`    |
| `spark.worker.resources.requests`       | The resources limits for the container                                                    | `{}`    |
| `spark.metrics.enabled`                 | Start a side-car Prometheus exporter                                                      | `false` |
| `spark.metrics.masterAnnotations`       | Annotations for enabling prometheus to access the metrics endpoint of the master nodes    | `{}`    |
| `spark.metrics.workerAnnotations`       | Annotations for enabling prometheus to access the metrics endpoint of the worker nodes    | `{}`    |


### Tanzu Observability (Wavefront) chart parameters

| Name                                                 | Description                                          | Value                                |
| ---------------------------------------------------- | ---------------------------------------------------- | ------------------------------------ |
| `wavefront.enabled`                                  | Switch to enable or disable the Wavefront helm chart | `false`                              |
| `wavefront.clusterName`                              | Unique name for the Kubernetes cluster (required)    | `KUBERNETES_CLUSTER_NAME`            |
| `wavefront.wavefront.url`                            | Wavefront URL for your cluster (required)            | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.wavefront.token`                          | Wavefront API Token (required)                       | `YOUR_API_TOKEN`                     |
| `wavefront.wavefront.existingSecret`                 | Name of an existing secret containing the token      | `""`                                 |
| `wavefront.collector.resources.limits`               | The resources limits for the collector container     | `{}`                                 |
| `wavefront.collector.resources.requests`             | The requested resources for the collector container  | `{}`                                 |
| `wavefront.collector.discovery.enabled`              | Rules based and Prometheus endpoints auto-discovery  | `true`                               |
| `wavefront.collector.discovery.enableRuntimeConfigs` | Enable runtime discovery rules                       | `true`                               |
| `wavefront.collector.discovery.config`               | Configuration for rules based auto-discovery         | `[]`                                 |
| `wavefront.proxy.resources.limits`                   | The resources limits for the proxy container         | `{}`                                 |
| `wavefront.proxy.resources.requests`                 | The requested resources for the proxy container      | `{}`                                 |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set kafka.replicaCount=3 \
  bitnami/dataplatform-bp1
```

The above command deploys the data platform with Kafka with 3 nodes (replicas).

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/dataplatform-bp1
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Data Platform Deployment with Observability Framework

In the default deployment, the helm chart deploys the data platform with [Metrics Emitter](https://hub.docker.com/r/bitnami/dataplatform-emitter) and [Prometheus Exporter](https://hub.docker.com/r/bitnami/dataplatform-exporter) which emit the health metrics of the data platform which can be integrated with your observability solution.

- To deploy the data platform with Tanzu Observability Framework with the Wavefront Collector with enabled annotation based discovery feature for all the applications (Kafka/Spark/Elasticsearch/Logstash) in the data platform, make sure that auto discovery `wavefront.collector.discovery.enabled=true` is enabled, It should be enabled by default and specify the 'enabled' parameter using the `--set <component>.metrics.enabled=true` argument to helm install. For Example,

```console
$ helm install my-release bitnami/dataplatform-bp1 \
    --set kafka.metrics.kafka.enabled=true \
    --set kafka.metrics.jmx.enabled=true \
    --set spark.metrics.enabled=true \
    --set solr.exporter.enabled=true \
    --set wavefront.enabled=true \
    --set wavefront.clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```
> **NOTE**: When the annotation based discovery feature is enabled in the Wavefront Collector, it scrapes metrics from all the pods that have Prometheus annotation enabled.

- To deploy the data platform with Tanzu Observability Framework without the annotation based discovery feature in Wavefront Collector for all the applications (Kafka/Spark/Elasticsearch/Logstash) in the data platform, uncomment the config section in the wavefront deployment from the data platform values.yml file, and specify the 'enable' parameter to 'false' using the `--set wavefront.collector.discovery.enabled=false`  with helm install command, below is an example:

```console

$ helm install my-release bitnami/dataplatform-bp1 \
    --set kafka.metrics.kafka.enabled=true \
    --set kafka.metrics.jmx.enabled=true \
    --set spark.metrics.enabled=true \
    --set solr.exporter.enabled=true \
    --set wavefront.enabled=true \
    --set wavefront.collector.discovery.enabled=false \
    --set wavefront.clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```

### For using an existing Wavefront deployment

- To enable the annotation discovery feature in wavefront for the existing wavefront deployment,  make sure that auto discovery `enableDiscovery: true` and annotation based discovery `discovery.disable_annotation_discovery: false` are enabled in the Wavefront Collector ConfigMap. They should be enabled by default.

- To not use the annotation based discovery feature in wavefront, edit the Wavefront Collector ConfigMap and add the following snippet under discovery plugins. Once done, restart the wavefront collectors DaemonSet.

```console
$ kubectl edit configmap wavefront-collector-config -n wavefront
```

Add the below config:

```yaml
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

        ## auto-discover solr
        - name: solr-discovery
          type: prometheus
          selectors:
            images:
              - '*bitnami/solr*'
          port: 9983
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

## Upgrading

### To 9.0.0

This major adds the auto discovery feature in wavefront and updates to newest versions of the exporter/emitter to the chart.

### To 8.0.0

This major adds the data platform metrics emitter and Prometheus exporters to the chart which emit health metrics of the data platform.

### To 7.0.0

This major updates the Kafka subchart and the Solr subchart to their newest major, 14.0.0 and 2.0.0 respectively. [Here](https://github.com/bitnami/charts/pull/7114) you can find more information about the changes introduced in those versions.

### To 6.0.0

This major updates the Kafka subchart and the Solr subchart to their newest major, 13.0.0 and 1.0.0 respectively.

### To 5.0.0

This major updates the Zookeeper subchart to it newest major, 7.0.0, which renames all TLS-related settings. For more information on this subchart's major, please refer to [zookeeper upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/zookeeper#to-700).

### To 4.0.0

This major version updates the prefixes of individual applications metrics in Wavefront Collectors which are fed to Tanzu observability in order to light up the individual dashboards of Kafka, Spark and Solr on Tanzu Observability platform.

### To 3.0.0

This major updates the wavefront subchart to it newest major, 3.0.0, which contains a new major for kube-state-metrics. For more information on this subchart's major, please refer to [wavefront upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/wavefront#to-300).

### To 2.0.0

The affinity rules have been updated to allow deploying this chart and the `dataplatform-bp2` chart in the same cluster.

### To 1.0.0

This version updates the wavefront dependency to `2.x.x` where wavefront started to use a scratch image instead of debian. This can affect a current deployment if wavefront commands were provided. From now on, the only command that you will be able to execute inside the wavefront pod will be `/wavefront-collector`.

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
