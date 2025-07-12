<!--- app-name: Bitnami Object Storage based on MinIO&reg; -->

# Bitnami Object Storage based on MinIO&reg;

MinIO&reg; is an object storage server, compatible with Amazon S3 cloud storage service, mainly used for storing unstructured data (such as photos, videos, log files, etc.).

[Overview of Bitnami Object Storage based on MinIO&reg;](https://min.io/)

Disclaimer: All software products, projects and company names are trademark&trade; or registered&reg; trademarks of their respective holders, and use of them does not imply any affiliation or endorsement. This software is licensed to you subject to one or more open source licenses and VMware provides the software on an AS-IS basis. MinIO&reg; is a registered trademark of the MinIO Inc. in the US and other countries. Bitnami is not affiliated, associated, authorized, endorsed by, or in any way officially connected with MinIO Inc. MinIO&reg; is licensed under GNU AGPL v3.0.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/minio
```

> Tip: Did you know that this app is also available as a Kubernetes App on the Azure Marketplace? Kubernetes Apps are the easiest way to deploy Bitnami on AKS. Click [here](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.minio-cnab) to see the listing on Azure Marketplace.

Looking to use Bitnami Object Storage based on MinIOreg; in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [MinIO&reg;](https://github.com/bitnami/containers/tree/main/bitnami/minio) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/minio
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

These commands deploy MinIO&reg; on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Update credentials

Bitnami charts configure credentials at first boot. Any further change in the secrets or credentials require manual intervention. Follow these instructions:

- Update the user password following [the upstream documentation](https://min.io/docs/minio/linux/administration/identity-access-management/minio-user-management.html)
- Update the password secret with the new values (replace the SECRET_NAME, USER and PASSWORD placeholders)

```shell
kubectl create secret generic SECRET_NAME --from-literal=root-user=USER --from-literal=root-password=PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose MinIO&reg; native Prometheus endpoint in the service. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus exporter

MinIO&reg; exports Prometheus metrics at `/minio/v2/metrics/cluster`. To allow Prometheus collecting your MinIO&reg; metrics, modify the `values.yaml` adding the corresponding annotations:

```diff
- podAnnotations: {}
+ podAnnotations:
+   prometheus.io/scrape: "true"
+   prometheus.io/path: "/minio/v2/metrics/cluster"
+   prometheus.io/port: "9000"
```

> Find more information about MinIO&reg; metrics at <https://docs.min.io/docs/how-to-monitor-minio-using-prometheus.html>

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

> Note: The total number of drives should be greater than 4 to guarantee erasure coding. Please set a combination of nodes, and drives per node that match this condition.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Securing traffic using TLS

By default, this chart assumes TLS is managed by the Ingress Controller and terminates the TLS connection in the Ingress Controller. This can be done by setting `ingress.enabled` and `ingress.tls` parameters to `true` as explained in the section above. However, it is possible to configure TLS encryption for MinIO&reg; server directly by setting `tls.enabled` parameter to `true`.

It is necessary to create a secret containing the TLS certificates and pass it to the chart via the `tls.existingCASecret` and `tls.server.existingSecret` parameters. Every secret should contain a `tls.crt` and `tls.key` keys including the certificate and key files respectively. For example: create the CA secret with the certificates files:

```console
kubectl create secret generic ca-tls-secret --from-file=./tls.crt --from-file=./tls.key
```

You can manually create the required TLS certificates or relying on the chart auto-generation capabilities. The chart supports two different ways to auto-generate the required certificates:

- Using Helm capabilities. Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `helm`.
- Relying on CertManager (please note it's required to have CertManager installed in your K8s cluster). Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `cert-manager`. Please note it's supported to use an existing Issuer/ClusterIssuer for issuing the TLS certificates by setting the `tls.autoGenerated.certManager.existingIssuer` and `tls.autoGenerated.certManager.existingIssuerKind` parameters.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: MINIO_LOG_LEVEL
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

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami Object Storage based on MinIO(&reg;)](https://github.com/bitnami/containers/tree/main/bitnami/minio) image stores data at the `/bitnami/minio/data` path of the container by default.
This can be modified with the `persistence.mountPath` value which modifies the `MINIO_DATA_DIR` environment variable of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) at this location so that data within MinIO is persistent. The volume is created using dynamic volume provisioning.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

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

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace                                              | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`      | Labels to add to all deployed objects                                                        | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                                                   | `{}`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `apiVersions`       | Override Kubernetes API versions reported by .Capabilities                                   | `[]`            |
| `clusterDomain`     | Default Kubernetes cluster domain                                                            | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                            | `[]`            |

### MinIO&reg; parameters

| Name                                               | Description                                                                                                                           | Value                          |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `image.registry`                                   | MinIO&reg; image registry                                                                                                             | `REGISTRY_NAME`                |
| `image.repository`                                 | MinIO&reg; image repository                                                                                                           | `REPOSITORY_NAME/minio`        |
| `image.digest`                                     | MinIO&reg; image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                            | `""`                           |
| `image.pullPolicy`                                 | Image pull policy                                                                                                                     | `IfNotPresent`                 |
| `image.pullSecrets`                                | Specify docker-registry secret names as an array                                                                                      | `[]`                           |
| `image.debug`                                      | Specify if debug logs should be enabled                                                                                               | `false`                        |
| `clientImage.registry`                             | MinIO&reg; Client image registry                                                                                                      | `REGISTRY_NAME`                |
| `clientImage.repository`                           | MinIO&reg; Client image repository                                                                                                    | `REPOSITORY_NAME/minio-client` |
| `clientImage.digest`                               | MinIO&reg; Client image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                     | `""`                           |
| `auth.rootUser`                                    | MinIO&reg; root username                                                                                                              | `admin`                        |
| `auth.rootPassword`                                | Password for MinIO&reg; root user                                                                                                     | `""`                           |
| `auth.existingSecret`                              | Use existing secret for credentials details (`auth.rootUser` and `auth.rootPassword` will be ignored and picked up from this secret). | `""`                           |
| `auth.rootUserSecretKey`                           | Key where the MINIO_ROOT_USER username is being stored inside the existing secret `auth.existingSecret`                               | `""`                           |
| `auth.rootPasswordSecretKey`                       | Key where the MINIO_ROOT_USER password is being stored inside the existing secret `auth.existingSecret`                               | `""`                           |
| `auth.forcePassword`                               | Force users to specify required passwords                                                                                             | `false`                        |
| `auth.usePasswordFiles`                            | Mount credentials as a files instead of using an environment variable                                                                 | `true`                         |
| `auth.useSecret`                                   | Uses a secret to mount the credential files.                                                                                          | `true`                         |
| `auth.forceNewKeys`                                | Force root credentials (user and password) to be reconfigured every time they change in the secrets                                   | `false`                        |
| `defaultBuckets`                                   | Comma, semi-colon or space separated list of buckets to create at initialization (only in standalone mode)                            | `""`                           |
| `tls.enabled`                                      | Enable TLS configuration for MinIO&reg;                                                                                               | `false`                        |
| `tls.autoGenerated.enabled`                        | Enable automatic generation of TLS certificates                                                                                       | `true`                         |
| `tls.autoGenerated.engine`                         | Mechanism to generate the certificates (allowed values: helm, cert-manager)                                                           | `helm`                         |
| `tls.autoGenerated.certManager.existingIssuer`     | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine)                                | `""`                           |
| `tls.autoGenerated.certManager.existingIssuerKind` | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                                                             | `""`                           |
| `tls.autoGenerated.certManager.keyAlgorithm`       | Key algorithm for the certificates (only for `cert-manager` engine)                                                                   | `RSA`                          |
| `tls.autoGenerated.certManager.keySize`            | Key size for the certificates (only for `cert-manager` engine)                                                                        | `2048`                         |
| `tls.autoGenerated.certManager.duration`           | Duration for the certificates (only for `cert-manager` engine)                                                                        | `2160h`                        |
| `tls.autoGenerated.certManager.renewBefore`        | Renewal period for the certificates (only for `cert-manager` engine)                                                                  | `360h`                         |
| `tls.ca`                                           | CA certificate for TLS. Ignored if `tls.existingCASecret` is set                                                                      | `""`                           |
| `tls.existingCASecret`                             | The name of an existing Secret containing the CA certificate for TLS                                                                  | `""`                           |
| `tls.server.cert`                                  | TLS certificate for MinIO&reg; servers. Ignored if `tls.server.existingSecret` is set                                                 | `""`                           |
| `tls.server.key`                                   | TLS key for MinIO&reg; servers. Ignored if `tls.server.existingSecret` is set                                                         | `""`                           |
| `tls.server.existingSecret`                        | The name of an existing Secret containing the TLS certificates for MinIO&reg; servers                                                 | `""`                           |
| `extraEnvVars`                                     | Extra environment variables to be set on MinIO&reg; container                                                                         | `[]`                           |
| `extraEnvVarsCM`                                   | ConfigMap with extra environment variables                                                                                            | `""`                           |
| `extraEnvVarsSecret`                               | Secret with extra environment variables                                                                                               | `""`                           |
| `command`                                          | Default container command (useful when using custom images). Use array form                                                           | `[]`                           |
| `args`                                             | Default container args (useful when using custom images). Use array form                                                              | `[]`                           |

### MinIO&reg; Deployment/StatefulSet parameters

| Name                                                                                        | Description                                                                                                                                                                                                                                                                                                                     | Value                      |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `mode`                                                                                      | MinIO&reg; server mode (`standalone` or `distributed`)                                                                                                                                                                                                                                                                          | `standalone`               |
| `schedulerName`                                                                             | Specifies the schedulerName, if it's nil uses kube-scheduler                                                                                                                                                                                                                                                                    | `""`                       |
| `terminationGracePeriodSeconds`                                                             | In seconds, time the given to the MinIO pod needs to terminate gracefully                                                                                                                                                                                                                                                       | `""`                       |
| `updateStrategy.type`                                                                       | MinIO&reg; deployment/statefulset update strategy type                                                                                                                                                                                                                                                                          | `RollingUpdate`            |
| `statefulset.podManagementPolicy`                                                           | StatefulSet controller supports relax its ordering guarantees while preserving its uniqueness and identity guarantees. There are two valid pod management policies: OrderedReady and Parallel                                                                                                                                   | `Parallel`                 |
| `statefulset.replicaCount`                                                                  | Number of pods per zone (only for MinIO&reg; distributed mode). Should be even and `>= 4`                                                                                                                                                                                                                                       | `4`                        |
| `statefulset.zones`                                                                         | Number of zones (only for MinIO&reg; distributed mode)                                                                                                                                                                                                                                                                          | `1`                        |
| `statefulset.drivesPerNode`                                                                 | Number of drives attached to every node (only for MinIO&reg; distributed mode)                                                                                                                                                                                                                                                  | `1`                        |
| `automountServiceAccountToken`                                                              | Mount Service Account token in pod                                                                                                                                                                                                                                                                                              | `false`                    |
| `hostAliases`                                                                               | MinIO&reg; pod host aliases                                                                                                                                                                                                                                                                                                     | `[]`                       |
| `containerPorts.api`                                                                        | MinIO&reg; container port to open for MinIO&reg; API                                                                                                                                                                                                                                                                            | `9000`                     |
| `podSecurityContext.enabled`                                                                | Enable pod Security Context                                                                                                                                                                                                                                                                                                     | `true`                     |
| `podSecurityContext.sysctls`                                                                | Set kernel settings using the sysctl interface                                                                                                                                                                                                                                                                                  | `[]`                       |
| `podSecurityContext.supplementalGroups`                                                     | Set filesystem extra groups                                                                                                                                                                                                                                                                                                     | `[]`                       |
| `podSecurityContext.fsGroup`                                                                | Group ID for the container                                                                                                                                                                                                                                                                                                      | `1001`                     |
| `podSecurityContext.fsGroupChangePolicy`                                                    | Set filesystem group change policy                                                                                                                                                                                                                                                                                              | `OnRootMismatch`           |
| `podSecurityContext.sysctls`                                                                | Set kernel settings using the sysctl interface                                                                                                                                                                                                                                                                                  | `[]`                       |
| `podSecurityContext.supplementalGroups`                                                     | Set filesystem extra groups                                                                                                                                                                                                                                                                                                     | `[]`                       |
| `podSecurityContext.fsGroupChangePolicy`                                                    | When K8s should preform chown on attached volumes                                                                                                                                                                                                                                                                               | `OnRootMismatch`           |
| `containerSecurityContext.enabled`                                                          | Enabled containers' Security Context                                                                                                                                                                                                                                                                                            | `true`                     |
| `containerSecurityContext.seLinuxOptions`                                                   | Set SELinux options in container                                                                                                                                                                                                                                                                                                | `{}`                       |
| `containerSecurityContext.runAsUser`                                                        | Set containers' Security Context runAsUser                                                                                                                                                                                                                                                                                      | `1001`                     |
| `containerSecurityContext.runAsGroup`                                                       | Set containers' Security Context runAsGroup                                                                                                                                                                                                                                                                                     | `1001`                     |
| `containerSecurityContext.runAsNonRoot`                                                     | Set container's Security Context runAsNonRoot                                                                                                                                                                                                                                                                                   | `true`                     |
| `containerSecurityContext.privileged`                                                       | Set container's Security Context privileged                                                                                                                                                                                                                                                                                     | `false`                    |
| `containerSecurityContext.readOnlyRootFilesystem`                                           | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                                                                                                         | `true`                     |
| `containerSecurityContext.allowPrivilegeEscalation`                                         | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                                                                                                       | `false`                    |
| `containerSecurityContext.capabilities.drop`                                                | List of capabilities to be dropped                                                                                                                                                                                                                                                                                              | `["ALL"]`                  |
| `containerSecurityContext.seccompProfile.type`                                              | Set container's Security Context seccomp profile                                                                                                                                                                                                                                                                                | `RuntimeDefault`           |
| `podLabels`                                                                                 | Extra labels for MinIO&reg; pods                                                                                                                                                                                                                                                                                                | `{}`                       |
| `podAnnotations`                                                                            | Annotations for MinIO&reg; pods                                                                                                                                                                                                                                                                                                 | `{}`                       |
| `podAffinityPreset`                                                                         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                                                                                             | `""`                       |
| `podAntiAffinityPreset`                                                                     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                                                                                        | `soft`                     |
| `nodeAffinityPreset.type`                                                                   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                                                                                       | `""`                       |
| `nodeAffinityPreset.key`                                                                    | Node label key to match. Ignored if `affinity` is set.                                                                                                                                                                                                                                                                          | `""`                       |
| `nodeAffinityPreset.values`                                                                 | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                                                                                                                       | `[]`                       |
| `affinity`                                                                                  | Affinity for pod assignment. Evaluated as a template.                                                                                                                                                                                                                                                                           | `{}`                       |
| `nodeSelector`                                                                              | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                                                                                                                                        | `{}`                       |
| `tolerations`                                                                               | Tolerations for pod assignment. Evaluated as a template.                                                                                                                                                                                                                                                                        | `[]`                       |
| `topologySpreadConstraints`                                                                 | Topology Spread Constraints for MinIO&reg; pods assignment spread across your cluster among failure-domains                                                                                                                                                                                                                     | `[]`                       |
| `priorityClassName`                                                                         | MinIO&reg; pods' priorityClassName                                                                                                                                                                                                                                                                                              | `""`                       |
| `runtimeClassName`                                                                          | Name of the runtime class to be used by MinIO&reg; pods'                                                                                                                                                                                                                                                                        | `""`                       |
| `resourcesPreset`                                                                           | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production).                                                                                                               | `micro`                    |
| `resources`                                                                                 | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                                                                                               | `{}`                       |
| `livenessProbe.enabled`                                                                     | Enable livenessProbe                                                                                                                                                                                                                                                                                                            | `true`                     |
| `livenessProbe.initialDelaySeconds`                                                         | Initial delay seconds for livenessProbe                                                                                                                                                                                                                                                                                         | `5`                        |
| `livenessProbe.periodSeconds`                                                               | Period seconds for livenessProbe                                                                                                                                                                                                                                                                                                | `5`                        |
| `livenessProbe.timeoutSeconds`                                                              | Timeout seconds for livenessProbe                                                                                                                                                                                                                                                                                               | `5`                        |
| `livenessProbe.failureThreshold`                                                            | Failure threshold for livenessProbe                                                                                                                                                                                                                                                                                             | `5`                        |
| `livenessProbe.successThreshold`                                                            | Success threshold for livenessProbe                                                                                                                                                                                                                                                                                             | `1`                        |
| `readinessProbe.enabled`                                                                    | Enable readinessProbe                                                                                                                                                                                                                                                                                                           | `true`                     |
| `readinessProbe.initialDelaySeconds`                                                        | Initial delay seconds for readinessProbe                                                                                                                                                                                                                                                                                        | `5`                        |
| `readinessProbe.periodSeconds`                                                              | Period seconds for readinessProbe                                                                                                                                                                                                                                                                                               | `5`                        |
| `readinessProbe.timeoutSeconds`                                                             | Timeout seconds for readinessProbe                                                                                                                                                                                                                                                                                              | `1`                        |
| `readinessProbe.failureThreshold`                                                           | Failure threshold for readinessProbe                                                                                                                                                                                                                                                                                            | `5`                        |
| `readinessProbe.successThreshold`                                                           | Success threshold for readinessProbe                                                                                                                                                                                                                                                                                            | `1`                        |
| `startupProbe.enabled`                                                                      | Enable startupProbe                                                                                                                                                                                                                                                                                                             | `false`                    |
| `startupProbe.initialDelaySeconds`                                                          | Initial delay seconds for startupProbe                                                                                                                                                                                                                                                                                          | `0`                        |
| `startupProbe.periodSeconds`                                                                | Period seconds for startupProbe                                                                                                                                                                                                                                                                                                 | `10`                       |
| `startupProbe.timeoutSeconds`                                                               | Timeout seconds for startupProbe                                                                                                                                                                                                                                                                                                | `5`                        |
| `startupProbe.failureThreshold`                                                             | Failure threshold for startupProbe                                                                                                                                                                                                                                                                                              | `60`                       |
| `startupProbe.successThreshold`                                                             | Success threshold for startupProbe                                                                                                                                                                                                                                                                                              | `1`                        |
| `customLivenessProbe`                                                                       | Override default liveness probe                                                                                                                                                                                                                                                                                                 | `{}`                       |
| `customReadinessProbe`                                                                      | Override default readiness probe                                                                                                                                                                                                                                                                                                | `{}`                       |
| `customStartupProbe`                                                                        | Override default startup probe                                                                                                                                                                                                                                                                                                  | `{}`                       |
| `lifecycleHooks`                                                                            | for the MinIO&reg container(s) to automate configuration before or after startup                                                                                                                                                                                                                                                | `{}`                       |
| `extraVolumes`                                                                              | Optionally specify extra list of additional volumes for MinIO&reg; pods                                                                                                                                                                                                                                                         | `[]`                       |
| `extraVolumeMounts`                                                                         | Optionally specify extra list of additional volumeMounts for MinIO&reg; container(s)                                                                                                                                                                                                                                            | `[]`                       |
| `initContainers`                                                                            | Add additional init containers to the MinIO&reg; pods                                                                                                                                                                                                                                                                           | `[]`                       |
| `sidecars`                                                                                  | Add additional sidecar containers to the MinIO&reg; pods                                                                                                                                                                                                                                                                        | `[]`                       |
| `pdb.create`                                                                                | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                                                                                                                 | `true`                     |
| `pdb.minAvailable`                                                                          | Minimum number/percentage of pods that must still be available after the eviction                                                                                                                                                                                                                                               | `""`                       |
| `pdb.maxUnavailable`                                                                        | Maximum number/percentage of pods that may be made unavailable after the eviction                                                                                                                                                                                                                                               | `""`                       |
| `autoscaling.vpa.enabled`                                                                   | Enable VPA for MinIO&reg; pods                                                                                                                                                                                                                                                                                                  | `false`                    |
| `autoscaling.vpa.annotations`                                                               | Annotations for VPA resource                                                                                                                                                                                                                                                                                                    | `{}`                       |
| `autoscaling.vpa.controlledResources`                                                       | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                                                                                                                  | `[]`                       |
| `autoscaling.vpa.maxAllowed`                                                                | VPA Max allowed resources for the pod                                                                                                                                                                                                                                                                                           | `{}`                       |
| `autoscaling.vpa.minAllowed`                                                                | VPA Min allowed resources for the pod                                                                                                                                                                                                                                                                                           | `{}`                       |
| `autoscaling.vpa.updatePolicy.updateMode`                                                   | Autoscaling update policy                                                                                                                                                                                                                                                                                                       | `Auto`                     |
| `defaultInitContainers.volumePermissions.enabled`                                           | Enable init container that changes the owner and group of the persistent volume                                                                                                                                                                                                                                                 | `false`                    |
| `defaultInitContainers.volumePermissions.image.registry`                                    | "volume-permissions" init-containers' image registry                                                                                                                                                                                                                                                                            | `REGISTRY_NAME`            |
| `defaultInitContainers.volumePermissions.image.repository`                                  | "volume-permissions" init-containers' image repository                                                                                                                                                                                                                                                                          | `REPOSITORY_NAME/os-shell` |
| `defaultInitContainers.volumePermissions.image.digest`                                      | "volume-permissions" init-containers' image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                                                                           | `""`                       |
| `defaultInitContainers.volumePermissions.image.pullPolicy`                                  | "volume-permissions" init-containers' image pull policy                                                                                                                                                                                                                                                                         | `IfNotPresent`             |
| `defaultInitContainers.volumePermissions.image.pullSecrets`                                 | "volume-permissions" init-containers' image pull secrets                                                                                                                                                                                                                                                                        | `[]`                       |
| `defaultInitContainers.volumePermissions.containerSecurityContext.enabled`                  | Enabled "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                                  | `true`                     |
| `defaultInitContainers.volumePermissions.containerSecurityContext.seLinuxOptions`           | Set SELinux options in "volume-permissions" init-containers                                                                                                                                                                                                                                                                     | `{}`                       |
| `defaultInitContainers.volumePermissions.containerSecurityContext.runAsUser`                | Set runAsUser in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                         | `0`                        |
| `defaultInitContainers.volumePermissions.containerSecurityContext.privileged`               | Set privileged in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                                        | `false`                    |
| `defaultInitContainers.volumePermissions.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in "volume-permissions" init-containers' Security Context                                                                                                                                                                                                                                          | `false`                    |
| `defaultInitContainers.volumePermissions.containerSecurityContext.capabilities.add`         | List of capabilities to be added in "volume-permissions" init-containers                                                                                                                                                                                                                                                        | `["CHOWN"]`                |
| `defaultInitContainers.volumePermissions.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in "volume-permissions" init-containers                                                                                                                                                                                                                                                      | `["ALL"]`                  |
| `defaultInitContainers.volumePermissions.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in "volume-permissions" init-containers                                                                                                                                                                                                                                                                     | `RuntimeDefault`           |
| `defaultInitContainers.volumePermissions.resourcesPreset`                                   | Set MinIO&reg; "volume-permissions" init container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if defaultInitContainers.volumePermissions.resources is set (defaultInitContainers.volumePermissions.resources is recommended for production). | `nano`                     |
| `defaultInitContainers.volumePermissions.resources`                                         | Set MinIO&reg; "volume-permissions" init container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                                                          | `{}`                       |

### MinIO&reg; Traffic exposure parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | MinIO&reg; service type                                                                                                          | `ClusterIP`              |
| `service.ports.api`                     | MinIO&reg; API service port                                                                                                      | `9000`                   |
| `service.nodePorts.api`                 | Specify the MinIO&reg API nodePort value for the LoadBalancer and NodePort service types                                         | `""`                     |
| `service.clusterIP`                     | Service Cluster IP                                                                                                               | `""`                     |
| `service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer` (optional, cloud specific)                                                      | `""`                     |
| `service.loadBalancerSourceRanges`      | Addresses that are allowed when service is LoadBalancer                                                                          | `[]`                     |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.extraPorts`                    | Extra ports to expose in the service (normally used with the `sidecar` value)                                                    | `[]`                     |
| `service.annotations`                   | Annotations for MinIO&reg; service                                                                                               | `{}`                     |
| `service.headless.annotations`          | Annotations for the headless service                                                                                             | `{}`                     |
| `ingress.enabled`                       | Enable ingress controller resource for MinIO API                                                                                 | `false`                  |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress resource                                                                                            | `minio.local`            |
| `ingress.path`                          | The Path to MinIO&reg;. You may need to set this to '/*' in order to use this with ALB ingress controllers.                      | `/`                      |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter                                                | `false`                  |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                    | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`                    | Any additional paths that may need to be added to the ingress under the main host                                                | `[]`                     |
| `ingress.extraTls`                      | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                       | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `networkPolicy.enabled`                 | Enable creation of NetworkPolicy for MinIO&reg;                                                                                  | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.addExternalClientAccess` | Allow access from pods with client label set to "true". Ignored if `networkPolicy.allowExternal` is true.                        | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressPodMatchLabels`   | Labels to match to allow traffic from other pods. Ignored if `networkPolicy.allowExternal` is true.                              | `{}`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.                        | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces. Ignored if `networkPolicy.allowExternal` is true.                    | `{}`                     |

### MinIO&reg; Persistence parameters

| Name                        | Description                                                             | Value                 |
| --------------------------- | ----------------------------------------------------------------------- | --------------------- |
| `persistence.enabled`       | Enable MinIO&reg; data persistence using PVC. If false, use emptyDir    | `true`                |
| `persistence.storageClass`  | PVC Storage Class for MinIO&reg; data volume                            | `""`                  |
| `persistence.mountPath`     | Data volume mount path                                                  | `/bitnami/minio/data` |
| `persistence.accessModes`   | PVC Access Modes for MinIO&reg; data volume                             | `["ReadWriteOnce"]`   |
| `persistence.size`          | PVC Storage Request for MinIO&reg; data volume                          | `8Gi`                 |
| `persistence.annotations`   | Annotations for the PVC                                                 | `{}`                  |
| `persistence.existingClaim` | Name of an existing PVC to use (only in `standalone` mode)              | `""`                  |
| `persistence.selector`      | Selector to match an existing Persistent Volume for MinIO&reg; data PVC | `{}`                  |
| `persistence.dataSource`    | Custom PVC data source                                                  | `{}`                  |

### RBAC parameters

| Name                                          | Description                                                 | Value   |
| --------------------------------------------- | ----------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for MinIO&reg; pods | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount                          | `""`    |
| `serviceAccount.automountServiceAccountToken` | Enable/disable auto mounting of the service account token   | `false` |
| `serviceAccount.annotations`                  | Custom annotations for MinIO&reg; ServiceAccount            | `{}`    |

### Metrics parameters

| Name                                       | Description                                                                                                                   | Value                                                    |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `metrics.prometheusAuthType`               | Authentication mode for Prometheus (`jwt` or `public`)                                                                        | `public`                                                 |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                                       | `false`                                                  |
| `metrics.serviceMonitor.enabled`           | If the operator is installed in your cluster, set to true to create a Service Monitor Entry                                   | `false`                                                  |
| `metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                                                                      | `""`                                                     |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                                                                           | `{}`                                                     |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus                                              | `""`                                                     |
| `metrics.serviceMonitor.paths`             | HTTP paths to scrape for metrics                                                                                              | `["/minio/v2/metrics/cluster","/minio/v2/metrics/node"]` |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                                                                   | `30s`                                                    |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                                                                           | `""`                                                     |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                     | `[]`                                                     |
| `metrics.serviceMonitor.relabelings`       | Metrics relabelings to add to the scrape endpoint, applied before scraping                                                    | `[]`                                                     |
| `metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                                                                      | `false`                                                  |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                           | `{}`                                                     |
| `metrics.serviceMonitor.apiVersion`        | ApiVersion for the serviceMonitor Resource (defaults to "monitoring.coreos.com/v1")                                           | `""`                                                     |
| `metrics.serviceMonitor.tlsConfig`         | Additional TLS configuration for metrics endpoint with "https" scheme                                                         | `{}`                                                     |
| `metrics.prometheusRule.enabled`           | Create a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`) | `false`                                                  |
| `metrics.prometheusRule.namespace`         | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                 | `""`                                                     |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                         | `{}`                                                     |
| `metrics.prometheusRule.rules`             | Prometheus Rule definitions                                                                                                   | `[]`                                                     |

### MinIO&reg; Console parameters

| Name                                                        | Description                                                                                                                                                                                                                                   | Value                                  |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `console.enabled`                                           | Enable MinIO&reg; Console                                                                                                                                                                                                                     | `true`                                 |
| `console.image.registry`                                    | MinIO&reg; Console image registry                                                                                                                                                                                                             | `REGISTRY_NAME`                        |
| `console.image.repository`                                  | MinIO&reg; Console image repository                                                                                                                                                                                                           | `REPOSITORY_NAME/minio-object-browser` |
| `console.image.digest`                                      | MinIO&reg; Console image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                                 | `""`                                   |
| `console.image.pullPolicy`                                  | MinIO&reg; Console image pull policy                                                                                                                                                                                                          | `IfNotPresent`                         |
| `console.image.pullSecrets`                                 | MinIO&reg; Console image pull secrets                                                                                                                                                                                                         | `[]`                                   |
| `console.replicaCount`                                      | Number of MinIO&reg; Console replicas to deploy                                                                                                                                                                                               | `1`                                    |
| `console.containerPorts.http`                               | MinIO&reg; Console HTTP container port                                                                                                                                                                                                        | `9090`                                 |
| `console.extraContainerPorts`                               | Optionally specify extra list of additional ports for MinIO&reg; Console containers                                                                                                                                                           | `[]`                                   |
| `console.livenessProbe.enabled`                             | Enable livenessProbe on MinIO&reg; Console containers                                                                                                                                                                                         | `true`                                 |
| `console.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                       | `5`                                    |
| `console.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                              | `5`                                    |
| `console.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                             | `5`                                    |
| `console.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                           | `5`                                    |
| `console.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                           | `1`                                    |
| `console.readinessProbe.enabled`                            | Enable readinessProbe on MinIO&reg; Console containers                                                                                                                                                                                        | `true`                                 |
| `console.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                      | `5`                                    |
| `console.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                             | `5`                                    |
| `console.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                            | `5`                                    |
| `console.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                          | `5`                                    |
| `console.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                          | `1`                                    |
| `console.startupProbe.enabled`                              | Enable startupProbe on MinIO&reg; Console containers                                                                                                                                                                                          | `false`                                |
| `console.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                        | `0`                                    |
| `console.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                               | `10`                                   |
| `console.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                              | `5`                                    |
| `console.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                            | `60`                                   |
| `console.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                            | `1`                                    |
| `console.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                           | `{}`                                   |
| `console.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                          | `{}`                                   |
| `console.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                            | `{}`                                   |
| `console.resourcesPreset`                                   | Set MinIO&reg; Console container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if console.resources is set (console.resources is recommended for production). | `nano`                                 |
| `console.resources`                                         | Set MinIO&reg; Console container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                                   |
| `console.podSecurityContext.enabled`                        | Enable MinIO&reg; Console pods' Security Context                                                                                                                                                                                              | `true`                                 |
| `console.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy for MinIO&reg; Console pods                                                                                                                                                                                | `Always`                               |
| `console.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface for MinIO&reg; Console pods                                                                                                                                                                    | `[]`                                   |
| `console.podSecurityContext.supplementalGroups`             | Set filesystem extra groups for MinIO&reg; Console pods                                                                                                                                                                                       | `[]`                                   |
| `console.podSecurityContext.fsGroup`                        | Set fsGroup in MinIO&reg; Console pods' Security Context                                                                                                                                                                                      | `1001`                                 |
| `console.containerSecurityContext.enabled`                  | Enabled MinIO&reg; Console container' Security Context                                                                                                                                                                                        | `true`                                 |
| `console.containerSecurityContext.seLinuxOptions`           | Set SELinux options in MinIO&reg; Console container                                                                                                                                                                                           | `{}`                                   |
| `console.containerSecurityContext.runAsUser`                | Set runAsUser in MinIO&reg; Console container' Security Context                                                                                                                                                                               | `1001`                                 |
| `console.containerSecurityContext.runAsGroup`               | Set runAsGroup in MinIO&reg; Console container' Security Context                                                                                                                                                                              | `1001`                                 |
| `console.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in MinIO&reg; Console container' Security Context                                                                                                                                                                            | `true`                                 |
| `console.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in MinIO&reg; Console container' Security Context                                                                                                                                                                  | `true`                                 |
| `console.containerSecurityContext.privileged`               | Set privileged in MinIO&reg; Console container' Security Context                                                                                                                                                                              | `false`                                |
| `console.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in MinIO&reg; Console container' Security Context                                                                                                                                                                | `false`                                |
| `console.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in MinIO&reg; Console container                                                                                                                                                                            | `["ALL"]`                              |
| `console.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in MinIO&reg; Console container                                                                                                                                                                                           | `RuntimeDefault`                       |
| `console.command`                                           | Override default MinIO&reg; Console container command (useful when using custom images)                                                                                                                                                       | `[]`                                   |
| `console.args`                                              | Override default MinIO&reg; Console container args (useful when using custom images)                                                                                                                                                          | `[]`                                   |
| `console.automountServiceAccountToken`                      | Mount Service Account token in MinIO&reg; Console pods                                                                                                                                                                                        | `false`                                |
| `console.hostAliases`                                       | MinIO&reg; Console pods host aliases                                                                                                                                                                                                          | `[]`                                   |
| `console.deploymentAnnotations`                             | Annotations for MinIO&reg; Console deployment                                                                                                                                                                                                 | `{}`                                   |
| `console.podLabels`                                         | Extra labels for MinIO&reg; Console pods                                                                                                                                                                                                      | `{}`                                   |
| `console.podAnnotations`                                    | Annotations for MinIO&reg; Console pods                                                                                                                                                                                                       | `{}`                                   |
| `console.podAffinityPreset`                                 | Pod affinity preset. Ignored if `console.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                   | `""`                                   |
| `console.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `console.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                              | `soft`                                 |
| `console.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `console.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                             | `""`                                   |
| `console.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `console.affinity` is set                                                                                                                                                                                 | `""`                                   |
| `console.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `console.affinity` is set                                                                                                                                                                              | `[]`                                   |
| `console.affinity`                                          | Affinity for MinIO&reg; Console pods assignment                                                                                                                                                                                               | `{}`                                   |
| `console.nodeSelector`                                      | Node labels for MinIO&reg; Console pods assignment                                                                                                                                                                                            | `{}`                                   |
| `console.tolerations`                                       | Tolerations for MinIO&reg; Console pods assignment                                                                                                                                                                                            | `[]`                                   |
| `console.updateStrategy.type`                               | MinIO&reg; Console deployment strategy type                                                                                                                                                                                                   | `RollingUpdate`                        |
| `console.priorityClassName`                                 | MinIO&reg; Console pods' priorityClassName                                                                                                                                                                                                    | `""`                                   |
| `console.topologySpreadConstraints`                         | Topology Spread Constraints for MinIO&reg; Console pod assignment spread across your cluster among failure-domains                                                                                                                            | `[]`                                   |
| `console.schedulerName`                                     | Name of the k8s scheduler (other than default) for MinIO&reg; Console pods                                                                                                                                                                    | `""`                                   |
| `console.terminationGracePeriodSeconds`                     | Seconds MinIO&reg; Console pods need to terminate gracefully                                                                                                                                                                                  | `""`                                   |
| `console.lifecycleHooks`                                    | for MinIO&reg; Console containers to automate configuration before or after startup                                                                                                                                                           | `{}`                                   |
| `console.extraEnvVars`                                      | Array with extra environment variables to add to MinIO&reg; Console containers                                                                                                                                                                | `[]`                                   |
| `console.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for MinIO&reg; Console containers                                                                                                                                                        | `""`                                   |
| `console.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for MinIO&reg; Console containers                                                                                                                                                           | `""`                                   |
| `console.extraVolumes`                                      | Optionally specify extra list of additional volumes for the MinIO&reg; Console pods                                                                                                                                                           | `[]`                                   |
| `console.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the MinIO&reg; Console containers                                                                                                                                                | `[]`                                   |
| `console.sidecars`                                          | Add additional sidecar containers to the MinIO&reg; Console pods                                                                                                                                                                              | `[]`                                   |
| `console.initContainers`                                    | Add additional init containers to the MinIO&reg; Console pods                                                                                                                                                                                 | `[]`                                   |
| `console.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                               | `true`                                 |
| `console.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                                | `""`                                   |
| `console.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `console.pdb.minAvailable` and `console.pdb.maxUnavailable` are empty.                                                                                | `""`                                   |
| `console.autoscaling.vpa.enabled`                           | Enable VPA for MinIO&reg; Console pods                                                                                                                                                                                                        | `false`                                |
| `console.autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                                  | `{}`                                   |
| `console.autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                                | `[]`                                   |
| `console.autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                                         | `{}`                                   |
| `console.autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                                         | `{}`                                   |
| `console.autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy                                                                                                                                                                                                                     | `Auto`                                 |
| `console.autoscaling.hpa.enabled`                           | Enable HPA for MinIO&reg; Console pods                                                                                                                                                                                                        | `false`                                |
| `console.autoscaling.hpa.minReplicas`                       | Minimum number of replicas                                                                                                                                                                                                                    | `""`                                   |
| `console.autoscaling.hpa.maxReplicas`                       | Maximum number of replicas                                                                                                                                                                                                                    | `""`                                   |
| `console.autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                                             | `""`                                   |
| `console.autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                                          | `""`                                   |
| `console.service.type`                                      | MinIO&reg; Console service type                                                                                                                                                                                                               | `ClusterIP`                            |
| `console.service.ports.http`                                | MinIO&reg; Console HTTP service port                                                                                                                                                                                                          | `9090`                                 |
| `console.service.nodePorts.http`                            | Specify the MinIO&reg; Console HTTP nodePort value                                                                                                                                                                                            | `""`                                   |
| `console.service.clusterIP`                                 | Service Cluster IP                                                                                                                                                                                                                            | `""`                                   |
| `console.service.loadBalancerIP`                            | loadBalancerIP if service type is `LoadBalancer` (optional, cloud specific)                                                                                                                                                                   | `""`                                   |
| `console.service.loadBalancerSourceRanges`                  | Addresses that are allowed when service is LoadBalancer                                                                                                                                                                                       | `[]`                                   |
| `console.service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                                                                                                                                          | `Cluster`                              |
| `console.service.extraPorts`                                | Extra ports to expose in the service (normally used with the `sidecar` value)                                                                                                                                                                 | `[]`                                   |
| `console.service.annotations`                               | Annotations for MinIO&reg; Console service                                                                                                                                                                                                    | `{}`                                   |
| `console.ingress.enabled`                                   | Enable ingress controller resource for MinIO&reg; Console                                                                                                                                                                                     | `false`                                |
| `console.ingress.apiVersion`                                | Force Ingress API version (automatically detected if not set)                                                                                                                                                                                 | `""`                                   |
| `console.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                                                                                                                 | `""`                                   |
| `console.ingress.hostname`                                  | Default host for the ingress resource                                                                                                                                                                                                         | `minio.local`                          |
| `console.ingress.path`                                      | The Path to MinIO&reg; Console. You may need to set this to '/*' in order to use this with ALB ingress controllers.                                                                                                                           | `/`                                    |
| `console.ingress.pathType`                                  | Ingress path type                                                                                                                                                                                                                             | `ImplementationSpecific`               |
| `console.ingress.annotations`                               | Additional annotations for the Ingress resource. To enable certificate auto-generation, place here your cert-manager annotations.                                                                                                             | `{}`                                   |
| `console.ingress.tls`                                       | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter                                                                                                                                                             | `false`                                |
| `console.ingress.selfSigned`                                | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                                                                                                                  | `false`                                |
| `console.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                                                                                                                                                      | `[]`                                   |
| `console.ingress.extraPaths`                                | Any additional paths that may need to be added to the ingress under the main host                                                                                                                                                             | `[]`                                   |
| `console.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                                                                                                                                        | `[]`                                   |
| `console.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                                                                                                                                                 | `[]`                                   |
| `console.ingress.extraRules`                                | Additional rules to be covered with this ingress record                                                                                                                                                                                       | `[]`                                   |
| `console.networkPolicy.enabled`                             | Enable creation of NetworkPolicy for MinIO&reg; Console                                                                                                                                                                                       | `true`                                 |
| `console.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                                    | `true`                                 |
| `console.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                               | `true`                                 |
| `console.networkPolicy.addExternalClientAccess`             | Allow access from pods with client label set to "true". Ignored if `console.networkPolicy.allowExternal` is true.                                                                                                                             | `true`                                 |
| `console.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                  | `[]`                                   |
| `console.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                  | `[]`                                   |
| `console.networkPolicy.ingressPodMatchLabels`               | Labels to match to allow traffic from other pods. Ignored if `console.networkPolicy.allowExternal` is true.                                                                                                                                   | `{}`                                   |
| `console.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces. Ignored if `console.networkPolicy.allowExternal` is true.                                                                                                                             | `{}`                                   |
| `console.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces. Ignored if `console.networkPolicy.allowExternal` is true.                                                                                                                         | `{}`                                   |

### MinIO&reg; provisioning parameters

| Name                                                             | Description                                                                                                                                                                                                                                 | Value            |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `provisioning.enabled`                                           | Enable MinIO&reg; provisioning Job                                                                                                                                                                                                          | `false`          |
| `provisioning.sleepTime`                                         | Sleep time before checking Minio availability                                                                                                                                                                                               | `5`              |
| `provisioning.schedulerName`                                     | Name of the k8s scheduler (other than default) for MinIO&reg; provisioning                                                                                                                                                                  | `""`             |
| `provisioning.nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                                                                                                                                    | `{}`             |
| `provisioning.podLabels`                                         | Extra labels for provisioning pods                                                                                                                                                                                                          | `{}`             |
| `provisioning.podAnnotations`                                    | Provisioning Pod annotations.                                                                                                                                                                                                               | `{}`             |
| `provisioning.command`                                           | Default provisioning container command (useful when using custom images). Use array form                                                                                                                                                    | `[]`             |
| `provisioning.args`                                              | Default provisioning container args (useful when using custom images). Use array form                                                                                                                                                       | `[]`             |
| `provisioning.extraCommands`                                     | Optionally specify extra list of additional commands for MinIO&reg; provisioning pod                                                                                                                                                        | `[]`             |
| `provisioning.extraVolumes`                                      | Optionally specify extra list of additional volumes for MinIO&reg; provisioning pod                                                                                                                                                         | `[]`             |
| `provisioning.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for MinIO&reg; provisioning container                                                                                                                                              | `[]`             |
| `provisioning.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if provisioning.resources is set (provisioning.resources is recommended for production). | `nano`           |
| `provisioning.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                           | `{}`             |
| `provisioning.policies`                                          | MinIO&reg; policies provisioning                                                                                                                                                                                                            | `[]`             |
| `provisioning.users`                                             | MinIO&reg; users provisioning. Can be used in addition to provisioning.usersExistingSecrets.                                                                                                                                                | `[]`             |
| `provisioning.usersExistingSecrets`                              | Array if existing secrets containing MinIO&reg; users to be provisioned. Can be used in addition to provisioning.users.                                                                                                                     | `[]`             |
| `provisioning.groups`                                            | MinIO&reg; groups provisioning                                                                                                                                                                                                              | `[]`             |
| `provisioning.buckets`                                           | MinIO&reg; buckets, versioning, lifecycle, quota and tags provisioning                                                                                                                                                                      | `[]`             |
| `provisioning.config`                                            | MinIO&reg; config provisioning                                                                                                                                                                                                              | `[]`             |
| `provisioning.podSecurityContext.enabled`                        | Enable pod Security Context                                                                                                                                                                                                                 | `true`           |
| `provisioning.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                          | `Always`         |
| `provisioning.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                              | `[]`             |
| `provisioning.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                 | `[]`             |
| `provisioning.podSecurityContext.fsGroup`                        | Group ID for the container                                                                                                                                                                                                                  | `1001`           |
| `provisioning.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                        | `true`           |
| `provisioning.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                            | `{}`             |
| `provisioning.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                  | `1001`           |
| `provisioning.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                 | `1001`           |
| `provisioning.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                               | `true`           |
| `provisioning.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                 | `false`          |
| `provisioning.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                     | `true`           |
| `provisioning.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                   | `false`          |
| `provisioning.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                          | `["ALL"]`        |
| `provisioning.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                            | `RuntimeDefault` |
| `provisioning.cleanupAfterFinished.enabled`                      | Enables Cleanup for Finished Jobs                                                                                                                                                                                                           | `false`          |
| `provisioning.cleanupAfterFinished.seconds`                      | Sets the value of ttlSecondsAfterFinished                                                                                                                                                                                                   | `600`            |
| `provisioning.networkPolicy.enabled`                             | Enable creation of NetworkPolicy resources                                                                                                                                                                                                  | `true`           |
| `provisioning.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                             | `true`           |
| `provisioning.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                | `[]`             |
| `provisioning.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                | `[]`             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set auth.rootUser=minio-admin \
  --set auth.rootPassword=minio-secret-password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/minio
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the MinIO&reg; Server root user and password to `minio-admin` and `minio-secret-password`, respectively.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/minio
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/minio/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 17.0.0

This major version moves MinIO Console to a separate deployment so the embedded UI is no longer needed. In addition, the following changes affecting the values structure have been introduced:

- `ingress.*` parameters have been moved to `console.ingress.*` to avoid confusion with the MinIO&reg; Server Ingress.
- `apiIngress.*` parameters have been renamed to `ingress.*`.
- `tls.*` parameters have been expanded so new configuration options are available.
- `volumePermissions` parameters have been moved under `defaultInitContainers` parameter.

### To 16.0.0

This major bump introduces the following changes:

- `auth.useCredentialsFiles` has been renamed to `auth.usePasswordFiles`. Its default value has been changed from `false` to `true`.

## To 15.0.0

This version updates MinIO&reg; to major version 2025.

### To 14.9.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 14.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

## To 13.0.0

This version updates MinIO&reg; to major version 2024.

### To 12.0.0

This version updates MinIO&reg; to major version 2023. All gateway features have been removed from Minio since upstream completely dropped this feature. The related options have been removed in version 12.1.0.

### To 11.0.0

This version deprecates the usage of `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` environment variables in MINIO&reg; container in favor of `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD`.

If you were already using the new variables, no issues are expected during upgrade.

## To 10.0.0

This version updates MinIO&reg; to major version 2022.

### To 9.0.0

This version updates MinIO&reg; authentication parameters so they're aligned with the [current terminology](https://docs.min.io/minio/baremetal/security/minio-identity-management/user-management.html#minio-users-root). As a result the following parameters have been affected:

- `accessKey.password` has been renamed to `auth.rootUser`.
- `secretKey.password` has been renamed to `auth.rootPassword`.
- `accessKey.forcePassword` and `secretKey.forcePassword` have been unified into `auth.forcePassword`.
- `existingSecret`, `useCredentialsFile` and `forceNewKeys` have been renamed to `auth.existingSecret`, `auth.useCredentialsFiles` and `forceNewKeys`, respectively.

### To 8.0.0

This version updates MinIO&reg; after some major changes, affecting its Web UI. MinIO&reg; has replaced its MinIO&reg; Browser with the MinIO&reg; Console, and Web UI has been moved to a separated port. As a result the following variables have been affected:

- `service.port` has been slit into `service.ports.api` (default: 9000) and `service.ports.console` (default: 9001).
- `containerPort` has been slit into `containerPorts.api` (default: 9000) and `containerPort.console` (default: 9001).
- `service.nodePort`has been slit into `service.nodePorts.api` and `service.nodePorts.console`.
- Service port `minio` has been replaced with `minio-api` and `minio-console` with target ports minio-api and minio-console respectively.
- Liveness, readiness and startup probes now use port `minio-console` instead of `minio`.

Please note that Web UI, previously running on port 9000 will now use port 9001 leaving port 9000 for the MinIO&reg; Server API.

### To 7.0.0

This version introduces pod and container securityContext support. The previous configuration of `securityContext` has moved to `podSecurityContext` and `containerSecurityContext`. Apart from this case, no issues are expected to appear when upgrading.

## To 6.0.0

This version updates MinIO&reg; to major version 2021.

### To 5.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 4.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 4.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

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
