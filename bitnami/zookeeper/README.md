# Zookeeper

[Zookeeper](https://zookeeper.apache.org/) is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or other by distributed applications.

## TL;DR;

```console
$ helm install bitnami/zookeeper
```

## Introduction

This chart bootstraps a [Zookeeper](https://github.com/bitnami/bitnami-docker-zookeeper) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/zookeeper
```

The command deploys Zookeeper on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Zookeeper chart and their default values.

|              Parameter                |                              Description                            |                            Default                       |
|---------------------------------------|---------------------------------------------------------------------|----------------------------------------------------------|
| `global.imageRegistry`                | Global Docker image registry                                        | `nil`                                                    |
| `global.imagePullSecrets`             | Global Docker registry secret names as an array                     | `[]` (does not add image pull secrets to deployed pods)  |
| `image.registry`                      | Zookeeper image registry                                            | `docker.io`                                              |
| `image.repository`                    | Zookeeper Image name                                                | `bitnami/zookeeper`                                      |
| `image.tag`                           | Zookeeper Image tag                                                 | `{TAG_NAME}`                                             |
| `image.pullPolicy`                    | Zookeeper image pull policy                                         | `IfNotPresent`                                           |
| `image.pullSecrets`                   | Specify docker-registry secret names as an array                    | `[]` (does not add image pull secrets to deployed pods)  |
| `image.debug`                         | Specify if debug values should be set                               | `false`                                                  |
| `nameOverride`              | String to partially override zookeeper.fullname template with a string (will append the release name)                                           | `nil`                                                    |
| `fullnameOverride`              | String to fully override zookeeper.fullname template with a string                                           | `nil`                                                    |
| `updateStrategy`                      | Update strategies                                                   | `RollingUpdate`                                          |
| `podDisruptionBudget.maxUnavailable`  | Max number of pods down simultaneously                              | `1`                                                      |
| `rollingUpdatePartition`              | Partition update strategy                                           | `nil`                                                    |
| `podManagementpolicy`                 | Pod management policy                                               | `Parallel`                                               |
| `replicaCount`                        | Number of ZooKeeper nodes                                           | `1`                                                      |
| `tickTime`                            | Basic time unit in milliseconds used by ZooKeeper for heartbeats    | `2000`                                                   |
| `initLimit`                           | Time the ZooKeeper servers in quorum have to connect to a leader    | `10`                                                     |
| `syncLimit`                           | How far out of date a server can be from a leader                   | `5`                                                      |
| `maxClientCnxns`                      | Number of concurrent connections that a single client may make to a single member | `60`                                       |
| `allowAnonymousLogin`                 | Allow to accept connections from unauthenticated users              | `yes`                                                    |
| `auth.existingSecret`                 | Use existing secret (ignores previous password)                     | `nil`                                                    |
| `auth.enabled`                        | Enable Zookeeper auth                                               | `false`                                                  |
| `auth.clientUser`                     | User that will use Zookeeper clients to auth                        | `nil`                                                    |
| `auth.clientPassword`                 | Password that will use Zookeeper clients to auth                    | `nil`                                                    |
| `auth.serverUsers`                    | List of user to be created                                          | `nil`                                                     |
| `auth.serverPasswords`                | List of passwords to assign to users when created                   | `nil`                                                     |
| `heapSize`                            | Size in MB for the Java Heap options (Xmx and XMs)                  | `[]`                                                     |
| `logLevel`                            | Log level of Zookeeper server                                       | `ERROR`                                                  |
| `jvmFlags`                            | Default JVMFLAGS for the ZooKeeper process                          | `nil`                                                    |
| `config`                              | Configure ZooKeeper with a custom zoo.conf file                     | `nil`                                                    |
| `service.type`                        | Kubernetes Service type                                             | `ClusterIP`                                              |
| `service.port`                        | ZooKeeper port                                                      | `2181`                                                   |
| `service.followerPort`                | ZooKeeper follower port                                             | `2888`                                                   |
| `service.electionPort`                | ZooKeeper election port                                             | `3888`                                                   |
| `service.publishNotReadyAddresses`    | If the ZooKeeper headless service should publish DNS records for not ready pods | `true`                                      |
| `securityContext.enabled`             | Enable security context (ZooKeeper master pod)                      | `true`                                                   |
| `securityContext.fsGroup`             | Group ID for the container (ZooKeeper master pod)                   | `1001`                                                   |
| `securityContext.runAsUser`           | User ID for the container (ZooKeeper master pod)                    | `1001`                                                   |
| `persistence.enabled`                 | Enable persistence using PVC                                        | `true`                                                   |
| `persistence.storageClass`            | PVC Storage Class for Zookeeper volume                              | `nil`                                                    |
| `persistence.accessMode`              | PVC Access Mode for Zookeeper volume                                | `ReadWriteOnce`                                          |
| `persistence.size`                    | PVC Storage Request for Zookeeper volume                            | `8Gi`                                                    |
| `persistence.annotations`             | Annotations for the PVC                                             | `{}`                                                     |
| `nodeSelector`                        | Node labels for pod assignment                                      | `{}`                                                     |
| `tolerations`                         | Toleration labels for pod assignment                                | `[]`                                                     |
| `affinity`                            | Map of node/pod affinities                                          | `{}`                                                     |
| `resources`                           | CPU/Memory resource requests/limits                                 | Memory: `256Mi`, CPU: `250m`                             |
| `livenessProbe.enabled`               | would you like a livessProbed to be enabled                         | `true`                                                   |
| `livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                            | 30                                                       |
| `livenessProbe.periodSeconds`         | How often to perform the probe                                      | 10                                                       |
| `livenessProbe.timeoutSeconds`        | When the probe times out                                            | 5                                                        |
| `livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded   | 6                                |
| `livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed | 1                                |
| `readinessProbe.enabled`              | Would you like a readinessProbe to be enabled                       | `true`                                                   |
| `readinessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                            | 5                                                        |
| `readinessProbe.periodSeconds`        | How often to perform the probe                                      | 10                                                       |
| `readinessProbe.timeoutSeconds`       | When the probe times out                                            | 5                                                        |
| `readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded   | 6                                |
| `readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed | 1                                |
| `metrics.enabled`                     | Start a side-car prometheus exporter                                | `false`                                                  |
| `metrics.image.registry`              | ZooKeeper exporter image registry                                   | `docker.io`                                              |
| `metrics.image.repository`            | ZooKeeper exporter image name                                       | `javsalgar/zookeeper-exporter`                           |
| `metrics.image.tag`                   | ZooKeeper exporter image tag                                        | `latest`                                                 |
| `metrics.image.pullPolicy`            | Image pull policy                                                   | `IfNotPresent`                                           |
| `metrics.image.pullSecrets`           | Specify docker-registry secret names as an array                    | `nil`                                                    |
| `metrics.podLabels`                   | Additional labels for Metrics exporter pod                          | `{}`                                                     |
| `metrics.podAnnotations`              | Additional annotations for Metrics exporter pod                     | `{prometheus.io/scrape: "true", prometheus.io/port: "9141"}` |
| `metrics.resources`                   | Exporter resource requests/limit                                    | Memory: `256Mi`, CPU: `100m`                             |
| `metrics.tolerations`                 | Exporter toleration labels for pod assignment                       | `[]`                                                     |
| `metrics.timeoutSeconds`              | Timeout in seconds the exporter uses to scrape its targets          | 3                                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set auth.clientUser=newUser \
    bitnami/zookeeper
```

The above command sets the ZooKeeper user to `newUser`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/zookeeper
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml bitnami/zookeeper
```

- Number of ZooKeeper nodes:
```diff
- replicaCount: 1
+ replicaCount: 3
```

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Log level

You can configure the Zookeeper log level using the `ZOO_LOG_LEVEL` environment variable. By default, it is set to `ERROR` because of each readiness probe produce an `INFO` message on connection and a `WARN` message on disconnection.

## Persistence

The [Bitnami Zookeeper](https://github.com/bitnami/bitnami-docker-zookeeper) image stores the Zookeeper data and configurations at the `/bitnami/zookeeper` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

This new version of the chart includes the new Zookeeper major version 3.5.5. Note that to perform an automatic upgrade
of the application, each node will need to have at least one snapshot file created in the data directory. If not, the
new version of the application won't be able to start the service. Please refer to [ZOOKEEPER-3056](https://issues.apache.org/jira/browse/ZOOKEEPER-3056)
in order to find ways to workaround this issue in case you are facing it.

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's statefulsets.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is `zookeeper`:

```console
$ kubectl delete statefulset zookeeper-zookeeper --cascade=false
```

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is zookeeper:

```console
$ kubectl delete statefulset zookeeper-zookeeper --cascade=false
```
