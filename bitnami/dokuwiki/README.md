<!--- app-name: DokuWiki -->

# Bitnami package for DokuWiki

DokuWiki is a standards-compliant wiki optimized for creating documentation. Designed to be simple to use for small organizations, it stores all data in plain text files so no database is required.

[Overview of DokuWiki](https://www.splitbrain.org/projects/dokuwiki)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/dokuwiki
```

Looking to use DokuWiki in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [DokuWiki](https://github.com/bitnami/containers/tree/main/bitnami/dokuwiki) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/dokuwiki
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys DokuWiki on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Certificates

#### CA Certificates

Custom CA certificates not included in the base docker image can be added with
the following configuration. The secret must exist in the same namespace as the
deployment. Will load all certificates files it finds in the secret.

```yaml
certificates:
  customCAs:
  - secret: my-ca-1
  - secret: my-ca-2
```

##### CA Certificates secret

Secret can be created with:

```console
kubectl create secret generic my-ca-1 --from-file my-ca-1.crt
```

#### TLS Certificate

A web server TLS Certificate can be injected into the container with the
following configuration. The certificate will be stored at the location
specified in the certificateLocation value.

```yaml
certificates:
  customCertificate:
    certificateSecret: my-secret
    certificateLocation: /ssl/server.pem
    keyLocation: /ssl/key.pem
    chainSecret:
      name: my-cert-chain-secret
      key: chain.pem
```

##### TLS secret

The certificate tls secret can be created with:

```console
kubectl create secret tls my-secret --cert tls.crt --key tls.key
```

The certificate chain is created with:

```console
kubectl create secret generic my-ca-1 --from-file my-ca-1.crt
```

## Persistence

The [Bitnami DokuWiki](https://github.com/bitnami/containers/tree/main/bitnami/dokuwiki) image stores the DokuWiki data and configurations at the `/bitnami/dokuwiki` path of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                | Description                                                                                           | Value |
| ------------------- | ----------------------------------------------------------------------------------------------------- | ----- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                  | `""`  |
| `nameOverride`      | String to partially override dokuwiki.fullname template with a string (will prepend the release name) | `""`  |
| `fullnameOverride`  | String to fully override dokuwiki.fullname template with a string                                     | `""`  |
| `namespaceOverride` | String to fully override common.names.namespace                                                       | `""`  |
| `commonAnnotations` | Annotations to add to all deployed objects                                                            | `{}`  |
| `commonLabels`      | Labels to add to all deployed objects                                                                 | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template).                          | `[]`  |

### Dokuwiki parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                      |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`                                    | DokuWiki image registry                                                                                                                                                                                           | `REGISTRY_NAME`            |
| `image.repository`                                  | DokuWiki image repository                                                                                                                                                                                         | `REPOSITORY_NAME/dokuwiki` |
| `image.digest`                                      | DokuWiki image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                          | `""`                       |
| `image.pullPolicy`                                  | Image pull policy                                                                                                                                                                                                 | `IfNotPresent`             |
| `image.pullSecrets`                                 | Image pull policy                                                                                                                                                                                                 | `[]`                       |
| `image.debug`                                       | Enable image debugging                                                                                                                                                                                            | `false`                    |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                    |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                       |
| `dokuwikiUsername`                                  | User of the application                                                                                                                                                                                           | `user`                     |
| `dokuwikiPassword`                                  | Application password                                                                                                                                                                                              | `""`                       |
| `existingSecret`                                    | Use an existing secret with the dokuwiki password                                                                                                                                                                 | `""`                       |
| `dokuwikiEmail`                                     | Admin email                                                                                                                                                                                                       | `user@example.com`         |
| `dokuwikiFullName`                                  | User's Full Name                                                                                                                                                                                                  | `User Name`                |
| `dokuwikiWikiName`                                  | Wiki name                                                                                                                                                                                                         | `My Wiki`                  |
| `customPostInitScripts`                             | Custom post-init.d user scripts                                                                                                                                                                                   | `{}`                       |
| `updateStrategy`                                    | Strategy to use to update Pods                                                                                                                                                                                    | `{}`                       |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                       |
| `persistence.enabled`                               | Enable persistence using PVC                                                                                                                                                                                      | `true`                     |
| `persistence.storageClass`                          | PVC Storage Class for DokuWiki volume                                                                                                                                                                             | `""`                       |
| `persistence.accessModes`                           | PVC Access Mode for DokuWiki volume                                                                                                                                                                               | `[]`                       |
| `persistence.size`                                  | PVC Storage Request for DokuWiki volume                                                                                                                                                                           | `8Gi`                      |
| `persistence.existingClaim`                         | Name of an existing PVC to be used                                                                                                                                                                                | `""`                       |
| `persistence.annotations`                           | Annotations to add to the PVC                                                                                                                                                                                     | `{}`                       |
| `podSecurityContext.enabled`                        | Enable securityContext on for DokuWiki deployment                                                                                                                                                                 | `true`                     |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                   |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                       |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                       |
| `podSecurityContext.fsGroup`                        | Group to configure permissions for volumes                                                                                                                                                                        | `1001`                     |
| `containerSecurityContext.enabled`                  | Enabled Dokuwiki containers' Security Context                                                                                                                                                                     | `true`                     |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                       |
| `containerSecurityContext.runAsUser`                | Set Dokuwiki containers' Security Context runAsUser                                                                                                                                                               | `1001`                     |
| `containerSecurityContext.runAsGroup`               | Set Dokuwiki containers' Security Context runAsGroup                                                                                                                                                              | `1001`                     |
| `containerSecurityContext.runAsNonRoot`             | Set Controller container's Security Context runAsNonRoot                                                                                                                                                          | `true`                     |
| `containerSecurityContext.privileged`               | Set primary container's Security Context privileged                                                                                                                                                               | `false`                    |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set primary container's Security Context readOnlyRootFilesystem                                                                                                                                                   | `true`                     |
| `containerSecurityContext.allowPrivilegeEscalation` | Set primary container's Security Context allowPrivilegeEscalation                                                                                                                                                 | `false`                    |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                  |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`           |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`                    |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                       |
| `livenessProbe.enabled`                             | Enable/disable the liveness probe                                                                                                                                                                                 | `true`                     |
| `livenessProbe.initialDelaySeconds`                 | Delay before liveness probe is initiated                                                                                                                                                                          | `120`                      |
| `livenessProbe.periodSeconds`                       | How often to perform the probe                                                                                                                                                                                    | `10`                       |
| `livenessProbe.timeoutSeconds`                      | When the probe times out                                                                                                                                                                                          | `5`                        |
| `livenessProbe.failureThreshold`                    | Minimum consecutive failures to be considered failed                                                                                                                                                              | `6`                        |
| `livenessProbe.successThreshold`                    | Minimum consecutive successes to be considered successful                                                                                                                                                         | `1`                        |
| `readinessProbe.enabled`                            | Enable/disable the readiness probe                                                                                                                                                                                | `true`                     |
| `readinessProbe.initialDelaySeconds`                | Delay before readinessProbe is initiated                                                                                                                                                                          | `30`                       |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                       |
| `readinessProbe.timeoutSeconds`                     | When the probe times out                                                                                                                                                                                          | `5`                        |
| `readinessProbe.failureThreshold`                   | Minimum consecutive failures to be considered failed                                                                                                                                                              | `6`                        |
| `readinessProbe.successThreshold`                   | Minimum consecutive successes to be considered successful                                                                                                                                                         | `1`                        |
| `startupProbe.enabled`                              | Enable/disable the startup probe                                                                                                                                                                                  | `false`                    |
| `startupProbe.initialDelaySeconds`                  | Delay before startup probe is initiated                                                                                                                                                                           | `120`                      |
| `startupProbe.periodSeconds`                        | How often to perform the probe                                                                                                                                                                                    | `10`                       |
| `startupProbe.timeoutSeconds`                       | When the probe times out                                                                                                                                                                                          | `5`                        |
| `startupProbe.failureThreshold`                     | Minimum consecutive failures to be considered failed                                                                                                                                                              | `6`                        |
| `startupProbe.successThreshold`                     | Minimum consecutive successes to be considered successful                                                                                                                                                         | `1`                        |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                       |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                     |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                       |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                       |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                       |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                       |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                       |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                       |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                       |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                       |
| `extraEnvVars`                                      | An array to add extra env vars                                                                                                                                                                                    | `[]`                       |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars                                                                                                                                                                               | `""`                       |
| `extraEnvVarsSecret`                                | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                      | `""`                       |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                       |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                       |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                       |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                       |
| `extraVolumes`                                      | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                | `[]`                       |
| `extraVolumeMounts`                                 | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.                                                                                             | `[]`                       |
| `lifecycleHooks`                                    | LifecycleHook to set additional configuration at startup. Evaluated as a template                                                                                                                                 | `{}`                       |
| `podLabels`                                         | Add additional labels to the pod (evaluated as a template)                                                                                                                                                        | `{}`                       |
| `initContainers`                                    | Attach additional init containers to the pod (evaluated as a template)                                                                                                                                            | `[]`                       |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`                     |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `""`                       |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                                    | `""`                       |
| `sidecars`                                          | Attach additional containers to the pod (evaluated as a template)                                                                                                                                                 | `[]`                       |
| `priorityClassName`                                 | Priority class assigned to the Pods                                                                                                                                                                               | `""`                       |
| `schedulerName`                                     | Alternative scheduler                                                                                                                                                                                             | `""`                       |
| `terminationGracePeriodSeconds`                     | In seconds, time the given to the pod to terminate gracefully                                                                                                                                                     | `""`                       |
| `containerPorts.http`                               | Container HTTP port                                                                                                                                                                                               | `8080`                     |
| `containerPorts.https`                              | Container HTTPS port                                                                                                                                                                                              | `8443`                     |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Dokuwiki container(s)                                                                                                                                       | `[]`                       |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for Dokuwiki pod                                                                                                                                                                | `true`                     |
| `serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                            | `""`                       |
| `serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                            | `false`                    |
| `serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                              | `{}`                       |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | Kubernetes Service type                                                                                                          | `LoadBalancer`           |
| `service.loadBalancerIP`                | Use serviceLoadBalancerIP to request a specific static IP, otherwise leave blank                                                 | `""`                     |
| `service.ports.http`                    | Service HTTP port                                                                                                                | `80`                     |
| `service.ports.https`                   | Service HTTPS port                                                                                                               | `443`                    |
| `service.nodePorts`                     | Use nodePorts to request some specific ports when using NodePort                                                                 | `{}`                     |
| `service.clusterIP`                     | Kubernetes service Cluster IP                                                                                                    | `""`                     |
| `service.loadBalancerSourceRanges`      | Kubernetes service Load Balancer sources                                                                                         | `[]`                     |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.extraPorts`                    | Extra ports to expose in the service (normally used with the `sidecar` value)                                                    | `[]`                     |
| `service.annotations`                   | Annotations to add to the service                                                                                                | `{}`                     |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |
| `ingress.enabled`                       | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`                      | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`                      | When the ingress is enabled, a host pointing to this will be created                                                             | `dokuwiki.local`         |
| `ingress.path`                          | The Path to Dokuwiki. You may need to set this to '/*' in order to use this                                                      | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.extraHosts`                    | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`                    | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                      | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                       | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Volume Permissions parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                      |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                 | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                             | `false`                    |
| `volumePermissions.image.registry`                          | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                        | Init container volume-permissions image name                                                                                                                                                                                                          | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                            | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`                        | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                       | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `nil`                      |
| `volumePermissions.containerSecurityContext.runAsUser`      | User ID for the init container                                                                                                                                                                                                                        | `0`                        |

### Metrics parameters

| Name                        | Description                                                                                                                                                                                                                       | Value                             |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`           | Start a exporter side-car                                                                                                                                                                                                         | `false`                           |
| `metrics.image.registry`    | Apache exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`  | Apache exporter image name                                                                                                                                                                                                        | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`      | Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`  | Image pull policy                                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets` | Specify docker-registry secret names as an array                                                                                                                                                                                  | `[]`                              |
| `metrics.podAnnotations`    | Additional annotations for Metrics exporter pod                                                                                                                                                                                   | `{}`                              |
| `metrics.resourcesPreset`   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                            |
| `metrics.resources`         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |

### Certificate injection parameters

| Name                                                 | Description                                                                                                       | Value                                    |
| ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                                                                  | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                                                               | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                                                               | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                                                                | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                                                                | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain                                                          | `/etc/ssl/certs/mychain.pem`             |
| `certificates.customCAs`                             | Defines a list of secrets to import into the container trust store                                                | `[]`                                     |
| `certificates.command`                               | Override default container command (useful when using custom images)                                              | `[]`                                     |
| `certificates.args`                                  | Override default container args (useful when using custom images)                                                 | `[]`                                     |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (eg proxy)                                                          | `[]`                                     |
| `certificates.extraEnvVarsCM`                        | ConfigMap containing extra env vars                                                                               | `""`                                     |
| `certificates.extraEnvVarsSecret`                    | Secret containing extra env vars (in case of sensitive data)                                                      | `""`                                     |
| `certificates.image.registry`                        | Container sidecar registry                                                                                        | `REGISTRY_NAME`                          |
| `certificates.image.repository`                      | Container sidecar image                                                                                           | `REPOSITORY_NAME/os-shell`               |
| `certificates.image.digest`                          | Container sidecar image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                     |
| `certificates.image.pullPolicy`                      | Container sidecar image pull policy                                                                               | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Container sidecar image pull secrets                                                                              | `[]`                                     |

The above parameters map to the env variables defined in [bitnami/dokuwiki](https://github.com/bitnami/containers/tree/main/bitnami/dokuwiki). For more information please refer to the [bitnami/dokuwiki](https://github.com/bitnami/containers/tree/main/bitnami/dokuwiki) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set dokuwikiUsername=admin,dokuwikiPassword=password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/dokuwiki
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the DokuWiki administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/dokuwiki
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/dokuwiki/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 16.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 12.0.0

Some of the chart values were changed to adapt to the latest Bitnami standards. More specifically:

- `containerPort` was changed to `containerPorts.http`
- `service.port` was changed to `service.ports.http`

No issues should be expected when upgrading.

### To 11.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 10.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 7.0.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

The [Bitnami Dokuwiki](https://github.com/bitnami/containers/tree/main/bitnami/dokuwiki) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed.

To upgrade to `7.0.0`, backup Drupal data and the previous MariaDB databases, install a new Drupal chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

### To 6.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In <https://github.com/helm/charts/pull/17294> the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is dokuwiki:

```console
kubectl patch deployment dokuwiki-dokuwiki --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
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