# kube-state-metrics

[kube-state-metrics](https://github.com/kubernetes/kube-state-metrics) is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects.

## TL;DR;

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kube-state-metrics
```

## Introduction

This chart bootstraps [kube-state-metrics](https://github.com/bitnami/bitnami-docker-kube-state-metrics) on [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0+

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

The following table lists the configurable parameters of the kube-state-metrics chart and their default values.

| Parameter                                    | Description                                                                                                   | Default                                                    |
|----------------------------------------------|---------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| `global.imageRegistry`                       | Global Docker image registry                                                                                  | `nil`                                                      |
| `global.imagePullSecrets`                    | Global Docker registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods)    |
| `global.storageClass`                        | Global storage class for dynamic provisioning                                                                 | `nil`                                                      |
| `global.labels`                              | Additional labels to apply to all resources                                                                   | `{}`                                                       |
| `nameOverride`                               | String to partially override `kube-state-metrics.name` template with a string (will prepend the release name) | `nil`                                                      |
| `fullnameOverride`                           | String to fully override `kube-state-metrics.fullname` template with a string                                 | `nil`                                                      |
| `rbac.create`                                | Whether to create & use RBAC resources or not                                                                 | `true`                                                     |
| `rbac.apiVersion`                            | Version of the RBAC API                                                                                       | `v1beta1`                                                  |
| `rbac.pspEnabled`                            | PodSecurityPolicy                                                                                             | `true`                                                     |
| `serviceAccount.create`                      | Specify whether to create a ServiceAccount for kube-state-metrics                                             | `true`                                                     |
| `serviceAccount.name`                        | The name of the ServiceAccount to create                                                                      | Generated using the `kube-state-metrics.fullname` template |
| `image.registry`                             | kube-state-metrics image registry                                                                             | `docker.io`                                                |
| `image.repository`                           | kube-state-metrics Image name                                                                                 | `bitnami/kube-state-metrics`                               |
| `image.tag`                                  | kube-state-metrics Image tag                                                                                  | `{TAG_NAME}`                                               |
| `image.pullPolicy`                           | kube-state-metrics image pull policy                                                                          | `IfNotPresent`                                             |
| `image.pullSecrets`                          | Specify docker-registry secret names as an array                                                              | `[]` (does not add image pull secrets to deployed pods)    |
| `extraArgs`                                  | Additional command line arguments to pass to kube-state-metrics                                               | `{}`                                                       |
| `namespace`                                  | Comma-separated list of namespaces to be enabled. Defaults to all namespaces                                  | ``                                                         |
| `collectors.certificatesigningrequests`      | Enable the `certificatesigningrequests` collector                                                             | `true`                                                     |
| `collectors.configmaps`                      | Enable the `configmaps` collector                                                                             | `true`                                                     |
| `collectors.cronjobs`                        | Enable the `cronjobs` collector                                                                               | `true`                                                     |
| `collectors.daemonsets`                      | Enable the `daemonsets` collector                                                                             | `true`                                                     |
| `collectors.deployments`                     | Enable the `deployments` collector                                                                            | `true`                                                     |
| `collectors.endpoints`                       | Enable the `endpoints` collector                                                                              | `true`                                                     |
| `collectors.horizontalpodautoscalers`        | Enable the `horizontalpodautoscalers` collector                                                               | `true`                                                     |
| `collectors.ingresses`                       | Enable the `ingresses` collector                                                                              | `true`                                                     |
| `collectors.jobs`                            | Enable the `jobs` collector                                                                                   | `true`                                                     |
| `collectors.limitranges`                     | Enable the `limitranges` collector                                                                            | `true`                                                     |
| `collectors.mutatingwebhookconfigurations`   | Enable the `mutatingwebhookconfigurations` collector                                                          | `true`                                                     |
| `collectors.namespaces`                      | Enable the `namespaces` collector                                                                             | `true`                                                     |
| `collectors.networkpolicies`                 | Enable the `networkpolicies` collector                                                                        | `true`                                                     |
| `collectors.nodes`                           | Enable the `nodes` collector                                                                                  | `true`                                                     |
| `collectors.persistentvolumeclaims`          | Enable the `persistentvolumeclaims` collector                                                                 | `true`                                                     |
| `collectors.persistentvolumes`               | Enable the `persistentvolumes` collector                                                                      | `true`                                                     |
| `collectors.poddisruptionbudgets`            | Enable the `poddisruptionbudgets` collector                                                                   | `true`                                                     |
| `collectors.pods`                            | Enable the `pods` collector                                                                                   | `true`                                                     |
| `collectors.replicasets`                     | Enable the `replicasets` collector                                                                            | `true`                                                     |
| `collectors.replicationcontrollers`          | Enable the `replicationcontrollers` collector                                                                 | `true`                                                     |
| `collectors.resourcequotas`                  | Enable the `resourcequotas` collector                                                                         | `true`                                                     |
| `collectors.secrets`                         | Enable the `secrets` collector                                                                                | `true`                                                     |
| `collectors.services`                        | Enable the `services` collector                                                                               | `true`                                                     |
| `collectors.statefulsets`                    | Enable the `statefulsets` collector                                                                           | `true`                                                     |
| `collectors.storageclasses`                  | Enable the `storageclasses` collector                                                                         | `true`                                                     |
| `collectors.verticalpodautoscalers`          | Enable the `verticalpodautoscalers` collector                                                                 | `false`                                                    |
| `collectors.validatingwebhookconfigurations` | Enable the `validatingwebhookconfigurations` collector                                                        | `false`                                                    |
| `collectors.volumeattachments`               | Enable the `volumeattachments` collector                                                                      | `true`                                                     |
| `securityContext.enabled`                    | Enable security context                                                                                       | `true`                                                     |
| `securityContext.runAsUser`                  | User ID for the container                                                                                     | `1001`                                                     |
| `securityContext.fsGroup`                    | Group ID for the container filesystem                                                                         | `1001`                                                     |
| `service.type`                               | Kubernetes service type                                                                                       | `ClusterIP`                                                |
| `service.port`                               | kube-state-metrics service port                                                                               | `8080`                                                     |
| `service.clusterIP`                          | Specific cluster IP when service type is cluster IP. Use `None` for headless service                          | `nil`                                                      |
| `service.nodePort`                           | Kubernetes Service nodePort                                                                                   | `nil`                                                      |
| `service.loadBalancerIP`                     | `loadBalancerIP` if service type is `LoadBalancer`                                                            | `nil`                                                      |
| `service.loadBalancerSourceRanges`           | Address that are allowed when svc is `LoadBalancer`                                                           | `[]`                                                       |
| `service.annotations`                        | Additional annotations for kube-state-metrics service                                                         | `{}`                                                       |
| `service.labels`                             | Additional labels for kube-state-metrics service                                                              | `{}`                                                       |
| `hostNetwork`                                | Expose the service to the host network                                                                        | `true`                                                     |
| `priorityClassName`                          | Priority class assigned to the Pods                                                                           | `nil`                                                      |
| `resources`                                  | Resource requests/limit                                                                                       | `{}`                                                       |
| `replicaCount`                               | Desired number of controller pods                                                                             | `1`                                                        |
| `podLabels`                                  | Pod labels                                                                                                    | `{}`                                                       |
| `podAnnotations`                             | Pod annotations                                                                                               | `{}`                                                       |
| `updateStrategy`                             | Allows setting of `RollingUpdate` strategy                                                                    | `{}`                                                       |
| `minReadySeconds`                            | How many seconds a pod needs to be ready before killing the next, during update                               | `0`                                                        |
| `affinity`                                   | Map of node/pod affinities                                                                                    | `{} (The value is evaluated as a template)`                |
| `nodeSelector`                               | Node labels for pod assignment (this value is evaluated as a template)                                        | `{} (The value is evaluated as a template)`                |
| `tolerations`                                | List of node taints to tolerate (this value is evaluated as a template)                                       | `[] (The value is evaluated as a template)`                |
| `livenessProbe.enabled`                      | Turn on and off liveness probe                                                                                | `true`                                                     |
| `livenessProbe.initialDelaySeconds`          | Delay before liveness probe is initiated                                                                      | `120`                                                      |
| `livenessProbe.periodSeconds`                | How often to perform the probe                                                                                | `10`                                                       |
| `livenessProbe.timeoutSeconds`               | When the probe times out                                                                                      | `5`                                                        |
| `livenessProbe.failureThreshold`             | Minimum consecutive failures for the probe                                                                    | `6`                                                        |
| `livenessProbe.successThreshold`             | Minimum consecutive successes for the probe                                                                   | `1`                                                        |
| `readinessProbe.enabled`                     | Turn on and off readiness probe                                                                               | `true`                                                     |
| `readinessProbe.initialDelaySeconds`         | Delay before readiness probe is initiated                                                                     | `30`                                                       |
| `readinessProbe.periodSeconds`               | How often to perform the probe                                                                                | `10`                                                       |
| `readinessProbe.timeoutSeconds`              | When the probe times out                                                                                      | `5`                                                        |
| `readinessProbe.failureThreshold`            | Minimum consecutive failures for the probe                                                                    | `6`                                                        |
| `readinessProbe.successThreshold`            | Minimum consecutive successes for the probe                                                                   | `1`                                                        |
| `serviceMonitor.enabled`                     | Creates a ServiceMonitor to monitor kube-state-metrics                                                        | `false`                                                    |
| `serviceMonitor.namespace`                   | Namespace in which Prometheus is running                                                                      | `nil`                                                      |
| `serviceMonitor.interval`                    | Scrape interval (use by default, falling back to Prometheus' default)                                         | `nil`                                                      |
| `serviceMonitor.jobLabel`                    | The name of the label on the target service to use as the job name in prometheus.                             | `nil`                                                      |
| `serviceMonitor.selector`                    | ServiceMonitor selector labels                                                                                | `[]`                                                       |
| `serviceMonitor.honorLabels`                 | Honor metrics labels                                                                                          | `false`                                                    |
| `serviceMonitor.relabelings`                 | ServiceMonitor relabelings                                                                                    | `[]`                                                       |
| `serviceMonitor.metricRelabelings`           | ServiceMonitor metricRelabelings                                                                              | `[]`                                                       |

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

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Increase the number of kube-state-metrics Pod replicas:

```diff
-   replicaCount: 1
+   replicaCount: 2
```

## Upgrading

```bash
$ helm upgrade my-release bitnami/kube-state-metrics
```
