<!--- app-name: Zipkin -->

# Bitnami package for Zipkin

Zipkin is a distributed tracing system that helps collect and analyze timing data to troubleshoot latency issues in service architectures, providing visibility into service call performance.

[Overview of Zipkin](https://zipkin.io/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/zipkin
```

Looking to use Zipkin in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [zipkin](https://github.com/bitnami/containers/tree/main/bitnami/zipkin) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/zipkin
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys zipkin on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose Zipkin native Prometheus endpoint in the service. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Zipkin application properties

The chart supports setting zipkin [environment variables](https://github.com/openzipkin/zipkin/blob/master/zipkin-server/README.md#configuration) via two parameters:

- `configOverrides`: Overrides non-sensitive application properties, such as `QUERY_TIMEOUT`.
- `secretConfigOverrides`: Overrides sensitive application properties, such as `MYSQL_PASSWORD`.

In the following example, we use `configOverrides` to disable the zipkin UI:

```yaml
configOverrides:
  UI_ENABLED: false
```

Alternatively, it is possible to use an external configmap and an external secret for this configuration: `existingConfigmap` and `existingSecret`.

> NOTE: Configuration overrides take precedence over the chart values. For example, setting `QUERY_PORT` via `configOverrides` leaves the `containerPorts.http` without effect.

### Using collectors

The Bitnami Zipkin image includes all the [available collectors](https://github.com/openzipkin/zipkin/tree/master/zipkin-collector). These can be configured using the `configOverrides` and `secretConfigOverrides` values. By default, it is using the HTTP collector endpoint.

In the examples below, we enable other collectors:

#### Using Bitnami RabbitMQ helm chart as collector

In the following example we will install the Bitnami RabbitMQ helm chart and [configure zipkin](https://github.com/openzipkin/zipkin/tree/master/zipkin-collector/rabbitmq) to use it as storage. Replace the RABBITMQ_USER and RABBITMQ_PASSWORD placeholders.

```bash
helm install rabbitmq oci://REGISTRY_NAME/REPOSITORY_NAME/rabbitmq --set auth.username=RABBITMQ_USER --set auth.password=RABBITMQ_PASSWORD
```

Then install the zipkin helm chart with the following values:

```yaml
#
# Example with RabbitMQ
#
# This section goes to a ConfigMap
configOverrides:
  RABBIT_ADDRESSES: rabbitmq
  RABBIT_USER: RABBITMQ_USER
# This section goes to a Secret
secretConfigOverrides:
  RABBIT_PASSWORD: RABBITMQ_PASSWORD
```

#### Using Bitnami Kafka helm chart as collector

In the following example we will install the Bitnami Kafka helm chart and [configure zipkin](https://github.com/openzipkin/zipkin/tree/master/zipkin-collector/kafka) to use it as storage.

```bash
helm install kafka oci://REGISTRY_NAME/REPOSITORY_NAME/kafka
```

Then install the zipkin helm chart with the following values:

```yaml
#
# Example with RabbitMQ
#
# This section goes to a ConfigMap
configOverrides:
  COLLECTOR_KAFKA_ENABLED: true
  KAFKA_BOOTSTRAP_SERVERS: kafka:9092
```

### Supported storage types

This chart natively supports the following storage methods:

- Cassandra: Set `storageType=cassandra3`. If using embedded Cassandra subchart set `cassandra.enabled=true`. If using an external Cassandra set the `cassandra.enabled=false` and the `externalDatabase` section (see corresponding section).
- In memory storage: Set `storageType=mem`.

It is possible to configure the rest of storage backends by setting `storageType=other`, and using the `configOverrides` and `secretConfigOverrides` values. Set the proper  [environment variables](https://github.com/openzipkin/zipkin/blob/master/zipkin-server/README.md#configuration). In the following sections we show two examples:

#### Using Bitnami Elasticsearch helm chart as storage

In the following example we will install the Bitnami Elasticsearch helm chart and configure zipkin to use it as storage.

```bash
helm install elasticsearch oci://REGISTRY_NAME/REPOSITORY_NAME/elasticsearch
```

Then install the zipkin helm chart with the following values:

```yaml
#
# Example with Elasticsearch
#
storageType: other
# This section goes to a ConfigMap
configOverrides:
  STORAGE_TYPE: elasticsearch
  ES_HOSTS: http://elasticsearch:9200
cassandra:
  enabled: false
```

#### Using Bitnami MySQL helm chart as storage

In the following example we will install the Bitnami MySQL helm chart and configure zipkin to use it as storage. Replace the DB_USER, DB_DATABASE and DB_PASSWORD placeholders.

```bash
helm install mysql oci://REGISTRY_NAME/REPOSITORY_NAME/mysql --set auth.usernames=DB_USER --set auth.password=DB_PASSWORD --set auth.database=DB_DATABASE
```

Then install the zipkin helm chart with the following values:

```yaml
#
# Example with MongoDB
#
storageType: other
# This section goes to a ConfigMap
configOverrides:
  STORAGE_TYPE: mysql
  MYSQL_DB: DB_DATABASE
  MYSQL_HOST: mysql
  MYSQL_TCP_PORT: 3306
  MYSQL_USER: DB_USER
# This section goes to a Secret
secretConfigOverrides:
  MYSQL_PASSWORD: DB_PASSWORD
cassandra:
  enabled: false
```

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as zipkin (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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
  server:
    extraPorts:
    - name: extraPort
      port: 11311
      targetPort: 11311
```

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

### Securing traffic using TLS

Zipkin can encrypt communications by setting `tls.enabled=true`.

It is necessary to create a secret containing the TLS certificates and pass it to the chart via the `tls.existingSecret` parameter. The secret should contain a `tls.crt` and `tls.key` keys including the certificate and key files respectively.

You can manually create the required TLS certificates or relying on the chart auto-generation capabilities. The chart supports two different ways to auto-generate the required certificates:

- Using Helm capabilities. Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `helm`.
- Relying on CertManager (please note it's required to have CertManager installed in your K8s cluster). Enable this feature by setting `tls.autoGenerated.enabled` to `true` and `tls.autoGenerated.engine` to `cert-manager`. Please note it's supported to use an existing Issuer/ClusterIssuer for issuing the TLS certificates by setting the `tls.autoGenerated.certManager.existingIssuer` and `tls.autoGenerated.certManager.existingIssuerKind` parameters.

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### Configure TLS Secrets for use with Ingress

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

| Name                                                | Description                                                                                                                                                                                                          | Value                    |
| --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `kubeVersion`                                       | Override Kubernetes version                                                                                                                                                                                          | `""`                     |
| `apiVersions`                                       | Override Kubernetes API versions reported by .Capabilities                                                                                                                                                           | `[]`                     |
| `nameOverride`                                      | String to partially override common.names.name                                                                                                                                                                       | `""`                     |
| `fullnameOverride`                                  | String to fully override common.names.fullname                                                                                                                                                                       | `""`                     |
| `namespaceOverride`                                 | String to fully override common.names.namespace                                                                                                                                                                      | `""`                     |
| `commonLabels`                                      | Labels to add to all deployed objects                                                                                                                                                                                | `{}`                     |
| `commonAnnotations`                                 | Annotations to add to all deployed objects                                                                                                                                                                           | `{}`                     |
| `clusterDomain`                                     | Kubernetes cluster domain name                                                                                                                                                                                       | `cluster.local`          |
| `extraDeploy`                                       | Array of extra objects to deploy with the release                                                                                                                                                                    | `[]`                     |
| `diagnosticMode.enabled`                            | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                                                                                              | `false`                  |
| `diagnosticMode.command`                            | Command to override all containers in the deployment                                                                                                                                                                 | `["sleep"]`              |
| `diagnosticMode.args`                               | Args to override all containers in the deployment                                                                                                                                                                    | `["infinity"]`           |
| `configOverrides`                                   | Overwrite or add extra configuration options to the chart default                                                                                                                                                    | `{}`                     |
| `secretConfigOverrides`                             | Overwrite or add extra configuration options to the chart default (these will be added in a secret)                                                                                                                  | `{}`                     |
| `existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for zipkin                                                                                                                                          | `""`                     |
| `existingSecret`                                    | The name of an existing Secret with your custom sensitive configuration for zipkin                                                                                                                                   | `""`                     |
| `javaOpts`                                          | Set extra Java Options when launching zipkin                                                                                                                                                                         | `""`                     |
| `image.registry`                                    | zipkin image registry                                                                                                                                                                                                | `REGISTRY_NAME`          |
| `image.repository`                                  | zipkin image repository                                                                                                                                                                                              | `REPOSITORY_NAME/zipkin` |
| `image.digest`                                      | zipkin image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                    | `""`                     |
| `image.pullPolicy`                                  | zipkin image pull policy                                                                                                                                                                                             | `IfNotPresent`           |
| `image.pullSecrets`                                 | zipkin image pull secrets                                                                                                                                                                                            | `[]`                     |
| `image.debug`                                       | Enable zipkin image debug mode                                                                                                                                                                                       | `false`                  |
| `replicaCount`                                      | Number of zipkin replicas to deploy                                                                                                                                                                                  | `1`                      |
| `containerPorts.http`                               | zipkin http server container port                                                                                                                                                                                    | `9411`                   |
| `extraContainerPorts`                               | Optionally specify extra list of additional container ports                                                                                                                                                          | `[]`                     |
| `deploymentLabels`                                  | Add extra labels to the Deployment object                                                                                                                                                                            | `{}`                     |
| `deploymentAnnotations`                             | Add extra annotations to the Deployment object                                                                                                                                                                       | `{}`                     |
| `logLevel`                                          | Set application log level                                                                                                                                                                                            | `INFO`                   |
| `usePasswordFiles`                                  | Mount all sensitive information as files                                                                                                                                                                             | `true`                   |
| `storageType`                                       | Set version store type. The chart natively supports cassandra3, mem or other. Any other type requires you to add the configuration in configOverrides and secretConfigOverrides.                                     | `cassandra3`             |
| `tls.enabled`                                       | Enable TLS                                                                                                                                                                                                           | `false`                  |
| `tls.usePemCerts`                                   | Use certificates in .pem format                                                                                                                                                                                      | `true`                   |
| `tls.existingSecret`                                | Name of a secret containing the certificate files                                                                                                                                                                    | `""`                     |
| `tls.certFilename`                                  | Filename inside the secret of the .crt file (when usePemCerts=true)                                                                                                                                                  | `tls.crt`                |
| `tls.certKeyFilename`                               | Filename inside the secret of the .key file (when usePemCerts=true)                                                                                                                                                  | `tls.key`                |
| `tls.keystoreFilename`                              | Filename inside the secret of the .jks file (when usePemCerts=false)                                                                                                                                                 | `zipkin.jks`             |
| `tls.password`                                      | Password of the Java keystore                                                                                                                                                                                        | `""`                     |
| `tls.passwordSecret`                                | Name of a secret containing the password of the Java keystore                                                                                                                                                        | `""`                     |
| `tls.autoGenerated.enabled`                         | Enable automatic generation of certificates for TLS                                                                                                                                                                  | `true`                   |
| `tls.autoGenerated.engine`                          | Mechanism to generate the certificates (allowed values: helm, cert-manager)                                                                                                                                          | `helm`                   |
| `tls.autoGenerated.certManager.existingIssuer`      | The name of an existing Issuer to use for generating the certificates (only for `cert-manager` engine)                                                                                                               | `""`                     |
| `tls.autoGenerated.certManager.existingIssuerKind`  | Existing Issuer kind, defaults to Issuer (only for `cert-manager` engine)                                                                                                                                            | `""`                     |
| `tls.autoGenerated.certManager.keyAlgorithm`        | Key algorithm for the certificates (only for `cert-manager` engine)                                                                                                                                                  | `RSA`                    |
| `tls.autoGenerated.certManager.keySize`             | Key size for the certificates (only for `cert-manager` engine)                                                                                                                                                       | `2048`                   |
| `tls.autoGenerated.certManager.duration`            | Duration for the certificates (only for `cert-manager` engine)                                                                                                                                                       | `2160h`                  |
| `tls.autoGenerated.certManager.renewBefore`         | Renewal period for the certificates (only for `cert-manager` engine)                                                                                                                                                 | `360h`                   |
| `livenessProbe.enabled`                             | Enable livenessProbe on zipkin containers                                                                                                                                                                            | `true`                   |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                              | `10`                     |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                     | `10`                     |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                    | `5`                      |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                  | `5`                      |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                  | `1`                      |
| `readinessProbe.enabled`                            | Enable readinessProbe on zipkin containers                                                                                                                                                                           | `true`                   |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                             | `10`                     |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                    | `10`                     |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                   | `5`                      |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                 | `5`                      |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                 | `1`                      |
| `startupProbe.enabled`                              | Enable startupProbe on zipkin containers                                                                                                                                                                             | `false`                  |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                               | `90`                     |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                      | `10`                     |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                     | `5`                      |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                   | `5`                      |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                   | `1`                      |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                  | `{}`                     |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                 | `{}`                     |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                   | `{}`                     |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (secondary.resources is recommended for production). | `small`                  |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                    | `{}`                     |
| `podSecurityContext.enabled`                        | Enable security context for zipkin pods                                                                                                                                                                              | `true`                   |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                   | `Always`                 |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                       | `[]`                     |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                          | `[]`                     |
| `podSecurityContext.fsGroup`                        | Group ID for the mounted volumes' filesystem                                                                                                                                                                         | `1001`                   |
| `containerSecurityContext.enabled`                  | zipkin container securityContext                                                                                                                                                                                     | `true`                   |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                     | `{}`                     |
| `containerSecurityContext.runAsUser`                | User ID for the zipkin container                                                                                                                                                                                     | `1001`                   |
| `containerSecurityContext.runAsGroup`               | Group ID for the zipkin container                                                                                                                                                                                    | `1001`                   |
| `containerSecurityContext.runAsNonRoot`             | Set secondary container's Security Context runAsNonRoot                                                                                                                                                              | `true`                   |
| `containerSecurityContext.privileged`               | Set secondary container's Security Context privileged                                                                                                                                                                | `false`                  |
| `containerSecurityContext.allowPrivilegeEscalation` | Set secondary container's Security Context allowPrivilegeEscalation                                                                                                                                                  | `false`                  |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                              | `true`                   |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                   | `["ALL"]`                |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                     | `RuntimeDefault`         |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                 | `[]`                     |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                    | `[]`                     |
| `hostAliases`                                       | zipkin pods host aliases                                                                                                                                                                                             | `[]`                     |
| `annotations`                                       | Annotations for zipkin deployment/statefulset                                                                                                                                                                        | `{}`                     |
| `podLabels`                                         | Extra labels for zipkin pods                                                                                                                                                                                         | `{}`                     |
| `podAnnotations`                                    | Annotations for zipkin pods                                                                                                                                                                                          | `{}`                     |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `""`                     |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `soft`                   |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                      | `true`                   |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                       | `""`                     |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                       | `""`                     |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                            | `""`                     |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                | `""`                     |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                             | `[]`                     |
| `affinity`                                          | Affinity for zipkin pods assignment                                                                                                                                                                                  | `{}`                     |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                   | `false`                  |
| `nodeSelector`                                      | Node labels for zipkin pods assignment                                                                                                                                                                               | `{}`                     |
| `tolerations`                                       | Tolerations for zipkin pods assignment                                                                                                                                                                               | `[]`                     |
| `updateStrategy.type`                               | zipkin strategy type                                                                                                                                                                                                 | `RollingUpdate`          |
| `priorityClassName`                                 | zipkin pods' priorityClassName                                                                                                                                                                                       | `""`                     |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                             | `[]`                     |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for zipkin pods                                                                                                                                                       | `""`                     |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                    | `""`                     |
| `lifecycleHooks`                                    | for the zipkin container(s) to automate configuration before or after startup                                                                                                                                        | `{}`                     |
| `extraEnvVars`                                      | Array with extra environment variables to add to zipkin nodes                                                                                                                                                        | `[]`                     |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for zipkin nodes                                                                                                                                                | `""`                     |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for zipkin nodes                                                                                                                                                   | `""`                     |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the zipkin pod(s)                                                                                                                                            | `[]`                     |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the zipkin container(s)                                                                                                                                 | `[]`                     |
| `sidecars`                                          | Add additional sidecar containers to the zipkin pod(s)                                                                                                                                                               | `[]`                     |
| `initContainers`                                    | Add additional init containers to the zipkin pod(s)                                                                                                                                                                  | `[]`                     |

### Autoscaling

| Name                                  | Description                                                                                    | Value   |
| ------------------------------------- | ---------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.vpa.enabled`             | Enable VPA                                                                                     | `false` |
| `autoscaling.vpa.annotations`         | Annotations for VPA resource                                                                   | `{}`    |
| `autoscaling.vpa.controlledResources` | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory | `[]`    |
| `autoscaling.vpa.maxAllowed`          | VPA Max allowed resources for the pod                                                          | `{}`    |
| `autoscaling.vpa.minAllowed`          | VPA Min allowed resources for the pod                                                          | `{}`    |

### VPA update policy

| Name                                      | Description                                                                                                                                                            | Value   |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.vpa.updatePolicy.updateMode` | Autoscaling update policy Specifies whether recommended updates are applied when a Pod is started and whether recommended updates are applied during the life of a Pod | `Auto`  |
| `autoscaling.hpa.enabled`                 | Enable HPA                                                                                                                                                             | `false` |
| `autoscaling.hpa.minReplicas`             | Minimum number of replicas                                                                                                                                             | `""`    |
| `autoscaling.hpa.maxReplicas`             | Maximum number of replicas                                                                                                                                             | `""`    |
| `autoscaling.hpa.targetCPU`               | Target CPU utilization percentage                                                                                                                                      | `""`    |
| `autoscaling.hpa.targetMemory`            | Target Memory utilization percentage                                                                                                                                   | `""`    |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | zipkin service type                                                                                                              | `ClusterIP`              |
| `service.ports.http`               | zipkin service http port                                                                                                         | `9411`                   |
| `service.nodePorts.http`           | Node port for Gremlin                                                                                                            | `""`                     |
| `service.clusterIP`                | zipkin service Cluster IP                                                                                                        | `""`                     |
| `service.loadBalancerIP`           | zipkin service Load Balancer IP                                                                                                  | `""`                     |
| `service.loadBalancerSourceRanges` | zipkin service Load Balancer sources                                                                                             | `[]`                     |
| `service.externalTrafficPolicy`    | zipkin service external traffic policy                                                                                           | `Cluster`                |
| `service.annotations`              | Additional custom annotations for zipkin service                                                                                 | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in zipkin service (normally used with the `sidecars` value)                                                | `[]`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `zipkin.local`           |
| `ingress.path`                     | The Path to Nginx. You may need to set this to '/*' in order to use this with ALB ingress controllers.                           | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.ingressClassName`         | Set the ingerssClassName on the ingress record for k8s 1.18+                                                                     | `""`                     |
| `ingress.tls`                      | Create TLS Secret                                                                                                                | `false`                  |
| `ingress.tlsWwwPrefix`             | Adds www subdomain to default cert                                                                                               | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | The list of additional rules to be added to this ingress record. Evaluated as a template                                         | `[]`                     |

### Other Parameters

| Name                                          | Description                                                      | Value   |
| --------------------------------------------- | ---------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `false` |

### Default Init Container Parameters

| Name                                                                                       | Description                                                                                                                                                                                                                                         | Value                       |
| ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `defaultInitContainers.waitForCassandra.enabled`                                           | Enable init container that waits for backends to be ready                                                                                                                                                                                           | `true`                      |
| `defaultInitContainers.waitForCassandra.image.registry`                                    | Cassandra image registry                                                                                                                                                                                                                            | `REGISTRY_NAME`             |
| `defaultInitContainers.waitForCassandra.image.repository`                                  | Cassandra image repository                                                                                                                                                                                                                          | `REPOSITORY_NAME/cassandra` |
| `defaultInitContainers.waitForCassandra.image.pullPolicy`                                  | Cassandra image pull policy                                                                                                                                                                                                                         | `IfNotPresent`              |
| `defaultInitContainers.waitForCassandra.image.pullSecrets`                                 | Cassandra image pull secrets                                                                                                                                                                                                                        | `[]`                        |
| `defaultInitContainers.waitForCassandra.image.debug`                                       | Enable debug output                                                                                                                                                                                                                                 | `false`                     |
| `defaultInitContainers.waitForCassandra.resourcesPreset`                                   | Set init container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                      |
| `defaultInitContainers.waitForCassandra.resources`                                         | Set init container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                              | `{}`                        |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.enabled`                  | Enabled Init container' Security Context                                                                                                                                                                                                            | `true`                      |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.seLinuxOptions`           | Set SELinux options in Init container                                                                                                                                                                                                               | `{}`                        |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.runAsUser`                | Set runAsUser in Init container' Security Context                                                                                                                                                                                                   | `1001`                      |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.runAsGroup`               | Set runAsGroup in Init container' Security Context                                                                                                                                                                                                  | `1001`                      |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in Init container' Security Context                                                                                                                                                                                                | `true`                      |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in Init container' Security Context                                                                                                                                                                                      | `true`                      |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.privileged`               | Set privileged in Init container' Security Context                                                                                                                                                                                                  | `false`                     |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in Init container' Security Context                                                                                                                                                                                    | `false`                     |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in Init container                                                                                                                                                                                                | `["ALL"]`                   |
| `defaultInitContainers.waitForCassandra.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in Init container                                                                                                                                                                                                               | `RuntimeDefault`            |
| `defaultInitContainers.initCerts.enabled`                                                  | Enable init container that initializes the Java keystore with the TLS certificates (requires tls.enabled=true)                                                                                                                                      | `true`                      |
| `defaultInitContainers.initCerts.resourcesPreset`                                          | Set init container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                      |
| `defaultInitContainers.initCerts.resources`                                                | Set init container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                              | `{}`                        |
| `defaultInitContainers.initCerts.containerSecurityContext.enabled`                         | Enabled Init container' Security Context                                                                                                                                                                                                            | `true`                      |
| `defaultInitContainers.initCerts.containerSecurityContext.seLinuxOptions`                  | Set SELinux options in Init container                                                                                                                                                                                                               | `{}`                        |
| `defaultInitContainers.initCerts.containerSecurityContext.runAsUser`                       | Set runAsUser in Init container' Security Context                                                                                                                                                                                                   | `1001`                      |
| `defaultInitContainers.initCerts.containerSecurityContext.runAsGroup`                      | Set runAsGroup in Init container' Security Context                                                                                                                                                                                                  | `1001`                      |
| `defaultInitContainers.initCerts.containerSecurityContext.runAsNonRoot`                    | Set runAsNonRoot in Init container' Security Context                                                                                                                                                                                                | `true`                      |
| `defaultInitContainers.initCerts.containerSecurityContext.readOnlyRootFilesystem`          | Set readOnlyRootFilesystem in Init container' Security Context                                                                                                                                                                                      | `true`                      |
| `defaultInitContainers.initCerts.containerSecurityContext.privileged`                      | Set privileged in Init container' Security Context                                                                                                                                                                                                  | `false`                     |
| `defaultInitContainers.initCerts.containerSecurityContext.allowPrivilegeEscalation`        | Set allowPrivilegeEscalation in Init container' Security Context                                                                                                                                                                                    | `false`                     |
| `defaultInitContainers.initCerts.containerSecurityContext.capabilities.drop`               | List of capabilities to be dropped in Init container                                                                                                                                                                                                | `["ALL"]`                   |
| `defaultInitContainers.initCerts.containerSecurityContext.seccompProfile.type`             | Set seccomp profile in Init container                                                                                                                                                                                                               | `RuntimeDefault`            |

### NetworkPolicy parameters

| Name                                    | Description                                                     | Value  |
| --------------------------------------- | --------------------------------------------------------------- | ------ |
| `networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                      | `true` |
| `networkPolicy.allowExternal`           | The Policy model to apply                                       | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations. | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces          | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces      | `{}`   |

### Metrics parameters

| Name                                       | Description                                                                           | Value   |
| ------------------------------------------ | ------------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                          | Enable metrics                                                                        | `false` |
| `metrics.annotations`                      | Annotations for the server service in order to scrape metrics                         | `{}`    |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator         | `false` |
| `metrics.serviceMonitor.annotations`       | Annotations for the ServiceMonitor Resource                                           | `""`    |
| `metrics.serviceMonitor.namespace`         | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)         | `""`    |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                          | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                               | `""`    |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                   | `{}`    |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                    | `[]`    |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                             | `[]`    |
| `metrics.serviceMonitor.honorLabels`       | Specify honorLabels parameter to add the scrape endpoint                              | `false` |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.     | `""`    |

### Database parameters

| Name                                         | Description                                                             | Value            |
| -------------------------------------------- | ----------------------------------------------------------------------- | ---------------- |
| `externalDatabase.host`                      | External database host                                                  | `""`             |
| `externalDatabase.port`                      | External database port                                                  | `9042`           |
| `externalDatabase.user`                      | Cassandra admin user                                                    | `bn_zipkin`      |
| `externalDatabase.password`                  | Password for `dbUser.user`. Randomly generated if empty                 | `""`             |
| `externalDatabase.existingSecret`            | Name of existing secret containing the database secret                  | `""`             |
| `externalDatabase.existingSecretPasswordKey` | Name of existing secret key containing the database password secret key | `""`             |
| `externalDatabase.cluster.datacenter`        | Name for cassandra's zipkin datacenter                                  | `datacenter1`    |
| `externalDatabase.keyspace`                  | Name for cassandra's zipkin keyspace                                    | `bitnami_zipkin` |

### Cassandra storage sub-chart

| Name                              | Description                                                                                                                                                                                                | Value            |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `cassandra.enabled`               | Enables cassandra storage pod                                                                                                                                                                              | `true`           |
| `cassandra.cluster.datacenter`    | Name for cassandra's zipkin datacenter                                                                                                                                                                     | `datacenter1`    |
| `cassandra.keyspace`              | Name for cassandra's zipkin keyspace                                                                                                                                                                       | `bitnami_zipkin` |
| `cassandra.dbUser.user`           | Cassandra admin user                                                                                                                                                                                       | `bn_zipkin`      |
| `cassandra.dbUser.password`       | Password for `dbUser.user`. Randomly generated if empty                                                                                                                                                    | `""`             |
| `cassandra.dbUser.existingSecret` | Name of an existing secret containing the user password.                                                                                                                                                   | `""`             |
| `cassandra.service.ports.cql`     | Cassandra cql port                                                                                                                                                                                         | `9042`           |
| `cassandra.resourcesPreset`       | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `medium`         |
| `cassandra.resources`             | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                          | `{}`             |
| `cassandra.initDB`                | Init script for initializing the instance                                                                                                                                                                  | `{}`             |
| `cassandra.extraEnvVars`          | Add extra env variables to the Cassandra installation                                                                                                                                                      | `[]`             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    oci://REGISTRY_NAME/REPOSITORY_NAME/zipkin
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/zipkin
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/blob/main/template/zipkin/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.1.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 1.0.0

This major updates the Cassandra subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/pull/29305) you can find more information about the changes introduced in that version.

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