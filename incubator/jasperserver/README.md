# jasperserver

[jasperserver](http://community.jaspersoft.com/project/jasperreports-server) The JasperReports server can be used as a stand-alone or embedded reporting and BI server that offers web-based reporting, analytic tools and visualization, and a dashboard feature for compiling multiple custom views


## TL;DR;

```console
$ helm install .
```

## Introduction

This chart bootstraps a [jasperserver](https://github.com/bitnami/bitnami-docker-jasperserver) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the jasperserver application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release ./jasperserver
```

The command deploys jasperserver on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the jasperserver chart and their default values.

|              Parameter                              Description                         |                         Default                         |
|------------------------------------------|----------------------------------------------|---------------------------------------------------------|
| `image`                                  | jasperserver image                           | `bitnami/jasperserver:{VERSION}`                        |
| `imageTag`                               | jasperserver image Tag                       | `3.1.3`                                                 |
| `imagePullPolicy`                        | Image pull policy                            | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `jasperserverUsername`                   | User of the application                      | `user`                                                  |
| `jasperserverPassword`                   | Application password                         | _random 10 character long alphanumeric string_          |
| `smtpHost`                               | SMTP host                                    | `nil`                                                   |
| `smtpPort`                               | SMTP port                                    | `nil`                                                   |
| `smtpEmail`                              | SMTP Email                                   | `nil`                                                   |
| `smtpUser`                               | SMTP user                                    | `nil`                                                   |
| `smtpProtocol`                           | SMTP protocol                                | `nil`                                                   |
| `smtpPassword`                           | SMTP password                                | `nil`                                                   |
| `mariadb.mariadbRootPassword`            | MariaDB admin password                       | `nil`                                                   |
| `serviceType`                            | Kubernetes Service type                      | `LoadBalancer`                                          |
| `persistence.enabled`                    | Enable persistence using PVC                 | `true`                                                  |
| `persistence.jasperserver.storageClass`  | PVC Storage Class for jasperserver volume    | `generic`                                               |
| `persistence.jasperserver.accessMode`    | PVC Access Mode for jasperserver volume      | `ReadWriteOnce`                                         |
| `persistence.jasperserver.size`          | PVC Storage Request for jasperserver volume  | `8Gi`                                                   |
| `resources`                              | CPU/Memory resource requests/limits          | Memory: `512Mi`, CPU: `300m`                            |

The above parameters map to the env variables defined in [bitnami/jasperserver](http://github.com/bitnami/bitnami-docker-jasperserver). For more information please refer to the [bitnami/jasperserver](http://github.com/bitnami/bitnami-docker-jasperserver) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set jasperserverUsername=admin,jasperserverPassword=bitnami,mariadb.mariadbRootPassword=secretpassword \
    stable/jasperserver
```

The above command sets the jasperserver administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/jasperserver
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami jasperserver](https://github.com/bitnami/bitnami-docker-jasperserver) image stores the jasperserver data and configurations at the `/bitnami/jasperserver` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
