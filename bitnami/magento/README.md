# Magento

[Magento](https://magento.org/) is a feature-rich flexible e-commerce solution. It includes transaction options, multi-store functionality, loyalty programs, product categorization and shopper filtering, promotion rules, and more.

## TL;DR;

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
- Helm 2.12+ or Helm 3.0-beta3+
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

The following table lists the configurable parameters of the Magento chart and their default values.

| Parameter                               | Description                                                                                          | Default                                                      |
|-----------------------------------------|------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                  | Global Docker image registry                                                                         | `nil`                                                        |
| `global.imagePullSecrets`               | Global Docker registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                   | Global storage class for dynamic provisioning                                                        | `nil`                                                        |
| `image.registry`                        | Magento image registry                                                                               | `docker.io`                                                  |
| `image.repository`                      | Magento Image name                                                                                   | `bitnami/magento`                                            |
| `image.tag`                             | Magento Image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.debug`                           | Specify if debug values should be set                                                                | `false`                                                      |
| `image.pullPolicy`                      | Image pull policy                                                                                    | `Always` if `imageTag` is `latest`, else `IfNotPresent`      |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                          | String to partially override magento.fullname template with a string (will prepend the release name) | `nil`                                                        |
| `fullnameOverride`                      | String to fully override magento.fullname template with a string                                     | `nil`                                                        |
| `magentoHost`                           | Magento host to create application URLs                                                              | `nil`                                                        |
| `magentoLoadBalancerIP`                 | `loadBalancerIP` for the magento Service                                                             | `nil`                                                        |
| `magentoUsername`                       | User of the application                                                                              | `user`                                                       |
| `magentoPassword`                       | Application password                                                                                 | _random 10 character long alphanumeric string_               |
| `magentoEmail`                          | Admin email                                                                                          | `user@example.com`                                           |
| `magentoFirstName`                      | Magento Admin First Name                                                                             | `FirstName`                                                  |
| `magentoLastName`                       | Magento Admin Last Name                                                                              | `LastName`                                                   |
| `magentoMode`                           | Magento mode                                                                                         | `developer`                                                  |
| `magentoUseSecureAdmin`                 | Use SSL to access the Magento Admin.                                                                 | `false`                                                      |
| `magentoSkipReindex`                    | Skip Magento Indexer reindex step during the initialization                                          | `false`                                                      |
| `magentoAdminUri`                       | Magento prefix to access Magento Admin                                                               | `admin`                                                      |
| `allowEmptyPassword`                    | Allow DB blank passwords                                                                             | `yes`                                                        |
| `ingress.enabled`                       | Enable ingress controller resource                                                                   | `false`                                                      |
| `ingress.annotations`                   | Ingress annotations                                                                                  | `[]`                                                         |
| `ingress.certManager`                   | Add annotations for cert-manager                                                                     | `false`                                                      |
| `ingress.hosts[0].name`                 | Hostname to your Magento installation                                                                | `magento.local`                                              |
| `ingress.hosts[0].path`                 | Path within the url structure                                                                        | `/`                                                          |
| `ingress.hosts[0].tls`                  | Utilize TLS backend in ingress                                                                       | `false`                                                      |
| `ingress.hosts[0].tlsHosts`             | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                 | `nil`                                                        |
| `ingress.hosts[0].tlsSecret`            | TLS Secret (certificates)                                                                            | `magento.local-tls-secret`                                   |
| `ingress.secrets[0].name`               | TLS Secret Name                                                                                      | `nil`                                                        |
| `ingress.secrets[0].certificate`        | TLS Secret Certificate                                                                               | `nil`                                                        |
| `ingress.secrets[0].key`                | TLS Secret Key                                                                                       | `nil`                                                        |
| `externalDatabase.host`                 | Host of the external database                                                                        | `nil`                                                        |
| `externalDatabase.port`                 | Port of the external database                                                                        | `3306`                                                       |
| `externalDatabase.user`                 | Existing username in the external db                                                                 | `bn_magento`                                                 |
| `externalDatabase.password`             | Password for the above username                                                                      | `nil`                                                        |
| `externalDatabase.database`             | Name of the existing database                                                                        | `bitnami_magento`                                            |
| `externalElasticsearch.host`            | Host of the external elasticsearch server                                                            | `nil`                                                        |
| `externalElasticsearch.port`            | Port of the external elasticsearch server                                                            | `nil`                                                        |
| `mariadb.enabled`                       | Whether to use the MariaDB chart                                                                     | `true`                                                       |
| `mariadb.rootUser.password`             | MariaDB admin password                                                                               | `nil`                                                        |
| `mariadb.db.name`                       | Database name to create                                                                              | `bitnami_magento`                                            |
| `mariadb.db.user`                       | Database user to create                                                                              | `bn_magento`                                                 |
| `mariadb.db.password`                   | Password for the database                                                                            | _random 10 character long alphanumeric string_               |
| `mariadb.replication.enabled`           | MariaDB replication enabled                                                                          | `true`                                                       |
| `mariadb.master.persistence.enabled`    | Enable persistence using PVC                                                                         | `true`                                                       |
| `mariadb.master.persistence.accessMode` | Persistent Volume Access Modes                                                                       | `[ReadWriteOnce]`                                            |
| `mariadb.master.persistence.size`       | Persistent Volume Size                                                                               | `8Gi`                                                        |
| `elasticsearch.enabled`                 | Use the Elasticsearch chart as search engine                                                         | `true`                                                       |
| `elasticsearch.image.registry`          | Elasticsearch image registry                                                                         | `docker.io`                                                  |
| `elasticsearch.image.repository`        | Elasticsearch image name                                                                             | `bitnami/elasticsearch`                                      |
| `elasticsearch.image.tag`               | Elasticsearch image tag                                                                              | `{TAG_NAME}`                                                 |
| `elasticsearch.sysctlImage.enabled`     | Enable kernel settings modifier image for Elasticsearch                                              | `true`                                                       |
| `elasticsearch.master.replicas`         | Desired number of Elasticsearch master-eligible nodes                                                | `1`                                                          |
| `elasticsearch.coordinating.replicas`   | Desired number of Elasticsearch coordinating-only nodes                                              | `1`                                                          |
| `elasticsearch.data.replicas`           | Desired number of Elasticsearch data nodes                                                           | `1`                                                          |
| `service.type`                          | Kubernetes Service type                                                                              | `LoadBalancer`                                               |
| `service.port`                          | Service HTTP port                                                                                    | `80`                                                         |
| `service.httpsPort`                     | Service HTTPS port                                                                                   | `443`                                                        |
| `nodePorts.https`                       | Kubernetes https node port                                                                           | `""`                                                         |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                                 | `Cluster`                                                    |
| `service.nodePorts.http`                | Kubernetes http node port                                                                            | `""`                                                         |
| `service.nodePorts.https`               | Kubernetes https node port                                                                           | `""`                                                         |
| `service.loadBalancerIP`                | `loadBalancerIP` for the Magento Service                                                             | `nil`                                                        |
| `livenessProbe.enabled`                 | Turn on and off liveness probe                                                                       | `true`                                                       |
| `livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated                                                             | `1000`                                                       |
| `livenessProbe.periodSeconds`           | How often to perform the probe                                                                       | `10`                                                         |
| `livenessProbe.timeoutSeconds`          | When the probe times out                                                                             | `5`                                                          |
| `livenessProbe.successThreshold`        | Minimum consecutive successes for the probe                                                          | `1`                                                          |
| `livenessProbe.failureThreshold`        | Minimum consecutive failures for the probe                                                           | `6`                                                          |
| `readinessProbe.enabled`                | Turn on and off readiness probe                                                                      | `true`                                                       |
| `readinessProbe.initialDelaySeconds`    | Delay before readiness probe is initiated                                                            | `30`                                                         |
| `readinessProbe.periodSeconds`          | How often to perform the probe                                                                       | `5`                                                          |
| `readinessProbe.timeoutSeconds`         | When the probe times out                                                                             | `3`                                                          |
| `readinessProbe.successThreshold`       | Minimum consecutive successes for the probe                                                          | `1`                                                          |
| `readinessProbe.failureThreshold`       | Minimum consecutive failures for the probe                                                           | `3`                                                          |
| `persistence.enabled`                   | Enable persistence using PVC                                                                         | `true`                                                       |
| `persistence.apache.storageClass`       | PVC Storage Class for Apache volume                                                                  | `nil`  (uses alpha storage annotation)                       |
| `persistence.apache.accessMode`         | PVC Access Mode for Apache volume                                                                    | `ReadWriteOnce`                                              |
| `persistence.apache.size`               | PVC Storage Request for Apache volume                                                                | `1Gi`                                                        |
| `persistence.magento.storageClass`      | PVC Storage Class for Magento volume                                                                 | `nil`  (uses alpha storage annotation)                       |
| `persistence.magento.accessMode`        | PVC Access Mode for Magento volume                                                                   | `ReadWriteOnce`                                              |
| `persistence.magento.size`              | PVC Storage Request for Magento volume                                                               | `8Gi`                                                        |
| `updateStrategy`                        | Set to Recreate if you use persistent volume that cannot be mounted by more than one pods            | `RollingUpdate`                                              |
| `resources`                             | CPU/Memory resource requests/limits                                                                  | Memory: `512Mi`, CPU: `300m`                                 |
| `podAnnotations`                        | Pod annotations                                                                                      | `{}`                                                         |
| `affinity`                              | Map of node/pod affinities                                                                           | `{}`                                                         |
| `metrics.enabled`                       | Start a side-car prometheus exporter                                                                 | `false`                                                      |
| `metrics.image.registry`                | Apache exporter image registry                                                                       | `docker.io`                                                  |
| `metrics.image.repository`              | Apache exporter image name                                                                           | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`                     | Apache exporter image tag                                                                            | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`              | Image pull policy                                                                                    | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`             | Specify docker-registry secret names as an array                                                     | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`                | Additional annotations for Metrics exporter pod                                                      | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                     | Exporter resource requests/limit                                                                     | {}                                                           |

The above parameters map to the env variables defined in [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento). For more information please refer to the [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento) image documentation.

> **Note**:
>
> For Magento to function correctly, you should specify the `magentoHost` parameter to specify the FQDN (recommended) or the public IP address of the Magento service.
>
> Optionally, you can specify the `magentoLoadBalancerIP` parameter to assign a reserved IP address to the Magento service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create magento-public-ip
> ```
>
> The reserved IP address can be associated to the Magento service by specifying it as the value of the `magentoLoadBalancerIP` parameter while installing the chart.

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

## Persistence

The [Bitnami Magento](https://github.com/bitnami/bitnami-docker-magento) image stores the Magento data and configurations at the `/bitnami/magento` and `/bitnami/apache` paths of the container.

 Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

## Notable changes

### 14.0.0

This version updates the docker image to `2.3.5-debian-10-r57` version. That version persists the full `htdocs` folder. From now on, to upgrade the Magento version it is needed to follow the [offical steps](https://devdocs.magento.com/guides/v2.3/comp-mgr/cli/cli-upgrade.html) manually.

### 13.0.0

Several changes were introduced that can break backwards compatibilty:
- This version includes a new major version of the ElasticSearch chart bundled as dependency. You can find the release notes of the new ElasticSearch major version in [this section](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch#1200) of the ES README.
- Labels are adapted to follow the Helm charts best practices.

### 9.0.0

This version enabled by default an initContainer that modify some kernel settings to meet the Elasticsearch requirements.

Currently, Elasticsearch requires some changes in the kernel of the host machine to work as expected. If those values are not set in the underlying operating system, the ES containers fail to boot with ERROR messages. More information about these requirements can be found in the links below:

- [File Descriptor requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html)
- [Virtual memory requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)

You can disable the initContainer using the `elasticsearch.sysctlImage.enabled=false` parameter.

## Upgrading

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
