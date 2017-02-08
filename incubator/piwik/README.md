# piwik

[Piwik](https://www.piwik.org) Piwik is a free and open source web analytics application written by a team of international developers that runs on a PHP/MySQL webserver. It tracks online visits to one or more websites and displays reports on these visits for analysis.

## TL;DR;

```console
$ helm install .
```

## Introduction

This chart bootstraps a [Piwik](https://github.com/bitnami/bitnami-docker-piwik) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the piwik application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release ./piwik
```

The command deploys piwik on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the piwik chart and their default values.

|             Parameter             |              Description              |                  Default                  |
|-----------------------------------|---------------------------------------|-------------------------------------------|
| `image`                           | piwik image                           | `bitnami/piwik:{VERSION}`                 |
| `imagePullPolicy`                 | Image pull policy                     | `IfNotPresent`                            |
| `piwikUsername`                   | User of the application               | `user`                                    |
| `piwikPassword`                   | Application password                  | _random 10 character alphanumeric string_ |
| `piwikEmail`                      | Admin email                           | `user@example.com`                        |
| `piwikWebsiteName`                | Name of the example website to track  | `example`                                 |
| `piwikWebsiteHost`                | Host of the example website to track  | `https://example.org                      |
| `smtpHost`                        | SMTP host                             | `nil`                                     |
| `smtpPort`                        | SMTP port                             | `nil`                                     |
| `smtpProtocol`                    | SMTP Protocol                         | `nil`                                     |
| `smtpUser`                        | SMTP user                             | `nil`                                     |
| `smtpPassword`                    | SMTP password                         | `nil`                                     |
| `mariadb.mariadbRootPassword`     | MariaDB admin password                | `nil`                                     |
| `serviceType`                     | Kubernetes Service type               | `LoadBalancer`                            |
| `persistence.enabled`             | Enable persistence using PVC          | `true`                                    |
| `persistence.apache.storageClass` | PVC Storage Class for apache volume   | `generic`                                 |
| `persistence.apache.accessMode`   | PVC Access Mode for apache volume     | `ReadWriteOnce`                           |
| `persistence.apache.size`         | PVC Storage Request for apache volume | `8Gi`                                     |
| `persistence.piwik.storageClass`  | PVC Storage Class for piwik volume    | `generic`                                 |
| `persistence.piwik.accessMode`    | PVC Access Mode for piwik volume      | `ReadWriteOnce`                           |
| `persistence.piwik.size`          | PVC Storage Request for piwik volume  | `8Gi`                                     |
| `resources`                       | CPU/Memory resource requests/limits   | Memory: `512Mi`, CPU: `300m`              |

The above parameters map to the env variables defined in [bitnami/piwik](http://github.com/bitnami/bitnami-docker-piwik). For more information please refer to the [bitnami/piwik](http://github.com/bitnami/bitnami-docker-piwik) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set piwikUsername=admin,piwikPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/piwik
```

The above command sets the piwik administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/piwik
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami piwik](https://github.com/bitnami/bitnami-docker-piwik) image stores the piwik data and configurations at the `/bitnami/piwik` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
