# Data Platform Blueprint 2 with Kafka-Spark-Elasticsearch

Enterprise applications increasingly rely on large amounts of data, that needs be distributed, processed, and stored.
Open source and commercial supported software stacks are available to implement a data platform, that can offer common data management services, accelerating the development and deployment of data hungry business applications.

This Helm chart enables the fully automated Kubernetes deployment of such multi-stack data platform, covering the following software components:

-   Apache Kafka              – Data distribution bus with buffering capabilities
-   Apache Spark              – In-memory data analytics
-   Elasticsearch with Kibana – Data persistence and search
-   Logstash                  - Data Processing Pipeline

These containerized stateful software stacks are deployed in multi-node cluster configurations, which is defined by the Helm Chart blueprint for this data platform deployment, covering:

-   Pod placement rules – Affinity rules to ensure placement diversity to prevent single point of failures and optimize load distribution
-   Pod resource sizing rules – Optimized Pod and JVM sizing settings for optimal performance and efficient resource usage
-   Default settings to ensure Pod access security
-   Optional Tanzu Observability framework configuration

In addition to the Pod resource optimizations, this blueprint is validated and tested to provide Kubernetes node count and sizing recommendations [(see Kubernetes Cluster Requirements)](#kubernetes-cluster-requirements) to facilitate cloud platform capacity planning. The goal is optimize the number of required Kubernetes nodes in order to optimize server resource usage and, at the same time, ensuring runtime and resource diversity.

The first release of this blueprint defines a small size data platform deployment, deployed on 3 Kubernetes application nodes with physical diverse underlying server infrastructure.

Use cases for this small size data platform setup include: data and application evaluation, development, and functional testing.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/dataplatform-bp2
```

## Introduction

This chart bootstraps Data Platform Blueprint-2 deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

The "Small" size data platform in default configuration deploys the following:

1. Zookeeper with 3 nodes to be used for both Kafka
2. Kafka with 3 nodes using the zookeeper deployed above
3. Elasticsearch with 3 master nodes, 2 data nodes, 2 coordinating nodes and 1 kibana node
4. Logstash with 2 nodes
5. Spark with 1 Master and 2 worker nodes

The data platform can be optionally deployed with the Tanzu observability framework. In that case, the wavefront collectors will be set up as a DaemonSet to collect the Kubernetes cluster metrics to enable runtime feed into the Tanzu Observability service. It will also be pre-configured to scrape the metrics from the Prometheus endpoint that each application (Kafka/Spark/Elasticsearch/Logstash) emits the metrics to.

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
$ helm install my-release bitnami/dataplatform-bp2
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
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |


### Kafka parameters

| Name                                            | Description                                        | Value                 |
| ----------------------------------------------- | -------------------------------------------------- | --------------------- |
| `kafka.enabled`                                 | Enable Kafka subchart                              | `true`                |
| `kafka.replicaCount`                            | Number of Kafka brokers                            | `3`                   |
| `kafka.heapOpts`                                | Kafja Java Heap size                               | `-Xmx4096m -Xms4096m` |
| `kafka.resources.limits`                        | Resource limits for Kafka                          | `{}`                  |
| `kafka.resources.requests.cpu`                  | CPU capacity request for Kafka nodes               | `250m`                |
| `kafka.resources.requests.memory`               | Memory capacity request for Kafka nodes            | `5120Mi`              |
| `kafka.affinity.podAntiAffinity`                | Kafka anti affinity rules                          | `{}`                  |
| `kafka.affinity.podAffinity`                    | Kafka affinity rules                               | `{}`                  |
| `kafka.metrics.kafka.enabled`                   | Enable prometheus exporter for Kafka               | `true`                |
| `kafka.metrics.kafka.resources.limits`          | Resource limits for kafka prometheus exporter      | `{}`                  |
| `kafka.metrics.kafka.resources.requests.cpu`    | CPU capacity request for Kafka prometheus nodes    | `100m`                |
| `kafka.metrics.kafka.resources.requests.memory` | Memory capacity request for Kafka prometheus nodes | `128Mi`               |
| `kafka.metrics.kafka.service.port`              | Kafka Prometheus exporter service port             | `9308`                |
| `kafka.metrics.jmx.enabled`                     | Enable JMX exporter for Kafka                      | `true`                |
| `kafka.metrics.jmx.resources.limits`            | Resource limits for kafka prometheus exporter      | `{}`                  |
| `kafka.metrics.jmx.resources.requests.cpu`      | CPU capacity request for Kafka prometheus nodes    | `100m`                |
| `kafka.metrics.jmx.resources.requests.memory`   | Memory capacity request for Kafka prometheus nodes | `128Mi`               |
| `kafka.metrics.jmx.service.port`                | Kafka Prometheus exporter service port             | `5556`                |
| `kafka.zookeeper.enabled`                       | Enable the Kafka subchart's Zookeeper              | `true`                |
| `kafka.zookeeper.replicaCount`                  | Number of Zookeeper nodes                          | `3`                   |
| `kafka.zookeeper.heapSize`                      | HeapSize for Zookeeper                             | `4096`                |
| `kafka.zookeeper.resources.limits`              | Resource limits for zookeeper                      | `{}`                  |
| `kafka.zookeeper.resources.requests.cpu`        | CPU capacity request for zookeeper                 | `250m`                |
| `kafka.zookeeper.resources.requests.memory`     | Memory capacity request for zookeeper              | `5120Mi`              |
| `kafka.zookeeper.affinity.podAntiAffinity`      | Zookeeper anti affinity rules                      | `{}`                  |
| `kafka.externalZookeeper.servers`               | Array of external Zookeeper servers                | `[]`                  |


### Spark parameters

| Name                                     | Description                           | Value    |
| ---------------------------------------- | ------------------------------------- | -------- |
| `spark.enabled`                          | Enable Spark subchart                 | `true`   |
| `spark.master.webPort`                   | Web port for spark master             | `8080`   |
| `spark.master.resources.limits`          | Spark master resource limits          | `{}`     |
| `spark.master.resources.requests.cpu`    | Spark master CPUs                     | `250m`   |
| `spark.master.resources.requests.memory` | Spark master requested memory         | `5120Mi` |
| `spark.master.affinity.podAntiAffinity`  | Spark master pod anti affinity rules  | `{}`     |
| `spark.worker.replicaCount`              | Number of spark workers               | `2`      |
| `spark.worker.webPort`                   | Web port for spark master             | `8081`   |
| `spark.worker.resources.limits`          | Spark master resource limits          | `{}`     |
| `spark.worker.resources.requests.cpu`    | Spark master CPUs                     | `250m`   |
| `spark.worker.resources.requests.memory` | Spark master requested memory         | `5120Mi` |
| `spark.worker.affinity.podAntiAffinity`  | Spark master pod anti affinity rules  | `{}`     |
| `spark.metrics.enabled`                  | Enable Prometheus exporter for Spark  | `true`   |
| `spark.metrics.masterAnnotations`        | Annotations for Spark master exporter | `{}`     |
| `spark.metrics.workerAnnotations`        | Annotations for Spark worker exporter | `{}`     |


### Elasticsearch parameters

| Name                                                   | Description                                  | Value    |
| ------------------------------------------------------ | -------------------------------------------- | -------- |
| `elasticsearch.enabled`                                | Enable Elasticsearch                         | `true`   |
| `elasticsearch.global.kibanaEnabled`                   | Enable Kibana                                | `true`   |
| `elasticsearch.master.replicas`                        | Number of Elasticsearch replicas             | `3`      |
| `elasticsearch.master.heapSize`                        | Heap Size for Elasticsearch master           | `512m`   |
| `elasticsearch.master.affinity.podAntiAffinity`        | Elasticsearch pod anti affinity              | `{}`     |
| `elasticsearch.master.resources.limits`                | Elasticsearch master resource limits         | `{}`     |
| `elasticsearch.master.resources.requests.cpu`          | Elasticsearch master CPUs                    | `250m`   |
| `elasticsearch.master.resources.requests.memory`       | Elasticsearch master requested memory        | `1048Mi` |
| `elasticsearch.data.name`                              | Elasticsearch data node name                 | `data`   |
| `elasticsearch.data.replicas`                          | Number of Elasticsearch replicas             | `2`      |
| `elasticsearch.data.heapSize`                          | Heap Size for Elasticsearch data node        | `2560m`  |
| `elasticsearch.data.affinity.podAntiAffinity`          | Elasticsearch pod anti affinity              | `{}`     |
| `elasticsearch.data.resources.limits`                  | Elasticsearch data node resource limits      | `{}`     |
| `elasticsearch.data.resources.requests.cpu`            | Elasticsearch data node CPUs                 | `250m`   |
| `elasticsearch.data.resources.requests.memory`         | Elasticsearch data node requested memory     | `5Gi`    |
| `elasticsearch.coordinating.replicas`                  | Number of Elasticsearch replicas             | `2`      |
| `elasticsearch.coordinating.heapSize`                  | Heap Size for Elasticsearch coordinating     | `1024m`  |
| `elasticsearch.coordinating.affinity.podAntiAffinity`  | Elasticsearch pod anti affinity              | `{}`     |
| `elasticsearch.coordinating.resources.limits`          | Elasticsearch coordinating resource limits   | `{}`     |
| `elasticsearch.coordinating.resources.requests.cpu`    | Elasticsearch coordinating CPUs              | `100m`   |
| `elasticsearch.coordinating.resources.requests.memory` | Elasticsearch coordinating requested memory  | `2Gi`    |
| `elasticsearch.metrics.enabled`                        | Enable Prometheus exporter for Elasticsearch | `true`   |
| `elasticsearch.metrics.resources.limits`               | Elasticsearch metrics resource limits        | `{}`     |
| `elasticsearch.metrics.resources.requests.cpu`         | Elasticsearch metrics CPUs                   | `100m`   |
| `elasticsearch.metrics.resources.requests.memory`      | Elasticsearch metrics requested memory       | `128Mi`  |
| `elasticsearch.metrics.service.annotations`            | Elasticsearch metrics service annotations    | `{}`     |


### Logstash parameters

| Name                                         | Description                            | Value   |
| -------------------------------------------- | -------------------------------------- | ------- |
| `logstash.enabled`                           | Enable Logstash                        | `true`  |
| `logstash.replicaCount`                      | Number of Logstash replicas            | `2`     |
| `logstash.affinity.podAntiAffinity`          | Logstash pod anti affinity             | `{}`    |
| `logstash.resources.limits`                  | Elasticsearch metrics resource limits  | `{}`    |
| `logstash.resources.requests.cpu`            | Elasticsearch metrics CPUs             | `100m`  |
| `logstash.resources.requests.memory`         | Elasticsearch metrics requested memory | `128Mi` |
| `logstash.metrics.enabled`                   | Enable metrics for logstash            | `true`  |
| `logstash.metrics.resources.limits`          | Elasticsearch metrics resource limits  | `{}`    |
| `logstash.metrics.resources.requests.cpu`    | Elasticsearch metrics CPUs             | `100m`  |
| `logstash.metrics.resources.requests.memory` | Elasticsearch metrics requested memory | `128Mi` |
| `logstash.metrics.service.port`              | Logstash service port                  | `9198`  |
| `logstash.metrics.service.annotations`       | Logstash service annotations           | `{}`    |


### Tanzu Observability (Wavefront) parameters

| Name                                                 | Description                                    | Value                                |
| ---------------------------------------------------- | ---------------------------------------------- | ------------------------------------ |
| `wavefront.enabled`                                  | Enable Tanzu Observability Framework                               | `false`                              |
| `wavefront.clusterName`                              | cluster name                                   | `KUBERNETES_CLUSTER_NAME`            |
| `wavefront.wavefront.url`                            | Tanzu Observability cluster URL                          | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.wavefront.token`                          | Tanzu Observability access token                         | `YOUR_API_TOKEN`                     |
| `wavefront.wavefront.existingSecret`                 | Tanzu Observability existing secret                      | `nil`                                |
| `wavefront.collector.resources.limits`               | Wavefront metrics resource limits          | `{}`                                 |
| `wavefront.collector.resources.requests.cpu`         | Wavefront metrics CPUs                     | `200m`                               |
| `wavefront.collector.resources.requests.memory`      | Wavefront metrics requested memory         | `10Mi`                               |
| `wavefront.collector.discovery.enabled`              | Enable Wavefront discovery                     | `true`                               |
| `wavefront.collector.discovery.enableRuntimeConfigs` | Enable runtime configs for Wavefront discovery | `true`                               |
| `wavefront.collector.discovery.config`               | Wavefront discovery config                     | `[]`                                 |
| `wavefront.proxy.resources.limits`                   | Wavefront metrics resource limits          | `{}`                                 |
| `wavefront.proxy.resources.requests.cpu`             | Wavefront metrics CPUs                     | `100m`                               |
| `wavefront.proxy.resources.requests.memory`          | Wavefront metrics requested memory         | `5Gi`                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set kafka.replicaCount=3 \
  bitnami/dataplatform-bp2
```

The above command deploys the data platform with Kafka with 3 nodes (replicas).

In case you need to deploy the data platform with Tanzu Observability Framework for all the applications (Kafka/Spark/Elasticsearch/Logstash) in the data platform, you can specify the 'enabled' parameter using the `--set <component>.metrics.enabled=true` argument to `helm install`. For Example,

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

The above command deploys the data platform with the Tanzu Observability Framework.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/dataplatform-bp2
```

> **Tip**: You can use the default [values.yaml](values.yaml)

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

