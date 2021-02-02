# Data Platform with Kafka-Spark-Solr (Blueprint-1)

Data Platform Blueprint1 comprises of Kafka, Spark and Solr. 

This orchestration helm chart can be used to quickly deploy this data platform blueprint on a kubernetes Cluster. It additionally gives you the following benefits: 
1. Ability to deploy data platform in different sizes (Small/Medium/Large) 
2. Resource sizing and placement rules to optimally bring up the platform with resiliency
3. Ability to deploy the Observability framework for the data platform with Wavefront

## TL;DR

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/dataplatform-bp1
```

## Introduction

This chart bootstraps Data Platform deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. 

The "Small" size data platform with observability framework deploys the following:
1. Zookeeper with 3 nodes to be used for both Kafka and Solr
2. Kafka with 3 nodes using the zookeeper deployed above along with metrics exporters
3. Solr with 2 nodes using the zookeeper deployed above along with metrics exporters
4. Spark with 1 Master and 2 worker nodes along with metrics exporters
5. Wavefront Collectors running as DaemonSet and Wavefront Proxy configured for Kafka/Spark/Solr

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/dataplatform-bp1
```

These commands deploy Data Platform on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

To install the chart including observability framework with wavefront, store the Wavefront URL in a environment variable $WAVEFRONT_URL

```console
export WAVEFRONT_URL=<YOUR-CLUSTER>.wavefront.com
```

Also create a secret storing your Wavefront token. API Token can be found at Settings -> User Profile -> API Access. Please store it in a local file api-token.txt to create the secret.

```console
kubectl create secret generic wavefront-token --from-file=api-token=./api-token.txt
```

To install the chart with observability framework with the release name `my-release`:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/dataplatform-bp1 -f values-metrics.yaml
```
> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Data Platform chart and their default values per section/component. Please note we have set the default values for all the below parameters to deploy a optimal and resilient data platform. If you need to update any other parameters apart from the ones mentioned below, you can refer to the corresponding chart. 

### Global parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                            | Global Docker image registry                                                                                                      | `nil`                                                   |
| `global.imagePullSecrets`                         | Global Docker registry secret names as an array                                                                                   | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                             | Global storage class for dynamic provisioning                                                                                     | `nil`                                                   |

### Common parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `nameOverride`                                    | String to partially override solr.fullname                                                                                       | `nil`                                                   |
| `fullnameOverride`                                | String to fully override solr.fullname                                                                                           | `nil`                                                   |
| `clusterDomain`                                   | Default Kubernetes cluster domain                                                                                                 | `cluster.local`                                         |
| `commonLabels`                                    | Labels to add to all deployed objects                                                                                             | `{}`                                                    |
| `commonAnnotations`                               | Annotations to add to all deployed objects                                                                                        | `{}`                                                    |
| `extraDeploy`                                     | Array of extra objects to deploy with the release                                                                                 | `nil` (evaluated as a template)                         |

### Zookeeper chart parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `zookeeper.enabled`                               | Switch to enable or disable the Zookeeper helm chart                                                                              | `true`                                                  |
| `zookeeper.replicaCount`                        | Number of Zookeeper nodes                                                                     | `3`                                                |
| `zookeeper.heap`                                        | Zookeepers's Java Heap size                                                                                                            | `-Xmx4096m -Xms4096m`                                   |
| `zookeeper.resources.limits`                    | The resources limits for Zookeeper containers                                                 | `{}`                                               |
| `zookeeper.resources.requests`                  | The requested resources for Zookeeper containers for a small kubernetes cluster               | `Default resources set in order to make optimal use of the kubernetes cluster resources`                                               |
| `zookeeper.affinity`                            | Affinity for pod assignment                                                               | `Zookeeper Pod Affinity and Anti Affinity rules set for resiliency of the Data Platform` (evaluated as a template)                     |


### Kafka Sub-chart parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `kafka.enabled`                                  | Switch to enable or disable the Kafka helm chart                                                                               | `true`                                             |
| `kafka.replicaCount`                        | Number of Kafka nodes                                                                     | `3`                                                |
| `kafka.heapOpts`                                        | Kafka's Java Heap size                                                                                                            | `-Xmx4096m -Xms4096m`                                   |
| `kafka.resources.limits`                    | The resources limits for Kafka containers                                                 | `{}`                                               |
| `kafka.resources.requests`                  | The requested resources for Kafka containers for a small kubernetes cluster               | `Default resources set in order to make optimal use of the kubernetes cluster resources`                                               |
| `kafka.affinity`                            | Affinity for pod assignment                                                               | `Kafka Pod Affinity and Anti Affinity rules set for resiliency of the Data Platform` (evaluated as a template)                     |
| `kafka.metrics.kafka.enabled`                           | Whether or not to create a standalone Kafka exporter to expose Kafka metrics                                                      | `false`                                                 |
| `kafka.metrics.kafka.resources.limits`                  | Kafka Exporter container resource limits                                                                                          | `{}`                                                    |
| `kafka.metrics.kafka.resources.requests`                | Kafka Exporter container resource requests                                                                                        | `{}`                                                    |
| `kafka.metrics.kafka.service.type`                      | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`) for Kafka Exporter                                            | `ClusterIP`                                             |
| `kafka.metrics.kafka.service.port`                      | Kafka Exporter Prometheus port                                                                                                    | `9308`                                                  |
| `kafka.metrics.jmx.enabled`                             | Whether or not to expose JMX metrics to Prometheus                                                                                | `false`                                                 |
| `kafka.metrics.jmx.resources.limits`                    | JMX Exporter container resource limits                                                                                            | `{}`                                                    |
| `kafka.metrics.jmx.resources.requests`                  | JMX Exporter container resource requests                                                                                          | `{}`                                                    |
| `kafka.metrics.jmx.service.port`                        | JMX Exporter Prometheus port                                                                                                      | `5556`                                                  |
| `kafka.zookeeper.enabled`                               | Switch to enable or disable the Zookeeper helm chart                                                                              | `false`                                                  |
| `externalZookeeper.servers`                       | Server or list of external Zookeeper servers to use                                                                               | `Zookeeper installed as a subchart to be used`                                                    |



### Solr parameters

| Parameter                                         | Description                                                                                                                       | Default                                                 |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `solr.enabled`                                  | Switch to enable or disable the Solr helm chart                                                                                                              | `docker.io`                                             |
| `solr.replicaCount`                        | Number of Solr nodes                                                                     | `2`                                                |
| `solr.resources.limits`                    | The resources limits for Solr containers                                                 | `{}`                                               |
| `solr.resources.requests`                  | The requested resources for Solr containers                                              | `{}`                                               |
| `solr.javaMem`                              | Java memory options to pass to the Solr container                                                | `nil`                              |
| `solr.heap`                                 | Java Heap options to pass to the solr container                                                  | `nil`                              |
| `solr.affinity`                             | Affinity for Solr pods assignment                                                                | `{}` (evaluated as a template)     |
| `solr.exporter.enabled`                              | Start a side-car prometheus exporter                                                                        | `false`                                                                         |
| `solr.exporter.port`                                          | Solr exporter port                                                                                          | `9983`                                                                          |
| `solr.exporter.resources`                            | Exporter resource requests/limit                                                                            | Memory: `256Mi`, CPU: `100m`                                                    |
| `solr.zookeeper.enabled`                             | Enable Zookeeper deployment. Needed for Solr cloud.                                                         | `false`                                                                          |
| `solr.exporter.affinity`                             | Affinity for Solr pods assignment                                                                           | `{}` (evaluated as a template)                                                  |
| `solr.externalZookeeper.servers`                     | Servers for an already existing Zookeeper.                                                                  | `[]`                                                                            |

### Spark Sub-Chart parameters

| Parameter                                   | Description                                                                                                                                | Default                                                 |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `spark.master.enabled`                           | Switch to enable or disable the Spark helm chart                                                                                                   | `{}` (evaluated as a template)                          |
| `spark.master.affinity`                           | Spark master affinity for pod assignment                                                                                                   | `{}` (evaluated as a template)                          |
| `spark.master.resources`                          | CPU/Memory resource requests/limits for Master                                                                                                      | `{}`                                                    |
| `spark.master.extraEnvVars`                       | Extra environment variables to pass to the master container                                                                                | `{}`                                                    |
| `spark.worker.javaOptions`                        | Set options for the JVM in the form `-Dx=y`                                                                                                | No default                                              |
| `spark.worker.replicaCount`                       | Set the number of workers                                                                                                                  | `2`                                                     |
| `spark.worker.affinity`                           | Spark worker affinity for pod assignment                                                                                                   | `{}` (evaluated as a template)                          |
| `spark.worker.resources`                          | CPU/Memory resource requests/limits                                                                                                        | Memory: `256Mi`, CPU: `250m`                            |
| `spark.metrics.enabled`                         | Start a side-car prometheus exporter                                                                                                         | `false`                                                      |
| `spark.metrics.masterAnnotations`               | Annotations for enabling prometheus to access the metrics endpoint of the master nodes                                                       | `{prometheus.io/scrape: "true", prometheus.io/path: "/metrics/", prometheus.io/port: "8080"}` |
| `spark.metrics.workerAnnotations`               | Annotations for enabling prometheus to access the metrics endpoint of the worker nodes                                                       | `{prometheus.io/scrape: "true", prometheus.io/path: "/metrics/", prometheus.io/port: "8081"}` |
| `spark.metrics.resources.limits`                | The resources limits for the metrics exporter container                                                                                      | `{}`                                                         |
| `spark.metrics.resources.requests`              | The requested resources for the metrics exporter container                                                                                   | `{}`                                                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set replicaCount=3 \
  bitnami/solr
```

The above command deploys Kafka with 3 nodes (replicas).

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/solr
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Number of Solr nodes:

```diff
- replicaCount: 1
+ replicaCount: 3
```

- Enable Zookeeper authentication: TBC

```diff
+ auth.jaas.zookeeperUser: zookeeperUser
+ auth.jaas.zookeeperPassword: zookeeperPassword
- zookeeper.auth.enabled: false
+ zookeeper.auth.enabled: true
+ zookeeper.auth.clientUser: zookeeperUser
+ zookeeper.auth.clientPassword: zookeeperPassword
+ zookeeper.auth.serverUsers: zookeeperUser
+ zookeeper.auth.serverPasswords: zookeeperPassword
```

- Enable Pod Disruption Budget:

```diff
- pdb.create: false
+ pdb.create: true
```

- Create a separate Solr  metrics exporter

```diff
- metrics.exporter.enabled: false
+ metrics.exporter.enabled: true
```

- Enable Zookeeper metrics

```diff
+ zookeeper.metrics.enabled: true
```

To horizontally scale this chart once it has been deployed, you can upgrade the statefulset using a new value for the `replicaCount` parameter. Please note that, when enabling TLS encryption, you must update your JKS secret including the keystore for the new replicas.

### Setting custom parameters

Any environment variable beginning with `KAFKA_CFG_` will be mapped to its corresponding Kafka key. For example, use `KAFKA_CFG_BACKGROUND_THREADS` in order to set `background.threads`. In order to pass custom environment variables use the `extraEnvVars` property.

Using `extraEnvVars` with `KAFKA_CFG_` is the preferred and simplest way to add custom Kafka parameters not otherwise specified in this chart. Alternatively, you can provide a *full* Kafka configuration using `config` or `existingConfigmap`.
Setting either `config` or `existingConfigmap` will cause the chart to disregard `KAFKA_CFG_` settings, which are used by many other Kafka-related chart values described above, as well as dynamically generated parameters such as `zookeeper.connect`. This can cause unexpected behavior.


### Accessing Solr from outside the cluster

There are two ways of configuring external access for Solr. Using LoadBalancer services or using NodePort services.

#### Using LoadBalancer services

You have two alternatives to use LoadBalancer services:

- Option A) Use random load balancer IPs using an **initContainer** that waits for the IPs to be ready and discover them automatically.

```console
service.type=LoadBalancer
service.port=8983
```

- Option B) Manually specify the load balancer IPs:

```console
service.type=LoadBalancer
service.port=8983
service.loadBalancerIPs[0]='external-ip-1'
service.loadBalancerIPs[1]='external-ip-2'}
```

Note: You need to know in advance the load balancer IPs so each Solr pod is configured with it.

#### Using NodePort services

You have two alternatives to use NodePort services:

- Option A) Use random node ports using an **initContainer** that discover them automatically.

```console
enabled=true
service.type=NodePort
```

Note: This option requires creating RBAC rules on clusters where RBAC policies are enabled.

- Option B) Manually specify the node ports:

```console
service.type=NodePort
service.nodePorts[0]='node-port-1'
service.nodePorts[1]='node-port-2'
```

Note: You need to know in advance the node ports that will be exposed so each Solr node is configured with it.

The pod will try to get the external ip of the node using `curl -s https://ipinfo.io/ip` unless `externalAccess.service.domain` is provided.

Following the aforementioned steps will also allow to connect the brokers from the outside using the cluster's default service (when `service.type` is `LoadBalancer` or `NodePort`). Use the property `service.externalPort` to specify the port used for external connections.

#### Name resolution with External-DNS TBC

You can use the following values to generate External-DNS annotations which automatically creates DNS records for each ReplicaSet pod:

```yaml
externalAccess:
  service:
    annotations:
      external-dns.alpha.kubernetes.io/hostname: "{{ .targetPod }}.example.com"
```
### Sidecars

If you have a need for additional containers to run within the same pod as Solr (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.


## Persistence

The [Bitnami Solr](https://github.com/bitnami/bitnami-docker-solr) image stores the Kafka data at the `/bitnami/solr` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube. See the [Parameters](#persistence-parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

