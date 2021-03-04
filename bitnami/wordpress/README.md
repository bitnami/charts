# WordPress

[WordPress](https://wordpress.org/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wordpress
```

## Introduction

This chart bootstraps a [WordPress](https://github.com/bitnami/bitnami-docker-wordpress) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the WordPress application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

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

The following table lists the configurable parameters of the WordPress chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                          | Default                        |
|---------------------|----------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname                   | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname                       | `nil`                          |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`                           |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `nil`                          |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |

### WordPress parameters

| Parameter                     | Description                                                                                                                                                                                                                      | Default                                                 |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`              | WordPress image registry                                                                                                                                                                                                         | `docker.io`                                             |
| `image.repository`            | WordPress image name                                                                                                                                                                                                             | `bitnami/wordpress`                                     |
| `image.tag`                   | WordPress image tag                                                                                                                                                                                                              | `{TAG_NAME}`                                            |
| `image.pullPolicy`            | WordPress image pull policy                                                                                                                                                                                                      | `IfNotPresent`                                          |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                                                                                                                                                                                 | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                 | Specify if debug logs should be enabled                                                                                                                                                                                          | `false`                                                 |
| `hostAliases`                 | Add deployment host aliases                                                                                                                                                                                                      | `Check values.yaml`                                     |
| `wordpressSkipInstall`        | Skip wizard installation when the external db already contains data from a previous WordPress installation [see](https://github.com/bitnami/bitnami-docker-wordpress#connect-wordpress-docker-container-to-an-existing-database) | `false`                                                 |
| `wordpressUsername`           | User of the application                                                                                                                                                                                                          | `user`                                                  |
| `existingSecret`              | Name of the existing Wordpress Secret (it must contain a key named `wordpress-password`). When it's set, `wordpressPassword` is ignored                                                                                          | `nil`                                                   |
| `serviceAccountName`          | Name of a service account for the WordPress pods                                                                                                                                                                                 | `default`                                               |
| `wordpressPassword`           | Application password                                                                                                                                                                                                             | _random 10 character long alphanumeric string_          |
| `wordpressEmail`              | Admin email                                                                                                                                                                                                                      | `user@example.com`                                      |
| `wordpressFirstName`          | First name                                                                                                                                                                                                                       | `FirstName`                                             |
| `wordpressLastName`           | Last name                                                                                                                                                                                                                        | `LastName`                                              |
| `wordpressBlogName`           | Blog name                                                                                                                                                                                                                        | `User's Blog!`                                          |
| `wordpressTablePrefix`        | Table prefix                                                                                                                                                                                                                     | `wp_`                                                   |
| `wordpressScheme`             | Scheme to generate application URLs [`http`, `https`]                                                                                                                                                                            | `http`                                                  |
| `wordpressExtraConfigContent` | Add extra content to the configuration file                                                                                                                                                                                      | `""`                                                    |
| `allowEmptyPassword`          | Allow DB blank passwords                                                                                                                                                                                                         | `true`                                                  |
| `allowOverrideNone`           | Set Apache AllowOverride directive to None                                                                                                                                                                                       | `false`                                                 |
| `htaccessPersistenceEnabled`  | Make `.htaccess` persistence so that it can be customized. [See](#disabling-htaccess)                                                                                                                                            | `false`                                                 |
| `customHTAccessCM`            | Configmap with custom wordpress-htaccess.conf directives                                                                                                                                                                         | `nil`                                                   |
| `customPostInitScripts`       | Custom post-init.d user scripts                                                                                                                                                                                                  | `nil`                                                   |
| `smtpHost`                    | SMTP host                                                                                                                                                                                                                        | `nil`                                                   |
| `smtpPort`                    | SMTP port                                                                                                                                                                                                                        | `nil`                                                   |
| `smtpUser`                    | SMTP user                                                                                                                                                                                                                        | `nil`                                                   |
| `smtpPassword`                | SMTP password                                                                                                                                                                                                                    | `nil`                                                   |
| `smtpUsername`                | User name for SMTP emails                                                                                                                                                                                                        | `nil`                                                   |
| `smtpProtocol`                | SMTP protocol [`tls`, `ssl`, `none`]                                                                                                                                                                                             | `nil`                                                   |
| `smtpExistingPassword`        | Existing secret containing SMTP password in key `smtp-password`                                                                                                                                                                  | `nil`                                                   |
| `command`                     | Override default container command (useful when using custom images)                                                                                                                                                             | `nil`                                                   |
| `args`                        | Override default container args (useful when using custom images)                                                                                                                                                                | `nil`                                                   |
| `extraEnvVars`                | Extra environment variables to be set on WordPress container                                                                                                                                                                     | `{}`                                                    |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                                                                                                                                                                             | `nil`                                                   |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                                                                                                                                                                                | `nil`                                                   |

### WordPress deployment parameters

| Parameter                   | Description                                                                               | Default                              |
|-----------------------------|-------------------------------------------------------------------------------------------|--------------------------------------|
| `replicaCount`              | Number of WordPress Pods to run                                                           | `1`                                  |
| `containerPorts.http`       | HTTP port to expose at container level                                                    | `8080`                               |
| `containerPorts.https`      | HTTPS port to expose at container level                                                   | `8443`                               |
| `podSecurityContext`        | WordPress pods' Security Context                                                          | Check `values.yaml` file             |
| `containerSecurityContext`  | WordPress containers' Security Context                                                    | Check `values.yaml` file             |
| `resources.limits`          | The resources limits for the WordPress container                                          | `{}`                                 |
| `resources.requests`        | The requested resources for the WordPress container                                       | `{"memory": "512Mi", "cpu": "300m"}` |
| `livenessProbe`             | Liveness probe configuration for WordPress                                                | Check `values.yaml` file             |
| `readinessProbe`            | Readiness probe configuration for WordPress                                               | Check `values.yaml` file             |
| `customLivenessProbe`       | Override default liveness probe                                                           | `nil`                                |
| `customReadinessProbe`      | Override default readiness probe                                                          | `nil`                                |
| `updateStrategy`            | Set up update strategy                                                                    | `RollingUpdate`                      |
| `schedulerName`             | Name of the alternate scheduler                                                           | `nil`                                |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                               |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                 |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                 |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                 |
| `affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template)       |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template)       |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)       |
| `podLabels`                 | Extra labels for WordPress pods                                                           | `{}`                                 |
| `podAnnotations`            | Annotations for WordPress pods                                                            | `{}`                                 |
| `extraVolumeMounts`         | Additional volume mounts                                                                  | `[]`                                 |
| `extraVolumes`              | Additional volumes                                                                        | `[]`                                 |
| `initContainers`            | Add additional init containers to the WordPress pods                                      | `{}` (evaluated as a template)       |
| `sidecars`                  | Attach additional sidecar containers to the pod                                           | `{}` (evaluated as a template)       |

### Exposure parameters

| Parameter                          | Description                                                                   | Default                        |
|------------------------------------|-------------------------------------------------------------------------------|--------------------------------|
| `service.type`                     | Kubernetes Service type                                                       | `LoadBalancer`                 |
| `service.port`                     | Service HTTP port                                                             | `80`                           |
| `service.httpsPort`                | Service HTTPS port                                                            | `443`                          |
| `service.httpsTargetPort`          | Service Target HTTPS port                                                     | `https`                        |
| `service.nodePorts.http`           | Kubernetes http node port                                                     | `""`                           |
| `service.nodePorts.https`          | Kubernetes https node port                                                    | `""`                           |
| `service.extraPorts`               | Extra ports to expose in the service (normally used with the `sidecar` value) | `nil`                          |
| `service.clusterIP`                | WordPress service clusterIP IP                                                | `None`                         |
| `service.loadBalancerSourceRanges` | Restricts access for LoadBalancer (only with `service.type: LoadBalancer`)    | `[]`                           |
| `service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                              | `nil`                          |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                          | `Cluster`                      |
| `service.annotations`              | Service annotations                                                           | `{}` (evaluated as a template) |
| `ingress.enabled`                  | Enable ingress controller resource                                            | `false`                        |
| `ingress.certManager`              | Add annotations for cert-manager                                              | `false`                        |
| `ingress.hostname`                 | Default host for the ingress resource                                         | `wordpress.local`              |
| `ingress.path`                     | Default path for the ingress resource                                         | `/`                            |
| `ingress.tls`                      | Create TLS Secret                                                             | `false`                        |
| `ingress.annotations`              | Ingress annotations                                                           | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`       | Additional hostnames to be covered                                            | `nil`                          |
| `ingress.extraHosts[0].path`       | Additional hostnames to be covered                                            | `nil`                          |
| `ingress.extraPaths`               | Additional arbitrary path/backend objects                                     | `nil`                          |
| `ingress.extraTls[0].hosts[0]`     | TLS configuration for additional hostnames to be covered                      | `nil`                          |
| `ingress.extraTls[0].secretName`   | TLS configuration for additional hostnames to be covered                      | `nil`                          |
| `ingress.secrets[0].name`          | TLS Secret Name                                                               | `nil`                          |
| `ingress.secrets[0].certificate`   | TLS Secret Certificate                                                        | `nil`                          |
| `ingress.secrets[0].key`           | TLS Secret Key                                                                | `nil`                          |

### Persistence parameters

| Parameter                   | Description                              | Default                                     |
|-----------------------------|------------------------------------------|---------------------------------------------|
| `persistence.enabled`       | Enable persistence using PVC             | `true`                                      |
| `persistence.existingClaim` | Enable persistence using an existing PVC | `nil`                                       |
| `persistence.storageClass`  | PVC Storage Class                        | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`    | PVC Access Mode                          | `ReadWriteOnce`                             |
| `persistence.size`          | PVC Storage Request                      | `10Gi`                                      |
| `persistence.dataSource`    | PVC data source                          | `{}`                                        |

### Database parameters

| Parameter                                 | Description                                          | Default                                        |
|-------------------------------------------|------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                         | Deploy MariaDB container(s)                          | `true`                                         |
| `mariadb.architecture`                    | MariaDB architecture (`standalone` or `replication`) | `standalone`                                   |
| `mariadb.auth.rootPassword`               | Password for the MariaDB `root` user                 | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                   | Database name to create                              | `bitnami_wordpress`                            |
| `mariadb.auth.username`                   | Database user to create                              | `bn_wordpress`                                 |
| `mariadb.auth.password`                   | Password for the database                            | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`     | Enable database persistence using PVC                | `true`                                         |
| `mariadb.primary.persistence.accessModes` | Database Persistent Volume Access Modes              | `[ReadWriteOnce]`                              |
| `mariadb.primary.persistence.size`        | Database Persistent Volume Size                      | `8Gi`                                          |
| `externalDatabase.host`                   | Host of the external database                        | `localhost`                                    |
| `externalDatabase.user`                   | Existing username in the external db                 | `bn_wordpress`                                 |
| `externalDatabase.password`               | Password for the above username                      | `nil`                                          |
| `externalDatabase.database`               | Name of the existing database                        | `bitnami_wordpress`                            |
| `externalDatabase.port`                   | Database port number                                 | `3306`                                         |
| `externalDatabase.existingSecret`         | Name of the database existing Secret Object          | `nil`                                          |

### Volume Permissions parameters

| Parameter                                     | Description                                                                                                          | Default                                                 |
|-----------------------------------------------|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                     | `docker.io`                                             |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                         | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                          | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                  | `Always`                                                |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.resources.limits`          | Init container volume-permissions resource  limits                                                                   | `{}`                                                    |
| `volumePermissions.resources.requests`        | Init container volume-permissions resource  requests                                                                 | `{}`                                                    |
| `volumePermissions.securityContext.*`         | Other container security context to be included as-is in the container spec                                          | `{}`                                                    |
| `volumePermissions.securityContext.runAsUser` | User ID for the init container (when facing issues in OpenShift or uid unknown, try value "auto")                    | `0`                                                     |

### Metrics parameters

| Parameter                                 | Description                                                                  | Default                                                      |
|-------------------------------------------|------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                         | Start a side-car prometheus exporter                                         | `false`                                                      |
| `metrics.image.registry`                  | Apache exporter image registry                                               | `docker.io`                                                  |
| `metrics.image.repository`                | Apache exporter image name                                                   | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`                       | Apache exporter image tag                                                    | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                | Image pull policy                                                            | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`               | Specify docker-registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.service.port`                    | Service Metrics port                                                         | `9117`                                                       |
| `metrics.service.annotations`             | Annotations for enabling prometheus to access the metrics endpoints          | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources.limits`                | The resources limits for the metrics exporter container                      | `{}`                                                         |
| `metrics.resources.requests`              | The requested resources for the metrics exporter container                   | `{}`                                                         |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator | `false`                                                      |
| `metrics.serviceMonitor.namespace`        | Namespace where servicemonitor resource should be created                    | `nil`                                                        |
| `metrics.serviceMonitor.interval`         | Specify the interval at which metrics should be scraped                      | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                          | `nil`                                                        |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                    | `nil`                                                        |
| `metrics.serviceMonitor.honorLabels`      | honorLabels chooses the metric's labels on collisions with target labels.    | `false`                                                      |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator   | `{}`                                                         |

### Other parameters

| Parameter                  | Description                                                    | Default |
|----------------------------|----------------------------------------------------------------|---------|
| `pdb.create`               | Enable/disable a Pod Disruption Budget creation                | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `nil`   |
| `autoscaling.enabled`      | Enable autoscaling for WordPress                               | `false` |
| `autoscaling.minReplicas`  | Minimum number of WordPress replicas                           | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of WordPress replicas                           | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `nil`   |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `nil`   |

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

If additional containers are needed in the same pod as WordPress (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/wordpress/administration/configure-use-sidecars/).

### External database support

You may want to have WordPress connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Refer to the [documentation on using an external database with WordPress](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/use-external-database/) and the [tutorial on integrating WordPress with a managed cloud database](https://docs.bitnami.com/tutorials/secure-wordpress-kubernetes-managed-database-ssl-upgrades/) for more information.

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve WordPress.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/wordpress/administration/enable-tls/).

### `.htaccess` files

For performance and security reasons, it is a good practice to configure Apache with the `AllowOverride None` directive. Instead of using `.htaccess` files, Apache will load the same directives at boot time. These directives are located in `/opt/bitnami/wordpress/wordpress-htaccess.conf`.

By default, the container image includes all the default `.htaccess` files in WordPress (together with the default plugins). To enable this feature, install the chart with the value `allowOverrideNone=yes`.

[Learn more about working with `.htaccess` files](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/understand-htaccess/).

## Persistence

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image stores the WordPress data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. [Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/chart-persistence/).

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 10.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/wordpress/administration/upgrade-helm3/).

#### Additional upgrade notes

- MariaDB dependency version was bumped to a new major version that introduces several incompatabilitees. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.
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

In https://github.com/helm/charts/pulls/12642 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to `3.0.0`. The following example assumes that the release name is `wordpress`:

```console
kubectl patch deployment wordpress-wordpress --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl delete statefulset wordpress-mariadb --cascade=false
```
