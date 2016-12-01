# node

[Node](https://www.nodejs.org) Event-driven I/O server-side JavaScript environment based on V8

## TL;DR;

```console
$ helm install .
```

## Introduction

This chart bootstraps a [Node](https://github.com/bitnami/bitnami-docker-node) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It clones and deploy a nodejs application  from a git repository and  defined revision.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release .
```

The command deploys node on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the node chart and their default values.

|              Parameter               |               Description                |                         Default                         |
|--------------------------------------|------------------------------------------|---------------------------------------------------------|
| `image`                              | node image                               | `bitnami/node:{VERSION}`                                |
| `imageTag`                           | node image Tag                           | ``                                                      |
| `imagePullPolicy`                    | Image pull policy                        | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `repository`                         | Repo of the application                  | `git@github.com:jbianquetti-nami/simple-node-app.git`   |
| `revision`                           | Revision  to checkout                    | `master`                                                |
| `mariadb.mariadbRootPassword`        | MariaDB admin password                   | `nil`                                                   |
| `serviceType`                        | Kubernetes Service type                  | `LoadBalancer`                                          |
| `persistence.enabled`                | Enable persistence using PVC             | `true`                                                  |
| `persistence.node.storageClass`      | PVC Storage Class for node volume        | `generic`                                               |
| `persistence.node.accessMode`        | PVC Access Mode for node volume          | `ReadWriteOnce`                                         |
| `persistence.node.size`              | PVC Storage Request for node volume      | `8Gi`                                                   |
| `resources`                          | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`                            |

The above parameters map to the env variables defined in [bitnami/node](http://github.com/bitnami/bitnami-docker-node). For more information please refer to the [bitnami/node](http://github.com/bitnami/bitnami-docker-node) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set repository=git@github.com:jbianquetti-nami/simple-node-app.git,mariadb.mariadbRootPassword=secretpassword \
    stable/node
```

The above command sets the node administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/node
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami node](https://github.com/bitnami/bitnami-docker-node) image stores the node data and configurations at the `/bitnami/node` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
