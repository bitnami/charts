# MinIO&reg; Helm Chart packaged by Bitnami

[MinIO&reg;](https://min.io) is an object storage server, compatible with Amazon S3 cloud storage service, mainly used for storing unstructured data (such as photos, videos, log files, etc.)

Disclaimer: All software products, projects and company names are trademarks&trade; or registered&reg; trademarks of their respective holders, and use of them does not imply any affiliation or endorsement. This software is licensed to you subject to one or more open source licenses and VMware provides the software on an AS-IS basis.

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
- ReadWriteMany volumes for deployment scaling

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

The following table lists the configurable parameters of the MinIO&reg; chart and their default values.

| Parameter                            | Description                                                                                                                                               | Default                                                 |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`               | Global Docker image registry                                                                                                                              | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                                                                           | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                | Global storage class for dynamic provisioning                                                                                                             | `nil`                                                   |
| `global.minio.existingSecret`        | Name of existing secret to use for MinIO&reg; credentials (overrides `existingSecret`)                                                                    | `nil`                                                   |
| `global.minio.accessKey`             | MinIO&reg; Access Key (overrides `accessKey.password`)                                                                                                    | `nil`                                                   |
| `global.minio.secretKey`             | MinIO&reg; Secret Key (overrides `secretKey.password`)                                                                                                    | `nil`                                                   |
| `commonLabels`                       | Labels to add to all deployed objects                                                                                                                     | `{}`                                                    |
| `commonAnnotations`                  | Annotations to add to all deployed objects                                                                                                                | `{}`                                                    |
| `kubeVersion`                        | Force target Kubernetes version (using Helm capabilities if not set)                                                                                      | `nil`                                                   |
| `extraDeploy`                        | Array of extra objects to deploy with the release                                                                                                         | `[]` (evaluated as a template)                          |
| `image.registry`                     | MinIO&reg; image registry                                                                                                                                 | `docker.io`                                             |
| `image.repository`                   | MinIO&reg; image name                                                                                                                                     | `bitnami/minio`                                         |
| `image.tag`                          | MinIO&reg; image tag                                                                                                                                      | `{TAG_NAME}`                                            |
| `image.pullPolicy`                   | Image pull policy                                                                                                                                         | `IfNotPresent`                                          |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                        | Specify if debug logs should be enabled                                                                                                                   | `false`                                                 |
| `nameOverride`                       | String to partially override common.names.fullname template with a string (will prepend the release name)                                                 | `nil`                                                   |
| `fullnameOverride`                   | String to fully override common.names.fullname template with a string                                                                                     | `nil`                                                   |
| `schedulerName`                      | Specifies the schedulerName, if it's nil uses kube-scheduler                                                                                              | `nil`                                                   |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                                                                                      | `true`                                                  |
| `serviceAccount.name`                | If serviceAccount.create is enabled, what should the serviceAccount name be - otherwise defaults to the fullname                                          | `nil`                                                   |
| `clusterDomain`                      | Kubernetes cluster domain                                                                                                                                 | `cluster.local`                                         |
| `hostAliases`                        | Add deployment host aliases                                                                                                                               | `[]`                                                    |
| `clientImage.registry`               | MinIO&reg; Client image registry                                                                                                                          | `docker.io`                                             |
| `clientImage.repository`             | MinIO&reg; Client image name                                                                                                                              | `bitnami/minio-client`                                  |
| `clientImage.tag`                    | MinIO&reg; Client image tag                                                                                                                               | `{TAG_NAME}`                                            |
| `volumePermissions.enabled`          | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`   | Init container volume-permissions image registry                                                                                                          | `docker.io`                                             |
| `volumePermissions.image.repository` | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`        | Init container volume-permissions image tag                                                                                                               | `"10"`                                                  |
| `volumePermissions.image.pullPolicy` | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                |
| `volumePermissions.resources`        | Init container resource requests/limit                                                                                                                    | `nil`                                                   |
| `mode`                               | MinIO&reg; server mode (`standalone` or `distributed`)                                                                                                    | `standalone`                                            |
| `statefulset.replicaCount`           | Number of pods (only for Minio distributed mode). Should be 4 <= x <= 32                                                                                  | `4`                                                     |
| `statefulset.updateStrategy`         | Statefulset update strategy policy                                                                                                                        | `RollingUpdate`                                         |
| `statefulset.podManagementpolicy`    | Statefulset pods management policy                                                                                                                        | `Parallel`                                              |
| `deployment.updateStrategy`          | Deployment update strategy policy                                                                                                                         | `Recreate`                                              |
| `existingSecret`                     | Existing secret with MinIO&reg; credentials                                                                                                               | `nil`                                                   |
| `useCredentialsFile`                 | Have the secret mounted as a file instead of env vars                                                                                                     | `false`                                                 |
| `forceNewKeys`                       | Force admin credentials (access and secret key) to be reconfigured every time they change in the secrets                                                  | `false`                                                 |
| `accessKey.password`                 | MinIO&reg; Access Key. Ignored if existing secret is provided.                                                                                            | _random 10 character alphanumeric string_               |
| `accessKey.forcePassword`            | Force users to specify an Access Key                                                                                                                      | `false`                                                 |
| `secretKey.password`                 | MinIO&reg; Secret Key. Ignored if existing secret is provided.                                                                                            | _random 40 character alphanumeric string_               |
| `secretKey.forcePassword`            | Force users to specify an Secret Key                                                                                                                      | `false`                                                 |
| `defaultBuckets`                     | Comma, semi-colon or space separated list of buckets to create (only in standalone mode)                                                                  | `nil`                                                   |
| `disableWebUI`                       | Disable MinIO&reg; Web UI                                                                                                                                 | `false`                                                 |
| `extraEnv`                           | Any extra environment variables you would like to pass to the pods                                                                                        | `{}`                                                    |
| `command`                            | Command for the minio container                                                                                                                           | `{}`                                                    |
| `resources`                          | Minio containers' resources                                                                                                                               | `{}`                                                    |
| `podAnnotations`                     | Pod annotations                                                                                                                                           | `{}`                                                    |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                                                    |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `soft`                                                  |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                 | `""`                                                    |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set.                                                                                                    | `""`                                                    |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                                                                 | `[]`                                                    |
| `affinity`                           | Affinity for pod assignment                                                                                                                               | `{}` (evaluated as a template)                          |
| `nodeSelector`                       | Node labels for pod assignment                                                                                                                            | `{}` (evaluated as a template)                          |
| `tolerations`                        | Tolerations for pod assignment                                                                                                                            | `[]` (evaluated as a template)                          |
| `securityContext.enabled`            | Enable security context                                                                                                                                   | `true`                                                  |
| `securityContext.fsGroup`            | Group ID for the container                                                                                                                                | `1001`                                                  |
| `securityContext.runAsUser`          | User ID for the container                                                                                                                                 | `1001`                                                  |
| `livenessProbe.enabled`              | Enable/disable the Liveness probe                                                                                                                         | `true`                                                  |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                                  | `60`                                                    |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                                                                                            | `10`                                                    |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                                                                                  | `5`                                                     |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.                                                              | `1`                                                     |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `6`                                                     |
| `readinessProbe.enabled`             | Enable/disable the Readiness probe                                                                                                                        | `true`                                                  |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                                                                                 | `5`                                                     |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                                                                                            | `10`                                                    |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                                                                                  | `5`                                                     |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `6`                                                     |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed.                                                              | `1`                                                     |
| `tls.enabled`                        | Enable tls in front of the container                                                                                                                      | `true`                                                  |
| `tls.secretName`                     | The name of the secret containing the certificates and key.                                                                                               | `nil`                                                   |
| `persistence.enabled`                | Use a PVC to persist data                                                                                                                                 | `true`                                                  |
| `persistence.mountPath`              | Path to mount the volume at                                                                                                                               | `/data`                                                 |
| `persistence.storageClass`           | Storage class of backing PVC                                                                                                                              | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`             | Use volume as ReadOnly or ReadWrite                                                                                                                       | `ReadWriteOnce`                                         |
| `persistence.size`                   | Size of data volume                                                                                                                                       | `8Gi`                                                   |
| `persistence.annotations`            | Persistent Volume annotations                                                                                                                             | `{}`                                                    |
| `persistence.existingClaim`          | Name of an existing PVC to use (only in "standalone" mode)                                                                                                | `nil`                                                   |
| `service.type`                       | Kubernetes Service type                                                                                                                                   | `ClusterIP`                                             |
| `service.port`                       | MinIO&reg; service port                                                                                                                                   | `9000`                                                  |
| `service.nodePort`                   | Port to bind to for NodePort service type                                                                                                                 | `nil`                                                   |
| `service.loadBalancerIP`             | Static IP Address to use for LoadBalancer service type                                                                                                    | `nil`                                                   |
| `service.annotations`                | Kubernetes service annotations                                                                                                                            | `{}`                                                    |
| `ingress.enabled`                    | Enable ingress controller resource                                                                                                                        | `false`                                                 |
| `ingress.certManager`                | Add annotations for cert-manager                                                                                                                          | `false`                                                 |
| `ingress.hostname`                   | Default host for the ingress resource                                                                                                                     | `minio.local`                                           |
| `ingress.path`                       | Default path for the ingress resource                                                                                                                     | `/`                                                     |
| `ingress.tls`                        | Create TLS Secret                                                                                                                                         | `false`                                                 |
| `ingress.annotations`                | Ingress annotations                                                                                                                                       | `[]` (evaluated as a template)                          |
| `ingress.extraHosts[0].name`         | Additional hostnames to be covered                                                                                                                        | `nil`                                                   |
| `ingress.extraHosts[0].path`         | Additional hostnames to be covered                                                                                                                        | `nil`                                                   |
| `ingress.extraPaths`                 | Additional arbitrary path/backend objects                                                                                                                 | `nil`                                                   |
| `ingress.extraTls[0].hosts[0]`       | TLS configuration for additional hostnames to be covered                                                                                                  | `nil`                                                   |
| `ingress.extraTls[0].secretName`     | TLS configuration for additional hostnames to be covered                                                                                                  | `nil`                                                   |
| `ingress.secrets[0].name`            | TLS Secret Name                                                                                                                                           | `nil`                                                   |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                                                                                                                    | `nil`                                                   |
| `ingress.secrets[0].key`             | TLS Secret Key                                                                                                                                            | `nil`                                                   |
| `networkPolicy.enabled`              | Enable NetworkPolicy                                                                                                                                      | `false`                                                 |
| `networkPolicy.allowExternal`        | Don't require client label for connections                                                                                                                | `true`                                                  |
| `prometheusAuthType`                 | Authentication mode for Prometheus (`jwt` or `public`)                                                                                                    | `public`                                                |

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

You can start the MinIO&reg; chart in distributed mode with the following parameter: `mode=distributed`

This chart sets Minio server in distributed mode with 4 nodes by default. You can change the number of nodes setting the `statefulset.replicaCount` parameter, for example to `statefulset.replicaCount=8`

> Note: that the number of replicas must even, greater than 4 and lower than 32

### Prometheus exporter

MinIO&reg; exports Prometheus metrics at `/minio/prometheus/metrics`. To allow Prometheus collecting your MinIO&reg; metrics, modify the `values.yaml` adding the corresponding annotations:

```diff
- podAnnotations: {}
+ podAnnotations:
+   prometheus.io/scrape: "true"
+   prometheus.io/path: "/minio/prometheus/metrics"
+   prometheus.io/port: "9000"
```

> Find more information about MinIO&reg; metrics at https://docs.min.io/docs/how-to-monitor-minio-using-prometheus.html

## Persistence

The [Bitnami MinIO&reg;](https://github.com/bitnami/bitnami-docker-minio) image stores data at the `/data` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

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
