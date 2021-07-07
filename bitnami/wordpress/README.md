# WordPress

[WordPress](https://wordpress.org/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wordpress
```

## Introduction

This chart bootstraps a [WordPress](https://github.com/bitnami/bitnami-docker-wordpress) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the WordPress application, and the [Bitnami Memcached chart](https://github.com/bitnami/charts/tree/master/bitnami/memcached) that can be used to cache database queries.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, Fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/wordpress
```

The command deploys WordPress on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |

### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `nil`           |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |

### WordPress Image parameters

| Name                | Description                                          | Value                 |
| ------------------- | ---------------------------------------------------- | --------------------- |
| `image.registry`    | WordPress image registry                             | `docker.io`           |
| `image.repository`  | WordPress image repository                           | `bitnami/wordpress`   |
| `image.tag`         | WordPress image tag (immutable tags are recommended) | `5.7.1-debian-10-r11` |
| `image.pullPolicy`  | WordPress image pull policy                          | `IfNotPresent`        |
| `image.pullSecrets` | WordPress image pull secrets                         | `[]`                  |
| `image.debug`       | Enable image debug mode                              | `false`               |

### WordPress Configuration parameters

| Name                                   | Description                                                                               | Value              |
| -------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------ |
| `wordpressUsername`                    | WordPress username                                                                        | `user`             |
| `wordpressPassword`                    | WordPress user password                                                                   | `""`               |
| `existingSecret`                       | Name of existing secret containing WordPress credentials                                  | `nil`              |
| `wordpressEmail`                       | WordPress user email                                                                      | `user@example.com` |
| `wordpressFirstName`                   | WordPress user first name                                                                 | `FirstName`        |
| `wordpressLastName`                    | WordPress user last name                                                                  | `LastName`         |
| `wordpressBlogName`                    | Blog name                                                                                 | `User's Blog!`     |
| `wordpressTablePrefix`                 | Prefix to use for WordPress database tables                                               | `wp_`              |
| `wordpressScheme`                      | Scheme to use to generate WordPress URLs                                                  | `http`             |
| `wordpressSkipInstall`                 | Skip wizard installation                                                                  | `false`            |
| `wordpressExtraConfigContent`          | Add extra content to the default wp-config.php file                                       | `nil`              |
| `wordpressConfiguration`               | The content for your custom wp-config.php file (experimental feature)                     | `nil`              |
| `existingWordPressConfigurationSecret` | The name of an existing secret with your custom wp-config.php file (experimental feature) | `nil`              |
| `wordpressConfigureCache`              | Enable W3 Total Cache plugin and configure cache settings                                 | `false`            |
| `wordpressAutoUpdateLevel`             | Level of auto-updates to allow. Allowed values: `major`, `minor` or `none`.               | `none`             |
| `wordpressPlugins`                     | Array of plugins to install and activate. Can be specified as `all` or `none`.            | `none`             |
| `apacheConfiguration`                  | The content for your custom httpd.conf file (advanced feature)                            | `nil`              |
| `existingApacheConfigurationConfigMap` | The name of an existing secret with your custom wp-config.php file (advanced feature)     | `nil`              |
| `customPostInitScripts`                | Custom post-init.d user scripts                                                           | `{}`               |
| `smtpHost`                             | SMTP server host                                                                          | `""`               |
| `smtpPort`                             | SMTP server port                                                                          | `""`               |
| `smtpUser`                             | SMTP username                                                                             | `""`               |
| `smtpPassword`                         | SMTP user password                                                                        | `""`               |
| `smtpProtocol`                         | SMTP protocol                                                                             | `""`               |
| `smtpExistingSecret`                   | The name of an existing secret with SMTP credentials                                      | `nil`              |
| `allowEmptyPassword`                   | Allow the container to be started with blank passwords                                    | `true`             |
| `allowOverrideNone`                    | Configure Apache to prohibit overriding directives with htaccess files                    | `false`            |
| `htaccessPersistenceEnabled`           | Persist custom changes on htaccess files                                                  | `false`            |
| `customHTAccessCM`                     | The name of an existing ConfigMap with custom htaccess rules                              | `nil`              |
| `command`                              | Override default container command (useful when using custom images)                      | `[]`               |
| `args`                                 | Override default container args (useful when using custom images)                         | `[]`               |
| `extraEnvVars`                         | Array with extra environment variables to add to the WordPress container                  | `[]`               |
| `extraEnvVarsCM`                       | Name of existing ConfigMap containing extra env vars                                      | `nil`              |
| `extraEnvVarsSecret`                   | Name of existing Secret containing extra env vars                                         | `nil`              |

### WordPress Multisite Configuration parameters

| Name                            | Description                                                                                                                        | Value              |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| `multisite.enable`              | Whether to enable WordPress Multisite configuration.                                                                               | `false`            |
| `multisite.host`                | WordPress Multisite hostname/address. This value is mandatory when enabling Multisite mode.                                        | `""`               |
| `multisite.networkType`         | WordPress Multisite network type to enable. Allowed values: `subfolder`, `subdirectory` or `subdomain`.                            | `subdomain`        |
| `multisite.enableNipIoRedirect` | Whether to enable IP address redirection to nip.io wildcard DNS. Useful when running on an IP address with subdomain network type. | `false`            |

### WordPress deployment parameters

| Name                                    | Description                                                                               | Value           |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                          | Number of WordPress replicas to deploy                                                    | `1`             |
| `updateStrategy.type`                   | WordPress deployment strategy type                                                        | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | WordPress deployment rolling update configuration parameters                              | `{}`            |
| `schedulerName`                         | Alternate scheduler                                                                       | `nil`           |
| `serviceAccountName`                    | ServiceAccount name                                                                       | `default`       |
| `hostAliases`                           | WordPress pod host aliases                                                                | `[]`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for WordPress pods                    | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for WordPress container(s)       | `[]`            |
| `sidecars`                              | Add additional sidecar containers to the WordPress pod                                    | `{}`            |
| `initContainers`                        | Add additional init containers to the WordPress pods                                      | `{}`            |
| `podLabels`                             | Extra labels for WordPress pods                                                           | `{}`            |
| `podAnnotations`                        | Annotations for WordPress pods                                                            | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                           | Tolerations for pod assignment                                                            | `[]`            |
| `resources.limits`                      | The resources limits for the WordPress container                                          | `{}`            |
| `resources.requests`                    | The requested resources for the WordPress container                                       | `{}`            |
| `containerPorts.http`                   | WordPress HTTP container port                                                             | `8080`          |
| `containerPorts.https`                  | WordPress HTTPS container port                                                            | `8443`          |
| `podSecurityContext.enabled`            | Enabled WordPress pods' Security Context                                                  | `true`          |
| `podSecurityContext.fsGroup`            | Set WordPress pod's Security Context fsGroup                                              | `1001`          |
| `containerSecurityContext.enabled`      | Enabled WordPress containers' Security Context                                            | `true`          |
| `containerSecurityContext.runAsUser`    | Set WordPress container's Security Context runAsUser                                      | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set WordPress container's Security Context runAsNonRoot                                   | `true`          |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `120`           |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`            |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `30`            |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`            |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `5`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `6`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`             |
| `customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                       | `{}`            |
| `customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                      | `{}`            |

### Traffic Exposure Parameters

| Name                               | Description                                                                                           | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | WordPress service type                                                                                | `LoadBalancer`           |
| `service.port`                     | WordPress service HTTP port                                                                           | `80`                     |
| `service.httpsPort`                | WordPress service HTTPS port                                                                          | `443`                    |
| `service.httpsTargetPort`          | Target port for HTTPS                                                                                 | `https`                  |
| `service.nodePorts.http`           | Node port for HTTP                                                                                    | `nil`                    |
| `service.nodePorts.https`          | Node port for HTTPS                                                                                   | `nil`                    |
| `service.clusterIP`                | WordPress service Cluster IP                                                                          | `nil`                    |
| `service.loadBalancerIP`           | WordPress service Load Balancer IP                                                                    | `nil`                    |
| `service.loadBalancerSourceRanges` | WordPress service Load Balancer sources                                                               | `[]`                     |
| `service.externalTrafficPolicy`    | WordPress service external traffic policy                                                             | `Cluster`                |
| `service.annotations`              | Additional custom annotations for WordPress service                                                   | `{}`                     |
| `service.extraPorts`               | Extra port to expose on WordPress service                                                             | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for WordPress                                                        | `false`                  |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                                        | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                         | `nil`                    |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                         | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                   | `wordpress.local`        |
| `ingress.path`                     | Default path for the ingress record                                                                   | `/`                      |
| `ingress.annotations`              | Additional custom annotations for the ingress record                                                  | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                    | `[]`                     |

### Persistence Parameters

| Name                                          | Description                                                                                     | Value                   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `persistence.enabled`                         | Enable persistence using Persistent Volume Claims                                               | `true`                  |
| `persistence.storageClass`                    | Persistent Volume storage class                                                                 | `nil`                   |
| `persistence.accessModes`                     | Persistent Volume access modes                                                                  | `[ReadWriteOnce]`       |
| `persistence.accessMode`                      | Persistent Volume access mode (DEPRECATED: use `persistence.accessModes` instead)               | `ReadWriteOnce`         |
| `persistence.size`                            | Persistent Volume size                                                                          | `10Gi`                  |
| `persistence.dataSource`                      | Custom PVC data source                                                                          | `{}`                    |
| `persistence.existingClaim`                   | The name of an existing PVC to use for persistence                                              | `nil`                   |
| `volumePermissions.enabled`                   | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`            | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`          | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                 | Bitnami Shell image tag (immutable tags are recommended)                                        | `10`                    |
| `volumePermissions.image.pullPolicy`          | Bitnami Shell image pull policy                                                                 | `Always`                |
| `volumePermissions.image.pullSecrets`         | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`          | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`        | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.securityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |

### Other Parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable a Pod Disruption Budget creation                        | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `nil`   |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for WordPress                | `false` |
| `autoscaling.minReplicas`  | Minimum number of WordPress replicas                           | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of WordPress replicas                           | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `50`    |

### Metrics Parameters

| Name                                      | Description                                                                  | Value                     |
| ----------------------------------------- | ---------------------------------------------------------------------------- | ------------------------- |
| `metrics.enabled`                         | Start a sidecar prometheus exporter to expose metrics                        | `false`                   |
| `metrics.image.registry`                  | Apache Exporter image registry                                               | `docker.io`               |
| `metrics.image.repository`                | Apache Exporter image repository                                             | `bitnami/apache-exporter` |
| `metrics.image.tag`                       | Apache Exporter image tag (immutable tags are recommended)                   | `0.8.0-debian-10-r364`    |
| `metrics.image.pullPolicy`                | Apache Exporter image pull policy                                            | `IfNotPresent`            |
| `metrics.image.pullSecrets`               | Apache Exporter image pull secrets                                           | `[]`                      |
| `metrics.resources.limits`                | The resources limits for the Prometheus exporter container                   | `{}`                      |
| `metrics.resources.requests`              | The requested resources for the Prometheus exporter container                | `{}`                      |
| `metrics.service.port`                    | Metrics service port                                                         | `9117`                    |
| `metrics.service.annotations`             | Additional custom annotations for Metrics service                            | `{}`                      |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator | `false`                   |
| `metrics.serviceMonitor.namespace`        | The namespace in which the ServiceMonitor will be created                    | `nil`                     |
| `metrics.serviceMonitor.interval`         | The interval at which metrics should be scraped                              | `30s`                     |
| `metrics.serviceMonitor.scrapeTimeout`    | The timeout after which the scrape is ended                                  | `nil`                     |
| `metrics.serviceMonitor.relabellings`     | Metrics relabellings to add to the scrape endpoint                           | `nil`                     |
| `metrics.serviceMonitor.honorLabels`      | Labels to honor to add to the scrape endpoint                                | `false`                   |
| `metrics.serviceMonitor.additionalLabels` | Additional custom labels for the ServiceMonitor                              | `{}`                      |


### Database Parameters

| Name                                       | Description                                                               | Value               |
| ------------------------------------------ | ------------------------------------------------------------------------- | ------------------- |
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements | `true`              |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`       | `standalone`        |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                     | `""`                |
| `mariadb.auth.database`                    | MariaDB custom database                                                   | `bitnami_wordpress` |
| `mariadb.auth.username`                    | MariaDB custom user name                                                  | `bn_wordpress`      |
| `mariadb.auth.password`                    | MariaDB custom user password                                              | `""`                |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                | `true`              |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                           | `nil`               |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                            | `[ReadWriteOnce]`   |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                    | `8Gi`               |
| `externalDatabase.host`                    | External Database server host                                             | `localhost`         |
| `externalDatabase.port`                    | External Database server port                                             | `3306`              |
| `externalDatabase.user`                    | External Database username                                                | `bn_wordpress`      |
| `externalDatabase.password`                | External Database user password                                           | `""`                |
| `externalDatabase.database`                | External Database database name                                           | `bitnami_wordpress` |
| `externalDatabase.existingSecret`          | The name of an existing secret with database credentials                  | `nil`               |
| `memcached.enabled`                        | Deploy a Memcached server for caching database queries                    | `false`             |
| `memcached.service.port`                   | Memcached service port                                                    | `11211`             |
| `externalCache.host`                       | External cache server host                                                | `localhost`         |
| `externalCache.port`                       | External cache server port                                                | `11211`             |

The above parameters map to the env variables defined in [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress). For more information please refer to the [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set wordpressUsername=admin \
  --set wordpressPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    bitnami/wordpress
```

The above command sets the WordPress administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/wordpress
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

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

Refer to the [documentation on using an external database with WordPress](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/use-external-database/) and the [tutorial on integrating WordPress with a managed cloud database](https://docs.bitnami.com/tutorials/secure-wordpress-kubernetes-managed-database-ssl-upgrades/) for more information.

### Memcached

This chart provides support for using Memcached to cache database queries and objects improving the website performance. To enable this feature, set `wordpressConfigureCache` and `memcached.enabled` parameters to `true`.

When this features is enabled, a Memcached server will be deployed in your K8s cluster using the Bitnami Memcached chart and the [W3 Total Cache](https://wordpress.org/plugins/w3-total-cache/) plugin will be activated and configured to use the Memcached server for database caching.

It is also possible to use an external cache server rather than installing one inside your cluster. To achieve this, the chart allows you to specify credentials for an external cache server with the [`externalCache` parameter](#database-parameters). You should also disable the Memcached installation with the `memcached.enabled` option. Here is an example:

```console
wordpressConfigureCache=true
memcached.enabled=false
externalCache.host=myexternalcachehost
externalCache.port=11211
```

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve WordPress.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/configure-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/wordpress/administration/enable-tls/).

### `.htaccess` files

For performance and security reasons, it is a good practice to configure Apache with the `AllowOverride None` directive. Instead of using `.htaccess` files, Apache will load the same directives at boot time. These directives are located in `/opt/bitnami/wordpress/wordpress-htaccess.conf`.

By default, the container image includes all the default `.htaccess` files in WordPress (together with the default plugins). To enable this feature, install the chart with the value `allowOverrideNone=yes`.

[Learn more about working with `.htaccess` files](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/understand-htaccess/).

## Persistence

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image stores the WordPress data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments.

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

If additional containers are needed in the same pod as WordPress (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/configure-sidecar-init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Notable changes

### 11.0.0

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image was refactored and now the source code is published in GitHub in the [`rootfs`](https://github.com/bitnami/bitnami-docker-wordpress/tree/master/5/debian-10/rootfs) folder of the container image.

In addition, several new features have been implemented:

- Multisite mode is now supported via `multisite.*` options.
- Plugins can be installed and activated on the first deployment via the `wordpressPlugins` option.
- Added support for limiting auto-updates to WordPress core via the `wordpressAutoUpdateLevel` option. In addition, auto-updates have been disabled by default. To update WordPress core, we recommend to swap the container image version for your deployment instead of using the built-in update functionality.

To enable the new features, it is not possible to do it by upgrading an existing deployment. Instead, it is necessary to perform a fresh deploy.

## Upgrading

### To 11.0.0

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image was refactored and now the source code is published in GitHub in the [`rootfs`](https://github.com/bitnami/bitnami-docker-wordpress/tree/master/5/debian-10/rootfs) folder of the container image.

Compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected.

### To 10.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/wordpress/administration/upgrade-helm3/).

#### Additional upgrade notes

- MariaDB dependency version was bumped to a new major version that introduces several incompatibilities. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.
- If you want to upgrade to this version from a previous one installed with Helm v3, there are two alternatives:
  - Install a new WordPress chart, and migrate your WordPress site using backup/restore tools such as [VaultPress](https://vaultpress.com/) or [All-in-One WP Migration](https://wordpress.org/plugins/all-in-one-wp-migration/).
  - Reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `wordpress`).

> Warning: please create a backup of your database before running any of these actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
$ export WORDPRESS_PASSWORD=$(kubectl get secret --namespace default wordpress -o jsonpath="{.data.wordpress-password}" | base64 --decode)
$ export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default wordpress-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
$ export MARIADB_PASSWORD=$(kubectl get secret --namespace default wordpress-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
$ export MARIADB_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=wordpress,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling WordPress replicas to 0:

```console
$ helm upgrade wordpress bitnami/wordpress --set wordpressPassword=$WORDPRESS_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 9.6.4
```

Finally, upgrade you release to `10.0.0` reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade wordpress bitnami/wordpress --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set wordpressPassword=$WORDPRESS_PASSWORD
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=wordpress,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 9.0.0

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `securityContext.runAsUser`, and `securityContext.fsGroup` to `0`.
Chart labels and Ingress configuration were also adapted to follow the Helm charts best practices.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- No writing permissions will be granted on `wp-config.php` by default.
- Backwards compatibility is not guaranteed.

To upgrade to `9.0.0`, it's recommended to install a new WordPress chart, and migrate your WordPress site using backup/restore tools such as [VaultPress](https://vaultpress.com/) or [All-in-One WP Migration](https://wordpress.org/plugins/all-in-one-wp-migration/).

### To 8.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pulls/12642 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the API's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to `3.0.0`. The following example assumes that the release name is `wordpress`:

```console
kubectl patch deployment wordpress-wordpress --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset wordpress-mariadb --cascade=false
```
