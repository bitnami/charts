<!--- app-name: NGINX Ingress Controller -->

# Bitnami package for NGINX Ingress Controller

NGINX Ingress Controller is an Ingress controller that manages external access to HTTP services in a Kubernetes cluster using NGINX.

[Overview of NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller
```

Looking to use NGINX Ingress Controller in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [ingress-nginx](https://github.com/kubernetes/ingress-nginx) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/nginx-ingress-controller
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy nginx-ingress-controller on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the NGINX Ingress Controller (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                | Description                                                          | Value           |
| ------------------- | -------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `""`            |
| `nameOverride`      | String to partially override common.names.fullname                   | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname                       | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace                      | `""`            |
| `commonLabels`      | Add labels to all the deployed resources                             | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                        | `{}`            |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]`            |
| `clusterDomain`     | Kubernetes cluster domain name                                       | `cluster.local` |

### Nginx Ingress Controller parameters

| Name                                   | Description                                                                                                                                        | Value                                      |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `image.registry`                       | Nginx Ingress Controller image registry                                                                                                            | `REGISTRY_NAME`                            |
| `image.repository`                     | Nginx Ingress Controller image repository                                                                                                          | `REPOSITORY_NAME/nginx-ingress-controller` |
| `image.digest`                         | Nginx Ingress Controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                           | `""`                                       |
| `image.pullPolicy`                     | Nginx Ingress Controller image pull policy                                                                                                         | `IfNotPresent`                             |
| `image.pullSecrets`                    | Specify docker-registry secret names as an array                                                                                                   | `[]`                                       |
| `containerPorts.http`                  | Nginx Ingress Controller HTTP port                                                                                                                 | `8080`                                     |
| `containerPorts.https`                 | Nginx Ingress Controller HTTPS port                                                                                                                | `8443`                                     |
| `containerPorts.defaultServer`         | Nginx Ingress Controller default server port                                                                                                       | `8181`                                     |
| `containerPorts.metrics`               | Nginx Ingress Controller metrics port                                                                                                              | `10254`                                    |
| `containerPorts.profiler`              | Nginx Ingress Controller profiler port                                                                                                             | `10245`                                    |
| `containerPorts.status`                | Nginx Ingress Controller status port                                                                                                               | `10246`                                    |
| `containerPorts.stream`                | Nginx Ingress Controller stream port                                                                                                               | `10247`                                    |
| `automountServiceAccountToken`         | Mount Service Account token in pod                                                                                                                 | `true`                                     |
| `hostAliases`                          | Deployment pod host aliases                                                                                                                        | `[]`                                       |
| `config`                               | Custom configuration options for NGINX                                                                                                             | `{}`                                       |
| `proxySetHeaders`                      | Custom headers before sending traffic to backends                                                                                                  | `{}`                                       |
| `addHeaders`                           | Custom headers before sending response traffic to the client                                                                                       | `{}`                                       |
| `defaultBackendService`                | Default 404 backend service; required only if `defaultBackend.enabled = false`                                                                     | `""`                                       |
| `electionID`                           | Election ID to use for status update                                                                                                               | `ingress-controller-leader`                |
| `allowSnippetAnnotations`              | Allow users to set snippet annotations                                                                                                             | `false`                                    |
| `reportNodeInternalIp`                 | If using `hostNetwork=true`, setting `reportNodeInternalIp=true`, will pass the flag `report-node-internal-ip-address` to Nginx Ingress Controller | `false`                                    |
| `watchIngressWithoutClass`             | Process Ingress objects without ingressClass annotation/ingressClassName field                                                                     | `false`                                    |
| `ingressClassResource.name`            | Name of the IngressClass resource                                                                                                                  | `nginx`                                    |
| `ingressClassResource.enabled`         | Create the IngressClass resource                                                                                                                   | `true`                                     |
| `ingressClassResource.default`         | Set the created IngressClass resource as default class                                                                                             | `false`                                    |
| `ingressClassResource.controllerClass` | IngressClass identifier for the controller                                                                                                         | `k8s.io/ingress-nginx`                     |
| `ingressClassResource.parameters`      | Optional parameters for the controller                                                                                                             | `{}`                                       |
| `publishService.enabled`               | Set the endpoint records on the Ingress objects to reflect those on the service                                                                    | `false`                                    |
| `publishService.pathOverride`          | Allows overriding of the publish service to bind to                                                                                                | `""`                                       |
| `scope.enabled`                        | Limit the scope of the controller.                                                                                                                 | `false`                                    |
| `scope.namespace`                      | Scope namespace. Defaults to `.Release.Namespace`                                                                                                  | `""`                                       |
| `configMapNamespace`                   | Allows customization of the configmap / nginx-configmap namespace                                                                                  | `""`                                       |
| `tcpConfigMapNamespace`                | Allows customization of the tcp-services-configmap namespace                                                                                       | `""`                                       |
| `udpConfigMapNamespace`                | Allows customization of the udp-services-configmap namespace                                                                                       | `""`                                       |
| `maxmindLicenseKey`                    | License key used to download Geolite2 database                                                                                                     | `""`                                       |
| `dhParam`                              | A base64ed Diffie-Hellman parameter                                                                                                                | `""`                                       |
| `tcp`                                  | TCP service key:value pairs                                                                                                                        | `{}`                                       |
| `udp`                                  | UDP service key:value pairs                                                                                                                        | `{}`                                       |
| `command`                              | Override default container command (useful when using custom images)                                                                               | `[]`                                       |
| `args`                                 | Override default container args (useful when using custom images)                                                                                  | `[]`                                       |
| `lifecycleHooks`                       | for the %%MAIN_CONTAINER_NAME%% container(s) to automate configuration before or after startup                                                     | `{}`                                       |
| `extraArgs`                            | Additional command line arguments to pass to nginx-ingress-controller                                                                              | `{}`                                       |
| `extraEnvVars`                         | Extra environment variables to be set on Nginx Ingress container                                                                                   | `[]`                                       |
| `extraEnvVarsCM`                       | Name of a existing ConfigMap containing extra environment variables                                                                                | `""`                                       |
| `extraEnvVarsSecret`                   | Name of a existing Secret containing extra environment variables                                                                                   | `""`                                       |

### Nginx Ingress deployment / daemonset parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `kind`                                              | Install as Deployment or DaemonSet                                                                                                                                                                                | `Deployment`     |
| `daemonset.useHostPort`                             | If `kind` is `DaemonSet`, this will enable `hostPort` for `TCP/80` and `TCP/443`                                                                                                                                  | `false`          |
| `daemonset.hostPorts`                               | HTTP and HTTPS ports                                                                                                                                                                                              | `{}`             |
| `replicaCount`                                      | Desired number of Controller pods                                                                                                                                                                                 | `1`              |
| `updateStrategy`                                    | Strategy to use to update Pods                                                                                                                                                                                    | `{}`             |
| `revisionHistoryLimit`                              | The number of old history to retain to allow rollback                                                                                                                                                             | `10`             |
| `podSecurityContext.enabled`                        | Enable Controller pods' Security Context                                                                                                                                                                          | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Group ID for the container filesystem                                                                                                                                                                             | `1001`           |
| `containerSecurityContext.enabled`                  | Enable Controller containers' Security Context                                                                                                                                                                    | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Switch to allow priviledge escalation on the Controller container                                                                                                                                                 | `false`          |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `nil`            |
| `containerSecurityContext.runAsUser`                | User ID for the Controller container                                                                                                                                                                              | `1001`           |
| `containerSecurityContext.runAsGroup`               | Group ID for the Controller container                                                                                                                                                                             | `1001`           |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`           |
| `containerSecurityContext.capabilities.drop`        | Linux Kernel capabilities that should be dropped                                                                                                                                                                  | `[]`             |
| `containerSecurityContext.capabilities.add`         | Linux Kernel capabilities that should be added                                                                                                                                                                    | `[]`             |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`           |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `minReadySeconds`                                   | How many seconds a pod needs to be ready before killing the next, during update                                                                                                                                   | `0`              |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`           |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `10`             |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `3`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `10`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `3`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`             |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`             |
| `customStartupProbe`                                | Custom liveness probe for the Web component                                                                                                                                                                       | `{}`             |
| `lifecycle`                                         | LifecycleHooks to set additional configuration at startup                                                                                                                                                         | `{}`             |
| `podLabels`                                         | Extra labels for Controller pods                                                                                                                                                                                  | `{}`             |
| `podAnnotations`                                    | Annotations for Controller pods                                                                                                                                                                                   | `{}`             |
| `priorityClassName`                                 | Controller priorityClassName                                                                                                                                                                                      | `""`             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`             |
| `hostNetwork`                                       | If the Nginx deployment / daemonset should run on the host's network namespace                                                                                                                                    | `false`          |
| `dnsPolicy`                                         | By default, while using host network, name resolution uses the host's DNS                                                                                                                                         | `ClusterFirst`   |
| `dnsConfig`                                         | is an object with optional parameters to pass to the DNS resolver                                                                                                                                                 | `{}`             |
| `terminationGracePeriodSeconds`                     | How many seconds to wait before terminating a pod                                                                                                                                                                 | `60`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`             |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                             | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                          | `[]`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Controller pods                                                                                                                                           | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Controller container(s)                                                                                                                              | `[]`             |
| `initContainers`                                    | Add init containers to the controller pods                                                                                                                                                                        | `[]`             |
| `sidecars`                                          | Add sidecars to the controller pods.                                                                                                                                                                              | `[]`             |
| `customTemplate`                                    | Override NGINX template                                                                                                                                                                                           | `{}`             |
| `topologySpreadConstraints`                         | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in                                                                                                           | `[]`             |
| `podSecurityPolicy.enabled`                         | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later                                                                       | `false`          |

### Default backend parameters

| Name                                                               | Description                                                                                                                                                                                                                                     | Value                   |
| ------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `defaultBackend.enabled`                                           | Enable a default backend based on NGINX                                                                                                                                                                                                         | `true`                  |
| `defaultBackend.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                              | `true`                  |
| `defaultBackend.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                                     | `[]`                    |
| `defaultBackend.image.registry`                                    | Default backend image registry                                                                                                                                                                                                                  | `REGISTRY_NAME`         |
| `defaultBackend.image.repository`                                  | Default backend image repository                                                                                                                                                                                                                | `REPOSITORY_NAME/nginx` |
| `defaultBackend.image.digest`                                      | Default backend image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                 | `""`                    |
| `defaultBackend.image.pullPolicy`                                  | Image pull policy                                                                                                                                                                                                                               | `IfNotPresent`          |
| `defaultBackend.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                                | `[]`                    |
| `defaultBackend.extraArgs`                                         | Additional command line arguments to pass to Nginx container                                                                                                                                                                                    | `{}`                    |
| `defaultBackend.containerPort`                                     | HTTP container port number                                                                                                                                                                                                                      | `8080`                  |
| `defaultBackend.serverBlockConfig`                                 | NGINX backend default server block configuration                                                                                                                                                                                                | `""`                    |
| `defaultBackend.replicaCount`                                      | Desired number of default backend pods                                                                                                                                                                                                          | `1`                     |
| `defaultBackend.podSecurityContext.enabled`                        | Enable Default backend pods' Security Context                                                                                                                                                                                                   | `true`                  |
| `defaultBackend.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                              | `Always`                |
| `defaultBackend.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                  | `[]`                    |
| `defaultBackend.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                     | `[]`                    |
| `defaultBackend.podSecurityContext.fsGroup`                        | Group ID for the container filesystem                                                                                                                                                                                                           | `1001`                  |
| `defaultBackend.containerSecurityContext.enabled`                  | Enable Default backend containers' Security Context                                                                                                                                                                                             | `true`                  |
| `defaultBackend.containerSecurityContext.capabilities.drop`        | Linux Kernel capabilities that should be dropped                                                                                                                                                                                                | `[]`                    |
| `defaultBackend.containerSecurityContext.allowPrivilegeEscalation` | Switch to allow priviledge escalation on the container                                                                                                                                                                                          | `false`                 |
| `defaultBackend.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                | `nil`                   |
| `defaultBackend.containerSecurityContext.runAsUser`                | User ID for the Default backend container                                                                                                                                                                                                       | `1001`                  |
| `defaultBackend.containerSecurityContext.runAsGroup`               | Group ID for the Default backend container                                                                                                                                                                                                      | `1001`                  |
| `defaultBackend.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                         | `true`                  |
| `defaultBackend.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                   | `true`                  |
| `defaultBackend.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                | `RuntimeDefault`        |
| `defaultBackend.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if defaultBackend.resources is set (defaultBackend.resources is recommended for production). | `nano`                  |
| `defaultBackend.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                               | `{}`                    |
| `defaultBackend.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                            | `true`                  |
| `defaultBackend.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                         | `30`                    |
| `defaultBackend.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                                | `10`                    |
| `defaultBackend.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                               | `5`                     |
| `defaultBackend.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                             | `3`                     |
| `defaultBackend.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                             | `1`                     |
| `defaultBackend.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                           | `true`                  |
| `defaultBackend.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                        | `0`                     |
| `defaultBackend.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                               | `5`                     |
| `defaultBackend.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                              | `5`                     |
| `defaultBackend.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                            | `6`                     |
| `defaultBackend.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                            | `1`                     |
| `defaultBackend.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                             | `false`                 |
| `defaultBackend.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                          | `0`                     |
| `defaultBackend.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                                 | `5`                     |
| `defaultBackend.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                                | `5`                     |
| `defaultBackend.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                              | `6`                     |
| `defaultBackend.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                              | `1`                     |
| `defaultBackend.customStartupProbe`                                | Custom liveness probe for the Web component                                                                                                                                                                                                     | `{}`                    |
| `defaultBackend.customLivenessProbe`                               | Custom liveness probe for the Web component                                                                                                                                                                                                     | `{}`                    |
| `defaultBackend.customReadinessProbe`                              | Custom readiness probe for the Web component                                                                                                                                                                                                    | `{}`                    |
| `defaultBackend.podLabels`                                         | Extra labels for Controller pods                                                                                                                                                                                                                | `{}`                    |
| `defaultBackend.podAnnotations`                                    | Annotations for Controller pods                                                                                                                                                                                                                 | `{}`                    |
| `defaultBackend.priorityClassName`                                 | priorityClassName                                                                                                                                                                                                                               | `""`                    |
| `defaultBackend.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                                  | `""`                    |
| `defaultBackend.terminationGracePeriodSeconds`                     | In seconds, time the given to the pod to terminate gracefully                                                                                                                                                                                   | `60`                    |
| `defaultBackend.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                                  | `[]`                    |
| `defaultBackend.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                             | `""`                    |
| `defaultBackend.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                        | `soft`                  |
| `defaultBackend.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                       | `""`                    |
| `defaultBackend.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                                                          | `""`                    |
| `defaultBackend.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                                       | `[]`                    |
| `defaultBackend.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                            | `[]`                    |
| `defaultBackend.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                               | `[]`                    |
| `defaultBackend.lifecycleHooks`                                    | for the %%MAIN_CONTAINER_NAME%% container(s) to automate configuration before or after startup                                                                                                                                                  | `{}`                    |
| `defaultBackend.extraEnvVars`                                      | Array with extra environment variables to add to %%MAIN_CONTAINER_NAME%% nodes                                                                                                                                                                  | `[]`                    |
| `defaultBackend.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for %%MAIN_CONTAINER_NAME%% nodes                                                                                                                                                          | `""`                    |
| `defaultBackend.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for %%MAIN_CONTAINER_NAME%% nodes                                                                                                                                                             | `""`                    |
| `defaultBackend.extraVolumes`                                      | Optionally specify extra list of additional volumes for the %%MAIN_CONTAINER_NAME%% pod(s)                                                                                                                                                      | `[]`                    |
| `defaultBackend.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the %%MAIN_CONTAINER_NAME%% container(s)                                                                                                                                           | `[]`                    |
| `defaultBackend.sidecars`                                          | Add additional sidecar containers to the %%MAIN_CONTAINER_NAME%% pod(s)                                                                                                                                                                         | `[]`                    |
| `defaultBackend.initContainers`                                    | Add additional init containers to the %%MAIN_CONTAINER_NAME%% pod(s)                                                                                                                                                                            | `[]`                    |
| `defaultBackend.affinity`                                          | Affinity for pod assignment                                                                                                                                                                                                                     | `{}`                    |
| `defaultBackend.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                                  | `{}`                    |
| `defaultBackend.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                                  | `[]`                    |
| `defaultBackend.service.type`                                      | Kubernetes Service type for default backend                                                                                                                                                                                                     | `ClusterIP`             |
| `defaultBackend.service.ports.http`                                | Default backend service HTTP port                                                                                                                                                                                                               | `80`                    |
| `defaultBackend.service.annotations`                               | Annotations for the default backend service                                                                                                                                                                                                     | `{}`                    |
| `defaultBackend.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                             | `true`                  |
| `defaultBackend.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                                      | `true`                  |
| `defaultBackend.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                                 | `true`                  |
| `defaultBackend.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                    | `[]`                    |
| `defaultBackend.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                    | `[]`                    |
| `defaultBackend.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                          | `{}`                    |
| `defaultBackend.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                                      | `{}`                    |
| `defaultBackend.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation for Default backend                                                                                                                                                                             | `true`                  |
| `defaultBackend.pdb.minAvailable`                                  | Minimum number/percentage of Default backend pods that should remain scheduled                                                                                                                                                                  | `1`                     |
| `defaultBackend.pdb.maxUnavailable`                                | Maximum number/percentage of Default backend pods that may be made unavailable                                                                                                                                                                  | `""`                    |

### Traffic exposure parameters

| Name                                    | Description                                                                                                                            | Value          |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `service.type`                          | Kubernetes Service type for Controller                                                                                                 | `LoadBalancer` |
| `service.ports`                         | Service ports                                                                                                                          | `{}`           |
| `service.targetPorts`                   | Map the controller service HTTP/HTTPS port                                                                                             | `{}`           |
| `service.nodePorts`                     | Specify the nodePort value(s) for the LoadBalancer and NodePort service types.                                                         | `{}`           |
| `service.annotations`                   | Annotations for controller service                                                                                                     | `{}`           |
| `service.labels`                        | Labels for controller service                                                                                                          | `{}`           |
| `service.clusterIP`                     | Controller Internal Cluster Service IP (optional)                                                                                      | `""`           |
| `service.externalIPs`                   | Controller Service external IP addresses                                                                                               | `[]`           |
| `service.ipFamilyPolicy`                | Controller Service ipFamilyPolicy (optional, cloud specific)                                                                           | `""`           |
| `service.ipFamilies`                    | Controller Service ipFamilies (optional, cloud specific)                                                                               | `[]`           |
| `service.loadBalancerIP`                | Kubernetes LoadBalancerIP to request for Controller (optional, cloud specific)                                                         | `""`           |
| `service.loadBalancerSourceRanges`      | List of IP CIDRs allowed access to load balancer (if supported)                                                                        | `[]`           |
| `service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                                         | `[]`           |
| `service.externalTrafficPolicy`         | Set external traffic policy to: "Local" to preserve source IP on providers supporting it                                               | `""`           |
| `service.healthCheckNodePort`           | Set this to the managed health-check port the kube-proxy will expose. If blank, a random port in the `NodePort` range will be assigned | `0`            |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                   | `None`         |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                            | `{}`           |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                                    | `true`         |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                             | `true`         |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                        | `true`         |
| `networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                     | `[]`           |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                           | `[]`           |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                           | `[]`           |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                                 | `{}`           |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                             | `{}`           |

### RBAC parameters

| Name                                          | Description                                                    | Value   |
| --------------------------------------------- | -------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Controller pods    | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount                             | `""`    |
| `serviceAccount.annotations`                  | Annotations for service account.                               | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account | `false` |
| `rbac.create`                                 | Specifies whether RBAC rules should be created                 | `true`  |
| `rbac.rules`                                  | Custom RBAC rules                                              | `[]`    |

### Other parameters

| Name                       | Description                                                               | Value   |
| -------------------------- | ------------------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable/disable a Pod Disruption Budget creation for Controller            | `true`  |
| `pdb.minAvailable`         | Minimum number/percentage of Controller pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of Controller pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable autoscaling for Controller                                         | `false` |
| `autoscaling.minReplicas`  | Minimum number of Controller replicas                                     | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Controller replicas                                     | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                                         | `""`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                                      | `""`    |

### Metrics parameters

| Name                                       | Description                                                                       | Value       |
| ------------------------------------------ | --------------------------------------------------------------------------------- | ----------- |
| `metrics.enabled`                          | Enable exposing Controller statistics                                             | `false`     |
| `metrics.service.type`                     | Type of Prometheus metrics service to create                                      | `ClusterIP` |
| `metrics.service.ports.metrics`            | Service HTTP management port                                                      | `9913`      |
| `metrics.service.annotations`              | Annotations for the Prometheus exporter service                                   | `{}`        |
| `metrics.service.labels`                   | Labels for the Prometheus exporter service                                        | `{}`        |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor resource for scraping metrics using PrometheusOperator      | `false`     |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                          | `""`        |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus. | `""`        |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                       | `30s`       |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                               | `""`        |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                | `[]`        |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                         | `[]`        |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                    | `{}`        |
| `metrics.serviceMonitor.annotations`       | Extra annotations for the ServiceMonitor                                          | `{}`        |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                               | `{}`        |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels          | `false`     |
| `metrics.prometheusRule.enabled`           | Create PrometheusRules resource for scraping metrics using PrometheusOperator     | `false`     |
| `metrics.prometheusRule.additionalLabels`  | Used to pass Labels that are required by the Installed Prometheus Operator        | `{}`        |
| `metrics.prometheusRule.namespace`         | Namespace which Prometheus is running in                                          | `""`        |
| `metrics.prometheusRule.rules`             | Rules to be prometheus in YAML format, check values for an example                | `[]`        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    --set image.pullPolicy=Always \
    oci://REGISTRY_NAME/REPOSITORY_NAME/nginx-ingress-controller
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the `image.pullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/nginx-ingress-controller
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 11.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 10.0.0

This major version changes the default parameters so it can be run in Pod Security Admission restricted mode:

- Default ports are `8080` and `8443`
- `allowPrivilegeEscalation` is set to `false`

In order to restore the configuration from versions < 10.0.0, set the following values

- `containerPorts.http=80`
- `containerPorts.https=443`
- `containerSecurityContext.allowPrivilegeEscalation=true`

### To 9.0.0

- Configuration for routing `Ingress` resources with custom `kubernetes.io/ingress.class` annotation is changed in favor of `IngressClass` resource required in NGINX Ingress Controller 1.x
  - `ingressClass` parameter is removed and replaced with `ingressClassResource.*` parameters
  - `ingressClassResource.*` parameters configure `IngressClass` resource only
  - To configure routing for `Ingress` using custom `kubernetes.io/ingress.class` annotation define `extraArgs.ingress-class` parameter with the annotation value

Consequences:

- Backwards compatibility is not guaranteed. Uninstall & install the chart again to obtain the latest version.

### To 7.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- Several parameters were renamed or disappeared in favor of new ones on this major version. These are a few examples:
  - `*.securityContext` paramateres are deprecated in favor of `*.containerSecurityContext` ones.
  - `*.minAvailable` paramateres are deprecated in favor of `*.pdb.minAvailable` ones.
  - `extraContainers`  paramatere is deprecated in favor of `sidecars`.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. Uninstall & install the chart again to obtain the latest version.

### To 6.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links**

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### Tp 5.3.0

In this version you can indicate the key to download the GeoLite2 databases using the [parameter](#parameters) `maxmindLicenseKey`.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nginx-ingress-controller:

```console
$ kubectl patch deployment nginx-ingress-controller-default-backend --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using deployments
$ kubectl patch deployment nginx-ingress-controller --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using daemonsets
$ kubectl patch daemonset nginx-ingress-controller --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
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