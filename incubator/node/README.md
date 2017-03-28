# Node

[Node](https://www.nodejs.org) Event-driven I/O server-side JavaScript environment based on V8

## TL;DR;

```console
$ helm install incubator/node
```

## Introduction

This chart bootstraps a [Node](https://github.com/bitnami/bitnami-docker-node) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It clones and deploys a Node.js application from a git repository.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/node
```

The command deploys Node.js on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation. Also includes support for MariaDB chart out of the box.

Due that the Helm Chart clones the application on the /app volume while the container is initializing, a persistent volume is not required.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Node chart and their default values.

|           Parameter           |             Description             |                        Default                        |
|-------------------------------|-------------------------------------|-------------------------------------------------------|
| `image`                       | Node image                          | `bitnami/node:{VERSION}`                              |
| `imagePullPolicy`             | Image pull policy                   | `IfNotPresent`                                        |
| `repository`                  | Repo of the application             | `git@github.com:jbianquetti-nami/simple-node-app.git` |
| `revision`                    | Revision  to checkout               | `master`                                              |
| `mariadb.mariadbRootPassword` | MariaDB admin password              | `nil`                                                 |
| `serviceType`                 | Kubernetes Service type             | `LoadBalancer`                                        |
| `resources`                   | CPU/Memory resource requests/limits | Memory: `512Mi`, CPU: `300m`                          |

The above parameters map to the env variables defined in [bitnami/node](http://github.com/bitnami/bitnami-docker-node). For more information please refer to the [bitnami/node](http://github.com/bitnami/bitnami-docker-node) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set repository=https://github.com/jbianquetti-nami/simple-node-app.git,mariadb.mariadbRootPassword=secretpassword \
    incubator/node
```

The above command clones the remote git  repository to the `/app/` directory  of the container. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/node
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Node](https://github.com/bitnami/bitnami-docker-node) image stores the Node application and configurations at the `/app`  path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
