<!--- app-name: cAdvisor -->

# Bitnami package for cAdvisor

cAdvisor (Container Advisor) is an open-source tool by Google for monitoring containers, collecting metrics like CPU, memory, and network usage.

[Overview of cAdvisor](https://github.com/google/cadvisor)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/cadvisor
```

Looking to use cAdvisor in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [cAdvisor](https://github.com/bitnami/containers/tree/main/bitnami/cadvisor) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/cadvisor
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys cAdvisor on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

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

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose cAdvisor native Prometheus endpoint in the service. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Extra cAdvisor parameters

It is possible to add extra configuration parameters to the `cadvisor` command using the `extraArgs` value. In the following example we use add the extra `log_cadvisor_usage=true` argument:

```yaml
extraArgs:
  - -log_cadvisor_usage=true
```

Check the [official cAdvisor documentation](https://github.com/google/cadvisor/blob/master/docs/runtime_options.md#L1) for the list of available arguments.

### Hostpath mounts

The Bitnami cAdvisor chart mounts a set of host folders by default, which can be enabled/disabled with the following values inside the the `defaultMounts` section:

- `defaultMounts.rootfs`: Mount the host `/` folder
- `defaultMounts.varRun`: Mount the host `/var/run` folder
- `defaultMounts.sys`: Mount the host `/sys` folder
- `defaultMounts.varLibDocker`: Mount the host `/var/lib/docker` folder
- `defaultMounts.devDisk`: Mount the host `/dev/disk` folder

You can mount extra folders using the `extraVolumes` and `extraVolumeMounts` values.

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Configure TLS Secrets for use with Ingress

This chart facilitates the creation of TLS secrets for use with the Ingress controller (although this is not mandatory). There are several common use cases:

- Generate certificate secrets based on chart parameters.
- Enable externally generated certificates.
- Manage application certificates via an external service (like [cert-manager](https://github.com/jetstack/cert-manager/)).
- Create self-signed certificates within the chart (if supported).

In the first two cases, a certificate and a key are needed. Files are expected in `.pem` format.

Here is an example of a certificate file:

> NOTE: There may be more than one certificate if there is a certificate chain.

```text
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```

Here is an example of a certificate key:

```text
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

- If using Helm to manage the certificates based on the parameters, copy these values into the `certificate` and `key` values for a given `*.ingress.secrets` entry.
- If managing TLS secrets separately, it is necessary to create a TLS secret with name `INGRESS_HOSTNAME-tls` (where INGRESS_HOSTNAME is a placeholder to be replaced with the hostname you set using the `*.ingress.hostname` parameter).
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, add to `*.ingress.annotations` the [corresponding ones](https://cert-manager.io/docs/usage/ingress/#supported-annotations) for cert-manager.
- If using self-signed certificates created by Helm, set both `*.ingress.tls` and `*.ingress.selfSigned` to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.storageClass`                                 | DEPRECATED: use global.defaultStorageClass instead                                                                                                                                                                                                                                                                                                                  | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                     | Description                                                                                                  | Value          |
| ------------------------ | ------------------------------------------------------------------------------------------------------------ | -------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                         | `""`           |
| `nameOverride`           | String to partially override cadvisor.fullname template (will maintain the release name)                     | `""`           |
| `fullnameOverride`       | String to fully override cadvisor.fullname template                                                          | `""`           |
| `namespaceOverride`      | String to fully override common.names.namespace                                                              | `""`           |
| `commonAnnotations`      | Common annotations to add to all cAdvisor resources (sub-charts are not considered). Evaluated as a template | `{}`           |
| `commonLabels`           | Common labels to add to all cAdvisor resources (sub-charts are not considered). Evaluated as a template      | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release (evaluated as a template).                                 | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                      | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                         | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                            | `["infinity"]` |

### cAdvisor parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                      |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`                                    | cAdvisor image registry                                                                                                                                                                                           | `REGISTRY_NAME`            |
| `image.repository`                                  | cAdvisor Image name                                                                                                                                                                                               | `REPOSITORY_NAME/cadvisor` |
| `image.digest`                                      | cAdvisor image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                          | `""`                       |
| `image.pullPolicy`                                  | cAdvisor image pull policy                                                                                                                                                                                        | `IfNotPresent`             |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                       |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                       |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                       |
| `extraArgs`                                         | Add extra arguments to the default command                                                                                                                                                                        | `[]`                       |
| `updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                    | `RollingUpdate`            |
| `priorityClassName`                                 | cAdvisor pods' priorityClassName                                                                                                                                                                                  | `""`                       |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                       |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                       |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                    |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                       |
| `extraEnvVars`                                      | Extra environment variables                                                                                                                                                                                       | `[]`                       |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars                                                                                                                                                                               | `""`                       |
| `extraEnvVarsSecret`                                | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                      | `""`                       |
| `defaultMounts.rootfs`                              | Mount host /                                                                                                                                                                                                      | `true`                     |
| `defaultMounts.varRun`                              | Mount host /var/run                                                                                                                                                                                               | `true`                     |
| `defaultMounts.sys`                                 | Mount host /sys                                                                                                                                                                                                   | `true`                     |
| `defaultMounts.varLibDocker`                        | Mount host /var/lib/docker                                                                                                                                                                                        | `true`                     |
| `defaultMounts.devDisk`                             | Mount host /dev/disk                                                                                                                                                                                              | `true`                     |
| `extraVolumes`                                      | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                | `[]`                       |
| `extraVolumeMounts`                                 | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.                                                                                             | `[]`                       |
| `initContainers`                                    | Add additional init containers to the pod (evaluated as a template)                                                                                                                                               | `[]`                       |
| `sidecars`                                          | Attach additional containers to the pod (evaluated as a template)                                                                                                                                                 | `[]`                       |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                       |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                       |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                     |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                       |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                       |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                       |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                       |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`                       |
| `containerPorts.http`                               | cAdvisor HTTP container port                                                                                                                                                                                      | `8080`                     |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for cAdvisor container(s)                                                                                                                                       | `[]`                       |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `small`                    |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                       |
| `podSecurityContext.enabled`                        | Enable cAdvisor pods' Security Context                                                                                                                                                                            | `true`                     |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                   |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                       |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                       |
| `podSecurityContext.fsGroup`                        | cAdvisor pods' group ID                                                                                                                                                                                           | `0`                        |
| `containerSecurityContext.enabled`                  | Enable cAdvisor containers' Security Context                                                                                                                                                                      | `true`                     |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                       |
| `containerSecurityContext.runAsUser`                | cAdvisor containers' Security Context                                                                                                                                                                             | `0`                        |
| `containerSecurityContext.runAsGroup`               | cAdvisor containers' Security Context                                                                                                                                                                             | `0`                        |
| `containerSecurityContext.runAsNonRoot`             | Set cAdvisor container's Security Context runAsNonRoot                                                                                                                                                            | `false`                    |
| `containerSecurityContext.privileged`               | Set cAdvisor container's Security Context privileged                                                                                                                                                              | `false`                    |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `true`                     |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                     |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                  |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`           |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                    |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`                       |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                       |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                        |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `5`                        |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                        |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                     |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `10`                       |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                       |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                        |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `5`                        |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                        |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                     |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `10`                       |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `5`                        |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                        |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `5`                        |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                        |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                       |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                       |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                       |
| `lifecycleHooks`                                    | LifecycleHook to set additional configuration at startup Evaluated as a template                                                                                                                                  | `{}`                       |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                       |
| `podLabels`                                         | Add additional labels to the pod (evaluated as a template)                                                                                                                                                        | `{}`                       |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.enabled`                       | Whether to create Service resource or not                                                                                        | `true`                   |
| `service.type`                          | Kubernetes Service type                                                                                                          | `ClusterIP`              |
| `service.ports.http`                    | cAdvisor client port                                                                                                             | `8080`                   |
| `service.nodePorts.http`                | Port to bind to for NodePort service type (client port)                                                                          | `""`                     |
| `service.clusterIP`                     | IP address to assign to service                                                                                                  | `""`                     |
| `service.externalIPs`                   | Service external IP addresses                                                                                                    | `[]`                     |
| `service.externalName`                  | Service external name                                                                                                            | `""`                     |
| `service.loadBalancerIP`                | IP address to assign to load balancer (if supported)                                                                             | `""`                     |
| `service.loadBalancerSourceRanges`      | List of IP CIDRs allowed access to load balancer (if supported)                                                                  | `[]`                     |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.extraPorts`                    | Extra ports to expose in the service (normally used with the `sidecar` value)                                                    | `[]`                     |
| `service.annotations`                   | Annotations to add to service                                                                                                    | `{}`                     |
| `service.labels`                        | Provide any additional labels which may be required.                                                                             | `{}`                     |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.                        | `true`                   |
| `networkPolicy.ingressPodMatchLabels`   | Labels to match to allow traffic from other pods. Ignored if `networkPolicy.allowExternal` is true.                              | `{}`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.                        | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.                    | `{}`                     |
| `ingress.enabled`                       | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress resource                                                                                            | `cadvisor.local`         |
| `ingress.path`                          | The Path to Nginx. You may need to set this to '/*' in order to use this with ALB ingress controllers.                           | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.ingressClassName`              | Set the ingerssClassName on the ingress record for k8s 1.18+                                                                     | `""`                     |
| `ingress.tls`                           | Create TLS Secret                                                                                                                | `false`                  |
| `ingress.tlsWwwPrefix`                  | Adds www subdomain to default cert                                                                                               | `false`                  |
| `ingress.extraHosts`                    | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`                    | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                      | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                       | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`                    | The list of additional rules to be added to this ingress record. Evaluated as a template                                         | `[]`                     |

### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for cAdvisor pod                     | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |

### Metrics parameters

| Name                                       | Description                                                                           | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                          | Enable metrics                                                                        | `false` |
| `metrics.annotations`                      | Annotations for the server service in order to scrape metrics                         | `{}`    |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator         | `false` |
| `metrics.serviceMonitor.annotations`       | Annotations for the ServiceMonitor Resource                                           | `""`    |
| `metrics.serviceMonitor.namespace`         | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)         | `""`    |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                          | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                               | `""`    |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`    |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`    |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`    |
| `metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                              | `false` |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set schedulerName=high-priority \
    oci://REGISTRY_NAME/REPOSITORY_NAME/cadvisor
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the cAdvisor scheduler to high-priority.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/cadvisor
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/cadvisor/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.2.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 1.0.0

This major bump changes the following security defaults:

- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

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