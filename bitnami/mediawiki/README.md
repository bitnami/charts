# MediaWiki

[MediaWiki](https://www.mediawiki.org) is an extremely powerful, scalable software and a feature-rich wiki implementation that uses PHP to process and display data stored in a database, such as MySQL.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mediawiki
```

## Introduction

This chart bootstraps a [MediaWiki](https://github.com/bitnami/bitnami-docker-mediawiki) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the MediaWiki application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/mediawiki
```

The command deploys MediaWiki on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Mediawki chart and their default values per section/component:

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

### Mediawiki parameters

| Parameter            | Description                                                          | Default                                                 |
|----------------------|----------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`     | MediaWiki image registry                                             | `docker.io`                                             |
| `image.repository`   | MediaWiki Image name                                                 | `bitnami/mediawiki`                                     |
| `image.tag`          | MediaWiki Image tag                                                  | `{TAG_NAME}`                                            |
| `image.pullPolicy`   | Image pull policy                                                    | `IfNotPresent`                                          |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                     | `[]` (does not add image pull secrets to deployed pods) |
| `mediawikiUser`      | User of the application                                              | `user`                                                  |
| `mediawikiPassword`  | Application password                                                 | _random 10 character long alphanumeric string_          |
| `mediawikiEmail`     | Admin email                                                          | `user@example.com`                                      |
| `mediawikiName`      | Name for the wiki                                                    | `My Wiki`                                               |
| `mediawikiHost`      | Mediawiki host to create application URLs                            | `nil`                                                   |
| `allowEmptyPassword` | Allow DB blank passwords                                             | `yes`                                                   |
| `hostAliases`        | Add deployment host aliases                                          | `Check values.yaml`                                     |
| `smtpHost`           | SMTP host                                                            | `nil`                                                   |
| `smtpPort`           | SMTP port                                                            | `nil`                                                   |
| `smtpHostID`         | SMTP host ID                                                         | `nil`                                                   |
| `smtpUser`           | SMTP user                                                            | `nil`                                                   |
| `smtpPassword`       | SMTP password                                                        | `nil`                                                   |
| `command`            | Override default container command (useful when using custom images) | `nil`                                                   |
| `args`               | Override default container args (useful when using custom images)    | `nil`                                                   |
| `extraEnvVars`       | Extra environment variables to be set on Mediawki container          | `{}`                                                    |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra env vars                 | `nil`                                                   |
| `extraEnvVarsSecret` | Name of existing Secret containing extra env vars                    | `nil`                                                   |

### Mediawiki deployment parameters

| Parameter                   | Description                                                                               | Default                                     |
|-----------------------------|-------------------------------------------------------------------------------------------|---------------------------------------------|
| `podSecurityContext`        | Mediawki pods' Security Context                                                           | Check `values.yaml` file                    |
| `containerSecurityContext`  | Mediawki containers' Security Context                                                     | Check `values.yaml` file                    |
| `resources.limits`          | The resources limits for the Mediawki container                                           | `{}`                                        |
| `resources.requests`        | The requested resources for the Mediawki container                                        | `{"memory": "512Mi", "cpu": "300m"}`        |
| `livenessProbe`             | Liveness probe configuration for Mediawki                                                 | Check `values.yaml` file                    |
| `readinessProbe`            | Readiness probe configuration for Mediawki                                                | Check `values.yaml` file                    |
| `customLivenessProbe`       | Override default liveness probe                                                           | `nil`                                       |
| `customReadinessProbe`      | Override default readiness probe                                                          | `nil`                                       |
| `updateStrategy`            | Strategy to use to update Pods                                                            | Check `values.yaml` file                    |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                        |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                      |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                        |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                        |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                        |
| `affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template)              |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template)              |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)              |
| `podLabels`                 | Extra labels for Mediawki pods                                                            | `{}` (evaluated as a template)              |
| `podAnnotations`            | Annotations for Mediawki pods                                                             | `{}` (evaluated as a template)              |
| `extraVolumeMounts`         | Optionally specify extra list of additional volumeMounts for Mediawki container(s)        | `[]`                                        |
| `extraVolumes`              | Optionally specify extra list of additional volumes for Mediawki pods                     | `[]`                                        |
| `initContainers`            | Add additional init containers to the Mediawki pods                                       | `{}` (evaluated as a template)              |
| `sidecars`                  | Add additional sidecar containers to the Mediawki pods                                    | `{}` (evaluated as a template)              |
| `persistence.enabled`       | Enable persistence using PVC                                                              | `true`                                      |
| `persistence.storageClass`  | PVC Storage Class for MediaWiki volume                                                    | `nil` (uses alpha storage class annotation) |
| `persistence.existingClaim` | An Existing PVC name for MediaWiki volume                                                 | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`    | PVC Access Mode for MediaWiki volume                                                      | `ReadWriteOnce`                             |
| `persistence.size`          | PVC Storage Request for MediaWiki volume                                                  | `8Gi`                                       |

### Exposure parameters

| Parameter                        | Description                                                   | Default                        |
|----------------------------------|---------------------------------------------------------------|--------------------------------|
| `service.type`                   | Kubernetes Service type                                       | `LoadBalancer`                 |
| `service.loadBalancer`           | Kubernetes LoadBalancerIP to request                          | `nil`                          |
| `service.port`                   | Service HTTP port                                             | `80`                           |
| `service.httpsPort`              | Service HTTPS port                                            | `""`                           |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                          | `Cluster`                      |
| `service.nodePorts.http`         | Kubernetes http node port                                     | `""`                           |
| `service.nodePorts.https`        | Kubernetes https node port                                    | `""`                           |
| `ingress.enabled`                | Enable ingress controller resource                            | `false`                        |
| `ingress.certManager`            | Add annotations for cert-manager                              | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                         | `mediawiki.local`              |
| `ingress.apiVersion`             | Force Ingress API version (automatically detected if not set) | ``                             |
| `ingress.path`                   | Ingress path                                                  | `/`                            |
| `ingress.pathType`               | Ingress path type                                             | `ImplementationSpecific`       |
| `ingress.tls`                    | Create TLS Secret                                             | `false`                        |
| `ingress.annotations`            | Ingress annotations                                           | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`     | Additional hostnames to be covered                            | `nil`                          |
| `ingress.extraHosts[0].path`     | Additional hostnames to be covered                            | `nil`                          |
| `ingress.extraPaths`             | Additional arbitrary path/backend objects                     | `nil`                          |
| `ingress.extraTls[0].hosts[0]`   | TLS configuration for additional hostnames to be covered      | `nil`                          |
| `ingress.extraTls[0].secretName` | TLS configuration for additional hostnames to be covered      | `nil`                          |
| `ingress.secrets[0].name`        | TLS Secret Name                                               | `nil`                          |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                        | `nil`                          |
| `ingress.secrets[0].key`         | TLS Secret Key                                                | `nil`                          |

### Database parameters

| Parameter                                   | Description                                          | Default                                        |
|---------------------------------------------|------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                           | Whether to use the MariaDB chart                     | `true`                                         |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`) | `standalone`                                   |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                 | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                     | Database name to create                              | `bitnami_mediawiki`                            |
| `mariadb.auth.username`                     | Database user to create                              | `bn_mediawiki`                                 |
| `mariadb.auth.password`                     | Password for the database                            | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                | `true`                                         |
| `mariadb.primary.persistence.accessMode`    | Database Persistent Volume Access Modes              | `ReadWriteOnce`                                |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                      | `8Gi`                                          |
| `mariadb.primary.persistence.existingClaim` | Enable persistence using an existing PVC             | `nil`                                          |
| `mariadb.primary.persistence.storageClass`  | PVC Storage Class                                    | `nil` (uses alpha storage class annotation)    |
| `mariadb.primary.persistence.hostPath`      | Host mount path for MariaDB volume                   | `nil` (will not mount to a host path)          |
| `externalDatabase.user`                     | Existing username in the external db                 | `bn_mediawiki`                                 |
| `externalDatabase.password`                 | Password for the above username                      | `nil`                                          |
| `externalDatabase.database`                 | Name of the existing database                        | `bitnami_mediawiki`                            |
| `externalDatabase.host`                     | Host of the existing database                        | `nil`                                          |
| `externalDatabase.port`                     | Port of the existing database                        | `3306`                                         |
| `externalDatabase.existingSecret`           | Name of the database existing Secret Object          | `nil`                                          |

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

The above parameters map to the env variables defined in [bitnami/mediawiki](http://github.com/bitnami/bitnami-docker-mediawiki). For more information please refer to the [bitnami/mediawiki](http://github.com/bitnami/bitnami-docker-mediawiki) image documentation.

> **Note**:
>
> For Mediawiki to function correctly, you should specify the `mediawikiHost` parameter to specify the FQDN (recommended) or the public IP address of the Mediawiki service.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set mediawikiUser=admin,mediawikiPassword=password,mariadb.mariadbRootPassword=secretpassword \
    bitnami/mediawiki
```

The above command sets the MediaWiki administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/mediawiki
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami MediaWiki](https://github.com/bitnami/bitnami-docker-mediawiki) image stores the MediaWiki data and configurations at the `/bitnami/mediawiki` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Mediawki app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

## Upgrading

### To 12.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Mediawki deployment before upgrading (the following example assumes that the release name is `mediawiki`):

```console
$ export APP_HOST=$(kubectl get svc --namespace default mediawiki --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
$ export APP_PASSWORD=$(kubectl get secret --namespace default mediawiki -o jsonpath="{.data.mediawiki-password}" | base64 --decode)
$ export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default mediawiki-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
$ export MARIADB_PASSWORD=$(kubectl get secret --namespace default mediawiki-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
$ kubectl delete deployments.apps mediawiki
$ helm upgrade mediawiki bitnami/mediawiki --set mediawikiHost=$APP_HOST,mediawikiPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD
```

### To 11.0.0

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

To upgrade to `11.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and Mediawiki data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `mediawiki` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and Mediawiki data on your current release:

```console
export MEDIAWIKI_HOST=$(kubectl get svc --namespace default mediawiki --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export MEDIAWIKI_PASSWORD=$(kubectl get secret --namespace default mediawiki -o jsonpath="{.data.mediawiki-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default mediawiki-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default mediawiki-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=mediawiki -o jsonpath="{.items[0].metadata.name}")
```

Delete the Mediawiki deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter:

```console
  $ kubectl delete deployments.apps mediawiki

  $ kubectl delete statefulsets.apps mediawiki-mariadb --cascade=false
```

Now the upgrade works:

```console
$ helm upgrade mediawiki bitnami/mediawiki --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set mediawikiPassword=$MEDIAWIKI_PASSWORD --set mediawikiHost=$MEDIAWIKI_HOST
```

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

  ```console
  $ kubectl delete pod mediawiki-mariadb-0
  ```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=mediawiki,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 10.0.0

The [Bitnami MediaWiki](https://github.com/bitnami/bitnami-docker-mediawiki) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed.

To upgrade to `10.0.0`, backup MediaWiki data and the previous MariaDB databases, install a new MediaWiki chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

### To 9.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17300 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 4.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 4.0.0. The following example assumes that the release name is mediawiki:

```console
$ kubectl patch deployment mediawiki-mediawiki --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset mediawiki-mariadb --cascade=false
```
