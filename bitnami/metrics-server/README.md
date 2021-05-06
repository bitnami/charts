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
- Helm 3.1.0

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

| Parameter                            | Description                                                                                                                                                                                                                   | Default                                                 |
|--------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`               | Global Docker image registry                                                                                                                                                                                                  | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                                                                                                                                               | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                     | Metrics Server image registry                                                                                                                                                                                                 | `docker.io`                                             |
| `image.repository`                   | Metrics Server image name                                                                                                                                                                                                     | `bitnami/metrics-server`                                |
| `image.tag`                          | Metrics Server image tag                                                                                                                                                                                                      | `{TAG_NAME}`                                            |
| `image.pullPolicy`                   | Metrics Server image pull policy                                                                                                                                                                                              | `IfNotPresent`                                          |
| `nameOverride`                       | String to partially override common.names.fullname template with a string (will prepend the release name)                                                                                                                     | `nil`                                                   |
| `fullnameOverride`                   | String to fully override common.names.fullname template with a string                                                                                                                                                         | `nil`                                                   |
| `replicas`                           | Number of metrics-server nodes to deploy                                                                                                                                                                                      | `1`                                                     |
| `securePort`                         | Port where metrics-server will be running                                                                                                                                                                                     | `8443`                                                  |
| `hostNetwork`                        | Enable hostNetwork mode                                                                                                                                                                                                       | `false`                                                 |
| `command`                            | Override default container command (useful when using custom images)                                                                                                                                                          | `["metrics-server"]`                                    |
| `extraArgs`                          | Extra arguments to pass to metrics-server on start up                                                                                                                                                                         | {}                                                      |
| `rbac.create`                        | Enable RBAC authentication                                                                                                                                                                                                    | `true`                                                  |
| `serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account                                                                                                                                                                      | `true`                                                  |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                                                                                                                                                          | `true`                                                  |
| `serviceAccount.name`                | The name of the ServiceAccount to create                                                                                                                                                                                      | Generated using the fullname template                   |
| `apiService.create`                  | Specifies whether the v1beta1.metrics.k8s.io API service should be created (This should not be necessary in k8s version >= 1.8). You can check if it is needed with `kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"`. | `false`                                                 |
| `podLabels`                          | Pod labels                                                                                                                                                                                                                    | `{}`                                                    |
| `podAnnotations`                     | Pod annotations                                                                                                                                                                                                               | `{}`                                                    |
| `priorityClassName`                  | Priority class for pod scheduling                                                                                                                                                                                             | `nil`                                                   |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`                                                    |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `soft`                                                  |
| `podDisruptionBudget.enabled`        | Create a PodDisruptionBudget                                                                                                                                                                                                  | `false`                                                 |
| `podDisruptionBudget.minAvailable`   | Minimum available instances; ignored if there is no PodDisruptionBudget                                                                                                                                                       | `nil`                                                   |
| `podDisruptionBudget.maxUnavailable` | Maximum unavailable instances; ignored if there is no PodDisruptionBudget                                                                                                                                                     | `nil`                                                   |
| `hostAliases`                        | Add deployment host aliases                                                                                                                                                                                                   | `[]`                                                    |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`                                                    |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                                        | `""`                                                    |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                     | `[]`                                                    |
| `affinity`                           | Affinity for pod assignment                                                                                                                                                                                                   | `{}` (evaluated as a template)                          |
| `topologySpreadConstraints`          | Topology spread constraints for pod                                                                                                                                                                                           | `[]` (evaluated as a template)                          |
| `nodeSelector`                       | Node labels for pod assignment                                                                                                                                                                                                | `{}` (evaluated as a template)                          |
| `tolerations`                        | Tolerations for pod assignment                                                                                                                                                                                                | `[]` (evaluated as a template)                          |
| `service.type`                       | Kubernetes Service type                                                                                                                                                                                                       | `ClusterIP`                                             |
| `service.port`                       | Kubernetes Service port                                                                                                                                                                                                       | `443`                                                   |
| `service.annotations`                | Annotations for the Service                                                                                                                                                                                                   | {}                                                      |
| `service.labels`                     | Labels for the Service                                                                                                                                                                                                        | {}                                                      |
| `service.loadBalancerIP`             | LoadBalancer IP if Service type is `LoadBalancer`                                                                                                                                                                             | `nil`                                                   |
| `service.nodePort`                   | NodePort if Service type is `LoadBalancer` or `NodePort`                                                                                                                                                                      | `nil`                                                   |
| `resources`                          | The [resources] to allocate for the container                                                                                                                                                                                 | `{}`                                                    |
| `livenessProbe`                      | Liveness probe configuration                                                                                                                                                                                                  | Check `values.yaml` file                                |
| `readinessProbe`                     | Readiness probe configuration                                                                                                                                                                                                 | Check `values.yaml` file                                |
| `customLivenessProbe`                | Override default liveness probe                                                                                                                                                                                               | `{}` (evaluated as a template)                          |
| `customReadinessProbe`               | Override default readiness probe                                                                                                                                                                                              | `{}` (evaluated as a template)                          |
| `podSecurityContext`                 | Metrics Server pods' Security Context                                                                                                                                                                                         | Check `values.yaml` file                                |
| `containerSecurityContext`           | Metrics Server containers' Security Context                                                                                                                                                                                   | Check `values.yaml` file                                |
| `extraVolumes`                       | Extra volumes                                                                                                                                                                                                                 | `nil`                                                   |
| `extraVolumeMounts`                  | Mount extra volume(s)                                                                                                                                                                                                         | `nil`                                                   |

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 5.2.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 5.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 4.0.0

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
