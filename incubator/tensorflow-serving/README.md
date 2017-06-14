# TensorFlow Serving Inception v3

TensorFlow Serving is an open-source software library for serving machine learning models. This chart will specifically serve the Inception v3 model with already trained data.

## TL;DR;

```console
$ helm install incubator/tensorflow-serving
```

## Introduction

This chart bootstraps a TensorFlow Serving Inception v3 pod on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```console
$ git clone https://github.com/bitnami/tensorflow.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/tensorflow-serving
```

The command deploys Tensorflow Serving Inception v3 model on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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

The following tables lists the configurable parameters of the TensorFlow Inception chart and their default values.

| Parameter                            | Description                              | Default                                                    |
| -------------------------------      | -------------------------------          | ---------------------------------------------------------- |
| `server.image`                       | Tensorflow server image                  | `bitnami/tf-server-slim:{VERSION}`                         |
| `server.port`                        | Tensorflow server port                   | `9000`                                                     |
| `client.image`                       | Tensorflow client image                  | `bitnami/tf-client-slim:{VERSION}`                         |
| `imagePullPolicy`                    | Image pull policy                        | `Always` if `image` tag is `latest`, else `IfNotPresent`   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release incubator/tensorflow-serving --set imagePullPolicy=Always
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/tensorflow-serving
```

> **Tip**: You can use the default [values.yaml](values.yaml)
