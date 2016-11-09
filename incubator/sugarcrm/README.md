# SugarCRM

[SugarCRM](http://www.sugarcrm.com/) is a modern and flexible CRM for your entire team.

## TL;DR;

```bash
$ helm install sugarcrm-x.x.x.tgz
```

## Introduction

This chart bootstraps a [SugarCRM](https://github.com/bitnami/bitnami-docker-sugarcrm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the SugarCRM application.

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
$ helm install --name my-release sugarcrm-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys SugarCRM on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the SugarCRM chart and their default values.

| Parameter                            | Description                              | Default                                                    |
| -------------------------------      | -------------------------------          | ---------------------------------------------------------- |
| `image`                              | SugarCRM image                           | `bitnami/sugarcrm:{VERSION}`                              |
| `imagePullPolicy`                    | Image pull policy                        | `Always` if `image` tag is `latest`, else `IfNotPresent`   |
| `sugarcrmUsername`                   | User of the application                  | `user`                                                     |
| `sugarcrmPassword`                   | Application password                     | `bitnami`                                                  |
| `sugarcrmEmail`                      | Admin email                              | `user@example.com`                                         |
| `sugarcrmLastName`                   | Last name                                | `LastName`                                                 |
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
| `persistence.sugarcrm.storageClass`  | PVC Storage Class for SugarCRM volume   | `generic`                                                  |
| `persistence.sugarcrm.accessMode`    | PVC Access Mode for SugarCRM volume     | `ReadWriteOnce`                                            |
| `persistence.sugarcrm.size`          | PVC Storage Request for SugarCRM volume | `8Gi`                                                      |

The above parameters map to the env variables defined in [bitnami/sugarcrm](http://github.com/bitnami/bitnami-docker-sugarcrm). For more information please refer to the [bitnami/sugarcrm](http://github.com/bitnami/bitnami-docker-sugarcrm) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set sugarcrmUsername=admin,sugarcrmPassword=password,mariadb.mariadbRootPassword=secretpassword \
    sugarcrm-x.x.x.tgz
```

The above command sets the SugarCRM application username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml sugarcrm-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami SugarCRM](https://github.com/bitnami/bitnami-docker-sugarcrm) image stores the SugarCRM data and configurations at the `/bitnami/sugarcrm` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
