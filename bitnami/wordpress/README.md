<!--- app-name: WordPress -->

# Bitnami package for WordPress

WordPress is the world's most popular blogging and content management platform. Powerful yet simple, everyone from students to global corporations use it to build beautiful, functional websites.

[Overview of WordPress](http://www.wordpress.org)

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/wordpress
```

Looking to use WordPress in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## ⚠️ Important Notice: Upcoming changes to the Bitnami Catalog

Beginning August 28th, 2025, Bitnami will evolve its public catalog to offer a curated set of hardened, security-focused images under the new [Bitnami Secure Images initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). As part of this transition:

- Granting community users access for the first time to security-optimized versions of popular container images.
- Bitnami will begin deprecating support for non-hardened, Debian-based software images in its free tier and will gradually remove non-latest tags from the public catalog. As a result, community users will have access to a reduced number of hardened images. These images are published only under the “latest” tag and are intended for development purposes
- Starting August 28th, over two weeks, all existing container images, including older or versioned tags (e.g., 2.50.0, 10.6), will be migrated from the public catalog (docker.io/bitnami) to the “Bitnami Legacy” repository (docker.io/bitnamilegacy), where they will no longer receive updates.
- For production workloads and long-term support, users are encouraged to adopt Bitnami Secure Images, which include hardened containers, smaller attack surfaces, CVE transparency (via VEX/KEV), SBOMs, and enterprise support.

These changes aim to improve the security posture of all Bitnami users by promoting best practices for software supply chain integrity and up-to-date deployments. For more details, visit the [Bitnami Secure Images announcement](https://github.com/bitnami/containers/issues/83267).

## Introduction

This chart bootstraps a [WordPress](https://github.com/bitnami/containers/tree/main/bitnami/wordpress) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the WordPress application, and the [Bitnami Memcached chart](https://github.com/bitnami/charts/tree/main/bitnami/memcached) that can be used to cache database queries.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/wordpress
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys WordPress on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### Update credentials

Bitnami charts configure credentials at first boot. Any further change in the secrets or credentials require manual intervention. Follow these instructions:

- Update the user password following [the upstream documentation](https://wordpress.org/documentation/)
- Update the password secret with the new values (replace the SECRET_NAME, PASSWORD and SMTP_PASSWORD placeholders)

```shell
kubectl create secret generic SECRET_NAME --from-literal=wordpress-password=PASSWORD --from-literal=smtp-password=SMTP_PASSWORD --dry-run -o yaml | kubectl apply -f -
```

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will deploy a sidecar container with [apache-exporter](https://github.com/Lusitaniae/apache_exporter) in all pods and a `metrics` service, which can be configured under the `metrics.service` section. This `metrics` service will have the necessary annotations to be automatically scraped by Prometheus.

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

### Known limitations

When performing admin operations that require activating the maintenance mode (such as updating a plugin or theme), it's activated in only one replica (see: [bug report](https://core.trac.wordpress.org/ticket/50797)). This implies that WP could be attending requests on other replicas while performing admin operations, with unpredictable consequences.

To avoid that, you can manually activate/deactivate the maintenance mode on every replica using the WP CLI. For instance, if you installed WP with three replicas, you can run the commands below to activate the maintenance mode in all of them (assuming that the release name is `wordpress`):

```console
kubectl exec $(kubectl get pods -l app.kubernetes.io/name=wordpress -o jsonpath='{.items[0].metadata.name}') -c wordpress -- wp maintenance-mode activate
kubectl exec $(kubectl get pods -l app.kubernetes.io/name=wordpress -o jsonpath='{.items[1].metadata.name}') -c wordpress -- wp maintenance-mode activate
kubectl exec $(kubectl get pods -l app.kubernetes.io/name=wordpress -o jsonpath='{.items[2].metadata.name}') -c wordpress -- wp maintenance-mode activate
```

### External database support

You may want to have WordPress connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

If the database already contains data from a previous WordPress installation, set the `wordpressSkipInstall` parameter to `true`. This parameter forces the container to skip the WordPress installation wizard. Otherwise, the container will assume it is a fresh installation and execute the installation wizard, potentially modifying or resetting the data in the existing database.

[Refer to the container documentation for more information](https://github.com/bitnami/containers/tree/main/bitnami/wordpress#connect-wordpress-container-to-an-existing-database).

### Memcached

This chart provides support for using Memcached to cache database queries and objects improving the website performance. To enable this feature, set `wordpressConfigureCache` and `memcached.enabled` parameters to `true`.

When this feature is enabled, a Memcached server will be deployed in your K8s cluster using the Bitnami Memcached chart and the [W3 Total Cache](https://wordpress.org/plugins/w3-total-cache/) plugin will be activated and configured to use the Memcached server for database caching.

It is also possible to use an external cache server rather than installing one inside your cluster. To achieve this, the chart allows you to specify credentials for an external cache server with the [`externalCache` parameter](#database-parameters). You should also disable the Memcached installation with the `memcached.enabled` option. Here is an example:

```console
wordpressConfigureCache=true
memcached.enabled=false
externalCache.host=myexternalcachehost
externalCache.port=11211
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.To enable Ingress integration, set `ingress.enabled` to `true`.

The most common scenario is to have one host name mapped to the deployment. In this case, the `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

However, it is also possible to have more than one host. To facilitate this, the `ingress.extraHosts` parameter (if available) can be set with the host names specified as an array. The `ingress.extraTLS` parameter (if available) can also be used to add the TLS configuration for extra hosts.

> NOTE: For each host specified in the `ingress.extraHosts` parameter, it is necessary to set a name, path, and any annotations that the Ingress controller should know about. Not all annotations are supported by all Ingress controllers, but [this annotation reference document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) lists the annotations supported by many popular Ingress controllers.

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

### `.htaccess` files

For performance and security reasons, it is a good practice to configure Apache with the `AllowOverride None` directive. Instead of using `.htaccess` files, Apache will load the same directives at boot time. These directives are located in `/opt/bitnami/wordpress/wordpress-htaccess.conf`.

By default, the container image includes all the default `.htaccess` files in WordPress (together with the default plugins). To enable this feature, install the chart with the value `allowOverrideNone=yes`.

However, some plugins may include `.htaccess` directives that will not be loaded when `AllowOverride` is set to `None`. To make them work, create a custom `wordpress-htaccess.conf` file with all the required directives. After creating it, create a Kubernetes ConfigMap with it (for example, named `custom-htaccess`) and install the chart with the correct parameters as shown below:

```text
    allowOverrideNone=true
    customHTAccessCM=custom-htaccess
```

Some plugins permit editing the `.htaccess` file and it may be necessary to persist it in order to keep those edits. To make these plugins work, set the `htaccessPersistenceEnabled` parameter as shown below:

```text
    allowOverrideNone=false
    htaccessPersistenceEnabled=true
```

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

## Persistence

The [Bitnami WordPress](https://github.com/bitnami/containers/tree/main/bitnami/wordpress) image stores the WordPress data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
wordpress:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as WordPress (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

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

This chart allows you to set your custom affinity using the `affinity` parameter. Learn more about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

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

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                                  | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`           | Labels to add to all deployed resources                                                      | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed resources                                                 | `{}`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `usePasswordFiles`       | Mount credentials as files instead of using environment variables                            | `true`          |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                         | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                            | `["infinity"]`  |

### WordPress Image parameters

| Name                | Description                                                                                               | Value                       |
| ------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------- |
| `image.registry`    | WordPress image registry                                                                                  | `REGISTRY_NAME`             |
| `image.repository`  | WordPress image repository                                                                                | `REPOSITORY_NAME/wordpress` |
| `image.digest`      | WordPress image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                        |
| `image.pullPolicy`  | WordPress image pull policy                                                                               | `IfNotPresent`              |
| `image.pullSecrets` | WordPress image pull secrets                                                                              | `[]`                        |
| `image.debug`       | Specify if debug values should be set                                                                     | `false`                     |

### WordPress Configuration parameters

| Name                                   | Description                                                                           | Value              |
| -------------------------------------- | ------------------------------------------------------------------------------------- | ------------------ |
| `wordpressUsername`                    | WordPress username                                                                    | `user`             |
| `wordpressPassword`                    | WordPress user password                                                               | `""`               |
| `existingSecret`                       | Name of existing secret containing WordPress credentials                              | `""`               |
| `wordpressEmail`                       | WordPress user email                                                                  | `user@example.com` |
| `wordpressFirstName`                   | WordPress user first name                                                             | `FirstName`        |
| `wordpressLastName`                    | WordPress user last name                                                              | `LastName`         |
| `wordpressBlogName`                    | Blog name                                                                             | `User's Blog!`     |
| `wordpressTablePrefix`                 | Prefix to use for WordPress database tables                                           | `wp_`              |
| `wordpressScheme`                      | Scheme to use to generate WordPress URLs                                              | `http`             |
| `wordpressSkipInstall`                 | Skip wizard installation                                                              | `false`            |
| `wordpressExtraConfigContent`          | Add extra content to the default wp-config.php file                                   | `""`               |
| `wordpressConfiguration`               | The content for your custom wp-config.php file (advanced feature)                     | `""`               |
| `existingWordPressConfigurationSecret` | The name of an existing secret with your custom wp-config.php file (advanced feature) | `""`               |
| `wordpressConfigureCache`              | Enable W3 Total Cache plugin and configure cache settings                             | `false`            |
| `wordpressPlugins`                     | Array of plugins to install and activate. Can be specified as `all` or `none`.        | `none`             |
| `apacheConfiguration`                  | The content for your custom httpd.conf file (advanced feature)                        | `""`               |
| `existingApacheConfigurationConfigMap` | The name of an existing secret with your custom httpd.conf file (advanced feature)    | `""`               |
| `customPostInitScripts`                | Custom post-init.d user scripts                                                       | `{}`               |
| `smtpHost`                             | SMTP server host                                                                      | `""`               |
| `smtpPort`                             | SMTP server port                                                                      | `""`               |
| `smtpUser`                             | SMTP username                                                                         | `""`               |
| `smtpPassword`                         | SMTP user password                                                                    | `""`               |
| `smtpProtocol`                         | SMTP protocol                                                                         | `""`               |
| `smtpFromEmail`                        | SMTP from email (default is `smtpUser`)                                               | `""`               |
| `smtpFromName`                         | SMTP from name  (default is `wordpressFirstName` and `wordpressLastName`)             | `""`               |
| `smtpExistingSecret`                   | The name of an existing secret with SMTP credentials                                  | `""`               |
| `allowEmptyPassword`                   | Allow the container to be started with blank passwords                                | `true`             |
| `allowOverrideNone`                    | Configure Apache to prohibit overriding directives with htaccess files                | `false`            |
| `overrideDatabaseSettings`             | Allow overriding the database settings persisted in wp-config.php                     | `false`            |
| `htaccessPersistenceEnabled`           | Persist custom changes on htaccess files                                              | `false`            |
| `customHTAccessCM`                     | The name of an existing ConfigMap with custom htaccess rules                          | `""`               |
| `command`                              | Override default container command (useful when using custom images)                  | `[]`               |
| `args`                                 | Override default container args (useful when using custom images)                     | `[]`               |
| `extraEnvVars`                         | Array with extra environment variables to add to the WordPress container              | `[]`               |
| `extraEnvVarsCM`                       | Name of existing ConfigMap containing extra env vars                                  | `""`               |
| `extraEnvVarsSecret`                   | Name of existing Secret containing extra env vars                                     | `""`               |

### WordPress Multisite Configuration parameters

| Name                            | Description                                                                                                                        | Value       |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `multisite.enable`              | Whether to enable WordPress Multisite configuration.                                                                               | `false`     |
| `multisite.host`                | WordPress Multisite hostname/address. This value is mandatory when enabling Multisite mode.                                        | `""`        |
| `multisite.networkType`         | WordPress Multisite network type to enable. Allowed values: `subfolder`, `subdirectory` or `subdomain`.                            | `subdomain` |
| `multisite.enableNipIoRedirect` | Whether to enable IP address redirection to nip.io wildcard DNS. Useful when running on an IP address with subdomain network type. | `false`     |

### WordPress deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `replicaCount`                                      | Number of WordPress replicas to deploy                                                                                                                                                                            | `1`              |
| `updateStrategy.type`                               | WordPress deployment strategy type                                                                                                                                                                                | `RollingUpdate`  |
| `schedulerName`                                     | Alternate scheduler                                                                                                                                                                                               | `""`             |
| `terminationGracePeriodSeconds`                     | In seconds, time given to the WordPress pod to terminate gracefully                                                                                                                                               | `""`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`             |
| `priorityClassName`                                 | Name of the existing priority class to be used by WordPress pods, priority class needs to be created beforehand                                                                                                   | `""`             |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`          |
| `hostAliases`                                       | WordPress pod host aliases                                                                                                                                                                                        | `[]`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for WordPress pods                                                                                                                                            | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for WordPress container(s)                                                                                                                               | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the WordPress pod                                                                                                                                                            | `[]`             |
| `initContainers`                                    | Add additional init containers to the WordPress pods                                                                                                                                                              | `[]`             |
| `podLabels`                                         | Extra labels for WordPress pods                                                                                                                                                                                   | `{}`             |
| `podAnnotations`                                    | Annotations for WordPress pods                                                                                                                                                                                    | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`             |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             |
| `containerPorts.http`                               | WordPress HTTP container port                                                                                                                                                                                     | `8080`           |
| `containerPorts.https`                              | WordPress HTTPS container port                                                                                                                                                                                    | `8443`           |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for WordPress container(s)                                                                                                                                      | `[]`             |
| `podSecurityContext.enabled`                        | Enabled WordPress pods' Security Context                                                                                                                                                                          | `true`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`             |
| `podSecurityContext.fsGroup`                        | Set WordPress pod's Security Context fsGroup                                                                                                                                                                      | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                              | `true`           |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`             |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`           |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                     | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                       | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                         | `false`          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault` |
| `livenessProbe.enabled`                             | Enable livenessProbe on WordPress containers                                                                                                                                                                      | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `120`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe on WordPress containers                                                                                                                                                                     | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe on WordPress containers                                                                                                                                                                       | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`             |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`             |
| `lifecycleHooks`                                    | for the WordPress container(s) to automate configuration before or after startup                                                                                                                                  | `{}`             |

### Traffic Exposure Parameters

| Name                                | Description                                                                                                                                              | Value                    |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                      | WordPress service type                                                                                                                                   | `LoadBalancer`           |
| `service.ports.http`                | WordPress service HTTP port                                                                                                                              | `80`                     |
| `service.ports.https`               | WordPress service HTTPS port                                                                                                                             | `443`                    |
| `service.httpsTargetPort`           | Target port for HTTPS                                                                                                                                    | `https`                  |
| `service.nodePorts.http`            | Node port for HTTP                                                                                                                                       | `""`                     |
| `service.nodePorts.https`           | Node port for HTTPS                                                                                                                                      | `""`                     |
| `service.sessionAffinity`           | Control where client requests go, to the same pod or round-robin                                                                                         | `None`                   |
| `service.sessionAffinityConfig`     | Additional settings for the sessionAffinity                                                                                                              | `{}`                     |
| `service.clusterIP`                 | WordPress service Cluster IP                                                                                                                             | `""`                     |
| `service.loadBalancerIP`            | WordPress service Load Balancer IP                                                                                                                       | `""`                     |
| `service.loadBalancerSourceRanges`  | WordPress service Load Balancer sources                                                                                                                  | `[]`                     |
| `service.externalTrafficPolicy`     | WordPress service external traffic policy                                                                                                                | `Cluster`                |
| `service.annotations`               | Additional custom annotations for WordPress service                                                                                                      | `{}`                     |
| `service.extraPorts`                | Extra port to expose on WordPress service                                                                                                                | `[]`                     |
| `ingress.enabled`                   | Enable ingress record generation for WordPress                                                                                                           | `false`                  |
| `ingress.pathType`                  | Ingress path type                                                                                                                                        | `ImplementationSpecific` |
| `ingress.apiVersion`                | Force Ingress API version (automatically detected if not set)                                                                                            | `""`                     |
| `ingress.ingressClassName`          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                            | `""`                     |
| `ingress.hostname`                  | Default host for the ingress record. The hostname is templated and thus can contain other variable references.                                           | `wordpress.local`        |
| `ingress.path`                      | Default path for the ingress record                                                                                                                      | `/`                      |
| `ingress.annotations`               | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                         | `{}`                     |
| `ingress.tls`                       | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                                            | `false`                  |
| `ingress.tlsWwwPrefix`              | Adds www subdomain to default cert                                                                                                                       | `false`                  |
| `ingress.selfSigned`                | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                             | `false`                  |
| `ingress.extraHosts`                | An array with additional hostname(s) to be covered with the ingress record. The host names are templated and thus can contain other variable references. | `[]`                     |
| `ingress.extraPaths`                | An array with additional arbitrary paths that may need to be added to the ingress under the main host                                                    | `[]`                     |
| `ingress.extraTls`                  | TLS configuration for additional hostname(s) to be covered with this ingress record                                                                      | `[]`                     |
| `ingress.secrets`                   | Custom TLS certificates as secrets                                                                                                                       | `[]`                     |
| `ingress.extraRules`                | Additional rules to be covered with this ingress record                                                                                                  | `[]`                     |
| `secondaryIngress.enabled`          | Enable ingress record generation for WordPress                                                                                                           | `false`                  |
| `secondaryIngress.pathType`         | Ingress path type                                                                                                                                        | `ImplementationSpecific` |
| `secondaryIngress.apiVersion`       | Force Ingress API version (automatically detected if not set)                                                                                            | `""`                     |
| `secondaryIngress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                            | `""`                     |
| `secondaryIngress.hostname`         | Default host for the ingress record. The hostname is templated and thus can contain other variable references.                                           | `wordpress.local`        |
| `secondaryIngress.path`             | Default path for the ingress record                                                                                                                      | `/`                      |
| `secondaryIngress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                         | `{}`                     |
| `secondaryIngress.tls`              | Enable TLS configuration for the host defined at `secondaryIngress.hostname` parameter                                                                   | `false`                  |
| `secondaryIngress.tlsWwwPrefix`     | Adds www subdomain to default cert                                                                                                                       | `false`                  |
| `secondaryIngress.selfSigned`       | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                             | `false`                  |
| `secondaryIngress.extraHosts`       | An array with additional hostname(s) to be covered with the ingress record. The host names are templated and thus can contain other variable references. | `[]`                     |
| `secondaryIngress.extraPaths`       | An array with additional arbitrary paths that may need to be added to the ingress under the main host                                                    | `[]`                     |
| `secondaryIngress.extraTls`         | TLS configuration for additional hostname(s) to be covered with this ingress record                                                                      | `[]`                     |
| `secondaryIngress.secrets`          | Custom TLS certificates as secrets                                                                                                                       | `[]`                     |
| `secondaryIngress.extraRules`       | Additional rules to be covered with this ingress record                                                                                                  | `[]`                     |

### Persistence Parameters

| Name                                                        | Description                                                                                                                                                                                                                                           | Value                      |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `persistence.enabled`                                       | Enable persistence using Persistent Volume Claims                                                                                                                                                                                                     | `true`                     |
| `persistence.storageClass`                                  | Persistent Volume storage class                                                                                                                                                                                                                       | `""`                       |
| `persistence.accessModes`                                   | Persistent Volume access modes                                                                                                                                                                                                                        | `[]`                       |
| `persistence.accessMode`                                    | Persistent Volume access mode (DEPRECATED: use `persistence.accessModes` instead)                                                                                                                                                                     | `ReadWriteOnce`            |
| `persistence.size`                                          | Persistent Volume size                                                                                                                                                                                                                                | `10Gi`                     |
| `persistence.dataSource`                                    | Custom PVC data source                                                                                                                                                                                                                                | `{}`                       |
| `persistence.existingClaim`                                 | The name of an existing PVC to use for persistence                                                                                                                                                                                                    | `""`                       |
| `persistence.selector`                                      | Selector to match an existing Persistent Volume for WordPress data PVC                                                                                                                                                                                | `{}`                       |
| `persistence.annotations`                                   | Persistent Volume Claim annotations                                                                                                                                                                                                                   | `{}`                       |
| `volumePermissions.enabled`                                 | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`                                                                                                                                                       | `false`                    |
| `volumePermissions.image.registry`                          | OS Shell + Utility image registry                                                                                                                                                                                                                     | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`                        | OS Shell + Utility image repository                                                                                                                                                                                                                   | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`                            | OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                    | `""`                       |
| `volumePermissions.image.pullPolicy`                        | OS Shell + Utility image pull policy                                                                                                                                                                                                                  | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`                       | OS Shell + Utility image pull secrets                                                                                                                                                                                                                 | `[]`                       |
| `volumePermissions.resourcesPreset`                         | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `nano`                     |
| `volumePermissions.resources`                               | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `volumePermissions.containerSecurityContext.seLinuxOptions` | Set SELinux options in container                                                                                                                                                                                                                      | `{}`                       |
| `volumePermissions.containerSecurityContext.runAsUser`      | User ID for the init container                                                                                                                                                                                                                        | `0`                        |

### Other Parameters

| Name                                          | Description                                                                                                                                    | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for WordPress pod                                                                                            | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                         | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                                         | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                                                           | `{}`    |
| `pdb.create`                                  | Enable a Pod Disruption Budget creation                                                                                                        | `true`  |
| `pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                 | `""`    |
| `pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty. | `""`    |
| `autoscaling.enabled`                         | Enable Horizontal POD autoscaling for WordPress                                                                                                | `false` |
| `autoscaling.minReplicas`                     | Minimum number of WordPress replicas                                                                                                           | `1`     |
| `autoscaling.maxReplicas`                     | Maximum number of WordPress replicas                                                                                                           | `11`    |
| `autoscaling.targetCPU`                       | Target CPU utilization percentage                                                                                                              | `50`    |
| `autoscaling.targetMemory`                    | Target Memory utilization percentage                                                                                                           | `50`    |

### Metrics Parameters

| Name                                                        | Description                                                                                                                                                                                                                       | Value                             |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `metrics.enabled`                                           | Start a sidecar prometheus exporter to expose metrics                                                                                                                                                                             | `false`                           |
| `metrics.image.registry`                                    | Apache exporter image registry                                                                                                                                                                                                    | `REGISTRY_NAME`                   |
| `metrics.image.repository`                                  | Apache exporter image repository                                                                                                                                                                                                  | `REPOSITORY_NAME/apache-exporter` |
| `metrics.image.digest`                                      | Apache exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                   | `""`                              |
| `metrics.image.pullPolicy`                                  | Apache exporter image pull policy                                                                                                                                                                                                 | `IfNotPresent`                    |
| `metrics.image.pullSecrets`                                 | Apache exporter image pull secrets                                                                                                                                                                                                | `[]`                              |
| `metrics.containerPorts.metrics`                            | Prometheus exporter container port                                                                                                                                                                                                | `9117`                            |
| `metrics.livenessProbe.enabled`                             | Enable livenessProbe on Prometheus exporter containers                                                                                                                                                                            | `true`                            |
| `metrics.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                           | `15`                              |
| `metrics.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                  | `10`                              |
| `metrics.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                 | `5`                               |
| `metrics.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                               | `3`                               |
| `metrics.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                               | `1`                               |
| `metrics.readinessProbe.enabled`                            | Enable readinessProbe on Prometheus exporter containers                                                                                                                                                                           | `true`                            |
| `metrics.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                          | `5`                               |
| `metrics.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                 | `10`                              |
| `metrics.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                | `3`                               |
| `metrics.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                              | `3`                               |
| `metrics.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                              | `1`                               |
| `metrics.startupProbe.enabled`                              | Enable startupProbe on Prometheus exporter containers                                                                                                                                                                             | `false`                           |
| `metrics.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                            | `10`                              |
| `metrics.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                   | `10`                              |
| `metrics.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                  | `1`                               |
| `metrics.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                | `15`                              |
| `metrics.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                | `1`                               |
| `metrics.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                               | `{}`                              |
| `metrics.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                              | `{}`                              |
| `metrics.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                | `{}`                              |
| `metrics.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production). | `nano`                            |
| `metrics.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                 | `{}`                              |
| `metrics.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                              | `true`                            |
| `metrics.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                  | `{}`                              |
| `metrics.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                        | `1001`                            |
| `metrics.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                       | `1001`                            |
| `metrics.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                     | `true`                            |
| `metrics.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                       | `false`                           |
| `metrics.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                           | `true`                            |
| `metrics.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                         | `false`                           |
| `metrics.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                | `["ALL"]`                         |
| `metrics.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                  | `RuntimeDefault`                  |
| `metrics.service.ports.metrics`                             | Prometheus metrics service port                                                                                                                                                                                                   | `9150`                            |
| `metrics.service.annotations`                               | Additional custom annotations for Metrics service                                                                                                                                                                                 | `{}`                              |
| `metrics.serviceMonitor.enabled`                            | Create ServiceMonitor Resource for scraping metrics using Prometheus Operator                                                                                                                                                     | `false`                           |
| `metrics.serviceMonitor.namespace`                          | Namespace for the ServiceMonitor Resource (defaults to the Release Namespace)                                                                                                                                                     | `""`                              |
| `metrics.serviceMonitor.interval`                           | Interval at which metrics should be scraped.                                                                                                                                                                                      | `""`                              |
| `metrics.serviceMonitor.scrapeTimeout`                      | Timeout after which the scrape is ended                                                                                                                                                                                           | `""`                              |
| `metrics.serviceMonitor.labels`                             | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                                                                                                                             | `{}`                              |
| `metrics.serviceMonitor.selector`                           | Prometheus instance selector labels                                                                                                                                                                                               | `{}`                              |
| `metrics.serviceMonitor.relabelings`                        | RelabelConfigs to apply to samples before scraping                                                                                                                                                                                | `[]`                              |
| `metrics.serviceMonitor.metricRelabelings`                  | MetricRelabelConfigs to apply to samples before ingestion                                                                                                                                                                         | `[]`                              |
| `metrics.serviceMonitor.honorLabels`                        | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                                          | `false`                           |
| `metrics.serviceMonitor.jobLabel`                           | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                                 | `""`                              |

### NetworkPolicy parameters

| Name                                    | Description                                                     | Value  |
| --------------------------------------- | --------------------------------------------------------------- | ------ |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created             | `true` |
| `networkPolicy.allowExternal`           | Don't require server label for connections                      | `true` |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations. | `true` |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                    | `[]`   |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces          | `{}`   |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces      | `{}`   |

### Database Parameters

| Name                                       | Description                                                                                                                                                                                                                | Value               |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements                                                                                                                                                  | `true`              |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`                                                                                                                                                        | `standalone`        |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                                                                                                                                                                      | `""`                |
| `mariadb.auth.database`                    | MariaDB custom database                                                                                                                                                                                                    | `bitnami_wordpress` |
| `mariadb.auth.username`                    | MariaDB custom user name                                                                                                                                                                                                   | `bn_wordpress`      |
| `mariadb.auth.password`                    | MariaDB custom user password                                                                                                                                                                                               | `""`                |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                                                                                                                                                                 | `true`              |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                                                                                                                                                                            | `""`                |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                                                                                                                                                                             | `[]`                |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                                                                                                                                                                     | `8Gi`               |
| `mariadb.primary.resourcesPreset`          | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). | `micro`             |
| `mariadb.primary.resources`                | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                |
| `externalDatabase.host`                    | External Database server host                                                                                                                                                                                              | `localhost`         |
| `externalDatabase.port`                    | External Database server port                                                                                                                                                                                              | `3306`              |
| `externalDatabase.user`                    | External Database username                                                                                                                                                                                                 | `bn_wordpress`      |
| `externalDatabase.password`                | External Database user password                                                                                                                                                                                            | `""`                |
| `externalDatabase.database`                | External Database database name                                                                                                                                                                                            | `bitnami_wordpress` |
| `externalDatabase.existingSecret`          | The name of an existing secret with database credentials. Evaluated as a template                                                                                                                                          | `""`                |
| `memcached.enabled`                        | Deploy a Memcached server for caching database queries                                                                                                                                                                     | `false`             |
| `memcached.auth.enabled`                   | Enable Memcached authentication                                                                                                                                                                                            | `false`             |
| `memcached.auth.username`                  | Memcached admin user                                                                                                                                                                                                       | `""`                |
| `memcached.auth.password`                  | Memcached admin password                                                                                                                                                                                                   | `""`                |
| `memcached.auth.existingPasswordSecret`    | Existing secret with Memcached credentials (must contain a value for `memcached-password` key)                                                                                                                             | `""`                |
| `memcached.service.port`                   | Memcached service port                                                                                                                                                                                                     | `11211`             |
| `memcached.resourcesPreset`                | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production).                 | `nano`              |
| `memcached.resources`                      | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                          | `{}`                |
| `externalCache.host`                       | External cache server host                                                                                                                                                                                                 | `localhost`         |
| `externalCache.port`                       | External cache server port                                                                                                                                                                                                 | `11211`             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set wordpressUsername=admin \
  --set wordpressPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    oci://REGISTRY_NAME/REPOSITORY_NAME/wordpress
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the WordPress administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/wordpress
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/wordpress/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Notable changes

### 13.2.0

Removed support for limiting auto-updates to WordPress core via the `wordpressAutoUpdateLevel` option. To update WordPress core, we recommend you use the `helm upgrade` command to update your deployment instead of using the built-in update functionality.

### 11.0.0

The [Bitnami WordPress](https://github.com/bitnami/containers/tree/main/bitnami/wordpress) image was refactored and now the source code is published in GitHub in the `rootfs` folder of the container image.

In addition, several new features have been implemented:

- Multisite mode is now supported via `multisite.*` options.
- Plugins can be installed and activated on the first deployment via the `wordpressPlugins` option.
- Added support for limiting auto-updates to WordPress core via the `wordpressAutoUpdateLevel` option. In addition, auto-updates have been disabled by default. To update WordPress core, we recommend to swap the container image version for your deployment instead of using the built-in update functionality.

To enable the new features, it is not possible to do it by upgrading an existing deployment. Instead, it is necessary to perform a fresh deploy.

## Upgrading

### To 25.0.0

This major release bumps the MariaDB version to 11.8. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-11-4-to-mariadb-11-8/) for upgrading from MariaDB 11.4 to 11.8. No major issues are expected during the upgrade.

### To 24.1.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 24.0.0

This major bump updates the MariaDB subchart to version 20.0.0. This subchart updates the StatefulSet objects `serviceName` to use a headless service, as the current non-headless service attached to it was not providing DNS entries. This will cause an upgrade issue because it changes "immutable fields". To workaround it, delete the StatefulSet objects as follows (replace the RELEASE_NAME placeholder):

```shell
kubectl delete sts RELEASE_NAME-mariadb --cascade=false
```

Then execute `helm upgrade` as usual.

### To 23.0.0

This major release bumps the MariaDB version to 11.4. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-11-3-to-mariadb-11-4/) for upgrading from MariaDB 11.3 to 11.4. No major issues are expected during the upgrade.

### To 22.0.0

This major release bumps the MariaDB chart version to [18.x.x](https://github.com/bitnami/charts/pull/24804); no major issues are expected during the upgrade.

### To 21.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. Compared to the previous approach, the values section has been simplified (check the Parameters section) and now it set to `enabled=true` by default. Egress traffic is allowed by default and ingress traffic is allowed by all pods but only to the ports set in `containerPorts` and `extraContainerPorts`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 20.0.0

This major release bumps the MariaDB chart version to [16.x.x](https://github.com/bitnami/charts/pull/23054); no major issues are expected during the upgrade.

### To 19.0.0

This major release bumps the MariaDB version to 11.2. No major issues are expected during the upgrade.

### To 18.0.0

This major release bumps the MariaDB version to 11.1. No major issues are expected during the upgrade.

### To 17.0.0

This major release bumps the MariaDB version to 11.0. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-11-to-mariadb-11-0/) for upgrading from MariaDB 10.11 to 11.0. No major issues are expected during the upgrade.

### To 16.0.0

This major release bumps the MariaDB version to 10.11. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-10-6-to-mariadb-10-11/) for upgrading from MariaDB 10.6 to 10.11. No major issues are expected during the upgrade.

### To 14.0.0

This major release bumps the MariaDB version to 10.6. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-105-to-mariadb-106/) for upgrading from MariaDB 10.5 to 10.6. No major issues are expected during the upgrade.

### To 13.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

- `service.port` and `service.httpsPort` have been regrouped under the `service.ports` map.
- `metrics.service.port` has been regrouped under the `metrics.service.ports` map.
- `serviceAccountName` has been deprecated in favor of `serviceAccount` map.

Additionally updates the MariaDB & Memcached subcharts to their newest major `10.x.x` and `6.x.x`, respectively, which contain similar changes.

### To 12.0.0

WordPress version was bumped to its latest major, `5.8.x`. Though no incompatibilities are expected while upgrading from previous versions, WordPress recommends backing up your application first.

Site backups can be easily performed using tools such as [VaultPress](https://vaultpress.com/) or [All-in-One WP Migration](https://wordpress.org/plugins/all-in-one-wp-migration/).

### To 11.0.0

The [Bitnami WordPress](https://github.com/bitnami/containers/tree/main/bitnami/wordpress) image was refactored and now the source code is published in GitHub in the `rootfs` folder of the container image.

Compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected.

### To 10.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### Additional upgrade notes

- MariaDB dependency version was bumped to a new major version that introduces several incompatibilities. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-800) for more information.
- If you want to upgrade to this version from a previous one installed with Helm v3, there are two alternatives:
  - Install a new WordPress chart, and migrate your WordPress site using backup/restore tools such as [VaultPress](https://vaultpress.com/) or [All-in-One WP Migration](https://wordpress.org/plugins/all-in-one-wp-migration/).
  - Reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `wordpress`).

> Warning: please create a backup of your database before running any of these actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
export WORDPRESS_PASSWORD=$(kubectl get secret --namespace default wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default wordpress-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default wordpress-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=wordpress,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling WordPress replicas to 0:

```console
helm upgrade wordpress oci://REGISTRY_NAME/REPOSITORY_NAME/wordpress --set wordpressPassword=$WORDPRESS_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 9.6.4
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Finally, upgrade you release to `10.0.0` reusing the existing PVC, and enabling back MariaDB:

```console
helm upgrade wordpress oci://REGISTRY_NAME/REPOSITORY_NAME/wordpress --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set wordpressPassword=$WORDPRESS_PASSWORD
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=wordpress,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 9.0.0

The [Bitnami WordPress](https://github.com/bitnami/containers/tree/main/bitnami/wordpress) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `securityContext.runAsUser`, and `securityContext.fsGroup` to `0`.
Chart labels and Ingress configuration were also adapted to follow the Helm charts best practices.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- No writing permissions will be granted on `wp-config.php` by default.
- Backwards compatibility is not guaranteed.

To upgrade to `9.0.0`, it's recommended to install a new WordPress chart, and migrate your WordPress site using backup/restore tools such as [VaultPress](https://vaultpress.com/) or [All-in-One WP Migration](https://wordpress.org/plugins/all-in-one-wp-migration/).

### To 8.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In <https://github.com/helm/charts/pulls/12642> the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the API's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to `3.0.0`. The following example assumes that the release name is `wordpress`:

```console
kubectl patch deployment wordpress-wordpress --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset wordpress-mariadb --cascade=false
```

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