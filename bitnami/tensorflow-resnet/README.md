# TensorFlow Serving ResNet

TensorFlow Serving is an open-source software library for serving machine learning models. This chart will specifically serve the ResNet model with already trained data.

## TL;DR;

```console
$ helm install bitnami/tensorflow-resnet
```

## Introduction

This chart bootstraps a TensorFlow Serving ResNet deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```console
$ git clone https://github.com/bitnami/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/tensorflow-resnet
```

The command deploys Tensorflow Serving ResNet model on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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

## Configuration

The following tables lists the configurable parameters of the TensorFlow ResNet chart and their default values.

| Parameter                                     | Description                                          | Default                                                      |
| ------------------------------------------    | -----------------------------------------------------| -------------------------------------------------------------|
| `global.imageRegistry`                        | Global Docker image registry                         | `nil`                                                        |
| `server.image.registry`                       | TensorFlow Serving image registry                    | `docker.io`                                                  |
| `server.image.repository`                     | TensorFlow Serving Image name                        | `bitnami/tensorflow-serving`                                 |
| `server.image.tag`                            | TensorFlow Serving Image tag                         | `{VERSION}`                                                  |
| `server.image.pullPolicy`                     | TensorFlow Serving image pull policy                 | `Always` if `imageTag` is `latest`, else `IfNotPresent`      |
| `server.image.pullSecrets`                    | Specify image pull secrets                           | `nil` (does not add image pull secrets to deployed pods)     |
| `replicaCount`                                | Desired number of pods                               | `1`                                                          |
| `server.port`                                 | Tensorflow server port                               | `8500`                                                       |
| `client.image.registry`                       | TensorFlow ResNet image registry                     | `docker.io`                                                  |
| `client.image.repository`                     | TensorFlow ResNet Image name                         | `bitnami/tensorflow-resnet`                                  |
| `client.image.tag`                            | TensorFlow ResNet Image tag                          | `{VERSION}`                                                  |
| `client.image.pullPolicy`                     | TensorFlow ResNet image pull policy                  | `Always` if `imageTag` is `latest`, else `IfNotPresent`      |
| `client.image.pullSecrets`                    | Specify image pull secrets                           | `nil` (does not add image pull secrets to deployed pods)     |
| `imagePullPolicy`                             | Image pull policy                                    | `Always` if `image` tag is `latest`, else `IfNotPresent`     |
| `podAnnotations`                              | Pod annotations                                      | `{}`                                                         |
| `livenessProbe.enabled`                       | Would you like a livessProbed to be enabled                                                       |  `true`         |
| `livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated                                                          |  30             |
| `livenessProbe.periodSeconds`                 | How often to perform the probe                                                                    |  5              |
| `livenessProbe.timeoutSeconds`                | When the probe times out                                                                          |  5              |
| `livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded         |  6              |
| `livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed       |  1              |
| `readinessProbe.enabled`                      | Would you like a readinessProbe to be enabled                                                     |  `true`         |
| `readinessProbe.initialDelaySeconds`          | Delay before liveness probe is initiated                                                          |  15             |
| `readinessProbe.periodSeconds`                | How often to perform the probe                                                                    |  5              |
| `readinessProbe.timeoutSeconds`               | When the probe times out                                                                          |  5              |
| `readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded         |  6              |
| `readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed       |  1              |
| `metrics.enabled`                             | Start a side-car Tensorflow prometheus exporter      | `false`                                                      |
| `metrics.image.registry`                      | Tensorflow exporter image registry                   | `docker.io`                                                  |
| `metrics.image.repository`                    | Tensorflow exporter image name                       | `ynqa/tensorflow-serving-exporter`                           |
| `metrics.image.tag`                           | Tensorflow exporter image tag                        | `latest`                                                     |
| `metrics.image.pullPolicy`                    | Image pull policy                                    | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`                   | Specify docker-registry secret names as an array     | `nil`                                                        |
| `metrics.port`                                | TensorFlow Exporter port                             | `9118`                                                       |
| `metrics.livenessProbe.enabled`               | Would you like a livessProbed to be enabled (metrics)                                                       |  `true`     |
| `metrics.livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated (metrics)                                                          |  30         |
| `metrics.livenessProbe.periodSeconds`         | How often to perform the probe (metrics)                                                                    |  5          |
| `metrics.livenessProbe.timeoutSeconds`        | When the probe times out (metrics)                                                                          |  5          |
| `metrics.livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded (metrics)         |  6          |
| `metrics.livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed (metrics)       |  1          |
| `metrics.readinessProbe.enabled`              | Would you like a readinessProbe to be enabled (metrics)                                                     |  `true`     |
| `metrics.readinessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (metrics)                                                          |  15         |
| `metrics.readinessProbe.periodSeconds`        | How often to perform the probe (metrics)                                                                    |  5          |
| `metrics.readinessProbe.timeoutSeconds`       | When the probe times out (metrics)                                                                          |  5          |
| `metrics.readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded (metrics)         |  6          |
| `metrics.readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (metrics)       |  1          |
| `metrics.podAnnotations`                      | Additional annotations for Metrics exporter pod      | `{prometheus.io/scrape: "true", prometheus.io/port: "9118"}`       |
| `metrics.resources`                           | Exporter resource requests/limit                     | Memory: `256Mi`, CPU: `100m`                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release bitnami/tensorflow-resnet --set imagePullPolicy=Always
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/tensorflow-resnet
```

> **Tip**: You can use the default [values.yaml](values.yaml)