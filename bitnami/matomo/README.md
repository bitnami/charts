<!--- app-name: Matomo -->

# Bitnami package for Matomo

Matomo, formerly known as Piwik, is a real time web analytics program. It provides detailed reports on website visitors.

[Overview of Matomo](https://matomo.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/matomo
```

Looking to use Matomo in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Matomo](https://github.com/bitnami/containers/tree/main/bitnami/matomo) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment as a database for the Matomo application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/matomo
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Matomo on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

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

## Persistence

The [Bitnami Matomo](https://github.com/bitnami/containers/tree/main/bitnami/matomo) image stores the Matomo data and configurations at the `/bitnami/matomo` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```console
helm install my-release --set persistence.existingClaim=PVC_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/matomo
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### Host path

#### System compatibility

- The local filesystem accessibility to a container in a pod with `hostPath` has been tested on OSX/MacOS with xhyve, and Linux with VirtualBox.
- Windows has not been tested with the supported VM drivers. Minikube does however officially support [Mounting Host Folders](https://minikube.sigs.k8s.io/docs/handbook/mount/) per pod. Or you may manually sync your container whenever host files are changed with tools like [docker-sync](https://github.com/EugenMayer/docker-sync) or [docker-bg-sync](https://github.com/cweagans/docker-bg-sync).

#### Mounting steps

1. The specified `hostPath` directory must already exist (create one if it does not).
2. Install the chart

    ```console
    helm install my-release --set persistence.hostPath=/PATH/TO/HOST/MOUNT oci://REGISTRY_NAME/REPOSITORY_NAME/matomo
    ```

    > Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

    This will mount the `matomo-data` volume into the `hostPath` directory. The site data will be persisted if the mount path contains valid data, else the site data will be initialized at first launch.
3. Because the container cannot control the host machine's directory permissions, you must set the Matomo file directory permissions yourself

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                | Description                                                                                                | Value |
| ------------------- | ---------------------------------------------------------------------------------------------------------- | ----- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                       | `""`  |
| `nameOverride`      | String to partially override matomo.fullname template (will maintain the release name)                     | `""`  |
| `fullnameOverride`  | String to fully override matomo.fullname template                                                          | `""`  |
| `namespaceOverride` | String to fully override common.names.namespace                                                            | `""`  |
| `commonAnnotations` | Common annotations to add to all Matomo resources (sub-charts are not considered). Evaluated as a template | `{}`  |
| `commonLabels`      | Common labels to add to all Matomo resources (sub-charts are not considered). Evaluated as a template      | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template).                               | `[]`  |

### Matomo parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                    |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `image.registry`                                    | Matomo image registry                                                                                                                                                                                             | `REGISTRY_NAME`          |
| `image.repository`                                  | Matomo Image name                                                                                                                                                                                                 | `REPOSITORY_NAME/matomo` |
| `image.digest`                                      | Matomo image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                            | `""`                     |
| `image.pullPolicy`                                  | Matomo image pull policy                                                                                                                                                                                          | `IfNotPresent`           |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                     |
| `image.debug`                                       | Specify if debug logs should be enabled                                                                                                                                                                           | `false`                  |
| `replicaCount`                                      | Number of Matomo Pods to run (requires ReadWriteMany PVC support)                                                                                                                                                 | `1`                      |
| `matomoUsername`                                    | User of the application                                                                                                                                                                                           | `user`                   |
| `matomoPassword`                                    | Application password                                                                                                                                                                                              | `""`                     |
| `matomoEmail`                                       | Admin email                                                                                                                                                                                                       | `user@example.com`       |
| `matomoWebsiteName`                                 | Matomo application name                                                                                                                                                                                           | `example`                |
| `matomoWebsiteHost`                                 | Matomo application host                                                                                                                                                                                           | `https://example.org`    |
| `matomoSkipInstall`                                 | Skip Matomo installation wizard. Useful for migrations and restoring from SQL dump                                                                                                                                | `false`                  |
| `customPostInitScripts`                             | Custom post-init.d user scripts                                                                                                                                                                                   | `{}`                     |
| `allowEmptyPassword`                                | Allow DB blank passwords                                                                                                                                                                                          | `true`                   |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                     |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                     |
| `updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                    | `RollingUpdate`          |
| `priorityClassName`                                 | Matomo pods' priorityClassName                                                                                                                                                                                    | `""`                     |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                     |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                     |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`                   |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                     |
| `extraEnvVars`                                      | Extra environment variables                                                                                                                                                                                       | `[]`                     |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars                                                                                                                                                                               | `""`                     |
| `extraEnvVarsSecret`                                | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                      | `""`                     |
| `extraVolumes`                                      | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                | `[]`                     |
| `extraVolumeMounts`                                 | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.                                                                                             | `[]`                     |
| `initContainers`                                    | Add additional init containers to the pod (evaluated as a template)                                                                                                                                               | `[]`                     |
| `sidecars`                                          | Attach additional containers to the pod (evaluated as a template)                                                                                                                                                 | `[]`                     |
| `serviceAccountName`                                | Attach serviceAccountName to the pod and sidecars                                                                                                                                                                 | `""`                     |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                     |
| `existingSecret`                                    | Name of a secret with the application password                                                                                                                                                                    | `""`                     |
| `smtpAuth`                                          | SMTP authentication mechanism (options: Plain, Login, Crammd5)                                                                                                                                                    | `""`                     |
| `smtpHost`                                          | SMTP host                                                                                                                                                                                                         | `""`                     |
| `smtpPort`                                          | SMTP port                                                                                                                                                                                                         | `""`                     |
| `smtpUser`                                          | SMTP user                                                                                                                                                                                                         | `""`                     |
| `smtpPassword`                                      | SMTP password                                                                                                                                                                                                     | `""`                     |
| `smtpProtocol`                                      | SMTP Protocol (options: ssl,tls, nil)                                                                                                                                                                             | `""`                     |
| `noreplyName`                                       | Noreply name                                                                                                                                                                                                      | `""`                     |
| `noreplyAddress`                                    | Noreply address                                                                                                                                                                                                   | `""`                     |
| `smtpExistingSecret`                                | The name of an existing secret with SMTP credentials                                                                                                                                                              | `""`                     |
| `containerPorts`                                    | Container ports                                                                                                                                                                                                   | `{}`                     |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Matomo container(s)                                                                                                                                         | `[]`                     |
| `persistence.enabled`                               | Enable persistence using PVC                                                                                                                                                                                      | `true`                   |
| `persistence.storageClass`                          | PVC Storage Class for Matomo volume                                                                                                                                                                               | `""`                     |
| `persistence.accessModes`                           | PVC Access Mode for Matomo volume                                                                                                                                                                                 | `["ReadWriteOnce"]`      |
| `persistence.size`                                  | PVC Storage Request for Matomo volume                                                                                                                                                                             | `8Gi`                    |
| `persistence.dataSource`                            | Custom PVC data source                                                                                                                                                                                            | `{}`                     |
| `persistence.existingClaim`                         | A manually managed Persistent Volume Claim                                                                                                                                                                        | `""`                     |
| `persistence.hostPath`                              | If defined, the matomo-data volume will mount to the specified hostPath.                                                                                                                                          | `""`                     |
| `persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                               | `{}`                     |
| `persistence.selector`                              | Selector to match an existing Persistent Volume for Matomo data PVC                                                                                                                                               | `{}`                     |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                     |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                   |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                     |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                     |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                     |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                     |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`                     |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`                  |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                     |
| `podSecurityContext.enabled`                        | Enable Matomo pods' Security Context                                                                                                                                                                              | `true`                   |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                 |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                     |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                     |
| `podSecurityContext.fsGroup`                        | Matomo pods' group ID                                                                                                                                                                                             | `1001`                   |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                   |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                     |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                   |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `0`                      |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                   |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                  |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `false`                  |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                  |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`         |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                  |
| `startupProbe.path`                                 | Request path for startupProbe                                                                                                                                                                                     | `/matomo.php`            |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `600`                    |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                     |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                      |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `5`                      |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                      |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                   |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `600`                    |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                     |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                      |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `5`                      |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                      |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                   |
| `readinessProbe.path`                               | Request path for readinessProbe                                                                                                                                                                                   | `/matomo.php`            |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`                     |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `5`                      |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                      |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `5`                      |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                      |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                     |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                     |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                     |
| `lifecycleHooks`                                    | LifecycleHook to set additional configuration at startup Evaluated as a template                                                                                                                                  | `{}`                     |
| `podAnnotations`                                    | Pod annotations                                                                                                                                                                                                   | `{}`                     |
| `podLabels`                                         | Add additional labels to the pod (evaluated as a template)                                                                                                                                                        | `{}`                     |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                                          | `LoadBalancer`           |
| `service.ports.http`               | Service HTTP port                                                                                                                | `80`                     |
| `service.ports.https`              | Service HTTPS port                                                                                                               | `443`                    |
| `service.loadBalancerSourceRanges` | Restricts access for LoadBalancer (only with `service.type: LoadBalancer`)                                                       | `[]`                     |
| `service.loadBalancerIP`           | loadBalancerIP for the Matomo Service (optional, cloud specific)                                                                 | `""`                     |
| `service.nodePorts`                | Kubernetes node port                                                                                                             | `{}`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.clusterIP`                | Matomo service Cluster IP                                                                                                        | `""`                     |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`              | Additional custom annotations for Matomo service                                                                                 | `{}`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.pathType`                 | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `matomo.local`           |
| `ingress.path`                     | The Path to Matomo. You may need to set this to '/*' in order to use this                                                        | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Database parameters

| Name                                        | Description                                                                                                                                                                                                                | Value               |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements                                                                                                                                       | `true`              |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                                                                                                                                                       | `standalone`        |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                                                                                                                                                       | `""`                |
| `mariadb.auth.database`                     | Database name to create                                                                                                                                                                                                    | `bitnami_matomo`    |
| `mariadb.auth.username`                     | Database user to create                                                                                                                                                                                                    | `bn_matomo`         |
| `mariadb.auth.password`                     | Password for the database                                                                                                                                                                                                  | `""`                |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                                                                                                                                                      | `true`              |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                                                                                                                                                            | `""`                |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                                                                                                                                                    | `["ReadWriteOnce"]` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                                                                                                                                                            | `8Gi`               |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)                                                                                                                                   | `""`                |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                                                                                                                                                   | `""`                |
| `mariadb.primary.resourcesPreset`           | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `micro`             |
| `mariadb.primary.resources`                 | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                |
| `externalDatabase.host`                     | Host of the existing database                                                                                                                                                                                              | `""`                |
| `externalDatabase.port`                     | Port of the existing database                                                                                                                                                                                              | `3306`              |
| `externalDatabase.user`                     | Existing username in the external db                                                                                                                                                                                       | `bn_matomo`         |
| `externalDatabase.password`                 | Password for the above username                                                                                                                                                                                            | `""`                |
| `externalDatabase.database`                 | Name of the existing database                                                                                                                                                                                              | `bitnami_matomo`    |
| `externalDatabase.existingSecret`           | Name of a secret containing the database credentials                                                                                                                                                                       | `""`                |

### Volume Permissions parameters

| Name                                  | Description                                                                                                                                                                                                                                           | Value                      |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                             | `false`                    |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                                                                                                                                                          | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`      | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `small`                    |
| `volumePermissions.resources`         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |

### Metrics parameters

| Name                        | Description                                                                                                                                                                                                                       | Value                             |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`           | Start a exporter side-car                                                                                                                                                                                                         | `false`                           |
| `metrics.image.registry`    | Apache exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`  | Apache exporter image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`      | Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`  | Image pull policy                                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets` | Specify docker-registry secret names as an array                                                                                                                                                                                  | `[]`                              |
| `metrics.resourcesPreset`   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `small`                           |
| `metrics.resources`         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.podAnnotations`    | Additional annotations for Metrics exporter pod                                                                                                                                                                                   | `{}`                              |

### Certificate injection parameters

| Name                                                 | Description                                                                                                       | Value                                    |
| ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                                                                  | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                                                               | `secret-name`                            |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                                                               | `secret-key`                             |
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

### NetworkPolicy parameters

| Name                                    | Description                                                     | Value  |
| --------------------------------------- | --------------------------------------------------------------- | ------ |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created             | `true` |
| `networkPolicy.allowExternal`           | Don't require server label for connections                      | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations. | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces          | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces      | `{}`   |

### CronJob parameters

| Name                                                                       | Description                                                                                                       | Value            |
| -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ---------------- |
| `cronjobs.taskScheduler.enabled`                                           | Whether to enable scheduled mail-to-task CronJob                                                                  | `true`           |
| `cronjobs.taskScheduler.schedule`                                          | Kubernetes CronJob schedule                                                                                       | `*/5 * * * *`    |
| `cronjobs.taskScheduler.suspend`                                           | Whether to create suspended CronJob                                                                               | `false`          |
| `cronjobs.taskScheduler.affinity`                                          | Affinity for CronJob pod assignment                                                                               | `{}`             |
| `cronjobs.taskScheduler.nodeSelector`                                      | Node labels for CronJob pod assignment. Evaluated as a template.                                                  | `{}`             |
| `cronjobs.taskScheduler.tolerations`                                       | Tolerations for CronJob pod assignment                                                                            | `[]`             |
| `cronjobs.taskScheduler.command`                                           | Override default container command (useful when using custom images)                                              | `[]`             |
| `cronjobs.taskScheduler.args`                                              | Override default container args (useful when using custom images)                                                 | `[]`             |
| `cronjobs.taskScheduler.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                              | `true`           |
| `cronjobs.taskScheduler.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                  | `{}`             |
| `cronjobs.taskScheduler.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                        | `1001`           |
| `cronjobs.taskScheduler.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                       | `0`              |
| `cronjobs.taskScheduler.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                     | `true`           |
| `cronjobs.taskScheduler.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                       | `false`          |
| `cronjobs.taskScheduler.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                           | `false`          |
| `cronjobs.taskScheduler.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                         | `false`          |
| `cronjobs.taskScheduler.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                | `["ALL"]`        |
| `cronjobs.taskScheduler.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                  | `RuntimeDefault` |
| `cronjobs.taskScheduler.podAnnotations`                                    | Additional pod annotations                                                                                        | `{}`             |
| `cronjobs.taskScheduler.podLabels`                                         | Additional pod labels                                                                                             | `{}`             |
| `cronjobs.taskScheduler.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads) | `{}`             |
| `cronjobs.taskScheduler.persistence.enabled`                               | Enable persistence using Persistent Volume Claims                                                                 | `true`           |
| `cronjobs.taskScheduler.persistence.existingClaim`                         | A manually managed Persistent Volume Claim                                                                        | `""`             |
| `cronjobs.taskScheduler.podSecurityContext.enabled`                        | Enable Task scheduler cronjob pods' Security Context                                                              | `true`           |
| `cronjobs.taskScheduler.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                | `Always`         |
| `cronjobs.taskScheduler.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                    | `[]`             |
| `cronjobs.taskScheduler.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                       | `[]`             |
| `cronjobs.taskScheduler.podSecurityContext.fsGroup`                        | Task scheduler cronjob pods' group ID                                                                             | `1001`           |
| `cronjobs.taskScheduler.extraEnvVars`                                      | Extra environment variables for the taskScheduler CronJob                                                         | `[]`             |
| `cronjobs.archive.enabled`                                                 | Whether to enable scheduled mail-to-task CronJob                                                                  | `true`           |
| `cronjobs.archive.schedule`                                                | Kubernetes CronJob schedule                                                                                       | `*/5 * * * *`    |
| `cronjobs.archive.suspend`                                                 | Whether to create suspended CronJob                                                                               | `false`          |
| `cronjobs.archive.affinity`                                                | Affinity for CronJob pod assignment                                                                               | `{}`             |
| `cronjobs.archive.tolerations`                                             | Tolerations for CronJob pod assignment                                                                            | `[]`             |
| `cronjobs.archive.nodeSelector`                                            | Node labels for CronJob pod assignment. Evaluated as a template.                                                  | `{}`             |
| `cronjobs.archive.command`                                                 | Override default container command (useful when using custom images)                                              | `[]`             |
| `cronjobs.archive.args`                                                    | Override default container args (useful when using custom images)                                                 | `[]`             |
| `cronjobs.archive.containerSecurityContext.enabled`                        | Enabled containers' Security Context                                                                              | `true`           |
| `cronjobs.archive.containerSecurityContext.seLinuxOptions`                 | Set SELinux options in container                                                                                  | `{}`             |
| `cronjobs.archive.containerSecurityContext.runAsUser`                      | Set containers' Security Context runAsUser                                                                        | `1001`           |
| `cronjobs.archive.containerSecurityContext.runAsGroup`                     | Set containers' Security Context runAsGroup                                                                       | `0`              |
| `cronjobs.archive.containerSecurityContext.runAsNonRoot`                   | Set container's Security Context runAsNonRoot                                                                     | `true`           |
| `cronjobs.archive.containerSecurityContext.privileged`                     | Set container's Security Context privileged                                                                       | `false`          |
| `cronjobs.archive.containerSecurityContext.readOnlyRootFilesystem`         | Set container's Security Context readOnlyRootFilesystem                                                           | `false`          |
| `cronjobs.archive.containerSecurityContext.allowPrivilegeEscalation`       | Set container's Security Context allowPrivilegeEscalation                                                         | `false`          |
| `cronjobs.archive.containerSecurityContext.capabilities.drop`              | List of capabilities to be dropped                                                                                | `["ALL"]`        |
| `cronjobs.archive.containerSecurityContext.seccompProfile.type`            | Set container's Security Context seccomp profile                                                                  | `RuntimeDefault` |
| `cronjobs.archive.podAnnotations`                                          | Additional pod annotations                                                                                        | `{}`             |
| `cronjobs.archive.podLabels`                                               | Additional pod labels                                                                                             | `{}`             |
| `cronjobs.archive.resources`                                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads) | `{}`             |
| `cronjobs.archive.persistence.enabled`                                     | Enable persistence using Persistent Volume Claims                                                                 | `true`           |
| `cronjobs.archive.persistence.existingClaim`                               | A manually managed Persistent Volume Claim                                                                        | `""`             |
| `cronjobs.archive.podSecurityContext.enabled`                              | Enable Archive cronjob pods' Security Context                                                                     | `true`           |
| `cronjobs.archive.podSecurityContext.fsGroupChangePolicy`                  | Set filesystem group change policy                                                                                | `Always`         |
| `cronjobs.archive.podSecurityContext.sysctls`                              | Set kernel settings using the sysctl interface                                                                    | `[]`             |
| `cronjobs.archive.podSecurityContext.supplementalGroups`                   | Set filesystem extra groups                                                                                       | `[]`             |
| `cronjobs.archive.podSecurityContext.fsGroup`                              | Archive cronjob pods' group ID                                                                                    | `1001`           |
| `cronjobs.archive.extraEnvVars`                                            | Extra environment variables for the archive CronJob                                                               | `[]`             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set matomoUsername=user,matomoPassword=password,mariadb.auth.rootPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/matomo
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Matomo administrator account username and password to `user` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/matomo
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/matomo/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 7.0.0

This major bump changes the following security defaults:

- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

Also, this major release bumps the MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 6.0.0

Moved persistence config for the cronjobs from `persistence` to `cronjobs.archive.persistence` and `cronjobs.taskScheduler.persistence` respectively.
Moved resource config for the archive cronjob from `resources` to `cronjobs.archive.resources`.

### To 4.0.0

This major release bumps the MariaDB version to 11.2. No major issues are expected during the upgrade.

### To 3.2.0

This version deprecates `cronjobs.enabled` value in favor of `cronjobs.taskScheduler.enabled` and `cronjobs.archive.enabled` values.

### To 3.0.0

This major release bumps the MariaDB version to 11.1. No major issues are expected during the upgrade.

### To 2.0.0

This major release bumps the MariaDB version to 11.0. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-11-to-mariadb-11-0/) for upgrading from MariaDB 10.11 to 11.0. No major issues are expected during the upgrade.

### To 1.0.0

This major release bumps the MariaDB version to 10.11. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-6-to-mariadb-10-11/) for upgrading from MariaDB 10.6 to 10.11. No major issues are expected during the upgrade.

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