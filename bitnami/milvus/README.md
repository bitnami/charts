<!--- app-name: Milvus -->

# Bitnami Secure Images Helm chart for Milvus

Milvus is a cloud-native, open-source vector database solution for AI applications and similarity search. Features high scalability, hibrid search and unified lambda structure.

[Overview of Milvus](https://milvus.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/milvus
```

Looking to use Milvus in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Milvus](https://github.com/grafana/loki) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/milvus
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys milvus on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `*.metrics.enabled` (under the `coordinator`, `dataNode`, `queryNode`, `streamingNode` and `proxy` sections) to true. This will expose the Milvus native Prometheus port in both the containers and services. The services will also have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `*.metrics.serviceMonitor.enabled=true` (under the `coordinator`, `dataNode`, `queryNode`, `streamingNode` and `proxy` sections). Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Milvus configuration

The Milvus configuration file `milvus.yaml` is shared across the different components: `coordinator`, `dataNode`, `queryNode` and `streamingNode`. This is set in the `milvus.defaultConfig` value. This configuration can be extended with extra settings using the `milvus.extraConfig` value. For specific component configuration edit the `extraConfig` section inside each of the previously mentioned components. Check the official [Milvis documentation](https://milvus.io/docs) for the list of possible configurations.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside each of the subsections: `rootCoord`, `dataCoord`, `indexCoord`, `dataNode`, `streamingNode`, `attu` and `queryNode`.

```yaml
dataCoord:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

rootCoord:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

indexCoord:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

dataNode:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

streamingNode:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

queryNode:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as milvus (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter inside each of the subsections: `rootCoord`, `dataCoord`, `indexCoord`, `dataNode`, `streamingNode`, `attu` and `queryNode` .

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter (where available), as shown in the example below:

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> NOTE: This Helm chart already includes sidecar containers for the Prometheus exporters (where applicable). These can be activated by adding the `--enable-metrics=true` parameter at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers.

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

### Update credentials

Bitnami charts configure credentials at first boot. Any further change in the secrets or credentials require manual intervention. Follow these instructions:

- Update the user password following [the upstream documentation](https://milvus.io/docs/authenticate.md#Update-user-password)
- Update the password secret with the new values (replace the SECRET_NAME, PASSWORD and ROOT_PASSWORD placeholders)

```shell
kubectl create secret generic SECRET_NAME --from-literal=password=PASSWORD --from-literal=root-password=ROOT_PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside each of the subsections: `rootCoord`, `dataCoord`, `indexCoord`, `dataNode`, `streamingNode`, `attu` and `queryNode`.

### External kafka support

You may want to have Milvus connect to an external kafka rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalKafka` parameter](#parameters). You should also disable the etcd installation with the `etcd.enabled` option. Here is an example:

```yaml
kafka:
  enabled: false
externalKafka:
  hosts:
    - externalhost
```

### External etcd support

You may want to have Milvus connect to an external etcd rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalEtcd` parameter](#parameters). You should also disable the etcd installation with the `etcd.enabled` option. Here is an example:

```yaml
etcd:
  enabled: false
externalEtcd:
  hosts:
    - externalhost
```

### External S3 support

You may want to have Milvus connect to an external storage streaming rather than installing MiniIO(TM) inside your cluster. To achieve this, the chart allows you to specify credentials for an external storage streaming with the [`externalS3` parameter](#parameters). You should also disable the MinIO(TM) installation with the `minio.enabled` option. Here is an example:

```console
minio.enabled=false
externalS3.host=myexternalhost
externalS3.accessKeyID=accesskey
externalS3.accessKeySecret=secret
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `attu.ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `attu.ingress.hostname` property can be used to set the host name. The `attu.ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `attu.ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `attu.ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `attu.ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Securing traffic using TLS

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

| Name                     | Description                                                                               | Value           |
| ------------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                               | `""`            |
| `apiVersions`            | Override Kubernetes API versions reported by .Capabilities                                | `[]`            |
| `nameOverride`           | String to partially override common.names.fullname                                        | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                            | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                     | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                            | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                         | `[]`            |
| `enableServiceLinks`     | Whether information about services should be injected into all pods' environment variable | `false`         |
| `usePasswordFiles`       | Mount credentials as files instead of using environment variables                         | `true`          |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)   | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployments/statefulsets                        | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployments/statefulsets                           | `["infinity"]`  |

### Common Milvus Parameters

| Name                                    | Description                                                                                                                                         | Value                      |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `milvus.image.registry`                 | Milvus image registry                                                                                                                               | `REGISTRY_NAME`            |
| `milvus.image.repository`               | Milvus image repository                                                                                                                             | `REPOSITORY_NAME/milvus`   |
| `milvus.image.digest`                   | Milvus image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                              | `""`                       |
| `milvus.image.pullPolicy`               | Milvus image pull policy                                                                                                                            | `IfNotPresent`             |
| `milvus.image.pullSecrets`              | Milvus image pull secrets                                                                                                                           | `[]`                       |
| `milvus.image.debug`                    | Enable debug mode                                                                                                                                   | `false`                    |
| `milvus.auth.enabled`                   | enable Milvus authentication                                                                                                                        | `false`                    |
| `milvus.auth.username`                  | Milvus username                                                                                                                                     | `user`                     |
| `milvus.auth.password`                  | Milvus username password                                                                                                                            | `""`                       |
| `milvus.auth.rootPassword`              | Milvus root password                                                                                                                                | `""`                       |
| `milvus.auth.existingSecret`            | Name of a secret containing the Milvus password                                                                                                     | `""`                       |
| `milvus.auth.existingSecretPasswordKey` | Name of the secret key containing the Milvus password                                                                                               | `""`                       |
| `milvus.defaultConfig`                  | Milvus components default configuration                                                                                                             | `""`                       |
| `milvus.extraConfig`                    | Extra configuration parameters                                                                                                                      | `{}`                       |
| `milvus.existingConfigMap`              | name of a ConfigMap with existing configuration for the default configuration                                                                       | `""`                       |
| `milvus.extraConfigExistingConfigMap`   | name of a ConfigMap with existing configuration                                                                                                     | `""`                       |
| `initJob.forceRun`                      | Force the run of the credential job                                                                                                                 | `false`                    |
| `initJob.image.registry`                | PyMilvus image registry                                                                                                                             | `REGISTRY_NAME`            |
| `initJob.image.repository`              | PyMilvus image repository                                                                                                                           | `REPOSITORY_NAME/pymilvus` |
| `initJob.image.digest`                  | PyMilvus image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                       |
| `initJob.image.pullPolicy`              | PyMilvus image pull policy                                                                                                                          | `IfNotPresent`             |
| `initJob.image.pullSecrets`             | PyMilvus image pull secrets                                                                                                                         | `[]`                       |
| `initJob.enableDefaultInitContainers`   | Deploy default init containers                                                                                                                      | `true`                     |

### TLS Client Configuration Parameters Connecting to Proxy

| Name                                                        | Description                                                                                                                                                                                                                       | Value            |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `initJob.tls.existingSecret`                                | Name of the existing secret containing the TLS certificates for initJob.                                                                                                                                                          | `""`             |
| `initJob.tls.cert`                                          | The secret key from the existingSecret if 'cert' key different from the default (client.pem)                                                                                                                                      | `client.pem`     |
| `initJob.tls.key`                                           | The secret key from the existingSecret if 'key' key different from the default (client.key)                                                                                                                                       | `client.key`     |
| `initJob.tls.caCert`                                        | The secret key from the existingSecret if 'caCert' key different from the default (ca.pem)                                                                                                                                        | `ca.pem`         |
| `initJob.tls.keyPassword`                                   | Password to access the password-protected PEM key if necessary.                                                                                                                                                                   | `""`             |
| `initJob.backoffLimit`                                      | set backoff limit of the job                                                                                                                                                                                                      | `10`             |
| `initJob.extraVolumes`                                      | Optionally specify extra list of additional volumes for the credential init job                                                                                                                                                   | `[]`             |
| `initJob.extraCommands`                                     | Extra commands to pass to the generation job                                                                                                                                                                                      | `""`             |
| `initJob.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`           |
| `initJob.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`             |
| `initJob.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`           |
| `initJob.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `1001`           |
| `initJob.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`           |
| `initJob.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`          |
| `initJob.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`           |
| `initJob.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`          |
| `initJob.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`        |
| `initJob.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault` |
| `initJob.podSecurityContext.enabled`                        | Enabled credential init job pods' Security Context                                                                                                                                                                                | `true`           |
| `initJob.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`         |
| `initJob.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`             |
| `initJob.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`             |
| `initJob.podSecurityContext.fsGroup`                        | Set credential init job pod's Security Context fsGroup                                                                                                                                                                            | `1001`           |
| `initJob.extraEnvVars`                                      | Array containing extra env vars to configure the credential init job                                                                                                                                                              | `[]`             |
| `initJob.extraEnvVarsCM`                                    | ConfigMap containing extra env vars to configure the credential init job                                                                                                                                                          | `""`             |
| `initJob.extraEnvVarsSecret`                                | Secret containing extra env vars to configure the credential init job (in case of sensitive data)                                                                                                                                 | `""`             |
| `initJob.extraVolumeMounts`                                 | Array of extra volume mounts to be added to the jwt Container (evaluated as template). Normally used with `extraVolumes`.                                                                                                         | `[]`             |
| `initJob.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if initJob.resources is set (initJob.resources is recommended for production). | `micro`          |
| `initJob.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`             |
| `initJob.livenessProbe.enabled`                             | Enable livenessProbe on init job                                                                                                                                                                                                  | `true`           |
| `initJob.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `5`              |
| `initJob.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`             |
| `initJob.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`              |
| `initJob.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `5`              |
| `initJob.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`              |
| `initJob.readinessProbe.enabled`                            | Enable readinessProbe on init job                                                                                                                                                                                                 | `true`           |
| `initJob.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `5`              |
| `initJob.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`             |
| `initJob.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `5`              |
| `initJob.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `5`              |
| `initJob.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`              |
| `initJob.startupProbe.enabled`                              | Enable startupProbe on init job                                                                                                                                                                                                   | `false`          |
| `initJob.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `5`              |
| `initJob.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`             |
| `initJob.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`              |
| `initJob.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `5`              |
| `initJob.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`              |
| `initJob.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`             |
| `initJob.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`             |
| `initJob.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`             |
| `initJob.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`          |
| `initJob.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                       | `[]`             |
| `initJob.annotations`                                       | Add annotations to the job                                                                                                                                                                                                        | `{}`             |
| `initJob.podLabels`                                         | Additional pod labels                                                                                                                                                                                                             | `{}`             |
| `initJob.podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                                        | `{}`             |
| `initJob.networkPolicy.enabled`                             | Enable creation of NetworkPolicy resources                                                                                                                                                                                        | `true`           |
| `initJob.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                   | `true`           |
| `initJob.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`             |
| `initJob.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`             |
| `initJob.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`             |
| `initJob.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                        | `{}`             |

### Coordinator Deployment Parameters

| Name                                                            | Description                                                                                                                                                                                                                               | Value            |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `coordinator.enabled`                                           | Enable Coordinator deployment                                                                                                                                                                                                             | `true`           |
| `coordinator.extraEnvVars`                                      | Array with extra environment variables to add to coordinator nodes                                                                                                                                                                        | `[]`             |
| `coordinator.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for coordinator nodes                                                                                                                                                                | `""`             |
| `coordinator.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for coordinator nodes                                                                                                                                                                   | `""`             |
| `coordinator.defaultConfig`                                     | Default override configuration from the common set in milvus.defaultConfig                                                                                                                                                                | `""`             |
| `coordinator.existingConfigMap`                                 | name of a ConfigMap with existing configuration for the default configuration                                                                                                                                                             | `""`             |
| `coordinator.extraConfig`                                       | Override configuration                                                                                                                                                                                                                    | `{}`             |
| `coordinator.extraConfigExistingConfigMap`                      | name of a ConfigMap with existing configuration                                                                                                                                                                                           | `""`             |
| `coordinator.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                      | `[]`             |
| `coordinator.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                         | `[]`             |
| `coordinator.replicaCount`                                      | Number of Coordinator replicas to deploy                                                                                                                                                                                                  | `1`              |
| `coordinator.containerPorts.metrics`                            | Metrics port for Coordinator                                                                                                                                                                                                              | `9091`           |
| `coordinator.livenessProbe.enabled`                             | Enable livenessProbe on Coordinator nodes                                                                                                                                                                                                 | `true`           |
| `coordinator.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                   | `5`              |
| `coordinator.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                          | `10`             |
| `coordinator.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                         | `5`              |
| `coordinator.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                       | `5`              |
| `coordinator.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                       | `1`              |
| `coordinator.readinessProbe.enabled`                            | Enable readinessProbe on Coordinator nodes                                                                                                                                                                                                | `true`           |
| `coordinator.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                  | `5`              |
| `coordinator.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                         | `10`             |
| `coordinator.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                        | `5`              |
| `coordinator.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                      | `5`              |
| `coordinator.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                      | `1`              |
| `coordinator.startupProbe.enabled`                              | Enable startupProbe on Coordinator containers                                                                                                                                                                                             | `false`          |
| `coordinator.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                    | `5`              |
| `coordinator.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                           | `10`             |
| `coordinator.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                          | `5`              |
| `coordinator.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                        | `5`              |
| `coordinator.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                        | `1`              |
| `coordinator.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                       | `{}`             |
| `coordinator.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                      | `{}`             |
| `coordinator.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                        | `{}`             |
| `coordinator.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if coordinator.resources is set (coordinator.resources is recommended for production). | `micro`          |
| `coordinator.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                         | `{}`             |
| `coordinator.podSecurityContext.enabled`                        | Enabled Coordinator pods' Security Context                                                                                                                                                                                                | `true`           |
| `coordinator.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                        | `Always`         |
| `coordinator.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                            | `[]`             |
| `coordinator.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                               | `[]`             |
| `coordinator.podSecurityContext.fsGroup`                        | Set Coordinator pod's Security Context fsGroup                                                                                                                                                                                            | `1001`           |
| `coordinator.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                      | `true`           |
| `coordinator.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                          | `{}`             |
| `coordinator.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                | `1001`           |
| `coordinator.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                               | `1001`           |
| `coordinator.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                             | `true`           |
| `coordinator.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                               | `false`          |
| `coordinator.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                   | `true`           |
| `coordinator.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                 | `false`          |
| `coordinator.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                        | `["ALL"]`        |
| `coordinator.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                          | `RuntimeDefault` |
| `coordinator.lifecycleHooks`                                    | for the coordinator container(s) to automate configuration before or after startup                                                                                                                                                        | `{}`             |
| `coordinator.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                                            | `""`             |
| `coordinator.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                        | `false`          |
| `coordinator.hostAliases`                                       | coordinator pods host aliases                                                                                                                                                                                                             | `[]`             |
| `coordinator.podLabels`                                         | Extra labels for coordinator pods                                                                                                                                                                                                         | `{}`             |
| `coordinator.podAnnotations`                                    | Annotations for coordinator pods                                                                                                                                                                                                          | `{}`             |
| `coordinator.podAffinityPreset`                                 | Pod affinity preset. Ignored if `coordinator.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`             |
| `coordinator.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `coordinator.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                      | `soft`           |
| `coordinator.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `coordinator.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`             |
| `coordinator.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `coordinator.affinity` is set                                                                                                                                                                         | `""`             |
| `coordinator.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `coordinator.affinity` is set                                                                                                                                                                      | `[]`             |
| `coordinator.affinity`                                          | Affinity for Coordinator pods assignment                                                                                                                                                                                                  | `{}`             |
| `coordinator.nodeSelector`                                      | Node labels for Coordinator pods assignment                                                                                                                                                                                               | `{}`             |
| `coordinator.tolerations`                                       | Tolerations for Coordinator pods assignment                                                                                                                                                                                               | `[]`             |
| `coordinator.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains                                                                                                                                           | `[]`             |
| `coordinator.priorityClassName`                                 | Coordinator pods' priorityClassName                                                                                                                                                                                                       | `""`             |
| `coordinator.schedulerName`                                     | Kubernetes pod scheduler registry                                                                                                                                                                                                         | `""`             |
| `coordinator.updateStrategy.type`                               | Coordinator statefulset strategy type                                                                                                                                                                                                     | `RollingUpdate`  |
| `coordinator.updateStrategy.rollingUpdate`                      | Coordinator statefulset rolling update configuration parameters                                                                                                                                                                           | `{}`             |
| `coordinator.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Coordinator pod(s)                                                                                                                                                            | `[]`             |
| `coordinator.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Coordinator container(s)                                                                                                                                                 | `[]`             |
| `coordinator.sidecars`                                          | Add additional sidecar containers to the Coordinator pod(s)                                                                                                                                                                               | `[]`             |
| `coordinator.enableDefaultInitContainers`                       | Deploy default init containers                                                                                                                                                                                                            | `true`           |
| `coordinator.initContainers`                                    | Add additional init containers to the Coordinator pod(s)                                                                                                                                                                                  | `[]`             |
| `coordinator.serviceAccount.create`                             | Enable creation of ServiceAccount for Coordinator pods                                                                                                                                                                                    | `true`           |
| `coordinator.serviceAccount.name`                               | The name of the ServiceAccount to use                                                                                                                                                                                                     | `""`             |
| `coordinator.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                                    | `false`          |
| `coordinator.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                      | `{}`             |
| `coordinator.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                           | `true`           |
| `coordinator.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                            | `{}`             |
| `coordinator.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `coordinator.pdb.minAvailable` and `coordinator.pdb.maxUnavailable` are empty.                                                                    | `{}`             |

### Coordinator Autoscaling configuration

| Name                                                  | Description                                                                                                                                                            | Value   |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `coordinator.autoscaling.vpa.enabled`                 | Enable VPA                                                                                                                                                             | `false` |
| `coordinator.autoscaling.vpa.annotations`             | Annotations for VPA resource                                                                                                                                           | `{}`    |
| `coordinator.autoscaling.vpa.controlledResources`     | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`    |
| `coordinator.autoscaling.vpa.maxAllowed`              | VPA Max allowed resources for the pod                                                                                                                                  | `{}`    |
| `coordinator.autoscaling.vpa.minAllowed`              | VPA Min allowed resources for the pod                                                                                                                                  | `{}`    |
| `coordinator.autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `coordinator.autoscaling.hpa.enabled`                 | Enable HPA for Milvus Coordinator                                                                                                                                      | `false` |
| `coordinator.autoscaling.hpa.annotations`             | Annotations for HPA resource                                                                                                                                           | `{}`    |
| `coordinator.autoscaling.hpa.minReplicas`             | Minimum number of Milvus Coordinator replicas                                                                                                                          | `""`    |
| `coordinator.autoscaling.hpa.maxReplicas`             | Maximum number of Milvus Coordinator replicas                                                                                                                          | `""`    |
| `coordinator.autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `coordinator.autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                                                   | `""`    |

### Coordinator Traffic Exposure Parameters

| Name                                                | Description                                                      | Value       |
| --------------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `coordinator.service.type`                          | Coordinator service type                                         | `ClusterIP` |
| `coordinator.service.ports.metrics`                 | Coordinator Metrics service port                                 | `9091`      |
| `coordinator.service.nodePorts.metrics`             | Node port for Metrics                                            | `""`        |
| `coordinator.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                      | `{}`        |
| `coordinator.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin | `None`      |
| `coordinator.service.clusterIP`                     | Coordinator service Cluster IP                                   | `""`        |
| `coordinator.service.loadBalancerIP`                | Coordinator service Load Balancer IP                             | `""`        |
| `coordinator.service.loadBalancerSourceRanges`      | Coordinator service Load Balancer sources                        | `[]`        |
| `coordinator.service.externalTrafficPolicy`         | Coordinator service external traffic policy                      | `Cluster`   |
| `coordinator.service.annotations`                   | Additional custom annotations for Coordinator service            | `{}`        |
| `coordinator.service.extraPorts`                    | Extra ports to expose in the Coordinator service                 | `[]`        |
| `coordinator.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                       | `true`      |
| `coordinator.networkPolicy.allowExternal`           | The Policy model to apply                                        | `true`      |
| `coordinator.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.  | `true`      |
| `coordinator.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `coordinator.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `coordinator.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces           | `{}`        |
| `coordinator.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces       | `{}`        |

### Coordinator Metrics Parameters

| Name                                                   | Description                                                                           | Value   |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------- | ------- |
| `coordinator.metrics.enabled`                          | Enable metrics                                                                        | `false` |
| `coordinator.metrics.annotations`                      | Annotations for the server service in order to scrape metrics                         | `{}`    |
| `coordinator.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator         | `false` |
| `coordinator.metrics.serviceMonitor.annotations`       | Annotations for the ServiceMonitor Resource                                           | `""`    |
| `coordinator.metrics.serviceMonitor.namespace`         | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)         | `""`    |
| `coordinator.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                          | `""`    |
| `coordinator.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                               | `""`    |
| `coordinator.metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `coordinator.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`    |
| `coordinator.metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`    |
| `coordinator.metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`    |
| `coordinator.metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                              | `false` |
| `coordinator.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`    |

### Data Node Deployment Parameters

| Name                                                         | Description                                                                                                                                                                                                                         | Value            |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `dataNode.enabled`                                           | Enable Data Node deployment                                                                                                                                                                                                         | `true`           |
| `dataNode.extraEnvVars`                                      | Array with extra environment variables to add to data node nodes                                                                                                                                                                    | `[]`             |
| `dataNode.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for data node nodes                                                                                                                                                            | `""`             |
| `dataNode.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for data node nodes                                                                                                                                                               | `""`             |
| `dataNode.defaultConfig`                                     | Default override configuration from the common set in milvus.defaultConfig                                                                                                                                                          | `""`             |
| `dataNode.existingConfigMap`                                 | name of a ConfigMap with existing configuration for the default configuration                                                                                                                                                       | `""`             |
| `dataNode.extraConfig`                                       | Override configuration                                                                                                                                                                                                              | `{}`             |
| `dataNode.extraConfigExistingConfigMap`                      | name of a ConfigMap with existing configuration                                                                                                                                                                                     | `""`             |
| `dataNode.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                | `[]`             |
| `dataNode.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                   | `[]`             |
| `dataNode.replicaCount`                                      | Number of Data Node replicas to deploy                                                                                                                                                                                              | `1`              |
| `dataNode.containerPorts.grpc`                               | GRPC port for Data Node                                                                                                                                                                                                             | `19530`          |
| `dataNode.containerPorts.metrics`                            | Metrics port for Data Node                                                                                                                                                                                                          | `9091`           |
| `dataNode.livenessProbe.enabled`                             | Enable livenessProbe on Data Node nodes                                                                                                                                                                                             | `true`           |
| `dataNode.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                             | `5`              |
| `dataNode.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                    | `10`             |
| `dataNode.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                   | `5`              |
| `dataNode.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                 | `5`              |
| `dataNode.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                 | `1`              |
| `dataNode.readinessProbe.enabled`                            | Enable readinessProbe on Data Node nodes                                                                                                                                                                                            | `true`           |
| `dataNode.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                            | `5`              |
| `dataNode.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                   | `10`             |
| `dataNode.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                  | `5`              |
| `dataNode.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                | `5`              |
| `dataNode.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                | `1`              |
| `dataNode.startupProbe.enabled`                              | Enable startupProbe on Data Node containers                                                                                                                                                                                         | `false`          |
| `dataNode.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                              | `5`              |
| `dataNode.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                     | `10`             |
| `dataNode.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                    | `5`              |
| `dataNode.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                  | `5`              |
| `dataNode.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                  | `1`              |
| `dataNode.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                 | `{}`             |
| `dataNode.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                | `{}`             |
| `dataNode.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                  | `{}`             |
| `dataNode.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if dataNode.resources is set (dataNode.resources is recommended for production). | `micro`          |
| `dataNode.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                   | `{}`             |
| `dataNode.podSecurityContext.enabled`                        | Enabled Data Node pods' Security Context                                                                                                                                                                                            | `true`           |
| `dataNode.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                  | `Always`         |
| `dataNode.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                      | `[]`             |
| `dataNode.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                         | `[]`             |
| `dataNode.podSecurityContext.fsGroup`                        | Set Data Node pod's Security Context fsGroup                                                                                                                                                                                        | `1001`           |
| `dataNode.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                | `true`           |
| `dataNode.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                    | `{}`             |
| `dataNode.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                          | `1001`           |
| `dataNode.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                         | `1001`           |
| `dataNode.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                       | `true`           |
| `dataNode.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                         | `false`          |
| `dataNode.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                             | `true`           |
| `dataNode.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                           | `false`          |
| `dataNode.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                  | `["ALL"]`        |
| `dataNode.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                    | `RuntimeDefault` |
| `dataNode.lifecycleHooks`                                    | for the data node container(s) to automate configuration before or after startup                                                                                                                                                    | `{}`             |
| `dataNode.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                                      | `""`             |
| `dataNode.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                  | `false`          |
| `dataNode.hostAliases`                                       | data node pods host aliases                                                                                                                                                                                                         | `[]`             |
| `dataNode.podLabels`                                         | Extra labels for data node pods                                                                                                                                                                                                     | `{}`             |
| `dataNode.podAnnotations`                                    | Annotations for data node pods                                                                                                                                                                                                      | `{}`             |
| `dataNode.podAffinityPreset`                                 | Pod affinity preset. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`             |
| `dataNode.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `soft`           |
| `dataNode.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`             |
| `dataNode.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `data node.affinity` is set                                                                                                                                                                     | `""`             |
| `dataNode.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `data node.affinity` is set                                                                                                                                                                  | `[]`             |
| `dataNode.affinity`                                          | Affinity for Data Node pods assignment                                                                                                                                                                                              | `{}`             |
| `dataNode.nodeSelector`                                      | Node labels for Data Node pods assignment                                                                                                                                                                                           | `{}`             |
| `dataNode.tolerations`                                       | Tolerations for Data Node pods assignment                                                                                                                                                                                           | `[]`             |
| `dataNode.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains                                                                                                                                     | `[]`             |
| `dataNode.priorityClassName`                                 | Data Node pods' priorityClassName                                                                                                                                                                                                   | `""`             |
| `dataNode.schedulerName`                                     | Kubernetes pod scheduler registry                                                                                                                                                                                                   | `""`             |
| `dataNode.updateStrategy.type`                               | Data Node statefulset strategy type                                                                                                                                                                                                 | `RollingUpdate`  |
| `dataNode.updateStrategy.rollingUpdate`                      | Data Node statefulset rolling update configuration parameters                                                                                                                                                                       | `{}`             |
| `dataNode.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Data Node pod(s)                                                                                                                                                        | `[]`             |
| `dataNode.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Data Node container(s)                                                                                                                                             | `[]`             |
| `dataNode.sidecars`                                          | Add additional sidecar containers to the Data Node pod(s)                                                                                                                                                                           | `[]`             |
| `dataNode.enableDefaultInitContainers`                       | Deploy default init containers                                                                                                                                                                                                      | `true`           |
| `dataNode.initContainers`                                    | Add additional init containers to the Data Node pod(s)                                                                                                                                                                              | `[]`             |
| `dataNode.serviceAccount.create`                             | Enable creation of ServiceAccount for Data Node pods                                                                                                                                                                                | `true`           |
| `dataNode.serviceAccount.name`                               | The name of the ServiceAccount to use                                                                                                                                                                                               | `""`             |
| `dataNode.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                              | `false`          |
| `dataNode.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                | `{}`             |
| `dataNode.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                     | `true`           |
| `dataNode.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                      | `{}`             |
| `dataNode.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `dataNode.pdb.minAvailable` and `dataNode.pdb.maxUnavailable` are empty.                                                                    | `{}`             |

### Data Node Autoscaling configuration

| Name                                               | Description                                                                                                                                                            | Value   |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `dataNode.autoscaling.vpa.enabled`                 | Enable VPA                                                                                                                                                             | `false` |
| `dataNode.autoscaling.vpa.annotations`             | Annotations for VPA resource                                                                                                                                           | `{}`    |
| `dataNode.autoscaling.vpa.controlledResources`     | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`    |
| `dataNode.autoscaling.vpa.maxAllowed`              | VPA Max allowed resources for the pod                                                                                                                                  | `{}`    |
| `dataNode.autoscaling.vpa.minAllowed`              | VPA Min allowed resources for the pod                                                                                                                                  | `{}`    |
| `dataNode.autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `dataNode.autoscaling.hpa.enabled`                 | Enable HPA for Milvus Data node                                                                                                                                        | `false` |
| `dataNode.autoscaling.hpa.annotations`             | Annotations for HPA resource                                                                                                                                           | `{}`    |
| `dataNode.autoscaling.hpa.minReplicas`             | Minimum number of Milvus Data node replicas                                                                                                                            | `""`    |
| `dataNode.autoscaling.hpa.maxReplicas`             | Maximum number of Milvus Data node replicas                                                                                                                            | `""`    |
| `dataNode.autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `dataNode.autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                                                   | `""`    |

### Data Node Traffic Exposure Parameters

| Name                                             | Description                                                      | Value       |
| ------------------------------------------------ | ---------------------------------------------------------------- | ----------- |
| `dataNode.service.type`                          | Data Node service type                                           | `ClusterIP` |
| `dataNode.service.ports.grpc`                    | Data Node GRPC service port                                      | `19530`     |
| `dataNode.service.ports.metrics`                 | Data Node Metrics service port                                   | `9091`      |
| `dataNode.service.nodePorts.grpc`                | Node port for GRPC                                               | `""`        |
| `dataNode.service.nodePorts.metrics`             | Node port for Metrics                                            | `""`        |
| `dataNode.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                      | `{}`        |
| `dataNode.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin | `None`      |
| `dataNode.service.clusterIP`                     | Data Node service Cluster IP                                     | `""`        |
| `dataNode.service.loadBalancerIP`                | Data Node service Load Balancer IP                               | `""`        |
| `dataNode.service.loadBalancerSourceRanges`      | Data Node service Load Balancer sources                          | `[]`        |
| `dataNode.service.externalTrafficPolicy`         | Data Node service external traffic policy                        | `Cluster`   |
| `dataNode.service.annotations`                   | Additional custom annotations for Data Node service              | `{}`        |
| `dataNode.service.extraPorts`                    | Extra ports to expose in the Data Node service                   | `[]`        |
| `dataNode.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                       | `true`      |
| `dataNode.networkPolicy.allowExternal`           | The Policy model to apply                                        | `true`      |
| `dataNode.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.  | `true`      |
| `dataNode.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `dataNode.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `dataNode.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces           | `{}`        |
| `dataNode.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces       | `{}`        |

### Data Node Metrics Parameters

| Name                                                | Description                                                                           | Value   |
| --------------------------------------------------- | ------------------------------------------------------------------------------------- | ------- |
| `dataNode.metrics.enabled`                          | Enable metrics                                                                        | `false` |
| `dataNode.metrics.annotations`                      | Annotations for the server service in order to scrape metrics                         | `{}`    |
| `dataNode.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator         | `false` |
| `dataNode.metrics.serviceMonitor.annotations`       | Annotations for the ServiceMonitor Resource                                           | `""`    |
| `dataNode.metrics.serviceMonitor.namespace`         | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)         | `""`    |
| `dataNode.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                          | `""`    |
| `dataNode.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                               | `""`    |
| `dataNode.metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `dataNode.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`    |
| `dataNode.metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`    |
| `dataNode.metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`    |
| `dataNode.metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                              | `false` |
| `dataNode.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`    |

### Query Node Deployment Parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value            |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `queryNode.enabled`                                           | Enable Query Node deployment                                                                                                                                                                                                          | `true`           |
| `queryNode.extraEnvVars`                                      | Array with extra environment variables to add to data node nodes                                                                                                                                                                      | `[]`             |
| `queryNode.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for data node nodes                                                                                                                                                              | `""`             |
| `queryNode.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for data node nodes                                                                                                                                                                 | `""`             |
| `queryNode.defaultConfig`                                     | Default override configuration from the common set in milvus.defaultConfig                                                                                                                                                            | `""`             |
| `queryNode.existingConfigMap`                                 | name of a ConfigMap with existing configuration for the default configuration                                                                                                                                                         | `""`             |
| `queryNode.extraConfig`                                       | Override configuration                                                                                                                                                                                                                | `{}`             |
| `queryNode.extraConfigExistingConfigMap`                      | name of a ConfigMap with existing configuration                                                                                                                                                                                       | `""`             |
| `queryNode.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                  | `[]`             |
| `queryNode.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                     | `[]`             |
| `queryNode.replicaCount`                                      | Number of Query Node replicas to deploy                                                                                                                                                                                               | `1`              |
| `queryNode.containerPorts.grpc`                               | GRPC port for Query Node                                                                                                                                                                                                              | `19530`          |
| `queryNode.containerPorts.metrics`                            | Metrics port for Query Node                                                                                                                                                                                                           | `9091`           |
| `queryNode.livenessProbe.enabled`                             | Enable livenessProbe on Query Node nodes                                                                                                                                                                                              | `true`           |
| `queryNode.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `5`              |
| `queryNode.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`             |
| `queryNode.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `5`              |
| `queryNode.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `5`              |
| `queryNode.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`              |
| `queryNode.readinessProbe.enabled`                            | Enable readinessProbe on Query Node nodes                                                                                                                                                                                             | `true`           |
| `queryNode.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `5`              |
| `queryNode.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`             |
| `queryNode.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `5`              |
| `queryNode.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `5`              |
| `queryNode.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`              |
| `queryNode.startupProbe.enabled`                              | Enable startupProbe on Query Node containers                                                                                                                                                                                          | `false`          |
| `queryNode.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `5`              |
| `queryNode.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `10`             |
| `queryNode.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `5`              |
| `queryNode.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `5`              |
| `queryNode.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`              |
| `queryNode.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                   | `{}`             |
| `queryNode.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                  | `{}`             |
| `queryNode.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                    | `{}`             |
| `queryNode.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if queryNode.resources is set (queryNode.resources is recommended for production). | `micro`          |
| `queryNode.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`             |
| `queryNode.podSecurityContext.enabled`                        | Enabled Query Node pods' Security Context                                                                                                                                                                                             | `true`           |
| `queryNode.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`         |
| `queryNode.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`             |
| `queryNode.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`             |
| `queryNode.podSecurityContext.fsGroup`                        | Set Query Node pod's Security Context fsGroup                                                                                                                                                                                         | `1001`           |
| `queryNode.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`           |
| `queryNode.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `{}`             |
| `queryNode.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `1001`           |
| `queryNode.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `1001`           |
| `queryNode.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `true`           |
| `queryNode.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`          |
| `queryNode.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`           |
| `queryNode.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`          |
| `queryNode.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`        |
| `queryNode.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault` |
| `queryNode.lifecycleHooks`                                    | for the data node container(s) to automate configuration before or after startup                                                                                                                                                      | `{}`             |
| `queryNode.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                                        | `""`             |
| `queryNode.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `false`          |
| `queryNode.hostAliases`                                       | data node pods host aliases                                                                                                                                                                                                           | `[]`             |
| `queryNode.podLabels`                                         | Extra labels for data node pods                                                                                                                                                                                                       | `{}`             |
| `queryNode.podAnnotations`                                    | Annotations for data node pods                                                                                                                                                                                                        | `{}`             |
| `queryNode.podAffinityPreset`                                 | Pod affinity preset. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                         | `""`             |
| `queryNode.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `soft`           |
| `queryNode.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`             |
| `queryNode.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `data node.affinity` is set                                                                                                                                                                       | `""`             |
| `queryNode.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `data node.affinity` is set                                                                                                                                                                    | `[]`             |
| `queryNode.affinity`                                          | Affinity for Query Node pods assignment                                                                                                                                                                                               | `{}`             |
| `queryNode.nodeSelector`                                      | Node labels for Query Node pods assignment                                                                                                                                                                                            | `{}`             |
| `queryNode.tolerations`                                       | Tolerations for Query Node pods assignment                                                                                                                                                                                            | `[]`             |
| `queryNode.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains                                                                                                                                       | `[]`             |
| `queryNode.priorityClassName`                                 | Query Node pods' priorityClassName                                                                                                                                                                                                    | `""`             |
| `queryNode.schedulerName`                                     | Kubernetes pod scheduler registry                                                                                                                                                                                                     | `""`             |
| `queryNode.updateStrategy.type`                               | Query Node statefulset strategy type                                                                                                                                                                                                  | `RollingUpdate`  |
| `queryNode.updateStrategy.rollingUpdate`                      | Query Node statefulset rolling update configuration parameters                                                                                                                                                                        | `{}`             |
| `queryNode.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Query Node pod(s)                                                                                                                                                         | `[]`             |
| `queryNode.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Query Node container(s)                                                                                                                                              | `[]`             |
| `queryNode.sidecars`                                          | Add additional sidecar containers to the Query Node pod(s)                                                                                                                                                                            | `[]`             |
| `queryNode.enableDefaultInitContainers`                       | Deploy default init containers                                                                                                                                                                                                        | `true`           |
| `queryNode.initContainers`                                    | Add additional init containers to the Query Node pod(s)                                                                                                                                                                               | `[]`             |
| `queryNode.serviceAccount.create`                             | Enable creation of ServiceAccount for Query Node pods                                                                                                                                                                                 | `true`           |
| `queryNode.serviceAccount.name`                               | The name of the ServiceAccount to use                                                                                                                                                                                                 | `""`             |
| `queryNode.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                                | `false`          |
| `queryNode.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                  | `{}`             |
| `queryNode.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                       | `true`           |
| `queryNode.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                        | `{}`             |
| `queryNode.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `queryNode.pdb.minAvailable` and `queryNode.pdb.maxUnavailable` are empty.                                                                    | `{}`             |

### Query Node Autoscaling configuration

| Name                                                | Description                                                                                                                                                            | Value   |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `queryNode.autoscaling.vpa.enabled`                 | Enable VPA                                                                                                                                                             | `false` |
| `queryNode.autoscaling.vpa.annotations`             | Annotations for VPA resource                                                                                                                                           | `{}`    |
| `queryNode.autoscaling.vpa.controlledResources`     | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`    |
| `queryNode.autoscaling.vpa.maxAllowed`              | VPA Max allowed resources for the pod                                                                                                                                  | `{}`    |
| `queryNode.autoscaling.vpa.minAllowed`              | VPA Min allowed resources for the pod                                                                                                                                  | `{}`    |
| `queryNode.autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `queryNode.autoscaling.hpa.enabled`                 | Enable HPA for Milvus Query node                                                                                                                                       | `false` |
| `queryNode.autoscaling.hpa.annotations`             | Annotations for HPA resource                                                                                                                                           | `{}`    |
| `queryNode.autoscaling.hpa.minReplicas`             | Minimum number of Milvus Query node replicas                                                                                                                           | `""`    |
| `queryNode.autoscaling.hpa.maxReplicas`             | Maximum number of Milvus Query node replicas                                                                                                                           | `""`    |
| `queryNode.autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `queryNode.autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                                                   | `""`    |

### Query Node Traffic Exposure Parameters

| Name                                              | Description                                                      | Value       |
| ------------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `queryNode.service.type`                          | Query Node service type                                          | `ClusterIP` |
| `queryNode.service.ports.grpc`                    | Query Node GRPC service port                                     | `19530`     |
| `queryNode.service.ports.metrics`                 | Query Node Metrics service port                                  | `9091`      |
| `queryNode.service.nodePorts.grpc`                | Node port for GRPC                                               | `""`        |
| `queryNode.service.nodePorts.metrics`             | Node port for Metrics                                            | `""`        |
| `queryNode.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                      | `{}`        |
| `queryNode.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin | `None`      |
| `queryNode.service.clusterIP`                     | Query Node service Cluster IP                                    | `""`        |
| `queryNode.service.loadBalancerIP`                | Query Node service Load Balancer IP                              | `""`        |
| `queryNode.service.loadBalancerSourceRanges`      | Query Node service Load Balancer sources                         | `[]`        |
| `queryNode.service.externalTrafficPolicy`         | Query Node service external traffic policy                       | `Cluster`   |
| `queryNode.service.annotations`                   | Additional custom annotations for Query Node service             | `{}`        |
| `queryNode.service.extraPorts`                    | Extra ports to expose in the Query Node service                  | `[]`        |
| `queryNode.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                       | `true`      |
| `queryNode.networkPolicy.allowExternal`           | The Policy model to apply                                        | `true`      |
| `queryNode.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.  | `true`      |
| `queryNode.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `queryNode.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `queryNode.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces           | `{}`        |
| `queryNode.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces       | `{}`        |

### Query Node Metrics Parameters

| Name                                                 | Description                                                                           | Value   |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------- | ------- |
| `queryNode.metrics.enabled`                          | Enable metrics                                                                        | `false` |
| `queryNode.metrics.annotations`                      | Annotations for the server service in order to scrape metrics                         | `{}`    |
| `queryNode.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator         | `false` |
| `queryNode.metrics.serviceMonitor.annotations`       | Annotations for the ServiceMonitor Resource                                           | `""`    |
| `queryNode.metrics.serviceMonitor.namespace`         | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)         | `""`    |
| `queryNode.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                          | `""`    |
| `queryNode.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                               | `""`    |
| `queryNode.metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `queryNode.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`    |
| `queryNode.metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`    |
| `queryNode.metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`    |
| `queryNode.metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                              | `false` |
| `queryNode.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`    |

### Streaming Node Deployment Parameters

| Name                                                              | Description                                                                                                                                                                                                                                   | Value            |
| ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `streamingNode.enabled`                                           | Enable Streaming Node deployment                                                                                                                                                                                                              | `true`           |
| `streamingNode.extraEnvVars`                                      | Array with extra environment variables to add to data node nodes                                                                                                                                                                              | `[]`             |
| `streamingNode.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for data node nodes                                                                                                                                                                      | `""`             |
| `streamingNode.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for data node nodes                                                                                                                                                                         | `""`             |
| `streamingNode.defaultConfig`                                     | Default override configuration from the common set in milvus.defaultConfig                                                                                                                                                                    | `""`             |
| `streamingNode.existingConfigMap`                                 | name of a ConfigMap with existing configuration for the default configuration                                                                                                                                                                 | `""`             |
| `streamingNode.extraConfig`                                       | Override configuration                                                                                                                                                                                                                        | `{}`             |
| `streamingNode.extraConfigExistingConfigMap`                      | name of a ConfigMap with existing configuration                                                                                                                                                                                               | `""`             |
| `streamingNode.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                          | `[]`             |
| `streamingNode.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                             | `[]`             |
| `streamingNode.replicaCount`                                      | Number of Streaming Node replicas to deploy                                                                                                                                                                                                   | `1`              |
| `streamingNode.containerPorts.grpc`                               | GRPC port for Streaming Node                                                                                                                                                                                                                  | `19530`          |
| `streamingNode.containerPorts.metrics`                            | Metrics port for Streaming Node                                                                                                                                                                                                               | `9091`           |
| `streamingNode.livenessProbe.enabled`                             | Enable livenessProbe on Streaming Node nodes                                                                                                                                                                                                  | `true`           |
| `streamingNode.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                       | `5`              |
| `streamingNode.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                              | `10`             |
| `streamingNode.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                             | `5`              |
| `streamingNode.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                           | `5`              |
| `streamingNode.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                           | `1`              |
| `streamingNode.readinessProbe.enabled`                            | Enable readinessProbe on Streaming Node nodes                                                                                                                                                                                                 | `true`           |
| `streamingNode.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                      | `5`              |
| `streamingNode.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                             | `10`             |
| `streamingNode.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                            | `5`              |
| `streamingNode.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                          | `5`              |
| `streamingNode.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                          | `1`              |
| `streamingNode.startupProbe.enabled`                              | Enable startupProbe on Streaming Node containers                                                                                                                                                                                              | `false`          |
| `streamingNode.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                        | `5`              |
| `streamingNode.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                               | `10`             |
| `streamingNode.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                              | `5`              |
| `streamingNode.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                            | `5`              |
| `streamingNode.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                            | `1`              |
| `streamingNode.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                           | `{}`             |
| `streamingNode.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                          | `{}`             |
| `streamingNode.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                            | `{}`             |
| `streamingNode.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if streamingNode.resources is set (streamingNode.resources is recommended for production). | `micro`          |
| `streamingNode.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                             | `{}`             |
| `streamingNode.podSecurityContext.enabled`                        | Enabled Streaming Node pods' Security Context                                                                                                                                                                                                 | `true`           |
| `streamingNode.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                            | `Always`         |
| `streamingNode.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                | `[]`             |
| `streamingNode.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                   | `[]`             |
| `streamingNode.podSecurityContext.fsGroup`                        | Set Streaming Node pod's Security Context fsGroup                                                                                                                                                                                             | `1001`           |
| `streamingNode.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                          | `true`           |
| `streamingNode.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                              | `{}`             |
| `streamingNode.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                                    | `1001`           |
| `streamingNode.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                                   | `1001`           |
| `streamingNode.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                                 | `true`           |
| `streamingNode.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                                   | `false`          |
| `streamingNode.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                       | `true`           |
| `streamingNode.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                                     | `false`          |
| `streamingNode.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                            | `["ALL"]`        |
| `streamingNode.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                              | `RuntimeDefault` |
| `streamingNode.lifecycleHooks`                                    | for the data node container(s) to automate configuration before or after startup                                                                                                                                                              | `{}`             |
| `streamingNode.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                                                | `""`             |
| `streamingNode.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                            | `false`          |
| `streamingNode.hostAliases`                                       | data node pods host aliases                                                                                                                                                                                                                   | `[]`             |
| `streamingNode.podLabels`                                         | Extra labels for data node pods                                                                                                                                                                                                               | `{}`             |
| `streamingNode.podAnnotations`                                    | Annotations for data node pods                                                                                                                                                                                                                | `{}`             |
| `streamingNode.podAffinityPreset`                                 | Pod affinity preset. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                 | `""`             |
| `streamingNode.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                            | `soft`           |
| `streamingNode.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `data node.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                           | `""`             |
| `streamingNode.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `data node.affinity` is set                                                                                                                                                                               | `""`             |
| `streamingNode.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `data node.affinity` is set                                                                                                                                                                            | `[]`             |
| `streamingNode.affinity`                                          | Affinity for Streaming Node pods assignment                                                                                                                                                                                                   | `{}`             |
| `streamingNode.nodeSelector`                                      | Node labels for Streaming Node pods assignment                                                                                                                                                                                                | `{}`             |
| `streamingNode.tolerations`                                       | Tolerations for Streaming Node pods assignment                                                                                                                                                                                                | `[]`             |
| `streamingNode.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains                                                                                                                                               | `[]`             |
| `streamingNode.priorityClassName`                                 | Streaming Node pods' priorityClassName                                                                                                                                                                                                        | `""`             |
| `streamingNode.schedulerName`                                     | Kubernetes pod scheduler registry                                                                                                                                                                                                             | `""`             |
| `streamingNode.updateStrategy.type`                               | Streaming Node statefulset strategy type                                                                                                                                                                                                      | `RollingUpdate`  |
| `streamingNode.updateStrategy.rollingUpdate`                      | Streaming Node statefulset rolling update configuration parameters                                                                                                                                                                            | `{}`             |
| `streamingNode.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Streaming Node pod(s)                                                                                                                                                             | `[]`             |
| `streamingNode.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Streaming Node container(s)                                                                                                                                                  | `[]`             |
| `streamingNode.sidecars`                                          | Add additional sidecar containers to the Streaming Node pod(s)                                                                                                                                                                                | `[]`             |
| `streamingNode.enableDefaultInitContainers`                       | Deploy default init containers                                                                                                                                                                                                                | `true`           |
| `streamingNode.initContainers`                                    | Add additional init containers to the Streaming Node pod(s)                                                                                                                                                                                   | `[]`             |
| `streamingNode.serviceAccount.create`                             | Enable creation of ServiceAccount for Streaming Node pods                                                                                                                                                                                     | `true`           |
| `streamingNode.serviceAccount.name`                               | The name of the ServiceAccount to use                                                                                                                                                                                                         | `""`             |
| `streamingNode.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                                        | `false`          |
| `streamingNode.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                          | `{}`             |
| `streamingNode.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                               | `true`           |
| `streamingNode.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                                | `{}`             |
| `streamingNode.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `streamingNode.pdb.minAvailable` and `streamingNode.pdb.maxUnavailable` are empty.                                                                    | `{}`             |

### Streaming Node Autoscaling configuration

| Name                                                    | Description                                                                                                                                                            | Value   |
| ------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `streamingNode.autoscaling.vpa.enabled`                 | Enable VPA                                                                                                                                                             | `false` |
| `streamingNode.autoscaling.vpa.annotations`             | Annotations for VPA resource                                                                                                                                           | `{}`    |
| `streamingNode.autoscaling.vpa.controlledResources`     | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`    |
| `streamingNode.autoscaling.vpa.maxAllowed`              | VPA Max allowed resources for the pod                                                                                                                                  | `{}`    |
| `streamingNode.autoscaling.vpa.minAllowed`              | VPA Min allowed resources for the pod                                                                                                                                  | `{}`    |
| `streamingNode.autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `streamingNode.autoscaling.hpa.enabled`                 | Enable HPA for Milvus Streaming node                                                                                                                                   | `false` |
| `streamingNode.autoscaling.hpa.annotations`             | Annotations for HPA resource                                                                                                                                           | `{}`    |
| `streamingNode.autoscaling.hpa.minReplicas`             | Minimum number of Milvus Streaming node replicas                                                                                                                       | `""`    |
| `streamingNode.autoscaling.hpa.maxReplicas`             | Maximum number of Milvus Streaming node replicas                                                                                                                       | `""`    |
| `streamingNode.autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `streamingNode.autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                                                   | `""`    |

### Streaming Node Traffic Exposure Parameters

| Name                                                  | Description                                                      | Value       |
| ----------------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `streamingNode.service.type`                          | Streaming Node service type                                      | `ClusterIP` |
| `streamingNode.service.ports.grpc`                    | Streaming Node GRPC service port                                 | `19530`     |
| `streamingNode.service.ports.metrics`                 | Streaming Node Metrics service port                              | `9091`      |
| `streamingNode.service.nodePorts.grpc`                | Node port for GRPC                                               | `""`        |
| `streamingNode.service.nodePorts.metrics`             | Node port for Metrics                                            | `""`        |
| `streamingNode.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                      | `{}`        |
| `streamingNode.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin | `None`      |
| `streamingNode.service.clusterIP`                     | Streaming Node service Cluster IP                                | `""`        |
| `streamingNode.service.loadBalancerIP`                | Streaming Node service Load Balancer IP                          | `""`        |
| `streamingNode.service.loadBalancerSourceRanges`      | Streaming Node service Load Balancer sources                     | `[]`        |
| `streamingNode.service.externalTrafficPolicy`         | Streaming Node service external traffic policy                   | `Cluster`   |
| `streamingNode.service.annotations`                   | Additional custom annotations for Streaming Node service         | `{}`        |
| `streamingNode.service.extraPorts`                    | Extra ports to expose in the Streaming Node service              | `[]`        |
| `streamingNode.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                       | `true`      |
| `streamingNode.networkPolicy.allowExternal`           | The Policy model to apply                                        | `true`      |
| `streamingNode.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.  | `true`      |
| `streamingNode.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `streamingNode.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                     | `[]`        |
| `streamingNode.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces           | `{}`        |
| `streamingNode.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces       | `{}`        |

### Streaming Node Metrics Parameters

| Name                                                     | Description                                                                           | Value   |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------- | ------- |
| `streamingNode.metrics.enabled`                          | Enable metrics                                                                        | `false` |
| `streamingNode.metrics.annotations`                      | Annotations for the server service in order to scrape metrics                         | `{}`    |
| `streamingNode.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator         | `false` |
| `streamingNode.metrics.serviceMonitor.annotations`       | Annotations for the ServiceMonitor Resource                                           | `""`    |
| `streamingNode.metrics.serviceMonitor.namespace`         | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)         | `""`    |
| `streamingNode.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                          | `""`    |
| `streamingNode.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                               | `""`    |
| `streamingNode.metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `streamingNode.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`    |
| `streamingNode.metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`    |
| `streamingNode.metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`    |
| `streamingNode.metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                              | `false` |
| `streamingNode.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`    |

### Proxy Deployment Parameters

| Name            | Description             | Value  |
| --------------- | ----------------------- | ------ |
| `proxy.enabled` | Enable Proxy deployment | `true` |

### Proxy TLS Connection Configuration Parameters

| Name                                                      | Description                                                                                                                                                                                                                   | Value            |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `proxy.tls.mode`                                          | TLS mode for proxy. Allowed values: `0`, `1`, `2`                                                                                                                                                                             | `0`              |
| `proxy.tls.existingSecret`                                | Name of the existing secret containing the TLS certificates for proxy.                                                                                                                                                        | `""`             |
| `proxy.tls.cert`                                          | The secret key from the existingSecret if 'cert' key different from the default (server.pem)                                                                                                                                  | `server.pem`     |
| `proxy.tls.key`                                           | The secret key from the existingSecret if 'key' key different from the default (server.key)                                                                                                                                   | `server.key`     |
| `proxy.tls.caCert`                                        | The secret key from the existingSecret if 'caCert' key different from the default (ca.pem)                                                                                                                                    | `ca.pem`         |
| `proxy.tls.keyPassword`                                   | Password to access the password-protected PEM key if necessary.                                                                                                                                                               | `""`             |
| `proxy.extraEnvVars`                                      | Array with extra environment variables to add to proxy nodes                                                                                                                                                                  | `[]`             |
| `proxy.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for proxy nodes                                                                                                                                                          | `""`             |
| `proxy.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for proxy nodes                                                                                                                                                             | `""`             |
| `proxy.defaultConfig`                                     | Default override configuration from the common set in milvus.defaultConfig                                                                                                                                                    | `""`             |
| `proxy.existingConfigMap`                                 | name of a ConfigMap with existing configuration for the default configuration                                                                                                                                                 | `""`             |
| `proxy.extraConfig`                                       | Override configuration                                                                                                                                                                                                        | `{}`             |
| `proxy.extraConfigExistingConfigMap`                      | name of a ConfigMap with existing configuration for the proxy nodes                                                                                                                                                           | `""`             |
| `proxy.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                          | `[]`             |
| `proxy.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                             | `[]`             |
| `proxy.replicaCount`                                      | Number of Proxy replicas to deploy                                                                                                                                                                                            | `1`              |
| `proxy.containerPorts.grpc`                               | GRPC port for Proxy                                                                                                                                                                                                           | `19530`          |
| `proxy.containerPorts.grpcInternal`                       | GRPC internal port for Proxy                                                                                                                                                                                                  | `19529`          |
| `proxy.containerPorts.metrics`                            | Metrics port for Proxy                                                                                                                                                                                                        | `9091`           |
| `proxy.livenessProbe.enabled`                             | Enable livenessProbe on Proxy nodes                                                                                                                                                                                           | `true`           |
| `proxy.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                       | `5`              |
| `proxy.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                              | `10`             |
| `proxy.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                             | `5`              |
| `proxy.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                           | `5`              |
| `proxy.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                           | `1`              |
| `proxy.readinessProbe.enabled`                            | Enable readinessProbe on Proxy nodes                                                                                                                                                                                          | `true`           |
| `proxy.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                      | `5`              |
| `proxy.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                             | `10`             |
| `proxy.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                            | `5`              |
| `proxy.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                          | `5`              |
| `proxy.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                          | `1`              |
| `proxy.startupProbe.enabled`                              | Enable startupProbe on Proxy containers                                                                                                                                                                                       | `false`          |
| `proxy.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                        | `5`              |
| `proxy.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                               | `10`             |
| `proxy.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                              | `5`              |
| `proxy.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                            | `5`              |
| `proxy.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                            | `1`              |
| `proxy.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                           | `{}`             |
| `proxy.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                          | `{}`             |
| `proxy.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                            | `{}`             |
| `proxy.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if proxy.resources is set (proxy.resources is recommended for production). | `micro`          |
| `proxy.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                             | `{}`             |
| `proxy.podSecurityContext.enabled`                        | Enabled Proxy pods' Security Context                                                                                                                                                                                          | `true`           |
| `proxy.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                            | `Always`         |
| `proxy.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                | `[]`             |
| `proxy.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                   | `[]`             |
| `proxy.podSecurityContext.fsGroup`                        | Set Proxy pod's Security Context fsGroup                                                                                                                                                                                      | `1001`           |
| `proxy.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                          | `true`           |
| `proxy.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                              | `{}`             |
| `proxy.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                    | `1001`           |
| `proxy.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                   | `1001`           |
| `proxy.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                 | `true`           |
| `proxy.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                   | `false`          |
| `proxy.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                       | `true`           |
| `proxy.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                     | `false`          |
| `proxy.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                            | `["ALL"]`        |
| `proxy.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                              | `RuntimeDefault` |
| `proxy.lifecycleHooks`                                    | for the proxy container(s) to automate configuration before or after startup                                                                                                                                                  | `{}`             |
| `proxy.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                                | `""`             |
| `proxy.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                            | `false`          |
| `proxy.hostAliases`                                       | proxy pods host aliases                                                                                                                                                                                                       | `[]`             |
| `proxy.podLabels`                                         | Extra labels for proxy pods                                                                                                                                                                                                   | `{}`             |
| `proxy.podAnnotations`                                    | Annotations for proxy pods                                                                                                                                                                                                    | `{}`             |
| `proxy.podAffinityPreset`                                 | Pod affinity preset. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `""`             |
| `proxy.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `soft`           |
| `proxy.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `proxy.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `proxy.affinity` is set                                                                                                                                                                   | `""`             |
| `proxy.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `proxy.affinity` is set                                                                                                                                                                | `[]`             |
| `proxy.affinity`                                          | Affinity for Proxy pods assignment                                                                                                                                                                                            | `{}`             |
| `proxy.nodeSelector`                                      | Node labels for Proxy pods assignment                                                                                                                                                                                         | `{}`             |
| `proxy.tolerations`                                       | Tolerations for Proxy pods assignment                                                                                                                                                                                         | `[]`             |
| `proxy.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains                                                                                                                               | `[]`             |
| `proxy.priorityClassName`                                 | Proxy pods' priorityClassName                                                                                                                                                                                                 | `""`             |
| `proxy.schedulerName`                                     | Kubernetes pod scheduler registry                                                                                                                                                                                             | `""`             |
| `proxy.updateStrategy.type`                               | Proxy statefulset strategy type                                                                                                                                                                                               | `RollingUpdate`  |
| `proxy.updateStrategy.rollingUpdate`                      | Proxy statefulset rolling update configuration parameters                                                                                                                                                                     | `{}`             |
| `proxy.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Proxy pod(s)                                                                                                                                                      | `[]`             |
| `proxy.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Proxy container(s)                                                                                                                                           | `[]`             |
| `proxy.sidecars`                                          | Add additional sidecar containers to the Proxy pod(s)                                                                                                                                                                         | `[]`             |
| `proxy.enableDefaultInitContainers`                       | Deploy default init containers                                                                                                                                                                                                | `true`           |
| `proxy.initContainers`                                    | Add additional init containers to the Proxy pod(s)                                                                                                                                                                            | `[]`             |
| `proxy.serviceAccount.create`                             | Enable creation of ServiceAccount for Proxy pods                                                                                                                                                                              | `true`           |
| `proxy.serviceAccount.name`                               | The name of the ServiceAccount to use                                                                                                                                                                                         | `""`             |
| `proxy.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                        | `false`          |
| `proxy.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                          | `{}`             |
| `proxy.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                               | `true`           |
| `proxy.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                | `{}`             |
| `proxy.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `proxy.pdb.minAvailable` and `proxy.pdb.maxUnavailable` are empty.                                                                    | `{}`             |

### Proxy Autoscaling configuration

| Name                                            | Description                                                                                                                                                            | Value   |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `proxy.autoscaling.vpa.enabled`                 | Enable VPA                                                                                                                                                             | `false` |
| `proxy.autoscaling.vpa.annotations`             | Annotations for VPA resource                                                                                                                                           | `{}`    |
| `proxy.autoscaling.vpa.controlledResources`     | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`    |
| `proxy.autoscaling.vpa.maxAllowed`              | VPA Max allowed resources for the pod                                                                                                                                  | `{}`    |
| `proxy.autoscaling.vpa.minAllowed`              | VPA Min allowed resources for the pod                                                                                                                                  | `{}`    |
| `proxy.autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `proxy.autoscaling.hpa.enabled`                 | Enable HPA for Milvus proxy                                                                                                                                            | `false` |
| `proxy.autoscaling.hpa.annotations`             | Annotations for HPA resource                                                                                                                                           | `{}`    |
| `proxy.autoscaling.hpa.minReplicas`             | Minimum number of Milvus proxy replicas                                                                                                                                | `""`    |
| `proxy.autoscaling.hpa.maxReplicas`             | Maximum number of Milvus proxy replicas                                                                                                                                | `""`    |
| `proxy.autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `proxy.autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                                                   | `""`    |

### Proxy Traffic Exposure Parameters

| Name                                          | Description                                                      | Value          |
| --------------------------------------------- | ---------------------------------------------------------------- | -------------- |
| `proxy.service.type`                          | Proxy service type                                               | `LoadBalancer` |
| `proxy.service.ports.grpc`                    | Proxy GRPC service port                                          | `19530`        |
| `proxy.service.ports.metrics`                 | Proxy Metrics service port                                       | `9091`         |
| `proxy.service.nodePorts.grpc`                | Node port for GRPC                                               | `""`           |
| `proxy.service.nodePorts.metrics`             | Node port for Metrics                                            | `""`           |
| `proxy.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                      | `{}`           |
| `proxy.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin | `None`         |
| `proxy.service.clusterIP`                     | Proxy service Cluster IP                                         | `""`           |
| `proxy.service.loadBalancerIP`                | Proxy service Load Balancer IP                                   | `""`           |
| `proxy.service.loadBalancerSourceRanges`      | Proxy service Load Balancer sources                              | `[]`           |
| `proxy.service.externalTrafficPolicy`         | Proxy service external traffic policy                            | `Cluster`      |
| `proxy.service.annotations`                   | Additional custom annotations for Proxy service                  | `{}`           |
| `proxy.service.extraPorts`                    | Extra ports to expose in the Proxy service                       | `[]`           |
| `proxy.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                       | `true`         |
| `proxy.networkPolicy.allowExternal`           | The Policy model to apply                                        | `true`         |
| `proxy.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.  | `true`         |
| `proxy.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                     | `[]`           |
| `proxy.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                     | `[]`           |
| `proxy.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces           | `{}`           |
| `proxy.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces       | `{}`           |

### Proxy Metrics Parameters

| Name                                             | Description                                                                           | Value   |
| ------------------------------------------------ | ------------------------------------------------------------------------------------- | ------- |
| `proxy.metrics.enabled`                          | Enable metrics                                                                        | `false` |
| `proxy.metrics.annotations`                      | Annotations for the server service in order to scrape metrics                         | `{}`    |
| `proxy.metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator         | `false` |
| `proxy.metrics.serviceMonitor.annotations`       | Annotations for the ServiceMonitor Resource                                           | `""`    |
| `proxy.metrics.serviceMonitor.namespace`         | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)         | `""`    |
| `proxy.metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                          | `""`    |
| `proxy.metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                               | `""`    |
| `proxy.metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `proxy.metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`    |
| `proxy.metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`    |
| `proxy.metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`    |
| `proxy.metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                              | `false` |
| `proxy.metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`    |

### Attu Deployment Parameters

| Name                                                     | Description                                                                                                                                                                                                                 | Value                  |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `attu.enabled`                                           | Enable Attu deployment                                                                                                                                                                                                      | `true`                 |
| `attu.image.registry`                                    | Attu image registry                                                                                                                                                                                                         | `REGISTRY_NAME`        |
| `attu.image.repository`                                  | Attu image repository                                                                                                                                                                                                       | `REPOSITORY_NAME/attu` |
| `attu.image.digest`                                      | Attu image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                        | `""`                   |
| `attu.image.pullPolicy`                                  | Attu image pull policy                                                                                                                                                                                                      | `IfNotPresent`         |
| `attu.image.pullSecrets`                                 | Attu image pull secrets                                                                                                                                                                                                     | `[]`                   |
| `attu.image.debug`                                       | Enable debug mode                                                                                                                                                                                                           | `false`                |
| `attu.extraEnvVars`                                      | Array with extra environment variables to add to attu nodes                                                                                                                                                                 | `[]`                   |
| `attu.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for attu nodes                                                                                                                                                         | `""`                   |
| `attu.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for attu nodes                                                                                                                                                            | `""`                   |
| `attu.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                        | `[]`                   |
| `attu.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                           | `[]`                   |
| `attu.replicaCount`                                      | Number of Attu replicas to deploy                                                                                                                                                                                           | `1`                    |
| `attu.containerPorts.http`                               | HTTP port for Attu                                                                                                                                                                                                          | `3000`                 |
| `attu.livenessProbe.enabled`                             | Enable livenessProbe on Attu nodes                                                                                                                                                                                          | `true`                 |
| `attu.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                     | `5`                    |
| `attu.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                            | `10`                   |
| `attu.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                           | `5`                    |
| `attu.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                         | `5`                    |
| `attu.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                         | `1`                    |
| `attu.readinessProbe.enabled`                            | Enable readinessProbe on Attu nodes                                                                                                                                                                                         | `true`                 |
| `attu.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                    | `5`                    |
| `attu.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                           | `10`                   |
| `attu.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                          | `5`                    |
| `attu.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                        | `5`                    |
| `attu.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                        | `1`                    |
| `attu.startupProbe.enabled`                              | Enable startupProbe on Attu containers                                                                                                                                                                                      | `false`                |
| `attu.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                      | `5`                    |
| `attu.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                             | `10`                   |
| `attu.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                            | `5`                    |
| `attu.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                          | `5`                    |
| `attu.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                          | `1`                    |
| `attu.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                         | `{}`                   |
| `attu.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                        | `{}`                   |
| `attu.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                          | `{}`                   |
| `attu.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if attu.resources is set (attu.resources is recommended for production). | `micro`                |
| `attu.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                           | `{}`                   |
| `attu.podSecurityContext.enabled`                        | Enabled Attu pods' Security Context                                                                                                                                                                                         | `true`                 |
| `attu.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                          | `Always`               |
| `attu.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                              | `[]`                   |
| `attu.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                 | `[]`                   |
| `attu.podSecurityContext.fsGroup`                        | Set Attu pod's Security Context fsGroup                                                                                                                                                                                     | `1001`                 |
| `attu.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                        | `true`                 |
| `attu.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                            | `{}`                   |
| `attu.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                  | `1001`                 |
| `attu.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                 | `1001`                 |
| `attu.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                               | `true`                 |
| `attu.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                 | `false`                |
| `attu.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                     | `true`                 |
| `attu.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                   | `false`                |
| `attu.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                          | `["ALL"]`              |
| `attu.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                            | `RuntimeDefault`       |
| `attu.lifecycleHooks`                                    | for the attu container(s) to automate configuration before or after startup                                                                                                                                                 | `{}`                   |
| `attu.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                              | `""`                   |
| `attu.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                          | `false`                |
| `attu.hostAliases`                                       | attu pods host aliases                                                                                                                                                                                                      | `[]`                   |
| `attu.podLabels`                                         | Extra labels for attu pods                                                                                                                                                                                                  | `{}`                   |
| `attu.podAnnotations`                                    | Annotations for attu pods                                                                                                                                                                                                   | `{}`                   |
| `attu.podAffinityPreset`                                 | Pod affinity preset. Ignored if `attu.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `""`                   |
| `attu.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `attu.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `soft`                 |
| `attu.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `attu.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                              | `""`                   |
| `attu.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `attu.affinity` is set                                                                                                                                                                  | `""`                   |
| `attu.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `attu.affinity` is set                                                                                                                                                               | `[]`                   |
| `attu.affinity`                                          | Affinity for Attu pods assignment                                                                                                                                                                                           | `{}`                   |
| `attu.nodeSelector`                                      | Node labels for Attu pods assignment                                                                                                                                                                                        | `{}`                   |
| `attu.tolerations`                                       | Tolerations for Attu pods assignment                                                                                                                                                                                        | `[]`                   |
| `attu.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains                                                                                                                             | `[]`                   |
| `attu.priorityClassName`                                 | Attu pods' priorityClassName                                                                                                                                                                                                | `""`                   |
| `attu.schedulerName`                                     | Kubernetes pod scheduler registry                                                                                                                                                                                           | `""`                   |
| `attu.updateStrategy.type`                               | Attu statefulset strategy type                                                                                                                                                                                              | `RollingUpdate`        |
| `attu.updateStrategy.rollingUpdate`                      | Attu statefulset rolling update configuration parameters                                                                                                                                                                    | `{}`                   |
| `attu.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Attu pod(s)                                                                                                                                                     | `[]`                   |
| `attu.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Attu container(s)                                                                                                                                          | `[]`                   |
| `attu.sidecars`                                          | Add additional sidecar containers to the Attu pod(s)                                                                                                                                                                        | `[]`                   |
| `attu.enableDefaultInitContainers`                       | Deploy default init containers                                                                                                                                                                                              | `true`                 |
| `attu.initContainers`                                    | Add additional init containers to the Attu pod(s)                                                                                                                                                                           | `[]`                   |
| `attu.serviceAccount.create`                             | Enable creation of ServiceAccount for Attu pods                                                                                                                                                                             | `true`                 |
| `attu.serviceAccount.name`                               | The name of the ServiceAccount to use                                                                                                                                                                                       | `""`                   |
| `attu.serviceAccount.automountServiceAccountToken`       | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                                                                                                      | `false`                |
| `attu.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                        | `{}`                   |
| `attu.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                             | `true`                 |
| `attu.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                              | `{}`                   |
| `attu.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `attu.pdb.minAvailable` and `attu.pdb.maxUnavailable` are empty.                                                                    | `{}`                   |

### Attu Autoscaling configuration

| Name                                           | Description                                                                                                                                                            | Value   |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `attu.autoscaling.vpa.enabled`                 | Enable VPA                                                                                                                                                             | `false` |
| `attu.autoscaling.vpa.annotations`             | Annotations for VPA resource                                                                                                                                           | `{}`    |
| `attu.autoscaling.vpa.controlledResources`     | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                         | `[]`    |
| `attu.autoscaling.vpa.maxAllowed`              | VPA Max allowed resources for the pod                                                                                                                                  | `{}`    |
| `attu.autoscaling.vpa.minAllowed`              | VPA Min allowed resources for the pod                                                                                                                                  | `{}`    |
| `attu.autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `attu.autoscaling.hpa.enabled`                 | Enable HPA for Milvus attu                                                                                                                                             | `false` |
| `attu.autoscaling.hpa.annotations`             | Annotations for HPA resource                                                                                                                                           | `{}`    |
| `attu.autoscaling.hpa.minReplicas`             | Minimum number of Milvus attu replicas                                                                                                                                 | `""`    |
| `attu.autoscaling.hpa.maxReplicas`             | Maximum number of Milvus attu replicas                                                                                                                                 | `""`    |
| `attu.autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `attu.autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                                                   | `""`    |

### Attu Traffic Exposure Parameters

| Name                                         | Description                                                                                                                      | Value                    |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `attu.service.type`                          | Attu service type                                                                                                                | `LoadBalancer`           |
| `attu.service.ports.http`                    | Attu HTTP service port                                                                                                           | `80`                     |
| `attu.service.nodePorts.http`                | Node port for HTTP                                                                                                               | `""`                     |
| `attu.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `attu.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `attu.service.clusterIP`                     | Attu service Cluster IP                                                                                                          | `""`                     |
| `attu.service.loadBalancerIP`                | Attu service Load Balancer IP                                                                                                    | `""`                     |
| `attu.service.loadBalancerSourceRanges`      | Attu service Load Balancer sources                                                                                               | `[]`                     |
| `attu.service.externalTrafficPolicy`         | Attu service external traffic policy                                                                                             | `Cluster`                |
| `attu.service.annotations`                   | Additional custom annotations for Attu service                                                                                   | `{}`                     |
| `attu.service.extraPorts`                    | Extra ports to expose in the Attu service                                                                                        | `[]`                     |
| `attu.ingress.enabled`                       | Enable ingress record generation for Milvus                                                                                      | `false`                  |
| `attu.ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `attu.ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `attu.ingress.hostname`                      | Default host for the ingress record                                                                                              | `milvus.local`           |
| `attu.ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `attu.ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `attu.ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `attu.ingress.tls`                           | Enable TLS configuration for the host defined at `attu.ingress.hostname` parameter                                               | `false`                  |
| `attu.ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `attu.ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `attu.ingress.extraPaths`                    | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `attu.ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `attu.ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `attu.ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `attu.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                                                                                       | `true`                   |
| `attu.networkPolicy.allowExternal`           | The Policy model to apply                                                                                                        | `true`                   |
| `attu.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `attu.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `attu.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `attu.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `attu.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |

### Init Container Parameters

| Name                                                              | Description                                                                                                                                                                                                                | Value                      |
| ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `waitContainer.image.registry`                                    | Init container wait-container image registry                                                                                                                                                                               | `REGISTRY_NAME`            |
| `waitContainer.image.repository`                                  | Init container wait-container image name                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell` |
| `waitContainer.image.digest`                                      | Init container wait-container image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                              | `""`                       |
| `waitContainer.image.pullPolicy`                                  | Init container wait-container image pull policy                                                                                                                                                                            | `IfNotPresent`             |
| `waitContainer.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                           | `[]`                       |
| `waitContainer.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                       | `true`                     |
| `waitContainer.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                           | `{}`                       |
| `waitContainer.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                 | `1001`                     |
| `waitContainer.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                | `1001`                     |
| `waitContainer.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                              | `true`                     |
| `waitContainer.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                | `false`                    |
| `waitContainer.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                    | `true`                     |
| `waitContainer.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                  | `false`                    |
| `waitContainer.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                         | `["ALL"]`                  |
| `waitContainer.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                           | `RuntimeDefault`           |
| `waitContainer.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if initJob.resources is set (initJob.resources is recommended for production). | `micro`                    |
| `waitContainer.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                       |

### External etcd settings

| Name                                     | Description                                                                                          | Value                |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------- | -------------------- |
| `externalEtcd.servers`                   | List of hostnames of the external etcd                                                               | `[]`                 |
| `externalEtcd.port`                      | Port of the external etcd instance                                                                   | `2379`               |
| `externalEtcd.user`                      | User of the external etcd instance                                                                   | `root`               |
| `externalEtcd.password`                  | Password of the external etcd instance                                                               | `""`                 |
| `externalEtcd.existingSecret`            | Name of a secret containing the external etcd password                                               | `""`                 |
| `externalEtcd.existingSecretPasswordKey` | Key inside the secret containing the external etcd password                                          | `etcd-root-password` |
| `externalEtcd.tls.enabled`               | Enable TLS for etcd client connections.                                                              | `false`              |
| `externalEtcd.tls.existingSecret`        | Name of the existing secret containing the TLS certificates for external etcd client communications. | `""`                 |
| `externalEtcd.tls.cert`                  | The secret key from the existingSecret if 'cert' key different from the default (tls.crt)            | `tls.crt`            |
| `externalEtcd.tls.key`                   | The secret key from the existingSecret if 'key' key different from the default (tls.key)             | `tls.key`            |
| `externalEtcd.tls.caCert`                | The secret key from the existingSecret if 'caCert' key different from the default (ca.crt)           | `ca.crt`             |
| `externalEtcd.tls.keyPassword`           | Password to access the password-protected PEM key if necessary.                                      | `""`                 |

### External S3 parameters

| Name                                      | Description                                                                                       | Value           |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------- | --------------- |
| `externalS3.host`                         | External S3 host                                                                                  | `""`            |
| `externalS3.port`                         | External S3 port number                                                                           | `443`           |
| `externalS3.accessKeyID`                  | External S3 access key ID                                                                         | `""`            |
| `externalS3.accessKeySecret`              | External S3 access key secret                                                                     | `""`            |
| `externalS3.existingSecret`               | Name of an existing secret resource containing the S3 credentials                                 | `""`            |
| `externalS3.existingSecretAccessKeyIDKey` | Name of an existing secret key containing the S3 access key ID                                    | `root-user`     |
| `externalS3.existingSecretKeySecretKey`   | Name of an existing secret key containing the S3 access key secret                                | `root-password` |
| `externalS3.bucket`                       | External S3 bucket                                                                                | `milvus`        |
| `externalS3.rootPath`                     | External S3 root path                                                                             | `file`          |
| `externalS3.iamEndpoint`                  | External S3 IAM endpoint                                                                          | `""`            |
| `externalS3.cloudProvider`                | External S3 cloud provider                                                                        | `""`            |
| `externalS3.tls.enabled`                  | Enable TLS for externalS3 client connections.                                                     | `false`         |
| `externalS3.tls.existingSecret`           | Name of the existing secret containing the TLS certificates for externalS3 client communications. | `""`            |
| `externalS3.tls.caCert`                   | The secret key from the existingSecret if 'caCert' key different from the default (ca.crt)        | `ca.crt`        |

### External Kafka parameters

| Name                                           | Description                                                                                                        | Value                 |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | --------------------- |
| `externalKafka.servers`                        | External Kafka brokers                                                                                             | `["localhost"]`       |
| `externalKafka.port`                           | External Kafka port                                                                                                | `9092`                |
| `externalKafka.listener.protocol`              | Kafka listener protocol. Allowed protocols: PLAINTEXT, SASL_PLAINTEXT, SASL_SSL and SSL                            | `PLAINTEXT`           |
| `externalKafka.sasl.user`                      | User for SASL authentication                                                                                       | `user`                |
| `externalKafka.sasl.password`                  | Password for SASL authentication                                                                                   | `""`                  |
| `externalKafka.sasl.existingSecret`            | Name of the existing secret containing a password for SASL authentication (under the key named "client-passwords") | `""`                  |
| `externalKafka.sasl.existingSecretPasswordKey` | Name of the secret key containing the Kafka client user password                                                   | `kafka-root-password` |
| `externalKafka.sasl.enabledMechanisms`         | Kafka enabled SASL mechanisms                                                                                      | `PLAIN`               |
| `externalKafka.tls.enabled`                    | Enable TLS for kafka client connections.                                                                           | `false`               |
| `externalKafka.tls.existingSecret`             | Name of the existing secret containing the TLS certificates for external kafka client communications.              | `""`                  |
| `externalKafka.tls.cert`                       | The secret key from the existingSecret if 'cert' key different from the default (tls.crt)                          | `tls.crt`             |
| `externalKafka.tls.key`                        | The secret key from the existingSecret if 'key' key different from the default (tls.key)                           | `tls.key`             |
| `externalKafka.tls.caCert`                     | The secret key from the existingSecret if 'caCert' key different from the default (ca.crt)                         | `ca.crt`              |
| `externalKafka.tls.keyPassword`                | Password to access the password-protected PEM key if necessary.                                                    | `""`                  |

### etcd sub-chart parameters

| Name                               | Description                                 | Value   |
| ---------------------------------- | ------------------------------------------- | ------- |
| `etcd.enabled`                     | Deploy etcd sub-chart                       | `true`  |
| `etcd.replicaCount`                | Number of etcd replicas                     | `3`     |
| `etcd.containerPorts.client`       | Container port for etcd                     | `2379`  |
| `etcd.auth.rbac.create`            | Switch to enable RBAC authentication        | `false` |
| `etcd.auth.client.secureTransport` | use TLS for client-to-server communications | `false` |

### MinIO&reg; chart parameters

| Name                               | Description                                                                                                                       | Value                                               |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| `minio`                            | For full list of MinIO&reg; values configurations please refere [here](https://github.com/bitnami/charts/tree/main/bitnami/minio) |                                                     |
| `minio.enabled`                    | Enable/disable MinIO&reg; chart installation                                                                                      | `true`                                              |
| `minio.auth.rootUser`              | MinIO&reg; root username                                                                                                          | `admin`                                             |
| `minio.auth.rootPassword`          | Password for MinIO&reg; root user                                                                                                 | `""`                                                |
| `minio.auth.existingSecret`        | Name of an existing secret containing the MinIO&reg; credentials                                                                  | `""`                                                |
| `minio.defaultBuckets`             | Comma, semi-colon or space separated list of MinIO&reg; buckets to create                                                         | `milvus`                                            |
| `minio.provisioning.enabled`       | Enable/disable MinIO&reg; provisioning job                                                                                        | `true`                                              |
| `minio.provisioning.extraCommands` | Extra commands to run on MinIO&reg; provisioning job                                                                              | `["mc anonymous set download provisioning/milvus"]` |
| `minio.tls.enabled`                | Enable/disable MinIO&reg; TLS support                                                                                             | `false`                                             |
| `minio.service.type`               | MinIO&reg; service type                                                                                                           | `ClusterIP`                                         |
| `minio.service.loadBalancerIP`     | MinIO&reg; service LoadBalancer IP                                                                                                | `""`                                                |
| `minio.service.ports.api`          | MinIO&reg; service port                                                                                                           | `80`                                                |
| `minio.console.enabled`            | Enable MinIO&reg; Console                                                                                                         | `false`                                             |

### kafka sub-chart paramaters

| Name                              | Description                                                   | Value            |
| --------------------------------- | ------------------------------------------------------------- | ---------------- |
| `kafka.enabled`                   | Enable/disable Kafka chart installation                       | `true`           |
| `kafka.controller.replicaCount`   | Number of Kafka controller eligible (controller+broker) nodes | `1`              |
| `kafka.service.ports.client`      | Kafka svc port for client connections                         | `9092`           |
| `kafka.overrideConfiguration`     | Kafka common configuration override                           | `{}`             |
| `kafka.listeners.client.protocol` | Kafka authentication protocol for the client listener         | `SASL_PLAINTEXT` |
| `kafka.sasl.enabledMechanisms`    | Kafka enabled SASL mechanisms                                 | `PLAIN`          |
| `kafka.sasl.client.users`         | Kafka client users                                            | `["user"]`       |

See <https://github.com/bitnami/readme-generator-for-helm> to create the table.

The above parameters map to the env variables defined in [bitnami/milvus](https://github.com/bitnami/containers/tree/main/bitnami/milvus). For more information please refer to the [bitnami/milvus](https://github.com/bitnami/containers/tree/main/bitnami/milvus) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set loki.traces.jaeger.grpc=true \
  oci://REGISTRY_NAME/REPOSITORY_NAME/milvus
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command enables the Jaeger GRPC traces.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/milvus
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/milvus/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 16.0.0

This major updates `milvus` to its latest version, 2.6.0. This new version introduces important architectural changes:

- root-coordinator, data-coordinator, index-coordinator and query-coordinator have all been unified into a single coordinator component, called coordinator. Therefore, values `rootCoord.*`, `dataCoord.*`, `queryCoord.*` and `indexCoord.*` have been removed and new values `coordinator.*` have been added to the chart.
- Capabilites of the data-node and index-node have been merged into the data-node, values `indexNode.*` have been removed from the chart.
- New component streaming-node have been added, introducing new chart values `streamingNode.*`.

### To 15.0.0

This major updates the `minio` subchart to its newest major, 17.0.0. For more information on this subchart's major, please refer to [minio upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/minio#to-1700).

### To 14.0.0

This major updates the `etcd` subchart to it newest major, 12.0.0. For more information on this subchart's major, please refer to [etcd upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/etcd#to-1200).

### To 13.0.0

This major updates the `minio` subchart to its newest major, 16.0.0. For more information on this subchart's major, please refer to [minio upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/minio#to-1600) (effective in 13.2.0).

### To 12.0.0

This major updates the Kafka subchart to its newest major, 32.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-3200).

### To 11.0.0

This major updates the `etcd` subchart to it newest major, 11.0.0. For more information on this subchart's major, please refer to [etcd upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/etcd#to-1100).

### To 10.1.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 10.0.0

This major updates the Kafka subchart to its newest major, 31.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-3100).

### To 9.0.0

This major updates the Kafka subchart to its newest major, 30.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-3000).

### To 8.0.0

This major updates the Kafka subchart to its newest major, 29.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2900).

### To 7.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 6.0.0

This major release bumps the MinIO chart version to [13.x.x](https://github.com/bitnami/charts/pull/22058/); no major issues are expected during the upgrade.

### To 4.0.0

This major updates the Kafka subchart to its newest major, 26.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2600).

### To 3.0.0

This major updates the Kafka subchart to its newest major, 25.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2500).

### To 2.0.0

This major updates the Kafka subchart to its newest major, 24.0.0. This new version refactors the Kafka chart architecture and requires manual actions during the upgrade. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2400).

Additionally, the following values have been modified:

- `externalKafka.securityProtocol` has been replaced with `externalKafka.listener.protocol`, which now allows Kafka security protocols 'PLAINTEXT','SASL_PLAINTEXT', 'SSL', 'SASL_SSL'.
- `externalKafka.user` has been replaced with `externalAccess.sasl.user`.
- `externalKafka.password` has been replaced with `externalAccess.sasl.password`.
- `externalKafka.existingSecret` has been replaced with `externalAccess.sasl.existingSecret`.
- `externalKafka.existingSecretPasswordKey` has been replaced with `externalAccess.sasl.existingSecretPasswordKey`.
- `externalKafka.saslMechanisms` has been replaced with `externalAccess.sasl.enabledMechanisms`.

### To 1.0.0

This major updates the Kafka subchart to its newest major, 23.0.0. For more information on this subchart's major, please refer to [Kafka upgrade notes](https://github.com/bitnami/charts/tree/main/bitnami/kafka#to-2300).

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
