# Contour Operator

[The Contour Operator](https://github.com/projectcontour/contour-operator/) extends the Kubernetes API to create, configure and manage instances of Contour on behalf of users.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/contour-operator
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Contour Operator](https://github.com/projectcontour/contour-operator/) Deployment in a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/contour-operator
```

The command deploys the Contour Operator on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
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

| Name                | Description                                        | Value |
| ------------------- | -------------------------------------------------- | ----- |
| `kubeVersion`       | Override Kubernetes version                        | `""`  |
| `nameOverride`      | String to partially override common.names.fullname | `""`  |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`  |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`  |


### Contour Operator Parameters

| Name                                 | Description                                                                                    | Value                      |
| ------------------------------------ | ---------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`                     | Contour Operator image registry                                                                | `docker.io`                |
| `image.repository`                   | Contour Operator image repository                                                              | `bitnami/contour-operator` |
| `image.tag`                          | Contour Operator image tag (immutable tags are recommended)                                    | `1.18.1-scratch-r0`        |
| `image.pullPolicy`                   | Contour Operator image pull policy                                                             | `IfNotPresent`             |
| `image.pullSecrets`                  | Contour Operator image pull secrets                                                            | `[]`                       |
| `contourImage.registry`              | Contour Image registry                                                                         | `docker.io`                |
| `contourImage.repository`            | Contour Image repository                                                                       | `bitnami/contour`          |
| `contourImage.tag`                   | Contour Image tag (immutable tags are recommended)                                             | `1.18.1-debian-10-r14`     |
| `contourImage.pullSecrets`           | Contour Image pull secrets                                                                     | `[]`                       |
| `envoyImage.registry`                | Envoy Image registry                                                                           | `docker.io`                |
| `envoyImage.repository`              | Envoy Image repository                                                                         | `bitnami/envoy`            |
| `envoyImage.tag`                     | Envoy Image tag (immutable tags are recommended)                                               | `1.19.1-debian-10-r36`     |
| `envoyImage.pullSecrets`             | Envoy Image pull secrets                                                                       | `[]`                       |
| `replicaCount`                       | Number of Contour Operator replicas to deploy                                                  | `1`                        |
| `livenessProbe.enabled`              | Enable livenessProbe on Contour Operator nodes                                                 | `true`                     |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                        | `5`                        |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                               | `30`                       |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                              | `5`                        |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                            | `5`                        |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                            | `1`                        |
| `readinessProbe.enabled`             | Enable readinessProbe on Contour Operator nodes                                                | `true`                     |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                       | `5`                        |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                              | `30`                       |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                             | `5`                        |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                           | `5`                        |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                           | `1`                        |
| `startupProbe.enabled`               | Enable startupProbe on Contour Operator nodes                                                  | `false`                    |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                         | `5`                        |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                | `30`                       |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                               | `5`                        |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                             | `5`                        |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                             | `1`                        |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                            | `{}`                       |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                           | `{}`                       |
| `customStartupProbe`                 | Custom startupProbe that overrides the default one                                             | `{}`                       |
| `resources.limits`                   | The resources limits for the Contour Operator containers                                       | `{}`                       |
| `resources.requests`                 | The requested resources for the Contour Operator containers                                    | `{}`                       |
| `podSecurityContext.enabled`         | Enabled Contour Operator pods' Security Context                                                | `true`                     |
| `podSecurityContext.fsGroup`         | Set Contour Operator pod's Security Context fsGroup                                            | `1001`                     |
| `containerSecurityContext.enabled`   | Enabled Contour Operator containers' Security Context                                          | `true`                     |
| `containerSecurityContext.runAsUser` | Set Contour Operator containers' Security Context runAsUser                                    | `1001`                     |
| `command`                            | Override default container command (useful when using custom images)                           | `[]`                       |
| `args`                               | Override default container args (useful when using custom images)                              | `[]`                       |
| `hostAliases`                        | Contour Operator pods host aliases                                                             | `[]`                       |
| `podLabels`                          | Extra labels for Contour Operator pods                                                         | `{}`                       |
| `podAnnotations`                     | Annotations for Contour Operator pods                                                          | `{}`                       |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`            | `""`                       |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `soft`                     |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`      | `""`                       |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                          | `""`                       |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                       | `[]`                       |
| `affinity`                           | Affinity for Contour Operator pods assignment                                                  | `{}`                       |
| `nodeSelector`                       | Node labels for Contour Operator pods assignment                                               | `{}`                       |
| `tolerations`                        | Tolerations for Contour Operator pods assignment                                               | `[]`                       |
| `updateStrategy.type`                | Contour Operator deployment strategy type                                                      | `RollingUpdate`            |
| `priorityClassName`                  | Contour Operator pods' priorityClassName                                                       | `""`                       |
| `lifecycleHooks`                     | for the Contour Operator container(s) to automate configuration before or after startup        | `{}`                       |
| `terminationGracePeriodSeconds`      | Termination grace period in seconds                                                            | `10`                       |
| `containerPort`                      | Contour Operator container port (used for metrics)                                             | `8080`                     |
| `extraEnvVars`                       | Array with extra environment variables to add to Contour Operator nodes                        | `[]`                       |
| `extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for Contour Operator nodes                | `""`                       |
| `extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for Contour Operator nodes                   | `""`                       |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for the Contour Operator pod(s)            | `[]`                       |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the Contour Operator container(s) | `[]`                       |
| `sidecars`                           | Add additional sidecar containers to the Contour Operator pod(s)                               | `[]`                       |
| `initContainers`                     | Add additional init containers to the Contour Operator pod(s)                                  | `[]`                       |


### Other Parameters

| Name                    | Description                                          | Value  |
| ----------------------- | ---------------------------------------------------- | ------ |
| `rbac.create`           | Specifies whether RBAC resources should be created   | `true` |
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | `true` |
| `serviceAccount.name`   | The name of the ServiceAccount to use.               | `""`   |


### Metrics parameters

| Name                                       | Description                                                                 | Value                    |
| ------------------------------------------ | --------------------------------------------------------------------------- | ------------------------ |
| `metrics.enabled`                          | Create a service for accessing the metrics endpoint                         | `false`                  |
| `metrics.service.type`                     | Contour Operator metrics service type                                       | `ClusterIP`              |
| `metrics.service.port`                     | Contour Operator metrics service HTTP port                                  | `80`                     |
| `metrics.service.nodePorts.http`           | Node port for HTTP                                                          | `""`                     |
| `metrics.service.clusterIP`                | Contour Operator metrics service Cluster IP                                 | `""`                     |
| `metrics.service.loadBalancerIP`           | Contour Operator metrics service Load Balancer IP                           | `""`                     |
| `metrics.service.loadBalancerSourceRanges` | Contour Operator metrics service Load Balancer sources                      | `[]`                     |
| `metrics.service.externalTrafficPolicy`    | Contour Operator metrics service external traffic policy                    | `Cluster`                |
| `metrics.service.annotations`              | Additional custom annotations for Contour Operator metrics service          | `{}`                     |
| `metrics.serviceMonitor.enabled`           | Specify if a servicemonitor will be deployed for prometheus-operator        | `false`                  |
| `metrics.serviceMonitor.jobLabel`          | Specify the jobLabel to use for the prometheus-operator                     | `app.kubernetes.io/name` |
| `metrics.serviceMonitor.interval`          | Scrape interval. If not set, the Prometheus default scrape interval is used | `""`                     |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                    | `[]`                     |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                  | `[]`                     |


See [readme-generator-for-helm](https://github.com/bitnami-labs/readme-generator-for-helm) to create the table.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set livenessProbe.enabled=false \
    bitnami/contour-operator
```

The above command disables the Operator liveness probes.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/contour-operator
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
contour-operator:
  extraEnvVars:
    - name: MY_VARIABLE
      value: my_value
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as contour-operator (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/contour-operator/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such your custom *Contour* objects. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

For instance, to deploy your custom *Contour* definition, you can install the Contour using the values below:

```yaml
extraDeploy:
  - |
    apiVersion: operator.projectcontour.io/v1alpha1
    kind: Contour
    metadata:
      name: contour-sample
    spec:
      namespace:
        name: {{ .Release.Namespace | quote }}
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
