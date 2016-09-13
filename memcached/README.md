# Memcached

> [Memcached](https://memcached.org/) is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

## TL;DR;

```bash
$ helm install memcached-x.x.x.tgz
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Memcached](https://github.com/bitnami/bitnami-docker-memcached) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/bitnami/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release memcached-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys Memcached on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Memcached chart and their default values.

|      Parameter      |          Description          |                         Default                         |
|---------------------|-------------------------------|---------------------------------------------------------|
| `imageTag`          | `bitnami/memcached` image tag | Memcached image version                                 |
| `imagePullPolicy`   | Image pull policy             | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `memcachedUsername` | Memcached admin user          | `nil`                                                   |
| `memcachedPassword` | Memcached admin password      | `nil`                                                   |

The above parameters map to the env variables defined in [bitnami/memcached](http://github.com/bitnami/bitnami-docker-memcached). For more information please refer to the [bitnami/memcached](http://github.com/bitnami/bitnami-docker-memcached) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set memcachedUser=user,memcachedPassword=password \
    memcached-x.x.x.tgz
```

The above command sets the Memcached admin account username and password to `user` and `password` respectively.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml memcached-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)
