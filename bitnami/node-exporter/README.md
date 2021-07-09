# Node Exporter

[Node Exporter](https://github.com/prometheus/node_exporter) is a Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/node-exporter
```

## Introduction

This chart bootstraps [Node Exporter](https://github.com/bitnami/bitnami-docker-node-exporter) on [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

Add the `bitnami` charts repo to Helm:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/node-exporter
```

The command deploys Node Exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Node Exporter chart and their default values.

| Parameter                               | Description                                                                               | Default                                                                   |
|-----------------------------------------|-------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| `global.imageRegistry`                  | Global Docker image registry                                                              | `nil`                                                                     |
| `global.imagePullSecrets`               | Global Docker registry secret names as an array                                           | `[]` (does not add image pull secrets to deployed pods)                   |
| `global.storageClass`                   | Global storage class for dynamic provisioning                                             | `nil`                                                                     |
| `nameOverride`                          | String to partially override `common.names.fullname` template with a string               | `nil`                                                                     |
| `fullnameOverride`                      | String to fully override `common.names.fullname` template with a string                   | `nil`                                                                     |
| `commonLabels`                          | Labels to add to all deployed objects                                                     | `{}`                                                                      |
| `hostAliases`                           | Add deployment host aliases                                                               | `[]`                                                                      |
| `rbac.create`                           | Whether to create & use RBAC resources or not                                             | `true`                                                                    |
| `rbac.apiVersion`                       | Version of the RBAC API                                                                   | `v1beta1`                                                                 |
| `rbac.pspEnabled`                       | PodSecurityPolicy                                                                         | `true`                                                                    |
| `serviceAccount.create`                 | Specify whether to create a ServiceAccount for Node Exporter                              | `true`                                                                    |
| `serviceAccount.name`                   | The name of the ServiceAccount to create                                                  | Generated using the `common.names.fullname` template                      |
| `image.registry`                        | Node Exporter image registry                                                              | `docker.io`                                                               |
| `image.repository`                      | Node Exporter Image name                                                                  | `bitnami/node-exporter`                                                   |
| `image.tag`                             | Node Exporter Image tag                                                                   | `{TAG_NAME}`                                                              |
| `image.pullPolicy`                      | Node Exporter image pull policy                                                           | `IfNotPresent`                                                            |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                          | `[]` (does not add image pull secrets to deployed pods)                   |
| `extraArgs`                             | Additional command line arguments to pass to node-exporter                                | `{}`                                                                      |
| `extraVolumes`                          | Additional volumes to the node-exporter pods                                              | `{}`                                                                      |
| `extraVolumeMounts`                     | Additional volumeMounts to the node-exporter container                                    | `{}`                                                                      |
| `securityContext.enabled`               | Enable security context                                                                   | `true`                                                                    |
| `securityContext.runAsUser`             | User ID for the container                                                                 | `1001`                                                                    |
| `securityContext.fsGroup`               | Group ID for the container filesystem                                                     | `1001`                                                                    |
| `service.type`                          | Kubernetes service type                                                                   | `ClusterIP`                                                               |
| `service.port`                          | Node Exporter service port                                                                | `9100`                                                                    |
| `service.targetPort`                    | Node Exporter container target port                                                       | `9100`                                                                    |
| `service.clusterIP`                     | Specific cluster IP when service type is cluster IP. Use `None` for headless service      | `nil`                                                                     |
| `service.nodePort`                      | Kubernetes Service nodePort                                                               | `nil`                                                                     |
| `service.loadBalancerIP`                | `loadBalancerIP` if service type is `LoadBalancer`                                        | `nil`                                                                     |
| `service.loadBalancerSourceRanges`      | Address that are allowed when svc is `LoadBalancer`                                       | `[]`                                                                      |
| `service.addPrometheusScrapeAnnotation` | Add the `prometheus.io/scrape: "true"` annotation to the service                          | `true`                                                                    |
| `service.annotations`                   | Additional annotations for Node Exporter service                                          | `{}`                                                                      |
| `service.labels`                        | Additional labels for Node Exporter service                                               | `{}`                                                                      |
| `updateStrategy`                        | The update strategy to apply to the DaemonSet                                             | `{ "type": "RollingUpdate", "rollingUpdate": { "maxUnavailable": "1" } }` |
| `hostNetwork`                           | Expose the service to the host network                                                    | `true`                                                                    |
| `minReadySeconds`                       | `minReadySeconds` to avoid killing pods before we are ready                               | `0`                                                                       |
| `priorityClassName`                     | Priority class assigned to the Pods                                                       | `nil`                                                                     |
| `resources`                             | Resource requests/limit                                                                   | `{}`                                                                      |
| `podLabels`                             | Pod labels                                                                                | `{}`                                                                      |
| `podAnnotations`                        | Pod annotations                                                                           | `{}`                                                                      |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                      |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                                                    |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                      |
| `nodeAffinityPreset.key`                | Node label key to match Ignored if `affinity` is set.                                     | `""`                                                                      |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                                                      |
| `affinity`                              | Affinity for pod assignment                                                               | `{}` (evaluated as a template)                                            |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}` (evaluated as a template)                                            |
| `tolerations`                           | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)                                            |
| `livenessProbe.enabled`                 | Turn on and off liveness probe                                                            | `true`                                                                    |
| `livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated                                                  | `120`                                                                     |
| `livenessProbe.periodSeconds`           | How often to perform the probe                                                            | `10`                                                                      |
| `livenessProbe.timeoutSeconds`          | When the probe times out                                                                  | `5`                                                                       |
| `livenessProbe.failureThreshold`        | Minimum consecutive failures for the probe                                                | `6`                                                                       |
| `livenessProbe.successThreshold`        | Minimum consecutive successes for the probe                                               | `1`                                                                       |
| `readinessProbe.enabled`                | Turn on and off readiness probe                                                           | `true`                                                                    |
| `readinessProbe.initialDelaySeconds`    | Delay before readiness probe is initiated                                                 | `30`                                                                      |
| `readinessProbe.periodSeconds`          | How often to perform the probe                                                            | `10`                                                                      |
| `readinessProbe.timeoutSeconds`         | When the probe times out                                                                  | `5`                                                                       |
| `readinessProbe.failureThreshold`       | Minimum consecutive failures for the probe                                                | `6`                                                                       |
| `readinessProbe.successThreshold`       | Minimum consecutive successes for the probe                                               | `1`                                                                       |
| `serviceMonitor.enabled`                | Creates a ServiceMonitor to monitor Node Exporter                                         | `false`                                                                   |
| `serviceMonitor.namespace`              | Namespace in which Prometheus is running                                                  | `nil`                                                                     |
| `serviceMonitor.interval`               | Scrape interval (use by default, falling back to Prometheus' default)                     | `nil`                                                                     |
| `serviceMonitor.jobLabel`               | The name of the label on the target service to use as the job name in prometheus.         | `nil`                                                                     |
| `serviceMonitor.selector`               | ServiceMonitor selector labels                                                            | `[]`                                                                      |
| `serviceMonitor.relabelings`            | ServiceMonitor relabelings                                                                | `[]`                                                                      |
| `serviceMonitor.metricRelabelings`      | ServiceMonitor metricRelabelings                                                          | `[]`                                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example the following command sets the `minReadySeconds` of the Node Exporter Pods to `120` seconds.

```bash
$ helm install my-release --set minReadySeconds=120 bitnami/node-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/node-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `XpodAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/node-exporter
```

### To 2.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 2.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/
