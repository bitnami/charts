# Metrics Server

[Metrics Server](https://github.com/kubernetes-incubator/metrics-server) is a cluster-wide aggregator of resource usage data. Metrics Server collects metrics from the Summary API, exposed by Kubelet on each node.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/metrics-server
```

## Introduction

This chart bootstraps a [Metrics Server](https://github.com/bitnami/bitnami-docker-metrics-server) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/metrics-server
```

These commands deploy Metrics Server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Metrics Server chart and their default values.

| Parameter                 | Description                                                                                                                     | Default                                                 |
|---------------------------|---------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                                                                                                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array                                                                                 | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`          | Metrics Server image registry                                                                                                   | `docker.io`                                             |
| `image.repository`        | Metrics Server image name                                                                                                       | `bitnami/metrics-server`                                |
| `image.tag`               | Metrics Server image tag                                                                                                        | `{TAG_NAME}`                                            |
| `image.pullPolicy`        | Metrics Server image pull policy                                                                                                | `IfNotPresent`                                          |
| `nameOverride`            | String to partially override metrics-server.fullname template with a string (will prepend the release name)                     | `nil`                                                   |
| `fullnameOverride`        | String to fully override metrics-server.fullname template with a string                                                         | `nil`                                                   |
| `securePort`              | Port where metrics-server will be running                                                                                       | `8443`                                                  |
| `hostNetwork`             | Enable hostNetwork mode                                                                                                         | `false`                                                 |
| `extraArgs`               | Extra arguments to pass to metrics-server on start up                                                                           | {}                                                      |
| `rbac.create`             | Enable RBAC authentication                                                                                                      | `true`                                                  |
| `serviceAccount.create`   | Specifies whether a ServiceAccount should be created                                                                            | `true`                                                  |
| `serviceAccount.name`     | The name of the ServiceAccount to create                                                                                        | Generated using the fullname template                   |
| `apiService.create`       | Specifies whether the v1beta1.metrics.k8s.io API service should be created (This should not be necessary in k8s version >= 1.8) | `false`                                                 |
| `podAnnotations`          | Pod annotations                                                                                                                 | `{}`                                                    |
| `priorityClassName`       | Priority class for pod scheduling                                                                                               | `nil`                                                   |
| `affinity`                | Map of node/pod affinities                                                                                                      | `{}` (The value is evaluated as a template)             |
| `nodeSelector`            | Node labels for pod assignment                                                                                                  | `{}` (The value is evaluated as a template)             |
| `tolerations`             | Tolerations for pod assignment                                                                                                  | `[]` (The value is evaluated as a template)             |
| `service.type`            | Kubernetes Service type                                                                                                         | `ClusterIP`                                             |
| `service.port`            | Kubernetes Service port                                                                                                         | `443`                                                   |
| `service.annotations`     | Annotations for the Service                                                                                                     | {}                                                      |
| `service.loadBalancerIP`  | LoadBalancer IP if Service type is `LoadBalancer`                                                                               | `nil`                                                   |
| `service.nodePort`        | NodePort if Service type is `LoadBalancer` or `NodePort`                                                                        | `nil`                                                   |
| `resources`               | The [resources] to allocate for the container                                                                                   | `{}`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set rbac.create=true bitnami/metrics-server
```

The above command enables RBAC authentication.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/metrics-server
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Enable security for Metrics Server. Configuring RBAC

In order to enable Role-based access control for Metrics Servier you can use the following parameter: `rbac.create=true`

## Upgrading

### 4.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 4.0.0. The following example assumes that the release name is metrics-server:

```console
$ kubectl delete deployment metrics-server --cascade=false
$ helm upgrade metrics-server bitnami/metrics-server
```

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is metrics-server:

```console
$ kubectl patch deployment metrics-server --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
