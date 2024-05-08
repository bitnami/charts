<!--- app-name: TensorFlow ResNet -->

# Bitnami package for TensorFlow ResNet

TensorFlow ResNet is a client utility for use with TensorFlow Serving and ResNet models.

[Overview of TensorFlow ResNet](https://github.com/tensorflow/models)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/tensorflow-resnet
```

Looking to use TensorFlow ResNet in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a TensorFlow Serving ResNet deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/tensorflow-resnet
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Tensorflow Serving ResNet model on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use any of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                                  | Value          |
| ------------------------ | -------------------------------------------------------------------------------------------- | -------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`           |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`           |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`           |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                   | `{}`           |
| `commonLabels`           | Labels to add to all deployed objects                                                        | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                         | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                            | `["infinity"]` |

### TensorFlow parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                                |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `server.image.registry`                             | TensorFlow Serving image registry                                                                                                                                                                                 | `REGISTRY_NAME`                      |
| `server.image.repository`                           | TensorFlow Serving image repository                                                                                                                                                                               | `REPOSITORY_NAME/tensorflow-serving` |
| `server.image.digest`                               | TensorFlow Serving image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                | `""`                                 |
| `server.image.pullPolicy`                           | TensorFlow Serving image pull policy                                                                                                                                                                              | `IfNotPresent`                       |
| `server.image.pullSecrets`                          | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                                 |
| `client.image.registry`                             | TensorFlow ResNet image registry                                                                                                                                                                                  | `REGISTRY_NAME`                      |
| `client.image.repository`                           | TensorFlow ResNet image repository                                                                                                                                                                                | `REPOSITORY_NAME/tensorflow-resnet`  |
| `client.image.digest`                               | TensorFlow ResNet image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                 | `""`                                 |
| `client.image.pullPolicy`                           | TensorFlow ResNet image pull policy                                                                                                                                                                               | `IfNotPresent`                       |
| `client.image.pullSecrets`                          | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                                 |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                              |
| `hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                       | `[]`                                 |
| `containerPorts.server`                             | Tensorflow server port                                                                                                                                                                                            | `8500`                               |
| `containerPorts.restApi`                            | TensorFlow Serving Rest API Port                                                                                                                                                                                  | `8501`                               |
| `replicaCount`                                      | Number of replicas                                                                                                                                                                                                | `1`                                  |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                                 |
| `podLabels`                                         | Pod labels                                                                                                                                                                                                        | `{}`                                 |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                                 |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                               |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                                 |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                                 |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                                 |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                             | `{}`                                 |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`                                 |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                          | `[]`                                 |
| `podSecurityContext.enabled`                        | Enabled pod Security Context                                                                                                                                                                                      | `true`                               |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                             |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                                 |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                                 |
| `podSecurityContext.fsGroup`                        | Set pod Security Context fsGroup                                                                                                                                                                                  | `1001`                               |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                               |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `nil`                                |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                               |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                               |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                               |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                              |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                               |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                              |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                            |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                     |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                                 |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                                 |
| `lifecycleHooks`                                    | for the container to automate configuration before or after startup                                                                                                                                               | `{}`                                 |
| `extraEnvVars`                                      | Array with extra environment variables for the Tensorflow Serving container(s)                                                                                                                                    | `[]`                                 |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env variables for the Tensorflow Serving container(s)                                                                                                                 | `""`                                 |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env variables for the Tensorflow Serving container(s)                                                                                                                    | `""`                                 |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes                                                                                                                                                               | `[]`                                 |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Tensorflow Serving container(s)                                                                                                                  | `[]`                                 |
| `sidecars`                                          | Add additional sidecar containers to the pod                                                                                                                                                                      | `[]`                                 |
| `enableDefaultInitContainers`                       | Add default init containers to the deployment                                                                                                                                                                     | `true`                               |
| `initContainers`                                    | Add additional init containers to the pod                                                                                                                                                                         | `[]`                                 |
| `updateStrategy.type`                               | Deployment strategy type.                                                                                                                                                                                         | `RollingUpdate`                      |
| `priorityClassName`                                 | Pod's priorityClassName                                                                                                                                                                                           | `""`                                 |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                                 |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                                 |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`                              |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                                 |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                              |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`                                 |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `5`                                  |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                                  |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`                                  |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                                  |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                               |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `30`                                 |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `5`                                  |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                                  |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`                                  |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                                  |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                               |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `15`                                 |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `5`                                  |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`                                  |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`                                  |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                                  |
| `customStartupProbe`                                | Custom liveness probe                                                                                                                                                                                             | `{}`                                 |
| `customLivenessProbe`                               | Custom liveness probe                                                                                                                                                                                             | `{}`                                 |
| `customReadinessProbe`                              | Custom readiness probe                                                                                                                                                                                            | `{}`                                 |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for pod                                                                                                                                                                         | `true`                               |
| `serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                            | `""`                                 |
| `serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                            | `false`                              |
| `serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                              | `{}`                                 |
| `networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                               | `true`                               |
| `networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                        | `true`                               |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                   | `true`                               |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                                 |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                                 |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                            | `{}`                                 |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                        | `{}`                                 |
| `service.type`                                      | Kubernetes Service type                                                                                                                                                                                           | `LoadBalancer`                       |
| `service.ports.server`                              | TensorFlow Serving server port                                                                                                                                                                                    | `8500`                               |
| `service.ports.restApi`                             | TensorFlow Serving Rest API port                                                                                                                                                                                  | `8501`                               |
| `service.nodePorts.server`                          | Kubernetes server node port                                                                                                                                                                                       | `""`                                 |
| `service.nodePorts.restApi`                         | Kubernetes Rest API node port                                                                                                                                                                                     | `""`                                 |
| `service.clusterIP`                                 | Service Cluster IP                                                                                                                                                                                                | `""`                                 |
| `service.loadBalancerIP`                            | Service Load Balancer IP                                                                                                                                                                                          | `""`                                 |
| `service.loadBalancerSourceRanges`                  | Service Load Balancer sources                                                                                                                                                                                     | `[]`                                 |
| `service.externalTrafficPolicy`                     | Service external traffic policy                                                                                                                                                                                   | `Cluster`                            |
| `service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                    | `[]`                                 |
| `service.annotations`                               | Additional custom annotations for Service                                                                                                                                                                         | `{}`                                 |
| `service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                              | `None`                               |
| `service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                       | `{}`                                 |
| `metrics.enabled`                                   | Enable Prometheus exporter to expose Tensorflow server metrics                                                                                                                                                    | `false`                              |
| `metrics.podAnnotations`                            | Prometheus exporter pod annotations                                                                                                                                                                               | `{}`                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/tensorflow-resnet --set imagePullPolicy=Always
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/tensorflow-resnet
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/tensorflow-resnet/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 4.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 3.3.0

TensorFlow ResNet's version was updated to `2.7.0`. Although this new version [does not include breaking changes](https://github.com/tensorflow/serving/releases/tag/2.7.0), the client [was updated to work with newer TF Model Garden models](https://github.com/tensorflow/serving/commit/bb1428d53abb53fe938ddf9bb8839d4dfe48d291). Older models may need to adapt their signature [to the newer, common one](https://www.tensorflow.org/hub/common_signatures/images).

As a result, the pretrained model served by this Chart was updated to [Imagenet (ILSVRC-2012-CLS) classification with ResNet 50](https://tfhub.dev/tensorflow/resnet_50/classification/1).

### To 3.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 3.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is tensorflow-resnet:

```console
kubectl delete deployment  tensorflow-resnet --cascade=false
helm upgrade tensorflow-resnet oci://REGISTRY_NAME/REPOSITORY_NAME/tensorflow-resnet
kubectl delete rs "$(kubectl get rs -l app=tensorflow-resnet -o jsonpath='{.items[0].metadata.name}')"
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.