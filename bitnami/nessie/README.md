<!--- app-name: Nessie -->

# Bitnami package for Nessie

Nessie is an open-source version control system for data lakes, enabling isolated data experimentation before committing changes.

[Overview of Nessie](https://projectnessie.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/nessie
```

Looking to use Nessie in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Nessie](https://github.com/bitnami/containers/tree/main/bitnami/nessie) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/nessie
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Nessie on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Nessie application properties

The chart supports setting Nessie [application properties](https://github.com/projectnessie/nessie/blob/main/servers/quarkus-server/src/main/resources/application.properties) via two parameters:

- `configOverrides`: Overrides non-sensitive application properties, such as `quarkus.micrometer.enabled`. Nested and plain YAML are supported.
- `secretConfigOverrides`: Overrides sensitive applicatino properties, such as `quarkus.datasource.postgresql.password`. Nested and plain YAML are supported.

In the following example, we use `configOverrides` to disable the HTTP access log and the HTTP decompression:

```yaml
configOverrides:
  quarkus:
    http:
      access-log:
        enabled: false
      enable-decompression: false
```

Alternatively, it is possible to use an external configmap and an external secret for this configuration: `existingConfigmap` and `existingSecret`.

> NOTE: Configuration overrides take precedence over the chart values. For example, setting `quarkus.http.port` via `configOverrides` leaves the `containerPorts.http` without effect.

### Supported version store types

This chart natively supports the following version store methods:

- JDBC with PostgreSQL: Set `versionStoreType=JDBC_POSTGRESQL`. If using embedded PostgreSQL subchart set `postgresql.enabled=true`. If using an external PostgreSQL set the `postgresql.enabled=false` and the `externalDatabase` section (see corresponding section).
- RocksDB: Set `versionStoreType=ROCKSDB` and `persistence.enabled=true` for maintaining persistence between releases. Note that this will create a PVC that will be shared between all replicas of the Deployment.
- In memory storage: Set `versionStoreType=IN_MEMORY`.

It is possible to configure the rest of storage backends by using `configOverrides` and `secretConfigOverrides`, setting the proper [application properties](https://github.com/projectnessie/nessie/blob/main/servers/quarkus-server/src/main/resources/application.properties). In the following sections we show two examples:

#### Using Bitnami MariaDB helm chart as version store

In the following example we will install the Bitnami MariaDB helm chart and configure Nessie to use it as version store. Replace the DB_USER, DB_DATABASE and DB_PASSWORD placeholders.

```bash
helm install mariadb oci://REGISTRY_NAME/REPOSITORY_NAME/mariadb --set auth.username=DB_USER --set auth.database=DB_DATABASE --set auth.password=DB_PASSWORD
```

Then install the Nessie helm chart with the following values:

```yaml
#
# Example with JDBC MariaDB
#
versionStoreType: JDBC
# This section goes to a ConfigMap
configOverrides:
  nessie.version.store.persist.jdbc.datasource: mariadb
  quarkus.datasource.mariadb.username: DB_USER
  quarkus.datasource.mariadb.jdbc.url: jdbc:mariadb://mariadb:3306/DB_DATABASE
# This section goes to a Secret
secretConfigOverrides:
  quarkus.datasource.mariadb.password: DB_PASSWORD
postgresql:
  enabled: false
```

#### Using Bitnami MongoDB helm chart as version store

In the following example we will install the Bitnami MongoDB helm chart and configure Nessie to use it as version store. Replace the DB_USER, DB_DATABASE and DB_PASSWORD placeholders.

```bash
helm install mariadb oci://REGISTRY_NAME/REPOSITORY_NAME/mongodb --set auth.usernames[0]=DB_USER --set auth.passwords[0]=DB_PASSWORD --set auth.databases[0]=DB_DATABASE
```

Then install the Nessie helm chart with the following values:

```yaml
#
# Example with MongoDB
#
versionStoreType: MONGODB
# This section goes to a ConfigMap
configOverrides:
  quarkus.mongodb.database: DB_DATABASE
# This section goes to a Secret
secretConfigOverrides:
  quarkus.mongodb.connection-string: mongodb://DB_USER:DB_PASSWORD@mongodb:27017
postgresql:
  enabled: false
```

### Authentication with an external OIDC provider

Nessie allows authentication using an external OIDC provider. This can be configured using the `configOverrides` and `secretConfigOverrides` values. Replace the OIDC_SERVER_URL, OIDC_SECRET and OIDC_CLIENT_ID placeholders:

```yaml
configOverrides:
  nessie.server.authentication.enabled: true
  quarkus.oidc.auth-server-url: OIDC_SERVER_URL
secretConfigOverrides:
  quarkus.oidc.credentials.secret: OIDC_SECRET
  quarkus.oidc.client-id: OIDC_CLIENT_ID
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

If additional containers are needed in the same pod as nessie (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                                                | Description                                                                                                                                                                                                          | Value                    |
| --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `kubeVersion`                                       | Override Kubernetes version                                                                                                                                                                                          | `""`                     |
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
| `existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for nessie                                                                                                                                          | `""`                     |
| `existingSecret`                                    | The name of an existing Secret with your custom sensitive configuration for nessie                                                                                                                                   | `""`                     |
| `javaOpts`                                          | Set extra Java Options when launching Nessie                                                                                                                                                                         | `""`                     |
| `image.registry`                                    | nessie image registry                                                                                                                                                                                                | `REGISTRY_NAME`          |
| `image.repository`                                  | nessie image repository                                                                                                                                                                                              | `REPOSITORY_NAME/nessie` |
| `image.digest`                                      | nessie image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)                                                                    | `""`                     |
| `image.pullPolicy`                                  | nessie image pull policy                                                                                                                                                                                             | `IfNotPresent`           |
| `image.pullSecrets`                                 | nessie image pull secrets                                                                                                                                                                                            | `[]`                     |
| `image.debug`                                       | Enable nessie image debug mode                                                                                                                                                                                       | `false`                  |
| `replicaCount`                                      | Number of nessie replicas to deploy                                                                                                                                                                                  | `1`                      |
| `containerPorts.http`                               | nessie http server container port                                                                                                                                                                                    | `19120`                  |
| `containerPorts.management`                         | management container port                                                                                                                                                                                            | `9000`                   |
| `extraContainerPorts`                               | Optionally specify extra list of additional container ports                                                                                                                                                          | `[]`                     |
| `deploymentLabels`                                  | Add extra labels to the Deployment object                                                                                                                                                                            | `{}`                     |
| `deploymentAnnotations`                             | Add extra annotations to the Deployment object                                                                                                                                                                       | `{}`                     |
| `logLevel`                                          | Set application log level                                                                                                                                                                                            | `INFO`                   |
| `usePasswordFile`                                   | Mount all sensitive information as files                                                                                                                                                                             | `true`                   |
| `versionStoreType`                                  | Set version store type. The chart natively supports JDBC_POSTGRESQL, ROCKSDB and IN_MEMORY. Any other type requires you to add the configuration in configOverrides and secretConfigOverrides.                       | `JDBC_POSTGRESQL`        |
| `livenessProbe.enabled`                             | Enable livenessProbe on nessie containers                                                                                                                                                                            | `true`                   |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                              | `10`                     |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                     | `10`                     |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                    | `5`                      |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                  | `5`                      |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                  | `1`                      |
| `readinessProbe.enabled`                            | Enable readinessProbe on nessie containers                                                                                                                                                                           | `true`                   |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                             | `10`                     |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                    | `10`                     |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                   | `5`                      |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                 | `5`                      |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                 | `1`                      |
| `startupProbe.enabled`                              | Enable startupProbe on nessie containers                                                                                                                                                                             | `false`                  |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                               | `90`                     |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                      | `10`                     |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                     | `5`                      |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                   | `5`                      |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                   | `1`                      |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                  | `{}`                     |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                 | `{}`                     |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                   | `{}`                     |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (secondary.resources is recommended for production). | `medium`                 |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                    | `{}`                     |
| `podSecurityContext.enabled`                        | Enable security context for nessie pods                                                                                                                                                                              | `true`                   |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                   | `Always`                 |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                       | `[]`                     |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                          | `[]`                     |
| `podSecurityContext.fsGroup`                        | Group ID for the mounted volumes' filesystem                                                                                                                                                                         | `1001`                   |
| `containerSecurityContext.enabled`                  | nessie container securityContext                                                                                                                                                                                     | `true`                   |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                     | `nil`                    |
| `containerSecurityContext.runAsUser`                | User ID for the nessie container                                                                                                                                                                                     | `1001`                   |
| `containerSecurityContext.runAsGroup`               | Group ID for the nessie container                                                                                                                                                                                    | `1001`                   |
| `containerSecurityContext.runAsNonRoot`             | Set secondary container's Security Context runAsNonRoot                                                                                                                                                              | `true`                   |
| `containerSecurityContext.privileged`               | Set secondary container's Security Context privileged                                                                                                                                                                | `false`                  |
| `containerSecurityContext.allowPrivilegeEscalation` | Set secondary container's Security Context allowPrivilegeEscalation                                                                                                                                                  | `false`                  |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                              | `true`                   |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                   | `["ALL"]`                |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                     | `RuntimeDefault`         |
| `command`                                           | Override default container command (useful when using custom images)                                                                                                                                                 | `[]`                     |
| `args`                                              | Override default container args (useful when using custom images)                                                                                                                                                    | `[]`                     |
| `hostAliases`                                       | nessie pods host aliases                                                                                                                                                                                             | `[]`                     |
| `annotations`                                       | Annotations for nessie deployment/statefulset                                                                                                                                                                        | `{}`                     |
| `podLabels`                                         | Extra labels for nessie pods                                                                                                                                                                                         | `{}`                     |
| `podAnnotations`                                    | Annotations for nessie pods                                                                                                                                                                                          | `{}`                     |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `""`                     |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `soft`                   |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                      | `true`                   |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                       | `""`                     |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                       | `""`                     |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                            | `""`                     |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                                | `""`                     |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                             | `[]`                     |
| `affinity`                                          | Affinity for nessie pods assignment                                                                                                                                                                                  | `{}`                     |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                   | `false`                  |
| `nodeSelector`                                      | Node labels for nessie pods assignment                                                                                                                                                                               | `{}`                     |
| `tolerations`                                       | Tolerations for nessie pods assignment                                                                                                                                                                               | `[]`                     |
| `updateStrategy.type`                               | nessie strategy type                                                                                                                                                                                                 | `RollingUpdate`          |
| `priorityClassName`                                 | nessie pods' priorityClassName                                                                                                                                                                                       | `""`                     |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                             | `[]`                     |
| `schedulerName`                                     | Name of the k8s scheduler (other than default) for nessie pods                                                                                                                                                       | `""`                     |
| `terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                    | `""`                     |
| `lifecycleHooks`                                    | for the nessie container(s) to automate configuration before or after startup                                                                                                                                        | `{}`                     |
| `extraEnvVars`                                      | Array with extra environment variables to add to nessie nodes                                                                                                                                                        | `[]`                     |
| `extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for nessie nodes                                                                                                                                                | `""`                     |
| `extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for nessie nodes                                                                                                                                                   | `""`                     |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for the nessie pod(s)                                                                                                                                            | `[]`                     |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the nessie container(s)                                                                                                                                 | `[]`                     |
| `sidecars`                                          | Add additional sidecar containers to the nessie pod(s)                                                                                                                                                               | `[]`                     |
| `initContainers`                                    | Add additional init containers to the nessie pod(s)                                                                                                                                                                  | `[]`                     |

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

| Name                                          | Description                                                                                                                      | Value                    |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.server.type`                         | nessie service type                                                                                                              | `LoadBalancer`           |
| `service.server.ports.http`                   | nessie service http port                                                                                                         | `19120`                  |
| `service.server.nodePorts.http`               | Node port for Gremlin                                                                                                            | `""`                     |
| `service.server.clusterIP`                    | nessie service Cluster IP                                                                                                        | `""`                     |
| `service.server.loadBalancerIP`               | nessie service Load Balancer IP                                                                                                  | `""`                     |
| `service.server.loadBalancerSourceRanges`     | nessie service Load Balancer sources                                                                                             | `[]`                     |
| `service.server.externalTrafficPolicy`        | nessie service external traffic policy                                                                                           | `Cluster`                |
| `service.server.annotations`                  | Additional custom annotations for nessie service                                                                                 | `{}`                     |
| `service.server.extraPorts`                   | Extra ports to expose in nessie service (normally used with the `sidecars` value)                                                | `[]`                     |
| `service.server.sessionAffinity`              | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.server.sessionAffinityConfig`        | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.management.type`                     | nessie service type                                                                                                              | `ClusterIP`              |
| `service.management.ports.http`               | nessie service http port                                                                                                         | `9000`                   |
| `service.management.nodePorts.http`           | Node port for Gremlin                                                                                                            | `""`                     |
| `service.management.clusterIP`                | nessie service Cluster IP                                                                                                        | `""`                     |
| `service.management.loadBalancerIP`           | nessie service Load Balancer IP                                                                                                  | `""`                     |
| `service.management.loadBalancerSourceRanges` | nessie service Load Balancer sources                                                                                             | `[]`                     |
| `service.management.externalTrafficPolicy`    | nessie service external traffic policy                                                                                           | `Cluster`                |
| `service.management.annotations`              | Additional custom annotations for nessie service                                                                                 | `{}`                     |
| `service.management.extraPorts`               | Extra ports to expose in nessie service (normally used with the `sidecars` value)                                                | `[]`                     |
| `service.management.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.management.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                             | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.selfSigned`                          | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.pathType`                            | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                          | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                            | Default host for the ingress resource                                                                                            | `nessie.local`           |
| `ingress.path`                                | The Path to Nginx. You may need to set this to '/*' in order to use this with ALB ingress controllers.                           | `/`                      |
| `ingress.annotations`                         | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.ingressClassName`                    | Set the ingerssClassName on the ingress record for k8s 1.18+                                                                     | `""`                     |
| `ingress.tls`                                 | Create TLS Secret                                                                                                                | `false`                  |
| `ingress.tlsWwwPrefix`                        | Adds www subdomain to default cert                                                                                               | `false`                  |
| `ingress.extraHosts`                          | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`                          | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                            | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                             | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`                          | The list of additional rules to be added to this ingress record. Evaluated as a template                                         | `[]`                     |

### Persistence Parameters

| Name                         | Description                                                                                                                           | Value                  |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `persistence.enabled`        | Enable persistence using Persistent Volume Claims                                                                                     | `true`                 |
| `persistence.mountPath`      | Path to mount the volume at.                                                                                                          | `/bitnami/nessie/data` |
| `persistence.subPath`        | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services                               | `""`                   |
| `persistence.storageClass`   | Storage class of backing PVC                                                                                                          | `""`                   |
| `persistence.annotations`    | Persistent Volume Claim annotations                                                                                                   | `{}`                   |
| `persistence.accessModes`    | Persistent Volume Access Modes                                                                                                        | `["ReadWriteOnce"]`    |
| `persistence.size`           | Size of data volume                                                                                                                   | `8Gi`                  |
| `persistence.existingClaim`  | The name of an existing PVC to use for persistence                                                                                    | `""`                   |
| `persistence.selector`       | Selector to match an existing Persistent Volume for nessie data PVC                                                                   | `{}`                   |
| `persistence.dataSource`     | Custom PVC data source                                                                                                                | `{}`                   |
| `persistence.resourcePolicy` | Setting it to "keep" to avoid removing PVCs during a helm delete operation. Leaving it empty will delete PVCs after the chart deleted | `""`                   |

### Other Parameters

| Name                                                              | Description                                                                                                                                                                                                                                           | Value                               |
| ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `volumePermissions.enabled`                                       | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                             |
| `volumePermissions.image.registry`                                | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`                     |
| `volumePermissions.image.repository`                              | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell`          |
| `volumePermissions.image.pullPolicy`                              | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`                      |
| `volumePermissions.image.pullSecrets`                             | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                                |
| `volumePermissions.resourcesPreset`                               | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                              |
| `volumePermissions.resources`                                     | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                                |
| `volumePermissions.containerSecurityContext.enabled`              | Enable volumePermissions container security context                                                                                                                                                                                                   | `true`                              |
| `volumePermissions.containerSecurityContext.runAsUser`            | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                                 |
| `waitContainer.image.registry`                                    | PostgreSQL client image registry                                                                                                                                                                                                                      | `REGISTRY_NAME`                     |
| `waitContainer.image.repository`                                  | PostgreSQL client image repository                                                                                                                                                                                                                    | `REPOSITORY_NAME/supabase-postgres` |
| `waitContainer.image.digest`                                      | PostgreSQL client image digest (overrides image tag)                                                                                                                                                                                                  | `""`                                |
| `waitContainer.image.pullPolicy`                                  | PostgreSQL client image pull policy                                                                                                                                                                                                                   | `IfNotPresent`                      |
| `waitContainer.image.pullSecrets`                                 | PostgreSQL client image pull secrets                                                                                                                                                                                                                  | `[]`                                |
| `waitContainer.image.debug`                                       | Enable PostgreSQL client image debug mode                                                                                                                                                                                                             | `false`                             |
| `waitContainer.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if waitContainer.resources is set (waitContainer.resources is recommended for production).         | `nano`                              |
| `waitContainer.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                                |
| `waitContainer.containerSecurityContext.enabled`                  | nessie container securityContext                                                                                                                                                                                                                      | `true`                              |
| `waitContainer.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                      | `nil`                               |
| `waitContainer.containerSecurityContext.runAsUser`                | User ID for the nessie container                                                                                                                                                                                                                      | `1001`                              |
| `waitContainer.containerSecurityContext.runAsGroup`               | Group ID for the nessie container                                                                                                                                                                                                                     | `1001`                              |
| `waitContainer.containerSecurityContext.runAsNonRoot`             | Set secondary container's Security Context runAsNonRoot                                                                                                                                                                                               | `true`                              |
| `waitContainer.containerSecurityContext.privileged`               | Set secondary container's Security Context privileged                                                                                                                                                                                                 | `false`                             |
| `waitContainer.containerSecurityContext.allowPrivilegeEscalation` | Set secondary container's Security Context allowPrivilegeEscalation                                                                                                                                                                                   | `false`                             |
| `waitContainer.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                               | `true`                              |
| `waitContainer.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                    | `["ALL"]`                           |
| `waitContainer.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                      | `RuntimeDefault`                    |
| `serviceAccount.create`                                           | Specifies whether a ServiceAccount should be created                                                                                                                                                                                                  | `true`                              |
| `serviceAccount.name`                                             | The name of the ServiceAccount to use.                                                                                                                                                                                                                | `""`                                |
| `serviceAccount.annotations`                                      | Additional Service Account annotations (evaluated as a template)                                                                                                                                                                                      | `{}`                                |
| `serviceAccount.automountServiceAccountToken`                     | Automount service account token for the server service account                                                                                                                                                                                        | `false`                             |

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

| Name                                          | Description                                                             | Value            |
| --------------------------------------------- | ----------------------------------------------------------------------- | ---------------- |
| `postgresql.enabled`                          | Switch to enable or disable the PostgreSQL helm chart                   | `true`           |
| `postgresql.auth.username`                    | Name for a custom user to create                                        | `bn_nessie`      |
| `postgresql.auth.password`                    | Password for the custom user to create                                  | `""`             |
| `postgresql.auth.database`                    | Name for a custom database to create                                    | `bitnami_nessie` |
| `postgresql.auth.existingSecret`              | Name of existing secret to use for PostgreSQL credentials               | `""`             |
| `postgresql.architecture`                     | PostgreSQL architecture (`standalone` or `replication`)                 | `standalone`     |
| `postgresql.primary.service.ports.postgresql` | PostgreSQL service port                                                 | `5432`           |
| `externalDatabase.host`                       | Database host                                                           | `""`             |
| `externalDatabase.port`                       | Database port number                                                    | `5432`           |
| `externalDatabase.user`                       | Non-root username                                                       | `postgres`       |
| `externalDatabase.password`                   | Password for the non-root username                                      | `""`             |
| `externalDatabase.database`                   | Database name                                                           | `nessie`         |
| `externalDatabase.existingSecret`             | Name of an existing secret resource containing the database credentials | `""`             |
| `externalDatabase.existingSecretPasswordKey`  | Name of an existing secret key containing the database credentials      | `db-password`    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    oci://REGISTRY_NAME/REPOSITORY_NAME/nessie
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/nessie
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/blob/main/template/nessie/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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