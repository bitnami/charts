<!--- app-name: Apache Flink -->

# Bitnami package for Apache Flink

Apache Flink is a framework and distributed processing engine for stateful computations over unbounded and bounded data streams.

[Overview of Apache Flink](https://flink.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/flink
```

Looking to use Apache Flink in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [flink](https://github.com/bitnami/containers/tree/main/bitnami/flink) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/flink
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy flink on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Persistence

The [Bitnami Flink](https://github.com/bitnami/containers/tree/main/bitnami/flink) image stores the trace onto an external database. Persistent Volume Claims are used to keep the data across deployments.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside each of the subsections: `jobmanager`, `taskmanager`.

```yaml
jobmanager:
  extraEnvVars:
    - name: ENV_VAR_NAME
      value: ENV_VAR_VALUE
taskmanager:
  extraEnvVars:
    - name: ENV_VAR_NAME
      value: ENV_VAR_VALUE
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as flink (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter inside each of the subsections: `jobmanager`, `taskmanager` .

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter (where available), as shown in the example below:

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> NOTE: This Helm chart already includes sidecar containers for the Prometheus exporters (where applicable). These can be activated by adding the `--enable-metrics=true` parameter at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers.

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside each of the subsections: `jobmanager`, `taskmanager`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `commonLabels`           | Labels to add to all deployed objects (sub-charts are not considered)                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Apache Flink parameters

| Name                | Description                                                                                                  | Value                   |
| ------------------- | ------------------------------------------------------------------------------------------------------------ | ----------------------- |
| `image.registry`    | Apache Flink image registry                                                                                  | `REGISTRY_NAME`         |
| `image.repository`  | Apache Flink image repository                                                                                | `REPOSITORY_NAME/flink` |
| `image.digest`      | Apache Flink image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `image.pullPolicy`  | image pull policy                                                                                            | `IfNotPresent`          |
| `image.pullSecrets` | Apache Flink image pull secrets                                                                              | `[]`                    |
| `image.debug`       | Enable image debug mode                                                                                      | `false`                 |

### Jobmanager deployment parameters

| Name                                                           | Description                                                                                                                                                                                                                             | Value            |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `jobmanager.command`                                           | Command for running the container (set to default if not set). Use array form                                                                                                                                                           | `[]`             |
| `jobmanager.args`                                              | Args for running the container (set to default if not set). Use array form                                                                                                                                                              | `[]`             |
| `jobmanager.lifecycleHooks`                                    | Override default etcd container hooks                                                                                                                                                                                                   | `{}`             |
| `jobmanager.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                      | `false`          |
| `jobmanager.hostAliases`                                       | Set pod host aliases                                                                                                                                                                                                                    | `[]`             |
| `jobmanager.extraEnvVars`                                      | Extra environment variables to be set on flink container                                                                                                                                                                                | `[]`             |
| `jobmanager.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                                    | `""`             |
| `jobmanager.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                                       | `""`             |
| `jobmanager.replicaCount`                                      | Number of Apache Flink Jobmanager replicas                                                                                                                                                                                              | `1`              |
| `jobmanager.livenessProbe.enabled`                             | Enable livenessProbe on Jobmanager nodes                                                                                                                                                                                                | `true`           |
| `jobmanager.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                 | `20`             |
| `jobmanager.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                        | `10`             |
| `jobmanager.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                       | `1`              |
| `jobmanager.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                     | `3`              |
| `jobmanager.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                     | `1`              |
| `jobmanager.startupProbe.enabled`                              | Enable startupProbe on Jobmanager containers                                                                                                                                                                                            | `true`           |
| `jobmanager.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                  | `20`             |
| `jobmanager.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                         | `10`             |
| `jobmanager.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                        | `1`              |
| `jobmanager.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                      | `15`             |
| `jobmanager.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                      | `1`              |
| `jobmanager.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                   | `true`           |
| `jobmanager.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                | `20`             |
| `jobmanager.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                       | `10`             |
| `jobmanager.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                      | `1`              |
| `jobmanager.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                    | `15`             |
| `jobmanager.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                    | `1`              |
| `jobmanager.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                     | `{}`             |
| `jobmanager.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                          | `{}`             |
| `jobmanager.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                        | `{}`             |
| `jobmanager.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if jobmanager.resources is set (jobmanager.resources is recommended for production). | `small`          |
| `jobmanager.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`             |
| `jobmanager.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for flink container                                                                                                                                                            | `[]`             |
| `jobmanager.containerPorts.rpc`                                | Port for RPC                                                                                                                                                                                                                            | `6123`           |
| `jobmanager.containerPorts.http`                               | Port for http UI                                                                                                                                                                                                                        | `8081`           |
| `jobmanager.containerPorts.blob`                               | Port for blob server                                                                                                                                                                                                                    | `6124`           |
| `jobmanager.service.type`                                      | Apache Flink service type                                                                                                                                                                                                               | `ClusterIP`      |
| `jobmanager.service.ports.rpc`                                 | Port for RPC                                                                                                                                                                                                                            | `6123`           |
| `jobmanager.service.ports.http`                                | Port for http UI                                                                                                                                                                                                                        | `8081`           |
| `jobmanager.service.ports.blob`                                | Port for blob server                                                                                                                                                                                                                    | `6124`           |
| `jobmanager.service.nodePorts.rpc`                             | Node port for RPC                                                                                                                                                                                                                       | `""`             |
| `jobmanager.service.nodePorts.http`                            | Node port for http UI                                                                                                                                                                                                                   | `""`             |
| `jobmanager.service.nodePorts.blob`                            | Port for blob server                                                                                                                                                                                                                    | `""`             |
| `jobmanager.service.extraPorts`                                | Extra ports to expose in the service (normally used with the `sidecar` value)                                                                                                                                                           | `[]`             |
| `jobmanager.service.loadBalancerIP`                            | LoadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                                        | `""`             |
| `jobmanager.service.loadBalancerSourceRanges`                  | Service Load Balancer sources                                                                                                                                                                                                           | `[]`             |
| `jobmanager.service.clusterIP`                                 | Service Cluster IP                                                                                                                                                                                                                      | `""`             |
| `jobmanager.service.externalTrafficPolicy`                     | Service external traffic policy                                                                                                                                                                                                         | `Cluster`        |
| `jobmanager.service.annotations`                               | Provide any additional annotations which may be required.                                                                                                                                                                               | `{}`             |
| `jobmanager.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                    | `None`           |
| `jobmanager.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                             | `{}`             |
| `jobmanager.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                     | `true`           |
| `jobmanager.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                              | `true`           |
| `jobmanager.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                         | `true`           |
| `jobmanager.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`             |
| `jobmanager.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`             |
| `jobmanager.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                  | `{}`             |
| `jobmanager.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                              | `{}`             |
| `jobmanager.serviceAccount.create`                             | Enables ServiceAccount                                                                                                                                                                                                                  | `true`           |
| `jobmanager.serviceAccount.name`                               | ServiceAccount name                                                                                                                                                                                                                     | `""`             |
| `jobmanager.serviceAccount.annotations`                        | Annotations to add to all deployed objects                                                                                                                                                                                              | `{}`             |
| `jobmanager.serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                                                                                                                        | `false`          |
| `jobmanager.podSecurityContext.enabled`                        | Enabled Apache Flink pods' Security Context                                                                                                                                                                                             | `true`           |
| `jobmanager.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                      | `Always`         |
| `jobmanager.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                          | `[]`             |
| `jobmanager.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                             | `[]`             |
| `jobmanager.podSecurityContext.fsGroup`                        | Set Apache Flink pod's Security Context fsGroup                                                                                                                                                                                         | `1001`           |
| `jobmanager.containerSecurityContext.enabled`                  | Enabled Apache Flink containers' Security Context                                                                                                                                                                                       | `true`           |
| `jobmanager.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                        | `{}`             |
| `jobmanager.containerSecurityContext.runAsUser`                | Set Apache Flink container's Security Context runAsUser                                                                                                                                                                                 | `1001`           |
| `jobmanager.containerSecurityContext.runAsGroup`               | Set Apache Flink container's Security Context runAsGroup                                                                                                                                                                                | `1001`           |
| `jobmanager.containerSecurityContext.runAsNonRoot`             | Force the container to be run as non root                                                                                                                                                                                               | `true`           |
| `jobmanager.containerSecurityContext.allowPrivilegeEscalation` | Allows privilege escalation                                                                                                                                                                                                             | `false`          |
| `jobmanager.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                 | `true`           |
| `jobmanager.containerSecurityContext.privileged`               | Set primary container's Security Context privileged                                                                                                                                                                                     | `false`          |
| `jobmanager.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                      | `["ALL"]`        |
| `jobmanager.containerSecurityContext.seccompProfile.type`      | Rules specifying actions to take based on the requested syscall                                                                                                                                                                         | `RuntimeDefault` |
| `jobmanager.podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                                              | `{}`             |
| `jobmanager.podLabels`                                         | Additional pod labels                                                                                                                                                                                                                   | `{}`             |
| `jobmanager.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                     | `""`             |
| `jobmanager.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                | `soft`           |
| `jobmanager.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                               | `""`             |
| `jobmanager.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                                   | `""`             |
| `jobmanager.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                                | `[]`             |
| `jobmanager.priorityClassName`                                 | Server priorityClassName                                                                                                                                                                                                                | `""`             |
| `jobmanager.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                             | `{}`             |
| `jobmanager.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                          | `{}`             |
| `jobmanager.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                          | `[]`             |
| `jobmanager.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                          | `[]`             |
| `jobmanager.schedulerName`                                     | Alternative scheduler                                                                                                                                                                                                                   | `""`             |
| `jobmanager.updateStrategy.type`                               | Apache Flink jobmanager deployment strategy type                                                                                                                                                                                        | `RollingUpdate`  |
| `jobmanager.updateStrategy.rollingUpdate`                      | Apache Flink jobmanager deployment rolling update configuration parameters                                                                                                                                                              | `nil`            |
| `jobmanager.extraVolumes`                                      | Optionally specify extra list of additional volumes for flink container                                                                                                                                                                 | `[]`             |
| `jobmanager.initContainers`                                    | Add additional init containers to the flink pods                                                                                                                                                                                        | `[]`             |
| `jobmanager.sidecars`                                          | Add additional sidecar containers to the flink pods                                                                                                                                                                                     | `[]`             |

### TaskManager deployment parameters

| Name                                                            | Description                                                                                                                                                                                                                               | Value            |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `taskmanager.command`                                           | Command for running the container (set to default if not set). Use array form                                                                                                                                                             | `[]`             |
| `taskmanager.args`                                              | Args for running the container (set to default if not set). Use array form                                                                                                                                                                | `[]`             |
| `taskmanager.lifecycleHooks`                                    | Override default etcd container hooks                                                                                                                                                                                                     | `{}`             |
| `taskmanager.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                        | `false`          |
| `taskmanager.hostAliases`                                       | Set pod host aliases                                                                                                                                                                                                                      | `[]`             |
| `taskmanager.extraEnvVars`                                      | Extra environment variables to be set on flink container                                                                                                                                                                                  | `[]`             |
| `taskmanager.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                                      | `""`             |
| `taskmanager.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                                         | `""`             |
| `taskmanager.replicaCount`                                      | Number of Apache Flink replicas                                                                                                                                                                                                           | `1`              |
| `taskmanager.livenessProbe.enabled`                             | Enable livenessProbe on taskmanager nodes                                                                                                                                                                                                 | `true`           |
| `taskmanager.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                   | `20`             |
| `taskmanager.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                          | `10`             |
| `taskmanager.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                         | `1`              |
| `taskmanager.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                       | `3`              |
| `taskmanager.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                       | `1`              |
| `taskmanager.startupProbe.enabled`                              | Enable startupProbe on taskmanager containers                                                                                                                                                                                             | `true`           |
| `taskmanager.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                    | `20`             |
| `taskmanager.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                           | `10`             |
| `taskmanager.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                          | `1`              |
| `taskmanager.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                        | `15`             |
| `taskmanager.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                        | `1`              |
| `taskmanager.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                     | `true`           |
| `taskmanager.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                  | `20`             |
| `taskmanager.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                         | `10`             |
| `taskmanager.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                        | `1`              |
| `taskmanager.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                      | `15`             |
| `taskmanager.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                      | `1`              |
| `taskmanager.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                       | `{}`             |
| `taskmanager.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                            | `{}`             |
| `taskmanager.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                          | `{}`             |
| `taskmanager.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if taskmanager.resources is set (taskmanager.resources is recommended for production). | `small`          |
| `taskmanager.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                         | `{}`             |
| `taskmanager.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for flink container                                                                                                                                                              | `[]`             |
| `taskmanager.containerPorts.data`                               | data exchange port                                                                                                                                                                                                                        | `6121`           |
| `taskmanager.containerPorts.rpc`                                | Port for RPC                                                                                                                                                                                                                              | `6122`           |
| `taskmanager.containerPorts.internalMetrics`                    | Port for internal metrics query service                                                                                                                                                                                                   | `6126`           |
| `taskmanager.service.type`                                      | Apache Flink service type                                                                                                                                                                                                                 | `ClusterIP`      |
| `taskmanager.service.ports.data`                                | data exchange port                                                                                                                                                                                                                        | `6121`           |
| `taskmanager.service.ports.rpc`                                 | Port for RPC                                                                                                                                                                                                                              | `6122`           |
| `taskmanager.service.ports.internalMetrics`                     | Port for internal metrics query service                                                                                                                                                                                                   | `6126`           |
| `taskmanager.service.nodePorts.data`                            | data exchange port                                                                                                                                                                                                                        | `""`             |
| `taskmanager.service.nodePorts.rpc`                             | Port for RPC                                                                                                                                                                                                                              | `""`             |
| `taskmanager.service.nodePorts.internalMetrics`                 | Port for internal metrics query service                                                                                                                                                                                                   | `""`             |
| `taskmanager.service.extraPorts`                                | Extra ports to expose in the service (normally used with the `sidecar` value)                                                                                                                                                             | `[]`             |
| `taskmanager.service.loadBalancerIP`                            | LoadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                                          | `""`             |
| `taskmanager.service.loadBalancerSourceRanges`                  | Service Load Balancer sources                                                                                                                                                                                                             | `[]`             |
| `taskmanager.service.clusterIP`                                 | Service Cluster IP                                                                                                                                                                                                                        | `""`             |
| `taskmanager.service.externalTrafficPolicy`                     | Service external traffic policy                                                                                                                                                                                                           | `Cluster`        |
| `taskmanager.service.annotations`                               | Provide any additional annotations which may be required.                                                                                                                                                                                 | `{}`             |
| `taskmanager.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                      | `None`           |
| `taskmanager.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                               | `{}`             |
| `taskmanager.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                       | `true`           |
| `taskmanager.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                                | `true`           |
| `taskmanager.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                           | `true`           |
| `taskmanager.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                              | `[]`             |
| `taskmanager.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                              | `[]`             |
| `taskmanager.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                    | `{}`             |
| `taskmanager.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                                | `{}`             |
| `taskmanager.serviceAccount.create`                             | Enables ServiceAccount                                                                                                                                                                                                                    | `true`           |
| `taskmanager.serviceAccount.name`                               | ServiceAccount name                                                                                                                                                                                                                       | `""`             |
| `taskmanager.serviceAccount.annotations`                        | Annotations to add to all deployed objects                                                                                                                                                                                                | `{}`             |
| `taskmanager.serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                                                                                                                          | `false`          |
| `taskmanager.podSecurityContext.enabled`                        | Enabled Apache Flink pods' Security Context                                                                                                                                                                                               | `true`           |
| `taskmanager.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                        | `Always`         |
| `taskmanager.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                            | `[]`             |
| `taskmanager.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                               | `[]`             |
| `taskmanager.podSecurityContext.fsGroup`                        | Set Apache Flink pod's Security Context fsGroup                                                                                                                                                                                           | `1001`           |
| `taskmanager.containerSecurityContext.enabled`                  | Enabled Apache Flink containers' Security Context                                                                                                                                                                                         | `true`           |
| `taskmanager.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                          | `{}`             |
| `taskmanager.containerSecurityContext.runAsUser`                | Set Apache Flink container's Security Context runAsUser                                                                                                                                                                                   | `1001`           |
| `taskmanager.containerSecurityContext.runAsGroup`               | Set Apache Flink container's Security Context runAsGroup                                                                                                                                                                                  | `1001`           |
| `taskmanager.containerSecurityContext.runAsNonRoot`             | Force the container to be run as non root                                                                                                                                                                                                 | `true`           |
| `taskmanager.containerSecurityContext.privileged`               | Set primary container's Security Context privileged                                                                                                                                                                                       | `false`          |
| `taskmanager.containerSecurityContext.allowPrivilegeEscalation` | Allows privilege escalation                                                                                                                                                                                                               | `false`          |
| `taskmanager.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                   | `true`           |
| `taskmanager.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                        | `["ALL"]`        |
| `taskmanager.containerSecurityContext.seccompProfile.type`      | Rules specifying actions to take based on the requested syscall                                                                                                                                                                           | `RuntimeDefault` |
| `taskmanager.podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                                                | `{}`             |
| `taskmanager.podLabels`                                         | Additional pod labels                                                                                                                                                                                                                     | `{}`             |
| `taskmanager.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                       | `""`             |
| `taskmanager.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                  | `soft`           |
| `taskmanager.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                 | `""`             |
| `taskmanager.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                                     | `""`             |
| `taskmanager.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                                  | `[]`             |
| `taskmanager.priorityClassName`                                 | Server priorityClassName                                                                                                                                                                                                                  | `""`             |
| `taskmanager.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                               | `{}`             |
| `taskmanager.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                            | `{}`             |
| `taskmanager.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                            | `[]`             |
| `taskmanager.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                            | `[]`             |
| `taskmanager.schedulerName`                                     | Alternative scheduler                                                                                                                                                                                                                     | `""`             |
| `taskmanager.podManagementPolicy`                               | Pod management policy for the Apache Flink taskmanager statefulset                                                                                                                                                                        | `Parallel`       |
| `taskmanager.updateStrategy.type`                               | Apache Flink taskmanager statefulset strategy type                                                                                                                                                                                        | `RollingUpdate`  |
| `taskmanager.updateStrategy.rollingUpdate`                      | Apache Flink taskmanager statefulset rolling update configuration parameters                                                                                                                                                              | `nil`            |
| `taskmanager.extraVolumes`                                      | Optionally specify extra list of additional volumes for flink container                                                                                                                                                                   | `[]`             |
| `taskmanager.initContainers`                                    | Add additional init containers to the flink pods                                                                                                                                                                                          | `[]`             |
| `taskmanager.sidecars`                                          | Add additional sidecar containers to the flink pods                                                                                                                                                                                       | `[]`             |

## Upgrading

### To 1.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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