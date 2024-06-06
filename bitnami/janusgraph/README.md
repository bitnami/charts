<!--- app-name: JanusGraph -->

# Bitnami package for JanusGraph

JanusGraph is a scalable graph database optimized for storing and querying graphs containing hundreds of billions of vertices and edges distributed across a multi-machine cluster.

[Overview of JanusGraph](https://janusgraph.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/janusgraph
```

Looking to use JanusGraph in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [JanusGraph](https://github.com/bitnami/containers/tree/main/bitnami/janusgraph) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/janusgraph
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys JanusGraph on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                                                | Description                                                                                                                                                                                                          | Value                              |
| --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `kubeVersion`                                       | Override Kubernetes version                                                                                                                                                                                          | `""`                               |
| `nameOverride`                                      | String to partially override common.names.name                                                                                                                                                                       | `""`                               |
| `fullnameOverride`                                  | String to fully override common.names.fullname                                                                                                                                                                       | `""`                               |
| `namespaceOverride`                                 | String to fully override common.names.namespace                                                                                                                                                                      | `""`                               |
| `commonLabels`                                      | Labels to add to all deployed objects                                                                                                                                                                                | `{}`                               |
| `commonAnnotations`                                 | Annotations to add to all deployed objects                                                                                                                                                                           | `{}`                               |
| `clusterDomain`                                     | Kubernetes cluster domain name                                                                                                                                                                                       | `cluster.local`                    |
| `extraDeploy`                                       | Array of extra objects to deploy with the release                                                                                                                                                                    | `[]`                               |
| `diagnosticMode.enabled`                            | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                                                                                              | `false`                            |
| `diagnosticMode.command`                            | Command to override all containers in the deployment                                                                                                                                                                 | `["sleep"]`                        |
| `diagnosticMode.args`                               | Args to override all containers in the deployment                                                                                                                                                                    | `["infinity"]`                     |
| `storageBackend.usePasswordFiles`                   | Mount credentials as a files instead of using an environment variable                                                                                                                                                | `false`                            |
| `storageBackend.cassandra.enabled`                  | Use Apache Casandra subchart as storage backend                                                                                                                                                                      | `true`                             |
| `storageBackend.berkeleyje.enabled`                 | Use BerkeleyDB (local) as storage backend                                                                                                                                                                            | `false`                            |
| `storageBackend.berkeleyje.directory`               | Path for the BerkeleyDB data                                                                                                                                                                                         | `/bitnami/janusgraph/data/storage` |
| `storageBackend.external.backend`                   | Type of the external storage backend to be used                                                                                                                                                                      | `""`                               |
| `storageBackend.external.hostname`                  | Hostname of the external storage backend                                                                                                                                                                             | `""`                               |
| `storageBackend.external.port`                      | Port of the external storage backend                                                                                                                                                                                 | `""`                               |
| `storageBackend.external.username`                  | Username used to authenticate to the storage backend, in case it requires authentication                                                                                                                             | `""`                               |
| `storageBackend.external.existingSecret`            | Existing secret containing the password of the external storage backend, in case its needed                                                                                                                          | `""`                               |
| `storageBackend.external.existingSecretPasswordKey` | Name of an existing secret key containing the storage backend password                                                                                                                                               | `""`                               |
| `indexBackend.lucene.enabled`                       | Use Lucene (local) as index management backend                                                                                                                                                                       | `false`                            |
| `indexBackend.lucene.directory`                     | Path for the BerkeleyDB data                                                                                                                                                                                         | `/bitnami/janusgraph/data/index`   |
| `indexBackend.external.backend`                     | Type of the external index backend to be used                                                                                                                                                                        | `""`                               |
| `indexBackend.external.hostname`                    | Hostname of the external index backend                                                                                                                                                                               | `""`                               |
| `indexBackend.external.port`                        | Port of the external index backend                                                                                                                                                                                   | `""`                               |
| `cache.enabled`                                     | Enable Janusgraph cache feature                                                                                                                                                                                      | `true`                             |
| `existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for JanusGraph                                                                                                                                      | `""`                               |
| `extraJanusgraphProperties`                         | Additional JanusGraph to be appended at the end of the janusgraph.properties configmap                                                                                                                               | `""`                               |
| `janusgraphProperties`                              | Override the content of the janusgraph.properties file.                                                                                                                                                              | `""`                               |
| `javaOptions`                                       | Java options for JanusGraph execution                                                                                                                                                                                | `""`                               |
| `image.registry`                                    | JanusGraph image registry                                                                                                                                                                                            | `REGISTRY_NAME`                    |
| `image.repository`                                  | JanusGraph image repository                                                                                                                                                                                          | `REPOSITORY_NAME/janusgraph`       |
| `image.digest`                                      | JanusGraph image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                | `""`                               |
| `image.pullPolicy`                                  | JanusGraph image pull policy                                                                                                                                                                                         | `IfNotPresent`                     |
| `image.pullSecrets`                                 | JanusGraph image pull secrets                                                                                                                                                                                        | `[]`                               |
| `image.debug`                                       | Enable JanusGraph image debug mode                                                                                                                                                                                   | `false`                            |
| `replicaCount`                                      | Number of JanusGraph replicas to deploy                                                                                                                                                                              | `1`                                |
| `containerPorts.gremlin`                            | JanusGraph gremlin server container port                                                                                                                                                                             | `8182`                             |
| `containerPorts.jmx`                                | JanusGraph JMX metrics container port                                                                                                                                                                                | `5555`                             |
| `livenessProbe.enabled`                             | Enable livenessProbe on JanusGraph containers                                                                                                                                                                        | `true`                             |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                              | `90`                               |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                     | `10`                               |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                    | `5`                                |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                  | `5`                                |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                  | `1`                                |
| `readinessProbe.enabled`                            | Enable readinessProbe on JanusGraph containers                                                                                                                                                                       | `true`                             |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                             | `90`                               |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                    | `10`                               |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                   | `5`                                |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                 | `5`                                |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                 | `1`                                |
| `startupProbe.enabled`                              | Enable startupProbe on JanusGraph containers                                                                                                                                                                         | `false`                            |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                               | `90`                               |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                      | `10`                               |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                     | `5`                                |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                   | `5`                                |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                   | `1`                                |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                  | `{}`                               |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                 | `{}`                               |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                   | `{}`                               |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (secondary.resources is recommended for production). | `xlarge`                           |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                    | `{}`                               |
| `podSecurityContext.enabled`                        | Enable security context for JanusGraph pods                                                                                                                                                                          | `true`                             |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                   | `Always`                           |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                       | `[]`                               |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                          | `[]`                               |
| `podSecurityContext.fsGroup`                        | Group ID for the mounted volumes' filesystem                                                                                                                                                                         | `1001`                             |
| `containerSecurityContext.enabled`                  | JanusGraph container securityContext                                                                                                                                                                                 | `true`                             |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                     | `nil`                              |
| `containerSecurityContext.runAsUser`                | User ID for the JanusGraph container                                                                                                                                                                                 | `1001`                             |
| `containerSecurityContext.runAsGroup`               | Group ID for the JanusGraph container                                                                                                                                                                                | `1001`                             |
| `containerSecurityContext.runAsNonRoot`             | Set secondary container's Security Context runAsNonRoot                                                                                                                                                              | `true`                             |
| `containerSecurityContext.privileged`               | Set secondary container's Security Context privileged                                                                                                                                                                | `false`                            |
| `containerSecurityContext.allowPrivilegeEscalation` | Set secondary container's Security Context allowPrivilegeEscalation                                                                                                                                                  | `false`                            |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                              | `true`                             |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                   | `["ALL"]`                          |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                     | `RuntimeDefault`                   |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                 | `[]`                               |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                    | `[]`                               |
| `hostAliases`                                       | JanusGraph pods host aliases                                                                                                                                                                                         | `[]`                               |
| `annotations`                                       | Annotations for JanusGraph deployment/statefulset                                                                                                                                                                    | `{}`                               |
| `podLabels`                                         | Extra labels for JanusGraph pods                                                                                                                                                                                     | `{}`                               |
| `podAnnotations`                                    | Annotations for JanusGraph pods                                                                                                                                                                                      | `{}`                               |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `""`                               |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `soft`                             |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                      | `true`                             |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                       | `""`                               |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                       | `""`                               |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                            | `""`                               |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                | `""`                               |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                             | `[]`                               |
| `affinity`                                          | Affinity for JanusGraph pods assignment                                                                                                                                                                              | `{}`                               |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                   | `false`                            |
| `nodeSelector`                                      | Node labels for JanusGraph pods assignment                                                                                                                                                                           | `{}`                               |
| `tolerations`                                       | Tolerations for JanusGraph pods assignment                                                                                                                                                                           | `[]`                               |
| `updateStrategy.type`                               | JanusGraph strategy type                                                                                                                                                                                             | `RollingUpdate`                    |
| `priorityClassName`                                 | JanusGraph pods' priorityClassName                                                                                                                                                                                   | `""`                               |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                             | `[]`                               |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for JanusGraph pods                                                                                                                                                   | `""`                               |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                    | `""`                               |
| `lifecycleHooks`                                    | for the JanusGraph container(s) to automate configuration before or after startup                                                                                                                                    | `{}`                               |
| `extraEnvVars`                                      | Array with extra environment variables to add to JanusGraph nodes                                                                                                                                                    | `[]`                               |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for JanusGraph nodes                                                                                                                                            | `""`                               |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for JanusGraph nodes                                                                                                                                               | `""`                               |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the JanusGraph pod(s)                                                                                                                                        | `[]`                               |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the JanusGraph container(s)                                                                                                                             | `[]`                               |
| `sidecars`                                          | Add additional sidecar containers to the JanusGraph pod(s)                                                                                                                                                           | `[]`                               |
| `initContainers`                                    | Add additional init containers to the JanusGraph pod(s)                                                                                                                                                              | `[]`                               |

### Autoscaling

| Name                                  | Description                                                                                    | Value   |
| ------------------------------------- | ---------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.vpa.enabled`             | Enable VPA                                                                                     | `false` |
| `autoscaling.vpa.annotations`         | Annotations for VPA resource                                                                   | `{}`    |
| `autoscaling.vpa.controlledResources` | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory | `[]`    |
| `autoscaling.vpa.maxAllowed`          | VPA Max allowed resources for the pod                                                          | `{}`    |
| `autoscaling.vpa.minAllowed`          | VPA Min allowed resources for the pod                                                          | `{}`    |

### VPA update policy

| Name                                      | Description                                                                                                                                                            | Value   |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `autoscaling.hpa.enabled`                 | Enable HPA                                                                                                                                                             | `false` |
| `autoscaling.hpa.minReplicas`             | Minimum number of replicas                                                                                                                                             | `""`    |
| `autoscaling.hpa.maxReplicas`             | Maximum number of replicas                                                                                                                                             | `""`    |
| `autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                                                   | `""`    |

### Traffic Exposure Parameters

| Name                               | Description                                                                           | Value          |
| ---------------------------------- | ------------------------------------------------------------------------------------- | -------------- |
| `service.type`                     | JanusGraph service type                                                               | `LoadBalancer` |
| `service.ports.gremlin`            | JanusGraph service Gremlin port                                                       | `8182`         |
| `service.nodePorts.gremlin`        | Node port for Gremlin                                                                 | `""`           |
| `service.clusterIP`                | JanusGraph service Cluster IP                                                         | `""`           |
| `service.loadBalancerIP`           | JanusGraph service Load Balancer IP                                                   | `""`           |
| `service.loadBalancerSourceRanges` | JanusGraph service Load Balancer sources                                              | `[]`           |
| `service.externalTrafficPolicy`    | JanusGraph service external traffic policy                                            | `Cluster`      |
| `service.annotations`              | Additional custom annotations for JanusGraph service                                  | `{}`           |
| `service.extraPorts`               | Extra ports to expose in JanusGraph service (normally used with the `sidecars` value) | `[]`           |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                      | `None`         |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                           | `{}`           |

### Persistence Parameters

| Name                         | Description                                                                                                                           | Value                      |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `persistence.enabled`        | Enable persistence using Persistent Volume Claims                                                                                     | `false`                    |
| `persistence.mountPath`      | Path to mount the volume at.                                                                                                          | `/bitnami/janusgraph/data` |
| `persistence.subPath`        | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services                               | `""`                       |
| `persistence.storageClass`   | Storage class of backing PVC                                                                                                          | `""`                       |
| `persistence.annotations`    | Persistent Volume Claim annotations                                                                                                   | `{}`                       |
| `persistence.accessModes`    | Persistent Volume Access Modes                                                                                                        | `["ReadWriteOnce"]`        |
| `persistence.size`           | Size of data volume                                                                                                                   | `8Gi`                      |
| `persistence.existingClaim`  | The name of an existing PVC to use for persistence                                                                                    | `""`                       |
| `persistence.selector`       | Selector to match an existing Persistent Volume for Janusgraph data PVC                                                               | `{}`                       |
| `persistence.dataSource`     | Custom PVC data source                                                                                                                | `{}`                       |
| `persistence.resourcePolicy` | Setting it to "keep" to avoid removing PVCs during a helm delete operation. Leaving it empty will delete PVCs after the chart deleted | `""`                       |

### Prometheus metrics

| Name                                                        | Description                                                                                                                                                                                                                | Value                          |
| ----------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `metrics.enabled`                                           | Enable the export of Prometheus metrics                                                                                                                                                                                    | `false`                        |
| `metrics.image.registry`                                    | JMX exporter image registry                                                                                                                                                                                                | `REGISTRY_NAME`                |
| `metrics.image.repository`                                  | JMX exporter image repository                                                                                                                                                                                              | `REPOSITORY_NAME/jmx-exporter` |
| `metrics.image.digest`                                      | JMX exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                               | `""`                           |
| `metrics.image.pullPolicy`                                  | JMX exporter image pull policy                                                                                                                                                                                             | `IfNotPresent`                 |
| `metrics.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                           | `[]`                           |
| `metrics.containerSecurityContext.enabled`                  | Enable Prometheus JMX exporter containers' Security Context                                                                                                                                                                | `true`                         |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                           | `{}`                           |
| `metrics.containerSecurityContext.runAsUser`                | Set Prometheus JMX exporter containers' Security Context runAsUser                                                                                                                                                         | `1001`                         |
| `metrics.containerSecurityContext.runAsGroup`               | Group ID for the Prometheus JMX exporter container                                                                                                                                                                         | `1001`                         |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set Prometheus JMX exporter containers' Security Context runAsNonRoot                                                                                                                                                      | `true`                         |
| `metrics.containerSecurityContext.privileged`               | Set Prometheus JMX exporter container's Security Context privileged                                                                                                                                                        | `false`                        |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set Prometheus JMX exporter containers' Security Context allowPrivilegeEscalation                                                                                                                                          | `false`                        |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set Prometheus JMX exporter containers' Security Context readOnlyRootFilesystem                                                                                                                                            | `true`                         |
| `metrics.containerSecurityContext.capabilities.drop`        | Set Prometheus JMX exporter containers' Security Context capabilities to be dropped                                                                                                                                        | `["ALL"]`                      |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set Prometheus JMX exporter container's Security Context seccomp profile                                                                                                                                                   | `RuntimeDefault`               |
| `metrics.containerPorts.metrics`                            | Prometheus JMX exporter metrics container port                                                                                                                                                                             | `5556`                         |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                         |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                           |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                       | `true`                         |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                    | `60`                           |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                           | `10`                           |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                          | `10`                           |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                        | `3`                            |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                        | `1`                            |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                      | `true`                         |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                   | `30`                           |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                          | `10`                           |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                         | `10`                           |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                       | `3`                            |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                       | `1`                            |
| `metrics.service.ports.metrics`                             | Prometheus JMX exporter metrics service port                                                                                                                                                                               | `5556`                         |
| `metrics.service.clusterIP`                                 | Static clusterIP or None for headless services                                                                                                                                                                             | `""`                           |
| `metrics.service.sessionAffinity`                           | Control where client requests go, to the same pod or round-robin                                                                                                                                                           | `None`                         |
| `metrics.service.annotations`                               | Annotations for the Prometheus JMX exporter service                                                                                                                                                                        | `{}`                           |
| `metrics.config`                                            | Configuration file for JMX exporter                                                                                                                                                                                        | `""`                           |
| `metrics.existingConfigmap`                                 | Name of existing ConfigMap with JMX exporter configuration                                                                                                                                                                 | `""`                           |
| `metrics.serviceMonitor.enabled`                            | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                                                     | `false`                        |
| `metrics.serviceMonitor.namespace`                          | Namespace in which Prometheus is running                                                                                                                                                                                   | `""`                           |
| `metrics.serviceMonitor.annotations`                        | Additional custom annotations for the ServiceMonitor                                                                                                                                                                       | `{}`                           |
| `metrics.serviceMonitor.labels`                             | Extra labels for the ServiceMonitor                                                                                                                                                                                        | `{}`                           |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in Prometheus                                                                                                                                           | `""`                           |
| `metrics.serviceMonitor.honorLabels`                        | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                   | `false`                        |
| `metrics.serviceMonitor.interval`                           | Interval at which metrics should be scraped.                                                                                                                                                                               | `""`                           |
| `metrics.serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                                                                                    | `""`                           |
| `metrics.serviceMonitor.metricRelabelings`                  | Specify additional relabeling of metrics                                                                                                                                                                                   | `[]`                           |
| `metrics.serviceMonitor.relabelings`                        | Specify general relabeling                                                                                                                                                                                                 | `[]`                           |
| `metrics.serviceMonitor.selector`                           | Prometheus instance selector labels                                                                                                                                                                                        | `{}`                           |

### Other Parameters

| Name                                                   | Description                                                                                     | Value                      |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                    |
| `volumePermissions.image.registry`                     | OS Shell + Utility image registry                                                               | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                   | OS Shell + Utility image repository                                                             | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.pullPolicy`                   | OS Shell + Utility image pull policy                                                            | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                  | OS Shell + Utility image pull secrets                                                           | `[]`                       |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                       |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                        |
| `serviceAccount.create`                                | Specifies whether a ServiceAccount should be created                                            | `true`                     |
| `serviceAccount.name`                                  | The name of the ServiceAccount to use.                                                          | `""`                       |
| `serviceAccount.annotations`                           | Additional Service Account annotations (evaluated as a template)                                | `{}`                       |
| `serviceAccount.automountServiceAccountToken`          | Automount service account token for the server service account                                  | `false`                    |

### NetworkPolicy parameters

| Name                                    | Description                                                     | Value  |
| --------------------------------------- | --------------------------------------------------------------- | ------ |
| `networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                      | `true` |
| `networkPolicy.allowExternal`           | The Policy model to apply                                       | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations. | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces          | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces      | `{}`   |

### Cassandra storage sub-chart

| Name                          | Description                                             | Value                |
| ----------------------------- | ------------------------------------------------------- | -------------------- |
| `cassandra.keyspace`          | Name for cassandra's janusgraph keyspace                | `bitnami_janusgraph` |
| `cassandra.dbUser.user`       | Cassandra admin user                                    | `bn_janusgraph`      |
| `cassandra.dbUser.password`   | Password for `dbUser.user`. Randomly generated if empty | `""`                 |
| `cassandra.service.ports.cql` | Cassandra cql port                                      | `9043`               |

See <https://github.com/bitnami/readme-generator-for-helm> to create the table

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    oci://REGISTRY_NAME/REPOSITORY_NAME/janusgraph
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/janusgraph
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/blob/main/template/janusgraph/values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### External storage backend support

You may want to have JanusGraph connect to an external storage backend rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`storageBackend.external` parameter](#parameters). You should also disable the Cassandra installation with the `storageBackend.cassandra.enabled` option. Here is an example:

```console
storageBackend.cassandra.enabled=false
storageBackend.external.backend=<your_backend_type>
storageBackend.external.hostname=<your_backend_host>
storageBackend.external.port=<your_backend_port>
#Auth only if needed#
storageBackend.external.username=<your_backend_username>
storageBackend.external.existingSecret=<secret_containing_the_password>
storageBackend.external.existingSecretPasswordKey=<secret_key_containing_the_password>
```

### External indexing backend support

You may want to have JanusGraph connect to an external indexing backend. To achieve this, the chart allows you to specify credentials for an external indexing backend with the [`indexBackend.external` parameter](#parameters). Here is an example:

```console
indexBackend.external.backend=<your_backend_type>
indexBackend.external.hostname=<your_backend_host>
indexBackend.external.port=<your_backend_port>
```

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as JanusGraph (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

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