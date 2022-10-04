<!--- app-name: HAProxy -->

# HAProxy packaged by Bitnami

HAProxy is a TCP proxy and a HTTP reverse proxy. It supports SSL termination and offloading, TCP and HTTP normalization, traffic regulation, caching and protection against DDoS attacks.

[Overview of HAProxy](http://www.haproxy.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ helm repo add my-repo https://charts.bitnami.com/bitnami
$ helm install my-release my-repo/haproxy
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [HAProxy](https://github.com/haproxytech/haproxy) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/infrastructure/haproxy/get-started/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release my-repo/haproxy
```

The command deploys haproxy on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### Traffic Exposure Parameters

| Name                               | Description                                                          | Value          |
| ---------------------------------- | -------------------------------------------------------------------- | -------------- |
| `service.type`                     | haproxy service type                                                 | `LoadBalancer` |
| `service.ports`                    | List of haproxy service ports                                        | `[]`           |
| `service.clusterIP`                | haproxy service Cluster IP                                           | `""`           |
| `service.loadBalancerIP`           | haproxy service Load Balancer IP                                     | `""`           |
| `service.loadBalancerSourceRanges` | haproxy service Load Balancer sources                                | `[]`           |
| `service.externalTrafficPolicy`    | haproxy service external traffic policy                              | `Cluster`      |
| `service.annotations`              | Additional custom annotations for haproxy service                    | `{}`           |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP" | `None`         |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                          | `{}`           |
| `service.labels`                   | Additional custom labels for haproxy service                         | `{}`           |


### HAProxy Parameters

| Name                                    | Description                                                                                             | Value                |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------- | -------------------- |
| `image.registry`                        | HAProxy image registry                                                                                  | `docker.io`          |
| `image.repository`                      | HAProxy image repository                                                                                | `bitnami/haproxy`    |
| `image.tag`                             | HAProxy image tag (immutable tags are recommended)                                                      | `2.6.6-debian-11-r0` |
| `image.digest`                          | HAProxy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                 |
| `image.pullPolicy`                      | HAProxy image pull policy                                                                               | `IfNotPresent`       |
| `image.pullSecrets`                     | HAProxy image pull secrets                                                                              | `[]`                 |
| `replicaCount`                          | Number of haproxy replicas to deploy                                                                    | `1`                  |
| `startupProbe.enabled`                  | Enable startupProbe on haproxy nodes                                                                    | `false`              |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                  | `15`                 |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                         | `10`                 |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                        | `5`                  |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                      | `5`                  |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                      | `1`                  |
| `livenessProbe.enabled`                 | Enable livenessProbe on haproxy nodes                                                                   | `true`               |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                 | `15`                 |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                        | `10`                 |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                       | `5`                  |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                     | `5`                  |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                     | `1`                  |
| `readinessProbe.enabled`                | Enable readinessProbe on haproxy nodes                                                                  | `true`               |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                | `15`                 |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                       | `10`                 |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                      | `5`                  |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                    | `5`                  |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                    | `1`                  |
| `customStartupProbe`                    | Custom startupProbe that overrides the default one                                                      | `{}`                 |
| `customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                     | `{}`                 |
| `customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                    | `{}`                 |
| `resources.limits`                      | The resources limits for the haproxy containers                                                         | `{}`                 |
| `resources.requests`                    | The requested resources for the haproxy containers                                                      | `{}`                 |
| `podSecurityContext.enabled`            | Enabled haproxy pods' Security Context                                                                  | `true`               |
| `podSecurityContext.fsGroup`            | Set haproxy pod's Security Context fsGroup                                                              | `1001`               |
| `containerSecurityContext.enabled`      | Enabled haproxy containers' Security Context                                                            | `true`               |
| `containerSecurityContext.runAsUser`    | Set haproxy containers' Security Context runAsUser                                                      | `1001`               |
| `containerSecurityContext.runAsNonRoot` | Set haproxy container's Security Context runAsNonRoot                                                   | `true`               |
| `pdb.create`                            | Enable a Pod Disruption Budget creation                                                                 | `false`              |
| `pdb.minAvailable`                      | Minimum number/percentage of pods that should remain scheduled                                          | `1`                  |
| `pdb.maxUnavailable`                    | Maximum number/percentage of pods that may be made unavailable                                          | `""`                 |
| `autoscaling.enabled`                   | Enable Horizontal POD autoscaling for HAProxy                                                           | `false`              |
| `autoscaling.minReplicas`               | Minimum number of HAProxy replicas                                                                      | `1`                  |
| `autoscaling.maxReplicas`               | Maximum number of HAProxy replicas                                                                      | `11`                 |
| `autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                       | `50`                 |
| `autoscaling.targetMemory`              | Target Memory utilization percentage                                                                    | `50`                 |
| `command`                               | Override default container command (useful when using custom images)                                    | `[]`                 |
| `args`                                  | Override default container args (useful when using custom images)                                       | `[]`                 |
| `hostAliases`                           | haproxy pods host aliases                                                                               | `[]`                 |
| `podLabels`                             | Extra labels for haproxy pods                                                                           | `{}`                 |
| `podAnnotations`                        | Annotations for haproxy pods                                                                            | `{}`                 |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `""`                 |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                | `soft`               |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`               | `""`                 |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                                   | `""`                 |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                                | `[]`                 |
| `configuration`                         | haproxy configuration                                                                                   | `""`                 |
| `containerPorts`                        | List of container ports to enable in the haproxy container                                              | `[]`                 |
| `existingConfigmap`                     | configmap with HAProxy configuration                                                                    | `""`                 |
| `affinity`                              | Affinity for haproxy pods assignment                                                                    | `{}`                 |
| `nodeSelector`                          | Node labels for haproxy pods assignment                                                                 | `{}`                 |
| `tolerations`                           | Tolerations for haproxy pods assignment                                                                 | `[]`                 |
| `schedulerName`                         | Name of the k8s scheduler (other than default)                                                          | `""`                 |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                          | `[]`                 |
| `updateStrategy.type`                   | haproxy statefulset strategy type                                                                       | `RollingUpdate`      |
| `priorityClassName`                     | haproxy pods' priorityClassName                                                                         | `""`                 |
| `lifecycleHooks`                        | for the haproxy container(s) to automate configuration before or after startup                          | `{}`                 |
| `extraEnvVars`                          | Array with extra environment variables to add to haproxy nodes                                          | `[]`                 |
| `extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for haproxy nodes                                  | `""`                 |
| `extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for haproxy nodes                                     | `""`                 |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for the haproxy pod(s)                              | `[]`                 |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the haproxy container(s)                   | `[]`                 |
| `sidecars`                              | Add additional sidecar containers to the haproxy pod(s)                                                 | `[]`                 |
| `initContainers`                        | Add additional init containers to the haproxy pod(s)                                                    | `[]`                 |


### Other Parameters

| Name                                          | Description                                                                                                         | Value  |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `true` |
| `serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`   |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `true` |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                          | `{}`   |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `true` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                              | `""`   |


The above parameters map to the env variables defined in [bitnami/haproxy](https://github.com/bitnami/containers/tree/main/bitnami/haproxy). For more information please refer to the [bitnami/haproxy](https://github.com/bitnami/containers/tree/main/bitnami/haproxy) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set service.type=LoadBalancer \
    my-repo/haproxy
```

The above command sets the HAProxy service type as LoadBalancer.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml my-repo/haproxy
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Configure HAProxy

By default, HAProxy is deployed with a sample, non-functional, configuration. You will need to edit the following values to adapt it to your use case:

* Set the configuration to be injected in the `haproxy.cfg` file by changing the `configuration` parameter. Alternatively, you can provide an existing ConfigMap with `haproxy.cfg` by using the `existingConfigmap` parameter.
* Based on your HAProxy configuration, edit the `containerPorts` and `service.ports` parameters. In the `containerPorts` parameter, set all the ports that the HAProxy configuration uses, and in the `service.ports` parameter, set the ports to be externally exposed.

Refer to the [chart documentation for a more detailed configuration example](https://docs.bitnami.com/kubernetes/infrastructure/haproxy/get-started/configure-proxy).

### Add extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/haproxy/configuration/configure-sidecar-init-containers/).

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

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