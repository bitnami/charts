<!--- app-name: Mastodon -->

# Bitnami package for Mastodon

Mastodon is self-hosted social network server based on ActivityPub. Written in Ruby, features real-time updates, multimedia attachments and no vendor lock-in.

[Overview of Mastodon](https://joinmastodon.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mastodon
```

Looking to use Mastodon in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps an [Mastodon](https://www.mastodon.com/) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/mastodon
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Mastodon on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### External database support

You may want to have Mastodon connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#parameters). You should also disable the MongoDB installation with the `postgresql.enabled` option. Here is an example:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

### External redis support

You may want to have mastodon connect to an external redis rather than installing one inside your cluster. Typical reasons for this are to use a managed redis service, or to share a common redis server for all your applications. To achieve this, the chart allows you to specify credentials for an external redis with the [`externalRedis` parameter](#parameters). You should also disable the Redis installation with the `redis.enabled` option. Here is an example:

```console
redis.enabled=false
externalRedis.host=myexternalhost
externalRedis.password=mypassword
externalRedis.port=6379
```

### External elasticsearch support

You may want to have mastodon connect to an external elasticsearch rather than installing one inside your cluster. Typical reasons for this are to use a managed elasticsearch service, or to share a common elasticsearch server for all your applications. To achieve this, the chart allows you to specify credentials for an external elasticsearch with the [`externalElasticsearch` parameter](#parameters). You should also disable the Redis installation with the `elasticsearch.enabled` option. Here is an example:

```console
elasticsearch.enabled=false
externalElasticsearch.host=myexternalhost
externalElasticsearch.password=mypassword
externalElasticsearch.port=9200
```

### External S3 support

You may want to have mastodon connect to an external storage streaming rather than installing MiniIO(TM) inside your cluster. To achieve this, the chart allows you to specify credentials for an external storage streaming with the [`externalS3` parameter](#parameters). You should also disable the MinIO(TM) installation with the `minio.enabled` option. Here is an example:

```console
minio.enabled=false
externalS3.host=myexternalhost
exterernalS3.accessKeyID=accesskey
externalS3.accessKeySecret=secret
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `apache.ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `apache.ingress.hostname` property can be used to set the host name. The `apache.ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `apache.ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `apache.ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `apache.ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

Adding the TLS parameter (where available) will cause the chart to generate HTTPS URLs, and the  application will be available on port 443. The actual TLS secrets do not have to be generated by this chart. However, if TLS is enabled, the Ingress record will not work until the TLS secret exists.

[Learn more about Ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

### TLS secrets

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

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside the `web`, `streaming` and `sidekiq` sections.

```yaml
streaming:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values inside the `web`, `streaming` and `sidekiq` sections.

### Sidecars

If additional containers are needed in the same pod as mastodon (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter inside the `web`, `streaming` and `sidekiq` sections.

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

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside the `web`, `streaming` and `sidekiq` sections.

## Persistence

The [Bitnami mastodon](https://github.com/bitnami/containers/tree/main/bitnami/mastodon) image stores the mastodon data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                     | Description                                                                                                                                         | Value                      |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `kubeVersion`            | Override Kubernetes version                                                                                                                         | `""`                       |
| `nameOverride`           | String to partially override common.names.name                                                                                                      | `""`                       |
| `fullnameOverride`       | String to fully override common.names.fullname                                                                                                      | `""`                       |
| `namespaceOverride`      | String to fully override common.names.namespace                                                                                                     | `""`                       |
| `commonLabels`           | Labels to add to all deployed objects                                                                                                               | `{}`                       |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                                                                          | `{}`                       |
| `clusterDomain`          | Kubernetes cluster domain name                                                                                                                      | `cluster.local`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                                                                   | `[]`                       |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)                                                             | `false`                    |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                                                                | `["sleep"]`                |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                                                                   | `["infinity"]`             |
| `image.registry`         | Mastodon image registry                                                                                                                             | `REGISTRY_NAME`            |
| `image.repository`       | Mastodon image repository                                                                                                                           | `REPOSITORY_NAME/mastodon` |
| `image.digest`           | Mastodon image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                       |
| `image.pullPolicy`       | Mastodon image pull policy                                                                                                                          | `IfNotPresent`             |
| `image.pullSecrets`      | Mastodon image pull secrets                                                                                                                         | `[]`                       |
| `image.debug`            | Enable Mastodon image debug mode                                                                                                                    | `false`                    |

### Mastodon common parameters

| Name                             | Description                                                                                                                    | Value                                |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------ |
| `environment`                    | Mastodon Rails and Node environment. Should be one of 'production',                                                            | `production`                         |
| `adminUser`                      | Mastodon admin username                                                                                                        | `""`                                 |
| `adminEmail`                     | Mastodon admin email                                                                                                           | `""`                                 |
| `adminPassword`                  | Mastodon admin password                                                                                                        | `""`                                 |
| `otpSecret`                      | Mastodon one time password secret. Generate with rake secret. Changing it will break two-factor authentication.                | `""`                                 |
| `secretKeyBase`                  | Mastodon secret key base. Generate with rake secret. Changing it will break all active browser sessions.                       | `""`                                 |
| `vapidPrivateKey`                | Mastodon vapid private key. Generate with rake mastodon:webpush:generate_vapid_key. Changing it will break push notifications. | `""`                                 |
| `vapidPublicKey`                 | Mastodon vapid public key. Generate with rake mastodon:webpush:generate_vapid_key. Changing it will break push notifications.  | `""`                                 |
| `extraConfig`                    | Extra configuration for Mastodon in the form of environment variables                                                          | `{}`                                 |
| `extraSecretConfig`              | Extra secret configuration for Mastodon in the form of environment variables                                                   | `{}`                                 |
| `existingConfigmap`              | The name of an existing ConfigMap with your default configuration for Mastodon                                                 | `""`                                 |
| `existingSecret`                 | The name of an existing Secret with your default configuration for Mastodon                                                    | `""`                                 |
| `extraConfigExistingConfigmap`   | The name of an existing ConfigMap with your extra configuration for Mastodon                                                   | `""`                                 |
| `extraConfigExistingSecret`      | The name of an existing Secret with your extra configuration for Mastodon                                                      | `""`                                 |
| `enableSearches`                 | Enable the search engine (uses Elasticsearch under the hood)                                                                   | `true`                               |
| `enableS3`                       | Enable the S3 storage engine                                                                                                   | `true`                               |
| `forceHttpsS3Protocol`           | Force Mastodon's S3_PROTOCOL to be https (Useful when TLS is terminated using cert-manager/Ingress)                            | `false`                              |
| `useSecureWebSocket`             | Set Mastodon's STREAMING_API_BASE_URL to use secure websocket (wss:// instead of ws://)                                        | `false`                              |
| `local_https`                    | Set this instance to advertise itself to the fediverse using HTTPS rather than HTTP URLs. This should almost always be true.   | `true`                               |
| `localDomain`                    | The domain name used by accounts on this instance. Unless you're using                                                         | `""`                                 |
| `webDomain`                      | Optional alternate domain used when you want to host Mastodon at a                                                             | `""`                                 |
| `defaultLocale`                  | Set the default locale for this instance                                                                                       | `en`                                 |
| `s3AliasHost`                    | S3 alias host for Mastodon (will use 'http://webDomain/bucket' if not set)                                                     | `""`                                 |
| `smtp.server`                    | SMTP server                                                                                                                    | `""`                                 |
| `smtp.port`                      | SMTP port                                                                                                                      | `587`                                |
| `smtp.from_address`              | From address for sent emails                                                                                                   | `""`                                 |
| `smtp.domain`                    | SMTP domain                                                                                                                    | `""`                                 |
| `smtp.reply_to`                  | Reply-To value for sent emails                                                                                                 | `""`                                 |
| `smtp.delivery_method`           | SMTP delivery method                                                                                                           | `smtp`                               |
| `smtp.ca_file`                   | SMTP CA file location                                                                                                          | `/etc/ssl/certs/ca-certificates.crt` |
| `smtp.openssl_verify_mode`       | OpenSSL verify mode                                                                                                            | `none`                               |
| `smtp.enable_starttls_auto`      | Automatically enable StartTLS                                                                                                  | `true`                               |
| `smtp.tls`                       | SMTP TLS                                                                                                                       | `false`                              |
| `smtp.auth_method`               | SMTP auth method (set to "none" to disable SMTP auth)                                                                          | `plain`                              |
| `smtp.login`                     | SMTP auth username                                                                                                             | `""`                                 |
| `smtp.password`                  | SMTP auth password                                                                                                             | `""`                                 |
| `smtp.existingSecret`            | Name of an existing secret resource containing the SMTP                                                                        | `""`                                 |
| `smtp.existingSecretLoginKey`    | Name of the key for the SMTP login credential                                                                                  | `""`                                 |
| `smtp.existingSecretPasswordKey` | Name of the key for the SMTP password credential                                                                               | `""`                                 |
| `smtp.existingSecretServerKey`   | Name of the key for the SMTP hostname                                                                                          | `""`                                 |

### Mastodon Web Parameters

| Name                                                    | Description                                                                                                                                                                                                               | Value            |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `web.replicaCount`                                      | Number of Mastodon web replicas to deploy                                                                                                                                                                                 | `1`              |
| `web.containerPorts.http`                               | Mastodon web HTTP container port                                                                                                                                                                                          | `3000`           |
| `web.livenessProbe.enabled`                             | Enable livenessProbe on Mastodon web containers                                                                                                                                                                           | `true`           |
| `web.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                   | `10`             |
| `web.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                          | `10`             |
| `web.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                         | `5`              |
| `web.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                       | `6`              |
| `web.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                       | `1`              |
| `web.readinessProbe.enabled`                            | Enable readinessProbe on Mastodon web containers                                                                                                                                                                          | `true`           |
| `web.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                  | `10`             |
| `web.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                         | `10`             |
| `web.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                        | `5`              |
| `web.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                      | `6`              |
| `web.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                      | `1`              |
| `web.startupProbe.enabled`                              | Enable startupProbe on Mastodon web containers                                                                                                                                                                            | `false`          |
| `web.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                    | `10`             |
| `web.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                           | `10`             |
| `web.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                          | `5`              |
| `web.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                        | `6`              |
| `web.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                        | `1`              |
| `web.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                       | `{}`             |
| `web.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                      | `{}`             |
| `web.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                        | `{}`             |
| `web.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if web.resources is set (web.resources is recommended for production). | `small`          |
| `web.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                         | `{}`             |
| `web.podSecurityContext.enabled`                        | Enabled Mastodon web pods' Security Context                                                                                                                                                                               | `true`           |
| `web.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                        | `Always`         |
| `web.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                            | `[]`             |
| `web.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                               | `[]`             |
| `web.podSecurityContext.fsGroup`                        | Set Mastodon web pod's Security Context fsGroup                                                                                                                                                                           | `1001`           |
| `web.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                      | `true`           |
| `web.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                          | `nil`            |
| `web.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                | `1001`           |
| `web.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                               | `1001`           |
| `web.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                             | `true`           |
| `web.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                               | `false`          |
| `web.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                   | `true`           |
| `web.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                 | `false`          |
| `web.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                        | `["ALL"]`        |
| `web.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                          | `RuntimeDefault` |
| `web.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                      | `[]`             |
| `web.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                         | `[]`             |
| `web.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                        | `false`          |
| `web.hostAliases`                                       | Mastodon web pods host aliases                                                                                                                                                                                            | `[]`             |
| `web.podLabels`                                         | Extra labels for Mastodon web pods                                                                                                                                                                                        | `{}`             |
| `web.podAnnotations`                                    | Annotations for Mastodon web pods                                                                                                                                                                                         | `{}`             |
| `web.podAffinityPreset`                                 | Pod affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`             |
| `web.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                              | `soft`           |
| `web.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `web.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `""`             |
| `web.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `web.affinity` is set                                                                                                                                                                 | `""`             |
| `web.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `web.affinity` is set                                                                                                                                                              | `[]`             |
| `web.affinity`                                          | Affinity for Mastodon web pods assignment                                                                                                                                                                                 | `{}`             |
| `web.nodeSelector`                                      | Node labels for Mastodon web pods assignment                                                                                                                                                                              | `{}`             |
| `web.tolerations`                                       | Tolerations for Mastodon web pods assignment                                                                                                                                                                              | `[]`             |
| `web.updateStrategy.type`                               | Mastodon web statefulset strategy type                                                                                                                                                                                    | `RollingUpdate`  |
| `web.priorityClassName`                                 | Mastodon web pods' priorityClassName                                                                                                                                                                                      | `""`             |
| `web.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                  | `[]`             |
| `web.schedulerName`                                     | Name of the k8s scheduler (other than default) for Mastodon web pods                                                                                                                                                      | `""`             |
| `web.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                         | `""`             |
| `web.lifecycleHooks`                                    | for the Mastodon web container(s) to automate configuration before or after startup                                                                                                                                       | `{}`             |
| `web.extraEnvVars`                                      | Array with extra environment variables to add to Mastodon web nodes                                                                                                                                                       | `[]`             |
| `web.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Mastodon web nodes                                                                                                                                               | `""`             |
| `web.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Mastodon web nodes                                                                                                                                                  | `""`             |
| `web.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Mastodon web pod(s)                                                                                                                                           | `[]`             |
| `web.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Mastodon web container(s)                                                                                                                                | `[]`             |
| `web.sidecars`                                          | Add additional sidecar containers to the Mastodon web pod(s)                                                                                                                                                              | `[]`             |
| `web.initContainers`                                    | Add additional init containers to the Mastodon web pod(s)                                                                                                                                                                 | `[]`             |

### Mastodon Web Traffic Exposure Parameters

| Name                                        | Description                                                                             | Value       |
| ------------------------------------------- | --------------------------------------------------------------------------------------- | ----------- |
| `web.service.type`                          | Mastodon web service type                                                               | `ClusterIP` |
| `web.service.ports.http`                    | Mastodon web service HTTP port                                                          | `80`        |
| `web.service.nodePorts.http`                | Node port for HTTP                                                                      | `""`        |
| `web.service.clusterIP`                     | Mastodon web service Cluster IP                                                         | `""`        |
| `web.service.loadBalancerIP`                | Mastodon web service Load Balancer IP                                                   | `""`        |
| `web.service.loadBalancerSourceRanges`      | Mastodon web service Load Balancer sources                                              | `[]`        |
| `web.service.externalTrafficPolicy`         | Mastodon web service external traffic policy                                            | `Cluster`   |
| `web.service.annotations`                   | Additional custom annotations for Mastodon web service                                  | `{}`        |
| `web.service.extraPorts`                    | Extra ports to expose in Mastodon web service (normally used with the `sidecars` value) | `[]`        |
| `web.service.sessionAffinity`               | Control where web requests go, to the same pod or round-robin                           | `None`      |
| `web.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                             | `{}`        |
| `web.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                                              | `true`      |
| `web.networkPolicy.allowExternal`           | The Policy model to apply                                                               | `true`      |
| `web.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                         | `true`      |
| `web.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                            | `[]`        |
| `web.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                            | `[]`        |
| `web.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                  | `{}`        |
| `web.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                              | `{}`        |

### Mastodon Sidekiq Parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value            |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `sidekiq.replicaCount`                                      | Number of Mastodon sidekiq replicas to deploy                                                                                                                                                                                     | `1`              |
| `sidekiq.livenessProbe.enabled`                             | Enable livenessProbe on Mastodon sidekiq containers                                                                                                                                                                               | `true`           |
| `sidekiq.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `10`             |
| `sidekiq.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`             |
| `sidekiq.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`              |
| `sidekiq.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `6`              |
| `sidekiq.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`              |
| `sidekiq.readinessProbe.enabled`                            | Enable readinessProbe on Mastodon sidekiq containers                                                                                                                                                                              | `true`           |
| `sidekiq.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `10`             |
| `sidekiq.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`             |
| `sidekiq.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `5`              |
| `sidekiq.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `6`              |
| `sidekiq.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`              |
| `sidekiq.startupProbe.enabled`                              | Enable startupProbe on Mastodon sidekiq containers                                                                                                                                                                                | `false`          |
| `sidekiq.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `10`             |
| `sidekiq.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`             |
| `sidekiq.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `5`              |
| `sidekiq.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `6`              |
| `sidekiq.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`              |
| `sidekiq.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`             |
| `sidekiq.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`             |
| `sidekiq.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`             |
| `sidekiq.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sidekiq.resources is set (sidekiq.resources is recommended for production). | `small`          |
| `sidekiq.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`             |
| `sidekiq.podSecurityContext.enabled`                        | Enabled Mastodon sidekiq pods' Security Context                                                                                                                                                                                   | `true`           |
| `sidekiq.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`         |
| `sidekiq.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`             |
| `sidekiq.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`             |
| `sidekiq.podSecurityContext.fsGroup`                        | Set Mastodon sidekiq pod's Security Context fsGroup                                                                                                                                                                               | `1001`           |
| `sidekiq.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`           |
| `sidekiq.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `nil`            |
| `sidekiq.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`           |
| `sidekiq.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `1001`           |
| `sidekiq.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`           |
| `sidekiq.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`          |
| `sidekiq.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`           |
| `sidekiq.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`          |
| `sidekiq.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`        |
| `sidekiq.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault` |
| `sidekiq.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                              | `[]`             |
| `sidekiq.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                 | `[]`             |
| `sidekiq.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`          |
| `sidekiq.hostAliases`                                       | Mastodon sidekiq pods host aliases                                                                                                                                                                                                | `[]`             |
| `sidekiq.podLabels`                                         | Extra labels for Mastodon sidekiq pods                                                                                                                                                                                            | `{}`             |
| `sidekiq.podAnnotations`                                    | Annotations for Mastodon sidekiq pods                                                                                                                                                                                             | `{}`             |
| `sidekiq.podAffinityPreset`                                 | Pod affinity preset. Ignored if `sidekiq.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`             |
| `sidekiq.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `sidekiq.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                  | `soft`           |
| `sidekiq.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `sidekiq.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                 | `""`             |
| `sidekiq.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `sidekiq.affinity` is set                                                                                                                                                                     | `""`             |
| `sidekiq.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `sidekiq.affinity` is set                                                                                                                                                                  | `[]`             |
| `sidekiq.affinity`                                          | Affinity for Mastodon sidekiq pods assignment                                                                                                                                                                                     | `{}`             |
| `sidekiq.nodeSelector`                                      | Node labels for Mastodon sidekiq pods assignment                                                                                                                                                                                  | `{}`             |
| `sidekiq.tolerations`                                       | Tolerations for Mastodon sidekiq pods assignment                                                                                                                                                                                  | `[]`             |
| `sidekiq.updateStrategy.type`                               | Mastodon sidekiq statefulset strategy type                                                                                                                                                                                        | `RollingUpdate`  |
| `sidekiq.priorityClassName`                                 | Mastodon sidekiq pods' priorityClassName                                                                                                                                                                                          | `""`             |
| `sidekiq.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                          | `[]`             |
| `sidekiq.schedulerName`                                     | Name of the k8s scheduler (other than default) for Mastodon sidekiq pods                                                                                                                                                          | `""`             |
| `sidekiq.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                                 | `""`             |
| `sidekiq.lifecycleHooks`                                    | for the Mastodon sidekiq container(s) to automate configuration before or after startup                                                                                                                                           | `{}`             |
| `sidekiq.extraEnvVars`                                      | Array with extra environment variables to add to Mastodon sidekiq nodes                                                                                                                                                           | `[]`             |
| `sidekiq.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Mastodon sidekiq nodes                                                                                                                                                   | `""`             |
| `sidekiq.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Mastodon sidekiq nodes                                                                                                                                                      | `""`             |
| `sidekiq.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Mastodon sidekiq pod(s)                                                                                                                                               | `[]`             |
| `sidekiq.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Mastodon sidekiq container(s)                                                                                                                                    | `[]`             |
| `sidekiq.sidecars`                                          | Add additional sidecar containers to the Mastodon sidekiq pod(s)                                                                                                                                                                  | `[]`             |
| `sidekiq.initContainers`                                    | Add additional init containers to the Mastodon sidekiq pod(s)                                                                                                                                                                     | `[]`             |
| `sidekiq.networkPolicy.enabled`                             | Enable creation of NetworkPolicy resources                                                                                                                                                                                        | `true`           |
| `sidekiq.networkPolicy.allowExternal`                       | The Policy model to apply                                                                                                                                                                                                         | `true`           |
| `sidekiq.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                   | `true`           |
| `sidekiq.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`             |
| `sidekiq.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`             |
| `sidekiq.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`             |
| `sidekiq.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                        | `{}`             |

### Mastodon Streaming Parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value            |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `streaming.replicaCount`                                      | Number of Mastodon streaming replicas to deploy                                                                                                                                                                                       | `1`              |
| `streaming.containerPorts.http`                               | Mastodon streaming HTTP container port                                                                                                                                                                                                | `8080`           |
| `streaming.livenessProbe.enabled`                             | Enable livenessProbe on Mastodon streaming containers                                                                                                                                                                                 | `true`           |
| `streaming.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `10`             |
| `streaming.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`             |
| `streaming.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `5`              |
| `streaming.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `6`              |
| `streaming.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`              |
| `streaming.readinessProbe.enabled`                            | Enable readinessProbe on Mastodon streaming containers                                                                                                                                                                                | `true`           |
| `streaming.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `10`             |
| `streaming.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`             |
| `streaming.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `5`              |
| `streaming.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `6`              |
| `streaming.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`              |
| `streaming.startupProbe.enabled`                              | Enable startupProbe on Mastodon streaming containers                                                                                                                                                                                  | `false`          |
| `streaming.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `10`             |
| `streaming.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `10`             |
| `streaming.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `5`              |
| `streaming.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `6`              |
| `streaming.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`              |
| `streaming.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                   | `{}`             |
| `streaming.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                  | `{}`             |
| `streaming.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                    | `{}`             |
| `streaming.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if streaming.resources is set (streaming.resources is recommended for production). | `small`          |
| `streaming.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`             |
| `streaming.podSecurityContext.enabled`                        | Enabled Mastodon streaming pods' Security Context                                                                                                                                                                                     | `true`           |
| `streaming.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`         |
| `streaming.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`             |
| `streaming.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`             |
| `streaming.podSecurityContext.fsGroup`                        | Set Mastodon streaming pod's Security Context fsGroup                                                                                                                                                                                 | `1001`           |
| `streaming.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`           |
| `streaming.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `nil`            |
| `streaming.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `1001`           |
| `streaming.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `1001`           |
| `streaming.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `true`           |
| `streaming.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`          |
| `streaming.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`           |
| `streaming.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`          |
| `streaming.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`        |
| `streaming.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault` |
| `streaming.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                  | `[]`             |
| `streaming.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                     | `[]`             |
| `streaming.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `false`          |
| `streaming.hostAliases`                                       | Mastodon streaming pods host aliases                                                                                                                                                                                                  | `[]`             |
| `streaming.podLabels`                                         | Extra labels for Mastodon streaming pods                                                                                                                                                                                              | `{}`             |
| `streaming.podAnnotations`                                    | Annotations for Mastodon streaming pods                                                                                                                                                                                               | `{}`             |
| `streaming.podAffinityPreset`                                 | Pod affinity preset. Ignored if `streaming.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                         | `""`             |
| `streaming.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `streaming.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `soft`           |
| `streaming.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `streaming.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`             |
| `streaming.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `streaming.affinity` is set                                                                                                                                                                       | `""`             |
| `streaming.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `streaming.affinity` is set                                                                                                                                                                    | `[]`             |
| `streaming.affinity`                                          | Affinity for Mastodon streaming pods assignment                                                                                                                                                                                       | `{}`             |
| `streaming.nodeSelector`                                      | Node labels for Mastodon streaming pods assignment                                                                                                                                                                                    | `{}`             |
| `streaming.tolerations`                                       | Tolerations for Mastodon streaming pods assignment                                                                                                                                                                                    | `[]`             |
| `streaming.updateStrategy.type`                               | Mastodon streaming statefulset strategy type                                                                                                                                                                                          | `RollingUpdate`  |
| `streaming.priorityClassName`                                 | Mastodon streaming pods' priorityClassName                                                                                                                                                                                            | `""`             |
| `streaming.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                              | `[]`             |
| `streaming.schedulerName`                                     | Name of the k8s scheduler (other than default) for Mastodon streaming pods                                                                                                                                                            | `""`             |
| `streaming.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                                     | `""`             |
| `streaming.lifecycleHooks`                                    | for the Mastodon streaming container(s) to automate configuration before or after startup                                                                                                                                             | `{}`             |
| `streaming.extraEnvVars`                                      | Array with extra environment variables to add to Mastodon streaming nodes                                                                                                                                                             | `[]`             |
| `streaming.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Mastodon streaming nodes                                                                                                                                                     | `""`             |
| `streaming.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Mastodon streaming nodes                                                                                                                                                        | `""`             |
| `streaming.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Mastodon streaming pod(s)                                                                                                                                                 | `[]`             |
| `streaming.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Mastodon streaming container(s)                                                                                                                                      | `[]`             |
| `streaming.sidecars`                                          | Add additional sidecar containers to the Mastodon streaming pod(s)                                                                                                                                                                    | `[]`             |
| `streaming.initContainers`                                    | Add additional init containers to the Mastodon streaming pod(s)                                                                                                                                                                       | `[]`             |

### Mastodon Streaming Traffic Exposure Parameters

| Name                                              | Description                                                                                   | Value       |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------- |
| `streaming.service.type`                          | Mastodon streaming service type                                                               | `ClusterIP` |
| `streaming.service.ports.http`                    | Mastodon streaming service HTTP port                                                          | `80`        |
| `streaming.service.nodePorts.http`                | Node port for HTTP                                                                            | `""`        |
| `streaming.service.clusterIP`                     | Mastodon streaming service Cluster IP                                                         | `""`        |
| `streaming.service.loadBalancerIP`                | Mastodon streaming service Load Balancer IP                                                   | `""`        |
| `streaming.service.loadBalancerSourceRanges`      | Mastodon streaming service Load Balancer sources                                              | `[]`        |
| `streaming.service.externalTrafficPolicy`         | Mastodon streaming service external traffic policy                                            | `Cluster`   |
| `streaming.service.annotations`                   | Additional custom annotations for Mastodon streaming service                                  | `{}`        |
| `streaming.service.extraPorts`                    | Extra ports to expose in Mastodon streaming service (normally used with the `sidecars` value) | `[]`        |
| `streaming.service.sessionAffinity`               | Control where streaming requests go, to the same pod or round-robin                           | `None`      |
| `streaming.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                   | `{}`        |
| `streaming.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                                                    | `true`      |
| `streaming.networkPolicy.allowExternal`           | The Policy model to apply                                                                     | `true`      |
| `streaming.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                               | `true`      |
| `streaming.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                  | `[]`        |
| `streaming.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                  | `[]`        |
| `streaming.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                        | `{}`        |
| `streaming.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                    | `{}`        |

### Mastodon Media Management Cronjob Parameters

| Name                                                           | Description                                                                            | Value        |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ------------ |
| `tootctlMediaManagement.enabled`                               | Enable Cronjob to manage all media caches                                              | `false`      |
| `tootctlMediaManagement.removeAttachments`                     | Enable removing attachements                                                           | `true`       |
| `tootctlMediaManagement.removeAttachmentsDays`                 | Number of days old media attachments must be for removal                               | `30`         |
| `tootctlMediaManagement.removeCustomEmoji`                     | Enable removal of cached remote emoji files                                            | `false`      |
| `tootctlMediaManagement.removePreviewCards`                    | Enable removal of cached preview cards                                                 | `false`      |
| `tootctlMediaManagement.removePreviewCardsDays`                | Number of days old preview cards must be for removal                                   | `30`         |
| `tootctlMediaManagement.removeAvatars`                         | Enable removal of cached remote avatar images                                          | `false`      |
| `tootctlMediaManagement.removeAvatarsDays`                     | Number of days old avatar images must be for removal                                   | `30`         |
| `tootctlMediaManagement.removeHeaders`                         | Enable removal of cached profile header images                                         | `false`      |
| `tootctlMediaManagement.removeHeadersDays`                     | Number of days old header images must be for removal                                   | `30`         |
| `tootctlMediaManagement.removeOrphans`                         | Enable removal of cached orphan files                                                  | `false`      |
| `tootctlMediaManagement.includeFollows`                        | Enable removal of cached avatar and header when local users are following the accounts | `false`      |
| `tootctlMediaManagement.cronSchedule`                          | Cron job schedule to run tootctl media commands                                        | `14 3 * * *` |
| `tootctlMediaManagement.failedJobsHistoryLimit`                | Number of failed jobs to keep                                                          | `3`          |
| `tootctlMediaManagement.successfulJobsHistoryLimit`            | Number of successful jobs to keep                                                      | `3`          |
| `tootctlMediaManagement.concurrencyPolicy`                     | Concurrency Policy.  Should be Allow, Forbid or Replace                                | `Allow`      |
| `tootctlMediaManagement.networkPolicy.enabled`                 | Enable creation of NetworkPolicy resources                                             | `true`       |
| `tootctlMediaManagement.networkPolicy.allowExternal`           | The Policy model to apply                                                              | `true`       |
| `tootctlMediaManagement.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                        | `true`       |
| `tootctlMediaManagement.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                           | `[]`         |
| `tootctlMediaManagement.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                           | `[]`         |
| `tootctlMediaManagement.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                 | `{}`         |
| `tootctlMediaManagement.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                             | `{}`         |

### Mastodon Migration job Parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value            |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `initJob.precompileAssets`                                  | Execute rake assets:precompile as part of the job                                                                                                                                                                                 | `true`           |
| `initJob.migrateDB`                                         | Execute rake db:migrate as part of the job                                                                                                                                                                                        | `true`           |
| `initJob.migrateElasticsearch`                              | Execute rake chewy:upgrade as part of the job                                                                                                                                                                                     | `true`           |
| `initJob.createAdmin`                                       | Create admin user as part of the job                                                                                                                                                                                              | `true`           |
| `initJob.backoffLimit`                                      | set backoff limit of the job                                                                                                                                                                                                      | `10`             |
| `initJob.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Mastodon init job                                                                                                                                                     | `[]`             |
| `initJob.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`           |
| `initJob.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `nil`            |
| `initJob.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`           |
| `initJob.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `1001`           |
| `initJob.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`           |
| `initJob.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`          |
| `initJob.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`           |
| `initJob.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`          |
| `initJob.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`        |
| `initJob.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault` |
| `initJob.podSecurityContext.enabled`                        | Enabled Mastodon init job pods' Security Context                                                                                                                                                                                  | `true`           |
| `initJob.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                | `Always`         |
| `initJob.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                    | `[]`             |
| `initJob.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                       | `[]`             |
| `initJob.podSecurityContext.fsGroup`                        | Set Mastodon init job pod's Security Context fsGroup                                                                                                                                                                              | `1001`           |
| `initJob.extraEnvVars`                                      | Array containing extra env vars to configure the Mastodon init job                                                                                                                                                                | `[]`             |
| `initJob.extraEnvVarsCM`                                    | ConfigMap containing extra env vars to configure the Mastodon init job                                                                                                                                                            | `""`             |
| `initJob.extraEnvVarsSecret`                                | Secret containing extra env vars to configure the Mastodon init job (in case of sensitive data)                                                                                                                                   | `""`             |
| `initJob.extraVolumeMounts`                                 | Array of extra volume mounts to be added to the Mastodon Container (evaluated as template). Normally used with `extraVolumes`.                                                                                                    | `[]`             |
| `initJob.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if initJob.resources is set (initJob.resources is recommended for production). | `small`          |
| `initJob.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`             |
| `initJob.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                | `false`          |
| `initJob.hostAliases`                                       | Add deployment host aliases                                                                                                                                                                                                       | `[]`             |
| `initJob.annotations`                                       | Add annotations to the job                                                                                                                                                                                                        | `{}`             |
| `initJob.podLabels`                                         | Additional pod labels                                                                                                                                                                                                             | `{}`             |
| `initJob.podAnnotations`                                    | Additional pod annotations                                                                                                                                                                                                        | `{}`             |
| `initJob.networkPolicy.enabled`                             | Enable creation of NetworkPolicy resources                                                                                                                                                                                        | `true`           |
| `initJob.networkPolicy.allowExternal`                       | The Policy model to apply                                                                                                                                                                                                         | `true`           |
| `initJob.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                   | `true`           |
| `initJob.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`             |
| `initJob.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                      | `[]`             |
| `initJob.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`             |
| `initJob.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                        | `{}`             |

### Persistence Parameters (only when S3 is disabled)

| Name                        | Description                                                                                             | Value               |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `false`             |
| `persistence.mountPath`     | Path to mount the volume at.                                                                            | `/bitnami/mastodon` |
| `persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                |
| `persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]` |
| `persistence.size`          | Size of data volume                                                                                     | `8Gi`               |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                |
| `persistence.selector`      | Selector to match an existing Persistent Volume for Mastodon data PVC                                   | `{}`                |
| `persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                |

### Init Container Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                      |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                       |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `nil`                      |
| `volumePermissions.containerSecurityContext.runAsUser`      | Set init container's Security Context runAsUser                                                                                                                                                                                                       | `0`                        |

### Other Parameters

| Name                                          | Description                                                             | Value         |
| --------------------------------------------- | ----------------------------------------------------------------------- | ------------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                    | `true`        |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                  | `""`          |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)        | `{}`          |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account          | `false`       |
| `externalDatabase.host`                       | Database host                                                           | `""`          |
| `externalDatabase.port`                       | Database port number                                                    | `5432`        |
| `externalDatabase.user`                       | Non-root username for Mastodon                                          | `postgres`    |
| `externalDatabase.password`                   | Password for the non-root username for Mastodon                         | `""`          |
| `externalDatabase.database`                   | Mastodon database name                                                  | `mastodon`    |
| `externalDatabase.existingSecret`             | Name of an existing secret resource containing the database credentials | `""`          |
| `externalDatabase.existingSecretPasswordKey`  | Name of an existing secret key containing the database credentials      | `db-password` |

### External Redis parameters

| Name                                      | Description                                                          | Value  |
| ----------------------------------------- | -------------------------------------------------------------------- | ------ |
| `externalRedis.host`                      | Redis host                                                           | `""`   |
| `externalRedis.port`                      | Redis port number                                                    | `6379` |
| `externalRedis.password`                  | Password for the Redis                                               | `""`   |
| `externalRedis.existingSecret`            | Name of an existing secret resource containing the Redis credentials | `""`   |
| `externalRedis.existingSecretPasswordKey` | Name of an existing secret key containing the Redis credentials      | `""`   |

### External S3 parameters

| Name                                      | Description                                                        | Value           |
| ----------------------------------------- | ------------------------------------------------------------------ | --------------- |
| `externalS3.host`                         | External S3 host                                                   | `""`            |
| `externalS3.port`                         | External S3 port number                                            | `443`           |
| `externalS3.accessKeyID`                  | External S3 access key ID                                          | `""`            |
| `externalS3.accessKeySecret`              | External S3 access key secret                                      | `""`            |
| `externalS3.existingSecret`               | Name of an existing secret resource containing the S3 credentials  | `""`            |
| `externalS3.existingSecretAccessKeyIDKey` | Name of an existing secret key containing the S3 access key ID     | `root-user`     |
| `externalS3.existingSecretKeySecretKey`   | Name of an existing secret key containing the S3 access key secret | `root-password` |
| `externalS3.protocol`                     | External S3 protocol                                               | `https`         |
| `externalS3.bucket`                       | External S3 bucket                                                 | `mastodon`      |
| `externalS3.region`                       | External S3 region                                                 | `us-east-1`     |

### External elasticsearch configuration

| Name                                              | Description                                                                  | Value                    |
| ------------------------------------------------- | ---------------------------------------------------------------------------- | ------------------------ |
| `externalElasticsearch.host`                      | Host of the external elasticsearch server                                    | `""`                     |
| `externalElasticsearch.port`                      | Port of the external elasticsearch server                                    | `""`                     |
| `externalElasticsearch.password`                  | Password for the external elasticsearch server                               | `""`                     |
| `externalElasticsearch.existingSecret`            | Name of an existing secret resource containing the elasticsearch credentials | `""`                     |
| `externalElasticsearch.existingSecretPasswordKey` | Name of an existing secret key containing the elasticsearch credentials      | `elasticsearch-password` |

### Redis sub-chart parameters

| Name                               | Description                                    | Value        |
| ---------------------------------- | ---------------------------------------------- | ------------ |
| `redis.enabled`                    | Deploy Redis subchart                          | `true`       |
| `redis.architecture`               | Set Redis architecture                         | `standalone` |
| `redis.existingSecret`             | Name of a secret containing redis credentials  | `""`         |
| `redis.master.service.ports.redis` | Redis port                                     | `6379`       |
| `redis.auth.enabled`               | Enable Redis auth                              | `true`       |
| `redis.auth.password`              | Redis password                                 | `""`         |
| `redis.auth.existingSecret`        | Name of a secret containing the Redis password | `""`         |

### PostgreSQL chart configuration

| Name                                          | Description                                               | Value              |
| --------------------------------------------- | --------------------------------------------------------- | ------------------ |
| `postgresql.enabled`                          | Switch to enable or disable the PostgreSQL helm chart     | `true`             |
| `postgresql.auth.username`                    | Name for a custom user to create                          | `bn_mastodon`      |
| `postgresql.auth.password`                    | Password for the custom user to create                    | `""`               |
| `postgresql.auth.database`                    | Name for a custom database to create                      | `bitnami_mastodon` |
| `postgresql.auth.existingSecret`              | Name of existing secret to use for PostgreSQL credentials | `""`               |
| `postgresql.architecture`                     | PostgreSQL architecture (`standalone` or `replication`)   | `standalone`       |
| `postgresql.primary.service.ports.postgresql` | PostgreSQL service port                                   | `5432`             |

### MinIO&reg; chart parameters

| Name                               | Description                                                                                                                       | Value                                                  |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `minio`                            | For full list of MinIO&reg; values configurations please refere [here](https://github.com/bitnami/charts/tree/main/bitnami/minio) |                                                        |
| `minio.enabled`                    | Enable/disable MinIO&reg; chart installation                                                                                      | `true`                                                 |
| `minio.auth.rootUser`              | MinIO&reg; root username                                                                                                          | `admin`                                                |
| `minio.auth.rootPassword`          | Password for MinIO&reg; root user                                                                                                 | `""`                                                   |
| `minio.auth.existingSecret`        | Name of an existing secret containing the MinIO&reg; credentials                                                                  | `""`                                                   |
| `minio.defaultBuckets`             | Comma, semi-colon or space separated list of MinIO&reg; buckets to create                                                         | `s3storage`                                            |
| `minio.provisioning.enabled`       | Enable/disable MinIO&reg; provisioning job                                                                                        | `true`                                                 |
| `minio.provisioning.extraCommands` | Extra commands to run on MinIO&reg; provisioning job                                                                              | `["mc anonymous set download provisioning/s3storage"]` |
| `minio.tls.enabled`                | Enable/disable MinIO&reg; TLS support                                                                                             | `false`                                                |
| `minio.service.type`               | MinIO&reg; service type                                                                                                           | `ClusterIP`                                            |
| `minio.service.loadBalancerIP`     | MinIO&reg; service LoadBalancer IP                                                                                                | `""`                                                   |
| `minio.service.ports.api`          | MinIO&reg; service port                                                                                                           | `80`                                                   |

### Elasticsearch chart configuration

| Name                                        | Description                                                                 | Value   |
| ------------------------------------------- | --------------------------------------------------------------------------- | ------- |
| `elasticsearch.enabled`                     | Whether to deploy a elasticsearch server to use as Mastodon's search engine | `true`  |
| `elasticsearch.sysctlImage.enabled`         | Enable kernel settings modifier image for Elasticsearch                     | `true`  |
| `elasticsearch.security.enabled`            | Enable security settings for Elasticsearch                                  | `false` |
| `elasticsearch.security.existingSecret`     | Name of an existing secret containing the elasticsearch credentials         | `""`    |
| `elasticsearch.security.tls.restEncryption` | Enable TLS encryption for REST API                                          | `false` |
| `elasticsearch.master.replicaCount`         | Desired number of Elasticsearch master-eligible nodes                       | `1`     |
| `elasticsearch.coordinating.replicaCount`   | Desired number of Elasticsearch coordinating-only nodes                     | `1`     |
| `elasticsearch.data.replicaCount`           | Desired number of Elasticsearch data nodes                                  | `1`     |
| `elasticsearch.ingest.replicaCount`         | Desired number of Elasticsearch ingest nodes                                | `1`     |
| `elasticsearch.service.ports.restAPI`       | Elasticsearch REST API port                                                 | `9200`  |

### Apache chart configuration

| Name                            | Description                                                     | Value                      |
| ------------------------------- | --------------------------------------------------------------- | -------------------------- |
| `apache.enabled`                | Enable Apache chart                                             | `true`                     |
| `apache.containerPorts.http`    | Apache container port                                           | `8080`                     |
| `apache.service.type`           | Apache service type                                             | `LoadBalancer`             |
| `apache.service.loadBalancerIP` | Apache service LoadBalancer IP                                  | `""`                       |
| `apache.service.ports.http`     | Apache service port                                             | `80`                       |
| `apache.vhostsConfigMap`        | Name of the ConfigMap containing the Apache vhost configuration | `""`                       |
| `apache.livenessProbe.path`     | Apache liveness probe path                                      | `/api/v1/streaming/health` |
| `apache.readinessProbe.path`    | Apache readiness probe path                                     | `/api/v1/streaming/health` |
| `apache.startupProbe.path`      | Apache startup probe path                                       | `/api/v1/streaming/health` |
| `apache.ingress.enabled`        | Enable ingress                                                  | `false`                    |
| `apache.ingress.hostname`       | Ingress hostname                                                | `mastodon.local`           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set adminUsername=admin \
  --set adminPassword=password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/mastodon
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the mastodon administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/mastodon
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/mastodon/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 6.0.0

This major updates the Elasticsearch subchart to its newest major, 21.0.0, which removes support for elasticsearch-curator. Check [Elasticsearch Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch#to-2100) for more information.

### To 5.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 4.0.0

This major updates the Apache subchart to its newest major, 10.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/apache#to-1000) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the PostgreSQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1300) you can find more information about the changes introduced in that version.

### 2.0.0

This major updates the Redis&reg; subchart to its newest major, 18.0.0. This subchart's major doesn't include any changes affecting its use as a subchart for Mastodon, so no major issues are expected during the upgrade.

NOTE: Due to an error in our release process, Redis&reg;' chart versions higher or equal than 17.15.4 already use Redis&reg; 7.2 by default.

### 1.0.0

This major updates the MinIO&reg; subchart to its newest major, 12.0.0. This subchart's major doesn't include any changes affecting its use as a subchart for Mastodon, so no major issues are expected during the upgrade.

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