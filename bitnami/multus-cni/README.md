<!--- app-name: Multus CNI -->

# Bitnami package for Multus CNI

Multus is a CNI plugin for Kubernetes clusters. Written in Go, features adding multiple network interfaces to pods.

[Overview of Multus CNI](https://github.com/k8snetworkplumbingwg/multus-cni)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/multus-cni
```

Looking to use Multus CNI in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Multus CNI](https://github.com/bitnami/containers/tree/main/bitnami/multus-cni) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/multus-cni
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Multus CNI on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Host configuration

Once installed, the helm chart will modify configuration files in the host nodes of the Kubernetes cluster. Ensure that the cluster allows root and privileged deployments.

Once the multus-cni configuration is installed, check the [upstream Kubernetes documentation](https://kubernetes.io/docs/concepts/cluster-administration/networking/) on how to modify the network settings of the cluster.

> **Important**: Double check that the host CNI binary and configuration directories are properly configured, or the deployment will fail. This is done using the `hostCNINetDir` and `hostCNIBinDir` values.

### Image

The `image` parameter allows specifying which image will be pulled for the chart.

#### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
2. Note that the `imagePullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:

    ```yaml
    imagePullSecrets:
      - name: SECRET_NAME
    ```

3. Install the chart

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                                                    | Value          |
| ------------------------ | -------------------------------------------------------------------------------------------------------------- | -------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                           | `""`           |
| `nameOverride`           | String to partially override multus-cni.fullname template (will maintain the release name)                     | `""`           |
| `fullnameOverride`       | String to fully override multus-cni.fullname template                                                          | `""`           |
| `namespaceOverride`      | String to fully override common.names.namespace                                                                | `""`           |
| `commonAnnotations`      | Common annotations to add to all Multus CNI resources (sub-charts are not considered). Evaluated as a template | `{}`           |
| `commonLabels`           | Common labels to add to all Multus CNI resources (sub-charts are not considered). Evaluated as a template      | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template).                                   | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                        | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                           | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                              | `["infinity"]` |

### Multus CNI parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                        |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `image.registry`                                    | Multus CNI image registry                                                                                                                                                                                         | `REGISTRY_NAME`              |
| `image.repository`                                  | Multus CNI Image name                                                                                                                                                                                             | `REPOSITORY_NAME/multus-cni` |
| `image.digest`                                      | Multus CNI image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                        | `""`                         |
| `image.pullPolicy`                                  | Multus CNI image pull policy                                                                                                                                                                                      | `IfNotPresent`               |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                         |
| `image.debug`                                       | Specify if debug logs should be enabled                                                                                                                                                                           | `false`                      |
| `CNIVersion`                                        | CNI version                                                                                                                                                                                                       | `0.3.0`                      |
| `hostCNIBinDir`                                     | CNI binary dir in the host machine to mount                                                                                                                                                                       | `/opt/cni/bin`               |
| `hostCNINetDir`                                     | CNI net.d dir in the host machine to mount                                                                                                                                                                        | `/etc/cni/net.d`             |
| `CNIMountPath`                                      | Path inside the container to mount the CNI dirs                                                                                                                                                                   | `/bitnami/multus-cni/host`   |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                         |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                         |
| `updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                    | `RollingUpdate`              |
| `priorityClassName`                                 | Multus CNI pods' priorityClassName                                                                                                                                                                                | `""`                         |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                         |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                         |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`                       |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                         |
| `extraEnvVars`                                      | Extra environment variables                                                                                                                                                                                       | `[]`                         |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars                                                                                                                                                                               | `""`                         |
| `extraEnvVarsSecret`                                | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                      | `""`                         |
| `extraVolumes`                                      | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                | `[]`                         |
| `extraVolumeMounts`                                 | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.                                                                                             | `[]`                         |
| `initContainers`                                    | Add additional init containers to the pod (evaluated as a template)                                                                                                                                               | `[]`                         |
| `sidecars`                                          | Attach additional containers to the pod (evaluated as a template)                                                                                                                                                 | `[]`                         |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                         |
| `networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                               | `true`                       |
| `networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                | `[]`                         |
| `networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                        | `true`                       |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                   | `true`                       |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                         |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                         |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                            | `{}`                         |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                        | `{}`                         |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                         |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                       |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                         |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                         |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                         |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                         |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`                         |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                       |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                         |
| `podSecurityContext.enabled`                        | Enable Multus CNI pods' Security Context                                                                                                                                                                          | `true`                       |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                     |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                         |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                         |
| `podSecurityContext.fsGroup`                        | Multus CNI pods' group ID                                                                                                                                                                                         | `0`                          |
| `containerSecurityContext.enabled`                  | Enable Multus CNI containers' Security Context                                                                                                                                                                    | `true`                       |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                         |
| `containerSecurityContext.runAsUser`                | Multus CNI containers' Security Context                                                                                                                                                                           | `0`                          |
| `containerSecurityContext.runAsGroup`               | Multus CNI containers' Security Context                                                                                                                                                                           | `0`                          |
| `containerSecurityContext.runAsNonRoot`             | Set Multus CNI container's Security Context runAsNonRoot                                                                                                                                                          | `false`                      |
| `containerSecurityContext.privileged`               | Set Multus CNI container's Security Context privileged                                                                                                                                                            | `true`                       |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `true`                       |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                       |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                    |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`             |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                      |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`                         |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                         |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                          |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `5`                          |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                          |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                       |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `10`                         |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                         |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                          |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `5`                          |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                          |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                       |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `10`                         |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `5`                          |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                          |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `5`                          |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                          |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                         |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                         |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                         |
| `lifecycleHooks`                                    | LifecycleHook to set additional configuration at startup Evaluated as a template                                                                                                                                  | `{}`                         |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                         |
| `podLabels`                                         | Add additional labels to the pod (evaluated as a template)                                                                                                                                                        | `{}`                         |

### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                     | `true`  |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Multus CNI pod                   | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set schedulerName=high-priority \
    oci://REGISTRY_NAME/REPOSITORY_NAME/multus-cni
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Multus CNI scheduler to high-priority.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/multus-cni
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/multus-cni/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 2.0.0

This major bump changes the following security defaults:

- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

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