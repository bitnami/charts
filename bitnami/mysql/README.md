# MySQL

[MySQL](https://mysql.com) is a fast, reliable, scalable, and easy to use open-source relational database system. MySQL Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

## TL;DR

```bash
$ helm install bitnami/mysql
```

## Introduction

This chart bootstraps a [MySQL](https://github.com/bitnami/bitnami-docker-mysql) replication cluster deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.10+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release bitnami/mysql
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

|             Parameter                     |                     Description                       |                              Default                              |
|-------------------------------------------|-------------------------------------------------------|-------------------------------------------------------------------|
| `global.imageRegistry`                    | Global Docker image registry                          | `nil`                                                             |
| `image.registry`                          | MySQL image registry                                  | `docker.io`                                                       |
| `image.repository`                        | MySQL Image name                                      | `bitnami/mysql`                                                   |
| `image.tag`                               | MySQL Image tag                                       | `{VERSION}`                                                       |
| `image.pullPolicy`                        | MySQL image pull policy                               | `Always` if `imageTag` is `latest`, else `IfNotPresent`           |
| `image.pullSecrets`                       | Specify image pull secrets                            | `nil` (does not add image pull secrets to deployed pods)          |
| `service.type`                            | Kubernetes service type                               | `ClusterIP`                                                       |
| `service.port`                            | MySQL service port                                    | `3306`                                                            |
| `root.password`                           | Password for the `root` user                          | _random 10 character alphanumeric string_                         |
| `db.user`                                 | Username of new user to create                        | `nil`                                                             |
| `db.password`                             | Password for the new user                             | _random 10 character alphanumeric string if `db.user` is defined_ |
| `db.name`                                 | Name for new database to create                       | `my_database`                                                     |
| `securityContext.enabled`                 | Enable security context                               | `true`                                                            |
| `securityContext.fsGroup`                 | Group ID for the container                            | `1001`                                                            |
| `securityContext.runAsUser`               | User ID for the container                             | `1001`                                                            |
| `replication.enabled`                     | MySQL replication enabled                             | `true`                                                            |
| `replication.user`                        | MySQL replication user                                | `replicator`                                                      |
| `replication.password`                    | MySQL replication user password                       | _random 10 character alphanumeric string_                         |
| `master.antiAffinity`                     | Master pod anti-affinity policy                       | `soft`                                                            |
| `master.persistence.enabled`              | Enable persistence using a `PersistentVolumeClaim`    | `true`                                                            |
| `master.persistence.existingClaim`        | Provide an existing `PersistentVolumeClaim`           | `nil`                                                             |
| `master.persistence.mountPath`            | Configure `PersistentVolumeClaim` mount path          | `/bitnami/mysql`                                                  |
| `master.persistence.annotations`          | Persistent Volume Claim annotations                   | `{}`                                                              |
| `master.persistence.storageClass`         | Persistent Volume Storage Class                       | ``                                                                |
| `master.persistence.accessModes`          | Persistent Volume Access Modes                        | `[ReadWriteOnce]`                                                 |
| `master.persistence.size`                 | Persistent Volume Size                                | `8Gi`                                                             |
| `master.config`                           | Config file for the MySQL Master server               | `_default values in the values.yaml file_`                        |
| `master.resources`                        | CPU/Memory resource requests/limits for master node   | `{}`                                                              |
| `master.livenessProbe.enabled`            | Turn on and off liveness probe (master)               | `true`                                                            |
| `master.livenessProbe.initialDelaySeconds`| Delay before liveness probe is initiated (master)     | `120`                                                             |
| `master.livenessProbe.periodSeconds`      | How often to perform the probe (master)               | `10`                                                              |
| `master.livenessProbe.timeoutSeconds`     | When the probe times out (master)                     | `1`                                                               |
| `master.livenessProbe.successThreshold`   | Minimum consecutive successes for the probe (master)  | `1`                                                               |
| `master.livenessProbe.failureThreshold`   | Minimum consecutive failures for the probe (master)   | `3`                                                               |
| `master.readinessProbe.enabled`           | Turn on and off readiness probe (master)              | `true`                                                            |
| `master.readinessProbe.initialDelaySeconds`| Delay before readiness probe is initiated (master)   | `30`                                                              |
| `master.readinessProbe.periodSeconds`     | How often to perform the probe (master)               | `10`                                                              |
| `master.readinessProbe.timeoutSeconds`    | When the probe times out (master)                     | `1`                                                               |
| `master.readinessProbe.successThreshold`  | Minimum consecutive successes for the probe (master)  | `1`                                                               |
| `master.readinessProbe.failureThreshold`  | Minimum consecutive failures for the probe (master)   | `3`                                                               |
| `slave.replicas`                          | Desired number of slave replicas                      | `1`                                                               |
| `slave.antiAffinity`                      | Slave pod anti-affinity policy                        | `soft`                                                            |
| `slave.persistence.enabled`               | Enable persistence using a `PersistentVolumeClaim`    | `true`                                                            |
| `slave.persistence.mountPath`             | Configure `PersistentVolumeClaim` mount path          | `/bitnami/mysql`                                                  |
| `slave.persistence.annotations`           | Persistent Volume Claim annotations                   | `{}`                                                              |
| `slave.persistence.storageClass`          | Persistent Volume Storage Class                       | ``                                                                |
| `slave.persistence.accessModes`           | Persistent Volume Access Modes                        | `[ReadWriteOnce]`                                                 |
| `slave.persistence.size`                  | Persistent Volume Size                                | `8Gi`                                                             |
| `slave.config`                            | Config file for the MySQL Slave replicas              | `_default values in the values.yaml file_`                        |
| `slave.resources`                         | CPU/Memory resource requests/limits for slave node    | `{}`                                                              |
| `slave.livenessProbe.enabled`             | Turn on and off liveness probe (slave)                | `true`                                                            |
| `slave.livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated (slave)      | `120`                                                             |
| `slave.livenessProbe.periodSeconds`       | How often to perform the probe (slave)                | `10`                                                              |
| `slave.livenessProbe.timeoutSeconds`      | When the probe times out (slave)                      | `1`                                                               |
| `slave.livenessProbe.successThreshold`    | Minimum consecutive successes for the probe (slave)   | `1`                                                               |
| `slave.livenessProbe.failureThreshold`    | Minimum consecutive failures for the probe (slave)    | `3`                                                               |
| `slave.readinessProbe.enabled`            | Turn on and off readiness probe (slave)               | `true`                                                            |
| `slave.readinessProbe.initialDelaySeconds`| Delay before readiness probe is initiated (slave)     | `30`                                                              |
| `slave.readinessProbe.periodSeconds`      | How often to perform the probe (slave)                | `10`                                                              |
| `slave.readinessProbe.timeoutSeconds`     | When the probe times out (slave)                      | `1`                                                               |
| `slave.readinessProbe.successThreshold`   | Minimum consecutive successes for the probe (slave)   | `1`                                                               |
| `slave.readinessProbe.failureThreshold`   | Minimum consecutive failures for the probe (slave)    | `3`                                                               |
| `metrics.enabled`                         | Start a side-car prometheus exporter                  | `false`                                                           |
| `metrics.image`                           | Exporter image name                                   | `prom/mysqld-exporter`                                            |
| `metrics.imageTag`                        | Exporter image tag                                    | `v0.10.0`                                                         |
| `metrics.imagePullPolicy`                 | Exporter image pull policy                            | `IfNotPresent`                                                    |
| `metrics.resources`                       | Exporter resource requests/limit                      | `nil`                                                             |

The above parameters map to the env variables defined in [bitnami/mysql](http://github.com/bitnami/bitnami-docker-mysql). For more information please refer to the [bitnami/mysql](http://github.com/bitnami/bitnami-docker-mysql) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set root.password=secretpassword,user.database=app_database \
    bitnami/mysql
```

The above command sets the MySQL `root` account password to `secretpassword`. Additionally it creates a database named `app_database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml bitnami/mysql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Initialize a fresh instance

The [Bitnami MySQL](https://github.com/bitnami/bitnami-docker-mysql) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

## Persistence

The [Bitnami MySQL](https://github.com/bitnami/bitnami-docker-mysql) image stores the MySQL data and configurations at the `/bitnami/mysql` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning by default. An existing PersistentVolumeClaim can be defined.

## Upgrading

It's necessary to set the `root.password` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Administrator credentials' section. Please note down the password and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/mysql --set root.password=[ROOT_PASSWORD]
```

| Note: you need to substitue the placeholder _[ROOT_PASSWORD]_ with the value obtained in the installation notes.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is mysql:

```console
$ kubectl delete statefulset mysql-master --cascade=false
$ kubectl delete statefulset mysql-slave --cascade=false
```
