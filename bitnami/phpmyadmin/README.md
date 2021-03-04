# phpMyAdmin

[phpMyAdmin](https://www.phpmyadmin.net/) is a free and open source administration tool for MySQL and MariaDB. As a portable web application written primarily in PHP, it has become one of the most popular MySQL administration tools, especially for web hosting services.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/phpmyadmin
```

## Introduction

This chart bootstraps a [phpMyAdmin](https://github.com/bitnami/bitnami-docker-phpmyadmin) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/phpmyadmin
```

The command deploys phpMyAdmin on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the phpMyAdmin chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |

### Common parameters

| Parameter           | Description                                                          | Default                        |
|---------------------|----------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname                   | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname                       | `nil`                          |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`                           |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `nil`                          |

### phpMyAdmin parameters

| Parameter            | Description                                                          | Default                                                 |
|----------------------|----------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`     | phpMyAdmin image registry                                            | `docker.io`                                             |
| `image.repository`   | phpMyAdmin image name                                                | `bitnami/phpmyadmin`                                    |
| `image.tag`          | phpMyAdmin image tag                                                 | `{TAG_NAME}`                                            |
| `image.pullPolicy`   | Image pull policy                                                    | `IfNotPresent`                                          |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                     | `[]` (does not add image pull secrets to deployed pods) |
| `command`            | Override default container command (useful when using custom images) | `nil`                                                   |
| `args`               | Override default container args (useful when using custom images)    | `nil`                                                   |
| `extraEnvVars`       | Extra environment variables to be set on PhpMyAdmin container        | `{}`                                                    |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra env vars                 | `nil`                                                   |
| `extraEnvVarsSecret` | Name of existing Secret containing extra env vars                    | `nil`                                                   |

### phpMyAdmin deployment parameters

| Parameter                   | Description                                                                               | Default                              |
|-----------------------------|-------------------------------------------------------------------------------------------|--------------------------------------|
| `containerPorts.http`       | HTTP port to expose at container level                                                    | `8080`                               |
| `containerPorts.https`      | HTTPS port to expose at container level                                                   | `8443`                               |
| `podSecurityContext`        | PhpMyAdmin pods' Security Context                                                         | Check `values.yaml` file             |
| `containerSecurityContext`  | PhpMyAdmin containers' Security Context                                                   | Check `values.yaml` file             |
| `resources.limits`          | The resources limits for the PhpMyAdmin container                                         | `{}`                                 |
| `resources.requests`        | The requested resources for the PhpMyAdmin container                                      | `{"memory": "512Mi", "cpu": "300m"}` |
| `livenessProbe`             | Liveness probe configuration for PhpMyAdmin                                               | Check `values.yaml` file             |
| `readinessProbe`            | Readiness probe configuration for PhpMyAdmin                                              | Check `values.yaml` file             |
| `customLivenessProbe`       | Override default liveness probe                                                           | `nil`                                |
| `customReadinessProbe`      | Override default readiness probe                                                          | `nil`                                |
| `hostAliases`               | Add deployment host aliases                                                               | `Check values.yaml`                  |
| `updateStrategy`            | Strategy to use to update Pods                                                            | Check `values.yaml` file             |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                 |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                               |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                 |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                 |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                 |
| `affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template)       |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template)       |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)       |
| `podLabels`                 | Extra labels for PhpMyAdmin pods                                                          | `{}` (evaluated as a template)       |
| `podAnnotations`            | Annotations for PhpMyAdmin pods                                                           | `{}` (evaluated as a template)       |
| `extraVolumeMounts`         | Optionally specify extra list of additional volumeMounts for PhpMyAdmin container(s)      | `[]`                                 |
| `extraVolumes`              | Optionally specify extra list of additional volumes for PhpMyAdmin pods                   | `[]`                                 |
| `initContainers`            | Add additional init containers to the PhpMyAdmin pods                                     | `{}` (evaluated as a template)       |
| `sidecars`                  | Add additional sidecar containers to the PhpMyAdmin pods                                  | `{}` (evaluated as a template)       |

### Exposure parameters

| Parameter                          | Description                                                                       | Default                        |
|------------------------------------|-----------------------------------------------------------------------------------|--------------------------------|
| `service.type`                     | Kubernetes Service type                                                           | `LoadBalancer`                 |
| `service.port`                     | Service HTTP port                                                                 | `80`                           |
| `service.httpsPort`                | Service HTTPS port                                                                | `""`                           |
| `service.nodePorts.http`           | Kubernetes http node port                                                         | `""`                           |
| `service.nodePorts.https`          | Kubernetes https node port                                                        | `""`                           |
| `service.clusterIP`                | PhpMyAdmin service clusterIP IP                                                   | `None`                         |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                              | `Cluster`                      |
| `service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                  | `nil`                          |
| `service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                             | `[]`                           |
| `service.annotations`              | Annotations for PhpMyAdmin service                                                | `{}` (evaluated as a template) |
| `ingress.enabled`                  | Enable ingress controller resource                                                | `false`                        |
| `ingress.certManager`              | Add annotations for cert-manager                                                  | `false`                        |
| `ingress.hostname`                 | Default host for the ingress resource                                             | `phpmyadmin.local`             |
| `ingress.pathType`                 | Ingress path type                                                                 | `ImplementationSpecific`       |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter | `false`                        |
| `ingress.annotations`              | Ingress annotations                                                               | `{}` (evaluated as a template) |
| `ingress.extraHosts[0].name`       | Additional hostnames to be covered                                                | `nil`                          |
| `ingress.extraHosts[0].path`       | Additional hostnames to be covered                                                | `nil`                          |
| `ingress.extraTls[0].hosts[0]`     | TLS configuration for additional hostnames to be covered                          | `nil`                          |
| `ingress.extraTls[0].secretName`   | TLS configuration for additional hostnames to be covered                          | `nil`                          |
| `ingress.secrets[0].name`          | TLS Secret Name                                                                   | `nil`                          |
| `ingress.secrets[0].certificate`   | TLS Secret Certificate                                                            | `nil`                          |
| `ingress.secrets[0].key`           | TLS Secret Key                                                                    | `nil`                          |

### Database parameters

| Parameter                  | Description                                                       | Default |
|----------------------------|-------------------------------------------------------------------|---------|
| `db.allowArbitraryServer`  | Enable connection to arbitrary MySQL server                       | `true`  |
| `db.port`                  | Database port to use to connect                                   | `3306`  |
| `db.chartName`             | Database suffix if included in the same release                   | `nil`   |
| `db.host`                  | Database host to connect to                                       | `nil`   |
| `db.bundleTestDB`          | Deploy a MariaDB instance for testing purposes                    | `false` |
| `db.enableSsl`             | Enable SSL for the connection between phpMyAdmin and the database | `false` |
| `db.ssl.clientKey`         | Client key file when using SSL                                    | `nil`   |
| `db.ssl.clientCertificate` | Client certificate file when using SSL                            | `nil`   |
| `db.ssl.caCertificate`     | CA file when using SSL                                            | `nil`   |
| `db.ssl.ciphers`           | List of allowable ciphers for connections when using SSL          | `nil`   |
| `db.ssl.verify`            | Enable SSL certificate validation                                 | `true`  |

### Metrics parameters

| Parameter                                  | Description                                                                       | Default                                                      |
|--------------------------------------------|-----------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                          | Start a side-car prometheus exporter                                              | `false`                                                      |
| `metrics.image.registry`                   | Apache exporter image registry                                                    | `docker.io`                                                  |
| `metrics.image.repository`                 | Apache exporter image name                                                        | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`                        | Apache exporter image tag                                                         | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                 | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                  | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.resources`                        | Exporter resource requests/limit                                                  | `{}`                                                         |
| `metrics.service.type`                     | Prometheus metrics service type                                                   | `LoadBalancer`                                               |
| `metrics.service.port`                     | Prometheus metrics service port                                                   | `9117`                                                       |
| `metrics.service.loadBalancerIP`           | Load Balancer IP if the Prometheus metrics server type is `LoadBalancer`          | `nil`                                                        |
| `metrics.service.annotations`              | Annotations for Prometheus metrics service                                        | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator      | `false`                                                      |
| `metrics.serviceMonitor.namespace`         | Namespace where servicemonitor resource should be created                         | `nil`                                                        |
| `metrics.serviceMonitor.interval`          | Specify the interval at which metrics should be scraped                           | `30s`                                                        |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus. | `nil`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                               | `nil`                                                        |
| `metrics.serviceMonitor.relabellings`      | Specify Relabellings to add to the scrape endpoint                                | `nil`                                                        |
| `metrics.serviceMonitor.metricRelabelings` | Specify Metric Relabellings to add to the scrape endpoint                         | `nil`                                                        |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels.         | `false`                                                      |
| `metrics.serviceMonitor.additionalLabels`  | Used to pass Labels that are required by the Installed Prometheus Operator        | `{}`                                                         |

For more information please refer to the [bitnami/phpmyadmin](http://github.com/bitnami/bitnami-docker-Phpmyadmin) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set db.host=mymariadb,db.port=3306 bitnami/phpmyadmin
```

The above command sets the phpMyAdmin to connect to a database in `mymariadb` host and `3306` port respectively.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/phpmyadmin
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this phpMyAdmin installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are three common use cases:

- Helm generates/manages certificate secrets.
- User generates/manages certificates separately.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

In the first two cases, it's needed a certificate and a key. We would expect them to look like this:

- certificate files should look like (and there can be more than one certificate if there is a certificate chain)

    ```console
    -----BEGIN CERTIFICATE-----
    MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
    ...
    jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
    -----END CERTIFICATE-----
    ```

- keys should look like:

    ```console
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
    ...
    wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
    -----END RSA PRIVATE KEY-----
    ```

If you are going to use Helm to manage the certificates, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `phpmyadmin.local-tls` for example).

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the PhpMyAdmin app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `XpodAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 8.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing PhpMyAdmin deployment before upgrading (the following example assumes that the release name is `phpmyadmin`):

```console
$ export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default phpmyadmin-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
$ export MARIADB_PASSWORD=$(kubectl get secret --namespace default phpmyadmin-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
$ kubectl delete deployments.apps phpmyadmin
$ helm upgrade phpmyadmin bitnami/phpmyadmin --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD
```

### To 7.0.0

In this major there were two main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB dependency version

Please read the update notes carefully.

**1. Adaptation to Helm v2 EOL**

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

**2. Updated MariaDB dependency version**

In this major the MariaDB dependency version was also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `7.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and phpMyAdmin data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `phpmyadmin` and that `db.bundleTestDB=true` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and phpMyAdmin data on your current release:

```console
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default phpmyadmin-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default phpmyadmin-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=phpmyadmin -o jsonpath="{.items[0].metadata.name}")
```

Delete the phpMyAdmin deployment and delete the MariaDB statefulsets:

```console
  $ kubectl delete deployments.apps phpmyadmin

  $ kubectl delete statefulsets.apps phpmyadmin-mariadb-master

  $ kubectl delete statefulsets.apps phpmyadmin-mariadb-slave

```

Now the upgrade works:

```console
$ helm upgrade phpmyadmin bitnami/phpmyadmin --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set db.bundleTestDB=true
```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=phpmyadmin,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 6.0.0

The [Bitnami phpMyAdmin](https://github.com/bitnami/bitnami-docker-phpmyadmin) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.
Chart labels and Ingress configuration were also adapted to follow the Helm charts best practices.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- No writing permissions will be granted on `config.inc.php` by default.
- Backwards compatibility is not guaranteed.

To upgrade to `6.0.0`, backup your previous MariaDB databases, install a new phpMyAdmin chart and import the MariaDB backups.

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to `1.0.0`. The following example assumes that the release name is `phpmyadmin`:

```console
$ kubectl patch deployment phpmyadmin-phpmyadmin --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
