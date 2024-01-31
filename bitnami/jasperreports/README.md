<!--- app-name: JasperReports -->

# Bitnami package for JasperReports

JasperReports Server is a stand-alone and embeddable reporting server. It is a central information hub, with reporting and analytics that can be embedded into web and mobile applications.

[Overview of JasperReports](http://community.jaspersoft.com/project/jasperreports-server)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/jasperreports
```

Looking to use JasperReports in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [JasperReports](https://github.com/bitnami/containers/tree/main/bitnami/jasperreports) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which bootstraps a MariaDB deployment required by the JasperReports application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/jasperreports
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys JasperReports on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                | Description                                                          | Value           |
| ------------------- | -------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `""`            |
| `nameOverride`      | String to partially override common.names.fullname                   | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname                       | `""`            |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`            |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]`            |

### JasperReports parameters

| Name                          | Description                                                                                                   | Value                           |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `image.registry`              | JasperReports image registry                                                                                  | `REGISTRY_NAME`                 |
| `image.repository`            | JasperReports image repository                                                                                | `REPOSITORY_NAME/jasperreports` |
| `image.digest`                | JasperReports image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                            |
| `image.pullPolicy`            | JasperReports image pull policy                                                                               | `IfNotPresent`                  |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                                                              | `[]`                            |
| `jasperreportsUsername`       | JasperReports user                                                                                            | `jasperadmin`                   |
| `jasperreportsExistingSecret` | Name of existing secret containing the key `jasperreports-password`                                           | `""`                            |
| `jasperreportsPassword`       | JasperReports password (Ignored if `jasperreportsExistingSecret` is provided)                                 | `""`                            |
| `jasperreportsEmail`          | JasperReports user email                                                                                      | `user@example.com`              |
| `allowEmptyPassword`          | Set to `yes` to allow the container to be started with blank passwords                                        | `no`                            |
| `smtpHost`                    | SMTP host                                                                                                     | `""`                            |
| `smtpPort`                    | SMTP port                                                                                                     | `""`                            |
| `smtpEmail`                   | SMTP email                                                                                                    | `""`                            |
| `smtpUser`                    | SMTP user                                                                                                     | `""`                            |
| `smtpExistingSecret`          | Name of existing secret containing the key `smtp-password`                                                    | `""`                            |
| `smtpPassword`                | SMTP password (Ignored if `smtpExistingSecret` is provided)                                                   | `""`                            |
| `smtpProtocol`                | SMTP protocol [`ssl`, `none`]                                                                                 | `""`                            |
| `command`                     | Override default container command (useful when using custom images)                                          | `[]`                            |
| `args`                        | Override default container args (useful when using custom images)                                             | `[]`                            |
| `extraEnvVars`                | Extra environment variables to be set on Jasperreports container                                              | `[]`                            |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                                                          | `""`                            |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                                                             | `""`                            |
| `updateStrategy.type`         | StrategyType                                                                                                  | `RollingUpdate`                 |

### Jasperreports deployment parameters

| Name                                                | Description                                                                               | Value                      |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------- | -------------------------- |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                        | `false`                    |
| `hostAliases`                                       | Add deployment host aliases                                                               | `[]`                       |
| `containerPorts.http`                               | HTTP port to expose at container level                                                    | `8080`                     |
| `dnsConfig`                                         | Pod DNS configuration.                                                                    | `{}`                       |
| `podSecurityContext.enabled`                        | Enable pod's Security Context                                                             | `true`                     |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                        | `Always`                   |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                            | `[]`                       |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                               | `[]`                       |
| `podSecurityContext.fsGroup`                        | Set pod's Security Context fsGroup                                                        | `1001`                     |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                      | `true`                     |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                          | `nil`                      |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                | `1001`                     |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                             | `true`                     |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                               | `false`                    |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                   | `false`                    |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                 | `false`                    |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                        | `["ALL"]`                  |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                          | `RuntimeDefault`           |
| `resources.limits`                                  | The resources limits for the Jasperreports container                                      | `{}`                       |
| `resources.requests`                                | The requested resources for the Jasperreports container                                   | `{}`                       |
| `startupProbe.enabled`                              | Enable startupProbe                                                                       | `false`                    |
| `startupProbe.path`                                 | Request path for startupProbe                                                             | `/jasperserver/login.html` |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                    | `450`                      |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                           | `10`                       |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                          | `5`                        |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                        | `6`                        |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                        | `1`                        |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                      | `true`                     |
| `livenessProbe.path`                                | Request path for livenessProbe                                                            | `/jasperserver/login.html` |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                   | `450`                      |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                          | `10`                       |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                         | `5`                        |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                       | `6`                        |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                       | `1`                        |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                     | `true`                     |
| `readinessProbe.path`                               | Request path for readinessProbe                                                           | `/jasperserver/login.html` |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                  | `30`                       |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                         | `10`                       |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                        | `5`                        |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                      | `6`                        |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                      | `1`                        |
| `customStartupProbe`                                | Override default startup probe                                                            | `{}`                       |
| `customLivenessProbe`                               | Override default liveness probe                                                           | `{}`                       |
| `customReadinessProbe`                              | Override default readiness probe                                                          | `{}`                       |
| `podLabels`                                         | Extra labels for Jasperreports pods                                                       | `{}`                       |
| `podAnnotations`                                    | Annotations for Jasperreports pods                                                        | `{}`                       |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                       |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                     |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                       |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set.                                    | `""`                       |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                       |
| `affinity`                                          | Affinity for pod assignment                                                               | `{}`                       |
| `nodeSelector`                                      | Node labels for pod assignment                                                            | `{}`                       |
| `tolerations`                                       | Tolerations for pod assignment                                                            | `[]`                       |
| `priorityClassName`                                 | JasperReports pods' priorityClassName                                                     | `""`                       |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                            | `""`                       |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                            | `[]`                       |
| `lifecycleHooks`                                    | LifecycleHooks to set additional configuration at startup.                                | `{}`                       |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Jasperreports pods                | `[]`                       |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Jasperreports container(s)   | `[]`                       |
| `initContainers`                                    | Add additional init containers to the Jasperreports pods                                  | `[]`                       |
| `sidecars`                                          | Add additional sidecar containers to the Jasperreports pods                               | `[]`                       |
| `persistence.enabled`                               | Enable persistence using PVC                                                              | `true`                     |
| `persistence.storageClass`                          | PVC Storage Class for Jasperreports volume                                                | `""`                       |
| `persistence.accessModes`                           | Persistent Volume Access Mode                                                             | `["ReadWriteOnce"]`        |
| `persistence.size`                                  | PVC Storage Request for Jasperreports volume                                              | `8Gi`                      |
| `persistence.existingClaim`                         | An Existing PVC name for Jasperreports volume                                             | `""`                       |
| `persistence.annotations`                           | Persistent Volume Claim annotations                                                       | `{}`                       |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for JasperReports pod                                   | `true`                     |
| `serviceAccount.name`                               | The name of the ServiceAccount to use.                                                    | `""`                       |
| `serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                    | `false`                    |
| `serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                      | `{}`                       |

### Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                                                          | `LoadBalancer`           |
| `service.ports.http`               | Service HTTP port                                                                                                                | `80`                     |
| `service.nodePorts.http`           | Kubernetes http node port                                                                                                        | `""`                     |
| `service.clusterIP`                | Jarperreports service Cluster IP                                                                                                 | `""`                     |
| `service.loadBalancerIP`           | Kubernetes LoadBalancerIP to request                                                                                             | `""`                     |
| `service.loadBalancerSourceRanges` | Jasperreports service Load Balancer sources                                                                                      | `[]`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`              | Annotations for Jasperreports service                                                                                            | `{}`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `jasperreports.local`    |
| `ingress.path`                     | Ingress path                                                                                                                     | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Database parameters

| Name                                        | Description                                                               | Value                   |
| ------------------------------------------- | ------------------------------------------------------------------------- | ----------------------- |
| `mariadb.enabled`                           | Whether to use the MariaDB chart                                          | `true`                  |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                      | `standalone`            |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                      | `""`                    |
| `mariadb.auth.database`                     | Database name to create                                                   | `bitnami_jasperreports` |
| `mariadb.auth.username`                     | Database user to create                                                   | `bn_jasperreports`      |
| `mariadb.auth.password`                     | Password for the database                                                 | `""`                    |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                     | `true`                  |
| `mariadb.primary.persistence.storageClass`  | PVC Storage Class                                                         | `""`                    |
| `mariadb.primary.persistence.accessModes`   | Access mode of persistent volume                                          | `["ReadWriteOnce"]`     |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                           | `8Gi`                   |
| `mariadb.primary.persistence.hostPath`      | Host mount path for MariaDB volume                                        | `""`                    |
| `mariadb.primary.persistence.existingClaim` | Enable persistence using an existing PVC                                  | `""`                    |
| `externalDatabase.existingSecret`           | Name of the database existing Secret Object                               | `""`                    |
| `externalDatabase.host`                     | Host of the existing database                                             | `""`                    |
| `externalDatabase.port`                     | Port of the existing database                                             | `3306`                  |
| `externalDatabase.user`                     | Existing username in the external db                                      | `bn_jasperreports`      |
| `externalDatabase.password`                 | Password for the above username                                           | `""`                    |
| `externalDatabase.database`                 | Name of the existing database                                             | `bitnami_jasperreports` |
| `externalDatabase.type`                     | Type of the existing database, allowed values: mariadb, mysql, postgresql | `mariadb`               |

### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                       | Value   |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                           | `false` |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                         | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.                     | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                                 | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by Jasperreports' pods.                                      | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                                  | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes Jasperreports only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access Jasperreports. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access Jasperreports. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                                | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                                    | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                        | `{}`    |

The above parameters map to the env variables defined in [bitnami/jasperreports](https://github.com/bitnami/containers/tree/main/bitnami/jasperreports). For more information please refer to the [bitnami/jasperreports](https://github.com/bitnami/containers/tree/main/bitnami/jasperreports) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set jasperreportsUsername=admin,jasperreportsPassword=password,mariadb.auth.rootPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/jasperreports
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the JasperReports administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/jasperreports
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/jasperreports/values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami JasperReports](https://github.com/bitnami/containers/tree/main/bitnami/jasperreports) image stores the JasperReports data and configurations at the `/bitnami/jasperreports` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the JasperReports app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

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

### To 12.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated, we recommend using `service.ports.http` instead.
- `service.nodePort` was deprecated, we recommend using `service.nodePorts.http` instead .
- `containerPort` was deprecated, we recommend using `containerPorts.http` instead.

Additionally updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-1000) for more information.

### To 11.0.0

The [Bitnami JasperReports](https://github.com/bitnami/containers/tree/main/bitnami/jasperreports) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Tomcat daemon was started as the `tomcat` user. From now on, both the container and the Tomcat daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed.

To upgrade to `11.0.0`, backup JasperReports data and the previous MariaDB databases, install a new JasperReports chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

In addition to this, the image was refactored and now the source code is published in GitHub in the `rootfs` folder of the container image.

We also fixed a regression with readiness and liveness probes. Now the kind of probe cannot be configured under the *readinessProbe/livenessProbe* sections but in the *customReadinessProbe/customLivenessProbe* sections.

### To 10.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- Ingress configuration was also adapted to follow the Helm charts best practices.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing JasperReports deployment before upgrading (the following example assumes that the release name is `jasperreports`):

```console
export JASPER_PASSWORD=$(kubectl get secret --namespace default jasperreports -o jsonpath="{.data.jasperreports-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default jasperreports-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default jasperreports-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
kubectl delete deployments.apps jasperreports
helm upgrade jasperreports oci://REGISTRY_NAME/REPOSITORY_NAME/jasperreports --set jasperreportsPassword=$JASPER_PASSWORD,mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 9.0.0

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

- <https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

#### 2. Updated MariaDB dependency version

In this major the MariaDB dependency version was also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-800) for more information.

To upgrade to `9.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and JasperReports data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `jasperreports` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and JasperReports data on your current release:

```console
export JASPERREPORTS_PASSWORD=$(kubectl get secret --namespace default jasperreports -o jsonpath="{.data.jasperreports-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default jasperreports-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default jasperreports-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=jasperreports -o jsonpath="{.items[0].metadata.name}")
```

Delete the JasperReports deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter:

```console
  kubectl delete deployments.apps jasperreports

  kubectl delete statefulsets.apps jasperreports-mariadb --cascade=false
```

Now the upgrade works:

```console
helm upgrade jasperreports oci://REGISTRY_NAME/REPOSITORY_NAME/jasperreports --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set jasperreportsPassword=$JASPERREPORTS_PASSWORD --set allowEmptyPasswords=false
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

  ```console
  kubectl delete pod jasperreports-mariadb-0
  ```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=jasperreports,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 8.0.0

JasperReports 7.5.0 includes some new configuration options that are required to be added if you upgrade from previous versions. Please check the [official community guide](https://community.jaspersoft.com/documentation/tibco-jasperreports-server-upgrade-guide/v750/upgrading-72-75) to upgrade your previous JasperReports installation.

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In <https://github.com/helm/charts/pull/17298> the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is jasperreports:

```console
kubectl patch deployment jasperreports-jasperreports --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset jasperreports-mariadb --cascade=false
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
