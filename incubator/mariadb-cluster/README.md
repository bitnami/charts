# MariaDB Cluster

[MariaDB](https://mariadb.org) is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, Facebook and Google.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

## TL;DR

```bash
$ helm install incubator/mariadb-cluster
```

## Introduction

This chart bootstraps a [MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) replication cluster deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/mariadb-cluster
```

The command deploys MariaDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MariaDB chart and their default values.

|          Parameter           |             Description             |                   Default                   |
|------------------------------|-------------------------------------|---------------------------------------------|
| `image`                      | Bitnami MariaDB image version       | `bitnami/mariadb:{VERSION}`                 |
| `imagePullPolicy`            | Image pull policy                   | `IfNotPresent`                              |
| `numSlaves`                  | Desired number of slave Pods        | `3`                                         |
| `mariadbRootPassword`        | Password for the `root` user.       | _random 10 character alphanumeric string_   |
| `mariadbUser`                | Username of new user to create.     | `nil`                                       |
| `mariadbPassword`            | Password for the new user.          | _random 10 character alphanumeric string_   |
| `mariadbDatabase`            | Name for new database to create.    | `my_database`                               |
| `mariadbReplicationUser`     | MariaDB replication user            | `my_replication_user`                       |
| `mariadbReplicationPassword` | MariaDB replication user password   | _random 10 character alphanumeric string_   |
| `serviceType`                | Kubernetes Service type             | `ClusterIP`                                 |
| `persistence.enabled`        | Use a PVC to persist data           | `true`                                      |
| `persistence.storageClass`   | Storage class of backing PVC        | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`     | Use volume as ReadOnly or ReadWrite | `ReadWriteOnce`                             |
| `persistence.size`           | Size of data volume                 | `8Gi`                                       |
| `resources`                  | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `250m`                |

The above parameters map to the env variables defined in [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb). For more information please refer to the [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mariadbRootPassword=secretpassword,mariadbUser=app_user,mariadbPassword=app_password,mariadbDatabase=app_database \
    incubator/mariadb-cluster
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/mariadb-cluster
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image stores the MariaDB data and configurations at the `/bitnami/mariadb` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can be defined.
