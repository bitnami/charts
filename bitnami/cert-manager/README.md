<!--- app-name: Cert Manager -->

# Cert Manager packaged by Bitnami

Cert Manager is a Kubernetes add-on to automate the management and issuance of TLS certificates from various issuing sources.

[Overview of Cert Manager](https://github.com/jetstack/cert-manager)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/cert-manager
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [cert-manager](https://cert-manager.io/) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/cert-manager
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` helm release:

```console
$ helm uninstall my-release
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

| Name                       | Description                                                                                                                                       | Value         |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `kubeVersion`              | Override Kubernetes version                                                                                                                       | `""`          |
| `nameOverride`             | String to partially override common.names.fullname                                                                                                | `""`          |
| `fullnameOverride`         | String to fully override common.names.fullname                                                                                                    | `""`          |
| `commonLabels`             | Labels to add to all deployed objects                                                                                                             | `{}`          |
| `commonAnnotations`        | Annotations to add to all deployed objects                                                                                                        | `{}`          |
| `extraDeploy`              | Array of extra objects to deploy with the release                                                                                                 | `[]`          |
| `logLevel`                 | Set up cert manager log level                                                                                                                     | `2`           |
| `clusterResourceNamespace` | Namespace used to store DNS provider credentials etc. for ClusterIssuer resources. If empty, uses the namespace where the controller is deployed. | `""`          |
| `leaderElection.namespace` | Namespace which leaderElection works.                                                                                                             | `kube-system` |
| `installCRDs`              | Flag to install Cert Manager CRDs                                                                                                                 | `false`       |
| `replicaCount`             | Number of Cert Manager replicas                                                                                                                   | `1`           |


### Controller deployment parameters

| Name                                                     | Description                                                                                                | Value                  |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ---------------------- |
| `controller.replicaCount`                                | Number of Controller replicas                                                                              | `1`                    |
| `controller.image.registry`                              | Controller image registry                                                                                  | `docker.io`            |
| `controller.image.repository`                            | Controller image repository                                                                                | `bitnami/cert-manager` |
| `controller.image.tag`                                   | Controller image tag (immutable tags are recommended)                                                      | `1.9.1-debian-11-r6`   |
| `controller.image.digest`                                | Controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                   |
| `controller.image.pullPolicy`                            | Controller image pull policy                                                                               | `IfNotPresent`         |
| `controller.image.pullSecrets`                           | Controller image pull secrets                                                                              | `[]`                   |
| `controller.image.debug`                                 | Controller image debug mode                                                                                | `false`                |
| `controller.acmesolver.image.registry`                   | Controller image registry                                                                                  | `docker.io`            |
| `controller.acmesolver.image.repository`                 | Controller image repository                                                                                | `bitnami/acmesolver`   |
| `controller.acmesolver.image.tag`                        | Controller image tag (immutable tags are recommended)                                                      | `1.9.1-debian-11-r8`   |
| `controller.acmesolver.image.digest`                     | Controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                   |
| `controller.acmesolver.image.pullPolicy`                 | Controller image pull policy                                                                               | `IfNotPresent`         |
| `controller.acmesolver.image.pullSecrets`                | Controller image pull secrets                                                                              | `[]`                   |
| `controller.acmesolver.image.debug`                      | Controller image debug mode                                                                                | `false`                |
| `controller.resources.limits`                            | The resources limits for the Controller container                                                          | `{}`                   |
| `controller.resources.requests`                          | The requested resources for the Controller container                                                       | `{}`                   |
| `controller.podSecurityContext.enabled`                  | Enabled Controller pods' Security Context                                                                  | `true`                 |
| `controller.podSecurityContext.fsGroup`                  | Set Controller pod's Security Context fsGroup                                                              | `1001`                 |
| `controller.containerSecurityContext.enabled`            | Enabled Controller containers' Security Context                                                            | `true`                 |
| `controller.containerSecurityContext.runAsUser`          | Set Controller container's Security Context runAsUser                                                      | `1001`                 |
| `controller.containerSecurityContext.runAsNonRoot`       | Set Controller container's Security Context runAsNonRoot                                                   | `true`                 |
| `controller.podAffinityPreset`                           | Pod affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`             | `""`                   |
| `controller.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`        | `soft`                 |
| `controller.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`       | `""`                   |
| `controller.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `controller.affinity` is set                                           | `""`                   |
| `controller.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `controller.affinity` is set                                        | `[]`                   |
| `controller.affinity`                                    | Affinity for Cert Manager Controller                                                                       | `{}`                   |
| `controller.nodeSelector`                                | Node labels for pod assignment                                                                             | `{}`                   |
| `controller.containerPort`                               | Controller container port                                                                                  | `9402`                 |
| `controller.command`                                     | Override Controller default command                                                                        | `[]`                   |
| `controller.args`                                        | Override Controller default args                                                                           | `[]`                   |
| `controller.priorityClassName`                           | Controller pod priority class name                                                                         | `""`                   |
| `controller.runtimeClassName`                            | Name of the runtime class to be used by pod(s)                                                             | `""`                   |
| `controller.schedulerName`                               | Name of the k8s scheduler (other than default)                                                             | `""`                   |
| `controller.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment                                                             | `[]`                   |
| `controller.hostAliases`                                 | Custom host aliases for Controller pods                                                                    | `[]`                   |
| `controller.tolerations`                                 | Tolerations for pod assignment                                                                             | `[]`                   |
| `controller.podLabels`                                   | Extra labels for Controller pods                                                                           | `{}`                   |
| `controller.podAnnotations`                              | Annotations for Controller pods                                                                            | `{}`                   |
| `controller.dnsPolicy`                                   | Controller pod DNS policy                                                                                  | `""`                   |
| `controller.dnsConfig`                                   | Controller pod DNS config. Required if `controller.dnsPolicy` is set to `None`                             | `{}`                   |
| `controller.lifecycleHooks`                              | Add lifecycle hooks to the Controller deployment                                                           | `{}`                   |
| `controller.updateStrategy.type`                         | Controller deployment update strategy                                                                      | `RollingUpdate`        |
| `controller.updateStrategy.rollingUpdate`                | Controller deployment rolling update configuration parameters                                              | `{}`                   |
| `controller.extraArgs`                                   | Extra arguments to pass to the Controller container                                                        | `[]`                   |
| `controller.extraEnvVars`                                | Add extra environment variables to the Controller container                                                | `[]`                   |
| `controller.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars                                                       | `""`                   |
| `controller.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars                                                          | `""`                   |
| `controller.extraVolumes`                                | Optionally specify extra list of additional volumes for Controller pods                                    | `[]`                   |
| `controller.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for Controller container(s)                       | `[]`                   |
| `controller.initContainers`                              | Add additional init containers to the Controller pods                                                      | `[]`                   |
| `controller.sidecars`                                    | Add additional sidecar containers to the Controller pod                                                    | `[]`                   |
| `controller.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                       | `true`                 |
| `controller.serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                     | `""`                   |
| `controller.serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                       | `{}`                   |
| `controller.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                             | `true`                 |


### Webhook deployment parameters

| Name                                                  | Description                                                                                             | Value                          |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `webhook.replicaCount`                                | Number of Webhook replicas                                                                              | `1`                            |
| `webhook.image.registry`                              | Webhook image registry                                                                                  | `docker.io`                    |
| `webhook.image.repository`                            | Webhook image repository                                                                                | `bitnami/cert-manager-webhook` |
| `webhook.image.tag`                                   | Webhook image tag (immutable tags are recommended)                                                      | `1.9.1-debian-11-r5`           |
| `webhook.image.digest`                                | Webhook image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                           |
| `webhook.image.pullPolicy`                            | Webhook image pull policy                                                                               | `IfNotPresent`                 |
| `webhook.image.pullSecrets`                           | Webhook image pull secrets                                                                              | `[]`                           |
| `webhook.image.debug`                                 | Webhook image debug mode                                                                                | `false`                        |
| `webhook.resources.limits`                            | The resources limits for the Webhook container                                                          | `{}`                           |
| `webhook.resources.requests`                          | The requested resources for the Webhook container                                                       | `{}`                           |
| `webhook.podSecurityContext.enabled`                  | Enabled Webhook pods' Security Context                                                                  | `true`                         |
| `webhook.podSecurityContext.fsGroup`                  | Set Webhook pod's Security Context fsGroup                                                              | `1001`                         |
| `webhook.containerSecurityContext.enabled`            | Enabled Webhook containers' Security Context                                                            | `true`                         |
| `webhook.containerSecurityContext.runAsUser`          | Set Webhook container's Security Context runAsUser                                                      | `1001`                         |
| `webhook.containerSecurityContext.runAsNonRoot`       | Set Webhook container's Security Context runAsNonRoot                                                   | `true`                         |
| `webhook.podAffinityPreset`                           | Pod affinity preset. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`             | `""`                           |
| `webhook.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`        | `soft`                         |
| `webhook.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `webhook.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `webhook.affinity` is set                                           | `""`                           |
| `webhook.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `webhook.affinity` is set                                        | `[]`                           |
| `webhook.affinity`                                    | Affinity for Cert Manager Webhook                                                                       | `{}`                           |
| `webhook.nodeSelector`                                | Node labels for pod assignment                                                                          | `{}`                           |
| `webhook.containerPort`                               | Webhook container port                                                                                  | `10250`                        |
| `webhook.httpsPort`                                   | Webhook container port                                                                                  | `443`                          |
| `webhook.command`                                     | Override Webhook default command                                                                        | `[]`                           |
| `webhook.args`                                        | Override Webhook default args                                                                           | `[]`                           |
| `webhook.livenessProbe.enabled`                       | Enable livenessProbe                                                                                    | `true`                         |
| `webhook.livenessProbe.path`                          | Path for livenessProbe                                                                                  | `/livez`                       |
| `webhook.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                 | `60`                           |
| `webhook.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                        | `10`                           |
| `webhook.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                       | `1`                            |
| `webhook.livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                     | `3`                            |
| `webhook.livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                     | `1`                            |
| `webhook.readinessProbe.enabled`                      | Enable readinessProbe                                                                                   | `true`                         |
| `webhook.readinessProbe.path`                         | Path for readinessProbe                                                                                 | `/healthz`                     |
| `webhook.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                | `5`                            |
| `webhook.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                       | `5`                            |
| `webhook.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                      | `1`                            |
| `webhook.readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                    | `3`                            |
| `webhook.readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                    | `1`                            |
| `webhook.customStartupProbe`                          | Override default startup probe                                                                          | `{}`                           |
| `webhook.customLivenessProbe`                         | Override default liveness probe                                                                         | `{}`                           |
| `webhook.customReadinessProbe`                        | Override default readiness probe                                                                        | `{}`                           |
| `webhook.priorityClassName`                           | Webhook pod priority class name                                                                         | `""`                           |
| `webhook.runtimeClassName`                            | Name of the runtime class to be used by pod(s)                                                          | `""`                           |
| `webhook.schedulerName`                               | Name of the k8s scheduler (other than default)                                                          | `""`                           |
| `webhook.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment                                                          | `[]`                           |
| `webhook.hostAliases`                                 | Custom host aliases for Webhook pods                                                                    | `[]`                           |
| `webhook.tolerations`                                 | Tolerations for pod assignment                                                                          | `[]`                           |
| `webhook.podLabels`                                   | Extra labels for Webhook pods                                                                           | `{}`                           |
| `webhook.podAnnotations`                              | Annotations for Webhook pods                                                                            | `{}`                           |
| `webhook.lifecycleHooks`                              | Add lifecycle hooks to the Webhook deployment                                                           | `{}`                           |
| `webhook.updateStrategy.type`                         | Webhook deployment update strategy                                                                      | `RollingUpdate`                |
| `webhook.updateStrategy.rollingUpdate`                | Controller deployment rolling update configuration parameters                                           | `{}`                           |
| `webhook.extraArgs`                                   | Extra arguments to pass to the Webhook container                                                        | `[]`                           |
| `webhook.extraEnvVars`                                | Add extra environment variables to the Webhook container                                                | `[]`                           |
| `webhook.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars                                                    | `""`                           |
| `webhook.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars                                                       | `""`                           |
| `webhook.extraVolumes`                                | Optionally specify extra list of additional volumes for Webhook pods                                    | `[]`                           |
| `webhook.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for Webhook container                          | `[]`                           |
| `webhook.initContainers`                              | Add additional init containers to the Webhook pods                                                      | `[]`                           |
| `webhook.sidecars`                                    | Add additional sidecar containers to the Webhook pod                                                    | `[]`                           |
| `webhook.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                    | `true`                         |
| `webhook.serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                  | `""`                           |
| `webhook.serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                    | `{}`                           |
| `webhook.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                          | `true`                         |


### CAInjector deployment parameters

| Name                                                     | Description                                                                                                | Value                |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------------------- |
| `cainjector.replicaCount`                                | Number of CAInjector replicas                                                                              | `1`                  |
| `cainjector.image.registry`                              | CAInjector image registry                                                                                  | `docker.io`          |
| `cainjector.image.repository`                            | CAInjector image repository                                                                                | `bitnami/cainjector` |
| `cainjector.image.tag`                                   | CAInjector image tag (immutable tags are recommended)                                                      | `1.9.1-debian-11-r6` |
| `cainjector.image.digest`                                | CAInjector image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                 |
| `cainjector.image.pullPolicy`                            | CAInjector image pull policy                                                                               | `IfNotPresent`       |
| `cainjector.image.pullSecrets`                           | CAInjector image pull secrets                                                                              | `[]`                 |
| `cainjector.image.debug`                                 | CAInjector image debug mode                                                                                | `false`              |
| `cainjector.resources.limits`                            | The resources limits for the CAInjector container                                                          | `{}`                 |
| `cainjector.resources.requests`                          | The requested resources for the CAInjector container                                                       | `{}`                 |
| `cainjector.podSecurityContext.enabled`                  | Enabled CAInjector pods' Security Context                                                                  | `true`               |
| `cainjector.podSecurityContext.fsGroup`                  | Set CAInjector pod's Security Context fsGroup                                                              | `1001`               |
| `cainjector.containerSecurityContext.enabled`            | Enabled CAInjector containers' Security Context                                                            | `true`               |
| `cainjector.containerSecurityContext.runAsUser`          | Set CAInjector container's Security Context runAsUser                                                      | `1001`               |
| `cainjector.containerSecurityContext.runAsNonRoot`       | Set CAInjector container's Security Context runAsNonRoot                                                   | `true`               |
| `cainjector.podAffinityPreset`                           | Pod affinity preset. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard`             | `""`                 |
| `cainjector.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard`        | `soft`               |
| `cainjector.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard`       | `""`                 |
| `cainjector.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `cainjector.affinity` is set                                           | `""`                 |
| `cainjector.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `cainjector.affinity` is set                                        | `[]`                 |
| `cainjector.affinity`                                    | Affinity for Cert Manager CAInjector                                                                       | `{}`                 |
| `cainjector.nodeSelector`                                | Node labels for pod assignment                                                                             | `{}`                 |
| `cainjector.command`                                     | Override CAInjector default command                                                                        | `[]`                 |
| `cainjector.args`                                        | Override CAInjector default args                                                                           | `[]`                 |
| `cainjector.priorityClassName`                           | CAInjector pod priority class name                                                                         | `""`                 |
| `cainjector.runtimeClassName`                            | Name of the runtime class to be used by pod(s)                                                             | `""`                 |
| `cainjector.schedulerName`                               | Name of the k8s scheduler (other than default)                                                             | `""`                 |
| `cainjector.topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment                                                             | `[]`                 |
| `cainjector.hostAliases`                                 | Custom host aliases for CAInjector pods                                                                    | `[]`                 |
| `cainjector.tolerations`                                 | Tolerations for pod assignment                                                                             | `[]`                 |
| `cainjector.podLabels`                                   | Extra labels for CAInjector pods                                                                           | `{}`                 |
| `cainjector.podAnnotations`                              | Annotations for CAInjector pods                                                                            | `{}`                 |
| `cainjector.lifecycleHooks`                              | Add lifecycle hooks to the CAInjector deployment                                                           | `{}`                 |
| `cainjector.updateStrategy.type`                         | Controller deployment update strategy                                                                      | `RollingUpdate`      |
| `cainjector.updateStrategy.rollingUpdate`                | Controller deployment rolling update configuration parameters                                              | `{}`                 |
| `cainjector.extraArgs`                                   | Extra arguments to pass to the CAInjector container                                                        | `[]`                 |
| `cainjector.extraEnvVars`                                | Add extra environment variables to the CAInjector container                                                | `[]`                 |
| `cainjector.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars                                                       | `""`                 |
| `cainjector.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars                                                          | `""`                 |
| `cainjector.extraVolumes`                                | Optionally specify extra list of additional volumes for CAInjector pods                                    | `[]`                 |
| `cainjector.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for CAInjector container(s)                       | `[]`                 |
| `cainjector.initContainers`                              | Add additional init containers to the CAInjector pods                                                      | `[]`                 |
| `cainjector.sidecars`                                    | Add additional sidecar containers to the CAInjector pod                                                    | `[]`                 |
| `cainjector.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                       | `true`               |
| `cainjector.serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                     | `""`                 |
| `cainjector.serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                       | `{}`                 |
| `cainjector.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                             | `true`               |


### Metrics Parameters

| Name                                       | Description                                                                       | Value      |
| ------------------------------------------ | --------------------------------------------------------------------------------- | ---------- |
| `metrics.enabled`                          | Start metrics                                                                     | `true`     |
| `metrics.podAnnotations`                   | Annotations for Cert Manager exporter pods                                        | `{}`       |
| `metrics.serviceMonitor.path`              | The path which the ServiceMonitor will monitor                                    | `/metrics` |
| `metrics.serviceMonitor.targetPort`        | The port in which the ServiceMonitor will monitor                                 | `9402`     |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator      | `false`    |
| `metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                          | `""`       |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus. | `""`       |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                       | `60s`      |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                           | `30s`      |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                | `[]`       |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                         | `[]`       |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                    | `{}`       |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                               | `{}`       |
| `metrics.serviceMonitor.additionalLabels`  | DEPRECATED. Use metrics.serviceMonitor.labels instead.                            | `{}`       |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels          | `false`    |


### Other Parameters

| Name          | Description                                        | Value  |
| ------------- | -------------------------------------------------- | ------ |
| `rbac.create` | Specifies whether RBAC resources should be created | `true` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release bitnami/cert-manager \
  --set installCRDs=true
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/cert-manager
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Cert Manager app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `controller.affinity`, `cainjector.affinity` or `webhook.affinity` parameters. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can make use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `controller.podAffinityPreset`, `cainjector.podAffinityPreset`, `webhook.podAffinityPreset`, `controller.podAntiAffinityPreset`, `cainjector.podAntiAffinityPreset`, `webhook.podAntiAffinityPreset`, `controller.nodeAffinityPreset`, `cainjector.nodeAffinityPreset` or `webhook.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 0.5.0

Exisiting CRDs have been syncronised with the official [Cert Manager repository](https://github.com/cert-manager/cert-manager/tree/master/deploy/crds). Using the templates present in the 1.8.0 tag.

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