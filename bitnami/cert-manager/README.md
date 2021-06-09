# Cert Manager

[cert-manager](https://cert-manager.io/) is a native Kubernetes certificate management controller. It can help with issuing certificates from a variety of sources, such as Let’s Encrypt, HashiCorp Vault, Venafi, a simple signing key pair, or self signed.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/cert-manager
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [cert-manager](https://cert-manager.io/) Deployment in a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
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

| Name                      | Description                                     | Value       |
| ------------------------- | ----------------------------------------------- | ----------- |
| `global.imageRegistry`    | Global Docker image registry                    | `nil`       |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `undefined` |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil`       |


### Common parameters

| Name                       | Description                                        | Value         |
| -------------------------- | -------------------------------------------------- | ------------- |
| `kubeVersion`              | Override Kubernetes version                        | `nil`         |
| `nameOverride`             | String to partially override common.names.fullname | `nil`         |
| `fullnameOverride`         | String to fully override common.names.fullname     | `nil`         |
| `commonLabels`             | Labels to add to all deployed objects              | `undefined`   |
| `commonAnnotations`        | Annotations to add to all deployed objects         | `undefined`   |
| `extraDeploy`              | Array of extra objects to deploy with the release  | `undefined`   |
| `logLevel`                 | Set up cert manager log level                      | `2`           |
| `leaderElection.namespace` | Namespace which leaderElection works.              | `kube-system` |
| `installCRDs`              | Flag to install Cert Manager CRDs                  | `false`       |
| `replicaCount`             | Number of Cert Manager replicas                    | `1`           |


### Controller deployment parameters

| Name                                               | Description                                                                                          | Value                  |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ---------------------- |
| `controller.replicaCount`                          | Number of Controller replicas                                                                        | `1`                    |
| `controller.image.registry`                        | Controller image registry                                                                            | `docker.io`            |
| `controller.image.repository`                      | Controller image repository                                                                          | `bitnami/cert-manager` |
| `controller.image.tag`                             | Controller image tag (immutabe tags are recommended)                                                 | `1.3.1-debian-10-r10`  |
| `controller.image.pullPolicy`                      | Controller image pull policy                                                                         | `IfNotPresent`         |
| `controller.image.pullSecrets`                     | Controller image pull secrets                                                                        | `undefined`            |
| `controller.image.debug`                           | Controller image debug mode                                                                          | `false`                |
| `controller.acmesolver.image.registry`             | Controller image registry                                                                            | `docker.io`            |
| `controller.acmesolver.image.repository`           | Controller image repository                                                                          | `bitnami/acme-solver`  |
| `controller.acmesolver.image.tag`                  | Controller image tag (immutabe tags are recommended)                                                 | `1.3.1-debian-10-r10`  |
| `controller.acmesolver.image.pullPolicy`           | Controller image pull policy                                                                         | `IfNotPresent`         |
| `controller.acmesolver.image.pullSecrets`          | Controller image pull secrets                                                                        | `undefined`            |
| `controller.acmesolver.image.debug`                | Controller image debug mode                                                                          | `false`                |
| `controller.resources.limits`                      | The resources limits for the Controller container                                                    | `undefined`            |
| `controller.resources.requests`                    | The requested resources for the Controller container                                                 | `undefined`            |
| `controller.podSecurityContext.enabled`            | Enabled Controller pods' Security Context                                                            | `true`                 |
| `controller.podSecurityContext.fsGroup`            | Set Controller pod's Security Context fsGroup                                                        | `1001`                 |
| `controller.containerSecurityContext.enabled`      | Enabled Controller containers' Security Context                                                      | `true`                 |
| `controller.containerSecurityContext.runAsUser`    | Set Controller container's Security Context runAsUser                                                | `1001`                 |
| `controller.containerSecurityContext.runAsNonRoot` | Set Controller container's Security Context runAsNonRoot                                             | `true`                 |
| `controller.podAffinityPreset`                     | Pod affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`       | `""`                   |
| `controller.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                 |
| `controller.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard` | `""`                   |
| `controller.nodeAffinityPreset.key`                | Node label key to match. Ignored if `controller.affinity` is set                                     | `""`                   |
| `controller.nodeAffinityPreset.values`             | Node label values to match. Ignored if `controller.affinity` is set                                  | `undefined`            |
| `controller.affinity`                              | Affinity for Cert Manager Controller                                                                 | `undefined`            |
| `controller.nodeSelector`                          | Node labels for pod assignment                                                                       | `undefined`            |
| `controller.containerPort`                         | Controller container port                                                                            | `9402`                 |
| `controller.command`                               | Override Controller default command                                                                  | `undefined`            |
| `controller.args`                                  | Override Controller default args                                                                     | `undefined`            |
| `controller.priorityClassName`                     | Controller pod priority class name                                                                   | `nil`                  |
| `controller.hostAliases`                           | Custom host aliases for Controller pods                                                              | `undefined`            |
| `controller.tolerations`                           | Tolerations for pod assignment                                                                       | `undefined`            |
| `controller.podLabels`                             | Extra labels for Controller pods                                                                     | `undefined`            |
| `controller.podAnnotations`                        | Annotations for Controller pods                                                                      | `undefined`            |
| `controller.lifecycleHooks`                        | Add lifecycle hooks to the Controller deployment                                                     | `undefined`            |
| `controller.updateStrategy.type`                   | Controller deployment update strategy                                                                | `RollingUpdate`        |
| `controller.updateStrategy.rollingUpdate`          | Controller deployment rolling update configuration parameters                                        | `undefined`            |
| `controller.extraEnvVars`                          | Add extra environment variables to the Controller container                                          | `undefined`            |
| `controller.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                                 | `nil`                  |
| `controller.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                                    | `nil`                  |
| `controller.extraVolumes`                          | Optionally specify extra list of additional volumes for Controller pods                              | `undefined`            |
| `controller.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Controller container(s)                 | `undefined`            |
| `controller.initContainers`                        | Add additional init containers to the Controller pods                                                | `undefined`            |
| `controller.sidecars`                              | Add additional sidecar containers to the Controller pod                                              | `undefined`            |
| `controller.serviceAccount.create`                 | Specifies whether a ServiceAccount should be created                                                 | `true`                 |
| `controller.serviceAccount.name`                   | The name of the ServiceAccount to use.                                                               | `""`                   |
| `controller.serviceAccount.annotations`            | Additional custom annotations for the ServiceAccount                                                 | `undefined`            |


### Webhook deployment parameters

| Name                                            | Description                                                                                       | Value                          |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------ |
| `webhook.replicaCount`                          | Number of Webhook replicas                                                                        | `1`                            |
| `webhook.image.registry`                        | Webhook image registry                                                                            | `docker.io`                    |
| `webhook.image.repository`                      | Webhook image repository                                                                          | `bitnami/cert-manager-webhook` |
| `webhook.image.tag`                             | Webhook image tag (immutabe tags are recommended)                                                 | `1.3.1-debian-10-r2`           |
| `webhook.image.pullPolicy`                      | Webhook image pull policy                                                                         | `IfNotPresent`                 |
| `webhook.image.pullSecrets`                     | Webhook image pull secrets                                                                        | `undefined`                    |
| `webhook.image.debug`                           | Webhook image debug mode                                                                          | `false`                        |
| `webhook.resources.limits`                      | The resources limits for the Webhook container                                                    | `undefined`                    |
| `webhook.resources.requests`                    | The requested resources for the Webhook container                                                 | `undefined`                    |
| `webhook.podSecurityContext.enabled`            | Enabled Webhook pods' Security Context                                                            | `true`                         |
| `webhook.podSecurityContext.fsGroup`            | Set Webhook pod's Security Context fsGroup                                                        | `1001`                         |
| `webhook.containerSecurityContext.enabled`      | Enabled Webhook containers' Security Context                                                      | `true`                         |
| `webhook.containerSecurityContext.runAsUser`    | Set Webhook container's Security Context runAsUser                                                | `1001`                         |
| `webhook.containerSecurityContext.runAsNonRoot` | Set Webhook container's Security Context runAsNonRoot                                             | `true`                         |
| `webhook.podAffinityPreset`                     | Pod affinity preset. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `webhook.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `webhook.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `webhook.nodeAffinityPreset.key`                | Node label key to match. Ignored if `webhook.affinity` is set                                     | `""`                           |
| `webhook.nodeAffinityPreset.values`             | Node label values to match. Ignored if `webhook.affinity` is set                                  | `undefined`                    |
| `webhook.affinity`                              | Affinity for Cert Manager Webhook                                                                 | `undefined`                    |
| `webhook.nodeSelector`                          | Node labels for pod assignment                                                                    | `undefined`                    |
| `webhook.containerPort`                         | Webhook container port                                                                            | `10250`                        |
| `webhook.httpsPort`                             | Webhook container port                                                                            | `443`                          |
| `webhook.command`                               | Override Webhook default command                                                                  | `undefined`                    |
| `webhook.args`                                  | Override Webhook default args                                                                     | `undefined`                    |
| `webhook.livenessProbe.enabled`                 | Enable livenessProbe                                                                              | `true`                         |
| `webhook.livenessProbe.path`                    | Path for livenessProbe                                                                            | `/livez`                       |
| `webhook.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                           | `60`                           |
| `webhook.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                  | `10`                           |
| `webhook.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                 | `1`                            |
| `webhook.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                               | `3`                            |
| `webhook.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                               | `1`                            |
| `webhook.readinessProbe.enabled`                | Enable readinessProbe                                                                             | `true`                         |
| `webhook.readinessProbe.path`                   | Path for readinessProbe                                                                           | `/healthz`                     |
| `webhook.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                          | `5`                            |
| `webhook.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                 | `5`                            |
| `webhook.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                | `1`                            |
| `webhook.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                              | `3`                            |
| `webhook.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                              | `1`                            |
| `webhook.customStartupProbe`                    | Override default startup probe                                                                    | `undefined`                    |
| `webhook.customLivenessProbe`                   | Override default liveness probe                                                                   | `undefined`                    |
| `webhook.customReadinessProbe`                  | Override default readiness probe                                                                  | `undefined`                    |
| `webhook.priorityClassName`                     | Webhook pod priority class name                                                                   | `nil`                          |
| `webhook.hostAliases`                           | Custom host aliases for Webhook pods                                                              | `undefined`                    |
| `webhook.tolerations`                           | Tolerations for pod assignment                                                                    | `undefined`                    |
| `webhook.podLabels`                             | Extra labels for Webhook pods                                                                     | `undefined`                    |
| `webhook.podAnnotations`                        | Annotations for Webhook pods                                                                      | `undefined`                    |
| `webhook.lifecycleHooks`                        | Add lifecycle hooks to the Webhook deployment                                                     | `undefined`                    |
| `webhook.updateStrategy.type`                   | Webhook deployment update strategy                                                                | `RollingUpdate`                |
| `webhook.updateStrategy.rollingUpdate`          | Controller deployment rolling update configuration parameters                                     | `undefined`                    |
| `webhook.extraEnvVars`                          | Add extra environment variables to the Webhook container                                          | `undefined`                    |
| `webhook.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                              | `nil`                          |
| `webhook.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                                 | `nil`                          |
| `webhook.extraVolumes`                          | Optionally specify extra list of additional volumes for Webhook pods                              | `undefined`                    |
| `webhook.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Webhook container(s)                 | `undefined`                    |
| `webhook.initContainers`                        | Add additional init containers to the Webhook pods                                                | `undefined`                    |
| `webhook.sidecars`                              | Add additional sidecar containers to the Webhook pod                                              | `undefined`                    |
| `webhook.serviceAccount.create`                 | Specifies whether a ServiceAccount should be created                                              | `true`                         |
| `webhook.serviceAccount.name`                   | The name of the ServiceAccount to use.                                                            | `""`                           |
| `webhook.serviceAccount.annotations`            | Additional custom annotations for the ServiceAccount                                              | `undefined`                    |


### CAInjector deployment parameters

| Name                                               | Description                                                                                          | Value                |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | -------------------- |
| `cainjector.replicaCount`                          | Number of CAInjector replicas                                                                        | `1`                  |
| `cainjector.image.registry`                        | CAInjector image registry                                                                            | `docker.io`          |
| `cainjector.image.repository`                      | CAInjector image repository                                                                          | `bitnami/cainjector` |
| `cainjector.image.tag`                             | CAInjector image tag (immutabe tags are recommended)                                                 | `1.3.1-debian-10-r2` |
| `cainjector.image.pullPolicy`                      | CAInjector image pull policy                                                                         | `IfNotPresent`       |
| `cainjector.image.pullSecrets`                     | CAInjector image pull secrets                                                                        | `undefined`          |
| `cainjector.image.debug`                           | CAInjector image debug mode                                                                          | `false`              |
| `cainjector.resources.limits`                      | The resources limits for the CAInjector container                                                    | `undefined`          |
| `cainjector.resources.requests`                    | The requested resources for the CAInjector container                                                 | `undefined`          |
| `cainjector.podSecurityContext.enabled`            | Enabled CAInjector pods' Security Context                                                            | `true`               |
| `cainjector.podSecurityContext.fsGroup`            | Set CAInjector pod's Security Context fsGroup                                                        | `1001`               |
| `cainjector.containerSecurityContext.enabled`      | Enabled CAInjector containers' Security Context                                                      | `true`               |
| `cainjector.containerSecurityContext.runAsUser`    | Set CAInjector container's Security Context runAsUser                                                | `1001`               |
| `cainjector.containerSecurityContext.runAsNonRoot` | Set CAInjector container's Security Context runAsNonRoot                                             | `true`               |
| `cainjector.podAffinityPreset`                     | Pod affinity preset. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard`       | `""`                 |
| `cainjector.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard`  | `soft`               |
| `cainjector.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard` | `""`                 |
| `cainjector.nodeAffinityPreset.key`                | Node label key to match. Ignored if `cainjector.affinity` is set                                     | `""`                 |
| `cainjector.nodeAffinityPreset.values`             | Node label values to match. Ignored if `cainjector.affinity` is set                                  | `undefined`          |
| `cainjector.affinity`                              | Affinity for Cert Manager CAInjector                                                                 | `undefined`          |
| `cainjector.nodeSelector`                          | Node labels for pod assignment                                                                       | `undefined`          |
| `cainjector.command`                               | Override CAInjector default command                                                                  | `undefined`          |
| `cainjector.args`                                  | Override CAInjector default args                                                                     | `undefined`          |
| `cainjector.priorityClassName`                     | CAInjector pod priority class name                                                                   | `nil`                |
| `cainjector.hostAliases`                           | Custom host aliases for CAInjector pods                                                              | `undefined`          |
| `cainjector.tolerations`                           | Tolerations for pod assignment                                                                       | `undefined`          |
| `cainjector.podLabels`                             | Extra labels for CAInjector pods                                                                     | `undefined`          |
| `cainjector.podAnnotations`                        | Annotations for CAInjector pods                                                                      | `undefined`          |
| `cainjector.lifecycleHooks`                        | Add lifecycle hooks to the CAInjector deployment                                                     | `undefined`          |
| `cainjector.updateStrategy.type`                   | Controller deployment update strategy                                                                | `RollingUpdate`      |
| `cainjector.updateStrategy.rollingUpdate`          | Controller deployment rolling update configuration parameters                                        | `undefined`          |
| `cainjector.extraEnvVars`                          | Add extra environment variables to the CAInjector container                                          | `undefined`          |
| `cainjector.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                                 | `nil`                |
| `cainjector.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                                    | `nil`                |
| `cainjector.extraVolumes`                          | Optionally specify extra list of additional volumes for CAInjector pods                              | `undefined`          |
| `cainjector.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for CAInjector container(s)                 | `undefined`          |
| `cainjector.initContainers`                        | Add additional init containers to the CAInjector pods                                                | `undefined`          |
| `cainjector.sidecars`                              | Add additional sidecar containers to the CAInjector pod                                              | `undefined`          |
| `cainjector.serviceAccount.create`                 | Specifies whether a ServiceAccount should be created                                                 | `true`               |
| `cainjector.serviceAccount.name`                   | The name of the ServiceAccount to use.                                                               | `""`                 |
| `cainjector.serviceAccount.annotations`            | Additional custom annotations for the ServiceAccount                                                 | `undefined`          |


### Metrics Parameters

| Name                                      | Description                                                                                      | Value       |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------ | ----------- |
| `metrics.enabled`                         | Start metrics                                                                                    | `true`      |
| `metrics.podAnnotations`                  | Annotations for Cert Manager exporter pods                                                       | `{}`        |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator                  | `false`     |
| `metrics.serviceMonitor.namespace`        | The namespace in which the ServiceMonitor will be created                                        | `nil`       |
| `metrics.serviceMonitor.interval`         | The interval at which metrics should be scraped                                                  | `60s`       |
| `metrics.serviceMonitor.path`             | The path which the ServiceMonitor will monitor                                                   | `/metrics`  |
| `metrics.serviceMonitor.scrapeTimeout`    | The timeout after which the scrape is ended                                                      | `30s`       |
| `metrics.serviceMonitor.targetPort`       | The port in which the ServiceMonitor will monitor                                                | `9402`      |
| `metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus | `undefined` |


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

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

