# Kafka

[Kafka](https://www.kafka.org/) is a distributed streaming platform used for building real-time data pipelines and streaming apps. It is horizontally scalable, fault-tolerant, wicked fast, and runs in production in thousands of companies.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kafka
```

## Introduction

This chart bootstraps a [Kafka](https://github.com/bitnami/bitnami-docker-kafka) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kafka
```

These commands deploy Kafka on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Kafka chart and their default values.

|                Parameter                |                                                                        Description                                                                        |                         Default                         |
|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                  | Global Docker image registry                                                                                                                              | `nil`                                                   |
| `global.imagePullSecrets`               | Global Docker registry secret names as an array                                                                                                           | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                   | Global storage class for dynamic provisioning                                                                                                             | `nil`                                                   |
| `image.registry`                        | Kafka image registry                                                                                                                                      | `docker.io`                                             |
| `image.repository`                      | Kafka Image name                                                                                                                                          | `bitnami/kafka`                                         |
| `image.tag`                             | Kafka Image tag                                                                                                                                           | `{VERSION}`                                             |
| `image.pullPolicy`                      | Kafka image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                           | Specify if debug values should be set                                                                                                                     | `false`                                                 |
| `nameOverride`                          | String to partially override kafka.fullname template with a string (will append the release name)                                                         | `nil`                                                   |
| `fullnameOverride`                      | String to fully override kafka.fullname template with a string                                                                                            | `nil`                                                   |
| `volumePermissions.enabled`             | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`      | Init container volume-permissions image registry                                                                                                          | `docker.io`                                             |
| `volumePermissions.image.repository`    | Init container volume-permissions image name                                                                                                              | `bitnami/minideb`                                       |
| `volumePermissions.image.tag`           | Init container volume-permissions image tag                                                                                                               | `buster`                                                |
| `volumePermissions.image.pullPolicy`    | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                |
| `volumePermissions.resources`           | Init container resource requests/limit                                                                                                                    | `nil`                                                   |
| `updateStrategy`                        | Update strategy for the stateful set                                                                                                                      | `RollingUpdate`                                         |
| `rollingUpdatePartition`                | Partition update strategy                                                                                                                                 | `nil`                                                   |
| `podDisruptionBudget.maxUnavailable`    | Max number of pods down simultaneously                                                                                                                    | `1`                                                     |
| `replicaCount`                          | Number of Kafka nodes                                                                                                                                     | `1`                                                     |
| `config`                                | Configuration file for Kafka                                                                                                                              | `nil`                                                   |
| `allowPlaintextListener`                | Allow to use the PLAINTEXT listener                                                                                                                       | `true`                                                  |
| `listeners`                             | The address the socket server listens on.                                                                                                                 | `nil`                                                   |
| `advertisedListeners`                   | Hostname and port the broker will advertise to producers and consumers.                                                                                   | `nil`                                                   |
| `listenerSecurityProtocolMap`           | The protocol->listener mapping.                                                                                                                           | `nil`                                                   |
| `interBrokerListenerName`               | The listener that the brokers should communicate on.                                                                                                      | `nil`                                                   |
| `brokerId`                              | ID of the Kafka node                                                                                                                                      | `-1`                                                    |
| `deleteTopicEnable`                     | Switch to enable topic deletion or not.                                                                                                                   | `false`                                                 |
| `heapOpts`                              | Kafka's Java Heap size.                                                                                                                                   | `-Xmx1024m -Xms1024m`                                   |
| `logFlushIntervalMessages`              | The number of messages to accept before forcing a flush of data to disk.                                                                                  | `10000`                                                 |
| `logFlushIntervalMs`                    | The maximum amount of time a message can sit in a log before we force a flush.                                                                            | `1000`                                                  |
| `logRetentionBytes`                     | A size-based retention policy for logs.                                                                                                                   | `_1073741824`                                           |
| `logRetentionCheckIntervalMs`           | The interval at which log segments are checked to see if they can be deleted.                                                                             | `300000`                                                |
| `logRetentionHours`                     | The minimum age of a log file to be eligible for deletion due to age.                                                                                     | `168`                                                   |
| `logSegmentBytes`                       | The maximum size of a log segment file. When this size is reached a new log segment will be created.                                                      | `_1073741824`                                           |
| `logMessageFormatVersion`               | Logging message format version.                                                                                                                           | ``                                                      |
| `logsDirs`                              | A comma separated list of directories under which to store log files.                                                                                     | `/bitnami/kafka/data`                                   |
| `maxMessageBytes`                       | The largest record batch size allowed by Kafka.                                                                                                           | `1000012`                                               |
| `defaultReplicationFactor`              | Default replication factors for automatically created topics                                                                                              | `1`                                                     |
| `offsetsTopicReplicationFactor`         | The replication factor for the offsets topic                                                                                                              | `1`                                                     |
| `transactionStateLogReplicationFactor ` | The replication factor for the transaction topic                                                                                                          | `1`                                                     |
| `transactionStateLogMinIsr `            | Overridden min.insync.replicas config for the transaction topic                                                                                           | `1`                                                     |
| `numIoThreads`                          | The number of threads doing disk I/O.                                                                                                                     | `8`                                                     |
| `numNetworkThreads`                     | The number of threads handling network requests.                                                                                                          | `3`                                                     |
| `numPartitions`                         | The default number of log partitions per topic.                                                                                                           | `1`                                                     |
| `numRecoveryThreadsPerDataDir`          | The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.                                                 | `1`                                                     |
| `socketReceiveBufferBytes`              | The receive buffer (SO_RCVBUF) used by the socket server.                                                                                                 | `102400`                                                |
| `socketRequestMaxBytes`                 | The maximum size of a request that the socket server will accept (protection against OOM).                                                                | `_104857600`                                            |
| `socketSendBufferBytes`                 | The send buffer (SO_SNDBUF) used by the socket server.                                                                                                    | `102400`                                                |
| `zookeeperConnectionTimeoutMs`          | Timeout in ms for connecting to Zookeeper.                                                                                                                | `6000`                                                  |
| `extraEnvVars`                          | Extra environment variables to add to kafka pods                                                                                                          | `nil`                                                   |
| `sslEndpointIdentificationAlgorithm`    | The endpoint identification algorithm to validate server hostname using server certificate.                                                               | `https`                                                 |
| `auth.enabled`                          | Switch to enable the kafka authentication.                                                                                                                | `false`                                                 |
| `auth.existingSecret`                   | Name of the existing secret containing credentials for brokerUser, interBrokerUser and zookeeperUser.                                                     | `nil`                                                   |
| `auth.certificatesSecret`               | Name of the existing secret containing the certificate files that will be used by Kafka.                                                                  | `nil`                                                   |
| `auth.certificatesPassword`             | Password for the above certificates if they are password protected.                                                                                       | `nil`                                                   |
| `auth.brokerUser`                       | Kafka client user.                                                                                                                                        | `user`                                                  |
| `auth.brokerPassword`                   | Kafka client password.                                                                                                                                    | `nil`                                                   |
| `auth.interBrokerUser`                  | Kafka inter broker communication user                                                                                                                     | `admin`                                                 |
| `auth.interBrokerPassword`              | Kafka inter broker communication password.                                                                                                                | `nil`                                                   |
| `auth.zookeeperUser`                    | Kafka Zookeeper user.                                                                                                                                     | `nil`                                                   |
| `auth.zookeeperPassword`                | Kafka Zookeeper password.                                                                                                                                 | `nil`                                                   |
| `securityContext.enabled`               | Enable security context                                                                                                                                   | `true`                                                  |
| `securityContext.fsGroup`               | Group ID for the container                                                                                                                                | `1001`                                                  |
| `securityContext.runAsUser`             | User ID for the container                                                                                                                                 | `1001`                                                  |
| `clusterDomain`                         | Kubernetes cluster domain                                                                                                                                 | `cluster.local`                                         |
| `service.type`                          | Kubernetes Service type                                                                                                                                   | `ClusterIP`                                             |
| `service.port`                          | Kafka port                                                                                                                                                | `9092`                                                  |
| `service.nodePort`                      | Kubernetes Service nodePort                                                                                                                               | `nil`                                                   |
| `service.loadBalancerIP`                | loadBalancerIP for Kafka Service                                                                                                                          | `nil`                                                   |
| `service.annotations`                   | Service annotations                                                                                                                                       | ``                                                      |
| `externalAccess.enabled`                | Enable Kubernetes external cluster access to Kafka brokers                                                                                                | `false`                                                 |
| `externalAccess.service.type`           | Kubernetes Servive type for external access. It can be NodePort or LoadBalancer                                                                           | `LoadBalancer`                                          |
| `externalAccess.service.port`           | Kafka port used for external access when service type is LoadBalancer                                                                                     | `19092`                                                 |
| `externalAccess.service.loadBalancerIP` | Array of load balancer IPs for Kafka brokers.                                                                                                             | `[]`                                                    |
| `externalAccess.service.domain`         | Domain or external ip used to configure Kafka external listener when service type is NodePort                                                             | `nil`                                                   |
| `externalAccess.service.nodePort`       | Array of node ports used to configure Kafka external listener when service type is NodePort                                                               | `[]`                                                    |
| `externalAccess.service.annotations`    | Service annotations for external access                                                                                                                   | ``                                                      |
| `serviceAccount.create`                 | Enable creation of ServiceAccount for kafka pod                                                                                                           | `false`                                                 |
| `serviceAccount.name`                   | Name of the created serviceAccount                                                                                                                        | Generated using the `kafka.fullname` template           |
| `persistence.enabled`                   | Enable Kafka persistence using PVC, note that Zookeeper perisstency is unaffected                                                                         | `true`                                                  |
| `persistence.existingClaim`             | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template.                                                                        | `nil`                                                   |
| `persistence.storageClass`              | PVC Storage Class for Kafka volume                                                                                                                        | `nil`                                                   |
| `persistence.accessMode`                | PVC Access Mode for Kafka volume                                                                                                                          | `ReadWriteOnce`                                         |
| `persistence.size`                      | PVC Storage Request for Kafka volume                                                                                                                      | `8Gi`                                                   |
| `persistence.annotations`               | Annotations for the PVC                                                                                                                                   | `{}`                                                    |
| `nodeSelector`                          | Node labels for pod assignment                                                                                                                            | `{}`                                                    |
| `tolerations`                           | Toleration labels for pod assignment                                                                                                                      | `[]`                                                    |
| `affinity`                              | Map of node/pod affinities                                                                                                                                | `{}`                                                    |
| `resources`                             | CPU/Memory resource requests/limits                                                                                                                       | Memory: `256Mi`, CPU: `250m`                            |
| `livenessProbe.enabled`                 | would you like a livessProbed to be enabled                                                                                                               | `true`                                                  |
| `livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated                                                                                                                  | 30                                                      |
| `livenessProbe.periodSeconds`           | How often to perform the probe                                                                                                                            | 10                                                      |
| `livenessProbe.timeoutSeconds`          | When the probe times out                                                                                                                                  | 5                                                       |
| `livenessProbe.failureThreshold`        | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | 6                                                       |
| `livenessProbe.successThreshold`        | Minimum consecutive successes for the probe to be considered successful after having failed                                                               | 1                                                       |
| `readinessProbe.enabled`                | would you like a readinessProbe to be enabled                                                                                                             | `true`                                                  |
| `readinessProbe.initialDelaySeconds`    | Delay before liveness probe is initiated                                                                                                                  | 5                                                       |
| `readinessProbe.periodSeconds`          | How often to perform the probe                                                                                                                            | 10                                                      |
| `readinessProbe.timeoutSeconds`         | When the probe times out                                                                                                                                  | 5                                                       |
| `readinessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | 6                                                       |
| `readinessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed                                                               | 1                                                       |
| `metrics.kafka.enabled`                 | Whether or not to create a standalone Kafka exporter to expose Kafka metrics                                                                              | `false`                                                 |
| `metrics.kafka.image.registry`          | Kafka exporter image registry                                                                                                                             | `docker.io`                                             |
| `metrics.kafka.image.repository`        | Kafka exporter image name                                                                                                                                 | `bitnami/kafka-exporter`                                |
| `metrics.kafka.image.tag`               | Kafka exporter image tag                                                                                                                                  | `{TAG_NAME}`                                            |
| `metrics.kafka.image.pullPolicy`        | Kafka exporter image pull policy                                                                                                                          | `IfNotPresent`                                          |
| `metrics.kafka.image.pullSecrets`       | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.kafka.interval`                | Interval that Prometheus scrapes Kafka metrics when using Prometheus Operator                                                                             | `10s`                                                   |
| `metrics.kafka.port`                    | Kafka Exporter Port which exposes metrics in Prometheus format for scraping                                                                               | `9308`                                                  |
| `metrics.kafka.resources`               | Allows setting resource limits for kafka-exporter pod                                                                                                     | `{}`                                                    |
| `metrics.kafka.annotations`             | Annotations for Prometheus metrics deployment                                                                                                             | `{}`                                                    |
| `metrics.kafka.service.type`            | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`) for Kafka Exporter                                                                    | `ClusterIP`                                             |
| `metrics.kafka.service.port`            | Kafka Exporter Prometheus port                                                                                                                            | `9308`                                                  |
| `metrics.kafka.service.nodePort`        | Kubernetes HTTP node port                                                                                                                                 | `""`                                                    |
| `metrics.kafka.service.annotations`     | Annotations for Prometheus metrics service                                                                                                                | `Check values.yaml file`                                |
| `metrics.kafka.service.loadBalancerIP`  | loadBalancerIP if service type is `LoadBalancer`                                                                                                          | `nil`                                                   |
| `metrics.kafka.service.clusterIP`       | Static clusterIP or None for headless services                                                                                                            | `nil`                                                   |
| `metrics.jmx.enabled`                   | Whether or not to expose JMX metrics to Prometheus                                                                                                        | `false`                                                 |
| `metrics.jmx.image.registry`            | JMX exporter image registry                                                                                                                               | `docker.io`                                             |
| `metrics.jmx.image.repository`          | JMX exporter image name                                                                                                                                   | `bitnami/jmx-exporter`                                  |
| `metrics.jmx.image.tag`                 | JMX exporter image tag                                                                                                                                    | `{TAG_NAME}`                                            |
| `metrics.jmx.image.pullPolicy`          | JMX exporter image pull policy                                                                                                                            | `IfNotPresent`                                          |
| `metrics.jmx.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.jmx.interval`                  | Interval that Prometheus scrapes JMX metrics when using Prometheus Operator                                                                               | `10s`                                                   |
| `metrics.jmx.exporterPort`              | JMX Exporter Port which exposes metrics in Prometheus format for scraping                                                                                 | `5556`                                                  |
| `metrics.jmx.resources`                 | Allows setting resource limits for jmx sidecar container                                                                                                  | `{}`                                                    |
| `metrics.jmx.service.type`              | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`) for JMX Exporter                                                                      | `ClusterIP`                                             |
| `metrics.jmx.service.port`              | JMX Exporter Prometheus port                                                                                                                              | `5556`                                                  |
| `metrics.jmx.service.nodePort`          | Kubernetes HTTP node port                                                                                                                                 | `""`                                                    |
| `metrics.jmx.service.annotations`       | Annotations for Prometheus metrics service                                                                                                                | `Check values.yaml file`                                |
| `metrics.jmx.service.loadBalancerIP`    | loadBalancerIP if service type is `LoadBalancer`                                                                                                          | `nil`                                                   |
| `metrics.jmx.service.clusterIP`         | Static clusterIP or None for headless services                                                                                                            | `nil`                                                   |
| `metrics.jmx.configMap.enabled`         | Enable the default ConfigMap for JMX                                                                                                                      | `true`                                                  |
| `metrics.jmx.configMap.overrideConfig`  | Allows config file to be generated by passing values to ConfigMap                                                                                         | `{}`                                                    |
| `metrics.jmx.configMap.overrideName`    | Allows setting the name of the ConfigMap to be used                                                                                                       | `""`                                                    |
| `metrics.jmx.jmxPort`                   | The jmx port which JMX style metrics are exposed (note: these are not scrapeable by Prometheus)                                                           | `5555`                                                  |
| `metrics.jmx.whitelistObjectNames`      | Allows setting which JMX objects you want to expose to via JMX stats to JMX Exporter                                                                      | (see `values.yaml`)                                     |
| `metrics.serviceMonitor.enabled`        | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.kafka.enabled` or `metrics.jmx.enabled` to be `true`)                     | `false`                                                 |
| `metrics.serviceMonitor.namespace`      | Namespace which Prometheus is running in                                                                                                                  | `monitoring`                                            |
| `metrics.serviceMonitor.interval`       | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                                                    | `nil`                                                   |
| `metrics.serviceMonitor.selector`       | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                                | `{ prometheus: kube-prometheus }`                       |
| `zookeeper.enabled`                     | Switch to enable or disable the Zookeeper helm chart                                                                                                      | `true`                                                  |
| `zookeeper.persistence.enabled`         | Enable Zookeeper persistence using PVC                                                                                                                    | `true`                                                  |
| `externalZookeeper.servers`             | Server or list of external Zookeeper servers to use.                                                                                                      | `nil`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set kafkaPassword=secretpassword,kafkaDatabase=my-database \
    bitnami/kafka
```

The above command sets the Kafka `kafka` account password to `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/kafka
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Number of Kafka nodes:
```diff
- replicaCount: 1
+ replicaCount: 3
```

- Allow to use the PLAINTEXT listener:
```diff
- allowPlaintextListener: true
+ allowPlaintextListener: false
```

- Default replication factors for automatically created topics:
```diff
- defaultReplicationFactor: 1
+ defaultReplicationFactor: 3
```

- The replication factor for the offsets topic:
```diff
- offsetsTopicReplicationFactor: 1
+ offsetsTopicReplicationFactor: 3
```

- The replication factor for the transaction topic:
```diff
- transactionStateLogReplicationFactor: 1
+ transactionStateLogReplicationFactor: 3
```

- Overridden min.insync.replicas config for the transaction topic:
```diff
- transactionStateLogMinIsr: 1
+ transactionStateLogMinIsr: 3
```

- Switch to enable the kafka authentication:
```diff
- auth.enabled: false
+ auth.enabled: true
```

- Whether or not to create a separate Kafka exporter:
```diff
- metrics.kafka.enabled: false
+ metrics.kafka.enabled: true
```

- Whether or not to expose JMX metrics to Prometheus:
```diff
- metrics.jmx.enabled: false
+ metrics.jmx.enabled: true
```

- Zookeeper chart metrics configuration:
```diff
+ zookeeper.metrics.enabled: true
```

To horizontally scale this chart once it has been deployed, you can upgrade the deployment using a new value for the `replicaCount` parameter.

### Setting custom parameters

Any environment variable beginning with `KAFKA_CFG_` will be mapped to its corresponding Kafka key. For example, use `KAFKA_CFG_BACKGROUND_THREADS` in order to set `background.threads`.
In order to pass custom environment variables use the `extraEnvVars` property.

### Enable security for Kafka and Zookeeper

If you enabled the authentication for Kafka, the SASL_SSL listener will be configured with your provided inputs. In particular you can set the following pair of credentials:

 * brokerUser/brokerPassword: To authenticate kafka clients against kafka brokers
 * interBrokerUser/interBrokerPassword: To authenticate kafka brokers between them.
 * zookeeperUser/zookeeperPassword: In the case that the Zookeeper chart is deployed with SASL authentication enabled.

In order to configure the authentication, you **must** create a secret containing the *kafka.keystore.jks* and *kafka.trustore.jks* certificates and pass the secret name with the `--auth.certificatesSecret` option when deploying the chart.

You can create the secret and deploy the chart with authentication using the following parameters:

```console
auth.enabled=true
auth.brokerUser=brokerUser
auth.brokerPassword=brokerPassword
auth.interBrokerUser=interBrokerUser
auth.interBrokerPassword=interBrokerPassword
auth.zookeeperUser=zookeeperUser
auth.zookeeperPassword=zookeeperPassword
zookeeper.auth.enabled=true
zookeeper.auth.serverUsers=zookeeperUser
zookeeper.auth.serverPasswords=zookeeperPassword
zookeeper.auth.clientUser=zookeeperUser
zookeeper.auth.clientPassword=zookeeperPassword
auth.certificatesSecret=kafka-certificates
```

> **Note**: If the JKS files are password protected (recommended), you will need to provide the password to get access to the keystores. To do so, use the `auth.certificatesPassword` option to provide your password.

### Accessing Kafka brokers from outside the cluster

In order to access Kafka Brokers from outside the cluster, an additional listener and advertised listener must be configured. Additionally, a specific service per kafka pod will be created.

There are two ways of configuring external access. Using LoadBalancer services or using NodePort services.

#### Using LoadBalancer services

```console
externalAccess.enabled=true
externalAccess.service.type=LoadBalancer
externalAccess.service.port=19092
externalAccess.service.loadBalancerIP={'external-ip-1', 'external-ip-2'}
```

You need to know in advance the load balancer IPs so each Kafka broker advertised listener is configured with it.

#### Using NodePort services

```console
externalAccess.enabled=true
externalAccess.service.type=NodePort
externalAccess.service.nodePort={'node-port-1', 'node-port-2'}
```

You need to know in advance the NodePort that will be exposed for each Kafka broker. It will be used to configure the advertised listener of each broker.

The pod will try to get the external ip of the node using `curl -s https://ipinfo.io/ip` unless `externalAccess.service.domain` is provided.

## Persistence

The [Bitnami Kafka](https://github.com/bitnami/bitnami-docker-kafka) image stores the Kafka data at the `/bitnami/kafka` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Upgrading

### To 7.0.0

Backwards compatibility is not guaranteed when Kafka metrics are enabled, unless you modify the labels used on the exporter deployments.
Use the workaround below to upgrade from versions previous to 7.0.0. The following example assumes that the release name is kafka:

```console
$ helm upgrade kafka bitnami/kafka --version 6.1.8 --set metrics.kafka.enabled=false
$ helm upgrade kafka bitnami/kafka --version 7.0.0 --set metrics.kafka.enabled=true
```

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is kafka:

```console
$ kubectl delete statefulset kafka-kafka --cascade=false
$ kubectl delete statefulset kafka-zookeeper --cascade=false
```

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is kafka:

```console
$ kubectl delete statefulset kafka-kafka --cascade=false
$ kubectl delete statefulset kafka-zookeeper --cascade=false
```
