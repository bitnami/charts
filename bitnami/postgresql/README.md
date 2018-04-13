# PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance.

## TL;DR;

```console
$ helm install bitnami/postgresql
```

## Introduction

This chart bootstraps a [PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/postgresql
```

The command deploys PostgreSQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the PostgreSQL chart and their default values.

|         Parameter          |                Description                |                            Default                        |
|----------------------------|-------------------------------------------|---------------------------------------------------------- |
| `image.registry`           | PostgreSQL image registry                 | `docker.io`                                               |
| `image.repository`         | PostgreSQL Image name                     | `bitnami/postgresql`                                      |
| `image.tag`                | PostgreSQL Image tag                      | `{VERSION}`                                               |
| `image.pullPolicy`         | PostgreSQL image pull policy              | `Always` if `imageTag` is `latest`, else `IfNotPresent`   |
| `image.pullSecrets`        | Specify image pull secrets                | `nil` (does not add image pull secrets to deployed pods)  |
| `postgresqlUsername`       | PostgreSQL admin user                     | `postgres`                                                |
| `postgresqlPassword`       | PostgreSQL admin password                 | _random 10 character alphanumeric string_                 |
| `postgresqlDatabase`       | PostgreSQL database                       | `nil`_                                                    |
| `serviceType`              | Kubernetes Service type                   | `ClusterIP`                                               |
| `persistence.enabled`      | Enable persistence using PVC              | `true`                                                    |
| `persistence.storageClass` | PVC Storage Class for PostgreSQL volume   | `generic`                                                 |
| `persistence.accessMode`   | PVC Access Mode for PostgreSQL volume     | `ReadWriteOnce`                                           |
| `persistence.size`         | PVC Storage Request for PostgreSQL volume | `8Gi`                                                     |
| `resources`                | CPU/Memory resource requests/limits       | Memory: `256Mi`, CPU: `250m`                              |

The above parameters map to the env variables defined in [bitnami/postgresql](http://github.com/bitnami/bitnami-docker-postgresql). For more information please refer to the [bitnami/postgresql](http://github.com/bitnami/bitnami-docker-postgresql) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set postgresqlPassword=secretpassword,postgresqlDatabase=my-database \
    bitnami/postgresql
```

The above command sets the PostgreSQL `postgres` account password to `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/postgresql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) image stores the PostgreSQL data and configurations at the `/bitnami/postgresql` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
