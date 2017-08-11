# Elasticsearch

[Elasticsearch](https://www.elastic.co/products/elasticsearch) is a highly scalable open-source full-text search and analytics engine. It allows you to store, search, and analyze big volumes of data quickly and in near real time.

## TL;DR;

```console
$ helm install incubator/elasticsearch
```

## Introduction

This chart bootstraps a [Elasticsearch](https://github.com/bitnami/bitnami-docker-elasticsearch) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/elasticsearch
```

The command deploys Elasticsearch on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Elasticsearch chart and their default values.

|           Parameter           |                           Description                           |              Default              |
|-------------------------------|-----------------------------------------------------------------|-----------------------------------|
| `image`                       | Elasticsearch image                                             | `bitnami/elasticsearch:{VERSION}` |
| `imagePullPolicy`             | Image pull policy                                               | `IfNotPresent`                    |
| `elasticsearchClusterName`    | Elasticsearch cluster name                                      | `elasticsearch-cluster`           |
| `elasticsearchNodeName`       | Elasticsearch node name                                         | ``                                |
| `elasticsearchPortNumber`     | Elasticsearch port                                              | `9200`                            |
| `elasticsearchNodePortNumber` | Elasticsearch Node to Node port                                 | `9300`                            |
| `elasticsearchClusterHosts`   | Elasticsearch hosts list (comma/colon seperated)                | ``                                |
| `elasticsClientNode`          | Elasticsearch node to behave as a 'smart router' for Kibana app | `false`                           |
| `serviceType`                 | Kubernetes Service type                                         | `ClusterIP`                       |
| `persistence.enabled`         | Enable persistence using a `PersistentVolumeClaim`              | `true`                            |
| `persistence.annotations`     | Persistent Volume Claim annotations                             | `{}`                              |
| `persistence.existingClaim`   | Persistent Volume existing claim name                           | ``                                |
| `persistence.storageClass`    | Persistent Volume Storage Class                                 | ``                                |
| `persistence.accessModes`     | Persistent Volume Access Modes                                  | `[ReadWriteOnce]`                 |
| `persistence.size`            | Persistent Volume Size                                          | `8Gi`                             |
| `resources`                   | CPU/Memory resource requests/limits                             | ``                                |

The above parameters map to the env variables defined in [bitnami/elasticsearch](http://github.com/bitnami/bitnami-docker-elasticsearch). For more information please refer to the [bitnami/elasticsearch](http://github.com/bitnami/bitnami-docker-elasticsearch) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set elasticsearchClusterName=elastic,elasticsearchPortNumber=80 \
  incubator/elasticsearch
```

The above command sets the Elasticsearch cluster name and REST api port number to `elastic` and `80` respectively.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/elasticsearch
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Elasticsearch](https://github.com/bitnami/bitnami-docker-elasticsearch) image stores the Elasticsearch data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
