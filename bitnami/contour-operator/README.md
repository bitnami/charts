<!--- app-name: Contour Operator -->

# Contour Operator packaged by Bitnami

The Contour Operator extends the Kubernetes API to create, configure and manage instances of Contour on behalf of users.

[Overview of Contour Operator](https://github.com/projectcontour/contour-operator)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/contour-operator
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Contour Operator](https://github.com/projectcontour/contour-operator/) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.21+
- Helm 3.2.0+

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

## Differences between the Bitnami Contour chart and the Bitnami Contour Operator chart

In the Bitnami catalog we offer both the *bitnami/contour* and *bitnami/contour-operator* charts. Each solution covers different needs and use cases.

The *bitnami/contour* chart deploys a single Contour installation using a Kubernetes Deployment object (together with Services, PVCs, ConfigMaps, etc.). The figure below shows a simplified view of the deployed objects in the cluster after executing *helm install*:

```
                    +--------------+                +-------------+
                    |              |                |             |
 Service            |   Contour    |                |    Envoy    |
<-------------------+              +<---------------+             |
                    |  Deployment  |                |  DaemonSet  |
                    |              |                |             |
                    +-----------+--+                +-------------+
                                ^
                                |                +------------+
                                |                |            |
                                +----------------+ Configmaps |
                                                 |            |
                                                 +------------+

```

Its lifecycle is managed using Helm.

The *bitnami/contour-operator* chart deploys a Contour Operator installation using a Kubernetes Deployment. The figure below shows the Contour Operator deployment after executing *helm install*:

```
+--------------------+
|                    |      +---------------+
|  Contour Operator  |      |               |
|                    |      |     RBAC      |
|     Deployment     |      | Privileges    |
+-------+------------+      +-------+-------+
        ^                           |
        |   +-----------------+     |
        +---+ Service Account +<----+
            +-----------------+
```

The operator will extend the Kubernetes API with the *Contour* object, among others. From that moment, the user will be able to deploy objects of these kinds and the previously deployed Operator will take care of deploying all the required Deployments, ConfigMaps and Services for running a Contour instance. Its lifecycle is managed using *kubectl* on the Contour objects. The following figure shows a simplified view of the deployed objects after deploying a *Contour* object using *kubectl*:

```
  +--------------------+
  |                    |      +---------------+
  |  Contour Operator  |      |               |
  |                    |      |     RBAC      |
  |     Deployment     |      | Privileges    |
  +-------+------------+      +-------+-------+
    |     ^                           |
    |     |   +-----------------+     |
    |     +---+ Service Account +<----+
    |         +-----------------+
    |
    |
    |
    |
    |    +-----------------------------------------------------------------------+
    |    |                       +--------------+                +-------------+ |
    |->  |                       |              |                |             | |
         |    Service            |   Contour    |                |    Envoy    | |
         |   <-------------------+              +<---------------+             | |
         |                       |  Deployment  |                |  DaemonSet  | |
         |                       |              |                |             | |
         |                       +-----------+--+                +-------------+ |
         |                                   ^                                   |
         |                                   |                +------------+     |
         |                                   +----------------+ Configmaps |     |
         |                                                    |  Secrets   |     |
         |                                                    +------------+     |
         +-----------------------------------------------------------------------+

```

This solution allows to easily deploy multiple Contour instances compared to the *bitnami/contour* chart. As the operator automatically deploys Contour installations, the Contour Operator pods will require a ServiceAccount with privileges to create and destroy multiple Kubernetes objects. This may be problematic for Kubernetes clusters with strict role-based access policies.

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

| Name                                              | Description                                                                                                              | Value                      |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | -------------------------- |
| `image.registry`                                  | Contour Operator image registry                                                                                          | `docker.io`                |
| `image.repository`                                | Contour Operator image repository                                                                                        | `bitnami/contour-operator` |
| `image.tag`                                       | Contour Operator image tag (immutable tags are recommended)                                                              | `1.22.0-scratch-r2`        |
| `image.digest`                                    | Contour Operator image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag         | `""`                       |
| `image.pullPolicy`                                | Contour Operator image pull policy                                                                                       | `IfNotPresent`             |
| `image.pullSecrets`                               | Contour Operator image pull secrets                                                                                      | `[]`                       |
| `contourImage.registry`                           | Contour Image registry                                                                                                   | `docker.io`                |
| `contourImage.repository`                         | Contour Image repository                                                                                                 | `bitnami/contour`          |
| `contourImage.tag`                                | Contour Image tag (immutable tags are recommended)                                                                       | `1.22.0-debian-11-r3`      |
| `contourImage.digest`                             | Contour image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                  | `""`                       |
| `contourImage.pullSecrets`                        | Contour Image pull secrets                                                                                               | `[]`                       |
| `envoyImage.registry`                             | Envoy Image registry                                                                                                     | `docker.io`                |
| `envoyImage.repository`                           | Envoy Image repository                                                                                                   | `bitnami/envoy`            |
| `envoyImage.tag`                                  | Envoy Image tag (immutable tags are recommended)                                                                         | `1.23.0-debian-11-r7`      |
| `envoyImage.digest`                               | Envoy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                    | `""`                       |
| `envoyImage.pullSecrets`                          | Envoy Image pull secrets                                                                                                 | `[]`                       |
| `replicaCount`                                    | Number of Contour Operator replicas to deploy                                                                            | `1`                        |
| `livenessProbe.enabled`                           | Enable livenessProbe on Contour Operator nodes                                                                           | `true`                     |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                  | `5`                        |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                         | `30`                       |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                        | `5`                        |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                      | `5`                        |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                      | `1`                        |
| `readinessProbe.enabled`                          | Enable readinessProbe on Contour Operator nodes                                                                          | `true`                     |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                 | `5`                        |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                        | `30`                       |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                       | `5`                        |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                     | `5`                        |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                     | `1`                        |
| `startupProbe.enabled`                            | Enable startupProbe on Contour Operator nodes                                                                            | `false`                    |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                   | `5`                        |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                          | `30`                       |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                         | `5`                        |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                       | `5`                        |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                       | `1`                        |
| `customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                      | `{}`                       |
| `customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                     | `{}`                       |
| `customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                       | `{}`                       |
| `resources.limits`                                | The resources limits for the Contour Operator containers                                                                 | `{}`                       |
| `resources.requests`                              | The requested resources for the Contour Operator containers                                                              | `{}`                       |
| `podSecurityContext.enabled`                      | Enabled Contour Operator pods' Security Context                                                                          | `true`                     |
| `podSecurityContext.fsGroup`                      | Set Contour Operator pod's Security Context fsGroup                                                                      | `1001`                     |
| `containerSecurityContext.enabled`                | Enabled Contour Operator containers' Security Context                                                                    | `true`                     |
| `containerSecurityContext.runAsUser`              | Set Contour Operator containers' Security Context runAsUser                                                              | `1001`                     |
| `containerSecurityContext.runAsNonRoot`           | Set Contour Operator containers' Security Context runAsNonRoot                                                           | `true`                     |
| `containerSecurityContext.readOnlyRootFilesystem` | Mount / (root) as a readonly filesystem on Contour Operator containers                                                   | `true`                     |
| `command`                                         | Override default container command (useful when using custom images)                                                     | `[]`                       |
| `args`                                            | Override default container args (useful when using custom images)                                                        | `[]`                       |
| `hostAliases`                                     | Contour Operator pods host aliases                                                                                       | `[]`                       |
| `schedulerName`                                   | Name of the Kubernetes scheduler (other than default)                                                                    | `""`                       |
| `podLabels`                                       | Extra labels for Contour Operator pods                                                                                   | `{}`                       |
| `podAnnotations`                                  | Annotations for Contour Operator pods                                                                                    | `{}`                       |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`                       |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`                     |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                       |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                    | `""`                       |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`                       |
| `affinity`                                        | Affinity for Contour Operator pods assignment                                                                            | `{}`                       |
| `nodeSelector`                                    | Node labels for Contour Operator pods assignment                                                                         | `{}`                       |
| `tolerations`                                     | Tolerations for Contour Operator pods assignment                                                                         | `[]`                       |
| `updateStrategy.type`                             | Contour Operator deployment strategy type                                                                                | `RollingUpdate`            |
| `priorityClassName`                               | Contour Operator pods' priorityClassName                                                                                 | `""`                       |
| `runtimeClassName`                                | Name of the runtime class to be used by pod(s)                                                                           | `""`                       |
| `lifecycleHooks`                                  | for the Contour Operator container(s) to automate configuration before or after startup                                  | `{}`                       |
| `terminationGracePeriodSeconds`                   | Termination grace period in seconds                                                                                      | `""`                       |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                       |
| `containerPorts.metrics`                          | Metrics port for the Contour Operator container                                                                          | `8080`                     |
| `extraEnvVars`                                    | Array with extra environment variables to add to Contour Operator nodes                                                  | `[]`                       |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for Contour Operator nodes                                          | `""`                       |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for Contour Operator nodes                                             | `""`                       |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the Contour Operator pod(s)                                      | `[]`                       |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the Contour Operator container(s)                           | `[]`                       |
| `sidecars`                                        | Add additional sidecar containers to the Contour Operator pod(s)                                                         | `[]`                       |
| `initContainers`                                  | Add additional init containers to the Contour Operator pod(s)                                                            | `[]`                       |


### Other Parameters

| Name                                          | Description                                                                                                         | Value  |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------ |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                                  | `true` |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `true` |
| `serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`   |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `true` |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                          | `{}`   |


### Metrics parameters

| Name                                       | Description                                                                      | Value       |
| ------------------------------------------ | -------------------------------------------------------------------------------- | ----------- |
| `metrics.enabled`                          | Create a service for accessing the metrics endpoint                              | `false`     |
| `metrics.service.type`                     | Contour Operator metrics service type                                            | `ClusterIP` |
| `metrics.service.ports.http`               | Contour Operator metrics service HTTP port                                       | `80`        |
| `metrics.service.nodePorts.http`           | Node port for HTTP                                                               | `""`        |
| `metrics.service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                   | `[]`        |
| `metrics.service.clusterIP`                | Contour Operator metrics service Cluster IP                                      | `""`        |
| `metrics.service.loadBalancerIP`           | Contour Operator metrics service Load Balancer IP                                | `""`        |
| `metrics.service.loadBalancerSourceRanges` | Contour Operator metrics service Load Balancer sources                           | `[]`        |
| `metrics.service.externalTrafficPolicy`    | Contour Operator metrics service external traffic policy                         | `Cluster`   |
| `metrics.service.annotations`              | Additional custom annotations for Contour Operator metrics service               | `{}`        |
| `metrics.serviceMonitor.enabled`           | Specify if a servicemonitor will be deployed for prometheus-operator             | `false`     |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                         | `""`        |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                              | `{}`        |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus | `""`        |
| `metrics.serviceMonitor.interval`          | Scrape interval. If not set, the Prometheus default scrape interval is used      | `""`        |
| `metrics.serviceMonitor.scrapeTimeout`     | Scrape Timeout duration for prometheus                                           | `""`        |
| `metrics.serviceMonitor.metricRelabelings` | Specify additional relabeling of metrics                                         | `[]`        |
| `metrics.serviceMonitor.relabelings`       | Specify general relabeling                                                       | `[]`        |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                              | `[]`        |


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

### Using private image registries

If the images for Contour and Envoy are in a private registry and require pull secrets to be set, you need to create three service accounts (Contour, Envoy and Contour Certgen) with your pull secrets in the same namespace as you wish to deploy a Contour object. For example, if you want to deploy a Contour object in the `projectcontour` namespace and your image pull secret is `mySecret`, you would need to create the following service accounts first:

```yaml
kind: ServiceAccount
metadata:
  name: contour
  namespace: projectcontour
imagePullSecrets:
  - name: mySecret
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: contour-certgen
  namespace: projectcontour
imagePullSecrets:
  - name: mySecret
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: envoy
  namespace: projectcontour
imagePullSecrets:
  - name: mySecret
```

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

If additional containers are needed in the same pod as contour-operator (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/infrastructure/contour-operator/configuration/configure-sidecar-init-containers/).

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

## Upgrading

### To 1.0.0

This version updates the chart to use Contour's latest release, `1.20.1`. Among other features, exisiting CRDs have been syncronised with the official [Contour repository](https://github.com/projectcontour/contour/blob/main/examples/render/contour.yaml)

This version bumps the Envoy and Contour container to the ones matching the Contour Operator requirements.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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