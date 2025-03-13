<!--- app-name: NATS -->

# Bitnami package for NATS

NATS is an open source, lightweight and high-performance messaging system. It is ideal for distributed systems and supports modern cloud architectures and pub-sub, request-reply and queuing models.

[Overview of NATS](https://nats.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/nats
```

Looking to use NATS in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [NATS](https://github.com/bitnami/containers/tree/main/bitnami/nats) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/nats
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys NATS on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Update credentials

The Bitnami NATS chart, when upgrading, reuses the secret previously rendered by the chart or the one specified in `existingSecret`. To update credentials, use one of the following:

- Run `helm upgrade` specifying new credentials via `auth.token` or `auth.credentials` parameters
- Run `helm upgrade` specifying a new secret in `existingSecret`

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will deploy a sidecar container with [prometheus-nats-exporter](https://github.com/nats-io/prometheus-nats-exporter) in all pods and a `metrics` service, which can be configured under the `metrics.service` section. This `metrics` service will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling vs Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter.

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

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

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

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Add labels to all the deployed resources                                                | `{}`            |
| `commonAnnotations`      | Add annotations to all the deployed resources                                           | `{}`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                               | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### NATS parameters

| Name                                               | Description                                                                                                                                                                     | Value                  |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `image.registry`                                   | NATS image registry                                                                                                                                                             | `REGISTRY_NAME`        |
| `image.repository`                                 | NATS image repository                                                                                                                                                           | `REPOSITORY_NAME/nats` |
| `image.digest`                                     | NATS image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                            | `""`                   |
| `image.pullPolicy`                                 | NATS image pull policy                                                                                                                                                          | `IfNotPresent`         |
| `image.pullSecrets`                                | NATS image pull secrets                                                                                                                                                         | `[]`                   |
| `auth.enabled`                                     | Switch to enable/disable client authentication                                                                                                                                  | `true`                 |
| `auth.token`                                       | Client authentication token                                                                                                                                                     | `""`                   |
| `auth.credentials`                                 | Client authentication users credentials collection. Ignored if `auth.token` is set                                                                                              | `[]`                   |
| `auth.noAuthUser`                                  | No authenticated access will be associated with this user. It must be one of the available under `auth.credentials` map array. No authenticated access will be denied if unset. | `""`                   |
| `auth.timeout`                                     | Client authentication timeout (seconds)                                                                                                                                         | `1`                    |
| `tls.enabled`                                      | Enable TLS configuration for NATS                                                                                                                                               | `false`                |
| `tls.autoGenerated.enabled`                        | Enable automatic generation of TLS certificates                                                                                                                                 | `true`                 |
| `tls.autoGenerated.engine`                         | Mechanism to generate the certificates (allowed values: helm, cert-manager)                                                                                                     | `helm`                 |
| `tls.autoGenerated.certManager.existingIssuer`     | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine)                                                                          | `""`                   |
| `tls.autoGenerated.certManager.existingIssuerKind` | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                                                                                                       | `""`                   |
| `tls.autoGenerated.certManager.keyAlgorithm`       | Key algorithm for the certificates (only for `cert-manager` engine)                                                                                                             | `RSA`                  |
| `tls.autoGenerated.certManager.keySize`            | Key size for the certificates (only for `cert-manager` engine)                                                                                                                  | `2048`                 |
| `tls.autoGenerated.certManager.duration`           | Duration for the certificates (only for `cert-manager` engine)                                                                                                                  | `2160h`                |
| `tls.autoGenerated.certManager.renewBefore`        | Renewal period for the certificates (only for `cert-manager` engine)                                                                                                            | `360h`                 |
| `tls.ca`                                           | CA certificate for TLS. Ignored if `tls.existingCASecret` is set                                                                                                                | `""`                   |
| `tls.existingCASecret`                             | The name of an existing Secret containing the CA certificate for TLS                                                                                                            | `""`                   |
| `tls.server.cert`                                  | TLS certificate for NATS servers. Ignored if `tls.server.existingSecret` is set                                                                                                 | `""`                   |
| `tls.server.key`                                   | TLS key for NATS servers. Ignored if `tls.server.existingSecret` is set                                                                                                         | `""`                   |
| `tls.server.existingSecret`                        | The name of an existing Secret containing the TLS certificates for NATS servers                                                                                                 | `""`                   |
| `tls.client.cert`                                  | TLS certificate for NATS clients. Ignored if `tls.client.existingSecret` is set                                                                                                 | `""`                   |
| `tls.client.key`                                   | TLS key for NATS clients. Ignored if `tls.client.existingSecret` is set                                                                                                         | `""`                   |
| `tls.client.existingSecret`                        | The name of an existing Secret containing the TLS certificates for NATS clients                                                                                                 | `""`                   |
| `cluster.name`                                     | Cluster name                                                                                                                                                                    | `nats`                 |
| `cluster.connectRetries`                           | Configure number of connect retries for implicit routes, otherwise leave blank                                                                                                  | `""`                   |
| `cluster.auth.enabled`                             | Switch to enable/disable cluster authentication                                                                                                                                 | `true`                 |
| `cluster.auth.user`                                | Cluster authentication user                                                                                                                                                     | `nats_cluster`         |
| `cluster.auth.password`                            | Cluster authentication password                                                                                                                                                 | `""`                   |
| `jetstream.enabled`                                | Switch to enable/disable JetStream                                                                                                                                              | `false`                |
| `jetstream.maxMemory`                              | Max memory usage for JetStream                                                                                                                                                  | `1G`                   |
| `jetstream.storeDirectory`                         | Directory to store JetStream data                                                                                                                                               | `/data`                |
| `debug.enabled`                                    | Switch to enable/disable debug on logging                                                                                                                                       | `false`                |
| `debug.trace`                                      | Switch to enable/disable trace debug level on logging                                                                                                                           | `false`                |
| `debug.logtime`                                    | Switch to enable/disable logtime on logging                                                                                                                                     | `false`                |
| `maxConnections`                                   | Max. number of client connections                                                                                                                                               | `""`                   |
| `maxControlLine`                                   | Max. protocol control line                                                                                                                                                      | `""`                   |
| `maxPayload`                                       | Max. payload                                                                                                                                                                    | `""`                   |
| `writeDeadline`                                    | Duration the server can block on a socket write to a client                                                                                                                     | `""`                   |
| `natsFilename`                                     | Filename used by several NATS files (binary, configuration file, and pid file)                                                                                                  | `nats-server`          |
| `configuration`                                    | Specify content for NATS configuration file (generated based on other parameters otherwise)                                                                                     | `""`                   |
| `existingSecret`                                   | Name of an existing secret with your custom configuration for NATS                                                                                                              | `""`                   |
| `command`                                          | Override default container command (useful when using custom images)                                                                                                            | `[]`                   |
| `args`                                             | Override default container args (useful when using custom images)                                                                                                               | `[]`                   |
| `extraEnvVars`                                     | Extra environment variables to be set on NATS container                                                                                                                         | `[]`                   |
| `extraEnvVarsCM`                                   | ConfigMap with extra environment variables                                                                                                                                      | `""`                   |
| `extraEnvVarsSecret`                               | Secret with extra environment variables                                                                                                                                         | `""`                   |

### NATS deployment/statefulset parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `resourceType`                                      | NATS cluster resource type under Kubernetes. Allowed values: `statefulset` (default) or `deployment`                                                                                                              | `statefulset`    |
| `replicaCount`                                      | Number of NATS nodes                                                                                                                                                                                              | `1`              |
| `schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                         | `""`             |
| `priorityClassName`                                 | Name of pod priority class                                                                                                                                                                                        | `""`             |
| `updateStrategy.type`                               | NATS deployment/statefulset update strategy type                                                                                                                                                                  | `RollingUpdate`  |
| `podManagementPolicy`                               | StatefulSet pod management policy                                                                                                                                                                                 | `OrderedReady`   |
| `containerPorts.client`                             | NATS client container port                                                                                                                                                                                        | `4222`           |
| `containerPorts.cluster`                            | NATS cluster container port                                                                                                                                                                                       | `6222`           |
| `containerPorts.monitoring`                         | NATS monitoring container port                                                                                                                                                                                    | `8222`           |
| `podSecurityContext.enabled`                        | Enabled NATS pods' Security Context                                                                                                                                                                               | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set NATS pod's Security Context fsGroup                                                                                                                                                                           | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`             |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`           |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `30`             |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `5`              |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe on NATS containers                                                                                                                                                                            | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `5`              |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`             |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`             |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`             |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`          |
| `hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                       | `[]`             |
| `podLabels`                                         | Extra labels for NATS pods                                                                                                                                                                                        | `{}`             |
| `podAnnotations`                                    | Annotations for NATS pods                                                                                                                                                                                         | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`             |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                             | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                          | `[]`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for NATS pods assignment spread across your cluster among failure-domains                                                                                                             | `[]`             |
| `lifecycleHooks`                                    | for the NATS container(s) to automate configuration before or after startup                                                                                                                                       | `{}`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for NATS pods                                                                                                                                                 | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for NATS container(s)                                                                                                                                    | `[]`             |
| `initContainers`                                    | Add additional init containers to the NATS pods                                                                                                                                                                   | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the NATS pods                                                                                                                                                                | `[]`             |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for NATS pod                                                                                                                                                                    | `true`           |
| `serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                            | `""`             |
| `serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                            | `false`          |
| `serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                              | `{}`             |

### Traffic Exposure parameters

| Name                                        | Description                                                                                                                      | Value                    |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                              | NATS service type                                                                                                                | `ClusterIP`              |
| `service.ports.client`                      | NATS client service port                                                                                                         | `4222`                   |
| `service.ports.cluster`                     | NATS cluster service port                                                                                                        | `6222`                   |
| `service.ports.monitoring`                  | NATS monitoring service port                                                                                                     | `8222`                   |
| `service.nodePorts.client`                  | Node port for clients                                                                                                            | `""`                     |
| `service.nodePorts.cluster`                 | Node port for clustering                                                                                                         | `""`                     |
| `service.nodePorts.monitoring`              | Node port for monitoring                                                                                                         | `""`                     |
| `service.sessionAffinity`                   | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`             | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                         | NATS service Cluster IP                                                                                                          | `""`                     |
| `service.loadBalancerIP`                    | NATS service Load Balancer IP                                                                                                    | `""`                     |
| `service.loadBalancerSourceRanges`          | NATS service Load Balancer sources                                                                                               | `[]`                     |
| `service.externalTrafficPolicy`             | NATS service external traffic policy                                                                                             | `Cluster`                |
| `service.annotations`                       | Additional custom annotations for NATS service                                                                                   | `{}`                     |
| `service.extraPorts`                        | Extra ports to expose in the NATS service (normally used with the `sidecar` value)                                               | `[]`                     |
| `service.headless.annotations`              | Annotations for the headless service.                                                                                            | `{}`                     |
| `service.headless.publishNotReadyAddresses` | Publishes the addresses of not ready Pods                                                                                        | `false`                  |
| `ingress.enabled`                           | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`                          | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                        | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`                          | When the ingress is enabled, a host pointing to this will be created                                                             | `nats.local`             |
| `ingress.path`                              | The Path to NATS. You may need to set this to '/*' in order to use this with ALB ingress controllers.                            | `/`                      |
| `ingress.ingressClassName`                  | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.annotations`                       | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                               | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                        | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                        | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`                        | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                          | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                           | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`                        | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `networkPolicy.enabled`                     | Enable creation of NetworkPolicy resources                                                                                       | `true`                   |
| `networkPolicy.allowExternal`               | The Policy model to apply                                                                                                        | `true`                   |
| `networkPolicy.allowExternalEgress`         | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`                | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`                 | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`        | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels`     | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |

### Metrics parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                           |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `metrics.enabled`                                           | Enable Prometheus metrics via exporter side-car                                                                                                                                                                                   | `false`                         |
| `metrics.image.registry`                                    | Prometheus metrics exporter image registry                                                                                                                                                                                        | `REGISTRY_NAME`                 |
| `metrics.image.repository`                                  | Prometheus metrics exporter image repository                                                                                                                                                                                      | `REPOSITORY_NAME/nats-exporter` |
| `metrics.image.digest`                                      | NATS Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                            |
| `metrics.image.pullPolicy`                                  | Prometheus metrics image pull policy                                                                                                                                                                                              | `IfNotPresent`                  |
| `metrics.image.pullSecrets`                                 | Prometheus metrics image pull secrets                                                                                                                                                                                             | `[]`                            |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                              | `true`                          |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `15`                            |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                             |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                            |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `3`                             |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                             |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                             | `true`                          |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `5`                             |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `1`                             |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                            |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                             |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                             |
| `metrics.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                   | `{}`                            |
| `metrics.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                  | `{}`                            |
| `metrics.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`                          |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                            |
| `metrics.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`                          |
| `metrics.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `1001`                          |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`                          |
| `metrics.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`                         |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`                          |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`                         |
| `metrics.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                       |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`                |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                          |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                            |
| `metrics.containerPorts.http`                               | Prometheus metrics exporter port                                                                                                                                                                                                  | `7777`                          |
| `metrics.flags`                                             | Flags to be passed to Prometheus metrics                                                                                                                                                                                          | `[]`                            |
| `metrics.service.type`                                      | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                                                                                                                               | `ClusterIP`                     |
| `metrics.service.port`                                      | Prometheus metrics service port                                                                                                                                                                                                   | `7777`                          |
| `metrics.service.loadBalancerIP`                            | Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank                                                                                                                                                  | `""`                            |
| `metrics.service.annotations`                               | Annotations for Prometheus metrics service                                                                                                                                                                                        | `{}`                            |
| `metrics.service.labels`                                    | Labels for Prometheus metrics service                                                                                                                                                                                             | `{}`                            |
| `metrics.serviceMonitor.enabled`                            | Specify if a ServiceMonitor will be deployed for Prometheus Operator                                                                                                                                                              | `false`                         |
| `metrics.serviceMonitor.namespace`                          | Namespace in which Prometheus is running                                                                                                                                                                                          | `monitoring`                    |
| `metrics.serviceMonitor.labels`                             | Extra labels for the ServiceMonitor                                                                                                                                                                                               | `{}`                            |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in Prometheus                                                                                                                                                  | `""`                            |
| `metrics.serviceMonitor.interval`                           | How frequently to scrape metrics                                                                                                                                                                                                  | `""`                            |
| `metrics.serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                                                                                           | `""`                            |
| `metrics.serviceMonitor.metricRelabelings`                  | Specify additional relabeling of metrics                                                                                                                                                                                          | `[]`                            |
| `metrics.serviceMonitor.relabelings`                        | Specify general relabeling                                                                                                                                                                                                        | `[]`                            |
| `metrics.serviceMonitor.selector`                           | Prometheus instance selector labels                                                                                                                                                                                               | `{}`                            |

### Persistence parameters

| Name                                               | Description                                                                    | Value               |
| -------------------------------------------------- | ------------------------------------------------------------------------------ | ------------------- |
| `persistence.enabled`                              | Enable NATS data persistence using PVCs (only for statefulset resourceType)    | `false`             |
| `persistence.storageClass`                         | PVC Storage Class for NATS data volume                                         | `""`                |
| `persistence.accessModes`                          | PVC Access modes                                                               | `["ReadWriteOnce"]` |
| `persistence.size`                                 | PVC Storage Request for NATS data volume                                       | `8Gi`               |
| `persistence.annotations`                          | Annotations for the PVC                                                        | `{}`                |
| `persistence.selector`                             | Selector to match an existing Persistent Volume for NATS's data PVC            | `{}`                |
| `persistentVolumeClaimRetentionPolicy.enabled`     | Enable Persistent volume retention policy for NATS statefulset                 | `false`             |
| `persistentVolumeClaimRetentionPolicy.whenScaled`  | Volume retention behavior when the replica count of the StatefulSet is reduced | `Retain`            |
| `persistentVolumeClaimRetentionPolicy.whenDeleted` | Volume retention behavior that applies when the StatefulSet is deleted         | `Retain`            |

### Other parameters

| Name                 | Description                                                    | Value  |
| -------------------- | -------------------------------------------------------------- | ------ |
| `pdb.create`         | Enable/disable a Pod Disruption Budget creation                | `true` |
| `pdb.minAvailable`   | Minimum number/percentage of pods that should remain scheduled | `""`   |
| `pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable | `""`   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set auth.enabled=true,auth.credentials[0].user=my-user,auth.credentials[0].password=T0pS3cr3t \
    oci://REGISTRY_NAME/REPOSITORY_NAME/nats
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command enables NATS client authentication with `my-user` as user and `T0pS3cr3t` as password credentials.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/nats
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/nats/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 9.0.0

This major versions ships by default a new NATS image version that dramatically reduces the image given there's no distro and it simply includes the NATS binary on top of a scratch base image. As a consequence, there's no shell available in the image and debugging actions must be performed using sidecars or equivalent mechanisms.

Also, the default path for storing JetStream data is `/data/jetstream` instead of `/data/jetstream/jetstream` to avoid stuttering. If you're upgrading from an existing installation with persisted data, you'll have to edit the JetStream's "store_dir" configuration property so it's compatible with your previous data.

Finally, the following changes are also introduced on chart parameters in this major version update:

- `auth.usersCredentials` is renamed to `auth.credentials`.
- `auth.user` and `auth.password` are deprecated in favor of `auth.credentials`.

### To 8.5.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 8.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 7.0.0

This new version updates the NATS image to a [new version that has support to configure NATS based on bash logic](https://github.com/bitnami/containers/tree/main/bitnami/nats#264-r13), although this chart overwrites the configuration file so that shouldn't affect the functionality. It also adds several standardizations that were missing in the chart:

- Add missing parameters such as `existingSecret`, `containerPorts.*`, `startupProbe.*` or `lifecycleHooks`.
- Add missing parameters to extend the services such as `service.extraPorts` or `service.sessionAffinity`.
- Add missing parameters to customize the ServiceMonitor for Prometheus Operator.

Other important changes:

- The NATS configuration file is no longer retrieved from a ConfigMap but a Secret instead.
- Regroup the client, cluster and monitoring service into a single service that exposes every port.

Consequences:

- Backwards compatibility is not guaranteed.

### To 6.0.0

- Some parameters were renamed or disappeared in favor of new ones on this major version. For instance:
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
- Ingress configuration was adapted to follow the Helm charts best practices.
- Chart labels were also adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed.

### To 5.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### Deploy chart with NATS version 1.x.x

NATS version 2.0.0 has renamed the server binary filename from `gnatsd` to `nats-server`. Therefore, the default values has been changed in the chart,
however, it is still possible to use the chart to deploy NATS version 1.x.x using the `natsFilename` property.

```console
helm install nats-v1 --set natsFilename=gnatsd --set image.tag=1.4.1 oci://REGISTRY_NAME/REPOSITORY_NAME/nats
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nats:

```console
kubectl delete statefulset nats-nats --cascade=false
```

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