<!--- app-name: TensorFlow ResNet -->

# TensorFlow Serving ResNet

TensorFlow Serving is an open-source software library for serving machine learning models. This chart will specifically serve the ResNet model with already trained data.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/tensorflow-resnet
```

## Introduction

This chart bootstraps a TensorFlow Serving ResNet deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name               | Description                                                                                  | Value |
| ------------------ | -------------------------------------------------------------------------------------------- | ----- |
| `nameOverride`     | String to partially override common.names.fullname template (will maintain the release name) | `""`  |
| `fullnameOverride` | String to fully override common.names.fullname template                                      | `""`  |
| `extraDeploy`      | Array of extra objects to deploy with the release                                            | `[]`  |


### TensorFlow parameters

| Name                                 | Description                                                                               | Value                        |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | ---------------------------- |
| `server.image.registry`              | TensorFlow Serving image registry                                                         | `docker.io`                  |
| `server.image.repository`            | TensorFlow Serving image repository                                                       | `bitnami/tensorflow-serving` |
| `server.image.tag`                   | TensorFlow Serving Image tag (immutable tags are recommended)                             | `2.6.0-debian-10-r32`        |
| `server.image.pullPolicy`            | TensorFlow Serving image pull policy                                                      | `IfNotPresent`               |
| `server.image.pullSecrets`           | Specify docker-registry secret names as an array                                          | `[]`                         |
| `client.image.registry`              | TensorFlow ResNet image registry                                                          | `docker.io`                  |
| `client.image.repository`            | TensorFlow ResNet image repository                                                        | `bitnami/tensorflow-resnet`  |
| `client.image.tag`                   | TensorFlow ResNet Image tag (immutable tags are recommended)                              | `2.6.1-debian-10-r0`         |
| `client.image.pullPolicy`            | TensorFlow ResNet image pull policy                                                       | `IfNotPresent`               |
| `client.image.pullSecrets`           | Specify docker-registry secret names as an array                                          | `[]`                         |
| `hostAliases`                        | Deployment pod host aliases                                                               | `[]`                         |
| `containerPorts.server`              | Tensorflow server port                                                                    | `8500`                       |
| `containerPorts.restApi`             | TensorFlow Serving Rest API Port                                                          | `8501`                       |
| `replicaCount`                       | Number of replicas                                                                        | `1`                          |
| `podAnnotations`                     | Pod annotations                                                                           | `{}`                         |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                         |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                       |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                         |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                     | `""`                         |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                         |
| `affinity`                           | Affinity for pod assignment. Evaluated as a template.                                     | `{}`                         |
| `nodeSelector`                       | Node labels for pod assignment. Evaluated as a template.                                  | `{}`                         |
| `tolerations`                        | Tolerations for pod assignment. Evaluated as a template.                                  | `[]`                         |
| `resources.limits`                   | The resources limits for the container                                                    | `{}`                         |
| `resources.requests`                 | The requested resources for the container                                                 | `{}`                         |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                      | `true`                       |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `30`                         |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `5`                          |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `5`                          |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `6`                          |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`                          |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                     | `true`                       |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `15`                         |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `5`                          |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `5`                          |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `6`                          |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`                          |
| `service.type`                       | Kubernetes Service type                                                                   | `LoadBalancer`               |
| `service.port`                       | TensorFlow Serving server port                                                            | `8500`                       |
| `service.restApiPort`                | TensorFlow Serving Rest API port                                                          | `8501`                       |
| `service.nodePorts.server`           | Kubernetes server node port                                                               | `""`                         |
| `service.nodePorts.restApi`          | Kubernetes Rest API node port                                                             | `""`                         |
| `service.loadBalancerIP`             | Set the LoadBalancer service type to internal only.                                       | `""`                         |
| `service.annotations`                | Service annotations                                                                       | `{}`                         |
| `metrics.enabled`                    | Enable Prometheus exporter to expose Tensorflow server metrics                            | `false`                      |
| `metrics.podAnnotations`             | Prometheus exporter pod annotations                                                       | `{}`                         |


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

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use any of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.3.0

TensorFlow ResNet's version was updated to `2.7.0`. Although this new version [does not include breaking changes](https://github.com/tensorflow/serving/releases/tag/2.7.0), the client [was updated to work with newer TF Model Garden models](https://github.com/tensorflow/serving/commit/bb1428d53abb53fe938ddf9bb8839d4dfe48d291). Older models may need to adapt their signature [to the newer, common one](https://www.tensorflow.org/hub/common_signatures/images).

As a result, the pretrained model served by this Chart was updated to [Imagenet (ILSVRC-2012-CLS) classification with ResNet 50](https://tfhub.dev/tensorflow/resnet_50/classification/1).

### To 3.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 3.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/tensorflow-resnet/administration/upgrade-helm3/).


### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is tensorflow-resnet:

```console
$ kubectl delete deployment  tensorflow-resnet --cascade=false
$ helm upgrade tensorflow-resnet bitnami/tensorflow-resnet
$ kubectl delete rs "$(kubectl get rs -l app=tensorflow-resnet -o jsonpath='{.items[0].metadata.name}')"
```

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
