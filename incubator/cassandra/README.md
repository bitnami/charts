# cassandra

[cassandra](https://cassandra.apache.org) Apache Cassandra is a free and open-source distributed database management system designed to handle large amounts of data across many commodity servers or datacenters.

## TL;DR;

```console
$ helm install .
```

## Introduction

This chart bootstraps a [Cassandra](https://github.com/bitnami/bitnami-docker-cassandra) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release ./cassandra
```

The command deploys two nodes with Cassandra on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` petset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the cassandra chart and their default values.

|              Parameter               |               Description                |                         Default                         |
|--------------------------------------|------------------------------------------|---------------------------------------------------------|
| `image`                              | cassandra image                          | `bitnami/cassandra:{VERSION}`                           |
| `imageTag`                           | cassandra image tag                      | `3.9-r3`                                                | 
| `imagePullPolicy`                    | Image pull policy                        | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `cassandraUser`                      | User of the application                  | `user`                                                  |
| `cassandraPassword`                  | Application password                     | `bitnami`                                               |
| `cassandraHost`                      | Hostname of the local node               | ``                                                      |
| `cassandraClusterName`               | Cluster Name                             | `cassandra-cluster`                                     |
| `cassandraSeeds`                     | List of nodes to seed the new node       | ``                                                      |
| `cassandraEnableRemoteConnections`   | Enable remote connections                | `true`                                                  |
| `cassandraSetCredentials`            | Enable the initial password change       | `1`                                                     |
| `cassandraEndPointSnitch`            | Desired Snitch for the Endpoint          | `SimpleSnitch`                                          |
| `cassandraTransportPort`             | Transport Port                           | `7000`                                                  |
| `cassandraSslTransportPort`          | SSL Transport Port                       | `7001`                                                  |
| `cassandraJmxPort`                   | JMX Port                                 | `7199`                                                  |
| `cassandraCqlPort`                   | CQL Port                                 | `9042`                                                  |
| `cassandraRpcPort`                   | RPC Port                                 | `9160`                                                  |
| `serviceType`                        | Kubernetes Service type                  | `nodePort`                                              |
| `persistence.enabled`                | Enable persistence using PVC             | `true`                                                  |
| `persistence.cassandra.storageClass` | PVC Storage Class for cassandra volume   | `generic`                                               |
| `persistence.cassandra.accessMode`   | PVC Access Mode for cassandra volume     | `ReadWriteOnce`                                         |
| `persistence.cassandra.size`         | PVC Storage Request for cassandra volume | `8Gi`                                                   |
| `resources`                          | CPU/Memory resource requests/limits      | Memory: `3000Mi`, CPU: `300m`                            |

The above parameters map to the env variables defined in [bitnami/cassandra](http://github.com/bitnami/bitnami-docker-cassandra). For more information please refer to the [bitnami/cassandra](http://github.com/bitnami/bitnami-docker-cassandra) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set cassandraUser=admin,cassandraPassword=password\
    ./cassandra
```


Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml ./cassandra
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami cassandra](https://github.com/bitnami/bitnami-docker-cassandra) image stores the cassandra data and configurations at the `/bitnami/cassandra` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
