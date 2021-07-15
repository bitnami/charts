# Bitnami Object Storage Helm Chart based on MinIO&reg;

[MinIO&reg;](https://min.io) is an object storage server, compatible with Amazon S3 cloud storage service, mainly used for storing unstructured data (such as photos, videos, log files, etc.)

Disclaimer: All software products, projects and company names are trademark&trade; or registered&reg; trademarks of their respective holders, and use of them does not imply any affiliation or endorsement. This software is licensed to you subject to one or more open source licenses and VMware provides the software on an AS-IS basis. MinIO&reg; is a registered trademark of the MinIO, Inc. in the US and other countries. Bitnami is not affiliated, associated, authorized, endorsed by, or in any way officially connected with MinIO, Inc. MinIO&reg; is licensed under GNU AGPL v3.0.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/minio
```

## Introduction

This chart bootstraps a [MinIO&reg;](https://github.com/bitnami/bitnami-docker-minio) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volume for Gateway NAS deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/minio
```

These commands deploy MinIO&reg; on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |
| `global.minio`            | Global MinIO(R) credentials                     | `{}`  |


### Common parameters

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override common.names.fullname template (will maintain the release name) | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname template                                      | `nil`           |
| `commonLabels`      | Labels to add to all deployed objects                                                        | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                                                   | `{}`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                         | `nil`           |
| `clusterDomain`     | Default Kubernetes cluster domain                                                            | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                            | `[]`            |


### MinIO&reg; parameters

| Name                      | Description                                                                                                | Value                     |
| ------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.registry`          | MinIO&reg; image registry                                                                                  | `docker.io`               |
| `image.repository`        | MinIO&reg; image repository                                                                                | `bitnami/minio`           |
| `image.tag`               | MinIO&reg; image tag (immutable tags are recommended)                                                      | `2021.6.17-debian-10-r15` |
| `image.pullPolicy`        | Image pull policy                                                                                          | `IfNotPresent`            |
| `image.pullSecrets`       | Specify docker-registry secret names as an array                                                           | `[]`                      |
| `image.debug`             | Specify if debug logs should be enabled                                                                    | `false`                   |
| `clientImage.registry`    | MinIO&reg; Client image registry                                                                           | `docker.io`               |
| `clientImage.repository`  | MinIO&reg; Client image repository                                                                         | `bitnami/minio-client`    |
| `clientImage.tag`         | MinIO&reg; Client image tag (immutable tags are recommended)                                               | `2021.6.13-debian-10-r22` |
| `mode`                    | MinIO&reg; server mode (`standalone` or `distributed`)                                                     | `standalone`              |
| `accessKey.password`      | MinIO&reg; Access Key. Ignored if existing secret is provided.                                             | `nil`                     |
| `accessKey.forcePassword` | Option to force users to specify a password. That is required for 'helm upgrade' to work properly.         | `false`                   |
| `secretKey.password`      | MinIO&reg; Secret Key. Ignored if existing secret is provided.                                             | `nil`                     |
| `secretKey.forcePassword` | Option to force users to specify a password. That is required for 'helm upgrade' to work properly.         | `false`                   |
| `existingSecret`          | Use existing secret (ignores accessKey, and secretKey passwords)                                           | `nil`                     |
| `useCredentialsFile`      | Mount MinIO&reg; secret as a file instead of passing environment variable                                  | `false`                   |
| `forceNewKeys`            | Force admin credentials (access and secret key) to be reconfigured every time they change in the secrets   | `false`                   |
| `defaultBuckets`          | Comma, semi-colon or space separated list of buckets to create at initialization (only in standalone mode) | `nil`                     |
| `disableWebUI`            | Disable MinIO&reg; Web UI                                                                                  | `false`                   |
| `tls.enabled`             | Enable tls in front of the container                                                                       | `false`                   |
| `tls.existingSecret`      | Name of an existing secret holding the certificate information                                             | `nil`                     |
| `tls.secretName`          | DEPRECATED. Use `tls.existingSecret` instead.                                                              | `""`                      |
| `tls.mountPath`           | The mount path where the secret will be located                                                            | `""`                      |
| `extraEnv`                | Extra environment variables to be set on MinIO&reg; container                                              | `{}`                      |
| `extraEnvVarsCM`          | ConfigMap with extra environment variables                                                                 | `""`                      |
| `extraEnvVarsSecret`      | Secret with extra environment variables                                                                    | `""`                      |
| `command`                 | Default container command (useful when using custom images). Use array form                                | `[]`                      |
| `args`                    | Default container args (useful when using custom images). Use array form                                   | `[]`                      |


### MinIO&reg; deployment/statefulset parameters

| Name                                    | Description                                                                                                                                                                                   | Value           |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `schedulerName`                         | Specifies the schedulerName, if it's nil uses kube-scheduler                                                                                                                                  | `nil`           |
| `deployment.updateStrategy.type`        | Set to Recreate if you use persistent volume that cannot be mounted by more than one pods to make sure the pods is destroyed first.                                                           | `Recreate`      |
| `statefulset.updateStrategy`            | Update strategy, can be set to `RollingUpdate` or `OnDelete`                                                                                                                                  | `RollingUpdate` |
| `statefulset.podManagementPolicy`       | StatefulSet controller supports relax its ordering guarantees while preserving its uniqueness and identity guarantees. There are two valid pod management policies: OrderedReady and Parallel | `Parallel`      |
| `statefulset.replicaCount`              | Number of pods per zone (only for MinIO&reg; distributed mode). Should be even and `>= 4`                                                                                                     | `4`             |
| `statefulset.zones`                     | Number of zones (only for MinIO&reg; distributed mode)                                                                                                                                        | `1`             |
| `statefulset.drivesPerNode`             | Number of drives attached to every node (only for MinIO&reg; distributed mode)                                                                                                                | `1`             |
| `hostAliases`                           | MinIO&reg; pod host aliases                                                                                                                                                                   | `[]`            |
| `containerPort`                         | MinIO&reg; container port to open                                                                                                                                                             | `9000`          |
| `podSecurityContext.enabled`            | Enable pod Security Context                                                                                                                                                                   | `true`          |
| `podSecurityContext.fsGroup`            | Group ID for the container                                                                                                                                                                    | `1001`          |
| `containerSecurityContext.enabled`      | Enable container Security Context                                                                                                                                                             | `true`          |
| `containerSecurityContext.runAsUser`    | User ID for the container                                                                                                                                                                     | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Avoid running as root User                                                                                                                                                                    | `true`          |
| `podLabels`                             | Extra labels for MinIO&reg; pods                                                                                                                                                              | `{}`            |
| `podAnnotations`                        | Annotations for MinIO&reg; pods                                                                                                                                                               | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                           | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                      | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                     | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                                                                                                                        | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                                                                                                                     | `[]`            |
| `affinity`                              | Affinity for pod assignment. Evaluated as a template.                                                                                                                                         | `{}`            |
| `nodeSelector`                          | Node labels for pod assignment. Evaluated as a template.                                                                                                                                      | `{}`            |
| `tolerations`                           | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                      | `[]`            |
| `resources.limits`                      | The resources limits for the MinIO&reg; container                                                                                                                                             | `{}`            |
| `resources.requests`                    | The requested resources for the MinIO&reg; container                                                                                                                                          | `{}`            |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                                                                                                                          | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                                                                       | `5`             |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                                                                              | `5`             |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                                                                             | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                                                                           | `5`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                                                                                           | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                                                                                                                         | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                                                                      | `5`             |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                                                                             | `5`             |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                                                                            | `1`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                                                                          | `5`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                                                                          | `1`             |
| `startupProbe.enabled`                  | Enable startupProbe                                                                                                                                                                           | `false`         |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                                                                                        | `0`             |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                                                                                               | `10`            |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                                                                                              | `5`             |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                                                                                            | `60`            |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                                                                                            | `1`             |
| `customLivenessProbe`                   | Override default liveness probe                                                                                                                                                               | `{}`            |
| `customReadinessProbe`                  | Override default readiness probe                                                                                                                                                              | `{}`            |
| `customStartupProbe`                    | Override default startup probe                                                                                                                                                                | `{}`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for MinIO&reg; pods                                                                                                                       | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for MinIO&reg; container(s)                                                                                                          | `[]`            |
| `initContainers`                        | Add additional init containers to the MinIO&reg; pods                                                                                                                                         | `{}`            |
| `sidecars`                              | Add additional sidecar containers to the MinIO&reg; pods                                                                                                                                      | `{}`            |


### Traffic exposure parameters

| Name                               | Description                                                                                                 | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | MinIO&reg; service type                                                                                     | `ClusterIP`              |
| `service.port`                     | MinIO&reg; service port                                                                                     | `9000`                   |
| `service.nodePort`                 | Specify the nodePort value for the LoadBalancer and NodePort service types                                  | `nil`                    |
| `service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer` (optional, cloud specific)                                 | `nil`                    |
| `service.loadBalancerSourceRanges` | Addresses that are allowed when service is LoadBalancer                                                     | `[]`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                        | `Cluster`                |
| `service.annotations`              | Annotations for MinIO&reg; service                                                                          | `{}`                     |
| `ingress.enabled`                  | Enable ingress controller resource                                                                          | `false`                  |
| `ingress.certManager`              | Set this to true in order to add the corresponding annotations for cert-manager                             | `false`                  |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                               | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress resource                                                                       | `minio.local`            |
| `ingress.path`                     | The Path to MinIO&reg;. You may need to set this to '/*' in order to use this with ALB ingress controllers. | `/`                      |
| `ingress.pathType`                 | Ingress path type                                                                                           | `ImplementationSpecific` |
| `ingress.servicePort`              | Service port to be used                                                                                     | `minio`                  |
| `ingress.annotations`              | Ingress annotations                                                                                         | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter                           | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                    | `[]`                     |
| `ingress.extraPaths`               | Any additional paths that may need to be added to the ingress under the main host                           | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets               | `[]`                     |
| `networkPolicy.enabled`            | Enable the default NetworkPolicy policy                                                                     | `false`                  |
| `networkPolicy.allowExternal`      | Don't require client label for connections                                                                  | `true`                   |


### Persistence parameters

| Name                        | Description                                                          | Value   |
| --------------------------- | -------------------------------------------------------------------- | ------- |
| `persistence.enabled`       | Enable MinIO&reg; data persistence using PVC. If false, use emptyDir | `true`  |
| `persistence.storageClass`  | PVC Storage Class for MinIO&reg; data volume                         | `nil`   |
| `persistence.mountPath`     | Data volume mount path                                               | `/data` |
| `persistence.accessModes`   | PVC Access Modes for MinIO&reg; data volume                          | `[]`    |
| `persistence.size`          | PVC Storage Request for MinIO&reg; data volume                       | `8Gi`   |
| `persistence.annotations`   | Annotations for the PVC                                              | `{}`    |
| `persistence.existingClaim` | Name of an existing PVC to use (only in `standalone` mode)           | `nil`   |


### Volume Permissions parameters

| Name                                                   | Description                                                                                                          | Value                   |
| ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`                     | Init container volume-permissions image registry                                                                     | `docker.io`             |
| `volumePermissions.image.repository`                   | Init container volume-permissions image repository                                                                   | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Init container volume-permissions image tag (immutable tags are recommended)                                         | `10-debian-10-r127`     |
| `volumePermissions.image.pullPolicy`                   | Init container volume-permissions image pull policy                                                                  | `Always`                |
| `volumePermissions.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                     | `[]`                    |
| `volumePermissions.resources.limits`                   | Init container volume-permissions resource limits                                                                    | `{}`                    |
| `volumePermissions.resources.requests`                 | Init container volume-permissions resource requests                                                                  | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | User ID for the init container                                                                                       | `0`                     |


### RBAC parameters

| Name                    | Description                                                 | Value  |
| ----------------------- | ----------------------------------------------------------- | ------ |
| `serviceAccount.create` | Enable the creation of a ServiceAccount for MinIO&reg; pods | `true` |
| `serviceAccount.name`   | Name of the created ServiceAccount                          | `""`   |


### Other parameters

| Name                 | Description                                                                       | Value   |
| -------------------- | --------------------------------------------------------------------------------- | ------- |
| `pdb.create`         | Enable/disable a Pod Disruption Budget creation                                   | `false` |
| `pdb.minAvailable`   | Minimum number/percentage of pods that must still be available after the eviction | `1`     |
| `pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable after the eviction | `nil`   |


### Metrics parameters

| Name                                      | Description                                                                                           | Value                       |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------- | --------------------------- |
| `metrics.prometheusAuthType`              | Authentication mode for Prometheus (`jwt` or `public`)                                                | `public`                    |
| `metrics.serviceMonitor.enabled`          | If the operator is installed in your cluster, set to true to create a Service Monitor Entry           | `false`                     |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                                              | `nil`                       |
| `metrics.serviceMonitor.path`             | HTTP path to scrape for metrics                                                                       | `/minio/v2/metrics/cluster` |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                                           | `30s`                       |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                                   | `nil`                       |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                                             | `nil`                       |
| `metrics.serviceMonitor.honorLabels`      | Specify honorLabels parameter to add the scrape endpoint                                              | `false`                     |
| `metrics.serviceMonitor.release`          | Specify the release for ServiceMonitor. Sometimes it should be custom for prometheus operator to work | `nil`                       |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the installed Prometheus Operator                            | `{}`                        |


### Gateway parameters

| Name                                    | Description                                                    | Value                      |
| --------------------------------------- | -------------------------------------------------------------- | -------------------------- |
| `gateway.enabled`                       | Use MinIO&reg; as Gateway for other storage systems            | `false`                    |
| `gateway.type`                          | Gateway type. Supported types are: `azure`, `gcs`, `nas`, `s3` | `s3`                       |
| `gateway.replicaCount`                  | Number of MinIO&reg; Gateway replicas                          | `4`                        |
| `gateway.auth.azure.accessKey`          | Access Key to access MinIO using Azure Gateway                 | `""`                       |
| `gateway.auth.azure.secretKey`          | Secret Key to access MinIO using Azure Gateway                 | `""`                       |
| `gateway.auth.azure.storageAccountName` | Azure Storage Account Name to use to access Azure Blob Storage | `""`                       |
| `gateway.auth.azure.storageAccountKey`  | Azure Storage Account Key to use to access Azure Blob Storage  | `""`                       |
| `gateway.auth.gcs.accessKey`            | Access Key to access MinIO using GCS Gateway                   | `""`                       |
| `gateway.auth.gcs.secretKey`            | Secret Key to access MinIO using GCS Gateway                   | `""`                       |
| `gateway.auth.gcs.keyJSON`              | Service Account key to access GCS                              | `""`                       |
| `gateway.auth.gcs.projectID`            | GCP Project ID to use                                          | `""`                       |
| `gateway.auth.nas.accessKey`            | Access Key to access MinIO using NAS Gateway                   | `""`                       |
| `gateway.auth.nas.secretKey`            | Secret Key to access MinIO using NAS Gateway                   | `""`                       |
| `gateway.auth.s3.accessKey`             | Access Key to use to access AWS S3                             | `""`                       |
| `gateway.auth.s3.secretKey`             | Secret Key to use to access AWS S3                             | `""`                       |
| `gateway.auth.s3.serviceEndpoint`       | AWS S3 endpoint                                                | `https://s3.amazonaws.com` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set accessKey.password=minio-access-key \
  --set secretKey.password=minio-secret-key \
    bitnami/minio
```

The above command sets the MinIO&reg; Server access key and secret key to `minio-access-key` and `minio-secret-key`, respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/minio
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Distributed mode

By default, this chart provisions a MinIO&reg; server in standalone mode. You can start MinIO&reg; server in [distributed mode](https://docs.minio.io/docs/distributed-minio-quickstart-guide) with the following parameter: `mode=distributed`

This chart bootstrap MinIO&reg; server in distributed mode with 4 nodes by default. You can change the number of nodes using the `statefulset.replicaCount` parameter. For instance, you can deploy the chart with 8 nodes using the following parameters:

```console
mode=distributed
statefulset.replicaCount=8
```

You can also bootstrap MinIO&reg; server in distributed mode in several zones, and using multiple drives per node. For instance, you can deploy the chart with 2 nodes per zone on 2 zones, using 2 drives per node:

```console
mode=distributed
statefulset.replicaCount=2
statefulset.zones=2
statefulset.drivesPerNode=2
```

> Note: The total number of drives should be multiple of 4 to guarantee erasure coding. Please set a combination of nodes, and drives per node that match this condition.

### Prometheus exporter

MinIO&reg; exports Prometheus metrics at `/minio/v2/metrics/cluster`. To allow Prometheus collecting your MinIO&reg; metrics, modify the `values.yaml` adding the corresponding annotations:

```diff
- podAnnotations: {}
+ podAnnotations:
+   prometheus.io/scrape: "true"
+   prometheus.io/path: "/minio/v2/metrics/cluster"
+   prometheus.io/port: "9000"
```

> Find more information about MinIO&reg; metrics at https://docs.min.io/docs/how-to-monitor-minio-using-prometheus.html

## Persistence

The [Bitnami Object Storage based on MinIO&reg;](https://github.com/bitnami/bitnami-docker-minio) image stores data at the `/data` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to serve your MinIO&reg; server.

To enable ingress integration, please set `ingress.enabled` to `true`, and `disableWebUI` to `false`.

#### Hosts

Most likely you will only want to have one hostname that maps to this MinIO&reg; installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object is can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

#### TLS

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are four common use cases:

- Helm generates/manages certificate secrets based on the parameters.
- User generates/manages certificates separately.
- Helm creates self-signed certificates and generates/manages certificate secrets.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

In the first two cases, it's needed a certificate and a key. Files are expected in PEM format.

- If you are going to use Helm to manage the certificates based on the parameters, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.
- In case you are going to manage TLS secrets separately, please know that you must create a TLS secret with name *INGRESS_HOSTNAME-tls* (where *INGRESS_HOSTNAME* is a placeholder to be replaced with the hostname you set using the `ingress.hostname` parameter).
- To use self-signed certificates created by Helm, set `ingress.tls` to `true`, and `ingress.certManager` to `false`.
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, set `ingress.certManager` boolean to `true` to enable the corresponding annotations for cert-manager.

### MinIO&reg; Gateway

MinIO&reg; can be configured as a Gateway for other other storage systems. Currently this chart supports to setup MinIO&reg; as a Gateway for the storage systems below:

- [Azure Blob Storage](https://azure.microsoft.com/en-us/services/storage/blobs/)
- [GCS](https://cloud.google.com/storage)
- NAS: Network Attached Storage
- [AWS S3](https://aws.amazon.com/s3/)

The enable this feature, install the chart setting `gateway.enabled` to `true`. You can choose the Gateway type setting the `gateway.type` parameter. For instance, to install the chart as a S3 Gateway, install the chart the using the following parameters:

```console
gateway.enabled=true
gateway.replicaCount=4
gateway.type=s3
gateway.auth.s3.serviceEndpoint=https://s3.amazonaws.com
gateway.auth.s3.accessKey=S3_ACCESS_KEY
gateway.auth.s3.secretKey=S3_SECRET_KEY
```

> Note: remember to replace the S3_ACCESS_KEY and S3_SECRET_KEY placeholders with your actual S3 access & secret keys.

Find all the available parameters to configure MinIO&reg; as a Gateway in the [Gateway parameters section](#gateway-parameters).

> Note: when using MinIO&reg; as a NAS Gateway, you need ReadWriteMany PVs to deploy multiple MinIO&reg; instances. Ensure you K8s cluster supports this kind of cluster, and install the chart setting `persistence.accessModes[0]` to `ReadWriteMany` to do so.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnv` property.

```yaml
extraEnv:
  - name: MINNIO_LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the MinIO&reg; app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 7.0.0

This version introduces pod and container securityContext support. The previous configuration of `securityContext` has moved to `podSecurityContext` and `containerSecurityContext`. Apart from this case, no issues are expected to appear when upgrading.

### To 5.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 4.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 4.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/
