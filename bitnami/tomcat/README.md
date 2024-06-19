<!--- app-name: Apache Tomcat -->

# Bitnami package for Apache Tomcat

Apache Tomcat is an open-source web server designed to host and run Java-based web applications. It is a lightweight server with a good performance for applications running in production environments.

[Overview of Apache Tomcat](http://tomcat.apache.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/tomcat
```

Looking to use Apache Tomcat in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Tomcat](https://github.com/bitnami/containers/tree/main/bitnami/tomcat) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages, Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment for Java code to run in.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/tomcat
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy Tomcat on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling vs Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different Tomcat version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter.

### Add extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, define a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

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

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Tomcat](https://github.com/bitnami/containers/tree/main/bitnami/tomcat) image stores the Tomcat data and configurations at the `/bitnami/tomcat` path of the container.

Persistent Volume Claims (PVCs) are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an init container to change the ownership of the volume before mounting it in the final destination.

You can enable this init container by setting `volumePermissions.enabled` to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value      |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`       |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`       |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`       |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `disabled` |

### Common parameters

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`      | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`      | Add labels to all the deployed resources                                                     | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                                | `{}`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                            | `[]`            |

### Tomcat parameters

| Name                           | Description                                                                                                                                                     | Value                    |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `image.registry`               | Tomcat image registry                                                                                                                                           | `REGISTRY_NAME`          |
| `image.repository`             | Tomcat image repository                                                                                                                                         | `REPOSITORY_NAME/tomcat` |
| `image.digest`                 | Tomcat image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                          | `""`                     |
| `image.pullPolicy`             | Tomcat image pull policy                                                                                                                                        | `IfNotPresent`           |
| `image.pullSecrets`            | Specify docker-registry secret names as an array                                                                                                                | `[]`                     |
| `image.debug`                  | Specify if debug logs should be enabled                                                                                                                         | `false`                  |
| `automountServiceAccountToken` | Mount Service Account token in pod                                                                                                                              | `false`                  |
| `hostAliases`                  | Deployment pod host aliases                                                                                                                                     | `[]`                     |
| `tomcatUsername`               | Tomcat admin user                                                                                                                                               | `user`                   |
| `tomcatPassword`               | Tomcat admin password                                                                                                                                           | `""`                     |
| `existingSecret`               | Use existing secret for password details (`tomcatPassword` will be ignored and picked up from this secret). The secret has to contain the key `tomcat-password` | `""`                     |
| `tomcatAllowRemoteManagement`  | Enable remote access to management interface                                                                                                                    | `0`                      |
| `catalinaOpts`                 | Java runtime option used by tomcat JVM                                                                                                                          | `""`                     |
| `command`                      | Override default container command (useful when using custom images)                                                                                            | `[]`                     |
| `args`                         | Override default container args (useful when using custom images)                                                                                               | `[]`                     |
| `extraEnvVars`                 | Extra environment variables to be set on Tomcat container                                                                                                       | `[]`                     |
| `extraEnvVarsCM`               | Name of existing ConfigMap containing extra environment variables                                                                                               | `""`                     |
| `extraEnvVarsSecret`           | Name of existing Secret containing extra environment variables                                                                                                  | `""`                     |

### Tomcat deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value               |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `replicaCount`                                      | Specify number of Tomcat replicas                                                                                                                                                                                 | `1`                 |
| `deployment.type`                                   | Use Deployment or StatefulSet                                                                                                                                                                                     | `deployment`        |
| `updateStrategy.type`                               | StrategyType                                                                                                                                                                                                      | `RollingUpdate`     |
| `containerPorts.http`                               | HTTP port to expose at container level                                                                                                                                                                            | `8080`              |
| `containerExtraPorts`                               | Extra ports to expose at container level                                                                                                                                                                          | `[]`                |
| `podSecurityContext.enabled`                        | Enable Tomcat pods' Security Context                                                                                                                                                                              | `true`              |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`            |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                |
| `podSecurityContext.fsGroup`                        | Set Tomcat pod's Security Context fsGroup                                                                                                                                                                         | `1001`              |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`              |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`              |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`              |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`              |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`             |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`              |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`             |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`           |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`    |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`             |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`              |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `120`               |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                 |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`                 |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                 |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`              |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`                |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `5`                 |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `3`                 |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`                 |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                 |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`             |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`                |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `5`                 |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `3`                 |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `3`                 |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                 |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                |
| `podLabels`                                         | Extra labels for Tomcat pods                                                                                                                                                                                      | `{}`                |
| `podAnnotations`                                    | Annotations for Tomcat pods                                                                                                                                                                                       | `{}`                |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`              |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`                |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                             | `{}`                |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`                |
| `schedulerName`                                     | Alternative scheduler                                                                                                                                                                                             | `""`                |
| `lifecycleHooks`                                    | Override default etcd container hooks                                                                                                                                                                             | `{}`                |
| `podManagementPolicy`                               | podManagementPolicy to manage scaling operation of pods (only in StatefulSet mode)                                                                                                                                | `""`                |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                          | `[]`                |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`                |
| `extraPodSpec`                                      | Optionally specify extra PodSpec                                                                                                                                                                                  | `{}`                |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Tomcat pods in Deployment                                                                                                                                 | `[]`                |
| `extraVolumeClaimTemplates`                         | Optionally specify extra list of additional volume claim templates for Tomcat pods in StatefulSet                                                                                                                 | `[]`                |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Tomcat container(s)                                                                                                                                  | `[]`                |
| `initContainers`                                    | Add init containers to the Tomcat pods.                                                                                                                                                                           | `[]`                |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`              |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `""`                |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                                    | `""`                |
| `sidecars`                                          | Add sidecars to the Tomcat pods.                                                                                                                                                                                  | `[]`                |
| `persistence.enabled`                               | Enable persistence                                                                                                                                                                                                | `true`              |
| `persistence.storageClass`                          | PVC Storage Class for Tomcat volume                                                                                                                                                                               | `""`                |
| `persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                               | `{}`                |
| `persistence.accessModes`                           | PVC Access Modes for Tomcat volume                                                                                                                                                                                | `["ReadWriteOnce"]` |
| `persistence.size`                                  | PVC Storage Request for Tomcat volume                                                                                                                                                                             | `8Gi`               |
| `persistence.existingClaim`                         | An Existing PVC name for Tomcat volume                                                                                                                                                                            | `""`                |
| `persistence.selectorLabels`                        | Selector labels to use in volume claim template in statefulset                                                                                                                                                    | `{}`                |
| `networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                               | `true`              |
| `networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                        | `true`              |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                   | `true`              |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                            | `{}`                |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                        | `{}`                |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for Tomcat pod                                                                                                                                                                  | `true`              |
| `serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                            | `""`                |
| `serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                            | `false`             |
| `serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                              | `{}`                |

### Traffic Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                                          | `LoadBalancer`           |
| `service.ports.http`               | Service HTTP port                                                                                                                | `80`                     |
| `service.nodePorts.http`           | Kubernetes http node port                                                                                                        | `""`                     |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.loadBalancerIP`           | Port Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank                                            | `""`                     |
| `service.clusterIP`                | Service Cluster IP                                                                                                               | `""`                     |
| `service.loadBalancerSourceRanges` | Service Load Balancer sources                                                                                                    | `[]`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.annotations`              | Annotations for Tomcat service                                                                                                   | `{}`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.headless.annotations`     | Annotations for the headless service.                                                                                            | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `tomcat.local`           |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter                                                | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.path`                     | Ingress path                                                                                                                     | `/`                      |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |

### Volume Permissions parameters

| Name                                  | Description                                                                                                                                                                                                                                           | Value                      |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory                                                                                                                                                                           | `false`                    |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`  | Init container volume-permissions image repository                                                                                                                                                                                                    | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`      | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `none`                     |
| `volumePermissions.resources`         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |

### Metrics parameters

| Name                                                            | Description                                                                                                                                                                                                                               | Value                                                                                                                                                                                                               |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `metrics.jmx.enabled`                                           | Whether or not to expose JMX metrics to Prometheus                                                                                                                                                                                        | `false`                                                                                                                                                                                                             |
| `metrics.jmx.catalinaOpts`                                      | custom option used to enabled JMX on tomcat jvm evaluated as template                                                                                                                                                                     | `-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=5555 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=true` |
| `metrics.jmx.image.registry`                                    | JMX exporter image registry                                                                                                                                                                                                               | `REGISTRY_NAME`                                                                                                                                                                                                     |
| `metrics.jmx.image.repository`                                  | JMX exporter image repository                                                                                                                                                                                                             | `REPOSITORY_NAME/jmx-exporter`                                                                                                                                                                                      |
| `metrics.jmx.image.digest`                                      | JMX exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                              | `""`                                                                                                                                                                                                                |
| `metrics.jmx.image.pullPolicy`                                  | JMX exporter image pull policy                                                                                                                                                                                                            | `IfNotPresent`                                                                                                                                                                                                      |
| `metrics.jmx.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                          | `[]`                                                                                                                                                                                                                |
| `metrics.jmx.config`                                            | Configuration file for JMX exporter                                                                                                                                                                                                       | `""`                                                                                                                                                                                                                |
| `metrics.jmx.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                      | `true`                                                                                                                                                                                                              |
| `metrics.jmx.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                          | `{}`                                                                                                                                                                                                                |
| `metrics.jmx.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                | `1001`                                                                                                                                                                                                              |
| `metrics.jmx.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                               | `1001`                                                                                                                                                                                                              |
| `metrics.jmx.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                             | `true`                                                                                                                                                                                                              |
| `metrics.jmx.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                               | `false`                                                                                                                                                                                                             |
| `metrics.jmx.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                   | `true`                                                                                                                                                                                                              |
| `metrics.jmx.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                 | `false`                                                                                                                                                                                                             |
| `metrics.jmx.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                        | `["ALL"]`                                                                                                                                                                                                           |
| `metrics.jmx.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                          | `RuntimeDefault`                                                                                                                                                                                                    |
| `metrics.jmx.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.jmx.resources is set (metrics.jmx.resources is recommended for production). | `none`                                                                                                                                                                                                              |
| `metrics.jmx.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                         | `{}`                                                                                                                                                                                                                |
| `metrics.jmx.ports.metrics`                                     | JMX Exporter container metrics ports                                                                                                                                                                                                      | `5556`                                                                                                                                                                                                              |
| `metrics.jmx.existingConfigmap`                                 | Name of existing ConfigMap with JMX exporter configuration                                                                                                                                                                                | `""`                                                                                                                                                                                                                |
| `metrics.podMonitor.podTargetLabels`                            | Used to keep given pod's labels in target                                                                                                                                                                                                 | `[]`                                                                                                                                                                                                                |
| `metrics.podMonitor.enabled`                                    | Create PodMonitor Resource for scraping metrics using PrometheusOperator                                                                                                                                                                  | `false`                                                                                                                                                                                                             |
| `metrics.podMonitor.namespace`                                  | Optional namespace in which Prometheus is running                                                                                                                                                                                         | `""`                                                                                                                                                                                                                |
| `metrics.podMonitor.interval`                                   | Specify the interval at which metrics should be scraped                                                                                                                                                                                   | `30s`                                                                                                                                                                                                               |
| `metrics.podMonitor.scrapeTimeout`                              | Specify the timeout after which the scrape is ended                                                                                                                                                                                       | `30s`                                                                                                                                                                                                               |
| `metrics.podMonitor.additionalLabels`                           | Additional labels that can be used so PodMonitors will be discovered by Prometheus                                                                                                                                                        | `{}`                                                                                                                                                                                                                |
| `metrics.podMonitor.scheme`                                     | Scheme to use for scraping                                                                                                                                                                                                                | `http`                                                                                                                                                                                                              |
| `metrics.podMonitor.tlsConfig`                                  | TLS configuration used for scrape endpoints used by Prometheus                                                                                                                                                                            | `{}`                                                                                                                                                                                                                |
| `metrics.podMonitor.relabelings`                                | Prometheus relabeling rules                                                                                                                                                                                                               | `[]`                                                                                                                                                                                                                |
| `metrics.prometheusRule.enabled`                                | Set this to true to create prometheusRules for Prometheus operator                                                                                                                                                                        | `false`                                                                                                                                                                                                             |
| `metrics.prometheusRule.additionalLabels`                       | Additional labels that can be used so prometheusRules will be discovered by Prometheus                                                                                                                                                    | `{}`                                                                                                                                                                                                                |
| `metrics.prometheusRule.namespace`                              | namespace where prometheusRules resource should be created                                                                                                                                                                                | `""`                                                                                                                                                                                                                |
| `metrics.prometheusRule.rules`                                  | Create specified [Rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)                                                                                                                                      | `[]`                                                                                                                                                                                                                |

The above parameters map to the env variables defined in [bitnami/tomcat](https://github.com/bitnami/containers/tree/main/bitnami/tomcat). For more information please refer to the [bitnami/tomcat](https://github.com/bitnami/containers/tree/main/bitnami/tomcat) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set tomcatUsername=manager,tomcatPassword=password oci://REGISTRY_NAME/REPOSITORY_NAME/tomcat
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Tomcat management username and password to `manager` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/tomcat
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/tomcat/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 11.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 10.0.0

Some of the chart values were changed to adapt to the latest Bitnami standards. More specifically:

- `containerPort` was changed to `containerPorts.http`
- `service.port` was changed to `service.ports.http`

No issues should be expected when upgrading.

### To 8.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- Ingress configuration was also adapted to follow the Helm charts best practices.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Tomcat deployment before upgrading (the following example assumes that the release name is `tomcat`):

```console
export TOMCAT_PASSWORD=$(kubectl get secret --namespace default tomcat -o jsonpath="{.data.tomcat-password}" | base64 -d)
kubectl delete deployments.apps tomcat
helm upgrade tomcat oci://REGISTRY_NAME/REPOSITORY_NAME/tomcat --set tomcatPassword=$TOMCAT_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 7.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### To 5.0.0

This release updates the Bitnami Tomcat container to `9.0.26-debian-9-r0`, which is based on Bash instead of Node.js.

### To 2.1.0

Tomcat container was moved to a non-root approach. There shouldn't be any issue when upgrading since the corresponding `securityContext` is enabled by default. Both the container image and the chart can be upgraded by running the command below:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/tomcat
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

If you use a previous container image (previous to **8.5.35-r26**) disable the `securityContext` by running the command below:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/tomcat --set securityContext.enabled=false,image.tag=XXX
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is tomcat:

```console
kubectl patch deployment tomcat --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
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