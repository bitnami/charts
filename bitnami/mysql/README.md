# MySQL

[MySQL](https://mysql.com) is a fast, reliable, scalable, and easy to use open-source relational database system. MySQL Server is intended for mission-critical, heavy-load production systems as well as for embedding into mass-deployed software.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mysql
```

## Introduction

This chart bootstraps a [MySQL](https://github.com/bitnami/bitnami-docker-mysql) replication cluster deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mysql
```

These commands deploy MySQL on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the MySQL chart and their default values.

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker Image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                                 | Default         |
|---------------------|-----------------------------------------------------------------------------|-----------------|
| `nameOverride`      | String to partially override common.names.fullname                          | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname                              | `nil`           |
| `clusterDomain`     | Default Kubernetes cluster domain                                           | `cluster.local` |
| `commonLabels`      | Labels to add to all deployed objects                                       | `nil`           |
| `commonAnnotations` | Annotations to add to all deployed objects                                  | `[]`            |
| `schedulerName`     | Name of the scheduler (other than default) to dispatch pods                 | `nil`           |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template) | `nil`           |
| `priorityClassName` | Name of priority class                                                      | `nil`           |

### MySQL common parameters

| Parameter                  | Description                                                                                                                                                                                                                                                             | Default                                                 |
|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`           | MySQL image registry                                                                                                                                                                                                                                                    | `docker.io`                                             |
| `image.repository`         | MySQL image name                                                                                                                                                                                                                                                        | `bitnami/mysql`                                         |
| `image.tag`                | MySQL image tag                                                                                                                                                                                                                                                         | `{TAG_NAME}`                                            |
| `image.pullPolicy`         | MySQL image pull policy                                                                                                                                                                                                                                                 | `IfNotPresent`                                          |
| `image.pullSecrets`        | Specify docker-registry secret names as an array                                                                                                                                                                                                                        | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`              | Specify if debug logs should be enabled                                                                                                                                                                                                                                 | `false`                                                 |
| `architecture`             | MySQL architecture (`standalone` or `replication`)                                                                                                                                                                                                                      | `standalone`                                            |
| `auth.rootPassword`        | Password for the `root` user. Ignored if existing secret is provided.                                                                                                                                                                                                   | _random 10 character alphanumeric string_               |
| `auth.database`            | Name for a custom database to create                                                                                                                                                                                                                                    | `my_database`                                           |
| `auth.username`            | Name for a custom user to create                                                                                                                                                                                                                                        | `""`                                                    |
| `auth.password`            | Password for the new user. Ignored if existing secret is provided                                                                                                                                                                                                       | _random 10 character long alphanumeric string_          |
| `auth.replicationUser`     | MySQL replication user                                                                                                                                                                                                                                                  | `nil`                                                   |
| `auth.replicationPassword` | MySQL replication user password. Ignored if existing secret is provided                                                                                                                                                                                                 | _random 10 character long alphanumeric string_          |
| `auth.forcePassword`       | Force users to specify required passwords                                                                                                                                                                                                                               | `false`                                                 |
| `auth.usePasswordFiles`    | Mount credentials as a files instead of using an environment variable                                                                                                                                                                                                   | `false`                                                 |
| `auth.customPasswordFiles` | Use custom password files when `auth.usePasswordFiles` is set to `true`. Define path for keys `root` and `user`, also define `replicator` if `architecture` is set to `replication`                                                                                     | `{}`                                                    |
| `auth.existingSecret`      | Use existing secret for password details (`auth.rootPassword`, `auth.password`, `auth.replicationPassword` will be ignored and picked up from this secret). The secret has to contain the keys `mysql-root-password`, `mysql-replication-password` and `mysql-password` | `nil`                                                   |
| `initdbScripts`            | Dictionary of initdb scripts                                                                                                                                                                                                                                            | `nil`                                                   |
| `initdbScriptsConfigMap`   | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                                                                                                     | `nil`                                                   |

### MySQL Primary parameters

| Parameter                                    | Description                                                                                                     | Default                        |
|----------------------------------------------|-----------------------------------------------------------------------------------------------------------------|--------------------------------|
| `primary.command`                            | Override default container command on MySQL Primary container(s) (useful when using custom images)              | `nil`                          |
| `primary.args`                               | Override default container args on MySQL Primary container(s) (useful when using custom images)                 | `nil`                          |
| `primary.configuration`                      | MySQL Primary configuration to be injected as ConfigMap                                                         | Check `values.yaml` file       |
| `primary.existingConfigmap`                  | Name of existing ConfigMap with MySQL Primary configuration                                                     | `nil`                          |
| `primary.updateStrategy`                     | Update strategy type for the MySQL primary statefulset                                                          | `RollingUpdate`                |
| `primary.podAnnotations`                     | Additional pod annotations for MySQL primary pods                                                               | `{}` (evaluated as a template) |
| `primary.hostAliases`                        | Add deployment host aliases                                                                                     | `[]`                           |
| `primary.podLabels`                          | Additional pod labels for MySQL primary pods                                                                    | `{}` (evaluated as a template) |
| `primary.podAffinityPreset`                  | MySQL primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `primary.podAntiAffinityPreset`              | MySQL primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `primary.nodeAffinityPreset.type`            | MySQL primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `primary.nodeAffinityPreset.key`             | MySQL primary node label key to match Ignored if `primary.affinity` is set.                                     | `""`                           |
| `primary.nodeAffinityPreset.values`          | MySQL primary node label values to match. Ignored if `primary.affinity` is set.                                 | `[]`                           |
| `primary.affinity`                           | Affinity for MySQL primary pods assignment                                                                      | `{}` (evaluated as a template) |
| `primary.nodeSelector`                       | Node labels for MySQL primary pods assignment                                                                   | `{}` (evaluated as a template) |
| `primary.tolerations`                        | Tolerations for MySQL primary pods assignment                                                                   | `[]` (evaluated as a template) |
| `primary.podSecurityContext.enabled`         | Enable security context for MySQL primary pods                                                                  | `true`                         |
| `primary.podSecurityContext.fsGroup`         | Group ID for the mounted volumes' filesystem                                                                    | `1001`                         |
| `primary.containerSecurityContext.enabled`   | MySQL primary container securityContext                                                                         | `true`                         |
| `primary.containerSecurityContext.runAsUser` | User ID for the MySQL primary container                                                                         | `1001`                         |
| `primary.livenessProbe`                      | Liveness probe configuration for MySQL primary containers                                                       | Check `values.yaml` file       |
| `primary.readinessProbe`                     | Readiness probe configuration for MySQL primary containers                                                      | Check `values.yaml` file       |
| `primary.customLivenessProbe`                | Override default liveness probe for MySQL primary containers                                                    | `nil`                          |
| `primary.customReadinessProbe`               | Override default readiness probe for MySQL primary containers                                                   | `nil`                          |
| `primary.resources.limits`                   | The resources limits for MySQL primary containers                                                               | `{}`                           |
| `primary.resources.requests`                 | The requested resources for MySQL primary containers                                                            | `{}`                           |
| `primary.extraEnvVars`                       | Extra environment variables to be set on MySQL primary containers                                               | `{}`                           |
| `primary.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for MySQL primary containers                               | `nil`                          |
| `primary.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for MySQL primary containers                                  | `nil`                          |
| `primary.extraFlags`                         | MySQL primary additional command line flags                                                                     | `nil`                          |
| `primary.persistence.enabled`                | Enable persistence on MySQL primary replicas using a `PersistentVolumeClaim`                                    | `true`                         |
| `primary.persistence.existingClaim`          | Name of an existing `PersistentVolumeClaim` for MySQL primary replicas                                          | `nil`                          |
| `primary.persistence.annotations`            | MySQL primary persistent volume claim annotations                                                               | `{}` (evaluated as a template) |
| `primary.persistence.storageClass`           | MySQL primary persistent volume storage Class                                                                   | `nil`                          |
| `primary.persistence.accessModes`            | MySQL primary persistent volume access Modes                                                                    | `[ReadWriteOnce]`              |
| `primary.persistence.size`                   | MySQL primary persistent volume size                                                                            | `8Gi`                          |
| `primary.persistence.selector`               | Selector to match an existing Persistent Volume                                                                 | `{}` (evaluated as a template) |
| `primary.initContainers`                     | Add additional init containers for the MySQL Primary pod(s)                                                     | `{}` (evaluated as a template) |
| `primary.sidecars`                           | Add additional sidecar containers for the MySQL Primary pod(s)                                                  | `{}` (evaluated as a template) |
| `primary.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the MySQL Primary container(s)                     | `{}`                           |
| `primary.extraVolumes`                       | Optionally specify extra list of additional volumes to the MySQL Primary pod(s)                                 | `{}`                           |
| `primary.service.type`                       | MySQL Primary K8s service type                                                                                  | `ClusterIP`                    |
| `primary.service.clusterIP`                  | MySQL Primary K8s service clusterIP IP                                                                          | `nil`                          |
| `primary.service.port`                       | MySQL Primary K8s service port                                                                                  | `3306`                         |
| `primary.service.nodePort`                   | MySQL Primary K8s service node port                                                                             | `nil`                          |
| `primary.service.loadBalancerIP`             | MySQL Primary loadBalancerIP if service type is `LoadBalancer`                                                  | `nil`                          |
| `primary.service.externalTrafficPolicy`      | Enable client source IP preservation                                                                            | `Cluster`                      |
| `primary.service.loadBalancerSourceRanges`   | Address that are allowed when MySQL Primary service is LoadBalancer                                             | `[]`                           |
| `primary.pdb.enabled`                        | Enable/disable a Pod Disruption Budget creation for MySQL primary pods                                          | `false`                        |
| `primary.pdb.minAvailable`                   | Minimum number/percentage of MySQL primary pods that should remain scheduled                                    | `1`                            |
| `primary.pdb.maxUnavailable`                 | Maximum number/percentage of MySQL primary pods that may be made unavailable                                    | `nil`                          |

### MySQL Secondary parameters

| Parameter                                      | Description                                                                                                         | Default                        |
|------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|--------------------------------|
| `secondary.command`                            | Override default container command on MySQL Secondary container(s) (useful when using custom images)                | `nil`                          |
| `secondary.args`                               | Override default container args on MySQL Secondary container(s) (useful when using custom images)                   | `nil`                          |
| `secondary.configuration`                      | MySQL Secondary configuration to be injected as ConfigMap                                                           | Check `values.yaml` file       |
| `secondary.existingConfigmap`                  | Name of existing ConfigMap with MySQL Secondary configuration                                                       | `nil`                          |
| `secondary.replicaCount`                       | Number of MySQL secondary replicas                                                                                  | `1`                            |
| `secondary.hostAliases`                        | Add deployment host aliases                                                                                         | `[]`                           |
| `secondary.updateStrategy`                     | Update strategy type for the MySQL secondary statefulset                                                            | `RollingUpdate`                |
| `secondary.podAnnotations`                     | Additional pod annotations for MySQL secondary pods                                                                 | `{}` (evaluated as a template) |
| `secondary.podLabels`                          | Additional pod labels for MySQL secondary pods                                                                      | `{}` (evaluated as a template) |
| `secondary.podAffinityPreset`                  | MySQL secondary pod affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `secondary.podAntiAffinityPreset`              | MySQL secondary pod anti-affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `secondary.nodeAffinityPreset.type`            | MySQL secondary node affinity preset type. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `secondary.nodeAffinityPreset.key`             | MySQL secondary node label key to match Ignored if `secondary.affinity` is set.                                     | `""`                           |
| `secondary.nodeAffinityPreset.values`          | MySQL secondary node label values to match. Ignored if `secondary.affinity` is set.                                 | `[]`                           |
| `secondary.affinity`                           | Affinity for MySQL secondary pods assignment                                                                        | `{}` (evaluated as a template) |
| `secondary.nodeSelector`                       | Node labels for MySQL secondary pods assignment                                                                     | `{}` (evaluated as a template) |
| `secondary.tolerations`                        | Tolerations for MySQL secondary pods assignment                                                                     | `[]` (evaluated as a template) |
| `secondary.podSecurityContext.enabled`         | Enable security context for MySQL secondary pods                                                                    | `true`                         |
| `secondary.podSecurityContext.fsGroup`         | Group ID for the mounted volumes' filesystem                                                                        | `1001`                         |
| `secondary.containerSecurityContext.enabled`   | MySQL secondary container securityContext                                                                           | `true`                         |
| `secondary.containerSecurityContext.runAsUser` | User ID for the MySQL secondary container                                                                           | `1001`                         |
| `secondary.livenessProbe`                      | Liveness probe configuration for MySQL secondary containers                                                         | Check `values.yaml` file       |
| `secondary.readinessProbe`                     | Readiness probe configuration for MySQL secondary containers                                                        | Check `values.yaml` file       |
| `secondary.customLivenessProbe`                | Override default liveness probe for MySQL secondary containers                                                      | `nil`                          |
| `secondary.customReadinessProbe`               | Override default readiness probe for MySQL secondary containers                                                     | `nil`                          |
| `secondary.resources.limits`                   | The resources limits for MySQL secondary containers                                                                 | `{}`                           |
| `secondary.resources.requests`                 | The requested resources for MySQL secondary containers                                                              | `{}`                           |
| `secondary.extraEnvVars`                       | Extra environment variables to be set on MySQL secondary containers                                                 | `{}`                           |
| `secondary.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for MySQL secondary containers                                 | `nil`                          |
| `secondary.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for MySQL secondary containers                                    | `nil`                          |
| `secondary.extraFlags`                         | MySQL secondary additional command line flags                                                                       | `nil`                          |
| `secondary.persistence.enabled`                | Enable persistence on MySQL secondary replicas using a `PersistentVolumeClaim`                                      | `true`                         |
| `secondary.persistence.annotations`            | MySQL secondary persistent volume claim annotations                                                                 | `{}` (evaluated as a template) |
| `secondary.persistence.storageClass`           | MySQL secondary persistent volume storage Class                                                                     | `nil`                          |
| `secondary.persistence.accessModes`            | MySQL secondary persistent volume access Modes                                                                      | `[ReadWriteOnce]`              |
| `secondary.persistence.size`                   | MySQL secondary persistent volume size                                                                              | `8Gi`                          |
| `secondary.persistence.selector`               | Selector to match an existing Persistent Volume                                                                     | `{}` (evaluated as a template) |
| `secondary.initContainers`                     | Add additional init containers for the MySQL secondary pod(s)                                                       | `{}` (evaluated as a template) |
| `secondary.sidecars`                           | Add additional sidecar containers for the MySQL secondary pod(s)                                                    | `{}` (evaluated as a template) |
| `secondary.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the MySQL secondary container(s)                       | `{}`                           |
| `secondary.extraVolumes`                       | Optionally specify extra list of additional volumes to the MySQL secondary pod(s)                                   | `{}`                           |
| `secondary.service.type`                       | MySQL secondary K8s service type                                                                                    | `ClusterIP`                    |
| `secondary.service.clusterIP`                  | MySQL secondary K8s service clusterIP IP                                                                            | `nil`                          |
| `secondary.service.port`                       | MySQL secondary K8s service port                                                                                    | `3306`                         |
| `secondary.service.nodePort`                   | MySQL secondary K8s service node port                                                                               | `nil`                          |
| `secondary.service.loadBalancerIP`             | MySQL secondary loadBalancerIP if service type is `LoadBalancer`                                                    | `nil`                          |
| `secondary.service.externalTrafficPolicy`      | Enable client source IP preservation                                                                                | `Cluster`                      |
| `secondary.service.loadBalancerSourceRanges`   | Address that are allowed when MySQL secondary service is LoadBalancer                                               | `[]`                           |
| `secondary.pdb.enabled`                        | Enable/disable a Pod Disruption Budget creation for MySQL secondary pods                                            | `false`                        |
| `secondary.pdb.minAvailable`                   | Minimum number/percentage of MySQL secondary pods that should remain scheduled                                      | `1`                            |
| `secondary.pdb.maxUnavailable`                 | Maximum number/percentage of MySQL secondary pods that may be made unavailable                                      | `nil`                          |

### RBAC parameters

| Parameter                    | Description                                            | Default                                              |
|------------------------------|--------------------------------------------------------|------------------------------------------------------|
| `serviceAccount.create`      | Enable the creation of a ServiceAccount for MySQL pods | `true`                                               |
| `serviceAccount.name`        | Name of the created ServiceAccount                     | Generated using the `common.names.fullname` template |
| `serviceAccount.annotations` | Annotations for MySQL Service Account                  | `{}` (evaluated as a template)                       |
| `rbac.create`                | Weather to create & use RBAC resources or not          | `false`                                              |

### Volume Permissions parameters

| Parameter                              | Description                                                                                                          | Default                                                 |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`            | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                     | `docker.io`                                             |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                                                         | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                                                          | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                  | `Always`                                                |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.resources.limits`   | Init container volume-permissions resource  limits                                                                   | `{}`                                                    |
| `volumePermissions.resources.requests` | Init container volume-permissions resource  requests                                                                 | `{}`                                                    |

### Metrics parameters

| Parameter                                 | Description                                                                         | Default                                                      |
|-------------------------------------------|-------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                         | Start a side-car prometheus exporter                                                | `false`                                                      |
| `metrics.image.registry`                  | Exporter image registry                                                             | `docker.io`                                                  |
| `metrics.image.repository`                | Exporter image name                                                                 | `bitnami/mysqld-exporter`                                    |
| `metrics.image.tag`                       | Exporter image tag                                                                  | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                | Exporter image pull policy                                                          | `IfNotPresent`                                               |
| `metrics.extraArgs.primary`               | Extra args to be passed to mysqld_exporter on Primary pods                          | `[]`                                                         |
| `metrics.extraArgs.secondary`             | Extra args to be passed to mysqld_exporter on Secondary pods                        | `[]`                                                         |
| `metrics.service.type`                    | Kubernetes service type for MySQL Prometheus Exporter                               | `ClusterIP`                                                  |
| `metrics.service.port`                    | MySQL Prometheus Exporter service port                                              | `9104`                                                       |
| `metrics.service.annotations`             | Prometheus exporter svc annotations                                                 | `{prometheus.io/scrape: "true", prometheus.io/port: "9104"}` |
| `metrics.resources.limits`                | The resources limits for MySQL prometheus exporter containers                       | `{}`                                                         |
| `metrics.resources.requests`              | The requested resources for MySQL prometheus exporter containers                    | `{}`                                                         |
| `metrics.livenessProbe`                   | Liveness probe configuration for MySQL prometheus exporter containers               | Check `values.yaml` file                                     |
| `metrics.readinessProbe`                  | Readiness probe configuration for MySQL prometheus exporter containers              | Check `values.yaml` file                                     |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator        | `false`                                                      |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                            | `nil`                                                        |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                         | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                 | `nil`                                                        |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                           | `nil`                                                        |
| `metrics.serviceMonitor.honorLabels`      | honorLabels chooses the metric's labels on collisions with target labels.           | `false`                                                      |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator          | `{}`                                                         |
| `metrics.serviceMonitor.release`          | Used to pass Labels release that sometimes should be custom for Prometheus Operator | `nil`                                                        |

The above parameters map to the env variables defined in [bitnami/mysql](http://github.com/bitnami/bitnami-docker-mysql). For more information please refer to the [bitnami/mysql](http://github.com/bitnami/bitnami-docker-mysql) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set auth.rootPassword=secretpassword,auth.database=app_database \
    bitnami/mysql
```

The above command sets the MySQL `root` account password to `secretpassword`. Additionally it creates a database named `app_database`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/mysql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change MySQL version

To modify the MySQL version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/mysql/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Customize a new MySQL instance

The [Bitnami MySQL](https://github.com/bitnami/bitnami-docker-mysql) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

These scripts are treated differently depending on their extension. While `.sh` scripts are executed on all the nodes, `.sql` and `.sql.gz` scripts are only executed on the primary nodes. This is because `.sh` scripts support conditional tests to identify the type of node they are running on, while such tests are not supported in `.sql` or `sql.gz` files.

Refer to the [chart documentation for more information and a usage example](http://docs.bitnami.com/kubernetes/infrastructure/mysql/configuration/customize-new-instance/).

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as MySQL, you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

## Persistence

The [Bitnami MySQL](https://github.com/bitnami/bitnami-docker-mysql) image stores the MySQL data and configurations at the `/bitnami/mysql` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning by default. An existing PersistentVolumeClaim can also be defined for this purpose.

[Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/mysql/configuration/chart-persistence/).

## Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to set the `auth.rootPassword` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Administrator credentials' section. Please note down the password and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/mysql --set auth.rootPassword=[ROOT_PASSWORD]
```

| Note: you need to substitute the placeholder _[ROOT_PASSWORD]_ with the value obtained in the installation notes.

### To 8.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - The terms *master* and *slave* have been replaced by the terms *primary* and *secondary*. Therefore, parameters prefixed with `master` or `slave` are now prefixed with `primary` or `secondary`, respectively.
  - Credentials parameters are reorganized under the `auth` parameter.
  - `replication.enabled` parameter is deprecated in favor of `architecture` parameter that accepts two values: `standalone` and `replication`.
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. To upgrade to `8.0.0`, install a new release of the MySQL chart, and migrate the data from your previous release. You have 2 alternatives to do so:
  - Create a backup of the database, and restore it on the new release using tools such as [mysqldump](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html).
  - Reuse the PVC used to hold the master data on your previous release. To do so, use the `primary.persistence.existingClaim` parameter. The following example assumes that the release name is `mysql`:

```bash
$ helm install mysql bitnami/mysql --set auth.rootPassword=[ROOT_PASSWORD] --set primary.persistence.existingClaim=[EXISTING_PVC]
```

| Note: you need to substitute the placeholder _[EXISTING_PVC]_ with the name of the PVC used on your previous release, and _[ROOT_PASSWORD]_ with the root password used in your previous release.

### To 7.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/mysql/administration/upgrade-helm3/).

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is mysql:

```console
$ kubectl delete statefulset mysql-master --cascade=false
$ kubectl delete statefulset mysql-slave --cascade=false
```
