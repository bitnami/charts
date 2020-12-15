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
- Helm 3.0-beta3+
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

### Global parameters

| Parameter                                   | Description                                                                                           | Default                                                      |
|---------------------------------------------|-------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                      | Global Docker image registry                                                                          | `nil`                                                        |
| `global.imagePullSecrets`                   | Global Docker registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods)                                                        |
| `global.storageClass`                       | Global storage class for dynamic provisioning                                                         | `nil`                                                        |

### SuiteCRM parameters

| Parameter                                 | Description    | Default                                                                                |
|-------------------------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
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
| `resources`                                 | CPU/Memory resource requests/limits                                                                   | Memory: `512Mi`, CPU: `300m`                                                       |
| `extraEnvVarsCM`                            | ConfigMap containing extra env vars                                                                                   | `[]`                                                        |
| `extraEnvVarsSecret`                        | Secret containing extra env vars (in case of sensitive data)                                                          | `[]`                                                        |
| `extraEnvVars`                              | Extra environment variables                                                                                           | `[]`                                                        |
| `extraVolumeMounts`                         | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. | `[]`                                                        |
| `extraVolumes`                              | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`    | `[]`                                                        |
| `initContainers`                            | Add additional init containers to the pod (evaluated as a template)                                                   | `[]`                                                        |
| `sidecars`                                  | Attach additional containers to the pod (evaluated as a template)                                                     | `[]`                                                        |

### MariaDB parameters

| Parameter                                 | Description    | Default                                                                                |
|-------------------------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| `mariadb.enabled`                           | Whether to use the MariaDB chart                                                                      | `true`                                                       |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                                  | `standalone`                                                 |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                                  | _random 10 character alphanumeric string_                                                      |
| `mariadb.auth.database`                     | Database name to create                                                                               | `bitnami_suitecrm`                                         |
| `mariadb.auth.username`                     | Database user to create                                                                               | `bn_suitecrm`                                              |
| `mariadb.auth.password`                     | Password for the database                                                                             | _random 10 character long alphanumeric string_                                                      |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                                 | `true`                                                       |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                              | `nil`                                                        |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                               | `[ReadWriteOnce]`                                            |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                                       | `8Gi`                                                        |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)              | `nil`                                                        |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                                       | `nil`                                                        |
| `externalDatabase.user`                     | Existing username in the external db                                                                  | `bn_suitecrm`                                              |
| `externalDatabase.password`                 | Password for the above username                                                                       | `""`                                                         |
| `externalDatabase.database`                 | Name of the existing database                                                                         | `bitnami_suitecrm`                                         |
| `externalDatabase.host`                     | Host of the existing database                                                                         | `nil`                                                        |
| `externalDatabase.port`                     | Port of the existing database                                                                         | `3306`                                                       |

### Persistence parameters

| Parameter                                   | Description    | Default                                                                                |
|---------------------------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| `persistence.enabled`                       | Enable persistence using PVC                                                                          | `true`                                                         |
| `persistence.storageClass`                  | PVC Storage Class for SuiteCRM volume                                                                 | `nil` (uses alpha storage class annotation)                                |
| `persistence.existingClaim`                 | An Existing PVC name for SuiteCRM volume                                                              | `nil` (uses alpha storage class annotation)                                |
| `persistence.accessMode`                    | PVC Access Mode for SuiteCRM volume                                                                   | `ReadWriteOnce`                                                |
| `persistence.size`                          | PVC Storage Request for SuiteCRM volume                                                               | `8Gi`                                                          |
| `volumePermissions.enabled`                 | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) |                                          `false`                                                      |
| `volumePermissions.image.registry`          | Init container volume-permissions image registry                                                      | `docker.io`                                                    |
| `volumePermissions.image.repository`        | Init container volume-permissions image name                                                          | `bitnami/minideb`                                                       |
| `volumePermissions.image.tag`               | Init container volume-permissions image tag                                                           | `buster`                                                       |
| `volumePermissions.image.pullSecrets`       | Specify docker-registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods)                       |
| `volumePermissions.image.pullPolicy`        | Init container volume-permissions image pull policy                                                   | `Always`                                                       |
| `volumePermissions.resources`               | Init container resource requests/limit                                                                | `nil`                                                          |

### Exposure parameters

| Parameter                                 | Description    | Default                                                                                |
|-------------------------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| `service.type`                              | Kubernetes Service type                                                                               | `LoadBalancer`                                               |
| `service.port`                              | Service HTTP port                                                                                     | `8080`                                                       |
| `service.httpsPort`                         | Service HTTPS port                                                                                    | `8443`                                                       |
| `service.nodePorts.http`                    | Kubernetes http node port                                                                             | `""`                                                         |
| `service.nodePorts.https`                   | Kubernetes https node port                                                                            | `""`                                                         |
| `service.externalTrafficPolicy              | Enable client source IP preservation                                                                  | `Cluster`                                                    |
| `service.loadBalancerIP`                    | `loadBalancerIP` for the SuiteCRM Service                                                             | `nil`                                                        |
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

### Metrics Parameters

| Parameter                                 | Description    | Default                                                                                |
|-------------------------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| `metrics.enabled`                           | Start a side-car prometheus exporter                                                                  | `false`                                                      |
| `metrics.image.registry`                    | Apache exporter image registry                                                                        | `docker.io`                                                  |
| `metrics.image.repository`                  | Apache exporter image name                                                                            | `bitnami/apache-exporter`                                                    |
| `metrics.image.tag`                         | Apache exporter image tag                                                                             | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                  | Image pull policy                                                                                     | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`                 | Specify docker-registry secret names as an array                                                      | `nil`                                                        |
| `metrics.podAnnotations`                    | Additional annotations for Metrics exporter pod                                                       | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                         | Exporter resource requests/limit                                                                      | {}                                                           |

### Common parameters

| Parameter                                 | Description    | Default                                                                                |
|-------------------------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| `commonAnnotations`                         | Annotations to be added to all deployed resources                                                     | `{}` (evaluated as a template)                                                    |
| `commonLabels`                              | Labels to be added to all deployed resources                                                          | `{}` (evaluated as a template)                                                    |
| `nameOverride`                              | String to partially override suitecrm.fullname template with a string (will prepend the release name) | `nil`                                                        |
| `fullnameOverride`                          | String to fully override suitecrm.fullname template with a string                                     | `nil`                                                        |
| `image.registry`                            | SuiteCRM image registry                                                                               | `docker.io`                                                  |
| `image.repository`                          | SuiteCRM image name                                                                                   | `bitnami/suitecrm`                                                    |
| `image.tag`                                 | SuiteCRM image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                          | Image pull policy                                                                                     | `IfNotPresent`                                               |
| `image.pullSecrets`                         | Specify docker-registry secret names as an array                                                      | `[]` (does not add image pull secrets to deployed pods)                                                        |
| `replicaCount`                              | Number of SuiteCRM replicas                                                                           | `1`                                                          |
| `podAnnotations`                            | Pod annotations                                                                                       | `{}`                                                         |
| `podAffinityPreset`                         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                   | `""`                                                         |
| `podAntiAffinityPreset`                     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`              | `soft`                                                       |
| `nodeAffinityPreset.type`                   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`             | `""`                                                         |
| `nodeAffinityPreset.key`                    | Node label key to match Ignored if `affinity` is set.                                                 | `""`                                                         |
| `nodeAffinityPreset.values`                 | Node label values to match. Ignored if `affinity` is set.                                             | `[]`                                                         |
| `affinity`                                  | Map of node/pod affinities                                                                            | `{}`                                                         |
| `podSecurityContext.enabled`                | Enable securityContext on for SuiteCRM deployment                                                     | `true`                                                       |
| `podSecurityContext.fsGroup`                | Group to configure permissions for volumes                                                            | `1001`                                                       |
| `containerSecurityContext.enabled`          | Enable securityContext on for SuiteCRM deployment                                                     | `true`                                                       |
| `containerSecurityContext.runAsUser`        | User for the securityContext                                                                          | `1001`                                                       |
| `extraDeploy`                               | Array of extra objects to deploy with the release 	                                                  | `[]` (evaluated as a template)                               |

### Database parameters

| Parameter                                  | Description                                           | Default                                        |
|--------------------------------------------|-------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                          | Whether to use the MariaDB chart                      | `true`                                         |
| `mariadb.architecture`                     | MariaDB architecture (`standalone` or `replication`)  | `standalone`                                   |
| `mariadb.auth.rootPassword`                | Password for the MariaDB `root` user                  | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                    | Database name to create                               | `bitnami_suitecrm`                             |
| `mariadb.auth.username`                    | Database user to create                               | `bn_suitecrm`                                  |
| `mariadb.auth.password`                    | Password for the database                             | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`      | Enable database persistence using PVC                 | `true`                                         |
| `mariadb.primary.persistence.accessMode`   | Database Persistent Volume Access Modes               | `ReadWriteOnce`                                |
| `mariadb.primary.persistence.size`         | Database Persistent Volume Size                       | `8Gi`                                          |
| `mariadb.primary.persistence.existingClaim`| Enable persistence using an existing PVC              | `nil`                                          |
| `mariadb.primary.persistence.storageClass` | PVC Storage Class                                     | `nil` (uses alpha storage class annotation)    |
| `mariadb.primary.persistence.hostPath`     | Host mount path for MariaDB volume                    | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                    | Existing username in the external db                  | `bn_suitecrm`                                  |
| `externalDatabase.password`                | Password for the above username                       | `nil`                                          |
| `externalDatabase.database`                | Name of the existing database                         | `bitnami_suitecrm`                             |
| `externalDatabase.host`                    | Host of the existing database                         | `nil`                                          |
| `externalDatabase.port`                    | Port of the existing database                         | `3306`                                         |
| `externalDatabase.existingSecret`          | Name of the database existing Secret Object           | `nil`                                          |

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

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 9.0.0

In this major there were three main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB dependency version
3. Migration to non-root

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

**3. Migration of the SuiteCRM image to non-root **

The [Bitnami SuiteCRM](https://github.com/bitnami/bitnami-docker-suitecrm) image was updated to support and enable the "non-root" user approach

If you want to continue to run the container image as the `root` user, you need to set `podSecurityContext.enabled=false` and `containerSecurity.context.enabled=false`.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed.

To upgrade to `9.0.0`, you can either install a new SuiteCRM chart and migrate your site or reuse the PVCs used to hold both the MariaDB and SuiteCRM data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `suitecrm` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and SuiteCRM data on your current release:

```console
export SUITECRM_HOST=$(kubectl get svc --namespace default suitecrm --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export SUITECRM_PASSWORD=$(kubectl get secret --namespace default suitecrm -o jsonpath="{.data.suitecrm-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default suitecrm-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default suitecrm-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=suitecrm -o jsonpath="{.items[0].metadata.name}")
\```

Upgrade your release (maintaining the version) disabling MariaDB and scaling SuiteCRM replicas to 0:

```console
$ helm upgrade suitecrm bitnami/suitecrm --set suitecrmPassword=$SUITECRM_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 8.0.26
\```

Finally, upgrade your release to `9.0.0` reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade suitecrm bitnami/suitecrm --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set suitecrmPassword=$SUITECRM_PASSWORD --set containerSecurityContext.runAsUser=0 --set podSecurityContext.fsGroup=0
\```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=suitecrm,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

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
