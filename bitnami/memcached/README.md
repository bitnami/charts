# Memcached

> [Memcached](https://memcached.org/) is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

## TL;DR;

```console
$ helm install bitnami/memcached
```

## Introduction

This chart bootstraps a [Memcached](https://github.com/bitnami/bitnami-docker-memcached) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/memcached
```

The command deploys Memcached on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Memcached chart and their default values.

|      Parameter              |             Description             |                          Default                          |
|-----------------------------|-------------------------------------|---------------------------------------------------------- |
| `global.imageRegistry`      | Global Docker image registry        | `nil`                                                     |
| `global.imagePullSecrets`   | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`            | Memcached image registry            | `docker.io`                                               |
| `image.repository`          | Memcached Image name                | `bitnami/memcached`                                       |
| `image.tag`                 | Memcached Image tag                 | `{TAG_NAME}`                                              |
| `image.pullPolicy`          | Memcached image pull policy         | `IfNotPresent`                                            |
| `image.pullSecrets`         | Specify docker-registry secret names as an array          | `[]` (does not add image pull secrets to deployed pods)  |
| `securityContext.enabled`   | Enable security context             | `true`                                                    |
| `securityContext.fsGroup`   | Group ID for the container          | `1001`                                                    |
| `securityContext.runAsUser` | User ID for the container           | `1001`                                                    |
| `memcachedUsername`         | Memcached admin user                | `nil`                                                     |
| `memcachedPassword`         | Memcached admin password            | `nil`                                                     |
| `serviceType`               | Kubernetes Service type             | `ClusterIP`                                               |
| `resources`                 | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `250m`                              |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                           | `false`                                              |
| `metrics.image.registry`                   | MongoDB exporter image registry                                                                                  | `docker.io`                                          |
| `metrics.image.repository`                 | MongoDB exporter image name                                                                                      | `prom/memcached-exporter`                           |
| `metrics.image.tag`                        | MongoDB exporter image tag                                                                                       | `v0.4.1`                                            |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods)  |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                | {}                                                   |
| `metrics.resources`                        | Exporter resource requests/limit                                                                               | Memory: `256Mi`, CPU: `100m`                         |


The above parameters map to the env variables defined in [bitnami/memcached](http://github.com/bitnami/bitnami-docker-memcached). For more information please refer to the [bitnami/memcached](http://github.com/bitnami/bitnami-docker-memcached) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release --set memcachedUser=user,memcachedPassword=password bitnami/memcached
```

The above command sets the Memcached admin account username and password to `user` and `password` respectively.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/memcached
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml bitnami/memcached
```

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is memcached:

```console
$ kubectl patch deployment memcached --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
