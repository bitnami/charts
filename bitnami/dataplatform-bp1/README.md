# Data Platform Blueprint 1 with Kafka-Spark-Solr

Enterprise applications increasingly rely on large amounts of data, that needs be distributed, processed, and stored.
Open source and commercial supported software stacks are available to implement a data platform, that can offer
common data management services, accelerating the development and deployment of data hungry business applications.

This Helm chart enables the fully automated Kubernetes deployment of such multi-stack data platform, covering the following software components:

-   Apache Kafka – Data distribution bus with buffering capabilities
-   Apache Spark – In-memory data analytics
-   Solr – Data persistence and search

These containerized stateful software stacks are deployed in multi-node cluster configurations, which is defined by the
Helm chart blueprint for this data platform deployment, covering:

-   Pod placement rules – Affinity rules to ensure placement diversity to prevent single point of failures and optimize load distribution
-   Pod resource sizing rules – Optimized Pod and JVM sizing settings for optimal performance and efficient resource usage
-   Default settings to ensure Pod access security
-   Optional [Tanzu Observability](https://docs.wavefront.com/kubernetes.html) framework configuration

In addition to the Pod resource optimizations, this blueprint is validated and tested to provide Kubernetes node count and sizing recommendations [(see Kubernetes Cluster Requirements)](#kubernetes-cluster-requirements) to facilitate cloud platform capacity planning. The goal is optimize the number of required Kubernetes nodes in order to optimize server resource usage and, at the same time, ensuring runtime and resource diversity.

The first release of this blueprint defines a small size data platform deployment, deployed on 3 Kubernetes application nodes with physical diverse underlying server infrastructure.

Use cases for this small size data platform setup include: data and application evaluation, development, and functional testing.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/dataplatform-bp1
```

## Introduction

This chart bootstraps Data Platform Blueprint-1 deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

The "Small" size data platform in default configuration deploys the following:
1. Zookeeper with 3 nodes to be used for both Kafka and Solr
2. Kafka with 3 nodes using the zookeeper deployed above
3. Solr with 2 nodes using the zookeeper deployed above
4. Spark with 1 Master and 2 worker nodes

The data platform can be optionally deployed with the Tanzu observability framework. In that case, the wavefront collectors will be set up as a DaemonSet to collect the Kubernetes cluster metrics to enable runtime feed into the Tanzu Observability service. It will also be pre-configured to scrape the metrics from the Prometheus endpoint that each application (Kafka/Spark/Solr) emits the metrics to.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

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

| Name                                     | Description                                                                               | Value                 |
| ---------------------------------------- | ----------------------------------------------------------------------------------------- | --------------------- |
| `kafka.enabled`                          | Switch to enable or disable the Kafka helm chart                                          | `true`                |
| `kafka.replicaCount`                     | Number of Kafka replicas                                                                  | `3`                   |
| `kafka.heapOpts`                         | Kafka's Java Heap size                                                                    | `-Xmx4096m -Xms4096m` |
| `kafka.resources.limits`                 | The resources limits for Kafka containers                                                 | `{}`                  |
| `kafka.resources.requests`               | The requested resources for Kafka containers                                              | `{}`                  |
| `kafka.affinity.podAntiAffinity`         | Zookeeper pods Anti Affinity rules for best possible resiliency (evaluated as a template) | `{}`                  |
| `kafka.affinity.podAffinity`             | Zookeeper pods Affinity rules for best possible resiliency (evaluated as a template)      | `{}`                  |
| `kafka.metrics.kafka.enabled`            | Whether or not to create a standalone Kafka exporter to expose Kafka metrics              | `false`               |
| `kafka.metrics.kafka.resources.limits`   | The resources limits for the container                                                    | `{}`                  |
| `kafka.metrics.kafka.resources.requests` | Kafka Exporter container resource requests                                                | `{}`                  |
| `kafka.metrics.kafka.service.port`       | Kafka Exporter Prometheus port to be used in Wavefront configuration                      | `9308`                |
| `kafka.metrics.jmx.enabled`              | Whether or not to expose JMX metrics to Prometheus                                        | `false`               |
| `kafka.metrics.jmx.resources.limits`     | The resources limits for the container                                                    | `{}`                  |
| `kafka.metrics.jmx.resources.requests`   | JMX Exporter container resource requests                                                  | `{}`                  |
| `kafka.metrics.jmx.service.port`         | JMX Exporter Prometheus port                                                              | `5556`                |
| `kafka.zookeeper.enabled`                | Switch to enable or disable the Zookeeper helm chart                                      | `false`               |
| `kafka.externalZookeeper.servers`        | Server or list of external Zookeeper servers to use                                       | `[]`                  |


### Solr chart parameters

| Name                                 | Description                                                                                    | Value                 |
| ------------------------------------ | ---------------------------------------------------------------------------------------------- | --------------------- |
| `solr.enabled`                       | Switch to enable or disable the Solr helm chart                                                | `true`                |
| `solr.replicaCount`                  | Number of Solr replicas                                                                        | `2`                   |
| `solr.authentication.enabled`        | Enable Solr authentication. BUG: Exporter deployment does not work with authentication enabled | `false`               |
| `solr.javaMem`                       | Java recommended memory options to pass to the Solr container                                  | `-Xmx4096m -Xms4096m` |
| `solr.affinity.podAntiAffinity`      | Zookeeper pods Anti Affinity rules for best possible resiliency (evaluated as a template)      | `{}`                  |
| `solr.resources.limits`              | The resources limits for Solr containers                                                       | `{}`                  |
| `solr.resources.requests`            | The requested resources for Solr containers                                                    | `{}`                  |
| `solr.exporter.enabled`              | Start a prometheus exporter                                                                    | `false`               |
| `solr.exporter.port`                 | Solr exporter port                                                                             | `9983`                |
| `solr.exporter.affinity.podAffinity` | Zookeeper pods Affinity rules for best possible resiliency (evaluated as a template)           | `{}`                  |
| `solr.exporter.resources.limits`     | The resources limits for the container                                                         | `{}`                  |
| `solr.exporter.resources.requests`   | The requested resources for the container                                                      | `{}`                  |
| `solr.zookeeper.enabled`             | Enable Zookeeper deployment. Needed for Solr cloud.                                            | `false`               |
| `solr.externalZookeeper.servers`     | Servers for an already existing Zookeeper.                                                     | `[]`                  |


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

In case you need to deploy the data platform with [Tanzu Observability](https://docs.wavefront.com/kubernetes.html) Framework for all the applications (Kafka/Spark/Solr) in the data platform, you can specify the 'enabled' parameter using the `--set <component>.metrics.enabled=true` argument to `helm install`. For Solr, the parameter is `solr.exporter.enabled=true` For Example,

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

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/dataplatform-bp1
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

In order to render complete information about the deployment including all the sub-charts, please use --render-subchart-notes flag while installing the chart.

## Upgrading

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
