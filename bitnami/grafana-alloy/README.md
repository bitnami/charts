<!--- app-name: Grafana Alloy -->

# Bitnami Secure Images Helm chart for Grafana Alloy

Grafana Alloy is an open source OpenTelemetry Collector distribution with built-in Prometheus pipelines and support for metrics, logs, traces, and profiles.

[Overview of Grafana Alloy](https://grafana.com/oss/alloy-opentelemetry-collector/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/grafana-alloy
```

## Why use Bitnami Secure Images?

Those are hardened, minimal CVE images built and maintained by Bitnami. Bitnami Secure Images are based on the cloud-optimized, security-hardened enterprise [OS Photon Linux](https://vmware.github.io/photon/). Why choose BSI images?

- Hardened secure images of popular open source software with Near-Zero Vulnerabilities
- Vulnerability Triage & Prioritization with VEX Statements, KEV and EPSS Scores
- Compliance focus with FIPS, STIG, and air-gap options, including secure bill of materials (SBOM)
- Software supply chain provenance attestation through in-toto
- First class support for the internet’s favorite Helm charts

Each image comes with valuable security metadata. You can view the metadata in [our public catalog here](https://app-catalog.vmware.com/bitnami/apps). Note: Some data is only available with [commercial subscriptions to BSI](https://bitnami.com/).

![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%201.png?raw=true "Application details")
![Alt text](https://github.com/bitnami/containers/blob/main/BSI%20UI%202.png?raw=true "Packaging report")

If you are looking for our previous generation of images based on Debian Linux, please see the [Bitnami Legacy registry](https://hub.docker.com/u/bitnamilegacy).

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Grafana Alloy](https://github.com/grafana/alloy) deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/grafana-alloy
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Grafana Alloy on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Alloy configuration

The Bitnami Grafana Alloy chart allows [providing a configuration](https://grafana.com/docs/alloy/latest/get-started/configuration-syntax/) using ConfigMaps. This is done using the `alloy.configuration` parameter. It is also possible to append the provided settings with the default configuration by using the `alloy.extraConfig` parameter. In the example below we add extra configuration parameters:

```yaml
alloy:
  extraConfig:|
    loki.write "local_loki" {
      endpoint {
        url = "http://loki:3100/loki/api/v1/push"
      }
  }
```

It is also possible to use an existing ConfigMap using the `alloy.existingConfigMap` parameter.

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
alloy:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as Grafana Alloy (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose Grafana Alloy native Prometheus endpoint in a metrics service that can be configured under the `metrics.service` section. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |
| `global.compatibility.omitEmptySeLinuxOptions`        | If set to true, removes the seLinuxOptions from the securityContexts when it is set to an empty object                                                                                                                                                                                                                                                              | `false` |

### Common parameters

| Name                                      | Description                                                                                                                                    | Value           |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `resourceType`                            | Type of controller to use for deploying Grafana Alloy in the cluster.                                                                          | `daemonset`     |
| `replicaCount`                            | Number of pods to deploy. Ignored when resourceType is 'daemonset'.                                                                            | `1`             |
| `kubeVersion`                             | Override Kubernetes version                                                                                                                    | `""`            |
| `apiVersions`                             | Override Kubernetes API versions reported by .Capabilities                                                                                     | `[]`            |
| `nameOverride`                            | String to partially override common.names.name                                                                                                 | `""`            |
| `fullnameOverride`                        | String to fully override common.names.fullname                                                                                                 | `""`            |
| `namespaceOverride`                       | String to fully override common.names.namespace                                                                                                | `""`            |
| `commonLabels`                            | Labels to add to all deployed objects                                                                                                          | `{}`            |
| `commonAnnotations`                       | Annotations to add to all deployed objects                                                                                                     | `{}`            |
| `clusterDomain`                           | Kubernetes cluster domain name                                                                                                                 | `cluster.local` |
| `extraDeploy`                             | Array of extra objects to deploy with the release                                                                                              | `[]`            |
| `diagnosticMode.enabled`                  | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                        | `false`         |
| `diagnosticMode.command`                  | Command to override all containers in the chart release                                                                                        | `["sleep"]`     |
| `diagnosticMode.args`                     | Args to override all containers in the chart release                                                                                           | `["infinity"]`  |
| `podSecurityContext.enabled`              | Enable Grafana Alloy pods' Security Context                                                                                                    | `true`          |
| `podSecurityContext.fsGroupChangePolicy`  | Set filesystem group change policy for Grafana Alloy pods                                                                                      | `Always`        |
| `podSecurityContext.sysctls`              | Set kernel settings using the sysctl interface for Grafana Alloy pods                                                                          | `[]`            |
| `podSecurityContext.supplementalGroups`   | Set filesystem extra groups for Grafana Alloy pods                                                                                             | `[]`            |
| `podSecurityContext.fsGroup`              | Set fsGroup in Grafana Alloy pods' Security Context                                                                                            | `1001`          |
| `hostAliases`                             | Grafana Alloy pods host aliases                                                                                                                | `[]`            |
| `controllerAnnotations`                   | Annotations for Grafana Alloy controller                                                                                                       | `{}`            |
| `podLabels`                               | Extra labels for Grafana Alloy pods                                                                                                            | `{}`            |
| `podAnnotations`                          | Annotations for Grafana Alloy pods                                                                                                             | `{}`            |
| `podAffinityPreset`                       | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                            | `""`            |
| `podAntiAffinityPreset`                   | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                       | `soft`          |
| `nodeAffinityPreset.type`                 | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                      | `""`            |
| `nodeAffinityPreset.key`                  | Node label key to match. Ignored if `affinity` is set                                                                                          | `""`            |
| `nodeAffinityPreset.values`               | Node label values to match. Ignored if `affinity` is set                                                                                       | `[]`            |
| `affinity`                                | Affinity for Grafana Alloy pods assignment                                                                                                     | `{}`            |
| `nodeSelector`                            | Node labels for Grafana Alloy pods assignment                                                                                                  | `{}`            |
| `tolerations`                             | Tolerations for Grafana Alloy pods assignment                                                                                                  | `[]`            |
| `updateStrategy.type`                     | Grafana Alloy daemonset strategy type                                                                                                          | `RollingUpdate` |
| `updateStrategy.type`                     | Grafana Alloy deployment strategy type                                                                                                         | `RollingUpdate` |
| `updateStrategy.type`                     | Grafana Alloy statefulset strategy type                                                                                                        | `RollingUpdate` |
| `podManagementPolicy`                     | Pod management policy for Grafana Alloy statefulset                                                                                            | `OrderedReady`  |
| `priorityClassName`                       | Grafana Alloy pods' priorityClassName                                                                                                          | `""`            |
| `topologySpreadConstraints`               | Topology Spread Constraints for Grafana Alloy pod assignment spread across your cluster among failure-domains                                  | `[]`            |
| `schedulerName`                           | Name of the k8s scheduler (other than default) for Grafana Alloy pods                                                                          | `""`            |
| `terminationGracePeriodSeconds`           | Seconds Grafana Alloy pods need to terminate gracefully                                                                                        | `""`            |
| `sidecars`                                | Add additional sidecar containers to the Grafana Alloy pods                                                                                    | `[]`            |
| `initContainers`                          | Add additional init containers to the Grafana Alloy pods                                                                                       | `[]`            |
| `extraVolumes`                            | Optionally specify extra list of additional volumes for the Grafana Alloy pods                                                                 | `[]`            |
| `pdb.create`                              | Enable/disable a Pod Disruption Budget creation                                                                                                | `true`          |
| `pdb.minAvailable`                        | Minimum number/percentage of pods that should remain scheduled                                                                                 | `""`            |
| `pdb.maxUnavailable`                      | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty. | `""`            |
| `autoscaling.vpa.enabled`                 | Enable VPA for Grafana Alloy pods                                                                                                              | `false`         |
| `autoscaling.vpa.annotations`             | Annotations for VPA resource                                                                                                                   | `{}`            |
| `autoscaling.vpa.controlledResources`     | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                 | `[]`            |
| `autoscaling.vpa.maxAllowed`              | VPA Max allowed resources for the pod                                                                                                          | `{}`            |
| `autoscaling.vpa.minAllowed`              | VPA Min allowed resources for the pod                                                                                                          | `{}`            |
| `autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy                                                                                                                      | `Auto`          |
| `autoscaling.hpa.enabled`                 | Enable HPA for Grafana Alloy pods                                                                                                              | `false`         |
| `autoscaling.hpa.minReplicas`             | Minimum number of replicas                                                                                                                     | `""`            |
| `autoscaling.hpa.maxReplicas`             | Maximum number of replicas                                                                                                                     | `""`            |
| `autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                              | `""`            |
| `autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                           | `""`            |

### Grafana Alloy parameters

| Name                                                      | Description                                                                                                                                                                                                                          | Value                           |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------- |
| `alloy.image.registry`                                    | Grafana Alloy image registry                                                                                                                                                                                                         | `REGISTRY_NAME`                 |
| `alloy.image.repository`                                  | Grafana Alloy image repository                                                                                                                                                                                                       | `REPOSITORY_NAME/grafana-alloy` |
| `alloy.image.pullPolicy`                                  | Grafana Alloy image pull policy                                                                                                                                                                                                      | `IfNotPresent`                  |
| `alloy.image.pullSecrets`                                 | Grafana Alloy image pull secrets                                                                                                                                                                                                     | `[]`                            |
| `alloy.containerPorts.http`                               | Grafana Alloy HTTP container port                                                                                                                                                                                                    | `8080`                          |
| `alloy.extraContainerPorts`                               | Optionally specify extra list of additional ports for Grafana Alloy containers                                                                                                                                                       | `[]`                            |
| `alloy.existingSecret`                                    | The name of an existing Secret with your custom configuration for Grafana Alloy                                                                                                                                                      | `""`                            |
| `alloy.configuration`                                     | Specify content for Grafana Alloy config file. Omitted if alloy.existingSecret is provided.                                                                                                                                          | `""`                            |
| `alloy.extraConfig`                                       | Append extra configuration to the default config file                                                                                                                                                                                | `""`                            |
| `alloy.clustering.enabled`                                | Deploy Grafana Alloy in a cluster to allow for load distribution.                                                                                                                                                                    | `false`                         |
| `alloy.clustering.name`                                   | Name for the Grafana Alloy cluster. Used for differentiating between clusters.                                                                                                                                                       | `""`                            |
| `alloy.clustering.portName`                               | Name for the port used for clustering, useful if running inside an Istio Mesh                                                                                                                                                        | `http`                          |
| `alloy.stabilityLevel`                                    | Minimum stability level of components and behavior to enable. Must be                                                                                                                                                                | `generally-available`           |
| `alloy.listenAddr`                                        | Address to listen for traffic on. 0.0.0.0 exposes the UI to other containers.                                                                                                                                                        | `0.0.0.0`                       |
| `alloy.uiPathPrefix`                                      | Base path where the UI is exposed.                                                                                                                                                                                                   | `/`                             |
| `alloy.storagePath`                                       | Path to where Grafana Alloy stores data (for example, the Write-Ahead Log).                                                                                                                                                          | `/tmp/alloy`                    |
| `alloy.enableReporting`                                   | Enables sending Grafana Labs anonymous usage stats to help improve Grafana Alloy.                                                                                                                                                    | `true`                          |
| `alloy.command`                                           | Override default Grafana Alloy container command (useful when using custom images)                                                                                                                                                   | `[]`                            |
| `alloy.args`                                              | Override default Grafana Alloy container args (useful when using custom images)                                                                                                                                                      | `[]`                            |
| `alloy.mounts.varlog`                                     | Mount /var/log from the host into the container for log collection.                                                                                                                                                                  | `true`                          |
| `alloy.mounts.dockercontainers`                           | Mount /var/lib/docker/containers from the host into the container for log                                                                                                                                                            | `true`                          |
| `alloy.startupProbe.enabled`                              | Enable startupProbe on Grafana Alloy containers                                                                                                                                                                                      | `false`                         |
| `alloy.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                               | `30`                            |
| `alloy.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                      | `30`                            |
| `alloy.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                     | `2`                             |
| `alloy.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                   | `3`                             |
| `alloy.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                   | `1`                             |
| `alloy.livenessProbe.enabled`                             | Enable livenessProbe on Grafana Alloy containers                                                                                                                                                                                     | `true`                          |
| `alloy.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                              | `30`                            |
| `alloy.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                     | `30`                            |
| `alloy.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                    | `2`                             |
| `alloy.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                  | `3`                             |
| `alloy.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                  | `1`                             |
| `alloy.readinessProbe.enabled`                            | Enable readinessProbe on Grafana Alloy containers                                                                                                                                                                                    | `true`                          |
| `alloy.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                             | `30`                            |
| `alloy.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                    | `30`                            |
| `alloy.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                   | `2`                             |
| `alloy.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                 | `3`                             |
| `alloy.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                 | `1`                             |
| `alloy.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                  | `{}`                            |
| `alloy.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                 | `{}`                            |
| `alloy.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                   | `{}`                            |
| `alloy.resourcesPreset`                                   | Set Grafana Alloy container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if alloy.resources is set (alloy.resources is recommended for production). | `nano`                          |
| `alloy.resources`                                         | Set Grafana Alloy container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                      | `{}`                            |
| `alloy.containerSecurityContext.enabled`                  | Enabled Grafana Alloy container's Security Context                                                                                                                                                                                   | `true`                          |
| `alloy.containerSecurityContext.seLinuxOptions`           | Set SELinux options in Grafana Alloy container                                                                                                                                                                                       | `{}`                            |
| `alloy.containerSecurityContext.runAsUser`                | Set runAsUser in Grafana Alloy container's Security Context                                                                                                                                                                          | `1001`                          |
| `alloy.containerSecurityContext.runAsGroup`               | Group ID for Grafana Alloy's containers                                                                                                                                                                                              | `1001`                          |
| `alloy.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in Grafana Alloy container's Security Context                                                                                                                                                                       | `true`                          |
| `alloy.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in Grafana Alloy container's Security Context                                                                                                                                                             | `true`                          |
| `alloy.containerSecurityContext.privileged`               | Set privileged in Grafana Alloy container's Security Context                                                                                                                                                                         | `false`                         |
| `alloy.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in Grafana Alloy container's Security Context                                                                                                                                                           | `false`                         |
| `alloy.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in Grafana Alloy container                                                                                                                                                                        | `["ALL"]`                       |
| `alloy.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in Grafana Alloy container                                                                                                                                                                                       | `RuntimeDefault`                |
| `alloy.lifecycleHooks`                                    | for Grafana Alloy containers to automate configuration before or after startup                                                                                                                                                       | `{}`                            |
| `alloy.extraEnvVars`                                      | Array with extra environment variables to add to Grafana Alloy containers                                                                                                                                                            | `[]`                            |
| `alloy.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Grafana Alloy containers                                                                                                                                                    | `""`                            |
| `alloy.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Grafana Alloy containers                                                                                                                                                       | `""`                            |
| `alloy.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Grafana Alloy containers                                                                                                                                            | `[]`                            |

### ConfigMap Reload parameters

| Name                                                               | Description                                                                                                                                                                                                                                               | Value                                      |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `configReloader.enabled`                                           | Enables automatically reloading when the Grafana Alloy config changes.                                                                                                                                                                                    | `true`                                     |
| `configReloader.image.registry`                                    | ConfigMap Reload image registry                                                                                                                                                                                                                           | `REGISTRY_NAME`                            |
| `configReloader.image.repository`                                  | ConfigMap Reload image repository                                                                                                                                                                                                                         | `REPOSITORY_NAME/grafana-configmap-reload` |
| `configReloader.image.pullPolicy`                                  | ConfigMap Reload image pull policy                                                                                                                                                                                                                        | `IfNotPresent`                             |
| `configReloader.image.pullSecrets`                                 | ConfigMap Reload image pull secrets                                                                                                                                                                                                                       | `[]`                                       |
| `configReloader.containerPorts.http`                               | ConfigMap Reload HTTP container port                                                                                                                                                                                                                      | `9533`                                     |
| `configReloader.extraContainerPorts`                               | Optionally specify extra list of additional ports for ConfigMap Reload containers                                                                                                                                                                         | `[]`                                       |
| `configReloader.startupProbe.enabled`                              | Enable startupProbe on ConfigMap Reload containers                                                                                                                                                                                                        | `false`                                    |
| `configReloader.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                                    | `30`                                       |
| `configReloader.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                                           | `30`                                       |
| `configReloader.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                                          | `2`                                        |
| `configReloader.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                                        | `3`                                        |
| `configReloader.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                                        | `1`                                        |
| `configReloader.livenessProbe.enabled`                             | Enable livenessProbe on ConfigMap Reload containers                                                                                                                                                                                                       | `true`                                     |
| `configReloader.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                                   | `30`                                       |
| `configReloader.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                                          | `30`                                       |
| `configReloader.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                                         | `2`                                        |
| `configReloader.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                                       | `3`                                        |
| `configReloader.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                                       | `1`                                        |
| `configReloader.readinessProbe.enabled`                            | Enable readinessProbe on ConfigMap Reload containers                                                                                                                                                                                                      | `true`                                     |
| `configReloader.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                                  | `30`                                       |
| `configReloader.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                                         | `30`                                       |
| `configReloader.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                                        | `2`                                        |
| `configReloader.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                                      | `3`                                        |
| `configReloader.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                                      | `1`                                        |
| `configReloader.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                                       | `{}`                                       |
| `configReloader.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                                      | `{}`                                       |
| `configReloader.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                                        | `{}`                                       |
| `configReloader.resourcesPreset`                                   | Set ConfigMap Reload container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if configReloader.resources is set (configReloader.resources is recommended for production). | `nano`                                     |
| `configReloader.resources`                                         | Set ConfigMap Reload container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                        | `{}`                                       |
| `configReloader.containerSecurityContext.enabled`                  | Enabled ConfigMap Reload container's Security Context                                                                                                                                                                                                     | `true`                                     |
| `configReloader.containerSecurityContext.seLinuxOptions`           | Set SELinux options in ConfigMap Reload container                                                                                                                                                                                                         | `{}`                                       |
| `configReloader.containerSecurityContext.runAsUser`                | Set runAsUser in ConfigMap Reload container's Security Context                                                                                                                                                                                            | `1001`                                     |
| `configReloader.containerSecurityContext.runAsGroup`               | Group ID for ConfigMap Reload's containers                                                                                                                                                                                                                | `1001`                                     |
| `configReloader.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in ConfigMap Reload container's Security Context                                                                                                                                                                                         | `true`                                     |
| `configReloader.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in ConfigMap Reload container's Security Context                                                                                                                                                                               | `true`                                     |
| `configReloader.containerSecurityContext.privileged`               | Set privileged inConfigMap Reload container's Security Context                                                                                                                                                                                            | `false`                                    |
| `configReloader.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in ConfigMap Reload container's Security Context                                                                                                                                                                             | `false`                                    |
| `configReloader.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in ConfigMap Reload container                                                                                                                                                                                          | `["ALL"]`                                  |
| `configReloader.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in ConfigMap Reload container                                                                                                                                                                                                         | `RuntimeDefault`                           |
| `configReloader.command`                                           | Override default ConfigMap Reload container command (useful when using custom images)                                                                                                                                                                     | `[]`                                       |
| `configReloader.args`                                              | Override default ConfigMap Reload container args (useful when using custom images)                                                                                                                                                                        | `[]`                                       |
| `configReloader.lifecycleHooks`                                    | for Grafana Alloy containers to automate configuration before or after startup                                                                                                                                                                            | `{}`                                       |
| `configReloader.extraEnvVars`                                      | Array with extra environment variables to add to Grafana Alloy containers                                                                                                                                                                                 | `[]`                                       |
| `configReloader.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for ConfigMap Reload containers                                                                                                                                                                      | `""`                                       |
| `configReloader.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for ConfigMap Reload containers                                                                                                                                                                         | `""`                                       |
| `configReloader.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the ConfigMap Reload containers                                                                                                                                                              | `[]`                                       |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value         |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `service.type`                          | Grafana Alloy service type                                                                                                       | `ClusterIP`   |
| `service.ports.http`                    | Grafana Alloy service HTTP port                                                                                                  | `80`          |
| `service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`          |
| `service.clusterIP`                     | Grafana Alloy service Cluster IP                                                                                                 | `""`          |
| `service.loadBalancerIP`                | Grafana Alloy service Load Balancer IP                                                                                           | `""`          |
| `service.loadBalancerSourceRanges`      | Grafana Alloy service Load Balancer sources                                                                                      | `[]`          |
| `service.externalTrafficPolicy`         | Grafana Alloy service external traffic policy                                                                                    | `Cluster`     |
| `service.annotations`                   | Additional custom annotations for Grafana Alloy service                                                                          | `{}`          |
| `service.extraPorts`                    | Extra ports to expose in Grafana Alloy service (normally used with the `sidecars` value)                                         | `[]`          |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                                 | `None`        |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`          |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`        |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`        |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`        |
| `networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.                        | `true`        |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`          |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy (ignored if allowExternalEgress=true)                                               | `[]`          |
| `networkPolicy.ingressPodMatchLabels`   | Labels to match to allow traffic from other pods. Ignored if `networkPolicy.allowExternal` is true.                              | `{}`          |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.                        | `{}`          |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.                    | `{}`          |
| `ingress.enabled`                       | Enable ingress record generation for Grafana Alloy                                                                               | `false`       |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `Prefix`      |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`          |
| `ingress.hostname`                      | Default host for the ingress record                                                                                              | `alloy.local` |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`          |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `/`           |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`          |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`       |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`       |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`          |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`          |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`          |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`          |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`          |

### Other Parameters

| Name                                          | Description                                                                                            | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                     | `true`  |
| `rbac.rules`                                  | Custom RBAC rules to set                                                                               | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                   | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                 | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)                                       | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                         | `true`  |
| `metrics.enabled`                             | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`            | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.annotations`          | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `metrics.serviceMonitor.labels`               | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `metrics.serviceMonitor.jobLabel`             | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `metrics.serviceMonitor.honorLabels`          | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `metrics.serviceMonitor.interval`             | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.metricRelabelings`    | Specify additional relabeling of metrics                                                               | `[]`    |
| `metrics.serviceMonitor.relabelings`          | Specify general relabeling                                                                             | `[]`    |
| `metrics.serviceMonitor.selector`             | Prometheus instance selector labels                                                                    | `{}`    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set aggregator.port=24444 oci://REGISTRY_NAME/REPOSITORY_NAME/fluentd
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the aggregators to listen on port 24444.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/fluentd
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/fluentd/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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
