<!--- app-name: Jaeger -->

# Bitnami package for Jaeger

Jaeger is a distributed tracing system. It is used for monitoring and troubleshooting microservices-based distributed systems.

[Overview of Jaeger](https://jaegertracing.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/jaeger
```

Looking to use Jaeger in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Introduction

This chart bootstraps a [jaeger](https://github.com/bitnami/containers/tree/main/bitnami/jaeger) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/jaeger
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy jaeger on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all history too.

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### External database support

You may want to have Jaeger connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#parameters). You should also disable the Cassandra installation with the `cassandra.enabled` option. Here is an example:

```console
cassandra.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.port=9042
```

The Jaeger keyspace needs to be created in the external Cassandra database prior to the deployment, otherwise Jaeger won't be able to initialise.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside each of the subsections: `collector`, `query`.

```yaml
collector:
  extraEnvVars:
    - name: ENV_VAR_NAME
      value: ENV_VAR_VALUE

query:
  extraEnvVars:
    - name: ENV_VAR_NAME
      value: ENV_VAR_VALUE
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as jaeger (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter inside each of the subsections: `collector`, `query` .

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

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside each of the subsections: `distributor`, `compactor`, `ingester`, `querier`, `queryFrontend` and `vulture`.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami jaeger](https://github.com/bitnami/containers/tree/main/bitnami/jaeger) image stores the trace onto an external database. Persistent Volume Claims are used to keep the data across deployments.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                     | Description                                                                             | Value          |
| ------------------------ | --------------------------------------------------------------------------------------- | -------------- |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`           |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`           |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`           |
| `commonLabels`           | Labels to add to all deployed objects (sub-charts are not considered)                   | `{}`           |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]` |

### Jaeger parameters

| Name                | Description                                                                                            | Value                    |
| ------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------ |
| `image.registry`    | Jaeger image registry                                                                                  | `REGISTRY_NAME`          |
| `image.repository`  | Jaeger image repository                                                                                | `REPOSITORY_NAME/jaeger` |
| `image.digest`      | Jaeger image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                     |
| `image.pullPolicy`  | image pull policy                                                                                      | `IfNotPresent`           |
| `image.pullSecrets` | Jaeger image pull secrets                                                                              | `[]`                     |
| `image.debug`       | Enable image debug mode                                                                                | `false`                  |

### Query deployment parameters

| Name                                                      | Description                                                                                                                                                                                                                   | Value            |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `query.command`                                           | Command for running the container (set to default if not set). Use array form                                                                                                                                                 | `[]`             |
| `query.args`                                              | Args for running the container (set to default if not set). Use array form                                                                                                                                                    | `[]`             |
| `query.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                            | `false`          |
| `query.hostAliases`                                       | Set pod host aliases                                                                                                                                                                                                          | `[]`             |
| `query.lifecycleHooks`                                    | Override default etcd container hooks                                                                                                                                                                                         | `{}`             |
| `query.extraEnvVars`                                      | Extra environment variables to be set on jaeger container                                                                                                                                                                     | `[]`             |
| `query.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                          | `""`             |
| `query.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                             | `""`             |
| `query.replicaCount`                                      | Number of Jaeger replicas                                                                                                                                                                                                     | `1`              |
| `query.livenessProbe.enabled`                             | Enable livenessProbe on Query nodes                                                                                                                                                                                           | `true`           |
| `query.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                       | `10`             |
| `query.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                              | `10`             |
| `query.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                             | `1`              |
| `query.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                           | `3`              |
| `query.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                           | `1`              |
| `query.startupProbe.enabled`                              | Enable startupProbe on Query containers                                                                                                                                                                                       | `false`          |
| `query.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                        | `10`             |
| `query.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                               | `10`             |
| `query.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                              | `1`              |
| `query.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                            | `15`             |
| `query.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                            | `1`              |
| `query.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                         | `true`           |
| `query.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                      | `10`             |
| `query.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                             | `10`             |
| `query.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                            | `1`              |
| `query.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                          | `15`             |
| `query.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                          | `1`              |
| `query.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                           | `{}`             |
| `query.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                | `{}`             |
| `query.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                              | `{}`             |
| `query.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if query.resources is set (query.resources is recommended for production). | `small`          |
| `query.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                             | `{}`             |
| `query.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for jaeger container                                                                                                                                                 | `[]`             |
| `query.configuration`                                     | Specify content for Jaeger collector configuration (auto-generated based on other values otherwise)                                                                                                                           | `{}`             |
| `query.overrideConfiguration`                             | Jaeger query common configuration override. Values defined here takes precedence over the ones defined at `query.configuration`                                                                                               | `{}`             |
| `query.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for Jaeger collector                                                                                                                                         | `""`             |
| `query.containerPorts.grpc`                               | Port for GRPC API                                                                                                                                                                                                             | `16685`          |
| `query.containerPorts.http`                               | Port for HTTP API                                                                                                                                                                                                             | `16686`          |
| `query.containerPorts.metrics`                            | Jaeger query prometheus metrics port                                                                                                                                                                                          | `8888`           |
| `query.containerPorts.healthcheck`                        | Jaeger query healthcheck port                                                                                                                                                                                                 | `13133`          |
| `query.service.type`                                      | Jaeger service type                                                                                                                                                                                                           | `ClusterIP`      |
| `query.service.ports.grpc`                                | Port for gRPC API                                                                                                                                                                                                             | `16685`          |
| `query.service.ports.http`                                | Port for API                                                                                                                                                                                                                  | `16686`          |
| `query.service.ports.metrics`                             | Jaeger query prometheus metrics port                                                                                                                                                                                          | `8888`           |
| `query.service.nodePorts.grpc`                            | Port for gRPC API                                                                                                                                                                                                             | `""`             |
| `query.service.nodePorts.http`                            | Node port for API                                                                                                                                                                                                             | `""`             |
| `query.service.nodePorts.metrics`                         | Jaeger query prometheus metrics port                                                                                                                                                                                          | `""`             |
| `query.service.extraPorts`                                | Extra ports to expose in the service (normally used with the `sidecar` value)                                                                                                                                                 | `[]`             |
| `query.service.loadBalancerIP`                            | LoadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                              | `""`             |
| `query.service.loadBalancerSourceRanges`                  | Service Load Balancer sources                                                                                                                                                                                                 | `[]`             |
| `query.service.clusterIP`                                 | Service Cluster IP                                                                                                                                                                                                            | `""`             |
| `query.service.externalTrafficPolicy`                     | Service external traffic policy                                                                                                                                                                                               | `Cluster`        |
| `query.service.annotations`                               | Provide any additional annotations which may be required.                                                                                                                                                                     | `{}`             |
| `query.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                          | `None`           |
| `query.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                   | `{}`             |
| `query.service.metrics.annotations`                       | Annotations for Prometheus metrics                                                                                                                                                                                            | `{}`             |
| `query.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                           | `true`           |
| `query.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                    | `true`           |
| `query.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                               | `true`           |
| `query.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                  | `[]`             |
| `query.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                  | `[]`             |
| `query.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                        | `{}`             |
| `query.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                    | `{}`             |
| `query.serviceAccount.create`                             | Enables ServiceAccount                                                                                                                                                                                                        | `true`           |
| `query.serviceAccount.name`                               | ServiceAccount name                                                                                                                                                                                                           | `""`             |
| `query.serviceAccount.annotations`                        | Annotations to add to all deployed objects                                                                                                                                                                                    | `{}`             |
| `query.serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                                                                                                              | `false`          |
| `query.podSecurityContext.enabled`                        | Enabled Jaeger pods' Security Context                                                                                                                                                                                         | `true`           |
| `query.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                            | `Always`         |
| `query.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                | `[]`             |
| `query.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                   | `[]`             |
| `query.podSecurityContext.fsGroup`                        | Set Jaeger pod's Security Context fsGroup                                                                                                                                                                                     | `1001`           |
| `query.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                          | `true`           |
| `query.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                              | `{}`             |
| `query.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                    | `1001`           |
| `query.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                   | `1001`           |
| `query.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                 | `true`           |
| `query.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                   | `false`          |
| `query.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                       | `true`           |
| `query.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                     | `false`          |
| `query.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                            | `["ALL"]`        |
| `query.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                              | `RuntimeDefault` |
| `query.podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                                    | `{}`             |
| `query.podLabels`                                         | Additional pod labels                                                                                                                                                                                                         | `{}`             |
| `query.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`             |
| `query.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `soft`           |
| `query.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`             |
| `query.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                         | `""`             |
| `query.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                      | `[]`             |
| `query.priorityClassName`                                 | Server priorityClassName                                                                                                                                                                                                      | `""`             |
| `query.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                   | `{}`             |
| `query.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                | `{}`             |
| `query.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                | `[]`             |
| `query.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                | `[]`             |
| `query.schedulerName`                                     | Alternative scheduler                                                                                                                                                                                                         | `""`             |
| `query.updateStrategy.type`                               | Jaeger query deployment strategy type                                                                                                                                                                                         | `RollingUpdate`  |
| `query.updateStrategy.rollingUpdate`                      | Jaeger query deployment rolling update configuration parameters                                                                                                                                                               | `{}`             |
| `query.extraVolumes`                                      | Optionally specify extra list of additional volumes for jaeger container                                                                                                                                                      | `[]`             |
| `query.initContainers`                                    | Add additional init containers to the jaeger pods                                                                                                                                                                             | `[]`             |
| `query.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                               | `true`           |
| `query.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                | `""`             |
| `query.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `query.pdb.minAvailable` and `query.pdb.maxUnavailable` are empty.                                                                    | `""`             |
| `query.sidecars`                                          | Add additional sidecar containers to the jaeger pods                                                                                                                                                                          | `[]`             |

### Collector deployment parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value                        |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `collector.command`                                           | Command for running the container (set to default if not set). Use array form                                                                                                                                                         | `[]`                         |
| `collector.args`                                              | Args for running the container (set to default if not set). Use array form                                                                                                                                                            | `[]`                         |
| `collector.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `false`                      |
| `collector.hostAliases`                                       | Set pod host aliases                                                                                                                                                                                                                  | `[]`                         |
| `collector.lifecycleHooks`                                    | Override default etcd container hooks                                                                                                                                                                                                 | `{}`                         |
| `collector.extraEnvVars`                                      | Extra environment variables to be set on jaeger container                                                                                                                                                                             | `[]`                         |
| `collector.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                                  | `""`                         |
| `collector.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                                     | `""`                         |
| `collector.replicaCount`                                      | Number of Jaeger replicas                                                                                                                                                                                                             | `1`                          |
| `collector.livenessProbe.enabled`                             | Enable livenessProbe on collector nodes                                                                                                                                                                                               | `true`                       |
| `collector.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `10`                         |
| `collector.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`                         |
| `collector.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `1`                          |
| `collector.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `3`                          |
| `collector.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`                          |
| `collector.startupProbe.enabled`                              | Enable startupProbe on collector containers                                                                                                                                                                                           | `false`                      |
| `collector.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `10`                         |
| `collector.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `10`                         |
| `collector.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `1`                          |
| `collector.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `15`                         |
| `collector.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`                          |
| `collector.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                 | `true`                       |
| `collector.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `10`                         |
| `collector.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`                         |
| `collector.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `1`                          |
| `collector.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `15`                         |
| `collector.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`                          |
| `collector.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                   | `{}`                         |
| `collector.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                        | `{}`                         |
| `collector.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                      | `{}`                         |
| `collector.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if collector.resources is set (collector.resources is recommended for production). | `small`                      |
| `collector.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                         |
| `collector.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for jaeger container                                                                                                                                                         | `[]`                         |
| `collector.configuration`                                     | Specify content for Jaeger collector configuration (auto-generated based on other values otherwise)                                                                                                                                   | `{}`                         |
| `collector.overrideConfiguration`                             | Jaeger collector common configuration override. Values defined here takes precedence over the ones defined at `query.configuration`                                                                                                   | `{}`                         |
| `collector.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for Jaeger collector                                                                                                                                                 | `""`                         |
| `collector.receivers`                                         | Sets the jaeger collector receivers that will be enabled                                                                                                                                                                              | `["otlp","jaeger","zipkin"]` |
| `collector.containerPorts.otlp.grpc`                          | Accepts traces in OpenTelemetry OTLP format over gRPC                                                                                                                                                                                 | `4317`                       |
| `collector.containerPorts.otlp.http`                          | Accepts traces in OpenTelemetry OTLP format over HTTP                                                                                                                                                                                 | `4318`                       |
| `collector.containerPorts.jaeger.grpc`                        | Legacy Jaeger protobuf via gRPC API port                                                                                                                                                                                              | `14250`                      |
| `collector.containerPorts.jaeger.thrift_http`                 | Legacy Jaeger Thrift over HTTP API port                                                                                                                                                                                               | `14268`                      |
| `collector.containerPorts.zipkin`                             | can accept Zipkin spans in Thrift, JSON and Proto (disabled by default)                                                                                                                                                               | `9411`                       |
| `collector.containerPorts.metrics`                            | Jaeger collector prometheus metrics port                                                                                                                                                                                              | `8888`                       |
| `collector.containerPorts.healthcheck`                        | Jaeger collector healthcheck port                                                                                                                                                                                                     | `13133`                      |
| `collector.service.type`                                      | Jaeger service type                                                                                                                                                                                                                   | `ClusterIP`                  |
| `collector.service.ports.otlp.grpc`                           | Accepts traces in OpenTelemetry OTLP format over gRPC                                                                                                                                                                                 | `4317`                       |
| `collector.service.ports.otlp.http`                           | Accepts traces in OpenTelemetry OTLP format over HTTP                                                                                                                                                                                 | `4318`                       |
| `collector.service.ports.jaeger.grpc`                         | Legacy Jaeger protobuf via gRPC API port                                                                                                                                                                                              | `14250`                      |
| `collector.service.ports.jaeger.thrift_http`                  | Legacy Jaeger Thrift over HTTP API port                                                                                                                                                                                               | `14268`                      |
| `collector.service.ports.zipkin`                              | can accept Zipkin spans in Thrift, JSON and Proto (disabled by default)                                                                                                                                                               | `9411`                       |
| `collector.service.ports.metrics`                             | Jaeger collector prometheus metrics port                                                                                                                                                                                              | `8888`                       |
| `collector.service.nodePorts.otlp.grpc`                       | Accepts traces in OpenTelemetry OTLP format over gRPC                                                                                                                                                                                 | `""`                         |
| `collector.service.nodePorts.otlp.http`                       | Accepts traces in OpenTelemetry OTLP format over HTTP                                                                                                                                                                                 | `""`                         |
| `collector.service.nodePorts.jaeger.grpc`                     | Legacy Jaeger protobuf via gRPC API port                                                                                                                                                                                              | `""`                         |
| `collector.service.nodePorts.jaeger.thrift_http`              | Legacy Jaeger Thrift over HTTP API port                                                                                                                                                                                               | `""`                         |
| `collector.service.nodePorts.zipkin`                          | can accept Zipkin spans in Thrift, JSON and Proto (disabled by default)                                                                                                                                                               | `""`                         |
| `collector.service.nodePorts.metrics`                         | Jaeger collector prometheus metrics port                                                                                                                                                                                              | `""`                         |
| `collector.service.extraPorts`                                | Extra ports to expose in the service (normally used with the `sidecar` value)                                                                                                                                                         | `[]`                         |
| `collector.service.loadBalancerIP`                            | LoadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                                      | `""`                         |
| `collector.service.loadBalancerSourceRanges`                  | Service Load Balancer sources                                                                                                                                                                                                         | `[]`                         |
| `collector.service.clusterIP`                                 | Service Cluster IP                                                                                                                                                                                                                    | `""`                         |
| `collector.service.externalTrafficPolicy`                     | Service external traffic policy                                                                                                                                                                                                       | `Cluster`                    |
| `collector.service.annotations`                               | Provide any additional annotations which may be required.                                                                                                                                                                             | `{}`                         |
| `collector.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                  | `None`                       |
| `collector.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                           | `{}`                         |
| `collector.service.metrics.annotations`                       | Annotations for Prometheus metrics                                                                                                                                                                                                    | `{}`                         |
| `collector.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                   | `true`                       |
| `collector.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                            | `true`                       |
| `collector.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                       | `true`                       |
| `collector.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                         |
| `collector.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                         |
| `collector.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                | `{}`                         |
| `collector.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`                         |
| `collector.serviceAccount.create`                             | Enables ServiceAccount                                                                                                                                                                                                                | `true`                       |
| `collector.serviceAccount.name`                               | ServiceAccount name                                                                                                                                                                                                                   | `""`                         |
| `collector.serviceAccount.annotations`                        | Annotations to add to all deployed objects                                                                                                                                                                                            | `{}`                         |
| `collector.serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                                                                                                                      | `false`                      |
| `collector.podSecurityContext.enabled`                        | Enabled Jaeger pods' Security Context                                                                                                                                                                                                 | `true`                       |
| `collector.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`                     |
| `collector.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`                         |
| `collector.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`                         |
| `collector.podSecurityContext.fsGroup`                        | Set Jaeger pod's Security Context fsGroup                                                                                                                                                                                             | `1001`                       |
| `collector.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`                       |
| `collector.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `{}`                         |
| `collector.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `1001`                       |
| `collector.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `1001`                       |
| `collector.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `true`                       |
| `collector.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`                      |
| `collector.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`                       |
| `collector.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`                      |
| `collector.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`                    |
| `collector.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`             |
| `collector.podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                                            | `{}`                         |
| `collector.podLabels`                                         | Additional pod labels                                                                                                                                                                                                                 | `{}`                         |
| `collector.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                   | `""`                         |
| `collector.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                              | `soft`                       |
| `collector.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                             | `""`                         |
| `collector.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                                 | `""`                         |
| `collector.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                                              | `[]`                         |
| `collector.priorityClassName`                                 | Server priorityClassName                                                                                                                                                                                                              | `""`                         |
| `collector.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                           | `{}`                         |
| `collector.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                        | `{}`                         |
| `collector.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                        | `[]`                         |
| `collector.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                        | `[]`                         |
| `collector.schedulerName`                                     | Alternative scheduler                                                                                                                                                                                                                 | `""`                         |
| `collector.updateStrategy.type`                               | Jaeger collector deployment strategy type                                                                                                                                                                                             | `RollingUpdate`              |
| `collector.updateStrategy.rollingUpdate`                      | Jaeger collector deployment rolling update configuration parameters                                                                                                                                                                   | `{}`                         |
| `collector.extraVolumes`                                      | Optionally specify extra list of additional volumes for jaeger container                                                                                                                                                              | `[]`                         |
| `collector.initContainers`                                    | Add additional init containers to the jaeger pods                                                                                                                                                                                     | `[]`                         |
| `collector.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                       | `true`                       |
| `collector.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                        | `""`                         |
| `collector.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `collector.pdb.minAvailable` and `collector.pdb.maxUnavailable` are empty.                                                                    | `""`                         |
| `collector.sidecars`                                          | Add additional sidecar containers to the jaeger pods                                                                                                                                                                                  | `[]`                         |
| `migration.podLabels`                                         | Additional pod labels                                                                                                                                                                                                                 | `{}`                         |
| `migration.podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                                            | `{}`                         |
| `migration.annotations`                                       | Provide any additional annotations which may be required.                                                                                                                                                                             | `{}`                         |
| `migration.podSecurityContext.enabled`                        | Enabled Jaeger pods' Security Context                                                                                                                                                                                                 | `true`                       |
| `migration.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`                     |
| `migration.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`                         |
| `migration.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`                         |
| `migration.podSecurityContext.fsGroup`                        | Set Jaeger pod's Security Context fsGroup                                                                                                                                                                                             | `1001`                       |
| `migration.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`                       |
| `migration.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `{}`                         |
| `migration.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `1001`                       |
| `migration.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `1001`                       |
| `migration.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `true`                       |
| `migration.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`                      |
| `migration.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`                       |
| `migration.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`                      |
| `migration.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`                    |
| `migration.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`             |
| `migration.extraEnvVars`                                      | Extra environment variables to be set on jaeger migration container                                                                                                                                                                   | `[]`                         |
| `migration.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                                  | `""`                         |
| `migration.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                                     | `""`                         |
| `migration.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for jaeger container                                                                                                                                                         | `[]`                         |
| `migration.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if migration.resources is set (migration.resources is recommended for production). | `small`                      |
| `migration.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                         |
| `migration.initContainer.resourcesPreset`                     | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if migration.resources is set (migration.resources is recommended for production). | `nano`                       |
| `migration.initContainer.resources`                           | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                         |
| `migration.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                   | `true`                       |
| `migration.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                            | `true`                       |
| `migration.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                       | `true`                       |
| `migration.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                         |
| `migration.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                         |
| `migration.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                | `{}`                         |
| `migration.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`                         |
| `migration.extraVolumes`                                      | Optionally specify extra list of additional volumes for jaeger container                                                                                                                                                              | `[]`                         |

### Set the image to use for the migration job

| Name                                         | Description                                                                                                                                                                                                | Value                       |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `cqlshImage.registry`                        | Cassandra image registry                                                                                                                                                                                   | `REGISTRY_NAME`             |
| `cqlshImage.repository`                      | Cassandra image repository                                                                                                                                                                                 | `REPOSITORY_NAME/cassandra` |
| `cqlshImage.digest`                          | Cassandra image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                  | `""`                        |
| `cqlshImage.pullPolicy`                      | image pull policy                                                                                                                                                                                          | `IfNotPresent`              |
| `cqlshImage.pullSecrets`                     | Cassandra image pull secrets                                                                                                                                                                               | `[]`                        |
| `cqlshImage.debug`                           | Enable image debug mode                                                                                                                                                                                    | `false`                     |
| `cqlshImage.resourcesPreset`                 | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                      |
| `cqlshImage.resources`                       | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                          | `{}`                        |
| `externalDatabase.host`                      | External database host                                                                                                                                                                                     | `""`                        |
| `externalDatabase.port`                      | External database port                                                                                                                                                                                     | `9042`                      |
| `externalDatabase.dbUser.user`               | Cassandra admin user                                                                                                                                                                                       | `bn_jaeger`                 |
| `externalDatabase.dbUser.password`           | Password for `dbUser.user`. Randomly generated if empty                                                                                                                                                    | `""`                        |
| `externalDatabase.existingSecret`            | Name of existing secret containing the database secret                                                                                                                                                     | `""`                        |
| `externalDatabase.existingSecretPasswordKey` | Name of existing secret key containing the database password secret key                                                                                                                                    | `""`                        |
| `externalDatabase.cluster.datacenter`        | Name for cassandra's jaeger datacenter                                                                                                                                                                     | `dc1`                       |
| `externalDatabase.keyspace`                  | Name for cassandra's jaeger keyspace                                                                                                                                                                       | `bitnami_jaeger`            |

### Cassandra storage sub-chart

| Name                              | Description                                                                                                                                                                                                | Value            |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `cassandra.enabled`               | Enables cassandra storage pod                                                                                                                                                                              | `true`           |
| `cassandra.cluster.datacenter`    | Name for cassandra's jaeger datacenter                                                                                                                                                                     | `dc1`            |
| `cassandra.keyspace`              | Name for cassandra's jaeger keyspace                                                                                                                                                                       | `bitnami_jaeger` |
| `cassandra.dbUser.user`           | Cassandra admin user                                                                                                                                                                                       | `bn_jaeger`      |
| `cassandra.dbUser.password`       | Password for `dbUser.user`. Randomly generated if empty                                                                                                                                                    | `""`             |
| `cassandra.dbUser.existingSecret` | Name of an existing secret containing the user password.                                                                                                                                                   | `""`             |
| `cassandra.service.ports.cql`     | Cassandra cql port                                                                                                                                                                                         | `9042`           |
| `cassandra.initDB`                | Init script for initializing the instance                                                                                                                                                                  | `{}`             |
| `cassandra.resourcesPreset`       | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `large`          |
| `cassandra.resources`             | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                          | `{}`             |

> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/jaeger/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 6.0.0

This major release updates Jaeger to its new major Jaeger v2. Previous releases of the chart (5.x.x) have been tagged as Jaeger v2, but due to an issue the chart continued using the Jaeger v1 binaries.

Starting from this version, the chart will use the Jaeger v2 binary and the container will no longer include Jaeger v1 binaries in the v2 images.

Additionally, this major release introduces the following changes:

- Removes the cassandra-schema init job, as Jaeger v2 is capable of initializing the schema.
- Removed the `admin`, `binary` and `grpc` collector port values. Added jaeger legacy ports `jaeger.grpc` (previously `grpc`) and `jaeger.thrift_http` (previously `binary`).
- Jaeger v2 no longer supports the `admin` port. Prometheus metrics and healthcheck capabilities have been moved into the new ports `metrics` and `healthcheck` for both collector and query nodes.
- Introduced the jaeger-query and jaeger-collector configmaps, as Jaeger v2 no longer supports configuration via environment variables. Added values `collector.configuration`/`query.configuration` and `collector.existingConfigmap`/`query.existingConfigmap` to customize configuration.

### To 5.1.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 4.0.0

This major updates Jaeger to version 1.63.0, which fully deprecates the [jaeger-agent component](https://github.com/jaegertracing/jaeger/issues/4739). When upgrading, all the jaeger-agent components will be fully removed. Check the [upstream documentation](https://www.jaegertracing.io/docs/1.62/architecture/) for alternatives.

### To 3.0.0

This major updates the Cassandra subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/pull/29305) you can find more information about the changes introduced in that version.

### To 2.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 1.0.0

This major updates the Cassandra subchart to its newest major, 10.0.0. [Here](https://github.com/bitnami/charts/pull/14076) you can find more information about the changes introduced in that version.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
