# kube-prometheus

[kube-prometheus](https://github.com/prometheus-operator/kube-prometheus) collects Kubernetes manifests to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/kube-prometheus
```

## Introduction

This chart bootstraps [Prometheus Operator](https://github.com/bitnami/bitnami-docker-prometheus-operator) on [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh) package manager.

In the default configuration the chart deploys the following components on the Kubernetes cluster:

- [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)
- [Prometheus](https://github.com/prometheus/prometheus/)
- [Alertmanager](https://github.com/prometheus/alertmanager)

**IMPORTANT**

Only one instance of the Prometheus Operator component should be running in the cluster. If you wish to deploy this chart to **manage multiple instances** of Prometheus in your Kubernetes cluster, you **have to disable** the installation of the Prometheus Operator component using the `operator.enabled=false` chart installation argument.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.1.0

## Installing the Chart

Add the `bitnami` charts repo to Helm:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/kube-prometheus
```

The command deploys kube-prometheus on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the flag `--purge` to delete all history too.

## Parameters

The following table lists the configurable parameters of the kube-prometheus chart and their default values.

### Global Parameters

| Parameter                 | Description                                                                                                | Default                                                 |
|---------------------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                                                                               | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array                                                            | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning                                                              | `nil`                                                   |
| `global.labels`           | Additional labels to apply to all resource                                                                 | `{}`                                                    |
| `nameOverride`            | String to partially override `kube-prometheus.name` template with a string (will prepend the release name) | `nil`                                                   |
| `fullnameOverride`        | String to fully override `kube-prometheus.fullname` template with a string                                 | `nil`                                                   |
| `rbac.create`             | Whether to create & use RBAC resources or not                                                              | `true`                                                  |
| `rbac.apiVersion`         | Version of the RBAC API                                                                                    | `v1beta1`                                               |
| `rbac.pspEnabled`         | PodSecurityPolicy                                                                                          | `true`                                                  |

### Prometheus Operator Parameters

| Parameter                                             | Description                                                                                                   | Default                                                          |
|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| `operator.enabled`                                    | Deploy Prometheus Operator to the cluster                                                                     | `true`                                                           |
| `operator.image.registry`                             | Prometheus Operator image registry                                                                            | `docker.io`                                                      |
| `operator.image.repository`                           | Prometheus Operator Image name                                                                                | `bitnami/prometheus-operator`                                    |
| `operator.image.tag`                                  | Prometheus Operator Image tag                                                                                 | `{TAG_NAME}`                                                     |
| `operator.image.pullPolicy`                           | Prometheus Operator image pull policy                                                                         | `IfNotPresent`                                                   |
| `operator.image.pullSecrets`                          | Specify docker-registry secret names as an array                                                              | `[]` (does not add image pull secrets to deployed pods)          |
| `operator.hostAliases`                                | Add deployment host aliases                                                                                   | `[]`                                                             |
| `operator.serviceAccount.create`                      | Specify whether to create a ServiceAccount for Prometheus Operator                                            | `true`                                                           |
| `operator.serviceAccount.name`                        | The name of the ServiceAccount to create                                                                      | Generated using the `kube-prometheus.operator.fullname` template |
| `operator.schedulerName`                              | Name of the k8s scheduler (other than default)                                                                | `nil`                                                            |
| `operator.securityContext.enabled`                    | Enable security context                                                                                       | `true`                                                           |
| `operator.securityContext.fsGroup`                    | Group ID for the container filesystem                                                                         | `1001`                                                           |
| `operator.securityContext.runAsUser`                  | User ID for the container                                                                                     | `1001`                                                           |
| `operator.service.type`                               | Kubernetes service type                                                                                       | `ClusterIP`                                                      |
| `operator.service.port`                               | Prometheus Operator service port                                                                              | `8080`                                                           |
| `operator.service.clusterIP`                          | Specific cluster IP when service type is cluster IP. Use `None` for headless service                          | `nil`                                                            |
| `operator.service.nodePort`                           | Kubernetes Service nodePort                                                                                   | `nil`                                                            |
| `operator.service.loadBalancerIP`                     | `loadBalancerIP` if service type is `LoadBalancer`                                                            | `nil`                                                            |
| `operator.service.loadBalancerSourceRanges`           | Address that are allowed when svc is `LoadBalancer`                                                           | `[]`                                                             |
| `operator.service.externalTrafficPolicy`              | Enable client source IP preservation                                                                          | `Cluster`                                                        |
| `operator.service.healthCheckNodePort`                | Specifies the health check node port                                                                          | `nil`                                                            |
| `operator.service.annotations`                        | Additional annotations for Prometheus Operator service                                                        | `{}`                                                             |
| `operator.serviceMonitor.enabled`                     | Creates a ServiceMonitor to monitor Prometheus Operator                                                       | `true`                                                           |
| `operator.serviceMonitor.interval`                    | Scrape interval (use by default, falling back to Prometheus' default)                                         | `nil`                                                            |
| `operator.serviceMonitor.metricRelabelings`           | Metric relabeling                                                                                             | `[]`                                                             |
| `operator.serviceMonitor.relabelings`                 | Relabel configs                                                                                               | `[]`                                                             |
| `operator.resources`                                  | CPU/Memory resource requests/limits for node                                                                  | `{}`                                                             |
| `operator.podAnnotations`                             | Pod annotations                                                                                               | `{}`                                                             |
| `operator.podAffinityPreset`                          | Prometheus Operator Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                             |
| `operator.podAntiAffinityPreset`                      | Prometheus Operator Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                                           |
| `operator.nodeAffinityPreset.type`                    | Prometheus Operator Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                                             |
| `operator.nodeAffinityPreset.key`                     | Prometheus Operator Node label key to match Ignored if `affinity` is set.                                     | `""`                                                             |
| `operator.nodeAffinityPreset.values`                  | Prometheus Operator Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                                             |
| `operator.affinity`                                   | Prometheus Operator Affinity for pod assignment                                                               | `{}` (evaluated as a template)                                   |
| `operator.nodeSelector`                               | Prometheus Operator Node labels for pod assignment                                                            | `{}` (evaluated as a template)                                   |
| `operator.tolerations`                                | Prometheus Operator Tolerations for pod assignment                                                            | `[]` (evaluated as a template)                                   |
| `operator.priorityClassName`                          | Priority class assigned to the Pods                                                                           | `nil`                                                            |
| `operator.livenessProbe.enabled`                      | Turn on and off liveness probe                                                                                | `true`                                                           |
| `operator.livenessProbe.initialDelaySeconds`          | Delay before liveness probe is initiated                                                                      | `120`                                                            |
| `operator.livenessProbe.periodSeconds`                | How often to perform the probe                                                                                | `10`                                                             |
| `operator.livenessProbe.timeoutSeconds`               | When the probe times out                                                                                      | `5`                                                              |
| `operator.livenessProbe.failureThreshold`             | Minimum consecutive failures for the probe                                                                    | `6`                                                              |
| `operator.livenessProbe.successThreshold`             | Minimum consecutive successes for the probe                                                                   | `1`                                                              |
| `operator.readinessProbe.enabled`                     | Turn on and off readiness probe                                                                               | `true`                                                           |
| `operator.readinessProbe.initialDelaySeconds`         | Delay before readiness probe is initiated                                                                     | `30`                                                             |
| `operator.readinessProbe.periodSeconds`               | How often to perform the probe                                                                                | `10`                                                             |
| `operator.readinessProbe.timeoutSeconds`              | When the probe times out                                                                                      | `5`                                                              |
| `operator.readinessProbe.failureThreshold`            | Minimum consecutive failures for the probe                                                                    | `6`                                                              |
| `operator.readinessProbe.successThreshold`            | Minimum consecutive successes for the probe                                                                   | `1`                                                              |
| `operator.logLevel`                                   | Log Level                                                                                                     | `info`                                                           |
| `operator.logFormat`                                  | Log Format                                                                                                    | `logfmt`                                                         |
| `operator.kubeletService.enabled`                     | Whether to maintain a service for scraping kubelets                                                           | `true`                                                           |
| `operator.configReloaderCpu`                          | Set the prometheus config reloader side-car CPU limit. If unset, uses the kube-prometheus project default     | `nil`                                                            |
| `operator.configReloaderMemory`                       | Set the prometheus config reloader side-car memory limit. If unset, uses the kube-prometheus project default  | `nil`                                                            |
| `operator.kubeletService.namespace`                   | Namespace to deploy the kubelet service                                                                       | `kube-system`                                                    |
| `operator.prometheusConfigReloader.image.registry`    | Prometheus Config Reloader image registry                                                                     | same as `operator.image.registry`                                |
| `operator.prometheusConfigReloader.image.repository`  | Prometheus Config Reloader Image name                                                                         | same as `operator.image.repository`                              |
| `operator.prometheusConfigReloader.image.tag`         | Prometheus Config Reloader Image tag                                                                          | same as `operator.image.tag`                                     |
| `operator.prometheusConfigReloader.image.pullPolicy`  | Prometheus Config Reloader image pull policy                                                                  | `IfNotPresent`                                                   |
| `operator.prometheusConfigReloader.image.pullSecrets` | Specify docker-registry secret names as an array                                                              | `[]` (does not add image pull secrets to deployed pods)          |

### Prometheus Parameters

| Parameter                                                  | Description                                                                                             | Default                                                                                                                                 |
|------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `prometheus.enabled`                                       | Deploy Prometheus to the cluster                                                                        | `true`                                                                                                                                  |
| `prometheus.image.registry`                                | Prometheus image registry                                                                               | `docker.io`                                                                                                                             |
| `prometheus.image.repository`                              | Prometheus Image name                                                                                   | `bitnami/prometheus`                                                                                                                    |
| `prometheus.image.tag`                                     | Prometheus Image tag                                                                                    | `{TAG_NAME}`                                                                                                                            |
| `prometheus.image.pullSecrets`                             | Specify docker-registry secret names as an array                                                        | `[]` (does not add image pull secrets to deployed pods)                                                                                 |
| `prometheus.serviceAccount.create`                         | Specify whether to create a ServiceAccount for Prometheus                                               | `true`                                                                                                                                  |
| `prometheus.serviceAccount.name`                           | The name of the ServiceAccount to create                                                                | Generated using the `kube-prometheus.prometheus.fullname` template                                                                      |
| `prometheus.serviceAccount.annotations`                    | Additional annotations for created Prometheus ServiceAccount                                            | `nil`                                                                                                                                   |
| `prometheus.securityContext.enabled`                       | Enable security context                                                                                 | `true`                                                                                                                                  |
| `prometheus.securityContext.fsGroup`                       | Group ID for the container filesystem                                                                   | `1001`                                                                                                                                  |
| `prometheus.securityContext.runAsUser`                     | User ID for the container                                                                               | `1001`                                                                                                                                  |
| `prometheus.podDisruptionBudget.enabled`                   | Create a pod disruption budget for Prometheus                                                           | `true`                                                                                                                                  |
| `prometheus.podDisruptionBudget.minAvailable`              | Minimum number / percentage of pods that should remain scheduled                                        | `1`                                                                                                                                     |
| `prometheus.podDisruptionBudget.maxUnavailable`            | Maximum number / percentage of pods that may be made unavailable                                        | `nil`                                                                                                                                   |
| `prometheus.service.type`                                  | Kubernetes service type                                                                                 | `ClusterIP`                                                                                                                             |
| `prometheus.service.port`                                  | Prometheus service port                                                                                 | `9090`                                                                                                                                  |
| `prometheus.service.clusterIP`                             | Specific cluster IP when service type is cluster IP. Use `None` for headless service                    | `nil`                                                                                                                                   |
| `prometheus.service.nodePort`                              | Kubernetes Service nodePort                                                                             | `nil`                                                                                                                                   |
| `prometheus.service.loadBalancerIP`                        | `loadBalancerIP` if service type is `LoadBalancer`                                                      | `nil`                                                                                                                                   |
| `prometheus.service.loadBalancerSourceRanges`              | Address that are allowed when svc is `LoadBalancer`                                                     | `[]`                                                                                                                                    |
| `prometheus.service.externalTrafficPolicy`                 | Enable client source IP preservation                                                                    | `Cluster`                                                                                                                               |
| `prometheus.service.healthCheckNodePort`                   | Specifies the health check node port                                                                    | `nil`                                                                                                                                   |
| `prometheus.service.annotations`                           | Additional annotations for Prometheus service  (this value is evaluated as a template)                  | `{}`                                                                                                                                    |
| `prometheus.stickySessions`                                | If `true` set Service `sessionAffinity: ClientIP`                                                       | `false`                                                                                                                                 |
| `prometheus.serviceMonitor.enabled`                        | Creates a ServiceMonitor to monitor Prometheus itself                                                   | `true`                                                                                                                                  |
| `prometheus.serviceMonitor.interval`                       | Scrape interval (use by default, falling back to Prometheus' default)                                   | `nil`                                                                                                                                   |
| `prometheus.serviceMonitor.metricRelabelings`              | Metric relabeling                                                                                       | `[]`                                                                                                                                    |
| `prometheus.serviceMonitor.relabelings`                    | Relabel configs                                                                                         | `[]`                                                                                                                                    |
| `prometheus.ingress.enabled`                               | Enable ingress controller resource                                                                      | `false`                                                                                                                                 |
| `prometheus.ingress.certManager`                           | Add annotations for cert-manager                                                                        | `false`                                                                                                                                 |
| `prometheus.ingress.hostname`                              | Default host for the ingress resource                                                                   | `prometheus.local`                                                                                                                      |
| `prometheus.ingress.path`                                  | Default path for the ingress resource                                                                   | `/`                                                                                                                                     |
| `prometheus.ingress.tls`                                   | Create TLS Secret                                                                                       | `false`                                                                                                                                 |
| `prometheus.ingress.annotations`                           | Ingress annotations                                                                                     | `[]`                                                                                                                                    |
| `prometheus.ingress.extraHosts[0].name`                    | Additional hostnames to be covered                                                                      | `nil`                                                                                                                                   |
| `prometheus.ingress.extraHosts[0].path`                    | Additional hostnames to be covered                                                                      | `nil`                                                                                                                                   |
| `prometheus.ingress.extraPaths`                            | Additional arbitrary path/backend objects                                                               | `nil`                                                                                                                                   |
| `prometheus.ingress.extraTls[0].hosts[0]`                  | TLS configuration for additional hostnames to be covered                                                | `nil`                                                                                                                                   |
| `prometheus.ingress.extraTls[0].secretName`                | TLS configuration for additional hostnames to be covered                                                | `nil`                                                                                                                                   |
| `prometheus.ingress.secrets[0].name`                       | TLS Secret Name                                                                                         | `nil`                                                                                                                                   |
| `prometheus.ingress.secrets[0].certificate`                | TLS Secret Certificate                                                                                  | `nil`                                                                                                                                   |
| `prometheus.ingress.secrets[0].key`                        | TLS Secret Key                                                                                          | `nil`                                                                                                                                   |
| `prometheus.externalUrl`                                   | External URL used to access Prometheus                                                                  | Generated from `prometheus.ingress` or Service data                                                                                     |
| `prometheus.resources`                                     | CPU/Memory resource requests/limits for node                                                            | `{}`                                                                                                                                    |
| `prometheus.podAffinityPreset`                             | Prometheus Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`          | `""`                                                                                                                                    |
| `prometheus.podAntiAffinityPreset`                         | Prometheus Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`     | `soft`                                                                                                                                  |
| `prometheus.nodeAffinityPreset.type`                       | Prometheus Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`    | `""`                                                                                                                                    |
| `prometheus.nodeAffinityPreset.key`                        | Prometheus Node label key to match Ignored if `affinity` is set.                                        | `""`                                                                                                                                    |
| `prometheus.nodeAffinityPreset.values`                     | Prometheus Node label values to match. Ignored if `affinity` is set.                                    | `[]`                                                                                                                                    |
| `prometheus.affinity`                                      | Prometheus Affinity for pod assignment                                                                  | `{}` (evaluated as a template)                                                                                                          |
| `prometheus.nodeSelector`                                  | Prometheus Node labels for pod assignment                                                               | `{}` (evaluated as a template)                                                                                                          |
| `prometheus.tolerations`                                   | Prometheus Tolerations for pod assignment                                                               | `[]` (evaluated as a template)                                                                                                          |
| `prometheus.replicaCount`                                  | Number of Prometheus replicas desired                                                                   | `1`                                                                                                                                     |
| `prometheus.logLevel`                                      | Log level for Prometheus                                                                                | `info`                                                                                                                                  |
| `prometheus.logFormat`                                     | Log format for Prometheus                                                                               | `logfmt`                                                                                                                                |
| `prometheus.podMetadata`                                   | Standard object’s metadata                                                                              | `{}`                                                                                                                                    |
| `prometheus.scrapeInterval`                                | Interval between consecutive scrapes                                                                    | `nil`                                                                                                                                   |
| `prometheus.evaluationInterval`                            | Interval between consecutive evaluations                                                                | `nil`                                                                                                                                   |
| `prometheus.listenLocal`                                   | ListenLocal makes the Prometheus server listen on loopback                                              | `false`                                                                                                                                 |
| `prometheus.enableAdminAPI`                                | Enable Prometheus adminitrative API                                                                     | `false`                                                                                                                                 |
| `prometheus.alertingEndpoints`                             | Alertmanagers to which alerts will be sent                                                              | `[]`                                                                                                                                    |
| `prometheus.externalLabels`                                | External labels to add to any time series                                                               | `{}`                                                                                                                                    |
| `prometheus.replicaExternalLabelName`                      | Name of the external label used to denote replica name                                                  | `nil`                                                                                                                                   |
| `prometheus.replicaExternalLabelNameClear`                 | Clear external label used to denote replica name                                                        | `false`                                                                                                                                 |
| `prometheus.portName`                                      | Port name used for the pods and governing service. This defaults to web                                 | `web`                                                                                                                                   |
| `prometheus.routePrefix`                                   | Prefix used to register routes, overriding externalUrl route                                            | `/`                                                                                                                                     |
| `prometheus.prometheusExternalLabelName`                   | Name of the external label used to denote Prometheus instance name                                      | `nil`                                                                                                                                   |
| `prometheus.prometheusExternalLabelNameClear`              | Clear external label used to denote Prometheus instance name                                            | `false`                                                                                                                                 |
| `prometheus.secrets`                                       | Secrets that should be mounted into the Prometheus Pods                                                 | `[]`                                                                                                                                    |
| `prometheus.configMaps`                                    | ConfigMaps that should be mounted into the Prometheus Pods                                              | `[]`                                                                                                                                    |
| `prometheus.querySpec`                                     | The query command line flags when starting Prometheus                                                   | `{}`                                                                                                                                    |
| `prometheus.ruleNamespaceSelector`                         | Namespaces to be selected for PrometheusRules discovery                                                 | `{}`                                                                                                                                    |
| `prometheus.ruleSelector`                                  | PrometheusRules to be selected for target discovery                                                     | `{}`                                                                                                                                    |
| `prometheus.serviceMonitorSelector`                        | If {}, select all ServiceMonitors                                                                       | `{}`                                                                                                                                    |
| `prometheus.serviceMonitorNamespaceSelector`               | Namespaces to be selected for ServiceMonitor discovery                                                  | `{}`                                                                                                                                    |
| `prometheus.podMonitorSelector`                            | If {}, select all PodMonitors                                                                           | `{}`                                                                                                                                    |
| `prometheus.podMonitorNamespaceSelector`                   | Namespaces to be selected for PodMonitor discovery                                                      | `{}`                                                                                                                                    |
| `prometheus.probeSelector`                                 | If {}, select all Probes                                                                                | `{}`                                                                                                                                    |
| `prometheus.probeNamespaceSelector`                        | Namespaces to be selected for Probe discovery                                                           | `{}`                                                                                                                                    |
| `prometheus.retention`                                     | Metrics retention days                                                                                  | `10d`                                                                                                                                   |
| `prometheus.retentionSize`                                 | Maximum size of metrics                                                                                 | `nil`                                                                                                                                   |
| `prometheus.disableCompaction`                             | Disable the compaction of the Prometheus TSDB                                                           | `false`                                                                                                                                 |
| `prometheus.walCompression`                                | Enable compression of the write-ahead log using Snappy                                                  | `false`                                                                                                                                 |
| `prometheus.paused`                                        | If true, the Operator won't process any Prometheus configuration changes                                | `false`                                                                                                                                 |
| `prometheus.remoteRead`                                    | The remote_read spec configuration for Prometheus                                                       | `[]`                                                                                                                                    |
| `prometheus.remoteWrite`                                   | The remote_write spec configuration for Prometheus                                                      | `[]`                                                                                                                                    |
| `prometheus.storageSpec`                                   | Prometheus StorageSpec for persistent data                                                              | `{}`                                                                                                                                    |
| `prometheus.persistence.enabled`                           | Use PVCs to persist data. If the storageSpec is provided this will not take effect.                     | `false`                                                                                                                                 |
| `prometheus.persistence.storageClass`                      | Persistent Volume Storage Class                                                                         | `generic`                                                                                                                               |
| `prometheus.persistence.accessModes`                       | Persistent Volume Access Modes                                                                          | `[ReadWriteOnce]`                                                                                                                       |
| `prometheus.persistence.size`                              | Persistent Volume Size                                                                                  | `8Gi`                                                                                                                                   |
| `prometheus.priorityClassName`                             | Priority class assigned to the Pods                                                                     | ``                                                                                                                                      |
| `prometheus.containers`                                    | Containers allows injecting additional containers                                                       | `[]`                                                                                                                                    |
| `prometheus.volumes`                                       | Volumes allows configuration of additional volumes. Evaluated as a template                             | `[]` See [docs](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#prometheusspec) for details |
| `prometheus.volumeMounts`                                  | VolumeMounts allows configuration of additional VolumeMounts. Evaluated as a template                   | `[]` See [docs](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#prometheusspec) for details |
| `prometheus.additionalPrometheusRules`                     | PrometheusRule defines recording and alerting rules for a Prometheus instance.                          | `[]`                                                                                                                                    |
| `prometheus.additionalScrapeConfigs.enabled`               | Enable additional scrape configs                                                                        | `false` See [docs](#additional-scrape-configurations) for details.                                                                      |
| `prometheus.additionalScrapeConfigs.type`                  | Indicates if the cart should use external additional scrape configs or internal configs                 | `external` See [docs](#additional-scrape-configurations) for details.                                                                   |
| `prometheus.additionalScrapeConfigs.external.name`         | Name of the secret that Prometheus should use for the additional external scrape configuration          | `nil`                                                                                                                                   |
| `prometheus.additionalScrapeConfigs.external.key`          | Name of the key inside the secret to be used for the additional external scrape configuration           | `nil`                                                                                                                                   |
| `prometheus.additionalScrapeConfigs.internal.jobList`      | A list of Prometheus scrape jobs                                                                        | `[]` See [docs](#additional-scrape-configurations) for details.                                                                         |
| `prometheus.additionalScrapeConfigsExternal.enabled`       | (deprecated) Enable additional scrape configs that are managed externally to this chart                 | `false` See [docs](#additional-scrape-configurations) for details.                                                                      |
| `prometheus.additionalScrapeConfigsExternal.name`          | (deprecated) Name of the secret that Prometheus should use for the additional scrape configuration      | `nil`                                                                                                                                   |
| `prometheus.additionalScrapeConfigsExternal.key`           | (deprecated) Name of the key inside the secret to be used for the additional scrape configuration       | `nil`                                                                                                                                   |
| `prometheus.additionalAlertRelabelConfigsExternal.enabled` | Enable additional Prometheus alert relabel configs that are managed externally to this chart            | `false` See [docs](#additional-alert-relabel-configurations) for details.                                                               |
| `prometheus.additionalAlertRelabelConfigsExternal.name`    | Name of the secret that Prometheus should use for the additional Prometheus alert relabel configuration | `nil`                                                                                                                                   |
| `prometheus.additionalAlertRelabelConfigsExternal.key`     | Name of the key inside the secret to be used for the additional Prometheus alert relabel configuration  | `nil`                                                                                                                                   |
| `prometheus.thanos.create`                                 | Create a Thanos sidecar container                                                                       | `false`                                                                                                                                 |
| `prometheus.thanos.image.registry`                         | Thanos image registry                                                                                   | `docker.io`                                                                                                                             |
| `prometheus.thanos.image.repository`                       | Thanos image name                                                                                       | `bitnami/prometheus`                                                                                                                    |
| `prometheus.thanos.image.tag`                              | Thanos image tag                                                                                        | `{TAG_NAME}`                                                                                                                            |
| `prometheus.thanos.image.pullPolicy`                       | Thanos image pull policy                                                                                | `IfNotPresent`                                                                                                                          |
| `prometheus.thanos.image.pullSecrets`                      | Specify docker-registry secret names as an array                                                        | `[]` (does not add image pull secrets to deployed pods)                                                                                 |
| `prometheus.thanos.prometheusUrl`                          | Specify custom prometheus url                                                                           | `""`                                                                                                                                    |  
| `prometheus.thanos.extraArgs`                              | Additional arguments passed to the thanos sidecar container                                             | `[]`                                                                                                                                    |
| `prometheus.thanos.objectStorageConfig.secretName`         | Defines the secretName to load.                                                                         | `nil`                                                                                                                                   |
| `prometheus.thanos.objectStorageConfig.secretKey`          | Defines the key inside the secret which references the objectStorageConfig for the thanos sideCar       | `nil`                                                                                                                                   |
| `prometheus.thanos.service.port`                           | Thanos service port                                                                                     | `10901`                                                                                                                                 |
| `prometheus.thanos.service.clusterIP`                      | Specific cluster IP when service type is cluster IP. Use `None` to create headless service by default.  | `None`                                                                                                                                  |
| `prometheus.thanos.service.nodePort`                       | Kubernetes Service nodePort                                                                             | `nil`                                                                                                                                   |
| `prometheus.thanos.service.loadBalancerIP`                 | `loadBalancerIP` if service type is `LoadBalancer`                                                      | `nil`                                                                                                                                   |
| `prometheus.thanos.service.loadBalancerSourceRanges`       | Address that are allowed when svc is `LoadBalancer`                                                     | `[]`                                                                                                                                    |
| `prometheus.thanos.service.annotations`                    | Additional annotations for Prometheus service                                                           | `{}`                                                                                                                                    |
| `prometheus.thanos.service.extraPorts`                     | Additional ports to expose from the Thanos sidecar container                                            | `[]`                                                                                                                                    |
| `prometheus.thanos.resources.limits`                       | The resources limits for the Thanos sidecar container                                                   | `{}`                                                                                                                                    |
| `prometheus.thanos.resources.requests`                     | The resources requests for the Thanos sidecar container                                                 | `{}`                                                                                                                                    |
| `prometheus.thanos.ingress.enabled`                               | Enable ingress controller resource                                                                      | `false`                                                                                                                                 |
| `prometheus.thanos.ingress.certManager`                           | Add annotations for cert-manager                                                                        | `false`                                                                                                                                 |
| `prometheus.thanos.ingress.annotations`                           | Ingress annotations                                                                                     | `[]`                                                                                                                                    |
| `prometheus.thanos.ingress.hosts[0].name`                         | Hostname to your Prometheus installation                                                                | `thanos.prometheus.local`                                                                                                                      |
| `prometheus.thanos.ingress.hosts[0].path`                         | Path within the url structure                                                                           | `/`                                                                                                                                     |
| `prometheus.thanos.ingress.tls[0].hosts[0]`                       | TLS hosts                                                                                               | `thanos.prometheus.local`                                                                                                                      |
| `prometheus.thanos.ingress.tls[0].secretName`                     | TLS Secret (certificates)                                                                               | `prometheus.local-tls`                                                                                                                  |
| `prometheus.serviceMonitor.enabled`                        | Creates a ServiceMonitor to monitor Prometheus itself                                                   | `true`                                                                                                                                  |

### Alertmanager Parameters

| Parameter                                         | Description                                                                                                                    | Default                                                                                                                                                                                                                                             |
|---------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `alertmanager.enabled`                            | Deploy Alertmanager to the cluster                                                                                             | `true`                                                                                                                                                                                                                                              |
| `alertmanager.image.registry`                     | Prometheus image registry                                                                                                      | `docker.io`                                                                                                                                                                                                                                         |
| `alertmanager.image.repository`                   | Prometheus Image name                                                                                                          | `bitnami/alertmanager`                                                                                                                                                                                                                              |
| `alertmanager.image.tag`                          | Prometheus Image tag                                                                                                           | `{TAG_NAME}`                                                                                                                                                                                                                                        |
| `alertmanager.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                               | `[]` (does not add image pull secrets to deployed pods)                                                                                                                                                                                             |
| `alertmanager.serviceAccount.create`              | Specify whether to create a ServiceAccount for Alertmanager                                                                    | `true`                                                                                                                                                                                                                                              |
| `alertmanager.serviceAccount.name`                | The name of the ServiceAccount to create                                                                                       | Generated using the `kube-prometheus.alertmanager.fullname` template                                                                                                                                                                                |
| `alertmanager.serviceAccount.annotations`         | Additional annotations for created Alertmanager ServiceAccount                                                                 | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.securityContext.enabled`            | Enable security context                                                                                                        | `true`                                                                                                                                                                                                                                              |
| `alertmanager.securityContext.fsGroup`            | Group ID for the container filesystem                                                                                          | `1001`                                                                                                                                                                                                                                              |
| `alertmanager.securityContext.runAsUser`          | User ID for the container                                                                                                      | `1001`                                                                                                                                                                                                                                              |
| `alertmanager.podDisruptionBudget.enabled`        | Create a pod disruption budget for Alertmanager                                                                                | `true`                                                                                                                                                                                                                                              |
| `alertmanager.podDisruptionBudget.minAvailable`   | Minimum number / percentage of pods that should remain scheduled                                                               | `1`                                                                                                                                                                                                                                                 |
| `alertmanager.podDisruptionBudget.maxUnavailable` | Maximum number / percentage of pods that may be made unavailable                                                               | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.service.type`                       | Kubernetes service type                                                                                                        | `ClusterIP`                                                                                                                                                                                                                                         |
| `alertmanager.service.port`                       | Alertmanager service port                                                                                                      | `9093`                                                                                                                                                                                                                                              |
| `alertmanager.service.clusterIP`                  | Specific cluster IP when service type is cluster IP. Use `None` for headless service                                           | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.service.nodePort`                   | Kubernetes Service nodePort                                                                                                    | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.service.loadBalancerIP`             | `loadBalancerIP` if service type is `LoadBalancer`                                                                             | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.service.loadBalancerSourceRanges`   | Address that are allowed when svc is `LoadBalancer`                                                                            | `[]`                                                                                                                                                                                                                                                |
| `alertmanager.service.externalTrafficPolicy`      | Enable client source IP preservation                                                                                           | `Cluster`                                                                                                                                                                                                                                           |
| `alertmanager.service.healthCheckNodePort`        | Specifies the health check node port                                                                                           | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.service.annotations`                | Additional annotations for Alertmanager service (this value is evaluated as a template)                                        | `{}`                                                                                                                                                                                                                                                |
| `alertmanager.stickySessions`                     | If `true` set Service `sessionAffinity: ClientIP`                                                                              | `false`                                                                                                                                                                                                                                             |
| `alertmanager.serviceMonitor.enabled`             | Creates a ServiceMonitor to monitor Alertmanager                                                                               | `true`                                                                                                                                                                                                                                              |
| `alertmanager.serviceMonitor.interval`            | Scrape interval (use by default, falling back to Prometheus' default)                                                          | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.serviceMonitor.metricRelabelings`   | Metric relabeling                                                                                                              | `[]`                                                                                                                                                                                                                                                |
| `alertmanager.serviceMonitor.relabelings`         | Relabel configs                                                                                                                | `[]`                                                                                                                                                                                                                                                |
| `alertmanager.ingress.enabled`                    | Enable ingress controller resource                                                                                             | `false`                                                                                                                                                                                                                                             |
| `alertmanager.ingress.certManager`                | Add annotations for cert-manager                                                                                               | `false`                                                                                                                                                                                                                                             |
| `alertmanager.ingress.hostname`                   | Default host for the ingress resource                                                                                          | `alertmanager.local`                                                                                                                                                                                                                                |
| `alertmanager.ingress.path`                       | Default path for the ingress resource                                                                                          | `/`                                                                                                                                                                                                                                                 |
| `alertmanager.ingress.tls`                        | Create TLS Secret                                                                                                              | `false`                                                                                                                                                                                                                                             |
| `alertmanager.ingress.annotations`                | Ingress annotations                                                                                                            | `[]`                                                                                                                                                                                                                                                |
| `alertmanager.ingress.extraHosts[0].name`         | Additional hostnames to be covered                                                                                             | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.ingress.extraHosts[0].path`         | Additional hostnames to be covered                                                                                             | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.ingress.extraPaths`                 | Additional arbitrary path/backend objects                                                                                      | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.ingress.extraTls[0].hosts[0]`       | TLS configuration for additional hostnames to be covered                                                                       | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.ingress.extraTls[0].secretName`     | TLS configuration for additional hostnames to be covered                                                                       | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.ingress.secrets[0].name`            | TLS Secret Name                                                                                                                | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.ingress.secrets[0].certificate`     | TLS Secret Certificate                                                                                                         | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.ingress.secrets[0].key`             | TLS Secret Key                                                                                                                 | `nil`                                                                                                                                                                                                                                               |
| `alertmanager.externalUrl`                        | External URL used to access Alertmanager                                                                                       | Generated from `alertmanager.ingress` or Service data                                                                                                                                                                                               |
| `alertmanager.resources`                          | CPU/Memory resource requests/limits for node                                                                                   | `{}`                                                                                                                                                                                                                                                |
| `alertmanager.podAffinityPreset`                  | Alertmanager Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                               | `""`                                                                                                                                                                                                                                                |
| `alertmanager.podAntiAffinityPreset`              | Alertmanager Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                          | `soft`                                                                                                                                                                                                                                              |
| `alertmanager.nodeAffinityPreset.type`            | Alertmanager Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                         | `""`                                                                                                                                                                                                                                                |
| `alertmanager.nodeAffinityPreset.key`             | Alertmanager Node label key to match Ignored if `affinity` is set.                                                             | `""`                                                                                                                                                                                                                                                |
| `alertmanager.nodeAffinityPreset.values`          | Alertmanager Node label values to match. Ignored if `affinity` is set.                                                         | `[]`                                                                                                                                                                                                                                                |
| `alertmanager.affinity`                           | Alertmanager Affinity for pod assignment                                                                                       | `{}` (evaluated as a template)                                                                                                                                                                                                                      |
| `alertmanager.nodeSelector`                       | Alertmanager Node labels for pod assignment                                                                                    | `{}` (evaluated as a template)                                                                                                                                                                                                                      |
| `alertmanager.tolerations`                        | Alertmanager Tolerations for pod assignment                                                                                    | `[]` (evaluated as a template)                                                                                                                                                                                                                      |
| `alertmanager.config`                             | Alertmanager configuration directive                                                                                           | `{"global":{"resolve_timeout":"5m"},"route":{"group_by":["job"],"group_wait":"30s","group_interval":"5m","repeat_interval":"12h","receiver":"null","routes":[{"match":{"alertname":"Watchdog"},"receiver":"null"}]},"receivers":[{"name":"null"}]}` |
| `alertmanager.externalConfig`                     | Alertmanager configuration is created externally. If true, `alertmanager.config` is ignored, and a secret will not be created. | `false` See [docs](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/alerting.md) for details                                                                                                        |
| `alertmanager.replicaCount`                       | Number of Alertmanager replicas desired                                                                                        | `1`                                                                                                                                                                                                                                                 |
| `alertmanager.portName`                           | Port name used for the pods and governing service. This defaults to web                                                        | `web`                                                                                                                                                                                                                                               |
| `alertmanager.routePrefix`                        | Prefix used to register routes, overriding externalUrl route                                                                   | `/`                                                                                                                                                                                                                                                 |
| `alertmanager.logLevel`                           | Log level for Alertmanager                                                                                                     | `info`                                                                                                                                                                                                                                              |
| `alertmanager.logFormat`                          | Log format for Alertmanager                                                                                                    | `logfmt`                                                                                                                                                                                                                                            |
| `alertmanager.podMetadata`                        | Standard object’s metadata                                                                                                     | `{}`                                                                                                                                                                                                                                                |
| `alertmanager.secrets`                            | Secrets that should be mounted into the Alertmanager Pods                                                                      | `[]`                                                                                                                                                                                                                                                |
| `alertmanager.configMaps`                         | ConfigMaps that should be mounted into the Alertmanager Pods                                                                   | `[]`                                                                                                                                                                                                                                                |
| `alertmanager.retention`                          | Metrics retention days                                                                                                         | `10d`                                                                                                                                                                                                                                               |
| `alertmanager.storageSpec`                        | Alertmanager StorageSpec for persistent data                                                                                   | `{}`                                                                                                                                                                                                                                                |
| `alertmanager.persistence.enabled`                | Use PVCs to persist data. If the storageSpec is provided this will not take effect.                                            | `false`                                                                                                                                                                                                                                             |
| `alertmanager.persistence.storageClass`           | Persistent Volume Storage Class                                                                                                | `generic`                                                                                                                                                                                                                                           |
| `alertmanager.persistence.accessModes`            | Persistent Volume Access Modes                                                                                                 | `[ReadWriteOnce]`                                                                                                                                                                                                                                   |
| `alertmanager.persistence.size`                   | Persistent Volume Size                                                                                                         | `8Gi`                                                                                                                                                                                                                                               |
| `alertmanager.paused`                             | If true, the Operator won't process any Alertmanager configuration changes                                                     | `false`                                                                                                                                                                                                                                             |
| `alertmanager.listenLocal`                        | ListenLocal makes the Alertmanager server listen on loopback                                                                   | `false`                                                                                                                                                                                                                                             |
| `alertmanager.containers`                         | Containers allows injecting additional containers                                                                              | `[]`                                                                                                                                                                                                                                                |
| `prometheus.volumes`                              | Volumes allows configuration of additional volumes. Evaluated as a template                                                    | `[]` See [docs](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#alertmanagerspec) for details                                                                                                           |
| `prometheus.volumeMounts`                         | VolumeMounts allows configuration of additional VolumeMounts. Evaluated as a template                                          | `[]` See [docs](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#alertmanagerspec) for details                                                                                                           |
| `alertmanager.priorityClassName`                  | Priority class assigned to the Pods                                                                                            | ``                                                                                                                                                                                                                                                  |
| `alertmanager.additionalPeers`                    | AdditionalPeers allows injecting a set of additional Alertmanagers to peer with to form a highly available cluster             | `[]`                                                                                                                                                                                                                                                |
| `alertmanager.templateFiles`                      | Template files as `filename: template` for Alertmanager (will be mounted under `/etc/alertmanager/config`)                     | `{}`                                                                                                                                                                                                                                                |

### Exporters

| Parameter                                                 | Description                                                                                                                     | Default       |
|-----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|---------------|
| `exporters.enabled`                                       | Deploy exporters                                                                                                                | `true`        |
| `exporters.node-exporter.enabled`                         | Deploy `node-exporter`                                                                                                          | `true`        |
| `exporters.kube-state-metrics.enabled`                    | Deploy `kube-state-metrics`                                                                                                     | `true`        |
| `kubelet.namespace`                                       | Namespace where kubelet service is deployed. Related configuration `operator.kubeletService.namespace`                          | `kube-system` |
| `kubelet.enabled`                                         | Create a ServiceMonitor to scrape kubelet service                                                                               | `true`        |
| `kubelet.serviceMonitor.https`                            | Enable scraping of the kubelet over HTTPS                                                                                       | `true`        |
| `kubelet.serviceMonitor.interval`                         | Scrape interval (use by default, falling back to Prometheus' default)                                                           | `nil`         |
| `kubelet.serviceMonitor.metricRelabelings`                | Metric relabeling                                                                                                               | `[]`          |
| `kubelet.serviceMonitor.relabelings`                      | Relabel configs                                                                                                                 | `[]`          |
| `kubelet.serviceMonitor.cAdvisorMetricRelabelings`        | Metric relabeling for scraping cAdvisor                                                                                         | `[]`          |
| `kubelet.serviceMonitor.cAdvisorRelabelings`              | Relabel configs for scraping cAdvisor                                                                                           | `[]`          |
| `kubeApiServer.enabled`                                   | Create a ServiceMonitor to scrape kube-apiserver service                                                                        | `true`        |
| `kubeApiServer.serviceMonitor.interval`                   | Scrape interval (use by default, falling back to Prometheus' default)                                                           | `nil`         |
| `kubeApiServer.serviceMonitor.metricRelabelings`          | Metric relabeling                                                                                                               | `[]`          |
| `kubeApiServer.serviceMonitor.relabelings`                | Relabel configs                                                                                                                 | `[]`          |
| `kubeControllerManager.enabled`                           | Create a ServiceMonitor to scrape kube-controller-manager service                                                               | `true`        |
| `kubeControllerManager.endpoints`                         | If your kube controller manager is not deployed as a pod, specify IPs it can be found on                                        | `[]`          |
| `kubeControllerManager.namespace`                         | Namespace where kube-controller-manager service is deployed.                                                                    | `kube-system` |
| `kubeControllerManager.service.enabled`                   | Whether or not to create a Service object for kube-controller-manager                                                           | 'true'        |
| `kubeControllerManager.service.port`                      | Listening port of the kube-controller-manager Service object                                                                    | '10252'       |
| `kubeControllerManager.service.targetPort`                | Port to target on the kube-controller-manager Pods. This should be the port that kube-controller-manager is exposing metrics on | '10252'       |
| `kubeControllerManager.service.selector`                  | Optional PODs Label selector for the service                                                                                    | 'nil'         |
| `kubeControllerManager.serviceMonitor.interval`           | Scrape interval (use by default, falling back to Prometheus' default)                                                           | `nil`         |
| `kubeControllerManager.serviceMonitor.https`              | Enable scraping kube-controller-manager over https                                                                              | `false`       |
| `kubeControllerManager.serviceMonitor.insecureSkipVerify` | Skip TLS certificate validation when scraping                                                                                   | `nil`         |
| `kubeControllerManager.serviceMonitor.serverName`         | Name of the server to use when validating TLS certificate                                                                       | `nil`         |
| `kubeControllerManager.serviceMonitor.metricRelabelings`  | Metric relabeling                                                                                                               | `[]`          |
| `kubeControllerManager.serviceMonitor.relabelings`        | Relabel configs                                                                                                                 | `[]`          |
| `kubeScheduler.enabled`                                   | Create a ServiceMonitor to scrape kube-scheduler service                                                                        | `true`        |
| `kubeScheduler.endpoints`                                 | If your kube scheduler is not deployed as a pod, specify IPs it can be found on                                                 | `[]`          |
| `kubeScheduler.namespace`                                 | Namespace where kube-scheduler service is deployed.                                                                             | `kube-system` |
| `kubeScheduler.service.enabled`                           | Whether or not to create a Service object for kube-scheduler                                                                    | 'true'        |
| `kubeScheduler.service.port`                              | Listening port of the kube scheduler Service object                                                                             | '10251'       |
| `kubeScheduler.service.targetPort`                        | Port to target on the kube scheduler Pods. This should be the port that kube scheduler is exposing metrics on                   | '10251'       |
| `kubeScheduler.service.selector`                          | Optional PODs Label selector for the service                                                                                    | 'nil'         |
| `kubeScheduler.serviceMonitor.interval`                   | Scrape interval (use by default, falling back to Prometheus' default)                                                           | `nil`         |
| `kubeScheduler.serviceMonitor.https`                      | Enable scraping kube-scheduler over https                                                                                       | `false`       |
| `kubeScheduler.serviceMonitor.insecureSkipVerify`         | Skip TLS certificate validation when scraping                                                                                   | `nil`         |
| `kubeScheduler.serviceMonitor.serverName`                 | Name of the server to use when validating TLS certificate                                                                       | `nil`         |
| `kubeScheduler.serviceMonitor.metricRelabelings`          | Metric relabeling                                                                                                               | `[]`          |
| `kubeScheduler.serviceMonitor.relabelings`                | Relabel configs                                                                                                                 | `[]`          |
| `coreDns.enabled`                                         | Create a ServiceMonitor to scrape coredns service                                                                               | `true`        |
| `coreDns.namespace`                                       | Namespace where core dns service is deployed.                                                                                   | `kube-system` |
| `coreDns.service.enabled`                                 | Whether or not to create a Service object for coredns                                                                           | 'true'        |
| `coreDns.service.port`                                    | Listening port of the coredns Service object                                                                                    | '9153'        |
| `coreDns.service.targetPort`                              | Port to target on the coredns Pods. This should be the port that coredns is exposing metrics on                                 | '9153'        |
| `coreDns.service.selector`                                | Optional PODs Label selector for the service                                                                                    | 'nil'         |
| `coreDns.serviceMonitor.interval`                         | Scrape interval (use by default, falling back to Prometheus' default)                                                           | `nil`         |
| `coreDns.serviceMonitor.metricRelabelings`                | Metric relabeling                                                                                                               | `[]`          |
| `coreDns.serviceMonitor.relabelings`                      | Relabel configs                                                                                                                 | `[]`          |
| `kubeProxy.enabled`                                       | Create a ServiceMonitor to scrape the kube-proxy Service                                                                        | `true`        |
| `kubeProxy.endpoints`                                     | If your kube-proxy is not deployed as a pod, specify IPs it can be found on                                                     | `[]`          |
| `kubeProxy.namespace`                                     | Namespace where cube-proxy service is deployed.                                                                                 | `kube-system` |
| `kubeProxy.service.enabled`                               | Whether or not to create a Service object for kube-proxy                                                                        | `true`        |
| `kubeProxy.service.port`                                  | Listening port of the kube-proxy Service object                                                                                 | `10249`       |
| `kubeProxy.service.targetPort`                            | Port to target on the kube-proxy Pods. This should be the port that kube-proxy is listening on                                  | `10249`       |
| `kubeProxy.service.selector`                              | Service label selector to discover the kube-proxy Pods                                                                          | `{}`          |
| `kubeProxy.serviceMonitor.enabled`                        | Create a ServiceMonitor object                                                                                                  | `true`        |
| `kubeProxy.serviceMonitor.interval`                       | Scrape interval (use by default, falling back to Prometheus' default)                                                           | `""`          |
| `kubeProxy.serviceMonitor.metricRelabelings`              | Metric relabeling                                                                                                               | `[]`          |
| `kubeProxy.serviceMonitor.relabelings`                    | Relabel configs                                                                                                                 | `[]`          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set operator.logLevel=debug \
  --set prometheus.replicaCount=5 \
    bitnami/kube-prometheus
```

The above command sets the Prometheus Operator `logLevel` to `debug`. Additionally it sets the `prometheus.replicaCount` to `5`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/kube-prometheus
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Additional scrape configurations

The following values have been deprecated. See [Upgrading](#upgrading) below.

```console
prometheus.additionalScrapeConfigsExternal.enabled
prometheus.additionalScrapeConfigsExternal.name
prometheus.additionalScrapeConfigsExternal.key
```

It is possible to inject externally managed scrape configurations via a Secret by setting `prometheus.additionalScrapeConfigs.enabled` to `true` and `prometheus.additionalScrapeConfigs.type` to `external`. The secret must exist in the same namespace which the kube-prometheus will be deployed into. Set the secret name using the parameter `prometheus.additionalScrapeConfigs.external.name`, and the key containing the additional scrape configuration using the `prometheus.additionalScrapeConfigs.external.key`. For instance, if you created a secret named `kube-prometheus-prometheus-scrape-config` and it contains a file named `additional-scrape-configs.yaml`, use the parameters below:

```console
prometheus.additionalScrapeConfigs.enabled=true
prometheus.additionalScrapeConfigs.type=external
prometheus.additionalScrapeConfigs.external.name=kube-prometheus-prometheus-scrape-config
prometheus.additionalScrapeConfigs.external.key=additional-scrape-configs.yaml
```

It is also possible to define scrape configs to be managed by the Helm chart by setting `prometheus.additionalScrapeConfigs.enabled` to `true` and `prometheus.additionalScrapeConfigs.type` to `internal`. You can then use `prometheus.additionalScrapeConfigs.internal.jobList` to define a list of additional scrape jobs for Prometheus.

```console
prometheus.additionalScrapeConfigs.enabled=true
prometheus.additionalScrapeConfigs.type=internal
prometheus.additionalScrapeConfigs.internal.jobList=
      - job_name: 'opentelemetry-collector'
        # metrics_path defaults to '/metrics'
        # scheme defaults to 'http'.
        static_configs:
          - targets: ['opentelemetry-collector:8889']
```

For more information, see [Prometheus Operator - Additional scrape configuration documentation](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/additional-scrape-config.md).

### Additional alert relabel configurations

It is possible to inject externally managed Prometheus alert relabel configurations via a Secret by setting `prometheus.additionalAlertRelabelConfigsExternal.enabled` to `true`. The secret must exist in the same namespace which the kube-prometheus will be deployed into. Set the secret name using the parameter `prometheus.additionalAlertRelabelConfigsExternal.name`, and the key containing the additional alert relabel configuration using the `prometheus.additionalAlertRelabelConfigsExternal.key`. For instance, if you created a secret named `kube-prometheus-prometheus-alert-relabel-config` and it contains a file named `additional-alert-relabel-configs.yaml`, use the parameters below:

```console
prometheus.additionalAlertRelabelConfigsExternal.enabled=true
prometheus.additionalAlertRelabelConfigsExternal.name=kube-prometheus-prometheus-alert-relabel-config
prometheus.additionalAlertRelabelConfigsExternal.key=additional-alert-relabel-configs.yaml
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/kube-prometheus
```

### To 4.0.0

This version standardizes the way of defining Ingress rules.
When configuring a single hostname for the Prometheus Ingress rule, set the `prometheus.ingress.hostname` value. When defining more than one, set the `prometheus.ingress.extraHosts` array.
When configuring a single hostname for the Alertmanager Ingress rule, set the `alertmanager.ingress.hostname` value. When defining more than one, set the `alertmanager.ingress.extraHosts` array.

Apart from this case, no issues are expected to appear when upgrading.

### To 3.4.0

Some parameters disappeared in favor of new ones:

- `prometheus.additionalScrapeConfigsExternal.enabled` -> deprecated in favor of `prometheus.additionalScrapeConfigs.enabled` and `prometheus.additionalScrapeConfigs.type`.
- `prometheus.additionalScrapeConfigsExternal.name` -> deprecated in favor of `prometheus.additionalScrapeConfigs.external.name`.
- `prometheus.additionalScrapeConfigsExternal.key` -> deprecated in favor of `prometheus.additionalScrapeConfigs.external.key`.

Adapt you parameters accordingly if you are external scrape configs.

### To 3.1.0

Some parameters disappeared in favor of new ones:

- `*.podAffinity` -> deprecated in favor of `*.podAffinityPreset`.
- `*.podAntiAffinity` -> deprecated in favor of `*.podAntiAffinityPreset`.
- `*.nodeAffinity` -> deprecated in favor of `*.nodeAffinityPreset.type`, `*.nodeAffinityPreset.key` and `*.nodeAffinityPreset.values`.

Adapt you parameters accordingly if you are setting custom affinity.

### To 3.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 2.1.0

> Note: ignore these instructions if you did not enabled the Thanos sidecar on Prometheus pods.

The Thanos sidecar svc is transformed into a headless service by default so Thanos can discover every available sidecar. You can undo this change by setting the `prometheus.thanos.service.clusterIP` parameter to an empty string `""`.

To upgrade from version 2.0.0, previously remove the Thanos sidecar svc to avoid issues with immutable fields:

```bash
$ kubectl delete svc my-relase-kube-prometheus-prometheus-thanos
$ helm upgrade my-release --set prometheus.thanos.create=true bitnami/kube-prometheus
```

### To 2.0.0

- CRDs were updated to the latest prometheus-operator v0.4.1 release artifacts
  - The apiVersion of CRDs was updated from `apiextensions.k8s.io/v1beta1` to `apiextensions.k8s.io/v1`
  - Kubernetes 1.16 is required

### To 1.0.0

- The chart was renamed to `kube-prometheus` to be more accurate with the actual capabilities of the chart: it does not just deploy the Prometheus operator, it deploys an entire cluster monitoring stack, that includes other components (e.g. NodeExporter or Kube State metrics). Find more information about the reasons behind this decision at [#3490](https://github.com/bitnami/charts/issues/3490).
- New CRDs were added and some existing ones were updated.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

> Note: There is no backwards compatibility due to the above mentioned changes. It's necessary to install a new release of the chart, and migrate the existing TSDB data to the new Prometheus instances.
