# grafana-operator

[grafana-operator](https://github.com/integr8ly/grafana-operator) is an Operator which introduces Lifecycle Management for Grafana Dashboards and Plugins.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/grafana-operator
```

## Introduction
Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [grafana-operator](https://github.com/integr8ly/grafana-operator/blob/master/documentation/deploy_grafana.md) Deployment [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/grafana-operator
```

These commands deploy grafana-operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` helm release:

```console
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the grafana-operator chart and their default values.

| Parameter                                             | Description                                                                                          | Default                                                 |
|-------------------------------------------------------|------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                                | Global Docker image registry                                                                         | `nil`                                                   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                                      | Grafana Operator image registry                                                                      | `docker.io`                                             |
| `image.repository`                                    | Grafana Operator image name                                                                          | `bitnami/grafana-operator`                              |
| `image.tag`                                           | Grafana Operator image tag                                                                           | `{TAG_NAME}`                                            |
| `image.pullPolicy`                                    | Grafana Operator image pull policy                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                                   | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `replicaCount`                                        | Specify the amount of replicas running                                                               | `1`                                                     |
| `updateStrategy`                                      | Specify the updateStrategy of the containers                                                         | `{"type": "RollingUpdate"}`                             |
| `args.scanAllNamespaces`                              | Specify if all namespace should be scanned for dashboards and datasources. (Creates ClusterRole)     | `false`                                                 |
| `args.scanNamespaces`                                 | Specify the namespaces which should be scanned for dashboards and datasources (Creates ClusterRole)  | `[]` (does not add ClusterRole or Namespaces)           |
| `installCRDs`                                         | only Helm v2 specify if CRDs get installed                                                           | `true`                                                  |
| `customResourceDeletePolicy`                          | only Helm v2 specify a policy on ressource deletion                                                  | `nil`                                                   |
| `podAffinityPreset`                                   | Set podAffinity preset from Helm Chart                                                               | `nil`                                                   |
| `podAntiAffinityPreset`                               | Set podAntiAffinity preset from Helm Chart                                                           | `soft`                                                  |
| `nodeAffinityPreset.type`                             | Set nodeAffinity preset type                                                                         | `nil`                                                   |
| `nodeAffinityPreset.key`                              | Set nodeAffinity preset key                                                                          | `nil`                                                   |
| `nodeAffinityPreset.values`                           | Set nodeAffinity preset values                                                                       | `nil`                                                   |
| `grafana.image.registry`                              | Grafana image registry                                                                               | `docker.io`                                             |
| `grafana.image.repository`                            | Grafana image name                                                                                   | `bitnami/grafana`                                       |
| `grafana.image.tag`                                   | Grafana image tag                                                                                    | `{TAG_NAME}`                                            |
| `grafanaPluginInit.image.registry`                    | Grafana Plugin Init image registry                                                                   | `quay.io`                                               |
| `grafanaPluginInit.image.repository`                  | Grafana Plugin Init image name                                                                       | `integreatly/grafana_plugins_init`                      |
| `grafanaPluginInit.image.tag`                         | Grafana Plugin Init image tag                                                                        | `{TAG_NAME}`                                            |
| `resources.limits`                                    | Specify resource limits which the container is not allowed to succeed.                               | `{}` (does not add resource limits to deployed pods)    |
| `resources.requests`                                  | Specify resource requests which the container needs to spawn.                                        | `{}` (does not add resource limits to deployed pods)    |
| `nodeSelector`                                        | Node labels for controller pod assignment                                                            | `{}`                                                    |
| `tolerations`                                         | Tolerations for controller pod assignment                                                            | `[]`                                                    |
| `affinity`                                            | Affinity for controller pod assignment                                                               | `{}`                                                    |
| `podAnnotations`                                      | Pod annotations                                                                                      | `{}`                                                    |
| `podLabels`                                           | Pod labels                                                                                           | `{}`                                                    |
| `commonAnnotations`                                   | Common Annotations which are applied to every ressource deployed                                     | `{}`                                                    |
| `commonLabels`                                        | Common Labels which are applied to every ressource deployed                                          | `{}`                                                    |
| `serviceAccount.create`                               | create a serviceAccount for the deployment                                                           | `true`                                                  |
| `serviceAccount.name`                                 | use the serviceAccount with the specified name                                                       | ``                                                      |
| `podSecurityContext.enabled`                          | Enable pods  security context                                                                        | `true`                                                  |
| `podSecurityContext.runAsNonRoot`                     | Grafana-Operator must runs as nonRoot.                                                               | `true`                                                  |
| `podSecurityContext.runAsUser`                        | User ID for the pods.                                                                                | `1001`                                                  |
| `podSecurityContext.runAsGroup`                       | User ID for the pods.                                                                                | `1001`                                                  |
| `podSecurityContext.fsGroup`                          | Group ID for the pods.                                                                               | `1001`                                                  |
| `podSecurityContext.supplementalGroups`               | Drop capabilities for the securityContext                                                            | `[]`                                                    |
| `speaker.extraEnvVars`                                | Extra environment variable to pass to the running container.                                         | `[]`                                                    |
| `nameOverride`                                        | String to partially override common.names.name template with a string                                | `nil`                                                   |
| `fullnameOverride`                                    | String to fully override ommon.names.fullname template with a string                                     | `nil`                                                   |
| `livenessProbe.enabled`                               | Enable/disable the Liveness probe                                                                    | `true`                                                  |
| `livenessProbe.initialDelaySeconds`                   | Delay before liveness probe is initiated                                                             | `3`                                                     |
| `livenessProbe.periodSeconds`                         | How often to perform the probe                                                                       | `10`                                                    |
| `livenessProbe.timeoutSeconds`                        | When the probe times out                                                                             | `10`                                                    |
| `livenessProbe.successThreshold`                      | Minimum consecutive successes for the probe to be considered successful after having failed.         | `1`                                                     |
| `livenessProbe.failureThreshold`                      | Minimum consecutive failures for the probe to be considered failed after having succeeded.           | `1`                                                     |
| `readinessProbe.enabled`                              | Enable/disable the Liveness probe                                                                    | `true`                                                  |
| `readinessProbe.initialDelaySeconds`                  | Delay before liveness probe is initiated                                                             | `3`                                                     |
| `readinessProbe.periodSeconds`                        | How often to perform the probe                                                                       | `10`                                                    |
| `readinessProbe.timeoutSeconds`                       | When the probe times out                                                                             | `10`                                                    |
| `readinessProbe.successThreshold`                     | Minimum consecutive successes for the probe to be considered successful after having failed.         | `1`                                                     |
| `readinessProbe.failureThreshold`                     | Minimum consecutive failures for the probe to be considered failed after having succeeded.           | `1`                                                     |
| `rbac.create`                                         | Specify if an rbac authorization should be created with the necessarry Rolebindings.                 | `true`                                                  |
| `prometheus.serviceMonitor.enabled`                   | Specify if a servicemonitor will be deployed for prometheus-operator.                                | `true`                                                  |
| `prometheus.serviceMonitor.jobLabel`                  | Specify the jobLabel to use for the prometheus-operator                                              | `app.kubernetes.io/name`                                |
| `prometheus.serviceMonitor.interval`                  | Specify the scrape interval if not specified use defaul prometheus scrapeIntervall                   | `""`                                                    |
| `prometheus.serviceMonitor.metricRelabelings`         | Specify additional relabeling of metrics.                                                            | `[]`                                                    |
| `prometheus.serviceMonitor.relabelings`               | Specify general relabeling.                                                                          | `[]`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set livenessProbe.successThreshold=5 \
    bitnami/grafana-operator
```
The above command sets the `livenessProbe.successThreshold` to `5`.

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

To configure [MetalLB](https://metallb.universe.tf) please look into the configuration section [MetalLB Configuration](https://metallb.universe.tf/configuration/).

### Documentation for the Configuration of Dashboards

After the installation you can create your Dashboards under a CRD of your kubernetes cluster.

For more details regarding what is possible with those CRDs please have a look at [Working with Dashboards](https://github.com/integr8ly/grafana-operator/blob/master/documentation/dashboards.md)

