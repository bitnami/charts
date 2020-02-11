# TensorFlow Serving ResNet

TensorFlow Serving is an open-source software library for serving machine learning models. This chart will specifically serve the ResNet model with already trained data.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/tensorflow-resnet
```

## Introduction

This chart bootstraps a TensorFlow Serving ResNet deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```console
$ git clone https://github.com/bitnami/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/tensorflow-resnet
```

These commands deploy Tensorflow Serving ResNet model on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```
You can check your releases with:

```console
$ helm list
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the TensorFlow ResNet chart and their default values.

| Parameter                            | Description                                                                                                    | Default                                                                                                            |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `global.imageRegistry`               | Global Docker image registry                                                                                   | `nil`                                                                                                              |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                                | `[]` (does not add image pull secrets to deployed pods)                                                            |
| `server.image.registry`              | TensorFlow Serving image registry                                                                              | `docker.io`                                                                                                        |
| `server.image.repository`            | TensorFlow Serving Image name                                                                                  | `bitnami/tensorflow-serving`                                                                                       |
| `server.image.tag`                   | TensorFlow Serving Image tag                                                                                   | `{TAG_NAME}`                                                                                                       |
| `server.image.pullPolicy`            | TensorFlow Serving image pull policy                                                                           | `IfNotPresent`                                                                                                     |
| `server.image.pullSecrets`           | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods)                                                            |
| `client.image.registry`              | TensorFlow ResNet image registry                                                                               | `docker.io`                                                                                                        |
| `client.image.repository`            | TensorFlow ResNet Image name                                                                                   | `bitnami/tensorflow-resnet`                                                                                        |
| `client.image.tag`                   | TensorFlow ResNet Image tag                                                                                    | `{TAG_NAME}`                                                                                                       |
| `client.image.pullPolicy`            | TensorFlow ResNet image pull policy                                                                            | `IfNotPresent`                                                                                                     |
| `client.image.pullSecrets`           | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods)                                                            |
| `nameOverride`                       | String to partially override tensorflow-resnet.fullname template with a string (will prepend the release name) | `nil`                                                                                                              |
| `fullnameOverride`                   | String to fully override tensorflow-resnet.fullname template with a string                                     | `nil`                                                                                                              |
| `containerPorts.server`              | Tensorflow server port                                                                                         | `8500`                                                                                                             |
| `containerPorts.restApi`             | TensorFlow Serving Rest API Port                                                                               | `8501`                                                                                                             |
| `replicaCount`                       | Desired number of pods                                                                                         | `1`                                                                                                                |
| `podAnnotations`                     | Pod annotations                                                                                                | `{}`                                                                                                               |
| `affinity`                           | Map of node/pod affinities                                                                                     | `{}` (The value is evaluated as a template)                                                                        |
| `nodeSelector`                       | Node labels for pod assignment                                                                                 | `{}` (The value is evaluated as a template)                                                                        |
| `tolerations`                        | Tolerations for pod assignment                                                                                 | `[]` (The value is evaluated as a template)                                                                        |
| `resources`                          | Resource requests/limit                                                                                        | `{}`                                                                                                               |
| `livenessProbe.enabled`              | Would you like a livessProbed to be enabled                                                                    | `true`                                                                                                             |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                       | 30                                                                                                                 |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                                                 | 5                                                                                                                  |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                                       | 5                                                                                                                  |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded                      | 6                                                                                                                  |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                    | 1                                                                                                                  |
| `readinessProbe.enabled`             | Would you like a readinessProbe to be enabled                                                                  | `true`                                                                                                             |
| `readinessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                                                                       | 15                                                                                                                 |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                                                 | 5                                                                                                                  |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                                       | 5                                                                                                                  |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded                      | 6                                                                                                                  |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed                    | 1                                                                                                                  |
| `service.type`                       | Kubernetes Service type                                                                                        | `LoadBalancer`                                                                                                     |
| `service.port`                       | TensorFlow Serving server port                                                                                 | `8500`                                                                                                             |
| `service.restApiPort`                | TensorFlow Serving Rest API port                                                                               | `8501`                                                                                                             |
| `service.nodePorts.server`           | Kubernetes server node port                                                                                    | `""`                                                                                                               |
| `service.nodePorts.restApi`          | Kubernetes Rest API node port                                                                                  | `""`                                                                                                               |
| `service.loadBalancerIP`             | LoadBalancer service IP address                                                                                | `""`                                                                                                               |
| `service.annotations`                | Service annotations                                                                                            | `{}`                                                                                                               |
| `metrics.enabled`                    | Enable Prometheus exporter to expose Tensorflow server metrics                                                 | `false`                                                                                                            |
| `metrics.podAnnotations`             | Additional annotations for Metrics exporter pod                                                                | `{prometheus.io/scrape: "true", prometheus.io/path: "/monitoring/prometheus/metrics", prometheus.io/port: "8501"}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release bitnami/tensorflow-resnet --set imagePullPolicy=Always
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/tensorflow-resnet
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.


## Upgrading

### 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is tensorflow-resnet:

```console
$ kubectl delete deployment  tensorflow-resnet --cascade=false
$ helm upgrade tensorflow-resnet bitnami/tensorflow-resnet
$ kubectl delete rs "$(kubectl get rs -l app=tensorflow-resnet -o jsonpath='{.items[0].metadata.name}')"
```
