# PrestaShop

[PrestaShop](https://prestashop.com/) is a popular open source e-commerce solution. Professional tools are easily accessible to increase online sales including instant guest checkout, abandoned cart reminders and automated Email marketing.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/prestashop
```

## Introduction

This chart bootstraps a [PrestaShop](https://github.com/bitnami/bitnami-docker-prestashop) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the PrestaShop application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/prestashop
```

The command deploys PrestaShop on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the PrestaShop chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                                  | Default                                                 |
|---------------------|------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`    | PrestaShop image registry                                                        | `docker.io`                                         |
| `image.repository`  | PrestaShop Image name                                                            | `bitnami/prestashop`                                |
| `image.tag`         | PrestaShop Image tag                                                             | `{TAG_NAME}`                                        |
| `image.pullPolicy`  | PrestaShop image pull policy                                                     | `IfNotPresent`                                      |
| `image.pullSecrets` | Specify docker-registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`       | Specify if debug logs should be enabled                                      | `false`                                                 |
| `nameOverride`      | String to partially override prestashop.fullname template                        | `nil`                                               |
| `fullnameOverride`  | String to fully override prestashop.fullname template                            | `nil`                                               |
| `commonLabels`      | Labels to add to all deployed objects                                        | `nil`                                                   |
| `commonAnnotations` | Annotations to add to all deployed objects                                   | `[]`                                                    |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template). | `nil`                                                   |

### PrestaShop parameters

| Parameter                            | Description                                                                                                           | Default                                        |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| `affinity`                           | Map of node/pod affinities                                                                                            | `{}`                                           |
| `allowEmptyPassword`                 | Allow DB blank passwords                                                                                              | `yes`                                          |
| `args`                               | Override default container args (useful when using custom images)                                                     | `nil`                                          |
| `command`                            | Override default container command (useful when using custom images)                                                  | `nil`                                          |
| `containerSecurityContext.enabled`   | Enable PrestaShop containers' Security Context                                                                        | `true`                                         |
| `containerSecurityContext.runAsUser` | PrestaShop containers' Security Context                                                                               | `1001`                                         |
| `customLivenessProbe`                | Override default liveness probe                                                                                       | `nil`                                          |
| `customReadinessProbe`               | Override default readiness probe                                                                                      | `nil`                                          |
| `existingSecret`                     | Name of a secret with the application password                                                                        | `nil`                                          |
| `extraEnvVarsCM`                     | ConfigMap containing extra env vars                                                                                   | `nil`                                          |
| `extraEnvVarsSecret`                 | Secret containing extra env vars (in case of sensitive data)                                                          | `nil`                                          |
| `extraEnvVars`                       | Extra environment variables                                                                                           | `nil`                                          |
| `extraVolumeMounts`                  | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. | `nil`                                          |
| `extraVolumes`                       | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`    | `nil`                                          |
| `initContainers`                     | Add additional init containers to the pod (evaluated as a template)                                                   | `nil`                                          |
| `lifecycleHooks`                     | LifecycleHook to set additional configuration at startup Evaluated as a template                                      | ``                                             |
| `livenessProbe`                      | Liveness probe configuration                                                                                          | `Check values.yaml file`                       |
| `prestashopHost`                     | PrestaShop host to create application URLs (when ingress, it will be ignored)                                         | `nil`                                          |
| `prestashopUsername`                 | User of the application                                                                                               | `user@example.com`                             |
| `prestashopPassword`                 | Application password                                                                                                  | _random 10 character long alphanumeric string_ |
| `prestashopEmail`                    | Admin email                                                                                                           | `user@example.com`                             |
| `prestashopFirstName`                | First Name                                                                                                            | `Bitnami`                                      |
| `prestashopLastName`                 | Last Name                                                                                                             | `Name`                                         |
| `prestashopCookieCheckIP`            | Whether to check the cookie's IP address or not                                                                       | `no`                                           |
| `prestashopCountry`                  | Default country of the store                                                                                          | `us`                                           |
| `prestashopLanguage`                 | Default language of the store (iso code)                                                                              | `en`                                           |
| `prestashopSkipInstall`              | Skip PrestaShop installation wizard (`no` / `yes`)                                                                    | `no`                                           |
| `nodeSelector`                       | Node labels for pod assignment                                                                                        | `{}` (The value is evaluated as a template)    |
| `persistence.accessMode`             | PVC Access Mode for PrestaShop volume                                                                                 | `ReadWriteOnce`                                |
| `persistence.enabled`                | Enable persistence using PVC                                                                                          | `true`                                         |
| `persistence.existingClaim`          | An Existing PVC name                                                                                                  | `nil`                                          |
| `persistence.hostPath`               | Host mount path for PrestaShop volume                                                                                 | `nil` (will not mount to a host path)          |
| `persistence.size`                   | PVC Storage Request for PrestaShop volume                                                                             | `8Gi`                                          |
| `persistence.storageClass`           | PVC Storage Class for PrestaShop volume                                                                               | `nil` (uses alpha storage class annotation)    |
| `podAnnotations`                     | Pod annotations                                                                                                       | `{}`                                           |
| `podLabels`                          | Add additional labels to the pod (evaluated as a template)                                                            | `nil`                                          |
| `podSecurityContext.enabled`         | Enable PrestaShop pods' Security Context                                                                              | `true`                                         |
| `podSecurityContext.fsGroup`         | PrestaShop pods' group ID                                                                                             | `1001`                                         |
| `readinessProbe`                     | Readiness probe configuration                                                                                         | `Check values.yaml file`                       |
| `replicaCount`                       | Number of PrestaShop Pods to run                                                                                      | `1`                                            |
| `resources`                          | CPU/Memory resource requests/limits                                                                                   | Memory: `512Mi`, CPU: `300m`                   |
| `sidecars`                           | Attach additional containers to the pod (evaluated as a template)                                                     | `nil`                                          |
| `smtpHost`                           | SMTP host                                                                                                             | `nil`                                          |
| `smtpPort`                           | SMTP port                                                                                                             | `nil` (but prestashop internal default is 25)  |
| `smtpProtocol`                       | SMTP Protocol (options: ssl,tls, nil)                                                                                 | `nil`                                          |
| `smtpUser`                           | SMTP user                                                                                                             | `nil`                                          |
| `smtpPassword`                       | SMTP password                                                                                                         | `nil`                                          |
| `tolerations`                        | Tolerations for pod assignment                                                                                        | `[]` (The value is evaluated as a template)    |
| `updateStrategy`                     | Deployment update strategy                                                                                            | `nil`                                          |

### Traffic Exposure Parameters

| Parameter                        | Description                           | Default            |
|----------------------------------|---------------------------------------|--------------------|
| `service.type`                   | Kubernetes Service type               | `LoadBalancer`     |
| `service.port`                   | Service HTTP port                     | `80`               |
| `service.httpsPort`              | Service HTTPS port                    | `443`              |
| `service.externalTrafficPolicy`  | Enable client source IP preservation  | `Cluster`          |
| `service.nodePorts.http`         | Kubernetes http node port             | `""`               |
| `service.nodePorts.https`        | Kubernetes https node port            | `""`               |
| `ingress.enabled`                | Enable ingress controller resource    | `false`            |
| `ingress.certManager`            | Add annotations for cert-manager      | `false`            |
| `ingress.hostname`               | Default host for the ingress resource | `prestashop.local` |
| `ingress.annotations`            | Ingress annotations                   | `{}`               |
| `ingress.hosts[0].name`          | Hostname to your PrestaShop installation  | `nil`          |
| `ingress.hosts[0].path`          | Path within the url structure         | `nil`              |
| `ingress.tls[0].hosts[0]`        | TLS hosts                             | `nil`              |
| `ingress.tls[0].secretName`      | TLS Secret (certificates)             | `nil`              |
| `ingress.secrets[0].name`        | TLS Secret Name                       | `nil`              |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                | `nil`              |
| `ingress.secrets[0].key`         | TLS Secret Key                        | `nil`              |

### Database parameters

| Parameter                                  | Description                              | Default                                        |
|--------------------------------------------|------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                          | Whether to use the MariaDB chart         | `true`                                         |
| `mariadb.rootUser.password`                | MariaDB admin password                   | `nil`                                          |
| `mariadb.db.name`                          | Database name to create                  | `bitnami_prestashop`                           |
| `mariadb.db.user`                          | Database user to create                  | `bn_prestashop`                                |
| `mariadb.db.password`                      | Password for the database                | _random 10 character long alphanumeric string_ |
| `mariadb.replication.enabled`              | MariaDB replication enabled              | `false`                                        |
| `mariadb.master.persistence.enabled`       | Enable database persistence using PVC    | `true`                                         |
| `mariadb.master.persistence.accessMode`    | Database Persistent Volume Access Modes  | `ReadWriteOnce`                                |
| `mariadb.master.persistence.size`          | Database Persistent Volume Size          | `8Gi`                                          |
| `mariadb.master.persistence.existingClaim` | Enable persistence using an existing PVC | `nil`                                          |
| `mariadb.master.persistence.storageClass`  | PVC Storage Class                        | `nil` (uses alpha storage class annotation)    |
| `mariadb.master.persistence.hostPath`      | Host mount path for MariaDB volume       | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                    | Existing username in the external db     | `bn_prestashop`                                |
| `externalDatabase.password`                | Password for the above username          | `nil`                                          |
| `externalDatabase.database`                | Name of the existing database            | `bitnami_prestashop`                           |
| `externalDatabase.host`                    | Host of the existing database            | `nil`                                          |
| `externalDatabase.port`                    | Port of the existing database            | `3306`                                         |

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
| `metrics.resources`         | Exporter resource requests/limit                 | {}                                                           |

The above parameters map to the env variables defined in [bitnami/prestashop](http://github.com/bitnami/bitnami-docker-prestashop). For more information please refer to the [bitnami/prestashop](http://github.com/bitnami/bitnami-docker-prestashop) image documentation.

> **Note**:
>
> For PrestaShop to function correctly, you should specify the `prestashopHost` parameter to specify the FQDN (recommended) or the public IP address of the PrestaShop service.
>
> Optionally, you can specify the `prestashopLoadBalancerIP` parameter to assign a reserved IP address to the PrestaShop service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create prestashop-public-ip
> ```
>
> The reserved IP address can be associated to the PrestaShop service by specifying it as the value of the `prestashopLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set prestashopUsername=admin,prestashopPassword=password,mariadb.mariadbRootPassword=secretpassword \
    bitnami/prestashop
```

The above command sets the PrestaShop administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/prestashop
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami PrestaShop](https://github.com/bitnami/bitnami-docker-prestashop) image stores the PrestaShop data and configurations at the `/bitnami/prestashop` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 10.0.0

The [Bitnami PrestaShop](https://github.com/bitnami/bitnami-docker-prestashop) image was updated to support and enable the "non-root" user approach

If you want to continue to run the container image as the `root` user, you need to set `podSecurityContext.enabled=false` and `containerSecurity.context.enabled=false`.

This upgrade also adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information.

### To 9.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17308 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is prestashop:

```console
$ kubectl patch deployment prestashop-prestashop --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset prestashop-mariadb --cascade=false
```
