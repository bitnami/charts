# SuiteCRM

[SuiteCRM](https://suitecrm.com/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## TL;DR;

```bash
$ helm install suitecrm-x.x.x.tgz
```

## Introduction

This chart bootstraps a [SuiteCRM](https://github.com/bitnami/bitnami-docker-suitecrm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the SuiteCRM application.

## Prerequisites

- Kubernetes 1.3+ with Alpha APIs enabled
- PV provisioner support in the underlying infrastructure

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release suitecrm-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys SuiteCRM on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the SuiteCRM chart and their default values.

| Parameter                            | Description                              | Default                                                    |
| -------------------------------      | -------------------------------          | ---------------------------------------------------------- |
| `image`                              | SuiteCRM image                           | `bitnami/suitecrm:{VERSION}`                               |
| `imagePullPolicy`                    | Image pull policy                        | `Always` if `image` tag is `latest`, else `IfNotPresent`   |
| `suitecrmUsername`                   | User of the application                  | `user`                                                     |
| `suitecrmPassword`                   | Application password                     | `bitnami`                                                  |
| `suitecrmEmail`                      | Admin email                              | `user@example.com`                                         |
| `suitecrmLastName`                   | Last name                                | `LastName`                                                 |
| `suitecrmBlogName`                   | Blog name                                | `User's Blog!`                                             |
| `smtpHost`                           | SMTP host                                | `nil`                                                      |
| `smtpPort`                           | SMTP port                                | `nil`                                                      |
| `smtpUser`                           | SMTP user                                | `nil`                                                      |
| `smtpPassword`                       | SMTP password                            | `nil`                                                      |
| `smtpProtocol`                       | SMTP protocol [`tls`, `ssl`]             | `nil`                                                      |
| `mariadb.mariadbRootPassword`        | MariaDB admin password                   | `nil`                                                      |
| `serviceType`                        | Kubernetes Service type                  | `LoadBalancer`                                             |
| `persistence.enabled`                | Enable persistence using PVC             | `true`                                                     |
| `persistence.apache.storageClass`    | PVC Storage Class for Apache volume      | `generic`                                                  |
| `persistence.apache.accessMode`      | PVC Access Mode for Apache volume        | `ReadWriteOnce`                                            |
| `persistence.apache.size`            | PVC Storage Request for Apache volume    | `1Gi`                                                      |
| `persistence.suitecrm.storageClass`  | PVC Storage Class for SuiteCRM volume    | `generic`                                                  |
| `persistence.suitecrm.accessMode`    | PVC Access Mode for SuiteCRM volume      | `ReadWriteOnce`                                            |
| `persistence.suitecrm.size`          | PVC Storage Request for SuiteCRM volume  | `8Gi`                                                      |

The above parameters map to the env variables defined in [bitnami/suitecrm](http://github.com/bitnami/bitnami-docker-suitecrm). For more information please refer to the [bitnami/suitecrm](http://github.com/bitnami/bitnami-docker-suitecrm) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set suitecrmUsername=admin,suitecrmPassword=password,mariadb.mariadbRootPassword=secretpassword \
    suitecrm-x.x.x.tgz
```

The above command sets the SuiteCRM application username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml suitecrm-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami SuiteCRM](https://github.com/bitnami/bitnami-docker-suitecrm) image stores the SuiteCRM data and configurations at the `/bitnami/suitecrm` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
