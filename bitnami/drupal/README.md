<!--- app-name: Drupal -->

# Bitnami package for Drupal

Drupal is one of the most versatile open source content management systems in the world. It is pre-configured with the Ctools and Views modules, Drush and Let's Encrypt auto-configuration support.

[Overview of Drupal](http://drupal.org)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/drupal
```

Looking to use Drupal in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Drupal](https://github.com/bitnami/containers/tree/main/bitnami/drupal) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment as a database for the Drupal application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/drupal
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Drupal on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

The [Bitnami Drupal](https://github.com/bitnami/containers/tree/main/bitnami/drupal) image stores the Drupal data and configurations at the `/bitnami/drupal` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```console
helm install my-release --set persistence.existingClaim=PVC_NAME oci://REGISTRY_NAME/REPOSITORY_NAME/drupal
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
    helm install my-release --set persistence.hostPath=/PATH/TO/HOST/MOUNT oci://REGISTRY_NAME/REPOSITORY_NAME/drupal
    ```

    > Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

    This will mount the `drupal-data` volume into the `hostPath` directory. The site data will be persisted if the mount path contains valid data, else the site data will be initialized at first launch.
3. Because the container cannot control the host machine's directory permissions, you must set the Drupal file directory permissions yourself and disable or clear Drupal cache. See Drupal Core's [INSTALL.txt](https://cgit.drupalcode.org/drupal/tree/core/INSTALL.txt?h=8.3.x#n152) for setting file permissions, and see [Drupal handbook page](https://www.drupal.org/node/2598914) to disable the cache, or [Drush handbook](https://drushcommands.com/drush-8x/cache/cache-rebuild/) to clear cache.

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
| `nameOverride`      | String to partially override drupal.fullname template (will maintain the release name)                     | `""`  |
| `fullnameOverride`  | String to fully override drupal.fullname template                                                          | `""`  |
| `namespaceOverride` | String to fully override common.names.namespace                                                            | `""`  |
| `commonAnnotations` | Common annotations to add to all Drupal resources (sub-charts are not considered). Evaluated as a template | `{}`  |
| `commonLabels`      | Common labels to add to all Drupal resources (sub-charts are not considered). Evaluated as a template      | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template).                               | `[]`  |

### Drupal parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                    |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `image.registry`                                    | Drupal image registry                                                                                                                                                                                             | `REGISTRY_NAME`          |
| `image.repository`                                  | Drupal Image name                                                                                                                                                                                                 | `REPOSITORY_NAME/drupal` |
| `image.digest`                                      | Drupal image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                            | `""`                     |
| `image.pullPolicy`                                  | Drupal image pull policy                                                                                                                                                                                          | `IfNotPresent`           |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                     |
| `image.debug`                                       | Specify if debug logs should be enabled                                                                                                                                                                           | `false`                  |
| `replicaCount`                                      | Number of Drupal Pods to run (requires ReadWriteMany PVC support)                                                                                                                                                 | `1`                      |
| `drupalProfile`                                     | Drupal installation profile                                                                                                                                                                                       | `standard`               |
| `drupalSkipInstall`                                 | Skip Drupal installation wizard. Useful for migrations and restoring from SQL dump                                                                                                                                | `false`                  |
| `drupalUsername`                                    | User of the application                                                                                                                                                                                           | `user`                   |
| `drupalPassword`                                    | Application password                                                                                                                                                                                              | `""`                     |
| `drupalEmail`                                       | Admin email                                                                                                                                                                                                       | `user@example.com`       |
| `allowEmptyPassword`                                | Allow DB blank passwords                                                                                                                                                                                          | `true`                   |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                     |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                     |
| `updateStrategy.type`                               | Update strategy - only really applicable for deployments with RWO PVs attached                                                                                                                                    | `RollingUpdate`          |
| `priorityClassName`                                 | Drupal pods' priorityClassName                                                                                                                                                                                    | `""`                     |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                     |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                     |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                  |
| `hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                       | `[]`                     |
| `extraEnvVars`                                      | Extra environment variables                                                                                                                                                                                       | `[]`                     |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars                                                                                                                                                                               | `""`                     |
| `extraEnvVarsSecret`                                | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                      | `""`                     |
| `extraVolumes`                                      | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`                                                                                                | `[]`                     |
| `extraVolumeMounts`                                 | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.                                                                                             | `[]`                     |
| `initContainers`                                    | Add additional init containers to the pod (evaluated as a template)                                                                                                                                               | `[]`                     |
| `sidecars`                                          | Attach additional containers to the pod (evaluated as a template)                                                                                                                                                 | `[]`                     |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                     |
| `serviceAccount.create`                             | Specifies whether a service account should be created                                                                                                                                                             | `true`                   |
| `serviceAccount.name`                               | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                                            | `""`                     |
| `serviceAccount.annotations`                        | Add annotations                                                                                                                                                                                                   | `{}`                     |
| `serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                                                                                                  | `false`                  |
| `existingSecret`                                    | Name of a secret with the application password                                                                                                                                                                    | `""`                     |
| `smtpHost`                                          | SMTP host                                                                                                                                                                                                         | `""`                     |
| `smtpPort`                                          | SMTP port                                                                                                                                                                                                         | `""`                     |
| `smtpUser`                                          | SMTP user                                                                                                                                                                                                         | `""`                     |
| `smtpPassword`                                      | SMTP password                                                                                                                                                                                                     | `""`                     |
| `smtpProtocol`                                      | SMTP Protocol (options: ssl,tls, nil)                                                                                                                                                                             | `""`                     |
| `containerPorts`                                    | Container ports                                                                                                                                                                                                   | `{}`                     |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Drupal container(s)                                                                                                                                         | `[]`                     |
| `sessionAffinity`                                   | Control where client requests go, to the same pod or round-robin. Values: ClientIP or None                                                                                                                        | `None`                   |
| `persistence.enabled`                               | Enable persistence using PVC                                                                                                                                                                                      | `true`                   |
| `persistence.storageClass`                          | PVC Storage Class for Drupal volume                                                                                                                                                                               | `""`                     |
| `persistence.accessModes`                           | PVC Access Mode for Drupal volume                                                                                                                                                                                 | `["ReadWriteOnce"]`      |
| `persistence.size`                                  | PVC Storage Request for Drupal volume                                                                                                                                                                             | `8Gi`                    |
| `persistence.existingClaim`                         | A manually managed Persistent Volume Claim                                                                                                                                                                        | `""`                     |
| `persistence.hostPath`                              | If defined, the drupal-data volume will mount to the specified hostPath.                                                                                                                                          | `""`                     |
| `persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                               | `{}`                     |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                     |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                   |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                     |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                     |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                     |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                     |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`                     |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`                  |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                     |
| `podSecurityContext.enabled`                        | Enable Drupal pods' Security Context                                                                                                                                                                              | `true`                   |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                 |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                     |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                     |
| `podSecurityContext.fsGroup`                        | Drupal pods' group ID                                                                                                                                                                                             | `1001`                   |
| `containerSecurityContext.enabled`                  | Enabled Drupal containers' Security Context                                                                                                                                                                       | `true`                   |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                     |
| `containerSecurityContext.runAsUser`                | Set Drupal containers' Security Context runAsUser                                                                                                                                                                 | `1001`                   |
| `containerSecurityContext.runAsGroup`               | Set Drupal containers' Security Context runAsGroup                                                                                                                                                                | `1001`                   |
| `containerSecurityContext.runAsNonRoot`             | Set Controller container's Security Context runAsNonRoot                                                                                                                                                          | `true`                   |
| `containerSecurityContext.privileged`               | Set Drupal container's Security Context privileged                                                                                                                                                                | `false`                  |
| `containerSecurityContext.allowPrivilegeEscalation` | Set Drupal container's Security Context allowPrivilegeEscalation                                                                                                                                                  | `false`                  |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`         |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set Drupal container's Security Context readOnlyRootFilesystem                                                                                                                                                    | `true`                   |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                  |
| `startupProbe.path`                                 | Request path for startupProbe                                                                                                                                                                                     | `/user/login`            |
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
| `readinessProbe.path`                               | Request path for readinessProbe                                                                                                                                                                                   | `/user/login`            |
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
| `service.loadBalancerIP`           | loadBalancerIP for the Drupal Service (optional, cloud specific)                                                                 | `""`                     |
| `service.nodePorts`                | Kubernetes node port                                                                                                             | `{}`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.clusterIP`                | %%MAIN_CONTAINER_NAME%% service Cluster IP                                                                                       | `""`                     |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`              | Additional custom annotations for %%MAIN_CONTAINER_NAME%% service                                                                | `{}`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.pathType`                 | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `drupal.local`           |
| `ingress.path`                     | The Path to Drupal. You may need to set this to '/*' in order to use this                                                        | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.tlsWwwPrefix`             | Adds www subdomain to default cert                                                                                               | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Database parameters

| Name                                        | Description                                                                                                                                                            | Value               |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements                                                                                   | `true`              |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                                                                                                   | `standalone`        |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                                                                                                   | `""`                |
| `mariadb.auth.database`                     | Database name to create                                                                                                                                                | `bitnami_drupal`    |
| `mariadb.auth.username`                     | Database user to create                                                                                                                                                | `bn_drupal`         |
| `mariadb.auth.password`                     | Password for the database                                                                                                                                              | `""`                |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                                                                                                  | `true`              |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                                                                                                        | `""`                |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                                                                                                | `["ReadWriteOnce"]` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                                                                                                        | `8Gi`               |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)                                                                               | `""`                |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                                                                                               | `""`                |
| `externalDatabase.host`                     | Host of the existing database                                                                                                                                          | `""`                |
| `externalDatabase.port`                     | Port of the existing database                                                                                                                                          | `3306`              |
| `externalDatabase.user`                     | Existing username in the external db                                                                                                                                   | `bn_drupal`         |
| `externalDatabase.password`                 | Password for the above username. Ignored if existing secret is provided                                                                                                | `""`                |
| `externalDatabase.database`                 | Name of the existing database                                                                                                                                          | `bitnami_drupal`    |
| `externalDatabase.existingSecret`           | Name of a secret with the database password. (externalDatabase.password will be ignored and picked up from this secret). The secret has to contain the key db-password | `""`                |

### Volume Permissions parameters

| Name                                  | Description                                                                                                                                                                                                                                           | Value                      |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                             | `false`                    |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                                                                                                                                                          | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`      | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array                                                                                                                                                                                                      | `[]`                       |
| `volumePermissions.resourcesPreset`   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `none`                     |
| `volumePermissions.resources`         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |

### Metrics parameters

| Name                                       | Description                                                                                                                                                                                                                       | Value                             |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                          | Start a exporter side-car                                                                                                                                                                                                         | `false`                           |
| `metrics.image.registry`                   | Apache exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`                 | Apache exporter image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`                     | Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                                                                                                                                                  | `[]`                              |
| `metrics.resourcesPreset`                  | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `none`                            |
| `metrics.resources`                        | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                                                                                                                                   | `{}`                              |
| `metrics.service.type`                     | Drupal exporter service type                                                                                                                                                                                                      | `ClusterIP`                       |
| `metrics.service.ports.metrics`            | Drupal exporter service port                                                                                                                                                                                                      | `9117`                            |
| `metrics.service.externalTrafficPolicy`    | Drupal exporter service external traffic policy                                                                                                                                                                                   | `Cluster`                         |
| `metrics.service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                    | `[]`                              |
| `metrics.service.loadBalancerIP`           | Drupal exporter service Load Balancer IP                                                                                                                                                                                          | `""`                              |
| `metrics.service.loadBalancerSourceRanges` | Drupal exporter service Load Balancer sources                                                                                                                                                                                     | `[]`                              |
| `metrics.service.annotations`              | Additional custom annotations for Drupal exporter service                                                                                                                                                                         | `{}`                              |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator                                                                                                                                                   | `false`                           |
| `metrics.serviceMonitor.namespace`         | The namespace in which the ServiceMonitor will be created                                                                                                                                                                         | `""`                              |
| `metrics.serviceMonitor.interval`          | The interval at which metrics should be scraped                                                                                                                                                                                   | `30s`                             |
| `metrics.serviceMonitor.scrapeTimeout`     | The timeout after which the scrape is ended                                                                                                                                                                                       | `""`                              |
| `metrics.serviceMonitor.relabellings`      | Metrics RelabelConfigs to apply to samples before scraping.                                                                                                                                                                       | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings` | Metrics RelabelConfigs to apply to samples before ingestion.                                                                                                                                                                      | `[]`                              |
| `metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                           |
| `metrics.serviceMonitor.additionalLabels`  | Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus                                                                                                                                  | `{}`                              |
| `metrics.prometheusRule.enabled`           | Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator                                                                                                                                             | `false`                           |
| `metrics.prometheusRule.namespace`         | The namespace in which the prometheusRule will be created                                                                                                                                                                         | `""`                              |
| `metrics.prometheusRule.additionalLabels`  | Additional labels for the prometheusRule                                                                                                                                                                                          | `{}`                              |
| `metrics.prometheusRule.rules`             | Custom Prometheus rules                                                                                                                                                                                                           | `[]`                              |

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

The above parameters map to the env variables defined in [bitnami/drupal](https://github.com/bitnami/containers/tree/main/bitnami/drupal). For more information please refer to the [bitnami/drupal](https://github.com/bitnami/containers/tree/main/bitnami/drupal) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set drupalUsername=admin,drupalPassword=password,mariadb.auth.rootPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/drupal
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Drupal administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/drupal
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/drupal/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 18.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

Also, this major release bumps the MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 17.0.0

This major release bumps the MariaDB version to 11.2. No major issues are expected during the upgrade.

### To 16.0.0

This major release bumps the MariaDB version to 11.1. No major issues are expected during the upgrade.

### To 15.0.0

This major release bumps the MariaDB version to 11.0. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-11-to-mariadb-11-0/) for upgrading from MariaDB 10.11 to 11.0. No major issues are expected during the upgrade.

### To 14.0.0

This major release bumps the MariaDB version to 10.11. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-6-to-mariadb-10-11/) for upgrading from MariaDB 10.6 to 10.11. No major issues are expected during the upgrade.

### To 12.0.0

This major release bumps the MariaDB version to 10.6. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-105-to-mariadb-106/) for upgrading from MariaDB 10.5 to 10.6. No major issues are expected during the upgrade.

### To 11.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated, we recommend using `service.ports.http` instead.
- `service.httpsPort` was deprecated, we recommend using `service.ports.https` instead.
- `persistence.accessMode` has been deprecated, we recommend using `persistence.accessModes` instead.

Additionally also updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes.

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

### To 9.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-800) for more information.

To upgrade to `9.0.0`, you have two alternatives:

- Install a new Drupal chart, and migrate your Drupal site using backup/restore tools such as [Drupal Backup and Migrate](https://www.drupal.org/project/backup_migrate).
- Reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `drupal`):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
export DRUPAL_PASSWORD=$(kubectl get secret --namespace default drupal -o jsonpath="{.data.drupal-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default drupal-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default drupal-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=drupal -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling Drupal replicas to 0:

```console
helm upgrade drupal oci://REGISTRY_NAME/REPOSITORY_NAME/drupal --set drupalPassword=$DRUPAL_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 8.2.1
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Finally, upgrade you release to 9.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
helm upgrade drupal oci://REGISTRY_NAME/REPOSITORY_NAME/drupal --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set drupalPassword=$DRUPAL_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=drupal,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 8.0.0

The [Bitnami Drupal](https://github.com/bitnami/containers/tree/main/bitnami/drupal) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed.

To upgrade to `8.0.0`, backup Drupal data and the previous MariaDB databases, install a new Drupal chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

This upgrade also adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information.

### To 6.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In <https://github.com/helm/charts/pull/17295> the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is drupal:

```console
kubectl patch deployment drupal-drupal --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset drupal-mariadb --cascade=false
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