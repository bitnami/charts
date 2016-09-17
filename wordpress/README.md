# WordPress

[WordPress](https://wordpress.org/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## TL;DR;

```bash
$ helm install wordpress-x.x.x.tgz
```

## Introduction

This chart bootstraps a [WordPress](https://github.com/bitnami/bitnami-docker-wordpress) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the WordPress application.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release wordpress-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys WordPress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the WordPress chart and their default values.

| Parameter                       | Description                     | Default                                                    |
| ------------------------------- | ------------------------------- | ---------------------------------------------------------- |
| `image.repo`                    | WordPress image repo            | `bitnami/wordpress`                                        |
| `image.tag`                     | WordPress image tag             | Bitnami WordPress image version                            |
| `image.pullPolicy`              | Image pull policy               | `Always` if `image.tag` is `latest`, else `IfNotPresent`   |
| `wordpressUsername`             | User of the application         | `user`                                                     |
| `wordpressPassword`             | Application password            | `bitnami`                                                  |
| `wordpressEmail`                | Admin email                     | `user@example.com`                                         |
| `wordpressFirstName`            | First name                      | `FirstName`                                                |
| `wordpressLastName`             | Last name                       | `LastName`                                                 |
| `wordpressBlogName`             | Blog name                       | `User's Blog!`                                             |
| `smtpHost`                      | SMTP host                       | `nil`                                                      |
| `smtpPort`                      | SMTP port                       | `nil`                                                      |
| `smtpUser`                      | SMTP user                       | `nil`                                                      |
| `smtpPassword`                  | SMTP password                   | `nil`                                                      |
| `smtpUsername`                  | User name for SMTP emails       | `nil`                                                      |
| `smtpProtocol`                  | SMTP protocol [`tls`, `ssl`]    | `nil`                                                      |
| `mariadb.mariadbRootPassword`   | MariaDB admin password          | `nil`                                                      |
| `serviceType`                   | Kubernetes Service type         | `LoadBalancer`                                             |
| `persistence.enabled`           | Enable persistence using PVC    | `true`                                                     |
| `persistence.storageClass`      | PVC Storage Class               | `generic`                                                  |
| `persistence.accessMode`        | PVC Access Mode                 | `ReadWriteOnce`                                            |
| `persistence.size`              | PVC Storage Request             | `8Gi`                                                      |

The above parameters map to the env variables defined in [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress). For more information please refer to the [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set wordpressUsername=admin,wordpressPassword=password,mariadb.mariadbRootPassword=secretpassword \
    wordpress-x.x.x.tgz
```

The above command sets the WordPress application username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml wordpress-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image stores the WordPress data and configurations at the `/bitnami/wordpress` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
