<!--- app-name: InfluxDB&trade; InfluxDB&trade; Core -->

# Bitnami Stack for InfluxDB&trade; Core

InfluxDB&trade; Core is an open source time-series database. It is a core component of the FDAP (Apache Flight, DataFusion, Arrow, and Parquet) stack.

[Overview of InfluxDB&trade; InfluxDB&trade; Core](https://www.influxdata.com/products/influxdb-overview)

InfluxDB&trade; is a trademark owned by InfluxData, which is not affiliated with, and does not endorse, this site.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/influxdb
```

Looking to use InfluxDB&trade; Core in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [influxdb](https://github.com/bitnami/containers/tree/main/bitnami/influxdb) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/influxdb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy influxdb on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Configure the way how to expose InfluxDB&trade; Core

This chart installs a deployment with the following configuration:

```text
                ------------------
               |     Ingress      |
               |    Controller    |
                ------------------
                        |
                        | /query
                        | /write
                        \/
                 ----------------
                |  InfluxDB(TM)  |
                |      svc       |
                 ----------------
                        |
                        \/
                  --------------
                 | InfluxDB(TM) |
                 |    Server    |
                 |     Pod      |
                  --------------
```

- **Ingress**: The ingress controller must be installed in the Kubernetes cluster. Set `ingress.enabled=true` to expose InfluxDB&trade; Core through Ingress.
- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster. Set `service.type=ClusterIP` to choose this service type.
- **NodePort**: Exposes the service on each Node's IP at a static port (the NodePort). You'll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`. Set `service.type=NodePort` to choose this service type.
- **LoadBalancer**: Exposes the service externally using a cloud provider's load balancer. Set `service.type=LoadBalancer` to choose this service type.

### Configure the Object Store

InfluxDB&trade; Core supports different storage systems to store Parquet files (refer to [upstream documentation](https://docs.influxdata.com/influxdb3/core/reference/config-options/#object-store) for more information about the supported object stores) that we can divide into three categories:

- Memory: This is the default object store. It stores all data in memory and is not persistent. This is suitable for testing and development purposes.
- File: This object store stores data in files on the local filesystem.
- Cloud: This object store stores data in a cloud provider's object storage service (e.g., AWS S3, Google Cloud Storage, Azure Blob Storage).

This chart allows you to configure the object store using the `objectStore` parameter. If you're using a Cloud storage, there are additional parameters to configure such as the Cloud specific credentials or the bucket name.

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Update credentials

This chart supports creating a random admin token at first boot (not supported when using `memory` as object store) by setting both the `auth.enabled` and `createAdminTokenJob.enabled` parameters to `true`.
As an alternative, the chart also supports consuming credentials from an existing secret by setting the `auth.existingSecret` and `auth.existingSecretAdminTokenKey` parameters. However, please note that this is only supported if you have pre-populated data in your object store with an admin token already created.

Any further change in the credentials require manual intervention, pleaser refer instructions below:

- Create an admin token following [the upstream documentation](https://docs.influxdata.com/influxdb3/core/admin/tokens/admin/create) if no admin token was created during the first boot.
- Regenerate the admin token following [the upstream documentation](https://docs.influxdata.com/influxdb3/core/admin/tokens/admin/regenerate).

> Note: please ensure you update the token in the secret used by the chart if you regenerate the token.

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will add the required annotations on InfluxDB&trade; Core service to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Adding extra environment variables

In case you want to add extra environment variables, you can use the `influxdb.extraEnvVars` property.

```yaml
extraEnvVars:
  - name: INFLUXDB_DATA_QUERY_LOG_ENABLED
    value: "true"
```

### Initialize a fresh instance

The [Bitnami InfluxDB&trade; Core](https://github.com/bitnami/containers/tree/main/bitnami/influxdb) image allows you to use your custom scripts to initialize a fresh instance (hhe allowed extension is `.sh`). In order to execute the scripts, you can specify custom scripts using the `initdbScripts` parameter.

In addition to this option, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsCM` parameter. Note that this will override the two previous options. parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

When using `file` as object store, data can be persisted by default using PVC(s). You can disable the persistence setting the `persistence.enabled` parameter to `false`.

A default `StorageClass` is needed in the Kubernetes cluster to dynamically provision the volumes. Specify another StorageClass in the `persistence.storageClass` or set `persistence.existingClaim` if you have already existing persistent volumes to use.

### Adjust permissions of persistent volume mountpoint

As the images run as non-root by default, it is necessary to adjust the ownership of the persistent volumes so that the containers can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions. As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination. You can enable this **initContainer** by setting `defaultInitContainers.volumePermissions.enabled` to `true`.

There are K8s distribution, such as OpenShift, where you can dynamically define the UID to run this **initContainer**. To do so, set the `defaultInitContainers.volumePermissions.securityContext.runAsUser` to `auto`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.defaultStorageClass`                          | Global default StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                | `""`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `apiVersions`            | Override Kubernetes API versions reported by .Capabilities                              | `[]`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `usePasswordFiles`       | Mount credentials as files instead of using environment variables                       | `true`          |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the chart release                                 | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the chart release                                    | `["infinity"]`  |

### InfluxDB(TM) Core parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                      |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `image.registry`                                    | InfluxDB(TM) Core image registry                                                                                                                                                                                  | `REGISTRY_NAME`            |
| `image.repository`                                  | InfluxDB(TM) Core image repository                                                                                                                                                                                | `REPOSITORY_NAME/influxdb` |
| `image.digest`                                      | InfluxDB(TM) Core image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                 | `""`                       |
| `image.pullPolicy`                                  | InfluxDB(TM) Core image pull policy                                                                                                                                                                               | `IfNotPresent`             |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                  | `[]`                       |
| `image.debug`                                       | Specify if debug logs should be enabled                                                                                                                                                                           | `false`                    |
| `auth.enabled`                                      | Enable bearer token authentication on InfluxDB(TM) Core server                                                                                                                                                    | `true`                     |
| `auth.existingSecret`                               | Name of existing Secret containing the admin token (only supported if store data is pre-populated)                                                                                                                | `""`                       |
| `auth.existingSecretAdminTokenKey`                  | Name of the key inside the existing secret containing the admin token (admin-token as default if not provided)                                                                                                    | `""`                       |
| `tls.enabled`                                       | Enable TLS configuration for InfluxDB(TM) Core                                                                                                                                                                    | `false`                    |
| `tls.autoGenerated.enabled`                         | Enable automatic generation of TLS certificates                                                                                                                                                                   | `true`                     |
| `tls.autoGenerated.engine`                          | Mechanism to generate the certificates (allowed values: helm, cert-manager)                                                                                                                                       | `helm`                     |
| `tls.autoGenerated.certManager.existingIssuer`      | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine)                                                                                                            | `""`                       |
| `tls.autoGenerated.certManager.existingIssuerKind`  | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                                                                                                                                         | `""`                       |
| `tls.autoGenerated.certManager.keyAlgorithm`        | Key algorithm for the certificates (only for `cert-manager` engine)                                                                                                                                               | `RSA`                      |
| `tls.autoGenerated.certManager.keySize`             | Key size for the certificates (only for `cert-manager` engine)                                                                                                                                                    | `2048`                     |
| `tls.autoGenerated.certManager.duration`            | Duration for the certificates (only for `cert-manager` engine)                                                                                                                                                    | `2160h`                    |
| `tls.autoGenerated.certManager.renewBefore`         | Renewal period for the certificates (only for `cert-manager` engine)                                                                                                                                              | `360h`                     |
| `tls.ca`                                            | CA certificate for TLS. Ignored if `tls.existingCASecret` is set                                                                                                                                                  | `""`                       |
| `tls.existingCASecret`                              | The name of an existing Secret containing the CA certificate for TLS                                                                                                                                              | `""`                       |
| `tls.server.cert`                                   | TLS certificate for InfluxDB(TM) Core servers. Ignored if `tls.server.existingSecret` is set                                                                                                                      | `""`                       |
| `tls.server.key`                                    | TLS key for InfluxDB(TM) Core servers. Ignored if `tls.server.existingSecret` is set                                                                                                                              | `""`                       |
| `tls.server.existingSecret`                         | The name of an existing Secret containing the TLS certificates for InfluxDB(TM) Core servers                                                                                                                      | `""`                       |
| `objectStore`                                       | InfluxDB(TM) Core object storage                                                                                                                                                                                  | `memory`                   |
| `nodeId`                                            | InfluxDB(TM) Core node id                                                                                                                                                                                         | `0`                        |
| `databases`                                         | Comma separated list of databases to create (ignored if `objectStore` is set to `memory`)                                                                                                                         | `""`                       |
| `bucket`                                            | Name of the bucket to create (only when using a Cloud Provider for object storage)                                                                                                                                | `""`                       |
| `s3.auth.accessKeyId`                               | AWS S3 access key id                                                                                                                                                                                              | `""`                       |
| `s3.auth.secretAccessKey`                           | AWS S3 secret access key                                                                                                                                                                                          | `""`                       |
| `s3.auth.existingSecret`                            | Name of existing Secret containing AWS S3 credentials (overrides `s3.credentials.accessKeyId` and `s3.credentials.secretAccessKey`)                                                                               | `""`                       |
| `s3.defaultRegion`                                  | AWS S3 default region                                                                                                                                                                                             | `us-east-1`                |
| `s3.endpoint`                                       | AWS S3 endpoint                                                                                                                                                                                                   | `""`                       |
| `google.auth.serviceAccountKey`                     | Google Cloud service account key (JSON format)                                                                                                                                                                    | `""`                       |
| `google.auth.existingSecret`                        | Name of existing Secret containing Google Cloud credentials (overrides `google.auth.serviceAccountKey`)                                                                                                           | `""`                       |
| `azure.auth.accessKey`                              | Microsoft Azure access key                                                                                                                                                                                        | `""`                       |
| `azure.auth.existingSecret`                         | Name of existing Secret containing Azure credentials (overrides `azure.credentials.accessKey`)                                                                                                                    | `""`                       |
| `azure.account`                                     | Microsoft Azure account name                                                                                                                                                                                      | `""`                       |
| `replicaCount`                                      | Number of InfluxDB(TM) Core replicas (ignored if `objectStore` is set to `file` or `memory`)                                                                                                                      | `1`                        |
| `initdbScripts`                                     | Dictionary of initdb scripts                                                                                                                                                                                      | `{}`                       |
| `initdbScriptsCM`                                   | Name of existing ConfigMap object with the initdb scripts (`initdbScripts` will be ignored).                                                                                                                      | `""`                       |
| `initdbScriptsSecret`                               | Secret with initdb scripts that contain sensitive information (Note: can be used with `initdbScriptsConfigMap` or `initdbScripts`)                                                                                | `""`                       |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                              | `[]`                       |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                 | `[]`                       |
| `extraEnvVars`                                      | Array with extra environment variables to add InfluxDB(TM) Core nodes                                                                                                                                             | `[]`                       |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for InfluxDB(TM) Core nodes                                                                                                                                  | `""`                       |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for InfluxDB(TM) Core nodes                                                                                                                                     | `""`                       |
| `containerPorts.http`                               | InfluxDB(TM) Core container HTTP port                                                                                                                                                                             | `8181`                     |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for InfluxDB(TM) Core nodes                                                                                                                                     | `[]`                       |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `small`                    |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                       |
| `podSecurityContext.enabled`                        | Enable InfluxDB(TM) Core pods' Security Context                                                                                                                                                                   | `true`                     |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                   |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                       |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                       |
| `podSecurityContext.fsGroup`                        | Set InfluxDB(TM) Core pod's Security Context fsGroup                                                                                                                                                              | `1001`                     |
| `containerSecurityContext.enabled`                  | Enable InfluxDB(TM) Core containers' Security Context                                                                                                                                                             | `true`                     |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                       |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                     |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                     |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`                     |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`                    |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                     |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`                    |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                  |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`           |
| `startupProbe.enabled`                              | Enable startupProbe on InfluxDB(TM) Core containers                                                                                                                                                               | `false`                    |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`                       |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                       |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`                        |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `3`                        |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                        |
| `livenessProbe.enabled`                             | Enable livenessProbe on InfluxDB(TM) Core containers                                                                                                                                                              | `true`                     |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `10`                       |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                       |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`                        |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `3`                        |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                        |
| `readinessProbe.enabled`                            | Enable readinessProbe on InfluxDB(TM) Core containers                                                                                                                                                             | `true`                     |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `10`                       |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                       |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                        |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `3`                        |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                        |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                       |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                       |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                       |
| `podAffinityPreset`                                 | InfluxDB(TM) Core Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                             | `""`                       |
| `podAntiAffinityPreset`                             | InfluxDB(TM) Core Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                        | `soft`                     |
| `nodeAffinityPreset.type`                           | InfluxDB(TM) Core Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                       | `""`                       |
| `nodeAffinityPreset.key`                            | InfluxDB(TM) Core Node label key to match Ignored if `affinity` is set.                                                                                                                                           | `""`                       |
| `nodeAffinityPreset.values`                         | InfluxDB(TM) Core Node label values to match. Ignored if `affinity` is set.                                                                                                                                       | `[]`                       |
| `affinity`                                          | InfluxDB(TM) Core Affinity for pod assignment                                                                                                                                                                     | `{}`                       |
| `nodeSelector`                                      | InfluxDB(TM) Core Node labels for pod assignment                                                                                                                                                                  | `{}`                       |
| `tolerations`                                       | InfluxDB(TM) Core Tolerations for pod assignment                                                                                                                                                                  | `[]`                       |
| `podAnnotations`                                    | Annotations for InfluxDB(TM) Core pods                                                                                                                                                                            | `{}`                       |
| `podLabels`                                         | Extra labels for InfluxDB(TM) Core pods                                                                                                                                                                           | `{}`                       |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                    |
| `hostAliases`                                       | InfluxDB(TM) Core pods host aliases                                                                                                                                                                               | `[]`                       |
| `updateStrategy.type`                               | InfluxDB(TM) Core deployment strategy type                                                                                                                                                                        | `RollingUpdate`            |
| `priorityClassName`                                 | InfluxDB(TM) Core pods' priorityClassName                                                                                                                                                                         | `""`                       |
| `revisionHistoryLimit`                              | InfluxDB(TM) Core deployment revision history limit                                                                                                                                                               | `10`                       |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                       |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                       |
| `lifecycleHooks`                                    | for the InfluxDB(TM) Core container(s) to automate configuration before or after startup                                                                                                                          | `{}`                       |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the InfluxDB(TM) Core pods                                                                                                                           | `[]`                       |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the InfluxDB(TM) Core pods                                                                                                                                | `[]`                       |
| `sidecars`                                          | Add additional sidecar containers to the InfluxDB(TM) Core pod(s)                                                                                                                                                 | `[]`                       |
| `initContainers`                                    | Add additional init-containers to the InfluxDB(TM) Core pod(s)                                                                                                                                                    | `[]`                       |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation for InfluxDB(TM) Core pods                                                                                                                                        | `true`                     |
| `pdb.minAvailable`                                  | Minimum number/percentage of InfluxDB(TM) Core pods that should remain scheduled                                                                                                                                  | `""`                       |
| `pdb.maxUnavailable`                                | Maximum number/percentage of InfluxDB(TM) Core pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                  | `""`                       |
| `autoscaling.vpa.enabled`                           | Enable VPA for InfluxDB(TM) Core                                                                                                                                                                                  | `false`                    |
| `autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                      | `{}`                       |
| `autoscaling.vpa.controlledResources`               | List of resources that the VPA can control. Defaults to cpu and memory                                                                                                                                            | `[]`                       |
| `autoscaling.vpa.maxAllowed`                        | VPA max allowed resources for the pod                                                                                                                                                                             | `{}`                       |
| `autoscaling.vpa.minAllowed`                        | VPA min allowed resources for the pod                                                                                                                                                                             | `{}`                       |
| `autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy                                                                                                                                                                                         | `Auto`                     |
| `autoscaling.hpa.enabled`                           | Enable HPA for InfluxDB(TM) Core (ignored if `objectStore` is set to `file` or `memory`)                                                                                                                          | `false`                    |
| `autoscaling.hpa.minReplicas`                       | Minimum number of replicas                                                                                                                                                                                        | `""`                       |
| `autoscaling.hpa.maxReplicas`                       | Maximum number of replicas                                                                                                                                                                                        | `""`                       |
| `autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                 | `""`                       |
| `autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                              | `""`                       |

### Exposing parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | Kubernetes service type                                                                                                          | `ClusterIP`              |
| `service.ports.http`                    | InfluxDB(TM) Core HTTP port                                                                                                      | `8181`                   |
| `service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`                     |
| `service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                     | InfluxDB(TM) Core service Cluster IP                                                                                             | `""`                     |
| `service.loadBalancerIP`                | InfluxDB(TM) Core service Load Balancer IP                                                                                       | `""`                     |
| `service.loadBalancerSourceRanges`      | InfluxDB(TM) service Load Balancer sources                                                                                       | `[]`                     |
| `service.externalTrafficPolicy`         | InfluxDB(TM) Core service external traffic policy                                                                                | `Cluster`                |
| `service.extraPorts`                    | Extra port to expose on InfluxDB(TM) Core service                                                                                | `[]`                     |
| `service.annotations`                   | Additional custom annotations for InfluxDB(TM) Core service                                                                      | `{}`                     |
| `ingress.enabled`                       | Enable ingress record generation for InfluxDB(TM) Core                                                                           | `false`                  |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress record                                                                                              | `influxdb.local`         |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |

### Metrics parameters

| Name                                       | Description                                                                                            | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ------- |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                  | `{}`    |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                     | `[]`    |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                              | `[]`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                    | `{}`    |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |

### Persistence parameters

| Name                        | Description                                                                                                                                    | Value               |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable InfluxDB(TM) Core data persistence (ignored unless `objectStore` is set to `file`)                                                      | `true`              |
| `persistence.existingClaim` | A manually managed Persistent Volume and Claim                                                                                                 | `""`                |
| `persistence.storageClass`  | PVC Storage Class for InfluxDB(TM) Core data volume                                                                                            | `""`                |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                                                                 | `["ReadWriteOnce"]` |
| `persistence.size`          | PVC Storage Request for InfluxDB(TM) Core data volume                                                                                          | `8Gi`               |
| `persistence.dataSource`    | Custom PVC data source                                                                                                                         | `{}`                |
| `persistence.annotations`   | Additional custom annotations for the PVC                                                                                                      | `{}`                |
| `persistence.selector`      | Selector to match an existing Persistent Volume for InfluxDB(TM) Core data PVC. If set, the PVC can't have a PV dynamically provisioned for it | `{}`                |
| `persistence.mountPath`     | Mount path of the InfluxDB(TM) Core data volume                                                                                                | `/bitnami/influxdb` |

### Default init-containers

| Name                                                                                        | Description                                                                                                                                                                                                                                                                                                                            | Value                      |
| ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `defaultInitContainers.volumePermissions.enabled`                                           | Enable init-container that changes the owner and group of the persistent volume                                                                                                                                                                                                                                                        | `false`                    |
| `defaultInitContainers.volumePermissions.image.registry`                                    | "volume-permissions" init-containers' image registry                                                                                                                                                                                                                                                                                   | `REGISTRY_NAME`            |
| `defaultInitContainers.volumePermissions.image.repository`                                  | "volume-permissions" init-containers' image repository                                                                                                                                                                                                                                                                                 | `REPOSITORY_NAME/os-shell` |
| `defaultInitContainers.volumePermissions.image.digest`                                      | "volume-permissions" init-containers' image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                                                                  | `""`                       |
| `defaultInitContainers.volumePermissions.image.pullPolicy`                                  | "volume-permissions" init-containers' image pull policy                                                                                                                                                                                                                                                                                | `IfNotPresent`             |
| `defaultInitContainers.volumePermissions.image.pullSecrets`                                 | "volume-permissions" init-containers' image pull secrets                                                                                                                                                                                                                                                                               | `[]`                       |
| `defaultInitContainers.volumePermissions.containerSecurityContext.enabled`                  | Enable "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                                          | `true`                     |
| `defaultInitContainers.volumePermissions.containerSecurityContext.seLinuxOptions`           | Set SELinux options in "volume-permissions" init-containers                                                                                                                                                                                                                                                                            | `{}`                       |
| `defaultInitContainers.volumePermissions.containerSecurityContext.runAsUser`                | Set runAsUser in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                                | `0`                        |
| `defaultInitContainers.volumePermissions.containerSecurityContext.privileged`               | Set privileged in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                               | `false`                    |
| `defaultInitContainers.volumePermissions.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                 | `false`                    |
| `defaultInitContainers.volumePermissions.containerSecurityContext.capabilities.add`         | List of capabilities to be added in "volume-permissions" init-containers                                                                                                                                                                                                                                                               | `[]`                       |
| `defaultInitContainers.volumePermissions.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in "volume-permissions" init-containers                                                                                                                                                                                                                                                             | `["ALL"]`                  |
| `defaultInitContainers.volumePermissions.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in "volume-permissions" init-containers                                                                                                                                                                                                                                                                            | `RuntimeDefault`           |
| `defaultInitContainers.volumePermissions.resourcesPreset`                                   | Set InfluxDB(TM) Core "volume-permissions" init-container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if defaultInitContainers.volumePermissions.resources is set (defaultInitContainers.volumePermissions.resources is recommended for production). | `nano`                     |
| `defaultInitContainers.volumePermissions.resources`                                         | Set InfluxDB(TM) Core "volume-permissions" init-container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                                                          | `{}`                       |

### Other Parameters

| Name                                          | Description                                                                                | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------ | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for InfluxDB(TM) Core pods                               | `true`  |
| `serviceAccount.name`                         | Name of the service account to use. If not set and `create` is `true`, a name is generated | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created                     | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                       | `{}`    |
| `rbac.create`                                 | Whether to create & use RBAC resources or not                                              | `true`  |

### InfluxDB(TM) Core "create-admin-token" K8s Job parameters

| Name                                                                    | Description                                                                                                                                                                                                                                                                                            | Value                      |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------- |
| `createAdminTokenJob.enabled`                                           | Whether to create a random admin token using a K8s job (ignored if `objectStore` is set to `memory` or `auth.enabled` is set to `false`). Warning: do not use this feature if Helm hooks aren't supported in your environment                                                                          | `true`                     |
| `createAdminTokenJob.image.registry`                                    | Kubectl image registry                                                                                                                                                                                                                                                                                 | `REGISTRY_NAME`            |
| `createAdminTokenJob.image.repository`                                  | Kubectl image repository                                                                                                                                                                                                                                                                               | `REPOSITORY_NAME/os-shell` |
| `createAdminTokenJob.image.digest`                                      | Kubectl image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                                                                | `""`                       |
| `createAdminTokenJob.image.pullPolicy`                                  | Kubectl image pull policy                                                                                                                                                                                                                                                                              | `IfNotPresent`             |
| `createAdminTokenJob.image.pullSecrets`                                 | Kubectl image pull secrets                                                                                                                                                                                                                                                                             | `[]`                       |
| `createAdminTokenJob.backoffLimit`                                      | set backoff limit of the job                                                                                                                                                                                                                                                                           | `10`                       |
| `createAdminTokenJob.containerSecurityContext.enabled`                  | Enable InfluxDB(TM) Core "create-admin-token" job's containers' Security Context                                                                                                                                                                                                                       | `true`                     |
| `createAdminTokenJob.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                                                                       | `{}`                       |
| `createAdminTokenJob.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                                                                             | `1001`                     |
| `createAdminTokenJob.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                                                                            | `1001`                     |
| `createAdminTokenJob.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                                                                          | `true`                     |
| `createAdminTokenJob.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                                                                            | `false`                    |
| `createAdminTokenJob.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                                                                                | `true`                     |
| `createAdminTokenJob.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                                                                              | `false`                    |
| `createAdminTokenJob.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                                                                     | `["ALL"]`                  |
| `createAdminTokenJob.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                                                                       | `RuntimeDefault`           |
| `createAdminTokenJob.resourcesPreset`                                   | Set InfluxDB(TM) Core "create-admin-token" job's container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if createAdminTokenJob.resources is set (createAdminTokenJob.resources is recommended for production). | `nano`                     |
| `createAdminTokenJob.resources`                                         | Set InfluxDB(TM) Core "create-admin-token" job's container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                         | `{}`                       |
| `createAdminTokenJob.automountServiceAccountToken`                      | Mount Service Account token in InfluxDB(TM) Core "create-admin-token" job's pods                                                                                                                                                                                                                       | `true`                     |
| `createAdminTokenJob.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                                                                                            | `[]`                       |
| `createAdminTokenJob.annotations`                                       | Add annotations to the InfluxDB(TM) Core "create-admin-token" job                                                                                                                                                                                                                                      | `{}`                       |
| `createAdminTokenJob.podLabels`                                         | Additional pod labels for InfluxDB(TM) Core "create-admin-token" job                                                                                                                                                                                                                                   | `{}`                       |
| `createAdminTokenJob.podAnnotations`                                    | Additional pod annotations for InfluxDB(TM) Core "create-admin-token" job                                                                                                                                                                                                                              | `{}`                       |
| `createAdminTokenJob.topologyKey`                                       | Override common lib default topology key. If empty - "kubernetes.io/hostname" is used                                                                                                                                                                                                                  | `""`                       |
| `createAdminTokenJob.affinity`                                          | Affinity for InfluxDB(TM) Core create-admin-token pods assignment (evaluated as a template)                                                                                                                                                                                                            | `{}`                       |
| `createAdminTokenJob.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `createAdminTokenJob.affinity` is set.                                                                                                                                                                                                                             | `""`                       |
| `createAdminTokenJob.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `createAdminTokenJob.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                                          | `""`                       |
| `createAdminTokenJob.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `createAdminTokenJob.affinity` is set.                                                                                                                                                                                                                          | `[]`                       |
| `createAdminTokenJob.nodeSelector`                                      | Node labels for InfluxDB(TM) Core create-admin-token pods assignment                                                                                                                                                                                                                                   | `{}`                       |
| `createAdminTokenJob.podAffinityPreset`                                 | Pod affinity preset. Ignored if `createAdminTokenJob.affinity` is set. Allowed values: `soft` or `hard`.                                                                                                                                                                                               | `""`                       |
| `createAdminTokenJob.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `createAdminTokenJob.affinity` is set. Allowed values: `soft` or `hard`.                                                                                                                                                                                          | `soft`                     |
| `createAdminTokenJob.tolerations`                                       | Tolerations for InfluxDB(TM) Core create-admin-token pods assignment                                                                                                                                                                                                                                   | `[]`                       |
| `createAdminTokenJob.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                                                                                               | `[]`                       |
| `createAdminTokenJob.priorityClassName`                                 | Priority Class Name                                                                                                                                                                                                                                                                                    | `""`                       |
| `createAdminTokenJob.schedulerName`                                     | Use an alternate scheduler, e.g. "stork".                                                                                                                                                                                                                                                              | `""`                       |
| `createAdminTokenJob.terminationGracePeriodSeconds`                     | Seconds InfluxDB(TM) Core create-admin-token pod needs to terminate gracefully                                                                                                                                                                                                                         | `""`                       |
| `createAdminTokenJob.serviceAccount.create`                             | Enable creation of ServiceAccount for InfluxDB(TM) Core create-admin-token pods                                                                                                                                                                                                                        | `true`                     |
| `createAdminTokenJob.serviceAccount.name`                               | Name of the service account to use. If not set and `create` is `true`, a name is generated                                                                                                                                                                                                             | `""`                       |
| `createAdminTokenJob.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                                                                                                 | `true`                     |
| `createAdminTokenJob.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                                                                                   | `{}`                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set objectStore=file \
    oci://REGISTRY_NAME/REPOSITORY_NAME/influxdb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the InfluxDB&trade; Core object store to `file`. Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/influxdb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/influxdb/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 7.0.0

This chart major version bumps the InfluxDB&trade; major version to `3.x` series. Please note InfluxDB&trade; Core 3 uses a completely different architecture and data engine (moving from TSM to Apache Arrow and Parquet stored on S3-compatible systems). Due to these architecture changes, the chart will be exclusively compatible with `3.x` container images from now on.

There's no upgrade path from previous release. Quoting [this upstream blog post](https://www.influxdata.com/blog/influxdb-3-oss-ga/):

> Since InfluxDB 3 Core is designed specifically for recent data (72 hours), our recommendation for migration is to mirror writes from older versions to a new InfluxDB 3 Core instance for a transition period, then switch over entirely after 72 hours.

On this major version we also removed support for overriding configuration via configuration files, given InfluxDB&trade; Core 3 is designed to be configured via CLI flags and environment variables exclusively. Backup jobs were also removed, as store should be managed by the object store in the new architecture.

Finally, this major version drops support for authentication based on users / password. Instead, a single admin token is used to authenticate every request.

### To 6.5.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

It's necessary to specify the existing passwords while performing an upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `auth.admin.password`, `user.pwd`, `auth.readUser.password` and `auth.writeUser.password` parameters when upgrading the chart:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/influxdb \
    --set auth.admin.password=[ADMIN_USER_PASSWORD] \
    --set auth.user.password=[USER_PASSWORD] \
    --set auth.readUser.password=[READ_USER_PASSWORD] \
    --set auth.writeUser.password=[WRITE_USER_PASSWORD]
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> Note: you need to substitute the placeholders _[ADMIN_USER_PASSWORD]_, _[USER_PASSWORD]_, _[READ_USER_PASSWORD]_, and _[WRITE_USER_PASSWORD]_ with the values obtained from instructions in the installation notes.

### To 6.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 5.0.0

This major release completely removes support for InfluxDB Relay&trade; because the component is [no longer maintained](https://github.com/influxdata/influxdb-relay/issues/81#issuecomment-824207830) by the original developers. As a consequence, the "high-availability" architecture feature is no longer supported.

To update from the previous major, please follow this steps:

```console
kubectl delete deployments.apps influxdb
helm upgrade influxdb oci://REGISTRY_NAME/REPOSITORY_NAME/influxdb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 4.0.0

This major release completely removes support for InfluxDB&trade; branch 1.x.x. You can use images for versions ~1.x.x taking into account the chart may need some modification to run with them.

If you were using InfluxDB&trade; +2.0 no issues are expected during upgrade.

### To 3.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `influxdb.service.port` was deprecated, we recommend using `influxdb.service.ports.http` instead.
- `influxdb.service.rpcPort` was deprecated, we recommend using `influxdb.service.ports.rpc` instead.
- `relay.service.port` was deprecated, we recommend using `relay.service.ports.http` instead.
- `relay.service.nodePort` was renamed as `relay.service.nodePorts.http`.
- `influxdb.securityContext` split into `influxdb.containerSecurityContext` and `influxdb.podSecurityContext`.
- `relay.securityContext` split into `relay.containerSecurityContext` and `relay.podSecurityContext`.
- `influxdb.updateStrategy` and `relay.updateStrategy`changed from String type (previously default to 'rollingUpdate') to Object type, allowing users to configure other updateStrategy parameters, similar to other charts.

### To 2.0.0

This version adds support to InfluxDB&trade; +2.0, since this version the chart is only verified to work with InfluxDB&trade; +2.0 bitnami images.
However, you can use images for versions ~1.x.x taking into account the chart may need some modification to run with them.

#### Installing InfluxDB&trade; v1 in chart v2

```console
helm install oci://REGISTRY_NAME/REPOSITORY_NAME/influxdb --set image.tag=1.8.3-debian-10-r88
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

As a consecuece some breaking changes have been included in this version.

- Authentication values has been moved to `auth.<property>...`.
- We keep `auth.readUser` and `auth.writeUser` user options in order to be compatible with InfluxDB&trade; v1. If you are using InfluxDB&trade; 2.0, please, use the CLI to create user and tokens through initDb scripts at `influxdb.initdbScripts` or the UI due to we are not able to automacally provide a token for them to be used. See more [InfluxDB&trade; 2.0 auth](https://docs.influxdata.com/influxdb/v2.0/security/tokens/)
- InfluxDB&trade; 2.0 has removed database concept, now it is called Bucket so the property `database` has been also moved to `auth.user.bucket`.
- Removed support for `files/docker-entrypoint-initdb.d/*.{sh,txt}`, please use `.influxdb.initdbScripts` or `.Values.influxdb.initdbScriptsCM` instead.
- Removed support for `files/conf/influxdb.conf`, please use `.influxdb.configuration` or `.influxdb.existingConfiguration` instead.
- Removed support for `files/conf/relay.toml`, please use `.Values.relay.configuration` or `.Values.relay.existingConfiguration` instead.
- `ingress.hosts` parameter has been replaced by `ingress.hostname` and `ingress.extraHosts` that may give us a bit more flexibility.

#### Migrating form InfluxDB&trade; v1 to v2

Since this release could mean lot of concepts changes, we strongly recommend to not do it direcly using the chart upgrade. Please, read more info in their [upgrade guide](https://docs.influxdata.com/influxdb/v2.0/upgrade/v1-to-v2/).

We actually recommend to backup all the data form a previous helm release, install new release using latest version of the chart and images and then restore data following their guides.

#### Upgrading the chart form 1.x.x to 2.x.x using InfluxDB&trade; v1 images

> NOTE: Please, create a backup of your database before running any of those actions.

Having an already existing chart release called `influxdb` and deployed like

```console
helm install influxdb oci://REGISTRY_NAME/REPOSITORY_NAME/influxdb
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

##### Export secrets and required values to update

```console
export INFLUXDB_ADMIN_PASSWORD=$(kubectl get secret --namespace default influxdb -o jsonpath="{.data.admin-user-password}" | base64 -d)
```

##### Upgrade the chart release

> NOTE: Please remember to migrate all the values to its new path following the above notes, e.g: `adminUser.pwd` -> `auth.admin.password`.

```console
helm upgrade influxdb oci://REGISTRY_NAME/REPOSITORY_NAME/influxdb --set image.tag=1.8.3-debian-10-r99 \
  --set auth.admin.password=${INFLUXDB_ADMIN_PASSWORD}
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 1.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 1.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- <https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
