# Kafka

[Kafka](https://www.kafka.org/) is a distributed streaming platform used for building real-time data pipelines and streaming apps. It is horizontally scalable, fault-tolerant, wicked fast, and runs in production in thousands of companies.

## TL;DR;

```console
$ helm install bitnami/kafka
```

## Introduction

This chart bootstraps a [Kafka](https://github.com/bitnami/bitnami-docker-kafka) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/kafka
```

The command deploys Kafka on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Kafka chart and their default values.

|          Parameter               |                                                  Description                                               |                                     Default                        |
|----------------------------------|------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------- |
| `global.imageRegistry`           | Global Docker image registry                                                                               | `nil`                                                              |
| `image.registry`                 | Kafka image registry                                                                                       | `docker.io`                                                        |
| `image.repository`               | Kafka Image name                                                                                           | `bitnami/kafka`                                                    |
| `image.tag`                      | Kafka Image tag                                                                                            | `{VERSION}`                                                        |
| `image.pullPolicy`               | Kafka image pull policy                                                                                    | `Always`                                                           |
| `image.pullSecrets`              | Specify image pull secrets                                                                                 | `nil` (does not add image pull secrets to deployed pods)           |
| `image.debug`                    | Specify if debug values should be set                                                                      | `false`                                                            |
| `updateStrategy`                 | Update strategy for the stateful set                                                                       | `1`                                                                |
| `replicaCount`                   | Number of Kafka nodes                                                                                      | `1`                                                                |
| `config`                         | Configuration file for Kafka                                                                               | `nil`                                                              |
| `allowPlaintextListener`         | Allow to use the PLAINTEXT listener                                                                        | `true`                                                             |
| `listeners`                      | The address the socket server listens on.                                                                  | `nil`                                                              |
| `advertisedListeners`            | Hostname and port the broker will advertise to producers and consumers.                                    | `nil`                                                              |
| `brokerId`                       | ID of the Kafka node                                                                                       | `-1`                                                               |
| `deleteTopicEnable`              | Switch to enable topic deletion or not.                                                                    | `false`                                                            |
| `heapOpts`                       | Kafka's Java Heap size.                                                                                    | `-Xmx1024m -Xms1024m`                                              |
| `logFlushIntervalMessages`       | The number of messages to accept before forcing a flush of data to disk.                                   | `10000`                                                            |
| `logFlushIntervalMs`             | The maximum amount of time a message can sit in a log before we force a flush.                             | `1000`                                                             |
| `logRetentionBytes`              | A size-based retention policy for logs.                                                                    | `_1073741824`                                                      |
| `logRetentionCheckIntervalMs`    | The interval at which log segments are checked to see if they can be deleted.                              | `300000`                                                           |
| `logRetentionHours`              | The minimum age of a log file to be eligible for deletion due to age.                                      | `168`                                                              |
| `logSegmentBytes`                | The maximum size of a log segment file. When this size is reached a new log segment will be created.       | `_1073741824`                                                      |
| `logsDirs`                       | A comma separated list of directories under which to store log files.                                      | `/opt/bitnami/kafka/data`                                          |
| `maxMessageBytes`                       | The largest record batch size allowed by Kafka.                                      | `1000012`                                          |
| `numIoThreads`                   | The number of threads doing disk I/O.                                                                      | `8`                                                                |
| `numNetworkThreads`              | The number of threads handling network requests.                                                           | `3`                                                                |
| `numPartitions`                  | The default number of log partitions per topic.                                                            | `1`                                                                |
| `numRecoveryThreadsPerDataDir`   | The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.  | `1`                                                                |
| `socketReceiveBufferBytes`       | The receive buffer (SO_RCVBUF) used by the socket server.                                                  | `102400`                                                           |
| `socketRequestMaxBytes`          | The maximum size of a request that the socket server will accept (protection against OOM).                 | `_104857600`                                                       |
| `socketSendBufferBytes`          | The send buffer (SO_SNDBUF) used by the socket server.                                                     | `102400`                                                           |
| `zookeeperConnectionTimeoutMs`   | Timeout in ms for connecting to zookeeper.                                                                 | `6000`                                                             |
| `auth.enabled`                   | Switch to enable the kafka authentication.                                                                 | `false`                                                            |
| `auth.existingSecret`            | Name of the existing secret containing credentials for brokerUser, interBrokerUser and zookeeperUser.      | `nil`                                                              |
| `auth.certificatesSecret`        | Name of the existing secret containing the certificate files that will be used by Kafka.                   | `nil`                                                              |
| `auth.certificatesPassword`      | Password for the above certificates if they are password protected.                                        | `nil`                                                              |
| `auth.brokerUser`                | Kafka client user.                                                                                         | `user`                                                             |
| `auth.brokerPassword`            | Kafka client password.                                                                                     | `nil`                                                              |
| `auth.interBrokerUser`           | Kafka inter broker communication user                                                                      | `admin`                                                            |
| `auth.interBrokerPassword`       | Kafka inter broker communication password.                                                                 | `nil`                                                              |
| `auth.zookeeperUser`             | Kafka Zookeeper user.                                                                                      | `nil`                                                              |
| `auth.zookeeperPassword`         | Kafka Zookeeper password.                                                                                  | `nil`                                                              |
| `securityContext.enabled`        | Enable security context                                                                                    | `true`                                                             |
| `securityContext.fsGroup`        | Group ID for the container                                                                                 | `1001`                                                             |
| `securityContext.runAsUser`      | User ID for the container                                                                                  | `1001`                                                             |
| `service.type`                   | Kubernetes Service type                                                                                    | `ClusterIP`                                                        |
| `service.port`                   | Kafka port                                                                                                 | `9092`                                                             |
| `persistence.enabled`            | Enable persistence using PVC                                                                               | `true`                                                             |
| `persistence.storageClass`       | PVC Storage Class for Kafka volume                                                                         | `nil`                                                              |
| `persistence.accessMode`         | PVC Access Mode for Kafka volume                                                                           | `ReadWriteOnce`                                                    |
| `persistence.size`               | PVC Storage Request for Kafka volume                                                                       | `8Gi`                                                              |
| `persistence.annotations`        | Annotations for the PVC                                                                                    | `{}`                                                               |
| `nodeSelector`                   | Node labels for pod assignment                                                                             | `{}`                                                               |
| `tolerations`                    | Toleration labels for pod assignment                                                                       | `[]`                                                               |
| `resources`                      | CPU/Memory resource requests/limits                                                                        | Memory: `256Mi`, CPU: `250m`                                       |
| `livenessProbe.enabled`               | would you like a livessProbed to be enabled                                                           |  `true`                                                            |
| `livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                              |  30                                                                |
| `livenessProbe.periodSeconds`         | How often to perform the probe                                                                        |  10                                                                |
| `livenessProbe.timeoutSeconds`        | When the probe times out                                                                              |  5                                                                 |
| `livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.            |  6                                                                 |
| `livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed           |  1                                                                 |
| `readinessProbe.enabled`              | would you like a readinessProbe to be enabled                                                         |  `true`                                                            |
| `readinessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                              |  5                                                                 |
| `readinessProbe.periodSeconds`        | How often to perform the probe                                                                        |  10                                                                |
| `readinessProbe.timeoutSeconds`       | When the probe times out                                                                              |  5                                                                 |
| `readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.            |  6                                                                 |
| `readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed           |  1                                                                 |
| `metrics.kafka.enabled`               | Whether or not to create a separate Kafka exporter                                                    | `false`                                                            |
| `metrics.kafka.image.registry`        | Kafka exporter image registry                                                                         | `docker.io`                                                        |
| `metrics.kafka.image.repository`      | Kafka exporter image name                                                                             | `danielqsj/kafka-exporter`                                         |
| `metrics.kafka.image.tag`             | Kafka exporter image tag                                                                              | `v1.0.1`                                                           |
| `metrics.kafka.image.pullPolicy`      | Kafka exporter image pull policy                                                                      | `Always`                                                           |
| `metrics.kafka.image.pullSecrets`     | Specify image pull secrets                                                                            | `nil` (does not add image pull secrets to deployed pods)           |
| `metrics.kafka.interval`              | Interval that Prometheus scrapes Kafka metrics when using Prometheus Operator                         | `10s`                                                              |
| `metrics.kafka.port`                  | Kafka Exporter Port which exposes metrics in Prometheus format for scraping                           | `9308`                                                             |
| `metrics.kafka.resources`             | Allows setting resource limits for kafka-exporter pod                                                 | `{}`                                                               |
| `metrics.jmx.resources`               | Allows setting resource limits for jmx sidecar container                                              | `{}`                                                               |
| `metrics.jmx.enabled`                 | Whether or not to expose JMX metrics to Prometheus                                                    | `false`                                                            |
| `metrics.jmx.image.registry`          | JMX exporter image registry                                                                           | `docker.io`                                                        |
| `metrics.jmx.image.repository`        | JMX exporter image name                                                                               | `solsson/kafka-prometheus-jmx-exporter@sha256`                     |
| `metrics.jmx.image.tag`               | JMX exporter image tag                                                                                | `a23062396cd5af1acdf76512632c20ea6be76885dfc20cd9ff40fb23846557e8` |
| `metrics.jmx.image.pullPolicy`        | JMX exporter image pull policy                                                                        | `Always`                                                           |
| `metrics.jmx.image.pullSecrets`       | Specify image pull secrets                                                                            | `nil` (does not add image pull secrets to deployed pods)           |
| `metrics.jmx.interval`                | Interval that Prometheus scrapes JMX metrics when using Prometheus Operator                           | `10s`                                                              |
| `metrics.jmx.exporterPort`            | JMX Exporter Port which exposes metrics in Prometheus format for scraping                             | `5556`                                                             |
| `metrics.jmx.configMap.enabled`       | Enable the default ConfigMap for JMX                                                                  | `true`                                                             |
| `metrics.jmx.configMap.overrideConfig`| Allows config file to be generated by passing values to ConfigMap                                     | `{}`                                                               |
| `metrics.jmx.configMap.overrideName`  | Allows setting the name of the ConfigMap to be used                                                   | `""`                                                               |
| `metrics.jmx.jmxPort`                 | The jmx port which JMX style metrics are exposed (note: these are not scrapeable by Prometheus)       | `5555`                                                             |
| `metrics.jmx.whitelistObjectNames`    | Allows setting which JMX objects you want to expose to via JMX stats to JMX Exporter                  | (see `values.yaml`)                                                |
| `zookeeper.enabled`                   | Switch to enable or disable the Zookeeper helm chart                                                  | `true`                                                             |
| `externalZookeeper.servers`           | Server or list of external zookeeper servers to use.                                                  | `nil`                                                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set kafkaPassword=secretpassword,kafkaDatabase=my-database \
    bitnami/kafka
```

The above command sets the Kafka `kafka` account password to `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/kafka
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Production and horizontal scaling

The following repo contains the recommended production settings for Kafka server in an alternative [values file](values-production.yaml). Please read carefully the comments in the values-production.yaml file to set up your environment

To horizontally scale this chart, first download the [values-production.yaml](values-production.yaml) file to your local folder, then:

```console
$ helm install --name my-release -f ./values-production.yaml bitnami/kafka
$ kubectl scale statefulset my-kafka-slave --replicas=3
```

## Enable security for Kafka and Zookeeper

If you enabled the authentication for Kafka, the SASL_SSL listener will be configured with your provided inputs. In particular you can set the following pair of credentials:

 * brokerUser/brokerPassword: To authenticate kafka clients against kafka brokers
 * interBrokerUser/interBrokerPassword: To authenticate kafka brokers between them.
 * zookeeperUser/zookeeperPassword: In the case that the Zookeeper chart is deployed with SASL authentication enabled.

In order to configure the authentication, you **must** create a secret containing the *kafka.keystore.jks* and *kafka.trustore.jks* certificates and pass the secret name with the `--auth.certificatesSecret` option when deploying the chart.

You can create the secret with this command assuming you have your certificates in your working directory:

```console
kubectl create secret generic kafka-certificates --from-file=./kafka.keystore.jks --from-file=./kafka.truststore.jks
```

As an example of Kafka installed with authentication you can use this command:

```console
helm install --name my-release bitnami/kafka --set auth.enabled=true \
             --set auth.brokerUser=brokerUser --set auth.brokerPassword=brokerPassword \
             --set auth.interBrokerUser=interBrokerUser --set auth.interBrokerPassword=interBrokerPassword \
             --set auth.zookeeperUser=zookeeperUser --set auth.zookeeperPassword=zookeeperPassword \
             --set zookeeper.auth.enabled=-true --set zookeeper.auth.serverUser=zookeeperUser --set zookeeper.auth.serverPassword=zookeeperPassword \
             --set zookeeper.auth.clientUser=zookeeperUser --set zookeeper.auth.clientPassword=zookeeperPassword \
             --set auth.certificatesSecret=kafka-certificates
```

> **Note**: If the JKS files are password protected (recommended), you will need to provide the password to get access to the keystores. To do so, use the `--auth.certificatesPassword` option to provide your password.

## Persistence

The [Bitnami Kafka](https://github.com/bitnami/bitnami-docker-kafka) image stores the Kafka data at the `/bitnami/kafka` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is kafka:

```console
$ kubectl delete statefulset kafka-kafka --cascade=false
$ kubectl delete statefulset kafka-zookeeper --cascade=false
```
