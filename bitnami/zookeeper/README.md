# Zookeeper

[Zookeeper](https://zookeeper.apache.org/) is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or other by distributed applications.

## TL;DR;

```console
$ helm install bitnami/zookeeper
```

## Introduction

This chart bootstraps a [Zookeeper](https://github.com/bitnami/bitnami-docker-zookeeper) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

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
| `image.registry`                      | Zookeeper image registry                                            | `docker.io`                                              |
| `image.repository`                    | Zookeeper Image name                                                | `bitnami/zookeeper`                                      |
| `image.tag`                           | Zookeeper Image tag                                                 | `{VERSION}`                                              |
| `image.pullPolicy`                    | Zookeeper image pull policy                                         | `Always`                                                 |
| `image.pullSecrets`                   | Specify image pull secrets                                          | `nil` (does not add image pull secrets to deployed pods) |
| `image.debug`                         | Specify if debug values should be set                               | `false`                                                  |
| `updateStrategy`                      | Update strategies                                                   | `RollingUpdate`                                          |
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
| `auth.serverUsers`                    | List of user to be created                                          | `[]`                                                     |
| `auth.serverPasswords`                | List of passwords to assign to users when created                   | `[]`                                                     |
| `heapSize`                            | Size in MB for the Java Heap options (Xmx and XMs)                  | `[]`                                                     |
| `jvmFlags`                            | Default JVMFLAGS for the ZooKeeper process                          | `nil`                                                    |
| `config`                              | Configure ZooKeeper with a custom zoo.conf file                     | `nil`                                                    |
| `service.type`                        | Kubernetes Service type                                             | `ClusterIP`                                              |
| `service.port`                        | ZooKeeper port                                                      | `2181`                                                   |
| `service.followerPort`                | ZooKeeper follower port                                             | `2888`                                                   |
| `service.electionPort`                | ZooKeeper election port                                             | `3888`                                                   |
| `securityContext.enabled`             | Enable security context (redis master pod)                          | `true`                                                   |
| `securityContext.fsGroup`             | Group ID for the container (redis master pod)                       | `1001`                                                   |
| `securityContext.runAsUser`           | User ID for the container (redis master pod)                        | `1001`                                                   |
| `persistence.enabled`                 | Enable persistence using PVC                                        | `true`                                                   |
| `persistence.storageClass`            | PVC Storage Class for Zookeeper volume                              | `nil`                                                    |
| `persistence.accessMode`              | PVC Access Mode for Zookeeper volume                                | `ReadWriteOnce`                                          |
| `persistence.size`                    | PVC Storage Request for Zookeeper volume                            | `8Gi`                                                    |
| `persistence.annotations`             | Annotations for the PVC                                             | `{}`                                                     |
| `nodeSelector`                        | Node labels for pod assignment                                      | `{}`                                                     |
| `tolerations`                         | Toleration labels for pod assignment                                | `[]`                                                     |
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

## Persistence

The [Bitnami Zookeeper](https://github.com/bitnami/bitnami-docker-zookeeper) image stores the Zookeeper data and configurations at the `/bitnami/zookeeper` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is zookeeper:

```console
$ kubectl delete statefulset zookeeper --cascade=false
```
