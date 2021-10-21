# Data Platform Blueprint 3 with RabbitMQ-Geode-Postgres

Enterprise applications increasingly rely on large amounts of data, that needs be distributed, processed, and stored.
Open source and commercial supported software stacks are available to implement a data platform, that can offer
common data management services, accelerating the development and deployment of data hungry business applications.

This Helm chart enables the fully automated Kubernetes deployment of such multi-stack data platform, covering the following software components:

-   VMware Tanzu RabbitMQ – Message Broker for modern applications
-   Apache Geode – An in-memory data grid
-   PostgreSQL – Powerful Open-source relational database management system
-   Data Platform Signature State Controller – Kubernetes controller that emits data platform health and state metrics in Prometheus format.

These containerized stateful software stacks are deployed in multi-node cluster configurations, which is defined by the
Helm chart blueprint for this data platform deployment, covering:

-   Pod placement rules – Affinity rules to ensure placement diversity to prevent single point of failures and optimize load distribution
-   Pod resource sizing rules – Optimized Pod and JVM sizing settings for optimal performance and efficient resource usage
-   Default settings to ensure Pod access security
-   Optional [Tanzu Observability](https://docs.wavefront.com/kubernetes.html) framework configuration 

In addition to the Pod resource optimizations, this blueprint is validated and tested to provide Kubernetes node count and sizing recommendations [(see Kubernetes Cluster Requirements)](#kubernetes-cluster-requirements) to facilitate cloud platform capacity planning. The goal is optimize the number of required Kubernetes nodes in order to optimize server resource usage and, at the same time, ensuring runtime and resource diversity.

This blueprint, in its default configuration, deploys the data platform on a Kubernetes cluster with three worker nodes. Use cases for this data platform setup include: data and application evaluation, development, and functional testing.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/dataplatform-bp3
```

## Introduction

This chart bootstraps Data Platform Blueprint3 with RabbitMQ, Apache Geode and PostgreSQL deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Once the chart is installed, the deployed data platform cluster comprises of:  
1. Apache Geode Cluster with 3 Servers and 2 Locators 
2. RabbitMQ Cluster with 3 Servers with operator to manage the same
3. 3 node PostgreSQL cluster with high availability
4. Data Platform Signature State Controller 

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
$ helm install my-release bitnami/dataplatform-bp3
```

These commands deploy Data Platform on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists recommended configurations of the parameters to bring up an optimal and resilient data platform. Please refer the individual charts for the remaining set of configurable parameters.

> **Tip**: List all releases using `helm list`

> **Recommendation**: It is a recommended best practice to create a dedicated namespace for the data platform cluster and deploy the data platform helm chart in the same.

## Uninstalling the Chart

Before uninstalling the chart, please ensure you have deleted the RabbitMQ custom resources.

To Delete the RabbitMQ custom resources:

```console
$ kubectl delete rabbitmqcluster.rabbitmq.com/rabbitmq-custom-configuration
```

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

After deleting the Chart make sure you delete the pvc's.

To delete the pvc's:

```console
$ kubectl delete pvc <pvc_name>
```

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                | Value |
| ------------------- | ------------------------------------------ | ----- |
| `commonLabels`      | Labels to add to all deployed objects      | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects | `{}`  |


### Data Platform Chart parameters

| Name                                                          | Description                                                                                                      | Value                                       |
| ------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `dataplatform.serviceAccount.create`                          | Specifies whether a ServiceAccount should be created                                                             | `true`                                      |
| `dataplatform.serviceAccount.name`                            | The name of the ServiceAccount to create                                                                         | `""`                                        |
| `dataplatform.serviceAccount.automountServiceAccountToken`    | Allows auto mount of ServiceAccountToken on the serviceAccount created                                           | `true`                                      |
| `dataplatform.rbac.create`                                    | Whether to create & use RBAC resources or not                                                                    | `true`                                      |
| `dataplatform.exporter.enabled`                               | Start a prometheus exporter                                                                                      | `true`                                      |
| `dataplatform.exporter.image.registry`                        | dataplatform exporter image registry                                                                             | `harbor-repo.vmware.com`                    |
| `dataplatform.exporter.image.repository`                      | dataplatform exporter image repository                                                                           | `octo_data_platforms/dataplatform-exporter` |
| `dataplatform.exporter.image.tag`                             | dataplatform exporter image tag (immutable tags are recommended)                                                 | `1.0.0`                                     |
| `dataplatform.exporter.image.pullPolicy`                      | dataplatform exporter image pull policy                                                                          | `IfNotPresent`                              |
| `dataplatform.exporter.image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                 | `[]`                                        |
| `dataplatform.exporter.config`                                | Data Platform Metrics Configuration emitted in Prometheus format                                                 | `""`                                        |
| `dataplatform.exporter.livenessProbe.enabled`                 | Enable livenessProbe                                                                                             | `true`                                      |
| `dataplatform.exporter.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                          | `10`                                        |
| `dataplatform.exporter.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                 | `5`                                         |
| `dataplatform.exporter.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                | `15`                                        |
| `dataplatform.exporter.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                              | `15`                                        |
| `dataplatform.exporter.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                              | `1`                                         |
| `dataplatform.exporter.readinessProbe.enabled`                | Enable readinessProbe                                                                                            | `true`                                      |
| `dataplatform.exporter.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                         | `10`                                        |
| `dataplatform.exporter.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                | `5`                                         |
| `dataplatform.exporter.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                               | `15`                                        |
| `dataplatform.exporter.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                             | `15`                                        |
| `dataplatform.exporter.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                             | `15`                                        |
| `dataplatform.exporter.startupProbe.enabled`                  | Enable startupProbe                                                                                              | `false`                                     |
| `dataplatform.exporter.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                           | `10`                                        |
| `dataplatform.exporter.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                  | `5`                                         |
| `dataplatform.exporter.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                 | `15`                                        |
| `dataplatform.exporter.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                               | `15`                                        |
| `dataplatform.exporter.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                               | `15`                                        |
| `dataplatform.exporter.containerPorts.http`                   | Data Platform Prometheus exporter port                                                                           | `9090`                                      |
| `dataplatform.exporter.priorityClassName`                     | exporter priorityClassName                                                                                       | `""`                                        |
| `dataplatform.exporter.command`                               | Override Data Platform Exporter entrypoint string.                                                               | `[]`                                        |
| `dataplatform.exporter.args`                                  | Arguments for the provided command if needed                                                                     | `[]`                                        |
| `dataplatform.exporter.resources.limits`                      | The resources limits for the container                                                                           | `{}`                                        |
| `dataplatform.exporter.resources.requests.cpu`                | The requested resources for the container                                                                        | `200m`                                      |
| `dataplatform.exporter.resources.requests.memory`             | The requested resources for the container                                                                        | `10Mi`                                      |
| `dataplatform.exporter.containerSecurityContext.enabled`      | Enable Data Platform exporter containers' Security Context                                                       | `true`                                      |
| `dataplatform.exporter.containerSecurityContext.runAsUser`    | User ID for the containers.                                                                                      | `1001`                                      |
| `dataplatform.exporter.containerSecurityContext.runAsNonRoot` | Enable Data Platform exporter containers' Security Context runAsNonRoot                                          | `true`                                      |
| `dataplatform.exporter.podSecurityContext.enabled`            | Enable Data Platform exporter pods' Security Context                                                             | `true`                                      |
| `dataplatform.exporter.podSecurityContext.fsGroup`            | Group ID for the pods.                                                                                           | `1001`                                      |
| `dataplatform.exporter.podAffinityPreset`                     | Data Platform exporter pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                        |
| `dataplatform.exporter.podAntiAffinityPreset`                 | Data Platform exporter pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                      |
| `dataplatform.exporter.nodeAffinityPreset.type`               | Data Platform exporter node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                        |
| `dataplatform.exporter.nodeAffinityPreset.key`                | Data Platform exporter node label key to match Ignored if `affinity` is set.                                     | `""`                                        |
| `dataplatform.exporter.nodeAffinityPreset.values`             | Data Platform exporter node label values to match. Ignored if `affinity` is set.                                 | `[]`                                        |
| `dataplatform.exporter.nodeSelector`                          | Node labels for exporter pods assignment. Evaluated as a template                                                | `{}`                                        |
| `dataplatform.exporter.tolerations`                           | Tolerations for exporter pods assignment. Evaluated as a template                                                | `[]`                                        |
| `dataplatform.exporter.podLabels`                             | Additional labels for Metrics exporter pod                                                                       | `{}`                                        |
| `dataplatform.exporter.podAnnotations`                        | Additional annotations for Metrics exporter pod                                                                  | `{}`                                        |
| `dataplatform.exporter.customLivenessProbe`                   | Override default liveness probe                                                                                  | `{}`                                        |
| `dataplatform.exporter.customReadinessProbe`                  | Override default readiness probe                                                                                 | `{}`                                        |
| `dataplatform.exporter.customStartupProbe`                    | Override default startup probe                                                                                   | `{}`                                        |
| `dataplatform.exporter.updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached                                   | `RollingUpdate`                             |
| `dataplatform.exporter.updateStrategy.rollingUpdate`          | Deployment rolling update configuration parameters                                                               | `{}`                                        |
| `dataplatform.exporter.extraEnvVars`                          | Additional environment variables to set                                                                          | `[]`                                        |
| `dataplatform.exporter.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                                       | `""`                                        |
| `dataplatform.exporter.extraEnvVarsSecret`                    | Secret with extra environment variables                                                                          | `""`                                        |
| `dataplatform.exporter.extraVolumes`                          | Extra volumes to add to the deployment                                                                           | `[]`                                        |
| `dataplatform.exporter.extraVolumeMounts`                     | Extra volume mounts to add to the container                                                                      | `[]`                                        |
| `dataplatform.exporter.initContainers`                        | Add init containers to the %%MAIN_CONTAINER_NAME%% pods                                                          | `[]`                                        |
| `dataplatform.exporter.sidecars`                              | Add sidecars to the %%MAIN_CONTAINER_NAME%% pods                                                                 | `[]`                                        |
| `dataplatform.exporter.service.type`                          | Service type for default Data Platform Prometheus exporter service                                               | `ClusterIP`                                 |
| `dataplatform.exporter.service.annotations`                   | Metrics exporter service annotations                                                                             | `{}`                                        |
| `dataplatform.exporter.service.labels`                        | Additional labels for Data Platform exporter service                                                             | `{}`                                        |
| `dataplatform.exporter.service.ports.http`                    | Kubernetes Service port                                                                                          | `9090`                                      |
| `dataplatform.exporter.service.loadBalancerIP`                | Load balancer IP for the Data Platform Exporter Service (optional, cloud specific)                               | `""`                                        |
| `dataplatform.exporter.service.nodePorts.http`                | Node ports for the HTTP exporter service                                                                         | `""`                                        |
| `dataplatform.exporter.service.loadBalancerSourceRanges`      | Exporter Load Balancer Source ranges                                                                             | `[]`                                        |
| `dataplatform.exporter.hostAliases`                           | Deployment pod host aliases                                                                                      | `[]`                                        |
| `dataplatform.emitter.enabled`                                | Start Data Platform metrics emitter                                                                              | `true`                                      |
| `dataplatform.emitter.image.registry`                         | Data Platform emitter image registry                                                                             | `harbor-repo.vmware.com`                    |
| `dataplatform.emitter.image.repository`                       | Data Platform emitter image repository                                                                           | `octo_data_platforms/dataplatform-emitter`  |
| `dataplatform.emitter.image.tag`                              | Data Platform emitter image tag (immutable tags are recommended)                                                 | `2.0.0`                                     |
| `dataplatform.emitter.image.pullPolicy`                       | Data Platform emitter image pull policy                                                                          | `IfNotPresent`                              |
| `dataplatform.emitter.image.pullSecrets`                      | Specify docker-registry secret names as an array                                                                 | `[]`                                        |
| `dataplatform.emitter.livenessProbe.enabled`                  | Enable livenessProbe                                                                                             | `true`                                      |
| `dataplatform.emitter.livenessProbe.initialDelaySeconds`      | Initial delay seconds for livenessProbe                                                                          | `10`                                        |
| `dataplatform.emitter.livenessProbe.periodSeconds`            | Period seconds for livenessProbe                                                                                 | `5`                                         |
| `dataplatform.emitter.livenessProbe.timeoutSeconds`           | Timeout seconds for livenessProbe                                                                                | `15`                                        |
| `dataplatform.emitter.livenessProbe.failureThreshold`         | Failure threshold for livenessProbe                                                                              | `15`                                        |
| `dataplatform.emitter.livenessProbe.successThreshold`         | Success threshold for livenessProbe                                                                              | `1`                                         |
| `dataplatform.emitter.readinessProbe.enabled`                 | Enable readinessProbe                                                                                            | `true`                                      |
| `dataplatform.emitter.readinessProbe.initialDelaySeconds`     | Initial delay seconds for readinessProbe                                                                         | `10`                                        |
| `dataplatform.emitter.readinessProbe.periodSeconds`           | Period seconds for readinessProbe                                                                                | `5`                                         |
| `dataplatform.emitter.readinessProbe.timeoutSeconds`          | Timeout seconds for readinessProbe                                                                               | `15`                                        |
| `dataplatform.emitter.readinessProbe.failureThreshold`        | Failure threshold for readinessProbe                                                                             | `15`                                        |
| `dataplatform.emitter.readinessProbe.successThreshold`        | Success threshold for readinessProbe                                                                             | `15`                                        |
| `dataplatform.emitter.startupProbe.enabled`                   | Enable startupProbe                                                                                              | `false`                                     |
| `dataplatform.emitter.startupProbe.initialDelaySeconds`       | Initial delay seconds for startupProbe                                                                           | `10`                                        |
| `dataplatform.emitter.startupProbe.periodSeconds`             | Period seconds for startupProbe                                                                                  | `5`                                         |
| `dataplatform.emitter.startupProbe.timeoutSeconds`            | Timeout seconds for startupProbe                                                                                 | `15`                                        |
| `dataplatform.emitter.startupProbe.failureThreshold`          | Failure threshold for startupProbe                                                                               | `15`                                        |
| `dataplatform.emitter.startupProbe.successThreshold`          | Success threshold for startupProbe                                                                               | `15`                                        |
| `dataplatform.emitter.containerPorts.http`                    | Data Platform emitter port                                                                                       | `8091`                                      |
| `dataplatform.emitter.priorityClassName`                      | exporter priorityClassName                                                                                       | `""`                                        |
| `dataplatform.emitter.command`                                | Override Data Platform entrypoint string.                                                                        | `[]`                                        |
| `dataplatform.emitter.args`                                   | Arguments for the provided command if needed                                                                     | `[]`                                        |
| `dataplatform.emitter.resources.limits`                       | The resources limits for the container                                                                           | `{}`                                        |
| `dataplatform.emitter.resources.requests.cpu`                 | The requested resources for the container                                                                        | `200m`                                      |
| `dataplatform.emitter.resources.requests.memory`              | The requested resources for the container                                                                        | `10Mi`                                      |
| `dataplatform.emitter.containerSecurityContext.enabled`       | Enable Data Platform emitter containers' Security Context                                                        | `true`                                      |
| `dataplatform.emitter.containerSecurityContext.runAsUser`     | User ID for the containers.                                                                                      | `1001`                                      |
| `dataplatform.emitter.containerSecurityContext.runAsNonRoot`  | Enable Data Platform emitter containers' Security Context runAsNonRoot                                           | `true`                                      |
| `dataplatform.emitter.podSecurityContext.enabled`             | Enable Data Platform emitter pods' Security Context                                                              | `true`                                      |
| `dataplatform.emitter.podSecurityContext.fsGroup`             | Group ID for the pods.                                                                                           | `1001`                                      |
| `dataplatform.emitter.podAffinityPreset`                      | Data Platform emitter pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                                        |
| `dataplatform.emitter.podAntiAffinityPreset`                  | Data Platform emitter pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`                                      |
| `dataplatform.emitter.nodeAffinityPreset.type`                | Data Platform emitter node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`                                        |
| `dataplatform.emitter.nodeAffinityPreset.key`                 | Data Platform emitter node label key to match Ignored if `affinity` is set.                                      | `""`                                        |
| `dataplatform.emitter.nodeAffinityPreset.values`              | Data Platform emitter node label values to match. Ignored if `affinity` is set.                                  | `[]`                                        |
| `dataplatform.emitter.nodeSelector`                           | Node labels for emitter pods assignment. Evaluated as a template                                                 | `{}`                                        |
| `dataplatform.emitter.tolerations`                            | Tolerations for emitter pods assignment. Evaluated as a template                                                 | `[]`                                        |
| `dataplatform.emitter.podLabels`                              | Additional labels for Metrics emitter pod                                                                        | `{}`                                        |
| `dataplatform.emitter.podAnnotations`                         | Additional annotations for Metrics emitter pod                                                                   | `{}`                                        |
| `dataplatform.emitter.customLivenessProbe`                    | Override default liveness probe%%MAIN_CONTAINER_NAME%%                                                           | `{}`                                        |
| `dataplatform.emitter.customReadinessProbe`                   | Override default readiness probe%%MAIN_CONTAINER_NAME%%                                                          | `{}`                                        |
| `dataplatform.emitter.customStartupProbe`                     | Override default startup probe                                                                                   | `{}`                                        |
| `dataplatform.emitter.updateStrategy.type`                    | Update strategy - only really applicable for deployments with RWO PVs attached                                   | `RollingUpdate`                             |
| `dataplatform.emitter.updateStrategy.rollingUpdate`           | Deployment rolling update configuration parameters                                                               | `{}`                                        |
| `dataplatform.emitter.extraEnvVars`                           | Additional environment variables to set                                                                          | `[]`                                        |
| `dataplatform.emitter.extraEnvVarsCM`                         | ConfigMap with extra environment variables                                                                       | `""`                                        |
| `dataplatform.emitter.extraEnvVarsSecret`                     | Secret with extra environment variables                                                                          | `""`                                        |
| `dataplatform.emitter.extraVolumes`                           | Extra volumes to add to the deployment                                                                           | `[]`                                        |
| `dataplatform.emitter.extraVolumeMounts`                      | Extra volume mounts to add to the container                                                                      | `[]`                                        |
| `dataplatform.emitter.initContainers`                         | Add init containers to the %%MAIN_CONTAINER_NAME%% pods                                                          | `[]`                                        |
| `dataplatform.emitter.sidecars`                               | Add sidecars to the %%MAIN_CONTAINER_NAME%% pods                                                                 | `[]`                                        |
| `dataplatform.emitter.service.type`                           | Service type for default Data Platform metrics emitter service                                                   | `ClusterIP`                                 |
| `dataplatform.emitter.service.annotations`                    | annotations for Data Platform emitter service                                                                    | `{}`                                        |
| `dataplatform.emitter.service.labels`                         | Additional labels for Data Platform emitter service                                                              | `{}`                                        |
| `dataplatform.emitter.service.ports.http`                     | Kubernetes Service port                                                                                          | `8091`                                      |
| `dataplatform.emitter.service.loadBalancerIP`                 | Load balancer IP for the dataplatform emitter Service (optional, cloud specific)                                 | `""`                                        |
| `dataplatform.emitter.service.nodePorts.http`                 | Node ports for the HTTP emitter service                                                                          | `""`                                        |
| `dataplatform.emitter.service.loadBalancerSourceRanges`       | Data Platform Emitter Load Balancer Source ranges                                                                | `[]`                                        |
| `dataplatform.emitter.hostAliases`                            | Deployment pod host aliases                                                                                      | `[]`                                        |


### RabbitMQ Cluster Operator Chart parameters

| Name                                    | Description                                | Value  |
| --------------------------------------- | ------------------------------------------ | ------ |
| `rabbitmq-cluster-operator.enabled`     | Switch to enable RabbitMQ chart deployment | `true` |
| `rabbitmq-cluster-operator.extraDeploy` | Instantiate RabbitMQ cluster               | `{}`   |


### rabbitmq-cluster-operator Metrics parameters

| Name                                        | Description                              | Value   |
| ------------------------------------------- | ---------------------------------------- | ------- |
| `rabbitmq-cluster-operator.metrics.enabled` | Expose rabbitmq-cluster-operator metrics | `false` |


### Apache Geode Chart parameters

| Name            | Description           | Value  |
| --------------- | --------------------- | ------ |
| `geode.enabled` | Enable geode subchart | `true` |


### Apache Geode Locator parameters

| Name                                      | Description                                        | Value       |
| ----------------------------------------- | -------------------------------------------------- | ----------- |
| `geode.locator.initialHeapSize`           | Initial size of the heap on Locator nodes          | `""`        |
| `geode.locator.maxHeapSize`               | Maximum size of the heap on Locator nodes          | `""`        |
| `geode.locator.replicaCount`              | Number of Locator replicas to deploy               | `2`         |
| `geode.locator.resources.limits`          | The resources limits for the Locator containers    | `{}`        |
| `geode.locator.resources.requests.cpu`    | The requested resources for the Locator containers | `100m`      |
| `geode.locator.resources.requests.memory` | The requested resources for the Locator containers | `128Mi`     |
| `geode.locator.service.type`              | Locator service type                               | `ClusterIP` |
| `geode.locator.service.ports.locator`     | Locator multicast service port                     | `10334`     |
| `geode.locator.service.ports.http`        | Locator HTTP service port                          | `7070`      |
| `geode.locator.service.ports.rmi`         | Locator RMI service port                           | `1099`      |


### Apache Geode Cache Server parameters

| Name                                     | Description                                             | Value   |
| ---------------------------------------- | ------------------------------------------------------- | ------- |
| `geode.server.initialHeapSize`           | Initial size of the heap on Cache server nodes          | `4g`    |
| `geode.server.maxHeapSize`               | Maximum size of the heap on Cache Server nodes          | `4g`    |
| `geode.server.replicaCount`              | Number of Cache Server replicas to deploy               | `3`     |
| `geode.server.resources.limits`          | The resources limits for the Cache server containers    | `{}`    |
| `geode.server.resources.requests.cpu`    | The requested resources for the Cache server containers | `250m`  |
| `geode.server.resources.requests.memory` | The requested resources for the Cache server containers | `5Gi`   |
| `geode.server.service.ports.server`      | Cache server multicast service port                     | `40404` |
| `geode.server.service.ports.http`        | Cache server HTTP service port                          | `7070`  |
| `geode.server.service.ports.rmi`         | Cache server RMI service port                           | `1099`  |


### Geode Metrics parameters

| Name                                | Description                                                         | Value   |
| ----------------------------------- | ------------------------------------------------------------------- | ------- |
| `geode.metrics.enabled`             | Expose Apache Geode metrics                                         | `false` |
| `geode.metrics.containerPort`       | Metrics container port                                              | `9914`  |
| `geode.metrics.service.port`        | Service HTTP management port                                        | `9914`  |
| `geode.metrics.service.annotations` | Annotations for enabling prometheus to access the metrics endpoints | `{}`    |


### postgresql-ha Chart parameters

| Name                                                 | Description                                                               | Value   |
| ---------------------------------------------------- | ------------------------------------------------------------------------- | ------- |
| `postgresql-ha.enabled`                              | Enable PostgreSQL Chart                                                   | `true`  |
| `postgresql-ha.postgresql.replicaCount`              | Number of replicas to deploy                                              | `3`     |
| `postgresql-ha.postgresql.resources.limits`          | The resources limits for the Locator containers                           | `{}`    |
| `postgresql-ha.postgresql.resources.requests.cpu`    | The requested resources for the Locator containers                        | `{}`    |
| `postgresql-ha.postgresql.resources.requests.memory` | The requested resources for the Locator containers                        | `{}`    |
| `postgresql-ha.metrics.enabled`                      | Enable Metrics for PostgreSQL                                             | `false` |
| `postgresql-ha.metrics.resources.limits`             | The resources limits for the metrics containers                           | `{}`    |
| `postgresql-ha.metrics.resources.requests`           | The requested resources for the metrics containers                        | `{}`    |
| `postgresql-ha.metrics.annotations`                  | Annotations for enabling prometheus to access the geode metrics endpoints | `{}`    |


### Tanzu Observability (Wavefront) chart parameters

| Name                                                 | Description                                          | Value                                |
| ---------------------------------------------------- | ---------------------------------------------------- | ------------------------------------ |
| `wavefront.enabled`                                  | Switch to enable or disable the Wavefront helm chart | `false`                              |
| `wavefront.clusterName`                              | Unique name for the Kubernetes cluster (required)    | `KUBERNETES_CLUSTER_NAME`            |
| `wavefront.wavefront.url`                            | Wavefront URL for your cluster (required)            | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.wavefront.token`                          | Wavefront API Token (required)                       | `YOUR_API_TOKEN`                     |
| `wavefront.wavefront.existingSecret`                 | Name of an existing secret containing the token      | `nil`                                |
| `wavefront.collector.resources.limits`               | The resources limits for the collector container     | `{}`                                 |
| `wavefront.collector.resources.requests`             | The requested resources for the collector container  | `{}`                                 |
| `wavefront.collector.discovery.enabled`              | Rules based and Prometheus endpoints auto-discovery  | `true`                               |
| `wavefront.collector.discovery.enableRuntimeConfigs` | Enable runtime discovery rules                       | `true`                               |
| `wavefront.proxy.resources.limits`                   | The resources limits for the proxy container         | `{}`                                 |
| `wavefront.proxy.resources.requests`                 | The requested resources for the proxy container      | `{}`                                 |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set geode.replicaCount=3 \
  bitnami/dataplatform-bp3
```

The above command deploys the data platform with Apache Geode with 3 nodes (replicas).

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/dataplatform-bp3
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Data Platform Deployment with Observability Framework

In the default deployment, the helm chart deploys the data platform with [Metrics Emitter](https://hub.docker.com/r/bitnami/dataplatform-emitter) and [Prometheus Exporter](https://hub.docker.com/r/bitnami/dataplatform-exporter) which emit the health metrics of the data platform which can be integrated with your observability solution.

In case you need to deploy the data platform with [Tanzu Observability](https://docs.wavefront.com/kubernetes.html) Framework for all the applications (RabbitMQ/Geode/PostgreSQL) in the data platform, you can specify the 'enabled' parameter using the `--set <component>.metrics.enabled=true` argument to `helm install`. For Apache Geode, the parameter is `geode.metrics.enabled=true` For Example,

```console
$ helm install my-release bitnami/dataplatform-bp3 \
    --set geode.metrics.enabled=true \
    --set postgresql-ha.metrics.enabled=true \
    --set wavefront.enabled=true \
    --set wavefront.clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.