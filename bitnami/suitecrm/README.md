# SuiteCRM

[SuiteCRM](https://www.suitecrm.com) is a completely open source enterprise-grade Customer Relationship Management (CRM) application. SuiteCRM is a software fork of the popular customer relationship management (CRM) system SugarCRM.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/suitecrm
```

## Introduction

This chart bootstraps a [SuiteCRM](https://github.com/bitnami/bitnami-docker-suitecrm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the SuiteCRM application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/suitecrm
```

The command deploys SuiteCRM on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the SuiteCRM chart and their default values.

| Parameter                        | Description                                                                                           | Default                                                      |
|----------------------------------|-------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `commonAnnotations`                         | Annotations to be added to all deployed resources                                                     | `{}` (evaluated as a template)                                                    |
| `commonLabels`                              | Labels to be added to all deployed resources                                                          | `{}` (evaluated as a template)                                                    |
| `global.imageRegistry`                      | Global Docker image registry                                                                          | `nil`                                                        |
| `global.imagePullSecrets`                   | Global Docker registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods)                                                        |
| `global.storageClass`                       | Global storage class for dynamic provisioning                                                         | `nil`                                                        |
| `image.registry`                            | SuiteCRM image registry                                                                               | `docker.io`                                                  |
| `image.repository`                          | SuiteCRM image name                                                                                   | `bitnami/suitecrm`                                                    |
| `image.tag`                                 | SuiteCRM image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                          | Image pull policy                                                                                     | `IfNotPresent`                                               |
| `image.pullSecrets`                         | Specify docker-registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods)                                                        |
| `nameOverride`                              | String to partially override suitecrm.fullname template with a string (will prepend the release name) | `nil`                                                        |
| `fullnameOverride`                          | String to fully override suitecrm.fullname template with a string                                     | `nil`                                                        |
| `replicaCount`                              | Number of SuiteCRM replicas                                                                           | `1`                                                          |
| `suitecrmHost`                              | SuiteCRM host to create application URLs                                                              | `nil`                                                        |
| `suitecrmUsername`                          | User of the application                                                                               | `user`                                                       |
| `suitecrmPassword`                          | Application password                                                                                  | _random 10 character alphanumeric string_                                                      |
| `suitecrmEmail`                             | Admin email                                                                                           | `user@example.com`                                           |
| `suitecrmLastName`                          | Last name                                                                                             | `Last`                                                       |
| `suitecrmSmtpHost`                          | SMTP host                                                                                             | `nil`                                                        |
| `suitecrmSmtpPort`                          | SMTP port                                                                                             | `nil`                                                        |
| `suitecrmSmtpUser`                          | SMTP user                                                                                             | `nil`                                                        |
| `suitecrmSmtpPassword`                      | SMTP password                                                                                         | `nil`                                                        |
| `suitecrmSmtpProtocol`                      | SMTP protocol [`ssl`, `tls`]                                                                          | `nil`                                                        |
| `suitecrmValidateUserIP`                    | Whether to validate the user IP address or not                                                        | `no`                                                         |
| `allowEmptyPassword`                        | Allow DB blank passwords                                                                              | `yes`                                                        |
| `externalDatabase.host`                     | Host of the external database                                                                         | `nil`                                                        |
| `externalDatabase.port`                     | Port of the external database                                                                         | `3306`                                                       |
| `externalDatabase.user`                     | Existing username in the external db                                                                  | `bn_suitecrm`                                                |
| `externalDatabase.password`                 | Password for the above username                                                                       | `nil`                                                        |
| `externalDatabase.database`                 | Name of the existing database                                                                         | `bitnami_suitecrm`                                           |
| `ingress.enabled`                           | Enable ingress controller resource                                                                    | `false`                                                      |
| `ingress.annotations`                       | Ingress annotations                                                                                   | `[]`                                                         |
| `ingress.certManager`                       | Add annotations for cert-manager                                                                      | `false`                                                      |
| `ingress.hosts[0].name`                     | Hostname to your SuiteCRM installation                                                                | `suitecrm.local`                                             |
| `ingress.hosts[0].path`                     | Path within the url structure                                                                         | `/`                                                            |
| `ingress.hosts[0].tls`                      | Utilize TLS backend in ingress                                                                        | `false`                                                      |
| `ingress.hosts[0].tlsHosts`                 | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                  | `nil`                                                        |
| `ingress.hosts[0].tlsSecret`                | TLS Secret (certificates)                                                                             | `suitecrm.local-tls-secret`                                                      |
| `ingress.secrets[0].name`                   | TLS Secret Name                                                                                       | `nil`                                                        |
| `ingress.secrets[0].certificate`            | TLS Secret Certificate                                                                                | `nil`                                                        |
| `ingress.secrets[0].key`                    | TLS Secret Key                                                                                        | `nil`                                                        |
| `mariadb.enabled`                           | Whether to use the MariaDB chart                                                                      | `true`                                                       |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                                  | `standalone`                                                 |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                                  | _random 10 character alphanumeric string_                                                      |
| `mariadb.auth.database`                     | Database name to create                                                                               | `bitnami_prestashop`                                         |
| `mariadb.auth.username`                     | Database user to create                                                                               | `bn_prestashop`                                              |
| `mariadb.auth.password`                     | Password for the database                                                                             | _random 10 character long alphanumeric string_                                                      |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                                 | `true`                                                       |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                              | `nil`                                                        |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                               | `[ReadWriteOnce]`                                            |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                                       | `8Gi`                                                        |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)              | `nil`                                                        |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                                       | `nil`                                                        |
| `externalDatabase.user`                     | Existing username in the external db                                                                  | `bn_prestashop`                                              |
| `externalDatabase.password`                 | Password for the above username                                                                       | `""`                                                         |
| `externalDatabase.database`                 | Name of the existing database                                                                         | `bitnami_prestashop`                                         |
| `externalDatabase.host`                     | Host of the existing database                                                                         | `nil`                                                        |
| `externalDatabase.port`                     | Port of the existing database                                                                         | `3306`                                                       |
| `service.type`                              | Kubernetes Service type                                                                               | `LoadBalancer`                                               |
| `service.port`                              | Service HTTP port                                                                                     | `8080`                                                       |
| `service.httpsPort`                         | Service HTTPS port                                                                                    | `8443`                                                       |
| `service.nodePorts.http`                    | Kubernetes http node port                                                                             | `""`                                                         |
| `service.nodePorts.https`                   | Kubernetes https node port                                                                            | `""`                                                         |
| `service.externalTrafficPolicy              | Enable client source IP preservation                                                                  | `Cluster`                                                    |
| `service.loadBalancerIP`                    | `loadBalancerIP` for the SuiteCRM Service                                                             | `nil`                                                        |
| `persistence.enabled`                       | Enable persistence using PVC                                                                          | `true`                                                       |
| `persistence.storageClass`                  | PVC Storage Class for SuiteCRM volume                                                                 | `nil` (uses alpha storage class annotation)                                                  |
| `persistence.existingClaim`                 | An Existing PVC name for SuiteCRM volume                                                              | `nil` (uses alpha storage class annotation)                                                  |
| `persistence.accessMode`                    | PVC Access Mode for SuiteCRM volume                                                                   | `ReadWriteOnce`                                              |
| `persistence.size`                          | PVC Storage Request for SuiteCRM volume                                                               | `8Gi`                                                        |
| `resources`                                 | CPU/Memory resource requests/limits                                                                   | Memory: `512Mi`, CPU: `300m`                                                       |
| `podAnnotations`                            | Pod annotations                                                                                       | `{}`                                                         |
| `podAffinityPreset`                         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                   | `""`                                                         |
| `podAntiAffinityPreset`                     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`              | `soft`                                                       |
| `nodeAffinityPreset.type`                   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`             | `""`                                                         |
| `nodeAffinityPreset.key`                    | Node label key to match Ignored if `affinity` is set.                                                 | `""`                                                         |
| `nodeAffinityPreset.values`                 | Node label values to match. Ignored if `affinity` is set.                                             | `[]`                                                         |
| `affinity`                                  | Map of node/pod affinities                                                                            | `{}`                                                         |
| `podSecurityContext.enabled`                | Enable securityContext on for DokuWiki deployment                                                     | `true`                                                       |
| `podSecurityContext.fsGroup`                | Group to configure permissions for volumes                                                            | `1001`                                                       |
| `containerSecurityContext.enabled`          | Enable securityContext on for DokuWiki deployment                                                     | `true`                                                       |
| `containerSecurityContext.runAsUser`        | User for the securityContext                                                                          | `1001`                                                       |
| `metrics.enabled`                           | Start a side-car prometheus exporter                                                                  | `false`                                                      |
| `metrics.image.registry`                    | Apache exporter image registry                                                                        | `docker.io`                                                  |
| `metrics.image.repository`                  | Apache exporter image name                                                                            | `bitnami/apache-exporter`                                                    |
| `metrics.image.tag`                         | Apache exporter image tag                                                                             | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                  | Image pull policy                                                                                     | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`                 | Specify docker-registry secret names as an array                                                      | `nil`                                                        |
| `metrics.podAnnotations`                    | Additional annotations for Metrics exporter pod                                                       | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                         | Exporter resource requests/limit                                                                      | {}                                                           |

The above parameters map to the env variables defined in [bitnami/suitecrm](http://github.com/bitnami/bitnami-docker-suitecrm). For more information please refer to the [bitnami/suitecrm](http://github.com/bitnami/bitnami-docker-suitecrm) image documentation.

> **Note**:
>
> For SuiteCRM to function correctly, you should specify the `suitecrmHost` parameter to specify the FQDN (recommended) or the public IP address of the SuiteCRM service.
>
> Optionally, you can specify the `suitecrmLoadBalancerIP` parameter to assign a reserved IP address to the SuiteCRM service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create suitecrm-public-ip
> ```
>
> The reserved IP address can be associated to the SuiteCRM service by specifying it as the value of the `suitecrmLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set suitecrmUsername=admin,suitecrmPassword=password,mariadb.mariadbRootPassword=secretpassword \
    bitnami/suitecrm
```

The above command sets the SuiteCRM administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/suitecrm
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami SuiteCRM](https://github.com/bitnami/bitnami-docker-suitecrm) image stores the SuiteCRM data and configurations at the `/bitnami/suitecrm` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 10.0.0

The [Bitnami SuiteCRM](https://github.com/bitnami/bitnami-docker-suitecrm) image was updated to support and enable the "non-root" user approach

If you want to continue to run the container image as the `root` user, you need to set `podSecurityContext.enabled=false` and `containerSecurity.context.enabled=false`.

This upgrade also adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information.

### 8.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17310 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is suitecrm:

```console
$ kubectl patch deployment suitecrm-suitecrm --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset suitecrm-mariadb --cascade=false
```
