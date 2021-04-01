# phpBB

[phpBB](https://www.phpbb.com/) is an Internet forum package written in the PHP scripting language. The name "phpBB" is an abbreviation of PHP Bulletin Board.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/phpbb
```

## Introduction

This chart bootstraps a [phpBB](https://github.com/bitnami/bitnami-docker-phpbb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the phpBB application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/phpbb
```

The command deploys phpBB on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the phpBB chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                                  | Default                                                 |
|---------------------|------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`    | phpBB image registry                                                         | `docker.io`                                             |
| `image.repository`  | phpBB Image name                                                             | `bitnami/phpbb`                                         |
| `image.tag`         | phpBB Image tag                                                              | `{TAG_NAME}`                                            |
| `image.pullPolicy`  | phpBB image pull policy                                                      | `IfNotPresent`                                          |
| `image.pullSecrets` | Specify docker-registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`       | Specify if debug logs should be enabled                                      | `false`                                                 |
| `nameOverride`      | String to partially override common.names.fullname template                  | `nil`                                                   |
| `fullnameOverride`  | String to fully override common.names.fullname template                      | `nil`                                                   |
| `commonLabels`      | Labels to add to all deployed objects                                        | `nil`                                                   |
| `commonAnnotations` | Annotations to add to all deployed objects                                   | `[]`                                                    |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template). | `nil`                                                   |

### phpBB parameters

| Parameter                            | Description                                                                                                                                               | Default                                     |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `affinity`                           | Map of node/pod affinities                                                                                                                                | `{}`                                        |
| `allowEmptyPassword`                 | Allow DB blank passwords                                                                                                                                  | `yes`                                       |
| `args`                               | Override default container args (useful when using custom images)                                                                                         | `nil`                                       |
| `command`                            | Override default container command (useful when using custom images)                                                                                      | `nil`                                       |
| `hostAliases`                        | Add deployment host aliases                                                                                                                               | `Check values.yaml`                         |
| `containerSecurityContext.enabled`   | Enable phpBB containers' Security Context                                                                                                                 | `true`                                      |
| `containerSecurityContext.runAsUser` | phpBB containers' Security Context                                                                                                                        | `1001`                                      |
| `customLivenessProbe`                | Override default liveness probe                                                                                                                           | `nil`                                       |
| `customReadinessProbe`               | Override default readiness probe                                                                                                                          | `nil`                                       |
| `existingSecret`                     | Name of a secret with the application password                                                                                                            | `nil`                                       |
| `extraEnvVarsCM`                     | ConfigMap containing extra env vars                                                                                                                       | `nil`                                       |
| `extraEnvVarsSecret`                 | Secret containing extra env vars (in case of sensitive data)                                                                                              | `nil`                                       |
| `extraEnvVars`                       | Extra environment variables                                                                                                                               | `nil`                                       |
| `extraVolumeMounts`                  | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`.                                     | `nil`                                       |
| `extraVolumes`                       | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts`                                        | `nil`                                       |
| `initContainers`                     | Add additional init containers to the pod (evaluated as a template)                                                                                       | `nil`                                       |
| `lifecycleHooks`                     | LifecycleHook to set additional configuration at startup Evaluated as a template                                                                          | ``                                          |
| `livenessProbe`                      | Liveness probe configuration                                                                                                                              | `Check values.yaml file`                    |
| `volumePermissions.enabled`          | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                     |
| `volumePermissions.image.registry`   | Init container volume-permissions image registry                                                                                                          | `docker.io`                                 |
| `volumePermissions.image.repository` | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell`                     |
| `volumePermissions.image.tag`        | Init container volume-permissions image tag                                                                                                               | `"10"`                                      |
| `volumePermissions.image.pullPolicy` | Init container volume-permissions image pull policy                                                                                                       | `Always`                                    |
| `volumePermissions.resources`        | Init container resource requests/limit                                                                                                                    | `nil`                                       |
| `phpbbSkipInstall`                   | Skip phpbb bootstrap (`no` / `yes`)                                                                                                                       | `no`                                        |
| `phpbbUsername`                      | User of the application                                                                                                                                   | `user`                                      |
| `phpbbPassword`                      | Application password                                                                                                                                      | _random 10 character alphanumeric string_   |
| `phpbbEmail`                         | Admin email                                                                                                                                               | `user@example.com`                          |
| `phpbbDisableSessionValidation`      | Disable session validation                                                                                                                                | `yes`                                       |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                 | `""`                                        |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                                                                                     | `""`                                        |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                                                                 | `[]`                                        |
| `nodeSelector`                       | Node labels for pod assignment                                                                                                                            | `{}` (The value is evaluated as a template) |
| `persistence.accessMode`             | PVC Access Mode for phpBB volume                                                                                                                          | `ReadWriteOnce`                             |
| `persistence.enabled`                | Enable persistence using PVC                                                                                                                              | `true`                                      |
| `persistence.existingClaim`          | An Existing PVC name                                                                                                                                      | `nil`                                       |
| `persistence.hostPath`               | Host mount path for phpBB volume                                                                                                                          | `nil` (will not mount to a host path)       |
| `persistence.size`                   | PVC Storage Request for phpBB volume                                                                                                                      | `8Gi`                                       |
| `persistence.storageClass`           | PVC Storage Class for phpBB volume                                                                                                                        | `nil` (uses alpha storage class annotation) |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                                        |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `soft`                                      |
| `podAnnotations`                     | Pod annotations                                                                                                                                           | `{}`                                        |
| `podLabels`                          | Add additional labels to the pod (evaluated as a template)                                                                                                | `nil`                                       |
| `podSecurityContext.enabled`         | Enable phpBB pods' Security Context                                                                                                                       | `true`                                      |
| `podSecurityContext.fsGroup`         | phpBB pods' group ID                                                                                                                                      | `1001`                                      |
| `priorityClassName`                  | Define the priority class name to use for the phpbb pods here.                                                                                            | `""`                                        |
| `readinessProbe`                     | Readiness probe configuration                                                                                                                             | `Check values.yaml file`                    |
| `replicaCount`                       | Number of phpBB Pods to run                                                                                                                               | `1`                                         |
| `resources`                          | CPU/Memory resource requests/limits                                                                                                                       | Memory: `512Mi`, CPU: `300m`                |
| `sidecars`                           | Attach additional containers to the pod (evaluated as a template)                                                                                         | `nil`                                       |
| `smtpHost`                           | SMTP host                                                                                                                                                 | `nil`                                       |
| `smtpPort`                           | SMTP port                                                                                                                                                 | `nil` (but phpbb internal default is 25)    |
| `smtpProtocol`                       | SMTP Protocol (options: ssl,tls, nil)                                                                                                                     | `nil`                                       |
| `smtpUser`                           | SMTP user                                                                                                                                                 | `nil`                                       |
| `smtpPassword`                       | SMTP password                                                                                                                                             | `nil`                                       |
| `tolerations`                        | Tolerations for pod assignment                                                                                                                            | `[]` (The value is evaluated as a template) |
| `updateStrategy`                     | Deployment update strategy                                                                                                                                | `nil`                                       |

### Traffic Exposure Parameters

| Parameter                        | Description                                              | Default                        |
|----------------------------------|----------------------------------------------------------|--------------------------------|
| `service.type`                   | Kubernetes Service type                                  | `LoadBalancer`                 |
| `service.port`                   | Service HTTP port                                        | `80`                           |
| `service.httpsPort`              | Service HTTPS port                                       | `443`                          |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                     | `Cluster`                      |
| `service.nodePorts.http`         | Kubernetes http node port                                | `""`                           |
| `service.nodePorts.https`        | Kubernetes https node port                               | `""`                           |
| `service.loadBalancerIP`         | loadBalancerIP for phpBB Service                         | `nil`                          |
| `ingress.enabled`                | Enable ingress controller resource                       | `false`                        |
| `ingress.certManager`            | Add annotations for cert-manager                         | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                    | `phpbb.local`                  |
| `ingress.path`                   | Default path for the ingress resource                    | `/`                            |
| `ingress.pathType`               | Ingress path type                                        | `ImplementationSpecific`       |
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

| Parameter                                   | Description                                                              | Default                                        |
|---------------------------------------------|--------------------------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                           | Whether to use the MariaDB chart                                         | `true`                                         |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                     | `standalone`                                   |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                     | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                     | Database name to create                                                  | `bitnami_phpbb`                                |
| `mariadb.auth.username`                     | Database user to create                                                  | `bn_phpbb`                                     |
| `mariadb.auth.password`                     | Password for the database                                                | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                    | `true`                                         |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas | `nil`                                          |
| `mariadb.primary.persistence.accessMode`    | Database Persistent Volume Access Modes                                  | `[ReadWriteOnce]`                              |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                          | `8Gi`                                          |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                          | `nil` (uses alpha storage class annotation)    |
| `mariadb.primary.persistence.hostPath`      | Host mount path for MariaDB volume                                       | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                     | Existing username in the external db                                     | `bn_phpbb`                                     |
| `externalDatabase.password`                 | Password for the above username                                          | `nil`                                          |
| `externalDatabase.database`                 | Name of the existing database                                            | `bitnami_phpbb`                                |
| `externalDatabase.host`                     | Host of the existing database                                            | `nil`                                          |
| `externalDatabase.port`                     | Port of the existing database                                            | `3306`                                         |
| `externalDatabase.existingSecret`           | Name of the database existing Secret Object                              | `nil`                                          |

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

The above parameters map to the env variables defined in [bitnami/phpbb](http://github.com/bitnami/bitnami-docker-phpbb). For more information please refer to the [bitnami/phpbb](http://github.com/bitnami/bitnami-docker-phpbb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set phpbbUsername=admin,phpbbPassword=password,mariadb.mariadbRootPassword=secretpassword \
    bitnami/phpbb
```

The above command sets the phpBB administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/phpbb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress without TLS

For using ingress (example without TLS):

```console
ingress.enabled=True
ingress.hosts[0]=phpbb.domain.com
serviceType=ClusterIP
phpbbUsername=admin
phpbbPassword=password
mariadb.mariadbRootPassword=secretpassword
```

These are the *3 mandatory parameters* when *Ingress* is desired: `ingress.enabled=True`, `ingress.hosts[0]=phpbb.domain.com` and `serviceType=ClusterIP`

### Ingress TLS

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret (named `phpbb-server-tls` in this example) in the namespace. Include the secret's name, along with the desired hostnames, in the Ingress TLS section of your custom `values.yaml` file:

```yaml
ingress:
  ## If true, phpBB server Ingress will be created
  ##
  enabled: true

  ## phpBB server Ingress annotations
  ##
  annotations: {}
  #   kubernetes.io/ingress.class: nginx
  #   kubernetes.io/tls-acme: 'true'

  ## phpBB server Ingress hostnames
  ## Must be provided if Ingress is enabled
  ##
  hosts:
    - phpbb.domain.com

  ## phpBB server Ingress TLS configuration
  ## Secrets must be manually created in the namespace
  ##
  tls:
    - secretName: phpbb-server-tls
      hosts:
        - phpbb.domain.com
```

## Persistence

The [Bitnami phpBB](https://github.com/bitnami/bitnami-docker-phpbb) image stores the phpBB data and configurations at the `/bitnami/phpbb` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, vpshere, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.
You may want to review the [PV reclaim policy](https://kubernetes.io/docs/tasks/administer-cluster/change-pv-reclaim-policy/) and update as required. By default, it's set to delete, and when phpBB is uninstalled, data is also removed.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 10.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 9.0.0

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

To upgrade to `9.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and phpBB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `phpbb`):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and phpBB data on your current release:

```console
export PHPBB_PASSWORD=$(kubectl get secret --namespace default phpbb -o jsonpath="{.data.phpbb-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default phpbb-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default phpbb-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=phpbb -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling phpBB replicas to 0:

```console
$ helm upgrade phpbb bitnami/phpbb --set phpbbPassword=$PHPBB_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 8.0.5
```

Finally, upgrade you release to 9.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade phpbb bitnami/phpbb --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set phpbbPassword=$PHPBB_PASSWORD
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=phpbb,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 8.0.0

The [Bitnami phpBB](https://github.com/bitnami/bitnami-docker-phpbb) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed.

To upgrade to `8.0.0`, backup phpBB data and the previous MariaDB databases, install a new phpBB chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

This upgrade also adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information.

### 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17307 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is phpbb:

```console
$ kubectl patch deployment phpbb-phpbb --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset phpbb-mariadb --cascade=false
```
