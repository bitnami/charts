# Magento

[Magento](https://magento.org/) is a feature-rich flexible e-commerce solution. It includes transaction options, multi-store functionality, loyalty programs, product categorization and shopper filtering, promotion rules, and more.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/magento
```

## Introduction

This chart bootstraps a [Magento](https://github.com/bitnami/bitnami-docker-magento) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment as a database for the Magento application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/magento
```

These commands deploy Magento on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Magento chart and their default values per section/component:

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
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`                           |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `nil`                          |

### Magento parameters

| Parameter               | Description                                                          | Default                                                 |
|-------------------------|----------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`        | Magento image registry                                               | `docker.io`                                             |
| `image.repository`      | Magento Image name                                                   | `bitnami/magento`                                       |
| `image.tag`             | Magento Image tag                                                    | `{TAG_NAME}`                                            |
| `image.debug`           | Specify if debug values should be set                                | `false`                                                 |
| `image.pullPolicy`      | Image pull policy                                                    | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`     | Specify docker-registry secret names as an array                     | `[]` (does not add image pull secrets to deployed pods) |
| `magentoHost`           | Magento host to create application URLs                              | `nil`                                                   |
| `magentoUsername`       | User of the application                                              | `user`                                                  |
| `magentoPassword`       | Application password                                                 | _random 10 character long alphanumeric string_          |
| `magentoEmail`          | Admin email                                                          | `user@example.com`                                      |
| `magentoFirstName`      | Magento Admin First Name                                             | `FirstName`                                             |
| `magentoLastName`       | Magento Admin Last Name                                              | `LastName`                                              |
| `magentoMode`           | Magento mode                                                         | `developer`                                             |
| `magentoUseSecureAdmin` | Use SSL to access the Magento Admin.                                 | `false`                                                 |
| `magentoSkipReindex`    | Skip Magento Indexer reindex step during the initialization          | `false`                                                 |
| `magentoAdminUri`       | Magento prefix to access Magento Admin                               | `admin`                                                 |
| `allowEmptyPassword`    | Allow DB blank passwords                                             | `yes`                                                   |
| `command`               | Override default container command (useful when using custom images) | `nil`                                                   |
| `args`                  | Override default container args (useful when using custom images)    | `nil`                                                   |
| `extraEnvVars`          | Extra environment variables to be set on Magento container           | `{}`                                                    |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                 | `nil`                                                   |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                    | `nil`                                                   |

### Magento deployment parameters

| Parameter                          | Description                                                                               | Default                                |
|------------------------------------|-------------------------------------------------------------------------------------------|----------------------------------------|
| `podSecurityContext`               | Magento pods' Security Context                                                            | Check `values.yaml` file               |
| `containerSecurityContext`         | Magento containers' Security Context                                                      | Check `values.yaml` file               |
| `resources.limits`                 | The resources limits for the Magento container                                            | `{}`                                   |
| `resources.requests`               | The requested resources for the Magento container                                         | `{"memory": "512Mi", "cpu": "300m"}`   |
| `livenessProbe`                    | Liveness probe configuration for Magento                                                  | Check `values.yaml` file               |
| `readinessProbe`                   | Readiness probe configuration for Magento                                                 | Check `values.yaml` file               |
| `customLivenessProbe`              | Override default liveness probe                                                           | `nil`                                  |
| `customReadinessProbe`             | Override default readiness probe                                                          | `nil`                                  |
| `updateStrategy`                   | Strategy to use to update Pods                                                            | Check `values.yaml` file               |
| `podAffinityPreset`                | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                   |
| `podAntiAffinityPreset`            | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                 |
| `nodeAffinityPreset.type`          | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                   |
| `nodeAffinityPreset.key`           | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                   |
| `nodeAffinityPreset.values`        | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                   |
| `affinity`                         | Affinity for pod assignment                                                               | `{}` (evaluated as a template)         |
| `nodeSelector`                     | Node labels for pod assignment                                                            | `{}` (evaluated as a template)         |
| `tolerations`                      | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)         |
| `podLabels`                        | Extra labels for Magento pods                                                             | `{}` (evaluated as a template)         |
| `podAnnotations`                   | Annotations for Magento pods                                                              | `{}` (evaluated as a template)         |
| `extraVolumeMounts`                | Optionally specify extra list of additional volumeMounts for Magento container(s)         | `[]`                                   |
| `extraVolumes`                     | Optionally specify extra list of additional volumes for Magento pods                      | `[]`                                   |
| `initContainers`                   | Add additional init containers to the Magento pods                                        | `{}` (evaluated as a template)         |
| `sidecars`                         | Add additional sidecar containers to the Magento pods                                     | `{}` (evaluated as a template)         |
| `persistence.enabled`              | Enable persistence using PVC                                                              | `true`                                 |
| `persistence.apache.storageClass`  | PVC Storage Class for Apache volume                                                       | `nil`  (uses alpha storage annotation) |
| `persistence.apache.accessMode`    | PVC Access Mode for Apache volume                                                         | `ReadWriteOnce`                        |
| `persistence.apache.size`          | PVC Storage Request for Apache volume                                                     | `1Gi`                                  |
| `persistence.magento.storageClass` | PVC Storage Class for Magento volume                                                      | `nil`  (uses alpha storage annotation) |
| `persistence.magento.accessMode`   | PVC Access Mode for Magento volume                                                        | `ReadWriteOnce`                        |
| `persistence.magento.size`         | PVC Storage Request for Magento volume                                                    | `8Gi`                                  |

### Exposure parameters

| Parameter                        | Description                                              | Default                        |
|----------------------------------|----------------------------------------------------------|--------------------------------|
| `service.type`                   | Kubernetes Service type                                  | `LoadBalancer`                 |
| `service.port`                   | Service HTTP port                                        | `80`                           |
| `service.httpsPort`              | Service HTTPS port                                       | `443`                          |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                     | `Cluster`                      |
| `service.nodePorts.http`         | Kubernetes http node port                                | `""`                           |
| `service.nodePorts.https`        | Kubernetes https node port                               | `""`                           |
| `service.loadBalancerIP`         | `loadBalancerIP` for the Magento Service                 | `nil`                          |
| `ingress.enabled`                | Enable ingress controller resource                       | `false`                        |
| `ingress.certManager`            | Add annotations for cert-manager                         | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                    | `magento.local`                |
| `ingress.path`                   | Default path for the ingress resource                    | `/`                            |
| `ingress.tls`                    | Create TLS Secret                                        | `false`                        |
| `ingress.annotations`            | Ingress annotations                                      | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`     | Additional hostnames to be covered                       | `nil`                          |
| `ingress.extraHosts[0].path`     | Additional hostnames to be covered                       | `nil`                          |
| `ingress.extraPaths`             | Additional arbitrary path/backend objects                | `nil`                          |
| `ingress.extraTls[0].hosts[0]`   | TLS configuration for additional hostnames to be covered | `nil`                          |
| `ingress.extraTls[0].secretName` | TLS configuration for additional hostnames to be covered | `nil`                          |
| `ingress.secrets[0].name`        | TLS Secret Name                                          | `nil`                          |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                   | `nil`                          |
| `ingress.secrets[0].key`         | TLS Secret Key                                           | `nil`                          |

### Database parameters

| Parameter                                   | Description                                          | Default                                        |
|---------------------------------------------|------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                           | Whether to use the MariaDB chart                     | `true`                                         |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`) | `standalone`                                   |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                 | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                     | Database name to create                              | `bitnami_magento`                              |
| `mariadb.auth.username`                     | Database user to create                              | `bn_magento`                                   |
| `mariadb.auth.password`                     | Password for the database                            | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                | `true`                                         |
| `mariadb.primary.persistence.accessMode`    | Database Persistent Volume Access Modes              | `ReadWriteOnce`                                |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                      | `8Gi`                                          |
| `mariadb.primary.persistence.existingClaim` | Enable persistence using an existing PVC             | `nil`                                          |
| `mariadb.primary.persistence.storageClass`  | PVC Storage Class                                    | `nil` (uses alpha storage class annotation)    |
| `mariadb.primary.persistence.hostPath`      | Host mount path for MariaDB volume                   | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                     | Existing username in the external db                 | `bn_magento`                                   |
| `externalDatabase.password`                 | Password for the above username                      | `nil`                                          |
| `externalDatabase.database`                 | Name of the existing database                        | `bitnami_magento`                              |
| `externalDatabase.host`                     | Host of the existing database                        | `nil`                                          |
| `externalDatabase.port`                     | Port of the existing database                        | `3306`                                         |
| `externalDatabase.existingSecret`           | Name of the database existing Secret Object          | `nil`                                          |

### Elasticsearch parameters

| Parameter                             | Description                                             | Default                 |
|---------------------------------------|---------------------------------------------------------|-------------------------|
| `elasticsearch.enabled`               | Use the Elasticsearch chart as search engine            | `true`                  |
| `elasticsearch.image.registry`        | Elasticsearch image registry                            | `docker.io`             |
| `elasticsearch.image.repository`      | Elasticsearch image name                                | `bitnami/elasticsearch` |
| `elasticsearch.image.tag`             | Elasticsearch image tag                                 | `{TAG_NAME}`            |
| `elasticsearch.sysctlImage.enabled`   | Enable kernel settings modifier image for Elasticsearch | `true`                  |
| `elasticsearch.master.replicas`       | Desired number of Elasticsearch master-eligible nodes   | `1`                     |
| `elasticsearch.coordinating.replicas` | Desired number of Elasticsearch coordinating-only nodes | `1`                     |
| `elasticsearch.data.replicas`         | Desired number of Elasticsearch data nodes              | `1`                     |
| `externalElasticsearch.host`          | Host of the external elasticsearch server               | `nil`                   |
| `externalElasticsearch.port`          | Port of the external elasticsearch server               | `nil`                   |

### Metrics parameters

| Parameter                   | Description                                      | Default                                                      |
|-----------------------------|--------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`           | Start a side-car prometheus exporter             | `false`                                                      |
| `metrics.image.registry`    | Apache exporter image registry                   | `docker.io`                                                  |
| `metrics.image.repository`  | Apache exporter image name                       | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`         | Apache exporter image tag                        | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`  | Image pull policy                                | `IfNotPresent`                                               |
| `metrics.image.pullSecrets` | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`    | Additional annotations for Metrics exporter pod  | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`         | Exporter resource requests/limit                 | `{}`                                                         |

The above parameters map to the env variables defined in [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento). For more information please refer to the [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento) image documentation.

> **Note**:
>
> For Magento to function correctly, you should specify the `magentoHost` parameter to specify the FQDN (recommended) or the public IP address of the Magento service.
>
> Optionally, you can specify the `service.loadBalancerIP` parameter to assign a reserved IP address to the Magento service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create magento-public-ip
> ```
>
> The reserved IP address can be associated to the Magento service by specifying it as the value of the `service.loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set magentoUsername=admin,magentoPassword=password,mariadb.mariadbRootPassword=secretpassword \
    bitnami/magento
```

The above command sets the Magento administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/magento
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this Magento installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

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

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `magento.local-tls` for example).

## Persistence

The [Bitnami Magento](https://github.com/bitnami/bitnami-docker-magento) image stores the Magento data and configurations at the `/bitnami/magento` and `/bitnami/apache` paths of the container.

 Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Magento app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Notable changes

### 14.0.0

This version updates the docker image to `2.3.5-debian-10-r57` version. That version persists the full `htdocs` folder. From now on, to upgrade the Magento version it is needed to follow the [official steps](https://devdocs.magento.com/guides/v2.3/comp-mgr/cli/cli-upgrade.html) manually.

### 13.0.0

Several changes were introduced that can break backwards compatibility:

- This version includes a new major version of the ElasticSearch chart bundled as dependency. You can find the release notes of the new ElasticSearch major version in [this section](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch#1200) of the ES README.
- Labels are adapted to follow the Helm charts best practices.

### 9.0.0

This version enabled by default an initContainer that modify some kernel settings to meet the Elasticsearch requirements.

Currently, Elasticsearch requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the ES containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

You can disable the initContainer using the `elasticsearch.sysctlImage.enabled=false` parameter.

## Upgrading

### To 16.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Magento deployment before upgrading (the following example assumes that the release name is `magento`):

```console
$ export APP_HOST=$(kubectl get svc --namespace default magento --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
$ export APP_PASSWORD=$(kubectl get secret --namespace default magento -o jsonpath="{.data.magento-password}" | base64 --decode)
$ export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default magento-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
$ export MARIADB_PASSWORD=$(kubectl get secret --namespace default magento-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
$ kubectl delete deployments.apps magento
$ helm upgrade magento bitnami/magento --set magentoHost=$APP_HOST,magentoPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD
```

### To 15.0.0

In this major there were two main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB and Elasticsearch dependency versions

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

In this major the MariaDB and Elasticsearch dependency versions were also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information. Although it is using the latest `bitnami/mariadb` chart, given Magento `2.4` [current limitations](https://devdocs.magento.com/guides/v2.4/install-gde/system-requirements.html#database), the container image of MariaDB has been bumped to `10.4.x` instead of using the latest `10.5.x`.

To upgrade to `15.0.0`, it should be done reusing the PVCs used to hold data from MariaDB, Elasticsearch and Magento data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `magento` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.4.x

Obtain the credentials and the names of the PVCs used to hold the MariaDB data on your current release:

```console
$ export MAGENTO_HOST=$(kubectl get svc --namespace default magento --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
$ export MAGENTO_PASSWORD=$(kubectl get secret --namespace default magento -o jsonpath="{.data.magento-password}" | base64 --decode)
$ export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default magento-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
$ export MARIADB_PASSWORD=$(kubectl get secret --namespace default magento-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
$ export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=magento -o jsonpath="{.items[0].metadata.name}")
```

Delete the Magento deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter.

```console
$ kubectl delete deployments.apps magento
$ kubectl delete statefulsets.apps magento-mariadb --cascade=false
```

Now the upgrade works:

```console
$ helm upgrade magento bitnami/magento --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set magentoPassword=$MAGENTO_PASSWORD --set magentoHost=$MAGENTO_HOST
```

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

```console
$ kubectl delete pod magento-mariadb-0z
```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=magento,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 10.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In 4dfac075aacf74405e31ae5b27df4369e84eb0b0 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 5.0.0

Manual intervention is needed if configuring Elasticsearch 6 as Magento search engine is desired.

[Follow the Magento documentation](https://devdocs.magento.com/guides/v2.3/config-guide/elasticsearch/configure-magento.html) in order to configure Elasticsearch, setting **Search Engine** to **Elasticsearch 6.0+**. If using the Elasticsearch server included in this chart, `hostname` and `port` can be obtained with the following commands:

```
$ kubectl get svc -l app=elasticsearch,component=client,release=RELEASE_NAME -o jsonpath="{.items[0].metadata.name}"
$ kubectl get svc -l app=elasticsearch,component=client,release=RELEASE_NAME -o jsonpath="{.items[0].spec.ports[0].port}"
```

Where `RELEASE_NAME` is the name of the release. Use `helm list` to find it.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is magento:

```console
$ kubectl patch deployment magento-magento --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset magento-mariadb --cascade=false
```
