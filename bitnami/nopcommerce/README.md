# nopCommerce packaged by Bitnami

[nopCommerce](https://www.nopcommerce.com/) is the best open-source eCommerce platform. nopCommerce is free, and it is the most popular ASP.NET Core shopping cart.

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/nopcommerce
```

## Introduction

This chart bootstraps an [nopCommerce](https://github.com/bitnami/bitnami-docker-nopcommerce) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MySql chart](https://github.com/bitnami/charts/tree/master/bitnami/mysql) which is required for bootstrapping a MySQL deployment for the database requirements of the nopCommerce application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).


## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/nopcommerce
```

The command deploys nopCommerce on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### nopCommerce Parameters

| Name                                              | Description                                                                                                              | Value                         |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ----------------------------- |
| `image.registry`                                  | nopCommerce image registry                                                                                               | `docker.io`                   |
| `image.repository`                                | nopCommerce image repository                                                                                             | `nopcommerceteam/nopcommerce` |
| `image.tag`                                       | nopCommerce image tag (immutable tags are recommended)                                                                   | `4.50.2`                      |
| `image.pullPolicy`                                | nopCommerce image pull policy                                                                                            | `IfNotPresent`                |
| `image.pullSecrets`                               | nopCommerce image pull secrets                                                                                           | `[]`                          |
| `image.debug`                                     | Enable nopCommerce image debug mode                                                                                      | `false`                       |
| `replicaCount`                                    | Number of replicas to deploy                                                                                             | `1`                           |
| `containerPorts.http`                             | HTTP container port                                                                                                      | `80`                          |
| `containerPorts.https`                            | HTTPS container port                                                                                                     | `443`                         |
| `livenessProbe.enabled`                           | Enable livenessProbe on containers                                                                                       | `true`                        |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                  | `120`                         |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                         | `10`                          |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                        | `5`                           |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                      | `6`                           |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                      | `1`                           |
| `readinessProbe.enabled`                          | Enable readinessProbe on containers                                                                                      | `true`                        |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                 | `120`                         |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                        | `10`                          |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                       | `5`                           |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                     | `6`                           |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                     | `1`                           |
| `startupProbe.enabled`                            | Enable startupProbe on containers                                                                                        | `false`                       |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                   | `120`                         |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                          | `10`                          |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                         | `5`                           |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                       | `6`                           |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                       | `1`                           |
| `customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                      | `{}`                          |
| `customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                     | `{}`                          |
| `customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                       | `{}`                          |
| `resources.limits`                                | The resources limits for the containers                                                                                  | `{}`                          |
| `resources.requests`                              | The requested resources for the containers                                                                               | `{}`                          |
| `podSecurityContext.enabled`                      | Enabled pods' Security Context                                                                                           | `true`                        |
| `podSecurityContext.fsGroup`                      | Set pod's Security Context fsGroup                                                                                       | `1001`                        |
| `containerSecurityContext.enabled`                | Enabled containers' Security Context                                                                                     | `true`                        |
| `containerSecurityContext.runAsUser`              | Set containers' Security Context runAsUser                                                                               | `1001`                        |
| `containerSecurityContext.runAsNonRoot`           | Set containers' Security Context runAsNonRoot                                                                            | `true`                        |
| `containerSecurityContext.readOnlyRootFilesystem` | Set containers' Security Context runAsNonRoot                                                                            | `false`                       |
| `existingConfigmap`                               | The name of an existing ConfigMap with your custom configuration                                                         | `nil`                         |
| `command`                                         | Override default container command (useful when using custom images)                                                     | `[]`                          |
| `args`                                            | Override default container args (useful when using custom images)                                                        | `[]`                          |
| `hostAliases`                                     | pods host aliases                                                                                                        | `[]`                          |
| `podLabels`                                       | Extra labels for pods                                                                                                    | `{}`                          |
| `podAnnotations`                                  | Annotations for pods                                                                                                     | `{}`                          |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`                          |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`                        |
| `pdb.create`                                      | Enable/disable a Pod Disruption Budget creation                                                                          | `false`                       |
| `pdb.minAvailable`                                | Minimum number/percentage of pods that should remain scheduled                                                           | `1`                           |
| `pdb.maxUnavailable`                              | Maximum number/percentage of pods that may be made unavailable                                                           | `""`                          |
| `autoscaling.enabled`                             | Enable autoscaling                                                                                                       | `false`                       |
| `autoscaling.minReplicas`                         | Minimum number of replicas                                                                                               | `""`                          |
| `autoscaling.maxReplicas`                         | Maximum number of replicas                                                                                               | `""`                          |
| `autoscaling.targetCPU`                           | Target CPU utilization percentage                                                                                        | `""`                          |
| `autoscaling.targetMemory`                        | Target Memory utilization percentage                                                                                     | `""`                          |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                          |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                    | `""`                          |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`                          |
| `affinity`                                        | Affinity for pods assignment                                                                                             | `{}`                          |
| `nodeSelector`                                    | Node labels for pods assignment                                                                                          | `{}`                          |
| `tolerations`                                     | Tolerations for pods assignment                                                                                          | `[]`                          |
| `updateStrategy.type`                             | statefulset strategy type                                                                                                | `RollingUpdate`               |
| `podManagementPolicy`                             | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join                       | `OrderedReady`                |
| `priorityClassName`                               | pods' priorityClassName                                                                                                  | `""`                          |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `{}`                          |
| `schedulerName`                                   | Name of the k8s scheduler (other than default) for pods                                                                  | `""`                          |
| `terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`                          |
| `lifecycleHooks`                                  | for the container(s) to automate configuration before or after startup                                                   | `{}`                          |
| `extraEnvVars`                                    | Array with extra environment variables to add to nodes                                                                   | `[]`                          |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for nodes                                                           | `""`                          |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for nodes                                                              | `""`                          |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the pod(s)                                                       | `[]`                          |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the container(s)                                            | `[]`                          |
| `sidecars`                                        | Add additional sidecar containers to the pod(s)                                                                          | `{}`                          |
| `initContainers`                                  | Add additional init containers to the pod(s)                                                                             | `{}`                          |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | service type                                                                                                                     | `LoadBalancer`           |
| `service.ports.http`               | service HTTP port                                                                                                                | `80`                     |
| `service.ports.https`              | service HTTPS port                                                                                                               | `443`                    |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                     |
| `service.clusterIP`                | service Cluster IP                                                                                                               | `""`                     |
| `service.loadBalancerIP`           | service Load Balancer IP                                                                                                         | `""`                     |
| `service.loadBalancerSourceRanges` | service Load Balancer sources                                                                                                    | `[]`                     |
| `service.externalTrafficPolicy`    | service external traffic policy                                                                                                  | `Cluster`                |
| `service.annotations`              | Additional custom annotations for service                                                                                        | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in service (normally used with the `sidecars` value)                                                       | `[]`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation                                                                                                 | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `nopcommerce.local`      |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |


### Persistence Parameters

| Name                        | Description                                                                                             | Value               |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `true`              |
| `persistence.mountPath`     | Path to mount the volume at.                                                                            | `/bitnami/data`     |
| `persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                |
| `persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]` |
| `persistence.size`          | Size of data volume                                                                                     | `8Gi`               |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                |
| `persistence.selector`      | Selector to match an existing Persistent Volume for WordPress data PVC                                  | `{}`                |
| `persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                |


### Database parameters

| Name                                      | Description                                                                              | Value                 |
| ----------------------------------------- | ---------------------------------------------------------------------------------------- | --------------------- |
| `mysql.enabled`                           | Whether to deploy a mysql server to satisfy the applications database requirements       | `true`                |
| `mysql.architecture`                      | MySQL architecture. Allowed values: `standalone` or `replication`                        | `standalone`          |
| `mysql.auth.rootPassword`                 | Password for the MySQL `root` user                                                       | `""`                  |
| `mysql.auth.database`                     | Database name to create                                                                  | `bitnami_nopcommerce` |
| `mysql.auth.username`                     | Database user to create                                                                  | `bn_nopcommerce`      |
| `mysql.auth.password`                     | Password for the database                                                                | `""`                  |
| `mysql.primary.persistence.enabled`       | Enable database persistence using PVC                                                    | `true`                |
| `mysql.primary.persistence.storageClass`  | MySQL primary persistent volume storage Class                                            | `""`                  |
| `mysql.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                  | `["ReadWriteOnce"]`   |
| `mysql.primary.persistence.size`          | Database Persistent Volume Size                                                          | `8Gi`                 |
| `mysql.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production) | `""`                  |
| `mysql.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MySQL primary replicas                   | `""`                  |
| `externalDatabase.host`                   | Host of the existing database                                                            | `""`                  |
| `externalDatabase.port`                   | Port of the existing database                                                            | `3306`                |
| `externalDatabase.user`                   | Existing username in the existing database                                               | `bn_nopcommerce`      |
| `externalDatabase.password`               | Password for the above username                                                          | `""`                  |
| `externalDatabase.database`               | Name of the existing database                                                            | `bitnami_nopcommerce` |
| `externalDatabase.existingSecret`         | Name of an existing secret resource containing the DB password                           | `""`                  |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                   |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `10-debian-10-r387`     |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |


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
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables                        | `[]`                                     |
| `certificates.extraEnvVarsCM`                        | ConfigMap with extra environment variables                           | `""`                                     |
| `certificates.extraEnvVarsSecret`                    | Secret with extra environment variables                              | `""`                                     |
| `certificates.image.registry`                        | Container sidecar registry                                           | `docker.io`                              |
| `certificates.image.repository`                      | Container sidecar image repository                                   | `bitnami/bitnami-shell`                  |
| `certificates.image.tag`                             | Container sidecar image tag (immutable tags are recommended)         | `10-debian-10-r387`                      |
| `certificates.image.pullPolicy`                      | Container sidecar image pull policy                                  | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Container sidecar image pull secrets                                 | `[]`                                     |


### Other Parameters

| Name                                          | Description                                                                                            | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                   | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                 | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)                                       | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                         | `true`  |
| `metrics.enabled`                             | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`            | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.labels`               | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `metrics.serviceMonitor.jobLabel`             | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `metrics.serviceMonitor.honorLabels`          | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `metrics.serviceMonitor.interval`             | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.metricRelabelings`    | Specify additional relabeling of metrics                                                               | `[]`    |
| `metrics.serviceMonitor.relabelings`          | Specify general relabeling                                                                             | `[]`    |
| `metrics.serviceMonitor.selector`             | Prometheus instance selector labels                                                                    | `{}`    |


### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                     | Value   |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                         | `false` |
| `networkPolicy.metrics.enabled`                               | Enable network policy for metrics (prometheus)                                                                                  | `false` |
| `networkPolicy.metrics.namespaceSelector`                     | Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                          | `{}`    |
| `networkPolicy.metrics.podSelector`                           | Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                      | `{}`    |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                       | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.                   | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                               | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by nopCommerce's pods.                                     | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                                | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes nopCommerce only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access nopCommerce. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access nopCommerce. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                              | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                                  | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                      | `{}`    |


The above parameters map to the env variables defined in [bitnami/nopcommerce](http://github.com/bitnami/bitnami-docker-nopcommerce). For more information please refer to the [bitnami/nopcommerce](http://github.com/bitnami/bitnami-docker-nopcommerce) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set nopcommerceUsername=admin \
  --set nopcommercePassword=password \
  --set mysql.auth.rootPassword=secretpassword \
    bitnami/nopcommerce
```

The above command sets the nopcommerce administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MySQL `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/nopcommerce
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### External database support

%%IF NEEDED%%

You may want to have nopcommerce connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#parameters). You should also disable the MySQL installation with the `mysql.enabled` option. Here is an example:

```console
mysql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

### Ingress

%%IF NEEDED%%

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/nopcommerce/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/nopcommerce/administration/enable-tls/).

### %%OTHER_SECTIONS%%

## Persistence

The [Bitnami nopcommerce](https://github.com/bitnami/bitnami-docker-nopcommerce) image stores the nopcommerce data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. [Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/apps/nopcommerce/configuration/chart-persistence/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
nopcommerce:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as nopcommerce (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/nopcommerce/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

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
