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
- Helm 3.1.0
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
| `image.registry`    | PrestaShop image registry                                                    | `docker.io`                                             |
| `image.repository`  | PrestaShop Image name                                                        | `bitnami/prestashop`                                    |
| `image.tag`         | PrestaShop Image tag                                                         | `{TAG_NAME}`                                            |
| `image.pullPolicy`  | PrestaShop image pull policy                                                 | `IfNotPresent`                                          |
| `image.pullSecrets` | Specify docker-registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`       | Specify if debug logs should be enabled                                      | `false`                                                 |
| `nameOverride`      | String to partially override prestashop.fullname template                    | `nil`                                                   |
| `fullnameOverride`  | String to fully override prestashop.fullname template                        | `nil`                                                   |
| `commonLabels`      | Labels to add to all deployed objects                                        | `nil`                                                   |
| `commonAnnotations` | Annotations to add to all deployed objects                                   | `[]`                                                    |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template). | `nil`                                                   |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)         | `nil`                                                   |

### PrestaShop parameters

| Parameter                            | Description                                                                                                           | Default                                        |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| `affinity`                           | Map of node/pod affinities                                                                                            | `{}`                                           |
| `allowEmptyPassword`                 | Allow DB blank passwords                                                                                              | `yes`                                          |
| `hostAliases`                        | Add deployment host aliases                                                                                           | `Check values.yaml`                            |
| `args`                               | Override default container args (useful when using custom images)                                                     | `nil`                                          |
| `command`                            | Override default container command (useful when using custom images)                                                  | `nil`                                          |
| `containerPorts.http`                | Sets http port inside NGINX container                                                                                 | `8080`                                         |
| `containerPorts.https`               | Sets https port inside NGINX container                                                                                | `8443`                                         |
| `containerSecurityContext.enabled`   | Enable PrestaShop containers' Security Context                                                                        | `true`                                         |
| `containerSecurityContext.runAsUser` | PrestaShop containers' Security Context                                                                               | `1001`                                         |
| `customLivenessProbe`                | Override default liveness probe                                                                                       | `nil`                                          |
| `customReadinessProbe`               | Override default readiness probe                                                                                      | `nil`                                          |
| `customStartupProbe`                 | Override default startup probe                                                                                        | `nil`                                          |
| `existingSecret`                     | Name of a secret with the application password                                                                        | `nil`                                          |
| `extraEnvVarsCM`                     | ConfigMap containing extra env vars                                                                                   | `nil`                                          |
| `extraEnvVarsSecret`                 | Secret containing extra env vars (in case of sensitive data)                                                          | `nil`                                          |
| `extraEnvVars`                       | Extra environment variables                                                                                           | `nil`                                          |
| `extraVolumeMounts`                  | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. | `nil`                                          |
| `extraVolumes`                       | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`    | `nil`                                          |
| `initContainers`                     | Add additional init containers to the pod (evaluated as a template)                                                   | `nil`                                          |
| `lifecycleHooks`                     | LifecycleHook to set additional configuration at startup Evaluated as a template                                      | ``                                             |
| `livenessProbe`                      | Liveness probe configuration                                                                                          | `Check values.yaml file`                       |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                             | `""`                                           |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                                                 | `""`                                           |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                             | `[]`                                           |
| `nodeSelector`                       | Node labels for pod assignment                                                                                        | `{}` (The value is evaluated as a template)    |
| `prestashopHost`                     | PrestaShop host to create application URLs (when ingress, it will be ignored)                                         | `nil`                                          |
| `prestashopUsername`                 | User of the application                                                                                               | `user@example.com`                             |
| `prestashopPassword`                 | Application password                                                                                                  | _random 10 character long alphanumeric string_ |
| `prestashopEmail`                    | Admin email                                                                                                           | `user@example.com`                             |
| `prestashopFirstName`                | First Name                                                                                                            | `Bitnami`                                      |
| `prestashopLastName`                 | Last Name                                                                                                             | `Name`                                         |
| `prestashopCookieCheckIP`            | Whether to check the cookie's IP address or not                                                                       | `no`                                           |
| `prestashopCountry`                  | Default country of the store                                                                                          | `us`                                           |
| `prestashopLanguage`                 | Default language of the store (iso code)                                                                              | `en`                                           |
| `prestashopSkipInstall`              | Skip PrestaShop installation wizard (`no` / `yes`)                                                                    | `false`                                        |
| `persistence.accessMode`             | PVC Access Mode for PrestaShop volume                                                                                 | `ReadWriteOnce`                                |
| `persistence.enabled`                | Enable persistence using PVC                                                                                          | `true`                                         |
| `persistence.existingClaim`          | An Existing PVC name                                                                                                  | `nil`                                          |
| `persistence.hostPath`               | Host mount path for PrestaShop volume                                                                                 | `nil` (will not mount to a host path)          |
| `persistence.size`                   | PVC Storage Request for PrestaShop volume                                                                             | `8Gi`                                          |
| `persistence.storageClass`           | PVC Storage Class for PrestaShop volume                                                                               | `nil` (uses alpha storage class annotation)    |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                   | `""`                                           |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                              | `soft`                                         |
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
| `startupProbe`                       | Startup probe configuration                                                                                           | `Check values.yaml file`                       |
| `tolerations`                        | Tolerations for pod assignment                                                                                        | `[]` (The value is evaluated as a template)    |
| `updateStrategy`                     | Deployment update strategy                                                                                            | `nil`                                          |

### Traffic Exposure Parameters

| Parameter                        | Description                                              | Default                        |
|----------------------------------|----------------------------------------------------------|--------------------------------|
| `service.type`                   | Kubernetes Service type                                  | `LoadBalancer`                 |
| `service.port`                   | Service HTTP port                                        | `80`                           |
| `service.httpsPort`              | Service HTTPS port                                       | `443`                          |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                     | `Cluster`                      |
| `service.nodePorts.http`         | Kubernetes http node port                                | `""`                           |
| `service.nodePorts.https`        | Kubernetes https node port                               | `""`                           |
| `ingress.enabled`                | Enable ingress controller resource                       | `false`                        |
| `ingress.certManager`            | Add annotations for cert-manager                         | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                    | `prestashop.local`             |
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
| `ingress.pathType`               | Ingress path type                                        | `ImplementationSpecific`       |

### Database parameters

| Parameter                                   | Description                                                                              | Default                                        |
|---------------------------------------------|------------------------------------------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                           | Whether to use the MariaDB chart                                                         | `true`                                         |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                     | `standalone`                                   |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                     | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                     | Database name to create                                                                  | `bitnami_prestashop`                           |
| `mariadb.auth.username`                     | Database user to create                                                                  | `bn_prestashop`                                |
| `mariadb.auth.password`                     | Password for the database                                                                | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                    | `true`                                         |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                 | `nil`                                          |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                  | `[ReadWriteOnce]`                              |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                          | `8Gi`                                          |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production) | `nil`                                          |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                          | `nil`                                          |
| `externalDatabase.user`                     | Existing username in the external db                                                     | `bn_prestashop`                                |
| `externalDatabase.password`                 | Password for the above username                                                          | `""`                                           |
| `externalDatabase.database`                 | Name of the existing database                                                            | `bitnami_prestashop`                           |
| `externalDatabase.host`                     | Host of the existing database                                                            | `nil`                                          |
| `externalDatabase.port`                     | Port of the existing database                                                            | `3306`                                         |

### Volume Permissions parameters

| Parameter                             | Description                                                                                                                                               | Default                                                 |
|---------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                          | `docker.io`                                             |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`         | Init container volume-permissions image tag                                                                                                               | `"10"`                                                  |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                |
| `volumePermissions.resources`         | Init container resource requests/limit                                                                                                                    | `nil`                                                   |

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

### Certificate injection parameters

| Parameter                                            | Description                                                          | Default                                  |
|------------------------------------------------------|----------------------------------------------------------------------|------------------------------------------|
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                     | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                  | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                  | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                   | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                   | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain             | `/etc/ssl/certs/chain.pem`               |
| `certificates.customCAs`                             | Defines a list of secrets to import into the container trust store   | `[]`                                     |
| `certificates.image.registry`                        | Container sidecar registry                                           | `docker.io`                              |
| `certificates.image.repository`                      | Container sidecar image                                              | `bitnami/bitnami-shell`                  |
| `certificates.image.tag`                             | Container sidecar image tag                                          | `"10"`                                   |
| `certificates.image.pullPolicy`                      | Container sidecar image pull policy                                  | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Container sidecar image pull secrets                                 | `image.pullSecrets`                      |
| `certificates.args`                                  | Override default container args (useful when using custom images)    | `nil`                                    |
| `certificates.command`                               | Override default container command (useful when using custom images) | `nil`                                    |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables (eg proxy)             | `[]`                                     |
| `certificates.extraEnvVarsCM`                        | ConfigMap containing extra env vars                                  | `nil`                                    |
| `certificates.extraEnvVarsSecret`                    | Secret containing extra env vars (in case of sensitive data)         | `nil`                                    |

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
  --set prestashopUsername=admin,prestashopPassword=password,mariadb.auth.rootPassword=secretpassword \
    bitnami/prestashop
```

The above command sets the PrestaShop administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/prestashop
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Image

The `image` parameter allows specifying which image will be pulled for the chart.

#### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
1. Note that the `imagePullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:

```yaml
imagePullSecrets:
  - name: SECRET_NAME
```

1. Install the chart

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami PrestaShop](https://github.com/bitnami/bitnami-docker-prestashop) image stores the PrestaShop data and configurations at the `/bitnami/prestashop` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
$ helm install my-release --set persistence.existingClaim=PVC_NAME bitnami/prestashop
```

### Host path

#### System compatibility

- The local filesystem accessibility to a container in a pod with `hostPath` has been tested on OSX/MacOS with xhyve, and Linux with VirtualBox.
- Windows has not been tested with the supported VM drivers. Minikube does however officially support [Mounting Host Folders](https://github.com/kubernetes/minikube/blob/master/docs/host_folder_mount.md) per pod. Or you may manually sync your container whenever host files are changed with tools like [docker-sync](https://github.com/EugenMayer/docker-sync) or [docker-bg-sync](https://github.com/cweagans/docker-bg-sync).

#### Mounting steps

1. The specified `hostPath` directory must already exist (create one if it does not).
1. Install the chart

    ```bash
    $ helm install my-release --set persistence.hostPath=/PATH/TO/HOST/MOUNT bitnami/prestashop
    ```

    This will mount the `prestashop-data` volume into the `hostPath` directory. The site data will be persisted if the mount path contains valid data, else the site data will be initialized at first launch.
1. Because the container cannot control the host machine's directory permissions, you must set the PrestaShop file directory permissions yourself and disable or clear PrestaShop cache.

## Troubleshooting

### SSL

One needs to explicitly turn on SSL in the Prestashop administration panel, else a `302` redirect to `http` scheme is returned on any page of the site by default.

To enable SSL on all pages, follow these steps:

- Browse to the administration panel and log in.
- Click “Shop Parameters” in the left navigation panel.
- Set the option “Enable SSL” to “Yes”.
- Click the “Save” button.
- Set the (now enabled) option “Enable SSL on all pages” to “Yes”.
- Click the “Save” button.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 13.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 12.0.0

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

### To 11.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `11.0.0`, you have two alternatives:

- Install a new Prestashop chart, and migrate your Prestashop site using backup/restore using any [Backup and Restore tool from Prestashop marketplace](https://addons.prestashop.com/en/search?search_query=backup&).
- Reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `prestashop`):

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
export PRESTASHOP_PASSWORD=$(kubectl get secret --namespace default prestashop -o jsonpath="{.data.prestashop-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default prestashop-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default prestashop-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=prestashop,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling Prestashop replicas to 0:

```console
$ helm upgrade prestashop bitnami/prestashop --set prestashopPassword=$PRESTASHOP_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 10.0.0
```

Finally, upgrade you release to 11.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade prestashop bitnami/prestashop --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set prestashopPassword=$PRESTASHOP_PASSWORD
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=prestashop,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

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
