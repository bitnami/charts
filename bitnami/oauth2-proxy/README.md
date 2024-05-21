<!--- app-name: OAuth2 Proxy -->

# Bitnami package for OAuth2 Proxy

A reverse proxy and static file server that provides authentication using Providers (Google, GitHub, and others) to validate accounts by email, domain or group.

[Overview of OAuth2 Proxy](https://github.com/oauth2-proxy/oauth2-proxy)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/oauth2-proxy
```

Looking to use OAuth2 Proxy in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [OAuth2 Proxy](https://github.com/oauth2-proxy/oauth2-proxy) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/oauth2-proxy
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys OAuth2 Proxy on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host.

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as OAuth2 Proxy (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

## Persistence

The [Bitnami OAuth2 Proxy](https://github.com/bitnami/containers/tree/main/bitnami/oauth2-proxy) image stores the OAuth2 Proxy data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments.

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
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | OAuth2 Proxy service type                                                                                                        | `ClusterIP`              |
| `service.port`                          | OAuth2 Proxy service HTTP port                                                                                                   | `80`                     |
| `service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`                     |
| `service.clusterIP`                     | OAuth2 Proxy service Cluster IP                                                                                                  | `""`                     |
| `service.loadBalancerIP`                | OAuth2 Proxy service Load Balancer IP                                                                                            | `""`                     |
| `service.loadBalancerSourceRanges`      | OAuth2 Proxy service Load Balancer sources                                                                                       | `[]`                     |
| `service.externalTrafficPolicy`         | OAuth2 Proxy service external traffic policy                                                                                     | `Cluster`                |
| `service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`                   | Additional custom annotations for OAuth2 Proxy service                                                                           | `{}`                     |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `ingress.enabled`                       | Enable ingress record generation for OAuth2 Proxy                                                                                | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress record                                                                                              | `oaut2-proxy.local`      |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.certManager`                   | Add the corresponding annotations for cert-manager integration                                                                   | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.existingSecretName`            | If you're providing your own certificate and want to manage the secret yourself                                                  | `""`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### OAuth2 Proxy Image parameters

| Name                | Description                                                                                                  | Value                          |
| ------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------ |
| `image.registry`    | OAuth2 Proxy image registry                                                                                  | `REGISTRY_NAME`                |
| `image.repository`  | OAuth2 Proxy image repository                                                                                | `REPOSITORY_NAME/oauth2-proxy` |
| `image.digest`      | OAuth2 Proxy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                           |
| `image.pullPolicy`  | OAuth2 Proxy image pull policy                                                                               | `IfNotPresent`                 |
| `image.pullSecrets` | OAuth2 Proxy image pull secrets                                                                              | `[]`                           |

### OAuth2 Proxy configuration parameters

| Name                                                   | Description                                                                                              | Value              |
| ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- | ------------------ |
| `configuration.clientID`                               | OAuth client ID                                                                                          | `XXXXXXX`          |
| `configuration.clientSecret`                           | OAuth client secret                                                                                      | `XXXXXXXX`         |
| `configuration.cookieSecret`                           | OAuth cookie secret                                                                                      | `XXXXXXXXXXXXXXXX` |
| `configuration.existingSecret`                         | Secret with the client ID, secret and cookie secret                                                      | `""`               |
| `configuration.google.enabled`                         | Enable Google service account                                                                            | `false`            |
| `configuration.google.adminEmail`                      | Google admin email                                                                                       | `""`               |
| `configuration.google.groups`                          | Restrict logins to members of these google groups                                                        | `[]`               |
| `configuration.google.serviceAccountJson`              | Google Service account JSON                                                                              | `""`               |
| `configuration.google.existingSecret`                  | Existing secret containing Google Service Account                                                        | `""`               |
| `configuration.content`                                | Default configuration                                                                                    | `""`               |
| `configuration.existingConfigmap`                      | Configmap with the OAuth2 Proxy configuration                                                            | `""`               |
| `configuration.authenticatedEmailsFile.enabled`        | Enable authenticated emails file                                                                         | `false`            |
| `configuration.authenticatedEmailsFile.content`        | Restricted access list (one email per line)                                                              | `""`               |
| `configuration.authenticatedEmailsFile.existingSecret` | Secret with the authenticated emails file                                                                | `""`               |
| `configuration.htpasswdFile.enabled`                   | Enable htpasswd file                                                                                     | `false`            |
| `configuration.htpasswdFile.existingSecret`            | Existing secret for htpasswd file                                                                        | `""`               |
| `configuration.htpasswdFile.content`                   | htpasswd file entries (one row per user)                                                                 | `""`               |
| `configuration.oidcIssuerUrl`                          | OpenID Connect issuer URL                                                                                | `""`               |
| `configuration.redirectUrl`                            | OAuth Redirect URL                                                                                       | `""`               |
| `configuration.whiteList`                              | Allowed domains for redirection after authentication. Prefix domain with a . or a *. to allow subdomains | `""`               |

### OAuth2 Proxy deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `containerPort`                                     | OAuth2 Proxy port number                                                                                                                                                                                          | `4180`           |
| `extraContainerPorts`                               | Array of additional container ports for the OAuth2 Proxy container                                                                                                                                                | `[]`             |
| `replicaCount`                                      | Number of OAuth2 Proxy replicas to deploy                                                                                                                                                                         | `1`              |
| `extraArgs`                                         | add extra args to the default command                                                                                                                                                                             | `[]`             |
| `startupProbe.enabled`                              | Enable startupProbe on OAuth2 Proxy nodes                                                                                                                                                                         | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `0`              |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `5`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `livenessProbe.enabled`                             | Enable livenessProbe on OAuth2 Proxy nodes                                                                                                                                                                        | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `0`              |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `5`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe on OAuth2 Proxy nodes                                                                                                                                                                       | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `0`              |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `5`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`             |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`             |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`           |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `pdb.create`                                        | Enable a Pod Disruption Budget creation                                                                                                                                                                           | `true`           |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `1`              |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                    | `""`             |
| `podSecurityContext.enabled`                        | Enabled OAuth2 Proxy pods' Security Context                                                                                                                                                                       | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set OAuth2 Proxy pod's Security Context fsGroup                                                                                                                                                                   | `1001`           |
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
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`             |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`             |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`          |
| `hostAliases`                                       | OAuth2 Proxy pods host aliases                                                                                                                                                                                    | `[]`             |
| `podLabels`                                         | Extra labels for OAuth2 Proxy pods                                                                                                                                                                                | `{}`             |
| `podAnnotations`                                    | Annotations for OAuth2 Proxy pods                                                                                                                                                                                 | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`             |
| `affinity`                                          | Affinity for OAuth2 Proxy pods assignment                                                                                                                                                                         | `{}`             |
| `nodeSelector`                                      | Node labels for OAuth2 Proxy pods assignment                                                                                                                                                                      | `{}`             |
| `tolerations`                                       | Tolerations for OAuth2 Proxy pods assignment                                                                                                                                                                      | `[]`             |
| `updateStrategy.type`                               | OAuth2 Proxy statefulset strategy type                                                                                                                                                                            | `RollingUpdate`  |
| `priorityClassName`                                 | OAuth2 Proxy pods' priorityClassName                                                                                                                                                                              | `""`             |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`             |
| `lifecycleHooks`                                    | for the OAuth2 Proxy container(s) to automate configuration before or after startup                                                                                                                               | `{}`             |
| `extraEnvVars`                                      | Array with extra environment variables to add to OAuth2 Proxy nodes                                                                                                                                               | `[]`             |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for OAuth2 Proxy nodes                                                                                                                                       | `""`             |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for OAuth2 Proxy nodes                                                                                                                                          | `""`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the OAuth2 Proxy pod(s)                                                                                                                                   | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the OAuth2 Proxy container(s)                                                                                                                        | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the OAuth2 Proxy pod(s)                                                                                                                                                      | `[]`             |
| `initContainers`                                    | Add additional init containers to the OAuth2 Proxy pod(s)                                                                                                                                                         | `[]`             |
| `dnsPolicy`                                         | Pod DNS policy. Valid values are 'ClusterFirstWithHostNet', 'ClusterFirst', 'Default' or 'None'.                                                                                                                  | `""`             |
| `dnsConfig`                                         | Pod DNS configuration.                                                                                                                                                                                            | `{}`             |
| `serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                              | `true`           |
| `serviceAccount.name`                               | The name of the ServiceAccount to use                                                                                                                                                                             | `""`             |
| `serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                    | `false`          |
| `serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                                                                                                        | `{}`             |

### External Redis&reg; parameters

| Name                                      | Description                                                | Value  |
| ----------------------------------------- | ---------------------------------------------------------- | ------ |
| `externalRedis.host`                      | External Redis&reg; server host                            | `""`   |
| `externalRedis.password`                  | External Redis&reg; user password                          | `""`   |
| `externalRedis.port`                      | External Redis&reg; server port                            | `6379` |
| `externalRedis.existingSecret`            | The name of an existing secret with Redis&reg; credentials | `""`   |
| `externalRedis.existingSecretPasswordKey` | Key inside the existing secret with Redis&reg; credentials | `""`   |

### Redis&reg; sub-chart parameters

| Name                                   | Description                                                | Value        |
| -------------------------------------- | ---------------------------------------------------------- | ------------ |
| `redis.enabled`                        | Deploy Redis&reg; sub-chart                                | `true`       |
| `redis.architecture`                   | Redis&reg; architecture                                    | `standalone` |
| `redis.master.service.port`            | Redis&reg; (without Sentinel) service port                 | `6379`       |
| `redis.replica.replicaCount`           | Number of Redis&reg; replicas                              | `3`          |
| `redis.auth.enabled`                   | Enable Redis&reg; authentication                           | `true`       |
| `redis.auth.existingSecret`            | Secret with Redis&reg; credentials                         | `""`         |
| `redis.auth.existingSecretPasswordKey` | Key inside the existing secret with Redis&reg; credentials | `""`         |
| `redis.auth.sentinel`                  | Enable authentication in the Sentinel nodes                | `true`       |
| `redis.sentinel.enabled`               | Enable Redis&reg; sentinel in the deployment               | `false`      |
| `redis.sentinel.masterSet`             | Name of the Redis&reg; Sentinel master set                 | `mymaster`   |
| `redis.sentinel.service.port`          | Redis&reg; (with Sentinel) service port                    | `6379`       |
| `redis.sentinel.service.sentinelPort`  | Redis&reg; (with Sentinel) sentinel service port           | `26379`      |

See <https://github.com/bitnami/readme-generator-for-helm> to create the table

The above parameters map to the env variables defined in [bitnami/oauth2-proxy](https://github.com/bitnami/containers/tree/main/bitnami/oauth2-proxy). For more information please refer to the [bitnami/oauth2-proxy](https://github.com/bitnami/containers/tree/main/bitnami/oauth2-proxy) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set replicaCount=2 \
    oci://REGISTRY_NAME/REPOSITORY_NAME/oauth2-proxy
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command increase the default number of replicas.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/oauth2-proxy
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/oauth2-proxy/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 5.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 4.0.0

This major updates the Redis&reg; subchart to its newest major, 18.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1800) you can find more information about the changes introduced in that version.

NOTE: Due to an error in our release process, Redis&reg;' chart versions higher or equal than 17.15.4 already use Redis&reg; 7.2 by default.

### To 3.0.0

This major update the Redis&reg; subchart to its newest major, 17.0.0, which updates Redis&reg; from its version 6.2 to version 7.0.

### To 2.0.0

This major update the Redis&reg; subchart to its newest major, 16.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1600) you can find more info about the specific changes.

Additionally, this chart has been standardised adding features from other charts.

### To 1.0.0

This major update the Redis&reg; subchart to its newest major, 15.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1500) you can find more info about the specific changes.

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