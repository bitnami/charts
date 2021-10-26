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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name               | Description                                                                                  | Value |
| ------------------ | -------------------------------------------------------------------------------------------- | ----- |
| `nameOverride`     | String to partially override common.names.fullname template (will maintain the release name) | `""`  |
| `fullnameOverride` | String to fully override `common.names.fullname` template with a string                      | `""`  |
| `commonLabels`     | Add labels to all the deployed resources                                                     | `{}`  |


### Node Exporter parameters

| Name                                          | Description                                                                               | Value                   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------- |
| `hostAliases`                                 | Deployment pod host aliases                                                               | `[]`                    |
| `rbac.create`                                 | Whether to create and use RBAC resources or not                                           | `true`                  |
| `rbac.apiVersion`                             | Version of the RBAC API                                                                   | `v1beta1`               |
| `rbac.pspEnabled`                             | Enable Pod Security Policy                                                                | `true`                  |
| `serviceAccount.create`                       | Specify whether to create a ServiceAccount for Node Exporter                              | `true`                  |
| `serviceAccount.name`                         | The name of the ServiceAccount to create                                                  | `""`                    |
| `image.registry`                              | Node Exporter image registry                                                              | `docker.io`             |
| `image.repository`                            | Node Exporter image repository                                                            | `bitnami/node-exporter` |
| `image.tag`                                   | Node Exporter Image tag (immutable tags are recommended)                                  | `1.2.2-debian-10-r75`   |
| `image.pullPolicy`                            | Node Exporter image pull policy                                                           | `IfNotPresent`          |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array                                          | `[]`                    |
| `extraArgs`                                   | Additional command line arguments to pass to node-exporter                                | `{}`                    |
| `extraVolumes`                                | Additional volumes to the node-exporter pods                                              | `[]`                    |
| `extraVolumeMounts`                           | Additional volumeMounts to the node-exporter container                                    | `[]`                    |
| `securityContext.enabled`                     | Enable security context                                                                   | `true`                  |
| `securityContext.fsGroup`                     | Group ID for the container filesystem                                                     | `1001`                  |
| `securityContext.runAsUser`                   | User ID for the container                                                                 | `1001`                  |
| `service.type`                                | Kubernetes service type                                                                   | `ClusterIP`             |
| `service.targetPort`                          | Node Exporter container target port                                                       | `9100`                  |
| `service.port`                                | Node Exporter service port                                                                | `9100`                  |
| `service.clusterIP`                           | Specific cluster IP when service type is cluster IP. Use `None` for headless service      | `""`                    |
| `service.nodePort`                            | Specify the nodePort value for the LoadBalancer and NodePort service types                | `""`                    |
| `service.loadBalancerIP`                      | `loadBalancerIP` if service type is `LoadBalancer`                                        | `""`                    |
| `service.loadBalancerSourceRanges`            | Address that are allowed when service is `LoadBalancer`                                   | `[]`                    |
| `service.addPrometheusScrapeAnnotation`       | Add the `prometheus.io/scrape: "true"` annotation to the service                          | `true`                  |
| `service.annotations`                         | Additional annotations for Node Exporter service                                          | `{}`                    |
| `service.labels`                              | Additional labels for Node Exporter service                                               | `{}`                    |
| `updateStrategy.type`                         | The update strategy type to apply to the DaemonSet                                        | `RollingUpdate`         |
| `updateStrategy.rollingUpdate.maxUnavailable` | Maximum number of pods that may be made unavailable                                       | `1`                     |
| `hostNetwork`                                 | Expose the service to the host network                                                    | `true`                  |
| `minReadySeconds`                             | `minReadySeconds` to avoid killing pods before we are ready                               | `0`                     |
| `priorityClassName`                           | Priority class assigned to the Pods                                                       | `""`                    |
| `resources.limits`                            | The resources limits for the container                                                    | `{}`                    |
| `resources.requests`                          | The requested resources for the container                                                 | `{}`                    |
| `podLabels`                                   | Pod labels                                                                                | `{}`                    |
| `podAnnotations`                              | Pod annotations                                                                           | `{}`                    |
| `podAffinityPreset`                           | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                    |
| `podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                  |
| `nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                    |
| `nodeAffinityPreset.key`                      | Node label key to match Ignored if `affinity` is set.                                     | `""`                    |
| `nodeAffinityPreset.values`                   | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                    |
| `affinity`                                    | Affinity for pod assignment. Evaluated as a template.                                     | `{}`                    |
| `nodeSelector`                                | Node labels for pod assignment. Evaluated as a template.                                  | `{}`                    |
| `tolerations`                                 | Tolerations for pod assignment. Evaluated as a template.                                  | `[]`                    |
| `livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                   | `120`                   |
| `livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                          | `10`                    |
| `livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                         | `5`                     |
| `livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                       | `6`                     |
| `livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                       | `1`                     |
| `readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                  | `30`                    |
| `readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                         | `10`                    |
| `readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                        | `5`                     |
| `readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                      | `6`                     |
| `readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                      | `1`                     |
| `serviceMonitor.enabled`                      | Creates a ServiceMonitor to monitor Node Exporter                                         | `false`                 |
| `serviceMonitor.namespace`                    | Namespace in which Prometheus is running                                                  | `""`                    |
| `serviceMonitor.jobLabel`                     | The name of the label on the target service to use as the job name in prometheus.         | `""`                    |
| `serviceMonitor.interval`                     | Scrape interval (use by default, falling back to Prometheus' default)                     | `""`                    |
| `serviceMonitor.scrapeTimeout`                | Timeout after which the scrape is ended                                                   | `""`                    |
| `serviceMonitor.selector`                     | ServiceMonitor selector labels                                                            | `{}`                    |
| `serviceMonitor.relabelings`                  | RelabelConfigs to apply to samples before scraping                                        | `[]`                    |
| `serviceMonitor.metricRelabelings`            | MetricRelabelConfigs to apply to samples before ingestion                                 | `[]`                    |


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

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/node-exporter
```

### To 2.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 2.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/node-exporter/administration/upgrade-helm3/).
