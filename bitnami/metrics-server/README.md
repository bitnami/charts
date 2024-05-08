<!--- app-name: Metrics Server -->

# Bitnami package for Metrics Server

Metrics Server aggregates resource usage data, such as container CPU and memory usage, in a Kubernetes cluster and makes it available via the Metrics API.

[Overview of Metrics Server](https://github.com/kubernetes-incubator/metrics-server)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/metrics-server
```

Looking to use Metrics Server in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Metrics Server](https://github.com/bitnami/containers/tree/main/bitnami/metrics-server) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/metrics-server
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Metrics Server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Enable RBAC security

In order to enable Role-Based Access Control (RBAC) for Metrics Server, use the following parameter: `rbac.create=true`.

### Configure certificates

If you are providing your own certificates for the API Service, set `insecureSkipTLSVerify` to `"false"`, and provide a `caBundle` consisting of the base64-encoded certificate chain.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

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
| `namespaceOverride`      | String to fully override common.names.namespace                                              | `""`           |
| `commonLabels`           | Add labels to all the deployed resources                                                     | `{}`           |
| `commonAnnotations`      | Add annotations to all the deployed resources                                                | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`        |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)                   | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                      | `["infinity"]` |

### Metrics Server parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `image.registry`                                    | Metrics Server image registry                                                                                                                                                                                     | `REGISTRY_NAME`                  |
| `image.repository`                                  | Metrics Server image repository                                                                                                                                                                                   | `REPOSITORY_NAME/metrics-server` |
| `image.digest`                                      | Metrics Server image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                    | `""`                             |
| `image.pullPolicy`                                  | Metrics Server image pull policy                                                                                                                                                                                  | `IfNotPresent`                   |
| `image.pullSecrets`                                 | Metrics Server image pull secrets                                                                                                                                                                                 | `[]`                             |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`                           |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                             |
| `replicas`                                          | Number of metrics-server nodes to deploy                                                                                                                                                                          | `1`                              |
| `updateStrategy.type`                               | Set up update strategy for metrics-server installation.                                                                                                                                                           | `RollingUpdate`                  |
| `rbac.create`                                       | Enable RBAC authentication                                                                                                                                                                                        | `true`                           |
| `serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                              | `true`                           |
| `serviceAccount.name`                               | The name of the ServiceAccount to create                                                                                                                                                                          | `""`                             |
| `serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account                                                                                                                                                                   | `false`                          |
| `serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                        | `{}`                             |
| `apiService.create`                                 | Specifies whether the v1beta1.metrics.k8s.io API service should be created. You can check if it is needed with `kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"`.                                          | `false`                          |
| `apiService.insecureSkipTLSVerify`                  | Specifies whether to skip self-verifying self-signed TLS certificates. Set to "false" if you are providing your own certificates.                                                                                 | `true`                           |
| `apiService.caBundle`                               | A base64-encoded string of concatenated certificates for the CA chain for the APIService.                                                                                                                         | `""`                             |
| `containerPorts.https`                              | Port where metrics-server will be running                                                                                                                                                                         | `8443`                           |
| `hostNetwork`                                       | Enable hostNetwork mode                                                                                                                                                                                           | `false`                          |
| `dnsPolicy`                                         | Default dnsPolicy setting                                                                                                                                                                                         | `ClusterFirst`                   |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                             |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                             |
| `lifecycleHooks`                                    | for the metrics-server container(s) to automate configuration before or after startup                                                                                                                             | `{}`                             |
| `extraEnvVars`                                      | Array with extra environment variables to add to metrics-server nodes                                                                                                                                             | `[]`                             |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for metrics-server nodes                                                                                                                                     | `""`                             |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for metrics-server nodes                                                                                                                                        | `""`                             |
| `extraArgs`                                         | Extra arguments to pass to metrics-server on start up                                                                                                                                                             | `[]`                             |
| `sidecars`                                          | Add additional sidecar containers to the metrics-server pod(s)                                                                                                                                                    | `[]`                             |
| `initContainers`                                    | Add additional init containers to the metrics-server pod(s)                                                                                                                                                       | `[]`                             |
| `podLabels`                                         | Pod labels                                                                                                                                                                                                        | `{}`                             |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                             |
| `priorityClassName`                                 | Priority class for pod scheduling                                                                                                                                                                                 | `""`                             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                             |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the metrics-server pod needs to terminate gracefully                                                                                                                                | `""`                             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                           |
| `pdb.create`                                        | Create a PodDisruptionBudget                                                                                                                                                                                      | `false`                          |
| `pdb.minAvailable`                                  | Minimum available instances                                                                                                                                                                                       | `""`                             |
| `pdb.maxUnavailable`                                | Maximum unavailable instances                                                                                                                                                                                     | `""`                             |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`                             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                             |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                             |
| `topologySpreadConstraints`                         | Topology spread constraints for pod                                                                                                                                                                               | `[]`                             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                             |
| `service.type`                                      | Kubernetes Service type                                                                                                                                                                                           | `ClusterIP`                      |
| `service.ports.https`                               | Kubernetes Service port                                                                                                                                                                                           | `443`                            |
| `service.nodePorts.https`                           | Kubernetes Service port                                                                                                                                                                                           | `""`                             |
| `service.clusterIP`                                 | metrics-server service Cluster IP                                                                                                                                                                                 | `""`                             |
| `service.loadBalancerIP`                            | LoadBalancer IP if Service type is `LoadBalancer`                                                                                                                                                                 | `""`                             |
| `service.loadBalancerSourceRanges`                  | metrics-server service Load Balancer sources                                                                                                                                                                      | `[]`                             |
| `service.externalTrafficPolicy`                     | metrics-server service external traffic policy                                                                                                                                                                    | `Cluster`                        |
| `service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                    | `[]`                             |
| `service.annotations`                               | Annotations for the Service                                                                                                                                                                                       | `{}`                             |
| `service.labels`                                    | Labels for the Service                                                                                                                                                                                            | `{}`                             |
| `service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                              | `None`                           |
| `service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                       | `{}`                             |
| `networkPolicy.enabled`                             | Enable creation of NetworkPolicy resources                                                                                                                                                                        | `true`                           |
| `networkPolicy.allowExternal`                       | The Policy model to apply                                                                                                                                                                                         | `true`                           |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                   | `true`                           |
| `networkPolicy.kubernetesPorts`                     | List of possible endpoints to kubernetes components like kube-apiserver or kubelet (limit to your cluster settings to increase security)                                                                          | `[]`                             |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                             |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                             |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                            | `{}`                             |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                        | `{}`                             |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                           |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                             |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `0`                              |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`                              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `3`                              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                              |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `0`                              |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`                              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `3`                              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                              |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `0`                              |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`                              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                              |
| `customStartupProbe`                                | Custom liveness probe for the Web component                                                                                                                                                                       | `{}`                             |
| `customLivenessProbe`                               | Custom Liveness probes for metrics-server                                                                                                                                                                         | `{}`                             |
| `customReadinessProbe`                              | Custom Readiness probes metrics-server                                                                                                                                                                            | `{}`                             |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                             |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                           |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                 |
| `podSecurityContext.enabled`                        | Pod security context                                                                                                                                                                                              | `true`                           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                             |
| `podSecurityContext.fsGroup`                        | Set %%MAIN_CONTAINER_NAME%% pod's Security Context fsGroup                                                                                                                                                        | `1001`                           |
| `extraVolumes`                                      | Extra volumes                                                                                                                                                                                                     | `[]`                             |
| `extraVolumeMounts`                                 | Mount extra volume(s)                                                                                                                                                                                             | `[]`                             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set rbac.create=true oci://REGISTRY_NAME/REPOSITORY_NAME/metrics-server
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command enables RBAC authentication.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/metrics-server
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/metrics-server/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 7.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 6.0.0

This major release renames several values in this chart and adds missing features, in order to be aligned with the rest of the assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated. We recommend using `service.ports.http` instead.
- `service.nodePort` was deprecated. We recommend using `service.nodePorts.https` instead.
- `extraArgs` is now interpreted as an array.

### To 5.2.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 5.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 4.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 4.0.0. The following example assumes that the release name is metrics-server:

```console
kubectl delete deployment metrics-server --cascade=false
helm upgrade metrics-server oci://REGISTRY_NAME/REPOSITORY_NAME/metrics-server
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is metrics-server:

```console
kubectl patch deployment metrics-server --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```

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