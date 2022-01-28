<!--- app-name: Bitnami LMS powered by Moodle(&trade;) LMS -->

# Bitnami LMS powered by Moodle(TM) LMS

Moodle(TM) LMS is an open source online Learning Management System widely used at universities, schools, and corporations. It is modular and highly adaptable to any type of online learning.

[Overview of Bitnami LMS powered by Moodle(&trade;) LMS](http://moodle.org/)

Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide commercial license of any of these products. This listing has an open source license. Moodle(TM) LMS is run and maintained by Moodle HQ, that is a completely and separate project from Bitnami.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/moodle
```

## Introduction

This chart bootstraps a [Moodle&trade;](https://github.com/bitnami/bitnami-docker-moodle) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Moodle&trade; application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/moodle
```

The command deploys Moodle&trade; on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
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

| Name                | Description                                                                                                | Value |
| ------------------- | ---------------------------------------------------------------------------------------------------------- | ----- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                       | `""`  |
| `nameOverride`      | String to partially override moodle.fullname template                                                      | `""`  |
| `fullnameOverride`  | String to fully override moodle.fullname template                                                          | `""`  |
| `commonAnnotations` | Common annotations to add to all Harbor resources (sub-charts are not considered). Evaluated as a template | `{}`  |
| `commonLabels`      | Common labels to add to all Harbor resources (sub-charts are not considered). Evaluated as a template      | `{}`  |
| `extraDeploy`       | Array with extra yaml to deploy with the chart. Evaluated as a template                                    | `[]`  |


### Moodle&trade; parameters

| Name                                    | Description                                                                                                           | Value                 |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`                        | Moodle image registry                                                                                                 | `docker.io`           |
| `image.repository`                      | Moodle image repository                                                                                               | `bitnami/moodle`      |
| `image.tag`                             | Moodle image tag (immutable tags are recommended)                                                                     | `3.11.5-debian-10-r0` |
| `image.pullPolicy`                      | Moodle image pull policy                                                                                              | `IfNotPresent`        |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                      | `[]`                  |
| `image.debug`                           | Specify if debug logs should be enabled                                                                               | `false`               |
| `replicaCount`                          | Number of Moodle replicas (requires ReadWriteMany PVC support)                                                        | `1`                   |
| `moodleSkipInstall`                     | Skip Moodle&trade; installation wizard. Useful for migrations and restoring from SQL dump                             | `false`               |
| `moodleSiteName`                        | Site name                                                                                                             | `""`                  |
| `moodleUsername`                        | User of the application                                                                                               | `user`                |
| `moodlePassword`                        | Application password                                                                                                  | `""`                  |
| `moodleEmail`                           | Admin email                                                                                                           | `user@example.com`    |
| `allowEmptyPassword`                    | Allow DB blank passwords                                                                                              | `true`                |
| `command`                               | Override default container command (useful when using custom images)                                                  | `[]`                  |
| `args`                                  | Override default container args (useful when using custom images)                                                     | `[]`                  |
| `updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached                                        | `RollingUpdate`       |
| `extraEnvVars`                          | An array to add extra env vars                                                                                        | `[]`                  |
| `extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                                            | `""`                  |
| `extraEnvVarsSecret`                    | Secret with extra environment variables (in case of sensitive data)                                                   | `""`                  |
| `extraVolumes`                          | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`    | `[]`                  |
| `extraVolumeMounts`                     | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. | `[]`                  |
| `initContainers`                        | Extra init containers to add to the deployment                                                                        | `[]`                  |
| `sidecars`                              | Extra sidecar containers to add to the deployment                                                                     | `[]`                  |
| `hostAliases`                           | Moodle&trade; pods host aliases                                                                                       | `[]`                  |
| `tolerations`                           | Tolerations for pod assignment                                                                                        | `[]`                  |
| `priorityClassName`                     | Moodle&trade; pods' priorityClassName                                                                                 | `""`                  |
| `schedulerName`                         | Name of the k8s scheduler (other than default)                                                                        | `""`                  |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                                        | `[]`                  |
| `existingSecret`                        | Name of a secret with the application password                                                                        | `""`                  |
| `smtpHost`                              | SMTP host                                                                                                             | `""`                  |
| `smtpPort`                              | SMTP port                                                                                                             | `""`                  |
| `smtpUser`                              | SMTP user                                                                                                             | `""`                  |
| `smtpPassword`                          | SMTP password                                                                                                         | `""`                  |
| `smtpProtocol`                          | SMTP Protocol (options: ssl,tls, nil)                                                                                 | `""`                  |
| `containerPorts`                        | Container ports                                                                                                       | `{}`                  |
| `sessionAffinity`                       | Control where client requests go, to the same pod or round-robin                                                      | `None`                |
| `persistence.enabled`                   | Enable persistence using PVC                                                                                          | `true`                |
| `persistence.customStorageClass`        | Create a custom storage class                                                                                         | `{}`                  |
| `persistence.storageClass`              | PVC Storage Class for Moodle                                                                                          | `""`                  |
| `persistence.accessModes`               | PVC Access Mode for Moodle                                                                                            | `["ReadWriteOnce"]`   |
| `persistence.size`                      | PVC Storage Request for Moodle                                                                                        | `8Gi`                 |
| `persistence.existingClaim`             | An Existing PVC name                                                                                                  | `""`                  |
| `persistence.hostPath`                  | Host mount path for Moodle                                                                                            | `""`                  |
| `persistence.annotations`               | Persistent Volume Claim annotations                                                                                   | `{}`                  |
| `podAffinityPreset`                     | Pod affinity preset                                                                                                   | `""`                  |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset                                                                                              | `soft`                |
| `nodeAffinityPreset.type`               | Node affinity type                                                                                                    | `""`                  |
| `nodeAffinityPreset.key`                | Node label key to match                                                                                               | `""`                  |
| `nodeAffinityPreset.values`             | Node label values to match                                                                                            | `[]`                  |
| `affinity`                              | Map of node/pod affinities                                                                                            | `{}`                  |
| `nodeSelector`                          | Node labels for pod assignment                                                                                        | `{}`                  |
| `resources.requests`                    | CPU/Memory resource requests                                                                                          | `{}`                  |
| `resources.limits`                      | CPU/Memory resource limits                                                                                            | `{}`                  |
| `podSecurityContext.enabled`            | Enable Moodle&trade; pods' Security Context                                                                           | `true`                |
| `podSecurityContext.fsGroup`            | Moodle&trade; pods' group ID                                                                                          | `1001`                |
| `containerSecurityContext.enabled`      | Enable Moodle&trade; containers' Security Context                                                                     | `true`                |
| `containerSecurityContext.runAsUser`    | Moodle&trade; containers' Security Context runAsUser                                                                  | `1001`                |
| `containerSecurityContext.runAsNonRoot` | Moodle&trade; containers' Security Context runAsNonRoot                                                               | `true`                |
| `startupProbe.enabled`                  | Enable startupProbe                                                                                                   | `false`               |
| `startupProbe.path`                     | Request path for startupProbe                                                                                         | `/login/index.php`    |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                | `600`                 |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                       | `10`                  |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                      | `5`                   |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                    | `6`                   |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                    | `1`                   |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                                                  | `true`                |
| `livenessProbe.path`                    | Request path for livenessProbe                                                                                        | `/login/index.php`    |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                               | `600`                 |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                      | `10`                  |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                     | `5`                   |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                   | `6`                   |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                   | `1`                   |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                                                 | `true`                |
| `readinessProbe.path`                   | Request path for readinessProbe                                                                                       | `/login/index.php`    |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                              | `30`                  |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                     | `5`                   |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                    | `3`                   |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                  | `6`                   |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                  | `1`                   |
| `customStartupProbe`                    | Override default startup probe                                                                                        | `{}`                  |
| `customLivenessProbe`                   | Override default liveness probe                                                                                       | `{}`                  |
| `customReadinessProbe`                  | Override default readiness probe                                                                                      | `{}`                  |
| `lifecycleHooks`                        | LifecycleHook to set additional configuration at startup Evaluated as a template                                      | `""`                  |
| `podAnnotations`                        | Pod annotations                                                                                                       | `{}`                  |
| `podLabels`                             | Add additional labels to the pod (evaluated as a template)                                                            | `{}`                  |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Service type                                                                                                                     | `LoadBalancer`           |
| `service.ports.http`               | Service HTTP port                                                                                                                | `80`                     |
| `service.ports.https`              | Service HTTPS port                                                                                                               | `443`                    |
| `service.nodePorts.http`           | Kubernetes HTTP node port                                                                                                        | `""`                     |
| `service.nodePorts.https`          | Kubernetes HTTPS node port                                                                                                       | `""`                     |
| `service.clusterIP`                | Service Cluster IP                                                                                                               | `""`                     |
| `service.loadBalancerSourceRanges` | Service load balancer source ranges                                                                                              | `[]`                     |
| `service.loadBalancerIP`           | loadBalancerIP for the Moodle&trade; Service (optional, cloud specific)                                                          | `""`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.annotations`              | Additional custom annotations for Moodle&trade; service                                                                          | `{}`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`                 | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`                 | When the ingress is enabled, a host pointing to this will be created                                                             | `moodle.local`           |
| `ingress.path`                     | The Path to Moodle&trade;. You may need to set this to '/*' in order to use this with ALB ingress controllers.                   | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |


### Database parameters

| Name                                        | Description                                                                              | Value               |
| ------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements     | `true`              |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                     | `standalone`        |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                     | `""`                |
| `mariadb.auth.database`                     | Database name to create                                                                  | `bitnami_moodle`    |
| `mariadb.auth.username`                     | Database user to create                                                                  | `bn_moodle`         |
| `mariadb.auth.password`                     | Password for the database                                                                | `""`                |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                    | `true`              |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                          | `""`                |
| `mariadb.primary.persistence.accessModes`   | PVC Access Modes for Moodle&trade; volume                                                | `["ReadWriteOnce"]` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                          | `8Gi`               |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production) | `""`                |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                 | `""`                |
| `externalDatabase.host`                     | Host of the existing database                                                            | `""`                |
| `externalDatabase.port`                     | Port of the existing database                                                            | `3306`              |
| `externalDatabase.user`                     | Existing username in the external db                                                     | `bn_moodle`         |
| `externalDatabase.password`                 | Password for the above username                                                          | `""`                |
| `externalDatabase.database`                 | Name of the existing database                                                            | `bitnami_moodle`    |
| `externalDatabase.existingSecret`           | Name of an existing secret resource containing the DB password                           | `""`                |


### Volume Permissions parameters

| Name                                   | Description                                                                                                                                               | Value                   |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                                                          | `docker.io`             |
| `volumePermissions.image.repository`   | Init container volume-permissions image repository                                                                                                        | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag (immutable tags are recommended)                                                                              | `10-debian-10-r311`     |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                                                       | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                                                          | `[]`                    |
| `volumePermissions.resources.limits`   | The resources limits for the container                                                                                                                    | `{}`                    |
| `volumePermissions.resources.requests` | The requested resources for the container                                                                                                                 | `{}`                    |


### Metrics parameters

| Name                                       | Description                                                                                     | Value                     |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------- | ------------------------- |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                            | `false`                   |
| `metrics.image.registry`                   | Apache exporter image registry                                                                  | `docker.io`               |
| `metrics.image.repository`                 | Apache exporter image repository                                                                | `bitnami/apache-exporter` |
| `metrics.image.tag`                        | Apache exporter image tag (immutable tags are recommended)                                      | `0.11.0-debian-10-r28`    |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                               | `IfNotPresent`            |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                | `[]`                      |
| `metrics.service.type`                     | Prometheus metrics service type                                                                 | `LoadBalancer`            |
| `metrics.service.port`                     | Prometheus metrics service port                                                                 | `9117`                    |
| `metrics.service.loadBalancerIP`           | Load Balancer IP if the Prometheus metrics server type is `LoadBalancer`, otherwise leave blank | `""`                      |
| `metrics.service.loadBalancerSourceRanges` | Prometheus metrics service service Load Balancer sources                                        | `[]`                      |
| `metrics.service.clusterIP`                | Prometheus metrics service Cluster IP                                                           | `""`                      |
| `metrics.service.externalTrafficPolicy`    | Prometheus metrics service service external traffic policy                                      | `Cluster`                 |
| `metrics.service.annotations`              | Annotations for Prometheus Exporter pods. Evaluated as a template.                              | `{}`                      |
| `metrics.service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                            | `None`                    |
| `metrics.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                     | `{}`                      |
| `metrics.resources`                        | Exporter resource requests/limit                                                                | `{}`                      |
| `metrics.podAnnotations`                   | Metrics exporter pod Annotation and Labels                                                      | `{}`                      |


### Certificate injection parameters

| Name                                                 | Description                                                          | Value                                    |
| ---------------------------------------------------- | -------------------------------------------------------------------- | ---------------------------------------- |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                     | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                  | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                  | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                   | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                   | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain             | `/etc/ssl/certs/mychain.pem`             |
| `certificates.customCAs`                             | Defines a list of secrets to import into the container trust store   | `[]`                                     |
| `certificates.command`                               | Override default container command (useful when using custom images) | `[]`                                     |
| `certificates.args`                                  | Override default container args (useful when using custom images)    | `[]`                                     |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (eg proxy)             | `[]`                                     |
| `certificates.extraEnvVarsCM`                        | ConfigMap with extra environment variables                           | `""`                                     |
| `certificates.extraEnvVarsSecret`                    | Secret with extra environment variables                              | `""`                                     |
| `certificates.image.registry`                        | Container sidecar registry                                           | `docker.io`                              |
| `certificates.image.repository`                      | Container sidecar image repository                                   | `bitnami/bitnami-shell`                  |
| `certificates.image.tag`                             | Container sidecar image tag (immutable tags are recommended)         | `10-debian-10-r311`                      |
| `certificates.image.pullPolicy`                      | Container sidecar image pull policy                                  | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Container sidecar image pull secrets                                 | `[]`                                     |


### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                | Value   |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                    | `false` |
| `networkPolicy.metrics.enabled`                               | Enable network policy for metrics (prometheus)                                                                             | `false` |
| `networkPolicy.metrics.namespaceSelector`                     | Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                     | `{}`    |
| `networkPolicy.metrics.podSelector`                           | Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                 | `{}`    |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                  | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.              | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                          | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by Moodle's pods.                                     | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                           | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes Moodle only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access Moodle. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access Moodle. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                         | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                             | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                 | `{}`    |


The above parameters map to the env variables defined in [bitnami/moodle](https://github.com/bitnami/bitnami-docker-moodle). For more information please refer to the [bitnami/moodle](https://github.com/bitnami/bitnami-docker-moodle) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set moodleUsername=admin,moodlePassword=password,mariadb.auth.rootPassword=secretpassword \
    bitnami/moodle
```

The above command sets the Moodle&trade; administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/moodle
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress without TLS

For using ingress (example without TLS):

```console
ingress.enabled=True
ingress.hosts[0]=moodle.domain.com
serviceType=ClusterIP
moodleUsername=admin
moodlePassword=password
mariadb.mariadbRootPassword=secretpassword
```

These are the *3 mandatory parameters* when *Ingress* is desired: `ingress.enabled=True`, `ingress.hosts[0]=moodle.domain.com` and `serviceType=ClusterIP`

### Ingress TLS

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret (named `moodle-server-tls` in this example) in the namespace. Include the secret's name, along with the desired hostnames, in the Ingress TLS section of your custom `values.yaml` file:

```yaml
ingress:
  ## If true, Moodle(TM) server Ingress will be created
  ##
  enabled: true

  ## Moodle(TM) server Ingress annotations
  ##
  annotations: {}
  #   kubernetes.io/ingress.class: nginx
  #   kubernetes.io/tls-acme: 'true'

  ## Moodle(TM) server Ingress hostnames
  ## Must be provided if Ingress is enabled
  ##
  hosts:
    - moodle.domain.com

  ## Moodle(TM) server Ingress TLS configuration
  ## Secrets must be manually created in the namespace
  ##
  tls:
    - secretName: moodle-server-tls
      hosts:
        - moodle.domain.com
```

## Persistence

The [Bitnami Container Image for Moodle&trade;](https://github.com/bitnami/bitnami-docker-moodle) stores the Moodle&trade; data and configurations at the `/bitnami/moodle` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, vpshere, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.
You may want to review the [PV reclaim policy](https://kubernetes.io/docs/tasks/administer-cluster/change-pv-reclaim-policy/) and update as required. By default, it's set to delete, and when Moodle&trade; is uninstalled, data is also removed.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 12.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated. We recommend using `service.ports.http` instead.
- `service.httpsPort` was deprecated. We recommend using `service.ports.https` instead.

Additionally updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-1000) for more information.

### To 11.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 10.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 9.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `9.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and Moodle&trade; data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `moodle`):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and Moodle&trade; data on your current release:

```console
export MOODLE_PASSWORD=$(kubectl get secret --namespace default moodle -o jsonpath="{.data.moodle-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default moodle-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default moodle-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=moodle -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling Moodle&trade; replicas to 0:

```console
$ helm upgrade moodle bitnami/moodle --set moodlePassword=$MOODLE_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 8.1.6
```

Finally, upgrade you release to 9.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade moodle bitnami/moodle --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set moodlePassword=$MOODLE_PASSWORD
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=moodle,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 8.0.0

The [Bitnami Container Image for Moodle&trade;](https://github.com/bitnami/bitnami-docker-moodle) was updated to support "non-root" user approach, however, **it is not enabled by default**. The container still runs as the `root` user and the Apache daemon is started as the `daemon` user, due to running Cron as a service, which requires running as root.

If you want to run with a non-root user, you need to set `podSecurityContext.enabled=true` and `containerSecurity.context.enabled=true`. In addition to that, you will also need to change the default Apache HTTP ports to run as a non-privileged user by setting `containerPorts.http` and `containerPorts.https` to a non-privileged port number (higher than 1024, i.e. 8080 and 8443, respectively). Note that, when running as a non-root user, Cron will not supported and therefore scheduled tasks will not be enabled for Moodle&trade;.

This upgrade also adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information.

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17301 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is moodle:

```console
$ kubectl patch deployment moodle-moodle --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset moodle-mariadb --cascade=false
```

## Community supported solution

Please, note this Helm chart is a community-supported solution. This means that the Bitnami team is not actively working on new features/improvements nor providing support through GitHub Issues for this Helm chart. Any new issue will stay open for 20 days to allow the community to contribute, after 15 days without activity the issue will be marked as stale being closed after 5 days.

The Bitnami team will review any PR that is created, feel free to create a PR if you find any issue or want to implement a new feature.

New versions are not going to be affected. Once a new version is released in the upstream project, the Bitnami container image will be updated to use the latest version.

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