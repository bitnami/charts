<!-- app-name: Laravel -->

# Laravel packaged by Bitnami

Laravel is an open source PHP framework for web application development.

[Overview of Laravel](https://laravel.com/)

                           
## TL;DR

```console
$ helm repo add my-repo https://charts.bitnami.com/bitnami
$ helm install my-release my-repo/laravel
```

## Introduction

This chart bootstraps a [Laravel](https://github.com/bitnami/containers/tree/main/bitnami/laravel) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Laravel application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release my-repo/laravel
```

The command deploys Laravel on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                                  | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`           | Labels to add to all deployed resources                                                      | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed resources                                                 | `{}`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                         | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                            | `["infinity"]`  |


### Laravel Image parameters

| Name                                                | Description                                                                                                              | Value                |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | -------------------- |
| `image.registry`                                    | Laravel image registry                                                                                                   | `docker.io`          |
| `image.repository`                                  | Laravel image repository                                                                                                 | `bitnami/laravel`    |
| `image.tag`                                         | Laravel image tag (immutable tags are recommended)                                                                       | `9.3.9-debian-11-r1` |
| `image.digest`                                      | Laravel image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                  | `""`                 |
| `image.pullPolicy`                                  | Laravel image pull policy                                                                                                | `IfNotPresent`       |
| `image.pullSecrets`                                 | Laravel image pull secrets                                                                                               | `[]`                 |
| `image.debug`                                       | Specify if debug values should be set                                                                                    | `false`              |
| `allowEmptyPassword`                                | Allow the container to be started with blank passwords                                                                   | `false`              |
| `command`                                           | Override default container command (useful when using custom images)                                                     | `[]`                 |
| `args`                                              | Override default container args (useful when using custom images)                                                        | `[]`                 |
| `extraEnvVars`                                      | Array with extra environment variables to add to the Laravel container                                                   | `[]`                 |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                     | `""`                 |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                        | `""`                 |
| `replicaCount`                                      | Number of Laravel replicas to deploy                                                                                     | `1`                  |
| `updateStrategy.type`                               | Laravel deployment strategy type                                                                                         | `RollingUpdate`      |
| `updateStrategy.rollingUpdate`                      | Laravel deployment rolling update configuration parameters                                                               | `{}`                 |
| `schedulerName`                                     | Alternate scheduler                                                                                                      | `""`                 |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                 |
| `priorityClassName`                                 | Name of the existing priority class to be used by Laravel pods, priority class needs to be created beforehand            | `""`                 |
| `hostAliases`                                       | Laravel pod host aliases                                                                                                 | `[]`                 |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Laravel pods                                                     | `[]`                 |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Laravel container(s)                                        | `[]`                 |
| `sidecars`                                          | Add additional sidecar containers to the Laravel pod                                                                     | `[]`                 |
| `initContainers`                                    | Add additional init containers to the Laravel pods                                                                       | `[]`                 |
| `podLabels`                                         | Extra labels for Laravel pods                                                                                            | `{}`                 |
| `podAnnotations`                                    | Annotations for Laravel pods                                                                                             | `{}`                 |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`                 |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`               |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                 |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                    | `""`                 |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`                 |
| `affinity`                                          | Affinity for pod assignment                                                                                              | `{}`                 |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                           | `{}`                 |
| `tolerations`                                       | Tolerations for pod assignment                                                                                           | `[]`                 |
| `resources.limits`                                  | The resources limits for the Laravel containers                                                                          | `{}`                 |
| `resources.requests.memory`                         | The requested memory for the Laravel containers                                                                          | `128Mi`              |
| `resources.requests.cpu`                            | The requested cpu for the Laravel containers                                                                             | `100m`               |
| `containerPorts.http`                               | Laravel HTTP container port                                                                                              | `8000`               |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Laravel container(s)                                               | `[]`                 |
| `podSecurityContext.enabled`                        | Enabled Laravel pods' Security Context                                                                                   | `true`               |
| `podSecurityContext.fsGroup`                        | Set Laravel pod's Security Context fsGroup                                                                               | `1000`               |
| `podSecurityContext.seccompProfile.type`            | Set Laravel container's Security Context seccomp profile                                                                 | `RuntimeDefault`     |
| `containerSecurityContext.enabled`                  | Enabled Laravel containers' Security Context                                                                             | `true`               |
| `containerSecurityContext.runAsUser`                | Set Laravel container's Security Context runAsUser                                                                       | `1000`               |
| `containerSecurityContext.runAsNonRoot`             | Set Laravel container's Security Context runAsNonRoot                                                                    | `true`               |
| `containerSecurityContext.allowPrivilegeEscalation` | Set WorLaraveldPress container's privilege escalation                                                                    | `false`              |
| `containerSecurityContext.capabilities.drop`        | Set Laravel container's Security Context runAsNonRoot                                                                    | `["ALL"]`            |
| `livenessProbe.enabled`                             | Enable livenessProbe on Laravel containers                                                                               | `true`               |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `120`                |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`                 |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `5`                  |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `6`                  |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`                  |
| `readinessProbe.enabled`                            | Enable readinessProbe on Laravel containers                                                                              | `true`               |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `30`                 |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`                 |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `5`                  |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `6`                  |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`                  |
| `startupProbe.enabled`                              | Enable startupProbe on Laravel containers                                                                                | `false`              |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `30`                 |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `10`                 |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `5`                  |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `6`                  |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`                  |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`                 |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`                 |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`                 |
| `lifecycleHooks`                                    | for the Laravel container(s) to automate configuration before or after startup                                           | `{}`                 |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Laravel service type                                                                                                             | `LoadBalancer`           |
| `service.ports.http`               | Laravel service HTTP port                                                                                                        | `8000`                   |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Laravel service Cluster IP                                                                                                       | `""`                     |
| `service.loadBalancerIP`           | Laravel service Load Balancer IP                                                                                                 | `""`                     |
| `service.loadBalancerSourceRanges` | Laravel service Load Balancer sources                                                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | Laravel service external traffic policy                                                                                          | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Laravel service                                                                                | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Laravel service                                                                                          | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Laravel                                                                                     | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `laravel.local`          |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |


### Persistence Parameters

| Name                                                   | Description                                                                                                   | Value                   |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `persistence.enabled`                                  | Enable persistence using Persistent Volume Claims                                                             | `true`                  |
| `persistence.storageClass`                             | Persistent Volume storage class                                                                               | `""`                    |
| `persistence.accessModes`                              | Persistent Volume access modes                                                                                | `[]`                    |
| `persistence.size`                                     | Persistent Volume size                                                                                        | `10Gi`                  |
| `persistence.dataSource`                               | Custom PVC data source                                                                                        | `{}`                    |
| `persistence.existingClaim`                            | The name of an existing PVC to use for persistence                                                            | `""`                    |
| `persistence.selector`                                 | Selector to match an existing Persistent Volume for Laravel data PVC                                          | `{}`                    |
| `persistence.annotations`                              | Persistent Volume Claim annotations                                                                           | `{}`                    |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`               | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                                  | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                                | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                                      | `11-debian-11-r45`      |
| `volumePermissions.image.digest`                       | Bitnami Shell image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                               | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                              | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                                   | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                                | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | User ID for the init container                                                                                | `0`                     |


### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Laravel pod                      | `false` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `true`  |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |
| `pdb.create`                                  | Enable a Pod Disruption Budget creation                                | `false` |
| `pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled         | `1`     |
| `pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable         | `""`    |
| `autoscaling.enabled`                         | Enable Horizontal POD autoscaling for Laravel                          | `false` |
| `autoscaling.minReplicas`                     | Minimum number of Laravel replicas                                     | `1`     |
| `autoscaling.maxReplicas`                     | Maximum number of Laravel replicas                                     | `11`    |
| `autoscaling.targetCPU`                       | Target CPU utilization percentage                                      | `50`    |
| `autoscaling.targetMemory`                    | Target Memory utilization percentage                                   | `50`    |


### Metrics Parameters

| Name                                         | Description                                                                                                     | Value                     |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `metrics.enabled`                            | Start a sidecar prometheus exporter to expose metrics                                                           | `false`                   |
| `metrics.image.registry`                     | Apache exporter image registry                                                                                  | `docker.io`               |
| `metrics.image.repository`                   | Apache exporter image repository                                                                                | `bitnami/apache-exporter` |
| `metrics.image.tag`                          | Apache exporter image tag (immutable tags are recommended)                                                      | `0.11.0-debian-11-r55`    |
| `metrics.image.digest`                       | Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                      |
| `metrics.image.pullPolicy`                   | Apache exporter image pull policy                                                                               | `IfNotPresent`            |
| `metrics.image.pullSecrets`                  | Apache exporter image pull secrets                                                                              | `[]`                      |
| `metrics.containerPorts.metrics`             | Prometheus exporter container port                                                                              | `9117`                    |
| `metrics.livenessProbe.enabled`              | Enable livenessProbe on Prometheus exporter containers                                                          | `true`                    |
| `metrics.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                         | `15`                      |
| `metrics.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                | `10`                      |
| `metrics.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                               | `5`                       |
| `metrics.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                             | `3`                       |
| `metrics.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                             | `1`                       |
| `metrics.readinessProbe.enabled`             | Enable readinessProbe on Prometheus exporter containers                                                         | `true`                    |
| `metrics.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                        | `5`                       |
| `metrics.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                               | `10`                      |
| `metrics.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                              | `3`                       |
| `metrics.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                            | `3`                       |
| `metrics.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                            | `1`                       |
| `metrics.startupProbe.enabled`               | Enable startupProbe on Prometheus exporter containers                                                           | `false`                   |
| `metrics.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                          | `10`                      |
| `metrics.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                 | `10`                      |
| `metrics.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                | `1`                       |
| `metrics.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                              | `15`                      |
| `metrics.startupProbe.successThreshold`      | Success threshold for startupProbe                                                                              | `1`                       |
| `metrics.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                             | `{}`                      |
| `metrics.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                            | `{}`                      |
| `metrics.customStartupProbe`                 | Custom startupProbe that overrides the default one                                                              | `{}`                      |
| `metrics.resources.limits`                   | The resources limits for the Prometheus exporter container                                                      | `{}`                      |
| `metrics.resources.requests`                 | The requested resources for the Prometheus exporter container                                                   | `{}`                      |
| `metrics.service.ports.metrics`              | Prometheus metrics service port                                                                                 | `9150`                    |
| `metrics.service.annotations`                | Additional custom annotations for Metrics service                                                               | `{}`                      |
| `metrics.serviceMonitor.enabled`             | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator                                   | `false`                   |
| `metrics.serviceMonitor.namespace`           | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)                                   | `""`                      |
| `metrics.serviceMonitor.interval`            | Interval at which metrics should be scraped.                                                                    | `""`                      |
| `metrics.serviceMonitor.scrapeTimeout`       | Timeout after which the scrape is ended                                                                         | `""`                      |
| `metrics.serviceMonitor.labels`              | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                           | `{}`                      |
| `metrics.serviceMonitor.selector`            | Prometheus instance selector labels                                                                             | `{}`                      |
| `metrics.serviceMonitor.relabelings`         | RelabelConfigs to apply to samples before scraping                                                              | `[]`                      |
| `metrics.serviceMonitor.metricRelabelings`   | MetricRelabelConfigs to apply to samples before ingestion                                                       | `[]`                      |
| `metrics.serviceMonitor.honorLabels`         | Specify honorLabels parameter to add the scrape endpoint                                                        | `false`                   |
| `metrics.serviceMonitor.jobLabel`            | The name of the label on the target service to use as the job name in prometheus.                               | `""`                      |


### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                  | Value   |
| ------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                      | `false` |
| `networkPolicy.metrics.enabled`                               | Enable network policy for metrics (prometheus)                                                                               | `false` |
| `networkPolicy.metrics.namespaceSelector`                     | Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                       | `{}`    |
| `networkPolicy.metrics.podSelector`                           | Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                   | `{}`    |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                    | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.                | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                            | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by testlink's pods.                                     | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                             | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes testlink only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access testlink. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access testlink. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                           | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                               | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                   | `{}`    |


### Database Parameters

| Name                                       | Description                                                                       | Value             |
| ------------------------------------------ | --------------------------------------------------------------------------------- | ----------------- |
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements         | `true`            |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`               | `standalone`      |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                             | `""`              |
| `mariadb.auth.database`                    | MariaDB custom database                                                           | `bitnami_laravel` |
| `mariadb.auth.username`                    | MariaDB custom user name                                                          | `bn_laravel`      |
| `mariadb.auth.password`                    | MariaDB custom user password                                                      | `""`              |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                        | `true`            |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                                   | `""`              |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                                    | `[]`              |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                            | `8Gi`             |
| `externalDatabase.host`                    | External Database server host                                                     | `localhost`       |
| `externalDatabase.port`                    | External Database server port                                                     | `3306`            |
| `externalDatabase.user`                    | External Database username                                                        | `bn_laravel`      |
| `externalDatabase.password`                | External Database user password                                                   | `""`              |
| `externalDatabase.database`                | External Database database name                                                   | `bitnami_laravel` |
| `externalDatabase.existingSecret`          | The name of an existing secret with database credentials. Evaluated as a template | `""`              |


The above parameters map to the env variables defined in [bitnami/laravel](https://github.com/bitnami/containers/tree/main/bitnami/laravel). For more information please refer to the [bitnami/laravel](https://github.com/bitnami/containers/tree/main/bitnami/laravel) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set mariadb.auth.password=myapppassword \
  --set mariadb.auth.rootPassword=secretpassword \
    my-repo/laravel
```

The above command installs a Laravel application container and prepares MariaDB database with the username and password to `bn_laravel` and `myapppassword` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml my-repo/laravel
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Known limitations

None so far

### External database support

You may want to have Laravel connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Refer to the [documentation on using an external database with Wordpress](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/use-external-database/) and the [tutorial on integrating WordPress with a managed cloud database](https://docs.bitnami.com/tutorials/secure-wordpress-kubernetes-managed-database-ssl-upgrades/) for more information.

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as nginx-ingress or traefik, that Ingress controller can be used to serve Laravel.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/configure-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/wordpress/administration/enable-tls-ingress/).

## Persistence

The [Bitnami Laravel](https://github.com/bitnami/containers/tree/main/bitnami/laravel) image stores the Laravel data and configurations at the `/app` path of the container. Persistent Volume Claims are used to keep the data across deployments.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
laravel:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as Laravel (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/configure-sidecar-init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Learn more about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).


## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.