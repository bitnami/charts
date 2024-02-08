<!--- app-name: Osclass -->

# Bitnami package for Osclass

Osclass allows you to easily create a classifieds site without any technical knowledge. It provides support for presenting general ads or specialized ads, is customizable, extensible and multilingual.

[Overview of Osclass](https://osclass-classifieds.com)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/osclass
```

Looking to use Osclass in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps an [Osclass](https://github.com/bitnami/containers/tree/main/bitnami/osclass) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Osclass application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/osclass
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Osclass on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                | Description                                        | Value |
| ------------------- | -------------------------------------------------- | ----- |
| `kubeVersion`       | Override Kubernetes version                        | `""`  |
| `nameOverride`      | String to partially override common.names.fullname | `""`  |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`  |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`  |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`  |

### Osclass Image parameters

| Name                | Description                                                                                             | Value                     |
| ------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`    | Osclass image registry                                                                                  | `REGISTRY_NAME`           |
| `image.repository`  | Osclass image repository                                                                                | `REPOSITORY_NAME/osclass` |
| `image.digest`      | Osclass image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                      |
| `image.pullPolicy`  | Osclass image pull policy                                                                               | `IfNotPresent`            |
| `image.pullSecrets` | Osclass image pull secrets                                                                              | `[]`                      |
| `image.debug`       | Enable Bitnami debug mode in Osclass image                                                              | `false`                   |

### Osclass Configuration parameters

| Name                 | Description                                            | Value              |
| -------------------- | ------------------------------------------------------ | ------------------ |
| `osclassSkipInstall` | Skip wizard installation                               | `false`            |
| `osclassUsername`    | Osclass username                                       | `user`             |
| `osclassSiteTitle`   | Osclass site title                                     | `user`             |
| `osclassPassword`    | Osclass user password                                  | `""`               |
| `osclassEmail`       | Osclass user email                                     | `user@example.com` |
| `existingSecret`     | Name of existing secret containing Osclass credentials | `""`               |
| `allowEmptyPassword` | Allow the container to be started with blank passwords | `true`             |
| `smtpHost`           | SMTP server host                                       | `""`               |
| `smtpPort`           | SMTP server port                                       | `""`               |
| `smtpUser`           | SMTP username                                          | `""`               |
| `smtpPassword`       | SMTP user password                                     | `""`               |
| `smtpProtocol`       | SMTP protocol                                          | `""`               |

### Osclass deployment parameters

| Name                                                 | Description                                                                                                     | Value                                    |
| ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `automountServiceAccountToken`                       | Mount Service Account token in pod                                                                              | `false`                                  |
| `hostAliases`                                        | Osclass pod host aliases                                                                                        | `[]`                                     |
| `podSecurityContext.enabled`                         | Enabled Osclass pods' Security Context                                                                          | `true`                                   |
| `podSecurityContext.fsGroupChangePolicy`             | Set filesystem group change policy                                                                              | `Always`                                 |
| `podSecurityContext.sysctls`                         | Set kernel settings using the sysctl interface                                                                  | `[]`                                     |
| `podSecurityContext.supplementalGroups`              | Set filesystem extra groups                                                                                     | `[]`                                     |
| `podSecurityContext.fsGroup`                         | Set Osclass pod's Security Context fsGroup                                                                      | `1001`                                   |
| `containerSecurityContext.enabled`                   | Enabled containers' Security Context                                                                            | `true`                                   |
| `containerSecurityContext.seLinuxOptions`            | Set SELinux options in container                                                                                | `nil`                                    |
| `containerSecurityContext.runAsUser`                 | Set containers' Security Context runAsUser                                                                      | `1001`                                   |
| `containerSecurityContext.runAsNonRoot`              | Set container's Security Context runAsNonRoot                                                                   | `true`                                   |
| `containerSecurityContext.privileged`                | Set container's Security Context privileged                                                                     | `false`                                  |
| `containerSecurityContext.readOnlyRootFilesystem`    | Set container's Security Context readOnlyRootFilesystem                                                         | `false`                                  |
| `containerSecurityContext.allowPrivilegeEscalation`  | Set container's Security Context allowPrivilegeEscalation                                                       | `false`                                  |
| `containerSecurityContext.capabilities.drop`         | List of capabilities to be dropped                                                                              | `["ALL"]`                                |
| `containerSecurityContext.seccompProfile.type`       | Set container's Security Context seccomp profile                                                                | `RuntimeDefault`                         |
| `startupProbe.enabled`                               | Enable startupProbe                                                                                             | `false`                                  |
| `startupProbe.path`                                  | Path for the HTTP probe                                                                                         | `/oc-admin`                              |
| `startupProbe.initialDelaySeconds`                   | Initial delay seconds for startupProbe                                                                          | `600`                                    |
| `startupProbe.periodSeconds`                         | Period seconds for startupProbe                                                                                 | `10`                                     |
| `startupProbe.timeoutSeconds`                        | Timeout seconds for startupProbe                                                                                | `5`                                      |
| `startupProbe.failureThreshold`                      | Failure threshold for startupProbe                                                                              | `5`                                      |
| `startupProbe.successThreshold`                      | Success threshold for startupProbe                                                                              | `1`                                      |
| `livenessProbe.enabled`                              | Enable livenessProbe                                                                                            | `true`                                   |
| `livenessProbe.path`                                 | Path for the HTTP probe                                                                                         | `/oc-admin`                              |
| `livenessProbe.initialDelaySeconds`                  | Initial delay seconds for livenessProbe                                                                         | `600`                                    |
| `livenessProbe.periodSeconds`                        | Period seconds for livenessProbe                                                                                | `10`                                     |
| `livenessProbe.timeoutSeconds`                       | Timeout seconds for livenessProbe                                                                               | `5`                                      |
| `livenessProbe.failureThreshold`                     | Failure threshold for livenessProbe                                                                             | `5`                                      |
| `livenessProbe.successThreshold`                     | Success threshold for livenessProbe                                                                             | `1`                                      |
| `readinessProbe.enabled`                             | Enable readinessProbe                                                                                           | `true`                                   |
| `readinessProbe.path`                                | Path for the HTTP probe                                                                                         | `/oc-admin`                              |
| `readinessProbe.initialDelaySeconds`                 | Initial delay seconds for readinessProbe                                                                        | `30`                                     |
| `readinessProbe.periodSeconds`                       | Period seconds for readinessProbe                                                                               | `5`                                      |
| `readinessProbe.timeoutSeconds`                      | Timeout seconds for readinessProbe                                                                              | `1`                                      |
| `readinessProbe.failureThreshold`                    | Failure threshold for readinessProbe                                                                            | `5`                                      |
| `readinessProbe.successThreshold`                    | Success threshold for readinessProbe                                                                            | `1`                                      |
| `customStartupProbe`                                 | Custom livenessProbe that overrides the default one                                                             | `{}`                                     |
| `customLivenessProbe`                                | Custom livenessProbe that overrides the default one                                                             | `{}`                                     |
| `customReadinessProbe`                               | Custom readinessProbe that overrides the default one                                                            | `{}`                                     |
| `certificates.customCertificate.certificateSecret`   | name of the secret with custom certificates                                                                     | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | name of the secret with the chain                                                                               | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | key of the secret with the chain                                                                                | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location of the certificate inside the container                                                                | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location of the certificate key inside the container                                                            | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location of the certificate chain inside the container                                                          | `/etc/ssl/certs/mychain.pem`             |
| `certificates.customCAs`                             | Array with custom CAs                                                                                           | `[]`                                     |
| `certificates.command`                               | Override certificate container command                                                                          | `[]`                                     |
| `certificates.args`                                  | Override certificate container args                                                                             | `[]`                                     |
| `certificates.extraEnvVars`                          | An array to add extra env vars                                                                                  | `[]`                                     |
| `certificates.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                                      | `""`                                     |
| `certificates.extraEnvVarsSecret`                    | Secret with extra environment variables                                                                         | `""`                                     |
| `certificates.image.registry`                        | Apache Exporter image registry                                                                                  | `REGISTRY_NAME`                          |
| `certificates.image.repository`                      | Apache Exporter image repository                                                                                | `REPOSITORY_NAME/os-shell`               |
| `certificates.image.digest`                          | Apache Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                     |
| `certificates.image.pullPolicy`                      | Apache Exporter image pull policy                                                                               | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Apache Exporter image pull secrets                                                                              | `[]`                                     |
| `lifecycleHooks`                                     | lifecycleHooks for the container to automate configuration before or after startup.                             | `{}`                                     |
| `podAnnotations`                                     | Annotations for Osclass pods                                                                                    | `{}`                                     |
| `podLabels`                                          | Extra labels for Osclass pods                                                                                   | `{}`                                     |
| `replicaCount`                                       | Number of Osclass replicas to deploy                                                                            | `1`                                      |
| `containerPorts.http`                                | Osclass HTTP container port                                                                                     | `8080`                                   |
| `containerPorts.https`                               | Osclass HTTPS container port                                                                                    | `8443`                                   |
| `command`                                            | Override default container command (useful when using custom images)                                            | `[]`                                     |
| `args`                                               | Override default container args (useful when using custom images)                                               | `[]`                                     |
| `updateStrategy.type`                                | Osclass deployment strategy type                                                                                | `RollingUpdate`                          |
| `updateStrategy.rollingUpdate`                       | Osclass deployment rolling update configuration parameters                                                      | `{}`                                     |
| `extraEnvVars`                                       | Array with extra environment variables to add to the Osclass container                                          | `[]`                                     |
| `extraEnvVarsCM`                                     | Name of existing ConfigMap containing extra env vars                                                            | `""`                                     |
| `extraEnvVarsSecret`                                 | Name of existing Secret containing extra env vars                                                               | `""`                                     |
| `extraVolumes`                                       | Optionally specify extra list of additional volumes for Osclass pods                                            | `[]`                                     |
| `extraVolumeMounts`                                  | Optionally specify extra list of additional volumeMounts for Osclass container(s)                               | `[]`                                     |
| `initContainers`                                     | Add additional init containers to the Osclass pods                                                              | `[]`                                     |
| `sidecars`                                           | Add additional sidecar containers to the Osclass pod                                                            | `[]`                                     |
| `podAffinityPreset`                                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                             | `""`                                     |
| `podAntiAffinityPreset`                              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                        | `soft`                                   |
| `nodeAffinityPreset.type`                            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                       | `""`                                     |
| `nodeAffinityPreset.key`                             | Node label key to match. Ignored if `affinity` is set                                                           | `""`                                     |
| `nodeAffinityPreset.values`                          | Node label values to match. Ignored if `affinity` is set                                                        | `[]`                                     |
| `affinity`                                           | Affinity for pod assignment                                                                                     | `{}`                                     |
| `nodeSelector`                                       | Node labels for pod assignment                                                                                  | `{}`                                     |
| `resources.limits`                                   | The resources limits for the Osclass container                                                                  | `{}`                                     |
| `resources.requests`                                 | The requested resources for the Osclass container                                                               | `{}`                                     |
| `tolerations`                                        | Tolerations for pod assignment                                                                                  | `[]`                                     |
| `priorityClassName`                                  | Osclass pods' priorityClassName                                                                                 | `""`                                     |
| `schedulerName`                                      | Name of the k8s scheduler (other than default)                                                                  | `""`                                     |
| `topologySpreadConstraints`                          | Topology Spread Constraints for pod assignment                                                                  | `[]`                                     |
| `serviceAccount.create`                              | Enable creation of ServiceAccount for Osclass pod                                                               | `true`                                   |
| `serviceAccount.name`                                | The name of the ServiceAccount to use.                                                                          | `""`                                     |
| `serviceAccount.automountServiceAccountToken`        | Allows auto mount of ServiceAccountToken on the serviceAccount created                                          | `false`                                  |
| `serviceAccount.annotations`                         | Additional custom annotations for the ServiceAccount                                                            | `{}`                                     |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Osclass service type                                                                                                             | `LoadBalancer`           |
| `service.ports.http`               | Osclass service HTTP port                                                                                                        | `80`                     |
| `service.ports.https`              | Osclass service HTTPS port                                                                                                       | `443`                    |
| `service.clusterIP`                | Osclass service Cluster IP                                                                                                       | `""`                     |
| `service.loadBalancerIP`           | Osclass service Load Balancer IP                                                                                                 | `""`                     |
| `service.loadBalancerSourceRanges` | Osclass service Load Balancer sources                                                                                            | `[]`                     |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`              | Additional custom annotations for Osclass service                                                                                | `{}`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                     |
| `service.externalTrafficPolicy`    | Osclass service external traffic policy                                                                                          | `Cluster`                |
| `ingress.enabled`                  | Enable ingress record generation for Osclass                                                                                     | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `osclass.local`          |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Database Parameters

| Name                                       | Description                                                                                                        | Value                      |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ | -------------------------- |
| `externalDatabase.host`                    | External Database server host                                                                                      | `""`                       |
| `externalDatabase.port`                    | External Database server port                                                                                      | `3306`                     |
| `externalDatabase.user`                    | External Database username                                                                                         | `bn_osclass`               |
| `externalDatabase.password`                | External Database user password                                                                                    | `""`                       |
| `externalDatabase.database`                | External Database database name                                                                                    | `bitnami_osclass`          |
| `externalDatabase.existingSecret`          | Name of an existing secret resource containing the DB password                                                     | `""`                       |
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements                                          | `true`                     |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`                                                | `standalone`               |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                                                              | `""`                       |
| `mariadb.auth.database`                    | MariaDB custom database                                                                                            | `bitnami_osclass`          |
| `mariadb.auth.username`                    | MariaDB custom user name                                                                                           | `bn_osclass`               |
| `mariadb.auth.password`                    | MariaDB custom user password                                                                                       | `""`                       |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                                                         | `true`                     |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                                                                    | `""`                       |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                                                                     | `[]`                       |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                                                             | `8Gi`                      |
| `persistence.enabled`                      | Enable persistence using Persistent Volume Claims                                                                  | `true`                     |
| `persistence.storageClass`                 | Persistent Volume storage class                                                                                    | `""`                       |
| `persistence.accessModes`                  | Persistent Volume access modes                                                                                     | `[]`                       |
| `persistence.size`                         | Persistent Volume size                                                                                             | `8Gi`                      |
| `persistence.existingClaim`                | The name of an existing PVC to use for persistence                                                                 | `""`                       |
| `persistence.hostPath`                     | If defined, the osclass-data volume will mount to the specified hostPath.                                          | `""`                       |
| `persistence.annotations`                  | Persistent Volume Claim annotations                                                                                | `{}`                       |
| `volumePermissions.enabled`                | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                    | `false`                    |
| `volumePermissions.image.registry`         | OS Shell + Utility image registry                                                                                  | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`       | OS Shell + Utility image repository                                                                                | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`           | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                       |
| `volumePermissions.image.pullPolicy`       | OS Shell + Utility image pull policy                                                                               | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`      | OS Shell + Utility image pull secrets                                                                              | `[]`                       |
| `volumePermissions.resources.limits`       | The resources limits for the init container                                                                        | `{}`                       |
| `volumePermissions.resources.requests`     | The requested resources for the init container                                                                     | `{}`                       |

### Other Parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable a Pod Disruption Budget creation                        | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for Osclass                  | `false` |
| `autoscaling.minReplicas`  | Minimum number of Osclass replicas                             | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Osclass replicas                             | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `50`    |

### Metrics Parameters

| Name                                       | Description                                                                                                     | Value                             |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                          | Start a sidecar prometheus exporter to expose metrics                                                           | `false`                           |
| `metrics.image.registry`                   | Apache Exporter image registry                                                                                  | `REGISTRY_NAME`                   |
| `metrics.image.repository`                 | Apache Exporter image repository                                                                                | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`                     | Apache Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                              |
| `metrics.image.pullPolicy`                 | Apache Exporter image pull policy                                                                               | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                | Apache Exporter image pull secrets                                                                              | `[]`                              |
| `metrics.resources.limits`                 | The resources limits for the Prometheus exporter container                                                      | `{}`                              |
| `metrics.resources.requests`               | The requested resources for the Prometheus exporter container                                                   | `{}`                              |
| `metrics.podAnnotations`                   | Annotations to add                                                                                              | `{}`                              |
| `metrics.service.type`                     | Metrics service type                                                                                            | `ClusterIP`                       |
| `metrics.service.port`                     | Metrics service port                                                                                            | `9117`                            |
| `metrics.service.annotations`              | Additional custom annotations for Metrics service                                                               | `{}`                              |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                    | `false`                           |
| `metrics.serviceMonitor.namespace`         | The namespace in which the ServiceMonitor will be created                                                       | `""`                              |
| `metrics.serviceMonitor.interval`          | The interval at which metrics should be scraped                                                                 | `30s`                             |
| `metrics.serviceMonitor.scrapeTimeout`     | The timeout after which the scrape is ended                                                                     | `""`                              |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                              | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                       | `[]`                              |
| `metrics.serviceMonitor.honorLabels`       | Labels to honor to add to the scrape endpoint                                                                   | `false`                           |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                                                  | `{}`                              |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                             | `{}`                              |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                               | `""`                              |

### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                 | Value   |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                     | `false` |
| `networkPolicy.metrics.enabled`                               | Enable network policy for metrics (prometheus)                                                                              | `false` |
| `networkPolicy.metrics.namespaceSelector`                     | Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                      | `{}`    |
| `networkPolicy.metrics.podSelector`                           | Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                  | `{}`    |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                   | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.               | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                           | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by Osclass's pods.                                     | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                            | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes Osclass only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access Osclass. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access Osclass. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                          | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                              | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                  | `{}`    |

The above parameters map to the env variables defined in [bitnami/osclass](https://github.com/bitnami/containers/tree/main/bitnami/osclass). For more information please refer to the [bitnami/osclass](https://github.com/bitnami/containers/tree/main/bitnami/osclass) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set osclassUsername=admin,osclassPassword=password,mariadb.auth.rootPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/osclass
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Osclass administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/osclass
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/osclass/values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami Osclass](https://github.com/bitnami/containers/tree/main/bitnami/osclass) image stores the Osclass data and configurations at the `/bitnami/osclass` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube. See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Osclass app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### TLS secrets

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

### To 13.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated. We recommend using `service.ports.http` instead.
- `service.httpsPort` was deprecated. We recommend using `service.ports.https` instead.
- `metrics.serviceMonitor.additionalLabels` renamed as `metrics.serviceMonitor.labels`.

Additionally updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-1000) for more information.

### To 10.0.0

The [Bitnami Osclass](https://github.com/bitnami/containers/tree/main/bitnami/osclass) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed.

To upgrade to `9.0.0`, backup Osclass data and the previous MariaDB databases, install a new Osclass chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

In addition to this, the image was refactored and now the source code is published in GitHub in the `rootfs` folder of the container image.

This upgrade also adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information.

### To 9.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Osclass deployment before upgrading (the following example assumes that the release name is `osclass`):

```console
export APP_HOST=$(kubectl get svc --namespace default osclass --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export APP_PASSWORD=$(kubectl get secret --namespace default osclass -o jsonpath="{.data.osclass-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default osclass-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default osclass-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
kubectl delete deployments.apps osclass
helm upgrade osclass oci://REGISTRY_NAME/REPOSITORY_NAME/osclass --set osclassHost=$APP_HOST,osclassPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 8.0.0

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

To upgrade to `8.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and Osclass data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `osclass` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and Osclass data on your current release:

```console
export OSCLASS_HOST=$(kubectl get svc --namespace default osclass --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export OSCLASS_PASSWORD=$(kubectl get secret --namespace default osclass -o jsonpath="{.data.osclass-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default osclass-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default osclass-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=osclass -o jsonpath="{.items[0].metadata.name}")
```

Delete the Osclass deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter:

```console
  kubectl delete deployments.apps osclass

  kubectl delete statefulsets.apps osclass-mariadb --cascade=false
```

Now the upgrade works:

```console
helm upgrade osclass oci://REGISTRY_NAME/REPOSITORY_NAME/osclass --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set osclassPassword=$OSCLASS_PASSWORD --set osclassHost=$OSCLASS_HOST
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

  ```console
  kubectl delete pod osclass-mariadb-0
  ```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=osclass,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In <https://github.com/helm/charts/pull/17303> the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is osclass:

```console
kubectl patch deployment osclass-osclass --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset osclass-mariadb --cascade=false
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