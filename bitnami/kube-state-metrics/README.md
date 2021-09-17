# kube-state-metrics

[kube-state-metrics](https://github.com/kubernetes/kube-state-metrics) is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kube-state-metrics
```

## Introduction

This chart bootstraps [kube-state-metrics](https://github.com/bitnami/bitnami-docker-kube-state-metrics) on [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh) package manager.

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
$ helm install my-release bitnami/kube-state-metrics
```

The command deploys kube-state-metrics on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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

| Name                | Description                                                                                                   | Value |
| ------------------- | ------------------------------------------------------------------------------------------------------------- | ----- |
| `nameOverride`      | String to partially override `kube-state-metrics.name` template with a string (will prepend the release name) | `""`  |
| `fullnameOverride`  | String to fully override `kube-state-metrics.fullname` template with a string                                 | `""`  |
| `commonLabels`      | Add labels to all the deployed resources                                                                      | `{}`  |
| `commonAnnotations` | Add annotations to all the deployed resources                                                                 | `{}`  |


### kube-state-metrics parameters

| Name                                            | Description                                                                               | Value                        |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------- |
| `hostAliases`                                   | Add deployment host aliases                                                               | `[]`                         |
| `rbac.create`                                   | Whether to create & use RBAC resources or not                                             | `true`                       |
| `rbac.apiVersion`                               | Version of the RBAC API                                                                   | `v1beta1`                    |
| `rbac.pspEnabled`                               | PodSecurityPolicy                                                                         | `true`                       |
| `serviceAccount.create`                         | Specify whether to create a ServiceAccount for kube-state-metrics                         | `true`                       |
| `serviceAccount.name`                           | The name of the ServiceAccount to create                                                  | `""`                         |
| `image.registry`                                | kube-state-metrics image registry                                                         | `docker.io`                  |
| `image.repository`                              | kube-state-metrics image repository                                                       | `bitnami/kube-state-metrics` |
| `image.tag`                                     | kube-state-metrics Image tag (immutable tags are recommended)                             | `2.2.0-debian-10-r2`         |
| `image.pullPolicy`                              | kube-state-metrics image pull policy                                                      | `IfNotPresent`               |
| `image.pullSecrets`                             | Specify docker-registry secret names as an array                                          | `[]`                         |
| `extraArgs`                                     | Additional command line arguments to pass to kube-state-metrics                           | `{}`                         |
| `namespaces`                                    | Comma-separated list of namespaces to be enabled. Defaults to all namespaces              | `""`                         |
| `kubeResources.certificatesigningrequests`      | Enable the `certificatesigningrequests` resource                                          | `true`                       |
| `kubeResources.configmaps`                      | Enable the `configmaps` resource                                                          | `true`                       |
| `kubeResources.cronjobs`                        | Enable the `cronjobs` resource                                                            | `true`                       |
| `kubeResources.daemonsets`                      | Enable the `daemonsets` resource                                                          | `true`                       |
| `kubeResources.deployments`                     | Enable the `deployments` resource                                                         | `true`                       |
| `kubeResources.endpoints`                       | Enable the `endpoints` resource                                                           | `true`                       |
| `kubeResources.horizontalpodautoscalers`        | Enable the `horizontalpodautoscalers` resource                                            | `true`                       |
| `kubeResources.ingresses`                       | Enable the `ingresses` resource                                                           | `true`                       |
| `kubeResources.jobs`                            | Enable the `jobs` resource                                                                | `true`                       |
| `kubeResources.limitranges`                     | Enable the `limitranges` resource                                                         | `true`                       |
| `kubeResources.mutatingwebhookconfigurations`   | Enable the `mutatingwebhookconfigurations` resource                                       | `true`                       |
| `kubeResources.namespaces`                      | Enable the `namespaces` resource                                                          | `true`                       |
| `kubeResources.networkpolicies`                 | Enable the `networkpolicies` resource                                                     | `true`                       |
| `kubeResources.nodes`                           | Enable the `nodes` resource                                                               | `true`                       |
| `kubeResources.persistentvolumeclaims`          | Enable the `persistentvolumeclaims` resource                                              | `true`                       |
| `kubeResources.persistentvolumes`               | Enable the `persistentvolumes` resource                                                   | `true`                       |
| `kubeResources.poddisruptionbudgets`            | Enable the `poddisruptionbudgets` resource                                                | `true`                       |
| `kubeResources.pods`                            | Enable the `pods` resource                                                                | `true`                       |
| `kubeResources.replicasets`                     | Enable the `replicasets` resource                                                         | `true`                       |
| `kubeResources.replicationcontrollers`          | Enable the `replicationcontrollers` resource                                              | `true`                       |
| `kubeResources.resourcequotas`                  | Enable the `resourcequotas` resource                                                      | `true`                       |
| `kubeResources.secrets`                         | Enable the `secrets` resource                                                             | `true`                       |
| `kubeResources.services`                        | Enable the `services` resource                                                            | `true`                       |
| `kubeResources.statefulsets`                    | Enable the `statefulsets` resource                                                        | `true`                       |
| `kubeResources.storageclasses`                  | Enable the `storageclasses` resource                                                      | `true`                       |
| `kubeResources.verticalpodautoscalers`          | Enable the `verticalpodautoscalers` resource                                              | `false`                      |
| `kubeResources.validatingwebhookconfigurations` | Enable the `validatingwebhookconfigurations` resource                                     | `false`                      |
| `kubeResources.volumeattachments`               | Enable the `volumeattachments` resource                                                   | `true`                       |
| `securityContext.enabled`                       | Enable security context                                                                   | `true`                       |
| `securityContext.fsGroup`                       | Group ID for the container filesystem                                                     | `1001`                       |
| `securityContext.runAsUser`                     | User ID for the container                                                                 | `1001`                       |
| `service.type`                                  | Kubernetes service type                                                                   | `ClusterIP`                  |
| `service.port`                                  | kube-state-metrics service port                                                           | `8080`                       |
| `service.clusterIP`                             | Specific cluster IP when service type is cluster IP. Use `None` for headless service      | `""`                         |
| `service.nodePort`                              | Specify the nodePort value for the LoadBalancer and NodePort service types.               | `""`                         |
| `service.loadBalancerIP`                        | `loadBalancerIP` if service type is `LoadBalancer`                                        | `""`                         |
| `service.loadBalancerSourceRanges`              | Address that are allowed when svc is `LoadBalancer`                                       | `[]`                         |
| `service.annotations`                           | Additional annotations for kube-state-metrics service                                     | `{}`                         |
| `service.labels`                                | Additional labels for kube-state-metrics service                                          | `{}`                         |
| `hostNetwork`                                   | Enable hostNetwork mode                                                                   | `false`                      |
| `priorityClassName`                             | Priority class assigned to the Pods                                                       | `""`                         |
| `resources.limits`                              | The resources limits for the container                                                    | `{}`                         |
| `resources.requests`                            | The requested resources for the container                                                 | `{}`                         |
| `replicaCount`                                  | Desired number of controller pods                                                         | `1`                          |
| `podLabels`                                     | Pod labels                                                                                | `{}`                         |
| `podAnnotations`                                | Pod annotations                                                                           | `{}`                         |
| `updateStrategy`                                | Allows setting of `RollingUpdate` strategy                                                | `{}`                         |
| `minReadySeconds`                               | How many seconds a pod needs to be ready before killing the next, during update           | `0`                          |
| `podAffinityPreset`                             | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                         |
| `podAntiAffinityPreset`                         | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                       |
| `nodeAffinityPreset.type`                       | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                         |
| `nodeAffinityPreset.key`                        | Node label key to match. Ignored if `affinity` is set.                                    | `""`                         |
| `nodeAffinityPreset.values`                     | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                         |
| `affinity`                                      | Affinity for pod assignment                                                               | `{}`                         |
| `nodeSelector`                                  | Node labels for pod assignment                                                            | `{}`                         |
| `tolerations`                                   | Tolerations for pod assignment                                                            | `[]`                         |
| `livenessProbe.enabled`                         | Turn on and off liveness probe                                                            | `true`                       |
| `livenessProbe.initialDelaySeconds`             | Delay before liveness probe is initiated                                                  | `120`                        |
| `livenessProbe.periodSeconds`                   | How often to perform the probe                                                            | `10`                         |
| `livenessProbe.timeoutSeconds`                  | When the probe times out                                                                  | `5`                          |
| `livenessProbe.failureThreshold`                | Minimum consecutive failures for the probe                                                | `6`                          |
| `livenessProbe.successThreshold`                | Minimum consecutive successes for the probe                                               | `1`                          |
| `readinessProbe.enabled`                        | Turn on and off readiness probe                                                           | `true`                       |
| `readinessProbe.initialDelaySeconds`            | Delay before readiness probe is initiated                                                 | `30`                         |
| `readinessProbe.periodSeconds`                  | How often to perform the probe                                                            | `10`                         |
| `readinessProbe.timeoutSeconds`                 | When the probe times out                                                                  | `5`                          |
| `readinessProbe.failureThreshold`               | Minimum consecutive failures for the probe                                                | `6`                          |
| `readinessProbe.successThreshold`               | Minimum consecutive successes for the probe                                               | `1`                          |
| `serviceMonitor.enabled`                        | Creates a ServiceMonitor to monitor kube-state-metrics                                    | `false`                      |
| `serviceMonitor.namespace`                      | Namespace in which Prometheus is running                                                  | `""`                         |
| `serviceMonitor.jobLabel`                       | The name of the label on the target service to use as the job name in prometheus.         | `""`                         |
| `serviceMonitor.interval`                       | Scrape interval (use by default, falling back to Prometheus' default)                     | `""`                         |
| `serviceMonitor.scrapeTimeout`                  | Timeout after which the scrape is ended                                                   | `""`                         |
| `serviceMonitor.selector`                       | ServiceMonitor selector labels                                                            | `{}`                         |
| `serviceMonitor.honorLabels`                    | Honor metrics labels                                                                      | `false`                      |
| `serviceMonitor.relabelings`                    | ServiceMonitor relabelings                                                                | `[]`                         |
| `serviceMonitor.metricRelabelings`              | ServiceMonitor metricRelabelings                                                          | `[]`                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example the following command sets the `replicas` of the kube-state-metrics Pods to `2`.

```bash
$ helm install my-release --set replicas=2 bitnami/kube-state-metrics
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/kube-state-metrics
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/apps/kube-state-metrics/configuration/configure-sidecar-init-containers/).

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/kube-state-metrics
```

### To 2.0.0

This version updates kube-state-metrics to its new major, 2.0.0. There have been some value's name changes to acommodate to the naming used in 2.0.0:

  - `.Values.namespace` -> `.Values.namespaces`
  - `.Values.collectors` -> `.Values.kubeResources`

For more information, please refer to [kube-state-metrics 2 release notes](https://kubernetes.io/blog/2021/04/13/kube-state-metrics-v-2-0/).

### To 1.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 1.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/kube-state-metrics/administration/upgrade-helm3/).
