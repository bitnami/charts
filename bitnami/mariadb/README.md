# MariaDB

[MariaDB](https://mariadb.org) is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, Facebook and Google.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mariadb
```

## Introduction

This chart bootstraps a [MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) replication cluster deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/mariadb
```

The command deploys MariaDB on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the MariaDB chart and their default values.

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker Image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                                 | Default         |
|---------------------|-----------------------------------------------------------------------------|-----------------|
| `nameOverride`      | String to partially override mariadb.fullname                               | `nil`           |
| `fullnameOverride`  | String to fully override mariadb.fullname                                   | `nil`           |
| `clusterDomain`     | Default Kubernetes cluster domain                                           | `cluster.local` |
| `commonLabels`      | Labels to add to all deployed objects                                       | `nil`           |
| `commonAnnotations` | Annotations to add to all deployed objects                                  | `[]`            |
| `schedulerName`     | Name of the scheduler (other than default) to dispatch pods                 | `nil`           |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template) | `nil`           |

### MariaDB common parameters

| Parameter                  | Description                                                                                                                                                                                                                                                                   | Default                                                 |
|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`           | MariaDB image registry                                                                                                                                                                                                                                                        | `docker.io`                                             |
| `image.repository`         | MariaDB image name                                                                                                                                                                                                                                                            | `bitnami/mariadb`                                       |
| `image.tag`                | MariaDB image tag                                                                                                                                                                                                                                                             | `{TAG_NAME}`                                            |
| `image.pullPolicy`         | MariaDB image pull policy                                                                                                                                                                                                                                                     | `IfNotPresent`                                          |
| `image.pullSecrets`        | Specify docker-registry secret names as an array                                                                                                                                                                                                                              | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`              | Specify if debug logs should be enabled                                                                                                                                                                                                                                       | `false`                                                 |
| `architecture`             | MariaDB architecture (`standalone` or `replication`)                                                                                                                                                                                                                          | `standalone`                                            |
| `auth.rootPassword`        | Password for the `root` user. Ignored if existing secret is provided.                                                                                                                                                                                                         | _random 10 character alphanumeric string_               |
| `auth.database`            | Name for a custom database to create                                                                                                                                                                                                                                          | `my_database`                                           |
| `auth.username`            | Name for a custom user to create                                                                                                                                                                                                                                              | `""`                                                    |
| `auth.password`            | Password for the new user. Ignored if existing secret is provided                                                                                                                                                                                                             | _random 10 character long alphanumeric string_          |
| `auth.replicationUser`     | MariaDB replication user                                                                                                                                                                                                                                                      | `nil`                                                   |
| `auth.replicationPassword` | MariaDB replication user password. Ignored if existing secret is provided                                                                                                                                                                                                     | _random 10 character long alphanumeric string_          |
| `auth.forcePassword`       | Force users to specify required passwords                                                                                                                                                                                                                                     | `false`                                                 |
| `auth.usePasswordFiles`    | Mount credentials as a files instead of using an environment variable                                                                                                                                                                                                         | `false`                                                 |
| `auth.customPasswordFiles` | Use custom password files when `auth.usePasswordFiles` is set to `true`. Define path for keys `root` and `user`, also define `replicator` if `architecture` is set to `replication`                                                                                           | `{}`                                                    |
| `auth.existingSecret`      | Use existing secret for password details (`auth.rootPassword`, `auth.password`, `auth.replicationPassword` will be ignored and picked up from this secret). The secret has to contain the keys `mariadb-root-password`, `mariadb-replication-password` and `mariadb-password` | `nil`                                                   |
| `initdbScripts`            | Dictionary of initdb scripts                                                                                                                                                                                                                                                  | `nil`                                                   |
| `initdbScriptsConfigMap`   | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`)                                                                                                                                                                                                           | `nil`                                                   |

### MariaDB Primary parameters

| Parameter                                    | Description                                                                                                       | Default                        |
|----------------------------------------------|-------------------------------------------------------------------------------------------------------------------|--------------------------------|
| `primary.command`                            | Override default container command on MariaDB Primary container(s) (useful when using custom images)              | `nil`                          |
| `primary.args`                               | Override default container args on MariaDB Primary container(s) (useful when using custom images)                 | `nil`                          |
| `primary.configuration`                      | MariaDB Primary configuration to be injected as ConfigMap                                                         | Check `values.yaml` file       |
| `primary.existingConfigmap`                  | Name of existing ConfigMap with MariaDB Primary configuration                                                     | `nil`                          |
| `primary.hostAliases`                        | Add deployment host aliases                                                                                       | `[]`                           |
| `primary.updateStrategy`                     | Update strategy type for the MariaDB primary statefulset                                                          | `RollingUpdate`                |
| `primary.podAnnotations`                     | Additional pod annotations for MariaDB primary pods                                                               | `{}` (evaluated as a template) |
| `primary.podLabels`                          | Additional pod labels for MariaDB primary pods                                                                    | `{}` (evaluated as a template) |
| `primary.podAffinityPreset`                  | MariaDB primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `primary.podAntiAffinityPreset`              | MariaDB primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `primary.nodeAffinityPreset.type`            | MariaDB primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `primary.nodeAffinityPreset.key`             | MariaDB primary node label key to match Ignored if `primary.affinity` is set.                                     | `""`                           |
| `primary.nodeAffinityPreset.values`          | MariaDB primary node label values to match. Ignored if `primary.affinity` is set.                                 | `[]`                           |
| `primary.affinity`                           | Affinity for MariaDB primary pods assignment                                                                      | `{}` (evaluated as a template) |
| `primary.nodeSelector`                       | Node labels for MariaDB primary pods assignment                                                                   | `{}` (evaluated as a template) |
| `primary.tolerations`                        | Tolerations for MariaDB primary pods assignment                                                                   | `[]` (evaluated as a template) |
| `primary.priorityClassName`                  | Priority class for MariaDB primary pods assignment                                                                | `nil`                          |
| `primary.podSecurityContext.enabled`         | Enable security context for MariaDB primary pods                                                                  | `true`                         |
| `primary.podSecurityContext.fsGroup`         | Group ID for the mounted volumes' filesystem                                                                      | `1001`                         |
| `primary.containerSecurityContext.enabled`   | MariaDB primary container securityContext                                                                         | `true`                         |
| `primary.containerSecurityContext.runAsUser` | User ID for the MariaDB primary container                                                                         | `1001`                         |
| `primary.livenessProbe`                      | Liveness probe configuration for MariaDB primary containers                                                       | Check `values.yaml` file       |
| `primary.readinessProbe`                     | Readiness probe configuration for MariaDB primary containers                                                      | Check `values.yaml` file       |
| `primary.customLivenessProbe`                | Override default liveness probe for MariaDB primary containers                                                    | `nil`                          |
| `primary.customReadinessProbe`               | Override default readiness probe for MariaDB primary containers                                                   | `nil`                          |
| `primary.resources.limits`                   | The resources limits for MariaDB primary containers                                                               | `{}`                           |
| `primary.resources.requests`                 | The requested resources for MariaDB primary containers                                                            | `{}`                           |
| `primary.extraEnvVars`                       | Extra environment variables to be set on MariaDB primary containers                                               | `{}`                           |
| `primary.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for MariaDB primary containers                               | `nil`                          |
| `primary.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for MariaDB primary containers                                  | `nil`                          |
| `primary.extraFlags`                         | MariaDB primary additional command line flags                                                                     | `nil`                          |
| `primary.persistence.enabled`                | Enable persistence on MariaDB primary replicas using a `PersistentVolumeClaim`                                    | `true`                         |
| `primary.persistence.existingClaim`          | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                                          | `nil`                          |
| `primary.persistence.subPath`                | Subdirectory of the volume to mount at                                                                            | `nil`                          |
| `primary.persistence.annotations`            | MariaDB primary persistent volume claim annotations                                                               | `{}` (evaluated as a template) |
| `primary.persistence.storageClass`           | MariaDB primary persistent volume storage Class                                                                   | `nil`                          |
| `primary.persistence.accessModes`            | MariaDB primary persistent volume access Modes                                                                    | `[ReadWriteOnce]`              |
| `primary.persistence.size`                   | MariaDB primary persistent volume size                                                                            | `8Gi`                          |
| `primary.persistence.selector`               | Selector to match an existing Persistent Volume                                                                   | `{}` (evaluated as a template) |
| `primary.initContainers`                     | Add additional init containers for the MariaDB Primary pod(s)                                                     | `{}` (evaluated as a template) |
| `primary.sidecars`                           | Add additional sidecar containers for the MariaDB Primary pod(s)                                                  | `{}` (evaluated as a template) |
| `primary.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the MariaDB Primary container(s)                     | `{}`                           |
| `primary.extraVolumes`                       | Optionally specify extra list of additional volumes to the MariaDB Primary pod(s)                                 | `{}`                           |
| `primary.service.type`                       | MariaDB Primary K8s service type                                                                                  | `ClusterIP`                    |
| `primary.service.clusterIP`                  | MariaDB Primary K8s service clusterIP IP                                                                          | `nil`                          |
| `primary.service.port`                       | MariaDB Primary K8s service port                                                                                  | `3306`                         |
| `primary.service.nodePort`                   | MariaDB Primary K8s service node port                                                                             | `nil`                          |
| `primary.service.loadBalancerIP`             | MariaDB Primary loadBalancerIP if service type is `LoadBalancer`                                                  | `nil`                          |
| `primary.service.loadBalancerSourceRanges`   | Address that are allowed when MariaDB Primary service is LoadBalancer                                             | `[]`                           |
| `primary.pdb.enabled`                        | Enable/disable a Pod Disruption Budget creation for MariaDB primary pods                                          | `false`                        |
| `primary.pdb.minAvailable`                   | Minimum number/percentage of MariaDB primary pods that should remain scheduled                                    | `1`                            |
| `primary.pdb.maxUnavailable`                 | Maximum number/percentage of MariaDB primary pods that may be made unavailable                                    | `nil`                          |

### MariaDB Secondary parameters

| Parameter                                      | Description                                                                                                           | Default                        |
|------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|--------------------------------|
| `secondary.command`                            | Override default container command on MariaDB Secondary container(s) (useful when using custom images)                | `nil`                          |
| `secondary.args`                               | Override default container args on MariaDB Secondary container(s) (useful when using custom images)                   | `nil`                          |
| `secondary.configuration`                      | MariaDB Secondary configuration to be injected as ConfigMap                                                           | Check `values.yaml` file       |
| `secondary.existingConfigmap`                  | Name of existing ConfigMap with MariaDB Secondary configuration                                                       | `nil`                          |
| `secondary.replicaCount`                       | Number of MariaDB secondary replicas                                                                                  | `1`                            |
| `secondary.updateStrategy`                     | Update strategy type for the MariaDB secondary statefulset                                                            | `RollingUpdate`                |
| `secondary.podAnnotations`                     | Additional pod annotations for MariaDB secondary pods                                                                 | `{}` (evaluated as a template) |
| `secondary.hostAliases`                        | Add deployment host aliases                                                                                           | `[]`                           |
| `secondary.podLabels`                          | Additional pod labels for MariaDB secondary pods                                                                      | `{}` (evaluated as a template) |
| `secondary.podAffinityPreset`                  | MariaDB secondary pod affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `secondary.podAntiAffinityPreset`              | MariaDB secondary pod anti-affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `secondary.nodeAffinityPreset.type`            | MariaDB secondary node affinity preset type. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `secondary.nodeAffinityPreset.key`             | MariaDB secondary node label key to match Ignored if `secondary.affinity` is set.                                     | `""`                           |
| `secondary.nodeAffinityPreset.values`          | MariaDB secondary node label values to match. Ignored if `secondary.affinity` is set.                                 | `[]`                           |
| `secondary.affinity`                           | Affinity for MariaDB secondary pods assignment                                                                        | `{}` (evaluated as a template) |
| `secondary.nodeSelector`                       | Node labels for MariaDB secondary pods assignment                                                                     | `{}` (evaluated as a template) |
| `secondary.tolerations`                        | Tolerations for MariaDB secondary pods assignment                                                                     | `[]` (evaluated as a template) |
| `secondary.priorityClassName`                  | Priority class for MariaDB secondary pods assignment                                                                  | `nil`                          |
| `secondary.podSecurityContext.enabled`         | Enable security context for MariaDB secondary pods                                                                    | `true`                         |
| `secondary.podSecurityContext.fsGroup`         | Group ID for the mounted volumes' filesystem                                                                          | `1001`                         |
| `secondary.containerSecurityContext.enabled`   | MariaDB secondary container securityContext                                                                           | `true`                         |
| `secondary.containerSecurityContext.runAsUser` | User ID for the MariaDB secondary container                                                                           | `1001`                         |
| `secondary.livenessProbe`                      | Liveness probe configuration for MariaDB secondary containers                                                         | Check `values.yaml` file       |
| `secondary.readinessProbe`                     | Readiness probe configuration for MariaDB secondary containers                                                        | Check `values.yaml` file       |
| `secondary.customLivenessProbe`                | Override default liveness probe for MariaDB secondary containers                                                      | `nil`                          |
| `secondary.customReadinessProbe`               | Override default readiness probe for MariaDB secondary containers                                                     | `nil`                          |
| `secondary.resources.limits`                   | The resources limits for MariaDB secondary containers                                                                 | `{}`                           |
| `secondary.resources.requests`                 | The requested resources for MariaDB secondary containers                                                              | `{}`                           |
| `secondary.extraEnvVars`                       | Extra environment variables to be set on MariaDB secondary containers                                                 | `{}`                           |
| `secondary.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for MariaDB secondary containers                                 | `nil`                          |
| `secondary.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for MariaDB secondary containers                                    | `nil`                          |
| `secondary.extraFlags`                         | MariaDB secondary additional command line flags                                                                       | `nil`                          |
| `secondary.extraFlags`                         | MariaDB secondary additional command line flags                                                                       | `nil`                          |
| `secondary.persistence.enabled`                | Enable persistence on MariaDB secondary replicas using a `PersistentVolumeClaim`                                      | `true`                         |
| `secondary.persistence.subPath`                | Subdirectory of the volume to mount at                                                                                | `nil`                          |
| `secondary.persistence.annotations`            | MariaDB secondary persistent volume claim annotations                                                                 | `{}` (evaluated as a template) |
| `secondary.persistence.storageClass`           | MariaDB secondary persistent volume storage Class                                                                     | `nil`                          |
| `secondary.persistence.accessModes`            | MariaDB secondary persistent volume access Modes                                                                      | `[ReadWriteOnce]`              |
| `secondary.persistence.size`                   | MariaDB secondary persistent volume size                                                                              | `8Gi`                          |
| `secondary.persistence.selector`               | Selector to match an existing Persistent Volume                                                                       | `{}` (evaluated as a template) |
| `secondary.initContainers`                     | Add additional init containers for the MariaDB secondary pod(s)                                                       | `{}` (evaluated as a template) |
| `secondary.sidecars`                           | Add additional sidecar containers for the MariaDB secondary pod(s)                                                    | `{}` (evaluated as a template) |
| `secondary.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the MariaDB secondary container(s)                       | `{}`                           |
| `secondary.extraVolumes`                       | Optionally specify extra list of additional volumes to the MariaDB secondary pod(s)                                   | `{}`                           |
| `secondary.service.type`                       | MariaDB secondary K8s service type                                                                                    | `ClusterIP`                    |
| `secondary.service.clusterIP`                  | MariaDB secondary K8s service clusterIP IP                                                                            | `nil`                          |
| `secondary.service.port`                       | MariaDB secondary K8s service port                                                                                    | `3306`                         |
| `secondary.service.nodePort`                   | MariaDB secondary K8s service node port                                                                               | `nil`                          |
| `secondary.service.loadBalancerIP`             | MariaDB secondary loadBalancerIP if service type is `LoadBalancer`                                                    | `nil`                          |
| `secondary.service.loadBalancerSourceRanges`   | Address that are allowed when MariaDB secondary service is LoadBalancer                                               | `[]`                           |
| `secondary.pdb.enabled`                        | Enable/disable a Pod Disruption Budget creation for MariaDB secondary pods                                            | `false`                        |
| `secondary.pdb.minAvailable`                   | Minimum number/percentage of MariaDB secondary pods that should remain scheduled                                      | `1`                            |
| `secondary.pdb.maxUnavailable`                 | Maximum number/percentage of MariaDB secondary pods that may be made unavailable                                      | `nil`                          |

### RBAC parameters

| Parameter                    | Description                                              | Default                                         |
|------------------------------|----------------------------------------------------------|-------------------------------------------------|
| `serviceAccount.create`      | Enable the creation of a ServiceAccount for MariaDB pods | `true`                                          |
| `serviceAccount.name`        | Name of the created ServiceAccount                       | Generated using the `mariadb.fullname` template |
| `serviceAccount.annotations` | Annotations for MariaDB Service Account                  | `{}` (evaluated as a template)                  |
| `rbac.create`                | Weather to create & use RBAC resources or not            | `false`                                         |

### Volume Permissions parameters

| Parameter                              | Description                                                                                                          | Default                                                 |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`            | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                     | `docker.io`                                             |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                                                         | `bitnami/minideb`                                       |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                                                          | `buster`                                                |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                  | `Always`                                                |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.resources.limits`   | Init container volume-permissions resource  limits                                                                   | `{}`                                                    |
| `volumePermissions.resources.requests` | Init container volume-permissions resource  requests                                                                 | `{}`                                                    |

### Metrics parameters

| Parameter                                 | Description                                                                         | Default                   |
|-------------------------------------------|-------------------------------------------------------------------------------------|---------------------------|
| `metrics.enabled`                         | Start a side-car prometheus exporter                                                | `false`                   |
| `metrics.image.registry`                  | Exporter image registry                                                             | `docker.io`               |
| `metrics.image.repository`                | Exporter image name                                                                 | `bitnami/mysqld-exporter` |
| `metrics.image.tag`                       | Exporter image tag                                                                  | `{TAG_NAME}`              |
| `metrics.image.pullPolicy`                | Exporter image pull policy                                                          | `IfNotPresent`            |
| `metrics.extraArgs.primary`               | Extra args to be passed to mysqld_exporter on Primary pods                          | `[]`                      |
| `metrics.extraArgs.secondary`             | Extra args to be passed to mysqld_exporter on Secondary pods                        | `[]`                      |
| `metrics.resources.limits`                | The resources limits for MariaDB prometheus exporter containers                     | `{}`                      |
| `metrics.resources.requests`              | The requested resources for MariaDB prometheus exporter containers                  | `{}`                      |
| `metrics.livenessProbe`                   | Liveness probe configuration for MariaDB prometheus exporter containers             | Check `values.yaml` file  |
| `metrics.readinessProbe`                  | Readiness probe configuration for MariaDB prometheus exporter containers            | Check `values.yaml` file  |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator        | `false`                   |
| `metrics.serviceMonitor.namespace`        | Namespace which Prometheus is running in                                            | `nil`                     |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped                                         | `30s`                     |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                 | `nil`                     |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                           | `nil`                     |
| `metrics.serviceMonitor.honorLabels`      | honorLabels chooses the metric's labels on collisions with target labels.           | `false`                   |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator          | `{}`                      |
| `metrics.serviceMonitor.release`          | Used to pass Labels release that sometimes should be custom for Prometheus Operator | `nil`                     |

The above parameters map to the env variables defined in [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb). For more information please refer to the [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set auth.rootPassword=secretpassword,auth.database=app_database \
    bitnami/mariadb
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a database named `my_database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/mariadb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change MariaDB version

To modify the MariaDB version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/mariadb/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Initialize a fresh instance

The [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to this option, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the previous option.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

Take into account those scripts are treated differently depending on the extension. While the `.sh` scripts are executed in all the nodes; the `.sql` and `.sql.gz` scripts are only executed in the primary nodes. The reason behind this differentiation is that the `.sh` scripts allow adding conditions to determine what is the node running the script, while these conditions can't be set using `.sql` nor `sql.gz` files. This way it is possible to cover different use cases depending on their needs.

If using a `.sh` script you want to do a "one-time" action like creating a database, you need to add a condition in your `.sh` script to be executed only in one of the nodes, such as

```yaml
initdbScripts:
  my_init_script.sh: |
     #!/bin/sh
     if [[ $(hostname) == *primary* ]]; then
       echo "Primary node"
       mysql -P 3306 -uroot -prandompassword -e "create database new_database";
     else
       echo "No primary node"
     fi
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as MariaDB, you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

The [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image stores the MariaDB data and configurations at the `/bitnami/mariadb` path of the container.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can be defined.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to set the `auth.rootPassword` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Administrator credentials' section. Please note down the password and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/mariadb --set auth.rootPassword=[ROOT_PASSWORD]
```

| Note: you need to substitute the placeholder _[ROOT_PASSWORD]_ with the value obtained in the installation notes.

### To 9.0.0

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

### To 8.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - The terms *master* and *slave* have been replaced by the terms *primary* and *secondary*. Therefore, parameters prefixed with `master` or `slave` are now prefixed with `primary` or `secondary`, respectively.
  - `securityContext.*` is deprecated in favor of `primary.podSecurityContext`, `primary.containerSecurityContext`, `secondary.podSecurityContext`, and `secondary.containerSecurityContext`.
  - Credentials parameter are reorganized under the `auth` parameter.
  - `replication.enabled` parameter is deprecated in favor of `architecture` parameter that accepts two values: `standalone` and `replication`.
- The default MariaDB version was updated from 10.3 to 10.5. According to the official documentation, upgrading from 10.3 should be painless. However, there are some things that have changed which could affect an upgrade:
  - [Incompatible changes upgrading from MariaDB 10.3 to MariaDB 10.4](https://mariadb.com/kb/en/upgrading-from-mariadb-103-to-mariadb-104/#incompatible-changes-between-103-and-104).
  - [Incompatible changes upgrading from MariaDB 10.4 to MariaDB 10.5](https://mariadb.com/kb/en/upgrading-from-mariadb-104-to-mariadb-105/#incompatible-changes-between-104-and-105).
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

Backwards compatibility is not guaranteed. To upgrade to `8.0.0`, install a new release of the MariaDB chart, and migrate the data from your previous release. You have 2 alternatives to do so:

- Create a backup of the database, and restore it on the new release using tools such as [mysqldump](https://mariadb.com/kb/en/mysqldump/).
- Reuse the PVC used to hold the master data on your previous release. To do so, use the `primary.persistence.existingClaim` parameter. The following example assumes that the release name is `mariadb`:

```bash
$ helm install mariadb bitnami/mariadb --set auth.rootPassword=[ROOT_PASSWORD] --set primary.persistence.existingClaim=[EXISTING_PVC]
```

| Note: you need to substitute the placeholder _[EXISTING_PVC]_ with the name of the PVC used on your previous release, and _[ROOT_PASSWORD]_ with the root password used in your previous release.

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17308 the `apiVersion` of the statefulset resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version bump signifies this change.

### To 6.0.0

MariaDB version was updated from 10.1 to 10.3, there are no changes in the chart itself. According to the official documentation, upgrading from 10.1 should be painless. However, there are some things that have changed which could affect an upgrade:

- [Incompatible changes upgrading from MariaDB 10.1 to MariaDB 10.2](https://mariadb.com/kb/en/library/upgrading-from-mariadb-101-to-mariadb-102//#incompatible-changes-between-101-and-102)
- [Incompatible changes upgrading from MariaDB 10.2 to MariaDB 10.3](https://mariadb.com/kb/en/library/upgrading-from-mariadb-102-to-mariadb-103/#incompatible-changes-between-102-and-103)

### To 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is mariadb:

```console
$ kubectl delete statefulset opencart-mariadb --cascade=false
```
