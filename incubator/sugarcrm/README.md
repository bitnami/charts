# SugarCRM

[SugarCRM](https://www.sugarcrm.org) Sugar offers the most innovative, flexible and affordable CRM in the market and delivers the best all-around value of any CRM.

## TL;DR;

```console
$ helm install .
```

## Introduction

This chart bootstraps a [SugarCRM](https://github.com/bitnami/bitnami-docker-sugarcrm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the sugarcrm application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release ./sugarcrm
```

The command deploys sugarcrm on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the sugarcrm chart and their default values.

|              Parameter               |               Description                |                         Default                         |
|--------------------------------------|------------------------------------------|---------------------------------------------------------|
| `image`                              | sugarcrm image                           | `bitnami/sugarcrm:{VERSION}`                            |
| `imageTag`                           | sugarcrm image Tag                       | `3.1.3`                                                 |
| `imagePullPolicy`                    | Image pull policy                        | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `sugarcrmUsername`                   | User of the application                  | `user`                                                  |
| `sugarcrmPassword`                   | Application password                     | _random 10 character long alphanumeric string_          |
| `sugarcrmEmail`                      | Admin email                              | `user@example.com`                                      |
| `sugarcrmHost`                       | Host domain or IP                        | `nil`                                                   |
| `smtpHost`                           | SMTP host                                | `nil`                                                   |
| `smtpPort`                           | SMTP port                                | `nil`                                                   |
| `smtpProtocol`                       | SMTP Protocol                            | `nil`                                                   |
| `smtpUser`                           | SMTP user                                | `nil`                                                   |
| `smtpPassword`                       | SMTP password                            | `nil`                                                   |
| `mariadb.mariadbRootPassword`        | MariaDB admin password                   | `nil`                                                   |
| `serviceType`                        | Kubernetes Service type                  | `LoadBalancer`                                          |
| `persistence.enabled`                | Enable persistence using PVC             | `true`                                                  |
| `persistence.sugarcrm.storageClass`  | PVC Storage Class for sugarcrm volume    | `generic`                                               |
| `persistence.sugarcrm.accessMode`    | PVC Access Mode for sugarcrm volume      | `ReadWriteOnce`                                         |
| `persistence.sugarcrm.size`          | PVC Storage Request for sugarcrm volume  | `8Gi`                                                   |
| `resources`                          | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`                            |

The above parameters map to the env variables defined in [bitnami/sugarcrm](http://github.com/bitnami/bitnami-docker-sugarcrm). For more information please refer to the [bitnami/sugarcrm](http://github.com/bitnami/bitnami-docker-sugarcrm) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set sugarcrmUser=admin,sugarcrmPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/sugarcrm
```

The above command sets the sugarcrm administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/sugarcrm
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami sugarcrm](https://github.com/bitnami/bitnami-docker-sugarcrm) image stores the sugarcrm data and configurations at the `/bitnami/sugarcrm` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
