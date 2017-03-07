# MySQL

[MySQL](https://mysql.com ) MySQL is a fast, reliable, scalable, and easy to use open-source relational database system. MySQL Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.


## TL;DR;

```bash
$ helm install incubator/mysql
```

## Introduction

This chart bootstraps a [MySQL](https://github.com/bitnami/bitnami-docker-mysql) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/mysql
```

The command deploys MySQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MySQL chart and their default values.

|         Parameter          |                Description                 |                   Default                   |
|----------------------------|--------------------------------------------|---------------------------------------------|
| `image`                    | MySQL image                                | `bitnami/mysql:{VERSION}`                   |
| `imagePullPolicy`          | Image pull policy.                         | `IfNotPresent`                              |
| `mysqlRootPassword`        | Password for the `root` user.              | `nil`                                       |
| `mysqlUser`                | Username of new user to create.            | `nil`                                       |
| `mysqlPassword`            | Password for the new user.                 | `nil`                                       |
| `mysqlDatabase`            | Name for new database to create.           | `nil`                                       |
| `persistence.enabled`      | Use a PVC to persist data                  | `true`                                      |
| `persistence.storageClass` | Storage class of backing PVC               | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite        | `ReadWriteOnce`                             |
| `persistence.size`         | Size of data volume                        | `8Gi`                                       |
| `resources`                | CPU/Memory resource requests/limits        | Memory: `256Mi`, CPU: `250m`                |
| `config`                   | Multi-line string for my.cnf configuration | `nil`                                       |

The above parameters map to the env variables defined in [bitnami/mysql](http://github.com/bitnami/bitnami-docker-mysql). For more information please refer to the [bitnami/mysql](http://github.com/bitnami/bitnami-docker-mysql) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mysqlRootPassword=secretpassword,mysqlUser=my-user,mysqlPassword=my-password,mysqlDatabase=my-database \
    incubator/mysql
```

The above command sets the MySQL `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/mysql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Custom my.cnf configuration

The Bitnami MySQL image allows you to provide a custom `my.cnf` file for configuring MySQL.
This Chart uses the `config` value to mount a custom `my.cnf` using a [ConfigMap](http://kubernetes.io/docs/user-guide/configmap/).
You can configure this by creating a YAML file that defines the `config` property as a multi-line string in the format of a `my.cnf` file.
For example:

```bash
cat > mysql-values.yaml <<EOF
config: |-
  [mysqld]
  max_allowed_packet = 64M
  sql_mode=STRICT_ALL_TABLES
  ft_stopword_file=/etc/mysql/stopwords.txt
  ft_min_word_len=3
  ft_boolean_syntax=' |-><()~*:""&^'
  innodb_buffer_pool_size=2G
EOF

helm install --name my-release -f mysql-values.yaml incubator/mysql
```

## Persistence

The [Bitnami MySQL](https://github.com/bitnami/bitnami-docker-mysql) image stores the MySQL data and configurations at the `/bitnami/mysql` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning.
