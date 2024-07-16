<!--- app-name: Node Exporter -->

# Bitnami package for Node Exporter

Prometheus exporter for hardware and OS metrics exposed by UNIX kernels, with pluggable metric collectors.

[Overview of Node Exporter](https://prometheus.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/node-exporter
```

Looking to use Node Exporter in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps [Node Exporter](https://github.com/bitnami/containers/tree/main/bitnami/node-exporter) on [Kubernetes](https://kubernetes.io) using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/node-exporter
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Node Exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration-and-installation-details) section lists the parameters that can be configured during installation.

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Resource Type

This chart, by default, installs Node Exporter as a `DaemonSet`. There are some cases where you may need to run Node Exporter as a `Deployment` (e.g., when using its textfile collector exclusively). In these instances, you can install the helm chart by setting the `resourceType` parameter to `Deployment`.

Installing the Node Exporter chart in `Deployment` mode will overwrite `hostNetwork` and `hostPid` to `false` and will not mount `/proc` and `/sys` from the host to the container. You can control this behavior by setting the `isolatedDeployment` parameter.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`   |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override `common.names.fullname` template with a string                      | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                              | `""`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                   | `{}`            |
| `commonLabels`           | Labels to add to all deployed objects                                                        | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                               | `cluster.local` |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)                   | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                      | `["infinity"]`  |

### Node Exporter parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                           |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `resourceType`                                      | Specify how to deploy Node Exporter (allowed values: `daemonset` and `deployment`)                                                                                                                                | `daemonset`                     |
| `replicaCount`                                      | Number of replicas to deploy (when `resourceType` is `deployment`)                                                                                                                                                | `1`                             |
| `isolatedDeployment`                                | Specify whether to deploy the Node Exporter in an isolated deployment without access to host network, host PID and /proc and /sys of the host. (when `resourceType` is `deployment`)                              | `true`                          |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                         |
| `hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                       | `[]`                            |
| `rbac.create`                                       | Whether to create and use RBAC resources or not                                                                                                                                                                   | `true`                          |
| `rbac.pspEnabled`                                   | Whether to create a PodSecurityPolicy and bound it with RBAC. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later                                                | `true`                          |
| `serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                              | `true`                          |
| `serviceAccount.name`                               | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                                                               | `""`                            |
| `serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                    | `false`                         |
| `serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                        | `{}`                            |
| `image.registry`                                    | Node Exporter image registry                                                                                                                                                                                      | `REGISTRY_NAME`                 |
| `image.repository`                                  | Node Exporter image repository                                                                                                                                                                                    | `REPOSITORY_NAME/node-exporter` |
| `image.digest`                                      | Node Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                     | `""`                            |
| `image.pullPolicy`                                  | Node Exporter image pull policy                                                                                                                                                                                   | `IfNotPresent`                  |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                            |
| `containerPorts.metrics`                            | Node Exporter container port                                                                                                                                                                                      | `9100`                          |
| `sidecars`                                          | Add additional sidecar containers to the Node exporter pod(s)                                                                                                                                                     | `[]`                            |
| `initContainers`                                    | Add additional init containers to the Node exporter pod(s)                                                                                                                                                        | `[]`                            |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`                          |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `""`                            |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                                    | `""`                            |
| `extraArgs`                                         | Additional command line arguments to pass to node-exporter                                                                                                                                                        | `{}`                            |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                            |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                            |
| `lifecycleHooks`                                    | for the Node exporter container(s) to automate configuration before or after startup                                                                                                                              | `{}`                            |
| `extraEnvVars`                                      | Array with extra environment variables to add to Node exporter container                                                                                                                                          | `[]`                            |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Node exporter container                                                                                                                                  | `""`                            |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Node exporter container                                                                                                                                     | `""`                            |
| `extraVolumes`                                      | Additional volumes to the node-exporter pods                                                                                                                                                                      | `[]`                            |
| `extraVolumeMounts`                                 | Additional volumeMounts to the node-exporter container                                                                                                                                                            | `[]`                            |
| `podSecurityContext.enabled`                        | Enabled Node exporter pods' Security Context                                                                                                                                                                      | `true`                          |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                        |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                            |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                            |
| `podSecurityContext.fsGroup`                        | Set Node exporter pod's Security Context fsGroup                                                                                                                                                                  | `1001`                          |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                          |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                            |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                          |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                          |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                          |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                         |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                          |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                         |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                       |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                |
| `service.type`                                      | Kubernetes service type                                                                                                                                                                                           | `ClusterIP`                     |
| `service.ports.metrics`                             | Node Exporter metrics service port                                                                                                                                                                                | `9100`                          |
| `service.nodePorts.metrics`                         | Specify the nodePort value for the LoadBalancer and NodePort service types                                                                                                                                        | `""`                            |
| `service.clusterIP`                                 | Specific cluster IP when service type is cluster IP. Use `None` for headless service                                                                                                                              | `""`                            |
| `service.loadBalancerIP`                            | `loadBalancerIP` if service type is `LoadBalancer`                                                                                                                                                                | `""`                            |
| `service.loadBalancerSourceRanges`                  | Address that are allowed when service is `LoadBalancer`                                                                                                                                                           | `[]`                            |
| `service.externalTrafficPolicy`                     | Node exporter service external traffic policy                                                                                                                                                                     | `Cluster`                       |
| `service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                    | `[]`                            |
| `service.addPrometheusScrapeAnnotation`             | Add the `prometheus.io/scrape: "true"` annotation to the service                                                                                                                                                  | `true`                          |
| `service.annotations`                               | Additional annotations for Node Exporter service                                                                                                                                                                  | `{}`                            |
| `service.labels`                                    | Additional labels for Node Exporter service                                                                                                                                                                       | `{}`                            |
| `service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                              | `None`                          |
| `service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                       | `{}`                            |
| `networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                               | `true`                          |
| `networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                        | `true`                          |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                   | `true`                          |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                            |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                            |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                            | `{}`                            |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                        | `{}`                            |
| `updateStrategy.type`                               | The update strategy type to apply to the DaemonSet                                                                                                                                                                | `RollingUpdate`                 |
| `updateStrategy.rollingUpdate.maxUnavailable`       | Maximum number of pods that may be made unavailable                                                                                                                                                               | `1`                             |
| `hostNetwork`                                       | Expose the service to the host network                                                                                                                                                                            | `true`                          |
| `hostPID`                                           | Allows visibility of processes on the host, potentially leaking information such as environment variables and configuration                                                                                       | `true`                          |
| `minReadySeconds`                                   | `minReadySeconds` to avoid killing pods before we are ready                                                                                                                                                       | `0`                             |
| `priorityClassName`                                 | Priority class assigned to the Pods                                                                                                                                                                               | `""`                            |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the Node exporter pod needs to terminate gracefully                                                                                                                                 | `""`                            |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                            |
| `podLabels`                                         | Pod labels                                                                                                                                                                                                        | `{}`                            |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                            |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                            |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                          |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                            |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                            |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                            |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                             | `{}`                            |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`                            |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                          | `[]`                            |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                          |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `120`                           |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                            |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                             |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`                             |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                             |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                          |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`                            |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                            |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`                             |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`                             |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                             |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                         |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`                            |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                            |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                             |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`                             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                             |
| `customStartupProbe`                                | Custom liveness probe for the Node exporter container                                                                                                                                                             | `{}`                            |
| `customLivenessProbe`                               | Custom liveness probe for the Node exporter container                                                                                                                                                             | `{}`                            |
| `customReadinessProbe`                              | Custom readiness probe for the Node exporter container                                                                                                                                                            | `{}`                            |
| `serviceMonitor.enabled`                            | Creates a ServiceMonitor to monitor Node Exporter                                                                                                                                                                 | `false`                         |
| `serviceMonitor.namespace`                          | Namespace in which Prometheus is running                                                                                                                                                                          | `""`                            |
| `serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                 | `""`                            |
| `serviceMonitor.interval`                           | Scrape interval (use by default, falling back to Prometheus' default)                                                                                                                                             | `""`                            |
| `serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                                                                           | `""`                            |
| `serviceMonitor.basicAuth`                          | Use basic auth for scraping                                                                                                                                                                                       | `{}`                            |
| `serviceMonitor.selector`                           | ServiceMonitor selector labels                                                                                                                                                                                    | `{}`                            |
| `serviceMonitor.relabelings`                        | RelabelConfigs to apply to samples before scraping                                                                                                                                                                | `[]`                            |
| `serviceMonitor.metricRelabelings`                  | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                         | `[]`                            |
| `serviceMonitor.labels`                             | Extra labels for the ServiceMonitor                                                                                                                                                                               | `{}`                            |
| `serviceMonitor.honorLabels`                        | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                          | `false`                         |
| `serviceMonitor.attachMetadata`                     | Attaches node metadata to discovered targets                                                                                                                                                                      | `{}`                            |
| `serviceMonitor.sampleLimit`                        | Per-scrape limit on number of scraped samples that will be accepted.                                                                                                                                              | `""`                            |
| `podSecurityPolicy.annotations`                     | Annotations for Pod Security Policy. Evaluated as a template.                                                                                                                                                     | `{}`                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example the following command sets the `minReadySeconds` of the Node Exporter Pods to `120` seconds.

```console
helm install my-release --set minReadySeconds=120 oci://REGISTRY_NAME/REPOSITORY_NAME/node-exporter
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/node-exporter
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/node-exporter/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/node-exporter
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 4.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 3.0.0

This major release renames several values in this chart and adds missing features, in order to be aligned with the rest of the assets in the Bitnami charts repository.

Affected values:

- `service.port` was renamed as `service.ports.metrics`.
- `service.targetPort` was renamed as `containerPorts.metrics`.
- `service.nodePort` was renamed as `service.nodePorts.metrics`.
- `securityContext` was split in `podSecurityContext` and `containerSecurityContext`.
- Removed unused value `rbac.apiVersion`.

### To 2.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 2.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

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