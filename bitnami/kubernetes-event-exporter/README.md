# Kubernetes Event Exporter

[Kubernetes Event Exporter](https://github.com/opsgenie/kubernetes-event-exporter) allows exporting the often missed Kubernetes events to various outputs so that they can be used for observability or alerting purposes.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kubernetes-event-exporter
```

## Introduction

This chart bootstraps a [Kubernetes Event Exporter](https://github.com/opsgenie/kubernetes-event-exporter) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kubernetes-event-exporter
```

These commands deploy Kubernetes Event Exporter on the Kubernetes cluster in the default configuration. The [Parameters](##parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list` or `helm ls --all-namespaces`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name                | Description                                                                                              | Value |
| ------------------- | -------------------------------------------------------------------------------------------------------- | ----- |
| `nameOverride`      | String to partially override kubernetes-event-exporter.fullname include (will maintain the release name) | `""`  |
| `fullnameOverride`  | String to fully override kubernetes-event-exporter.fullname template                                     | `""`  |
| `commonAnnotations` | Annotations to add to all deployed objects                                                               | `{}`  |
| `commonLabels`      | Labels to add to all deployed objects                                                                    | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template)                              | `[]`  |


### Kubernetes Event Exporter parameters

| Name                                              | Description                                                                               | Value                               |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------- |
| `replicaCount`                                    | Desired number of pod replicas                                                            | `1`                                 |
| `image.registry`                                  | Container image registry                                                                  | `docker.io`                         |
| `image.repository`                                | Container image name                                                                      | `bitnami/kubernetes-event-exporter` |
| `image.tag`                                       | Container image tag                                                                       | `0.11.0-debian-10-r0`               |
| `image.pullPolicy`                                | Container image pull policy                                                               | `IfNotPresent`                      |
| `image.pullSecrets`                               | Specify docker-registry secret names as an array                                          | `[]`                                |
| `hostAliases`                                     | Add deployment host aliases                                                               | `[]`                                |
| `config.logLevel`                                 | Verbosity of the logs (options: `fatal`, `error`, `warn`, `info` or `debug`)              | `debug`                             |
| `config.logFormat`                                | How the logs are formatted. Allowed values: `pretty` or `json`                            | `pretty`                            |
| `config.receivers`                                | Array containing event receivers                                                          | `[]`                                |
| `config.route.routes`                             | Array containing event route configuration                                                | `[]`                                |
| `rbac.create`                                     | Create the RBAC roles for API accessibility                                               | `true`                              |
| `serviceAccount.create`                           | Create a serviceAccount for the pod                                                       | `true`                              |
| `serviceAccount.name`                             | Use the serviceAccount with the specified name                                            | `""`                                |
| `podAnnotations`                                  | Pod annotations                                                                           | `{}`                                |
| `podSecurityContext.enabled`                      | Enable security context                                                                   | `true`                              |
| `podSecurityContext.fsGroup`                      | Group ID for the container                                                                | `1001`                              |
| `containerSecurityContext.enabled`                | Enable container security context                                                         | `true`                              |
| `containerSecurityContext.capabilities.add`       | Add capabilities for the securityContext                                                  | `[]`                                |
| `containerSecurityContext.capabilities.drop`      | Drop capabilities for the securityContext                                                 | `[]`                                |
| `containerSecurityContext.readOnlyRootFilesystem` | Allows the pod to mount the RootFS as ReadOnly only                                       | `true`                              |
| `containerSecurityContext.runAsNonRoot`           | If the pod should run as a non root container.                                            | `true`                              |
| `containerSecurityContext.runAsUser`              | Define the uid with which the pod will run                                                | `1001`                              |
| `resources.limits`                                | Specify resource limits which the container is not allowed to succeed.                    | `{}`                                |
| `resources.requests`                              | Specify resource requests which the container needs to spawn.                             | `{}`                                |
| `nodeSelector`                                    | Node labels for pod assignment                                                            | `{}`                                |
| `priorityClassName`                               | Set Priority Class Name to allow priority control over other pods                         | `""`                                |
| `tolerations`                                     | Tolerations for pod assignment                                                            | `[]`                                |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                              |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                |
| `affinity`                                        | Affinity for pod assignment                                                               | `{}`                                |
| `extraEnvVars`                                    | Array containing extra env vars to be added to all containers                             | `[]`                                |
| `extraEnvVarsConfigMap`                           | ConfigMap containing extra env vars to be added to all containers                         | `""`                                |
| `extraEnvVarsSecret`                              | Secret containing extra env vars to be added to all containers                            | `""`                                |
| `extraVolumeMounts`                               | Array to add extra mounts (normally used with extraVolumes)                               | `[]`                                |
| `extraVolumes`                                    | Array to add extra volumes                                                                | `[]`                                |
| `initContainers`                                  | Attach additional init containers to pods                                                 | `[]`                                |


## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter. Refer to the [chart documentation for more information on these parameters and how to use them with images from a private registry](https://docs.bitnami.com/kubernetes/apps/kubernetes-event-exporter/configuration/change-image-version/).

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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
