<!--- app-name: MediaWiki -->

# Bitnami package for MediaWiki

MediaWiki is the free and open source wiki software that powers Wikipedia. Used by thousands of organizations, it is extremely powerful, scalable software and a feature-rich wiki implementation.

[Overview of MediaWiki](http://www.mediawiki.org/wiki/MediaWiki)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mediawiki
```

Looking to use MediaWiki in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [MediaWiki](https://github.com/bitnami/containers/tree/main/bitnami/mediawiki) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the MediaWiki application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/mediawiki
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys MediaWiki on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Mediawki app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

## Persistence

The [Bitnami MediaWiki](https://github.com/bitnami/containers/tree/main/bitnami/mediawiki) image stores the MediaWiki data and configurations at the `/bitnami/mediawiki` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
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

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`      | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`      | Labels to add to all deployed objects                                                        | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                                                   | `{}`            |
| `clusterDomain`     | Default Kubernetes cluster domain                                                            | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                            | `[]`            |

### Mediawiki parameters

| Name                           | Description                                                                                                                                        | Value                       |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.registry`               | MediaWiki image registry                                                                                                                           | `REGISTRY_NAME`             |
| `image.repository`             | MediaWiki image repository                                                                                                                         | `REPOSITORY_NAME/mediawiki` |
| `image.digest`                 | MediaWiki image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                          | `""`                        |
| `image.pullPolicy`             | Image pull policy                                                                                                                                  | `IfNotPresent`              |
| `image.pullSecrets`            | Specify docker-registry secret names as an array                                                                                                   | `[]`                        |
| `image.debug`                  | Enable MediaWiki image debug mode                                                                                                                  | `false`                     |
| `automountServiceAccountToken` | Mount Service Account token in pod                                                                                                                 | `false`                     |
| `hostAliases`                  | Deployment pod host aliases                                                                                                                        | `[]`                        |
| `mediawikiUser`                | User of the application                                                                                                                            | `user`                      |
| `mediawikiPassword`            | Application password                                                                                                                               | `""`                        |
| `mediawikiSecret`              | Existing `Secret` containing the password for the `mediawikiUser` user; must contain the key `mediawiki-password` and optional key `smtp-password` | `""`                        |
| `mediawikiEmail`               | Admin email                                                                                                                                        | `user@example.com`          |
| `mediawikiName`                | Name for the wiki                                                                                                                                  | `My Wiki`                   |
| `mediawikiHost`                | Mediawiki host to create application URLs                                                                                                          | `""`                        |
| `allowEmptyPassword`           | Allow DB blank passwords                                                                                                                           | `yes`                       |
| `smtpHost`                     | SMTP host                                                                                                                                          | `""`                        |
| `smtpPort`                     | SMTP port                                                                                                                                          | `""`                        |
| `smtpHostID`                   | SMTP host ID                                                                                                                                       | `""`                        |
| `smtpUser`                     | SMTP user                                                                                                                                          | `""`                        |
| `smtpPassword`                 | SMTP password                                                                                                                                      | `""`                        |
| `command`                      | Override default container command (useful when using custom images)                                                                               | `[]`                        |
| `args`                         | Override default container args (useful when using custom images)                                                                                  | `[]`                        |
| `lifecycleHooks`               | for the Mediawiki container(s) to automate configuration before or after startup                                                                   | `{}`                        |
| `extraEnvVars`                 | Extra environment variables to be set on Mediawki container                                                                                        | `[]`                        |
| `extraEnvVarsCM`               | Name of existing ConfigMap containing extra env vars                                                                                               | `""`                        |
| `extraEnvVarsSecret`           | Name of existing Secret containing extra env vars                                                                                                  | `""`                        |

### Mediawiki deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                                             |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `replicaCount`                                      | Number of Mediawiki replicas to deploy                                                                                                                                                                            | `1`                                               |
| `updateStrategy.type`                               | StrategyType can be set to RollingUpdate or OnDelete                                                                                                                                                              | `RollingUpdate`                                   |
| `podSecurityContext.enabled`                        | Enable Mediawiki pods' Security Context                                                                                                                                                                           | `true`                                            |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                                          |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                                              |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                                              |
| `podSecurityContext.fsGroup`                        | Group ID for the volumes of the pod                                                                                                                                                                               | `1001`                                            |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`                                            |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                                              |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                                            |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                                            |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                                            |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                                           |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                                            |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                                           |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                                         |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`                                  |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`                                           |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                                              |
| `containerPorts.http`                               | MediaWiki HTTP container port                                                                                                                                                                                     | `8080`                                            |
| `containerPorts.https`                              | MediaWiki HTTPS container port                                                                                                                                                                                    | `8443`                                            |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for MediaWiki container(s)                                                                                                                                      | `[]`                                              |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                                           |
| `startupProbe.httpGet.path`                         | Request path for startupProbe                                                                                                                                                                                     | `/api.php?action=query&meta=siteinfo&format=none` |
| `startupProbe.httpGet.port`                         | Port for startupProbe                                                                                                                                                                                             | `http`                                            |
| `startupProbe.httpGet.httpHeaders`                  | Headers for startupProbe                                                                                                                                                                                          | `[]`                                              |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `120`                                             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                                              |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                                               |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`                                               |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                                               |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                                            |
| `livenessProbe.httpGet.path`                        | Request path for livenessProbe                                                                                                                                                                                    | `/api.php?action=query&meta=siteinfo&format=none` |
| `livenessProbe.httpGet.port`                        | Port for livenessProbe                                                                                                                                                                                            | `http`                                            |
| `livenessProbe.httpGet.httpHeaders`                 | Headers for livenessProbe                                                                                                                                                                                         | `[]`                                              |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `120`                                             |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                                              |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                                               |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`                                               |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                                               |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                                            |
| `readinessProbe.httpGet.path`                       | Request path for readinessProbe                                                                                                                                                                                   | `/api.php?action=query&meta=siteinfo&format=none` |
| `readinessProbe.httpGet.port`                       | Port for readinessProbe                                                                                                                                                                                           | `http`                                            |
| `readinessProbe.httpGet.httpHeaders`                | Headers for livenessProbe                                                                                                                                                                                         | `[]`                                              |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`                                              |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                                              |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`                                               |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`                                               |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                                               |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                                              |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                                              |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                                              |
| `podLabels`                                         | Extra labels for Mediawki pods                                                                                                                                                                                    | `{}`                                              |
| `podAnnotations`                                    | Annotations for Mediawki pods                                                                                                                                                                                     | `{}`                                              |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                                              |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                                            |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                                              |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                            | `""`                                              |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                                              |
| `affinity`                                          | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                             | `{}`                                              |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                          | `{}`                                              |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                          | `[]`                                              |
| `priorityClassName`                                 | Mediawiki pods' priorityClassName                                                                                                                                                                                 | `""`                                              |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                                              |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                                              |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Mediawki pods                                                                                                                                             | `[]`                                              |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Mediawki container(s)                                                                                                                                | `[]`                                              |
| `initContainers`                                    | Add additional init containers to the Mediawki pods                                                                                                                                                               | `[]`                                              |
| `sidecars`                                          | Add additional sidecar containers to the Mediawki pods                                                                                                                                                            | `[]`                                              |
| `persistence.enabled`                               | Enable persistence using PVC                                                                                                                                                                                      | `true`                                            |
| `persistence.storageClass`                          | PVC Storage Class for MediaWiki volume                                                                                                                                                                            | `""`                                              |
| `persistence.existingClaim`                         | An Existing PVC name for MediaWiki volume                                                                                                                                                                         | `""`                                              |
| `persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                    | `[]`                                              |
| `persistence.size`                                  | PVC Storage Request for MediaWiki volume                                                                                                                                                                          | `8Gi`                                             |
| `persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                               | `{}`                                              |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for Dokuwiki pod                                                                                                                                                                | `true`                                            |
| `serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                            | `""`                                              |
| `serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                            | `false`                                           |
| `serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                              | `{}`                                              |

### Traffic Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                                          | `LoadBalancer`           |
| `service.ports.http`               | Service HTTP port                                                                                                                | `80`                     |
| `service.ports.https`              | HTTPS Port. Set this to any value (recommended: 443) to enable the https service port                                            | `443`                    |
| `service.nodePorts.http`           | Kubernetes http node port                                                                                                        | `""`                     |
| `service.nodePorts.https`          | Kubernetes https node port                                                                                                       | `""`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.clusterIP`                | Mediawiki service Cluster IP                                                                                                     | `""`                     |
| `service.loadBalancerIP`           | Mediawiki service Load Balancer IP                                                                                               | `""`                     |
| `service.loadBalancerSourceRanges` | Mediawiki service Load Balancer sources                                                                                          | `[]`                     |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`              | Additional custom annotations for Mediawiki service                                                                              | `{}`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `mediawiki.local`        |
| `ingress.path`                     | The Path to Mediawiki. You may need to set this to '/*' in order to use this with ALB ingress controllers.                       | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Database parameters

| Name                                        | Description                                                                           | Value               |
| ------------------------------------------- | ------------------------------------------------------------------------------------- | ------------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements. | `true`              |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                  | `standalone`        |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                  | `""`                |
| `mariadb.auth.database`                     | Database name to create                                                               | `bitnami_mediawiki` |
| `mariadb.auth.username`                     | Database user to create                                                               | `bn_mediawiki`      |
| `mariadb.auth.password`                     | Password for the database                                                             | `""`                |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                 | `true`              |
| `mariadb.primary.persistence.storageClass`  | PVC Storage Class                                                                     | `""`                |
| `mariadb.primary.persistence.accessModes`   | Persistent Volume Access Mode                                                         | `["ReadWriteOnce"]` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                       | `8Gi`               |
| `mariadb.primary.persistence.hostPath`      | Host mount path for MariaDB volume                                                    | `""`                |
| `mariadb.primary.persistence.existingClaim` | Enable persistence using an existing PVC                                              | `""`                |
| `externalDatabase.existingSecret`           | Use existing secret (ignores previous password)                                       | `""`                |
| `externalDatabase.host`                     | Host of the existing database                                                         | `""`                |
| `externalDatabase.port`                     | Port of the existing database                                                         | `3306`              |
| `externalDatabase.user`                     | Existing username in the external db                                                  | `bn_mediawiki`      |
| `externalDatabase.password`                 | Password for the above username                                                       | `""`                |
| `externalDatabase.database`                 | Name of the existing database                                                         | `bitnami_mediawiki` |

### Metrics parameters

| Name                                       | Description                                                                                                                                                                                                                       | Value                             |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                                                                                                                                              | `false`                           |
| `metrics.image.registry`                   | Apache exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`                 | Apache exporter image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`                     | Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                                                                                                                                                  | `[]`                              |
| `metrics.resourcesPreset`                  | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                            |
| `metrics.resources`                        | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.port`                             | Metrics service port                                                                                                                                                                                                              | `9117`                            |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                                                                                                                                   | `{}`                              |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                                                                                                                      | `true`                            |
| `metrics.serviceMonitor.namespace`         | The namespace in which the ServiceMonitor will be created                                                                                                                                                                         | `""`                              |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus                                                                                                                                                  | `""`                              |
| `metrics.serviceMonitor.interval`          | The interval at which metrics should be scraped                                                                                                                                                                                   | `30s`                             |
| `metrics.serviceMonitor.scrapeTimeout`     | The timeout after which the scrape is ended                                                                                                                                                                                       | `""`                              |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                         | `[]`                              |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                                                                                                                                                                    | `{}`                              |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                                                                                                                                               | `{}`                              |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                                                                                                                                                          | `false`                           |

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

The above parameters map to the env variables defined in [bitnami/mediawiki](https://github.com/bitnami/containers/tree/main/bitnami/mediawiki). For more information please refer to the [bitnami/mediawiki](https://github.com/bitnami/containers/tree/main/bitnami/mediawiki) image documentation.

> **Note**:
>
> For Mediawiki to function correctly, you should specify the `mediawikiHost` parameter to specify the FQDN (recommended) or the public IP address of the Mediawiki service.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set mediawikiUser=admin,mediawikiPassword=password,mariadb.mariadbRootPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/mediawiki
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the MediaWiki administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/mediawiki
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/mediawiki/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 20.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

Also, this major release bumps the MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 19.0.0

This major release bumps the MariaDB chart version to [16.x.x](https://github.com/bitnami/charts/pull/23054); no major issues are expected during the upgrade

### To 18.0.0

This major release bumps the MariaDB version to 11.2. No major issues are expected during the upgrade.

### To 17.0.0

This major release bumps the MariaDB version to 11.1. No major issues are expected during the upgrade.

### To 16.0.0

This major release bumps the MariaDB version to 11.0. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-11-to-mariadb-11-0/) for upgrading from MariaDB 10.11 to 11.0. No major issues are expected during the upgrade.

### To 15.0.0

This major release bumps the MariaDB version to 10.11. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-6-to-mariadb-10-11/) for upgrading from MariaDB 10.6 to 10.11. No major issues are expected during the upgrade.

### To 14.0.0

This major release bumps the MariaDB version to 10.6. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-105-to-mariadb-106/) for upgrading from MariaDB 10.5 to 10.6. No major issues are expected during the upgrade.

### To 13.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated. We recommend using `service.ports.http` instead.
- `service.httpsPort` was deprecated. We recommend using `service.ports.https` instead.
- `metrics.serviceMonitor.additionalLabels` was replaced by `metrics.serviceMonitor.labels`.
- `metrics.serviceMonitor.relabellings` was replaced by `metrics.serviceMonitor.metricRelabelings`, and new value `metrics.serviceMonitor.relabelings` was introduced, fixing an issue with the values mapping. Now, the ServiceMonitor settings are inline with the chart values.

Additionally updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-1000) for more information.

### To 12.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Mediawki deployment before upgrading (the following example assumes that the release name is `mediawiki`):

```console
export APP_HOST=$(kubectl get svc --namespace default mediawiki --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export APP_PASSWORD=$(kubectl get secret --namespace default mediawiki -o jsonpath="{.data.mediawiki-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default mediawiki-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default mediawiki-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
kubectl delete deployments.apps mediawiki
helm upgrade mediawiki oci://REGISTRY_NAME/REPOSITORY_NAME/mediawiki --set mediawikiHost=$APP_HOST,mediawikiPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 11.0.0

In this major there were two main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB dependency version

Please read the update notes carefully.

#### 1. Adaptation to Helm v2 EOL

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

##### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

##### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

##### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

#### 2. Updated MariaDB dependency version

In this major the MariaDB dependency version was also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-800) for more information.

To upgrade to `11.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and Mediawiki data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `mediawiki` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and Mediawiki data on your current release:

```console
export MEDIAWIKI_HOST=$(kubectl get svc --namespace default mediawiki --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export MEDIAWIKI_PASSWORD=$(kubectl get secret --namespace default mediawiki -o jsonpath="{.data.mediawiki-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default mediawiki-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default mediawiki-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=mediawiki -o jsonpath="{.items[0].metadata.name}")
```

Delete the Mediawiki deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter:

```console
  kubectl delete deployments.apps mediawiki

  kubectl delete statefulsets.apps mediawiki-mariadb --cascade=false
```

Now the upgrade works:

```console
helm upgrade mediawiki oci://REGISTRY_NAME/REPOSITORY_NAME/mediawiki --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set mediawikiPassword=$MEDIAWIKI_PASSWORD --set mediawikiHost=$MEDIAWIKI_HOST
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

  ```console
  kubectl delete pod mediawiki-mariadb-0
  ```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=mediawiki,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 10.0.0

The [Bitnami MediaWiki](https://github.com/bitnami/containers/tree/main/bitnami/mediawiki) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed.

To upgrade to `10.0.0`, backup MediaWiki data and the previous MariaDB databases, install a new MediaWiki chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

### To 9.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In <https://github.com/helm/charts/pull/17300> the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 4.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 4.0.0. The following example assumes that the release name is mediawiki:

```console
kubectl patch deployment mediawiki-mediawiki --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset mediawiki-mariadb --cascade=false
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