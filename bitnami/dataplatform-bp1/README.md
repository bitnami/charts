# Data Platform with Kafka-Spark-Solr (Blueprint-1)

Data Platform Blueprint-1 comprises of Kafka, Spark and Solr. 

This orchestration helm chart can be used to quickly deploy this data platform blueprint on a kubernetes Cluster. It additionally gives you the following benefits: 
1. Ability to deploy data platform in different sizes (Small/Medium/Large) 
2. Resource sizing and pod affinity rules to bring up an optimal and resilient platform
3. Ability to deploy the Observability framework for the data platform with Wavefront

## TL;DR

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/dataplatform-bp1
```

## Introduction

This chart bootstraps Data Platform Blueprint-1 deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. 

The "Small" size data platform in default configuration deploys the following:
1. Zookeeper with 3 nodes to be used for both Kafka and Solr
2. Kafka with 3 nodes using the zookeeper deployed above
3. Solr with 2 nodes using the zookeeper deployed above
4. Spark with 1 Master and 2 worker nodes

Please refer [Data Platform with Wavefront Section](#wavefront-observability-set-up-for-the-data-platform) to set up the data platform with Observability framework.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Kubernetes Cluster requirements

Below are the Kubernetes Cluster requirements for different sizes of the data platform:

|Data Platform Size        | Kubernetes Cluster Size |  Usage                                     |
|--------------------------|-------------------------|--------------------------------------------|
|Small                     |1 Master Node (2 CPU, 4Gi Memory) <br /> 3 Worker Nodes (4 CPU, 32Gi Memory)            |   Development Environment <br />     |
                                     

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/dataplatform-bp1
```

These commands deploy Data Platform on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists recommended configurations of the parameters to bring up an optimal and resilient data platform. Please refer the individual charts for the remaining set of configurable parameters. 

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the recommended configurations for each application used in the data platform. If you need to configure any other parameters apart from the ones mentioned below, you can refer to the corresponding chart and update the values.yaml accordingly. 

### Global parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                            | Global Docker image registry                                                                                                      | `nil`                                                   |
| `global.imagePullSecrets`                         | Global Docker registry secret names as an array                                                                                   | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                             | Global storage class for dynamic provisioning                                                                                     | `nil`                                                   |

### Common parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `extraDeploy`                                     | Array of extra objects to deploy with the release                                                                                 | `nil` (evaluated as a template)                         |

### RBAC parameters

| Parameter                                         | Description                                                                                                                       | Default                                             |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------|
| `serviceAccount.create`                           | Enable creation of ServiceAccount                                                                                 | `true`                          |
| `serviceAccount.name`                             | Name of the created serviceAccount                                                                                | Generated using the common.fullname template                          |
| `rbac.create`                                     | Weather to create & use RBAC resources or not                                                                     | `false`                          |

### Zookeeper chart parameters

| Parameter                                         | Description                                                                                                                       | Default                                             |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------|
| `zookeeper.enabled`                               | Switch to enable or disable the Zookeeper helm chart                                                                              | `true`                                              |
| `zookeeper.replicaCount`                          | Number of Zookeeper nodes                                                                                                         | `3`                                                 |
| `zookeeper.heap`                                  | Zookeepers's Java Heap size                                                                                                       | Zookeeper Java Heap size set according to data platform t-shirt size                                          |
| `zookeeper.resources.limits`                      | The resources limits for Zookeeper containers                                                 | `{}`                                               |
| `zookeeper.resources.requests`                    | The requested resources for Zookeeper containers for a small kubernetes cluster               | Zookeeper pods Resource requests set according to data platform t-shirt size                                               |
| `zookeeper.affinity`                            | Affinity for pod assignment                                                               | Zookeeper pods Affinity rules set according to data platform t-shirt size (evaluated as a template)                     |


### Kafka chart parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `kafka.enabled`                                  | Switch to enable or disable the Kafka helm chart                                                                               | `true`                                             |
| `kafka.replicaCount`                             | Number of Kafka nodes                                                                     | `3`                                                |
| `kafka.heapOpts`                                 | Kafka's Java Heap size                                                                                                            | Kafka Java Heap size set according to data platform t-shirt size                                   |
| `kafka.resources.limits`                         | The resources limits for Kafka containers                                                 | `{}`                                               |
| `kafka.resources.requests`                       | The requested resources for Kafka containers for a small kubernetes cluster               | Kafka pods Resource requests set according to data platform t-shirt size                                               |
| `kafka.affinity`                                 | Affinity for pod assignment                                                               | Kafka pods affinity rules set according to data platform t-shirt size (evaluated as a template)                          |
| `kafka.metrics.kafka.enabled`                    | Whether or not to create a standalone Kafka exporter to expose Kafka metrics                                                      | `false`                                                 |
| `kafka.metrics.kafka.resources.limits`           | Kafka Exporter container resource limits                                                                                          | `{}`                                                    |
| `kafka.metrics.kafka.resources.requests`         | Kafka Exporter container resource requests                                                                                        | Kafka Exporter pod resource requests set according to data platform t-shirt size                                                    |
| `kafka.metrics.kafka.service.port`               | Kafka Exporter Prometheus port                                                                                                    | `9308`                                             |
| `kafka.metrics.jmx.enabled`                      | Whether or not to expose JMX metrics to Prometheus                                                                                | `false`                                            |
| `kafka.metrics.jmx.resources.limits`             | JMX Exporter container resource limits                                                                                            | `{}`                                                    |
| `kafka.metrics.jmx.resources.requests`           | JMX Exporter container resource requests                                                                                          | JMX exporter pod resource requests set according to data platform t-shirt size                                                    |
| `kafka.metrics.jmx.service.port`                 | JMX Exporter Prometheus port                                                                                                      | `5556`                                                  |
| `kafka.zookeeper.enabled`                        | Switch to enable or disable the Zookeeper helm chart                                                                              | `false` Common Zookeeper deployment used for kafka and solr                                                 |
| `externalZookeeper.servers`                      | Server or list of external Zookeeper servers to use                                                                               | Zookeeper installed as a subchart to be used                                                    |


### Solr chart parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `solr.enabled`                                  | Switch to enable or disable the Solr helm chart                                          | `true`                                             |
| `solr.replicaCount`                             | Number of Solr nodes                                                                     | `2`                          |
| `solr.authentication.enabled`                   | Enable Solr authentication                                                               | `true` should be 'false' for metrics exporters deployment                                            |
| `solr.resources.limits`                         | The resources limits for Solr containers                                                 | `{}`                                               |
| `solr.resources.requests`                       | The requested resources for Solr containers                                              | Solr pods resource requests set according to data platform t-shirt size              |
| `solr.javaMem`                                  | Java memory options to pass to the Solr container                                        | `-Xmx4096m -Xms4096m`                              |
| `solr.heap`                                     | Java Heap options to pass to the solr container                                          | `nil`                              |
| `solr.affinity`                                 | Affinity for Solr pods assignment                                                        | Solr pods Affinity rules set according to data platform t-shirt size (evaluated as a template)     |
| `solr.exporter.enabled`                         | Start a side-car prometheus exporter                                                     | `false`                                                                         |
| `solr.exporter.port`                            | Solr exporter port                                                                       | `9983`                                                                          |
| `solr.exporter.resources`                       | Exporter resource requests/limit                                                         | Solr exporter pod resource requests set according to data platform t-shirt size                                              |
| `solr.exporter.affinity`                        | Affinity for Solr pods assignment                                                        | Solr exporter pod affinity rules set according to data platform t-shirt size (evaluated as a template)                                                  |
| `solr.zookeeper.enabled`                        | Enable Zookeeper deployment. Needed for Solr cloud.                                                         | `false` common zookeeper used between kafka and solr                                                                          |
| `solr.externalZookeeper.servers`                | Servers for an already existing Zookeeper.                                                                  | Zookeeper installed as a subchart to be used                                                                            |

### Spark chart parameters

| Parameter                                   | Description                                                                                                                                | Default                                                 |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `spark.enabled`                           | Switch to enable or disable the Spark helm chart                                                                                                   | `true`                          |
| `master.webPort`                                 | Specify the port where the web interface will listen on the master                                                                         | `8080`                                                  |
| `spark.master.affinity`                          | Spark master affinity for pod assignment                                                                                                   | Spark master pod Affinity rules set according to data platform t-shirt size (evaluated as a template)                          |
| `spark.master.resources`                         | CPU/Memory resource requests/limits for Master                                                                                             | Spark master pods resource requests set according to data platform t-shirt size                                                    |
| `spark.worker.javaOptions`                       | Set options for the JVM in the form `-Dx=y`                                                                                                | No default                                              |
| `spark.worker.replicaCount`                      | Set the number of workers                                                                                                                  | `2`                                                     |
| `spark.worker.webPort`                           | Specify the port where the web interface will listen on the worker                                                                         | `8081`                                                  |
| `spark.worker.affinity`                          | Spark worker affinity for pod assignment                                                                                                   | Spark worker pods Affinity rules set according to data platform t-shirt size (evaluated as a template)                          |
| `spark.worker.resources`                         | CPU/Memory resource requests/limits for worker                                                                                             | Spark worker pods resource requests set according to data platform t-shirt size                            |
| `spark.metrics.enabled`                          | Start a side-car prometheus exporter                                                                                                         | `false`                                                      |
| `spark.metrics.masterAnnotations`                | Annotations for enabling prometheus to access the metrics endpoint of the master nodes                                                       | `{prometheus.io/scrape: "true", prometheus.io/path: "/metrics/", prometheus.io/port: "8080"}` |
| `spark.metrics.workerAnnotations`                | Annotations for enabling prometheus to access the metrics endpoint of the worker nodes                                                       | `{prometheus.io/scrape: "true", prometheus.io/path: "/metrics/", prometheus.io/port: "8081"}` |
| `spark.metrics.resources.limits`                 | The resources limits for the metrics exporter container                                                                                      | `{}`                                                         |
| `spark.metrics.resources.requests`               | The requested resources for the metrics exporter container                                                                                   | Spark exporter container resource requests set according to data platform t-shirt size                                                         |

### Wavefront chart parameters

By default the data platform helm chart is deployed without Wavefront Observability framework. Please refer the [Data Platform with Wavefront Section](#wavefront-observability-set-up-for-the-data-platform) for more details.

| Parameter                                  | Description                                                                                                            | Default                                                 |
|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `wavefront.enabled`                        | Switch to enable or disable the Wavefront helm chart                                                                   | `true`                                                  |
| `wavefront.clusterName`                    | Unique name for the Kubernetes cluster (required)                                                                      | `KUBERNETES_CLUSTER_NAME`                               |
| `wavefront.wavefront.url`                  | Wavefront URL for your cluster (required)                                                                              | `https://YOUR_CLUSTER.wavefront.com`                    |
| `wavefront.wavefront.token`                | Wavefront API Token (required)                                                                                         | `YOUR_API_TOKEN`                                        |
| `wavefront.wavefront.existingSecret`       | Name of an existing secret containing the token                                                                        | `nil`                                                   |
| `wavefront.collector.discovery.enabled`    | Rules based and Prometheus endpoints auto-discovery                                                                    | `true`                                                  |
| `wavefront.collector.discovery.enableRuntimeConfigs` | Enable runtime discovery rules                                                                               | `true`                                                 |
| `wavefront.collector.discovery.config`     | Configuration for rules based auto-discovery                                                                           | Data Platform components pods discovery config                                                   |
| `wavefront.collector.resources.limits`     | The resources limits for the collector container                                                                       | `{}`                                                    |
| `wavefront.collector.resources.requests`   | The requested resources for the collector container                                                                    | Collectors pods resource requests set according to data platform t-shirt size                        |
| `wavefront.proxy.resources.limits`         | The resources limits for the proxy container                                                                           | `{}`                                                    |
| `wavefront.proxy.resources.requests`       | The requested resources for the proxy container                                                                        | Proxy pods resource requests set according to data platform t-shirt size                                 |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set kafka.replicaCount=3 \
  bitnami/dataplatform-bp1
```

The above command deploys the data platform with Kafka with 3 nodes (replicas).

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/dataplatform-bp1
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Wavefront Observability set up for the Data Platform

This chart includes a values-metrics.yaml file where you can find some parameters oriented to deploy the wavefront observability framework additionally in comparison to the regular values.yaml. You can use this file instead of the default one.

The "Small" size data platform with observability framework deploys the following:
1. Zookeeper with 3 nodes to be used for both Kafka and Solr
2. Kafka with 3 nodes using the zookeeper deployed above along with metrics exporters
3. Solr with 2 nodes using the zookeeper deployed above along with metrics exporters
4. Spark with 1 Master and 2 worker nodes along with metrics exporters
5. Wavefront Collectors running as DaemonSet and Wavefront Proxy configured for Kafka/Spark/Solr

To install the data platform chart with observability framework with the release name `my-release`:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/dataplatform-bp1 -f values-metrics.yaml \
  --set wavefront.clusterName=<K8s-CLUSTER-NAME> \
  --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
  --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```

Alternatively you can store the Wavefront API token in a secret and use the secret while installing the chart. API Token can be found at Settings -> User Profile -> API Access. Please store it in a local file api-token.txt to create the secret using the command below.

```console
kubectl create secret generic wavefront-token --from-file=api-token=./api-token.txt
```
To install the data platform chart with observability framework using this token with the release name `my-release`:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/dataplatform-bp1 -f values-metrics.yaml \
  --set wavefront.clusterName=<K8s-CLUSTER-NAME> \
  --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
  --set wavefront.wavefront.existingSecret=wavefront-token
```


> **Tip**: List all releases using `helm list`

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

