# cassandra

[Apache Cassandra](https://cassandra.apache.org) is a free and open-source distributed database management system designed to handle large amounts of data across many commodity servers or datacenters.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/cassandra
```

## Introduction

This chart bootstraps a [Cassandra](https://github.com/bitnami/bitnami-docker-cassandra) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/cassandra
```

These commands deploy one node with Cassandra on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Cassandra chart and their default values.

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker Image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                                 | Default         |
|---------------------|-----------------------------------------------------------------------------|-----------------|
| `nameOverride`      | String to partially override cassandra.fullname                             | `nil`           |
| `fullnameOverride`  | String to fully override cassandra.fullname                                 | `nil`           |
| `clusterDomain`     | Default Kubernetes cluster domain                                           | `cluster.local` |
| `commonLabels`      | Labels to add to all deployed objects                                       | `nil`           |
| `commonAnnotations` | Annotations to add to all deployed objects                                  | `[]`            |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template) | `nil`           |

### Cassandra parameters

| Parameter                     | Description                                                                                                                                         | Default                                                 |
|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`              | Cassandra Image registry                                                                                                                            | `docker.io`                                             |
| `image.repository`            | Cassandra Image name                                                                                                                                | `bitnami/cassandra`                                     |
| `image.tag`                   | Cassandra Image tag                                                                                                                                 | `{TAG_NAME}`                                            |
| `image.pullPolicy`            | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                                                                                                    | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                 | Specify if debug logs should be enabled                                                                                                             | `false`                                                 |
| `hostAliases`                 | Add deployment host aliases                                                                                                                         | `[]`                                                    |
| `dbUser.user`                 | Cassandra admin user                                                                                                                                | `cassandra`                                             |
| `dbUser.forcePassword`        | Force the user to provide a non-empty password for `dbUser.user`                                                                                    | `false`                                                 |
| `dbUser.password`             | Password for `dbUser.user`. Randomly generated if empty                                                                                             | (Random generated)                                      |
| `dbUser.existingSecret`       | Use an existing secret object for `dbUser.user` password (will ignore `dbUser.password`)                                                            | `nil`                                                   |
| `initDBConfigMap`             | Configmap for initialization CQL commands (done in the first node). Useful for creating keyspaces at startup                                        | `nil` (evaluated as a template)                         |
| `initDBSecret`                | Secret for initialization CQL commands (done in the first node) that contain sensitive data. Useful for creating keyspaces at startup               | `nil` (evaluated as a template)                         |
| `tlsEncryptionSecretName`     | Secret with keystore, keystore password, truststore and truststore password                                                                         | `{}`                                                    |
| `existingConfiguration`       | Pointer to a configMap that contains custom Cassandra configuration files. This will override any Cassandra configuration variable set in the chart | `nil` (evaluated as a template)                         |
| `cluster.name`                | Cassandra cluster name                                                                                                                              | `cassandra`                                             |
| `cluster.seedCount`           | Number of seed nodes (note: must be greater or equal than 1 and less or equal to `replicaCount`)                                                    | `1`                                                     |
| `cluster.numTokens`           | Number of tokens for each node                                                                                                                      | `256`                                                   |
| `cluster.datacenter`          | Datacenter name                                                                                                                                     | `dc1`                                                   |
| `cluster.rack`                | Rack name                                                                                                                                           | `rack1`                                                 |
| `cluster.enableRPC`           | Enable Thrift RPC endpoint                                                                                                                          | `true`                                                  |
| `cluster.enableUDF`           | Enable CASSANDRA_ENABLE_USER_DEFINED_FUNCTIONS                                                                                                      | `false`                                                 |
| `cluster.internodeEncryption` | Set internode encryption. NOTE: A value different from 'none' requires setting `tlsEncryptionSecretName`                                            | `none`                                                  |
| `cluster.clientEncryption`    | Set client-server encryption. NOTE: A value different from 'false' requires setting `tlsEncryptionSecretName`                                       | `false`                                                 |
| `jvm.extraOpts`               | Set the value for Java Virtual Machine extra options (JVM_EXTRA_OPTS)                                                                               | `nil`                                                   |
| `jvm.maxHeapSize`             | Set Java Virtual Machine maximum heap size (MAX_HEAP_SIZE). Calculated automatically if `nil`                                                       | `nil`                                                   |
| `jvm.newHeapSize`             | Set Java Virtual Machine new heap size (HEAP_NEWSIZE). Calculated automatically if `nil`                                                            | `nil`                                                   |
| `command`                     | Override default container command (useful when using custom images)                                                                                | `[]`                                                    |
| `args`                        | Override default container args (useful when using custom images)                                                                                   | `[]`                                                    |
| `extraEnvVars`                | Extra environment variables to be set on cassandra container                                                                                        | `{}`                                                    |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                                                                                                | `nil`                                                   |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                                                                                                   | `nil`                                                   |

### Statefulset parameters

| Parameter                            | Description                                                                               | Default                        |
|--------------------------------------|-------------------------------------------------------------------------------------------|--------------------------------|
| `replicaCount`                       | Number of Cassandra replicas                                                              | `1`                            |
| `updateStrategy`                     | Update strategy type for the statefulset                                                  | `RollingUpdate`                |
| `rollingUpdatePartition`             | Partition update strategy                                                                 | `nil`                          |
| `priorityClassName`                  | Cassandra priorityClassName                                                               | `nil`                          |
| `podManagementPolicy`                | StatefulSet pod management policy                                                         | `OrderedReady`                 |
| `podAnnotations`                     | Additional pod annotations                                                                | `{}`                           |
| `podLabels`                          | Additional pod labels                                                                     | `{}`                           |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                     | `""`                           |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                           |
| `affinity`                           | Affinity for pod assignment                                                               | `{}` (evaluated as a template) |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}` (evaluated as a template) |
| `tolerations`                        | Tolerations for pod assignment                                                            | `[]` (evaluated as a template) |
| `topologySpreadConstraints`          | Topology Spread Constraints for pod assignment                                            | `[]` (evaluated as a template) |
| `podSecurityContext.enabled`         | Enable security context for Cassandra pods                                                | `true`                         |
| `podSecurityContext.fsGroup`         | Group ID for the volumes of the pod                                                       | `1001`                         |
| `containerSecurityContext.enabled`   | Cassandra Container securityContext                                                       | `true`                         |
| `containerSecurityContext.runAsUser` | User ID for the Cassandra container                                                       | `1001`                         |
| `resources.limits`                   | The resources limits for Cassandra containers                                             | `{}`                           |
| `resources.requests`                 | The requested resources for Cassandra containers                                          | `{}`                           |
| `livenessProbe`                      | Liveness probe configuration for Cassandra                                                | Check `values.yaml` file       |
| `readinessProbe`                     | Readiness probe configuration for Cassandra                                               | Check `values.yaml` file       |
| `customLivenessProbe`                | Override default liveness probe                                                           | `nil`                          |
| `customReadinessProbe`               | Override default readiness probe                                                          | `nil`                          |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for cassandra container          | `[]`                           |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for cassandra container               | `[]`                           |
| `initContainers`                     | Add additional init containers to the cassandra pods                                      | `{}` (evaluated as a template) |
| `sidecars`                           | Add additional sidecar containers to the cassandra pods                                   | `{}` (evaluated as a template) |
| `pdb.create`                         | Enable/disable a Pod Disruption Budget creation                                           | `false`                        |
| `pdb.minAvailable`                   | Minimum number/percentage of pods that should remain scheduled                            | `1`                            |
| `pdb.maxUnavailable`                 | Maximum number/percentage of pods that may be made unavailable                            | `nil`                          |
| `hostNetwork`                        | Use Host-Network for the PODs (if true, also dnsPolicy: ClusterFirstWithHostNet is set)   | `false`                        |
| `containerPorts.intra`               | Intra Port on the Host and Container                                                      | `7000`                         |
| `containerPorts.tls`                 | TLS Port on the Host and Container                                                        | `7001`                         |
| `containerPorts.jmx`                 | JMX Port on the Host and Container                                                        | `7199`                         |
| `containerPorts.cql`                 | CQL Port on the Host and Container                                                        | `9042`                         |
| `containerPorts.thrift`              | Thrift Port on the Host and Container                                                     | `9160`                         |
| `metrics.containerPorts.http`        | HTTP Port on the Host and Container                                                       | `8080`                         |
| `metrics.containerPorts.jmx`         | JMX Port on the Host and Container                                                        | `5555`                         |


### Exposure parameters

| Parameter                     | Description                                      | Default     |
|-------------------------------|--------------------------------------------------|-------------|
| `service.type`                | Kubernetes Service type                          | `ClusterIP` |
| `service.port`                | CQL Port for the Kubernetes service              | `9042`      |
| `service.thriftPort`          | Thrift Port for the Kubernetes service           | `9160`      |
| `service.metricsPort`         | Metrics Port for the Kubernetes service          | `8080`      |
| `service.nodePorts.cql`       | Kubernetes CQL node port                         | `""`        |
| `service.nodePorts.thrift`    | Kubernetes Thrift node port                      | `""`        |
| `service.nodePorts.metrics`   | Kubernetes Metrics node port                     | `""`        |
| `service.loadBalancerIP`      | LoadBalancerIP if service type is `LoadBalancer` | `nil`       |
| `service.annotations`         | Annotations for the service                      | {}          |
| `networkPolicy.enabled`       | Enable NetworkPolicy                             | `false`     |
| `networkPolicy.allowExternal` | Don't require client label for connections       | `true`      |

### Persistence parameters

| Parameter                        | Description                                         | Default                        |
|----------------------------------|-----------------------------------------------------|--------------------------------|
| `persistence.enabled`            | Enable Cassandra data persistence using PVC         | `true`                         |
| `persistence.storageClass`       | PVC Storage Class for Cassandra data volume         | `nil`                          |
| `persistence.commitStorageClass` | PVC Storage Class for Cassandra Commit Log volume   | `nil`                          |
| `persistence.annotations`        | Persistent Volume Claim annotations Annotations     | `{}` (evaluated as a template) |
| `persistence.accessMode`         | PVC Access Mode for Cassandra data volume           | `[ReadWriteOnce]`              |
| `persistence.size`               | PVC Storage Request for Cassandra data volume       | `8Gi`                          |
| `persistence.commitLogsize`      | PVC Storage Request for Cassandra commit log volume | `nil`                          |
| `persistence.mountPath`          | The path the data volume will be mounted at         | `/bitnami/cassandra`           |
| `persistence.commitLogMountPath` | The path the commit log volume will be mounted at   | `nil`                          |

### Volume Permissions parameters

| Parameter                                     | Description                                                                                                          | Default                                                 |
|-----------------------------------------------|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                     | `docker.io`                                             |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                         | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                          | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                  | `Always`                                                |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.resources.limits`          | Init container volume-permissions resource  limits                                                                   | `{}`                                                    |
| `volumePermissions.resources.requests`        | Init container volume-permissions resource  requests                                                                 | `{}`                                                    |
| `volumePermissions.securityContext.*`         | Other container security context to be included as-is in the container spec                                          | `{}`                                                    |
| `volumePermissions.securityContext.runAsUser` | User ID for the init container (when facing issues in OpenShift or uid unknown, try value "auto")                    | `0`                                                     |

### Metrics parameters

| Parameter                              | Description                                                                                            | Default                                                      |
|----------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `metrics.enabled`                      | Start a side-car prometheus exporter                                                                   | `false`                                                      |
| `metrics.image.registry`               | Cassandra exporter Image registry                                                                      | `docker.io`                                                  |
| `metrics.image.repository`             | Cassandra exporter Image name                                                                          | `bitnami/cassandra-exporter`                                 |
| `metrics.image.tag`                    | Cassandra exporter Image tag                                                                           | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`             | Image pull policy                                                                                      | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`            | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`               | Additional annotations for Metrics exporter                                                            | `{prometheus.io/scrape: "true", prometheus.io/port: "8080"}` |
| `metrics.resources`                    | Exporter resource requests/limit                                                                       | `{}`                                                         |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                                                      |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `nil`                                                        |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `nil` (Prometheus Operator default value)                    |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                    | `nil`                                                        |

The above parameters map to the env variables defined in [bitnami/cassandra](http://github.com/bitnami/bitnami-docker-cassandra). For more information please refer to the [bitnami/cassandra](http://github.com/bitnami/bitnami-docker-cassandra) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
    --set dbUser.user=admin,dbUser.password=password \
    bitnami/cassandra
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/cassandra
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Enable TLS for Cassandra

You can enable TLS between client and server and between nodes. In order to do so, you need to set the following values:

- For internode cluster encryption, set `cluster.internodeEncryption` to a value different from `none`. Available values are `all`, `dc` or `rack`.
- For client-server encryption, set `cluster.clientEncryption` to true.

In addition to this, you **must** create a secret containing the *keystore* and *truststore* certificates and their corresponding protection passwords. Then, set the `tlsEncryptionSecretName`  when deploying the chart.

You can create the secret (named for example `cassandra-tls`) using `--from-file=./keystore`, `--from-file=./truststore`, `--from-literal=keystore-password=PUT_YOUR_KEYSTORE_PASSWORD` and `--from-literal=truststore-password=PUT_YOUR_TRUSTSTORE_PASSWORD` options, assuming you have your certificates in your working directory (replace the PUT_YOUR_KEYSTORE_PASSWORD and PUT_YOUR_TRUSTSTORE_PASSWORD placeholders).To deploy Cassandra with TLS you can use those parameters:

```console
cluster.internodeEncryption=all
cluster.clientEncryption=true
tlsEncryptionSecretName=cassandra-tls
```

### Using custom configuration

This helm chart supports mounting your custom configuration file(s) for Cassandra. This is done by setting the `existingConfiguration` parameter with the name of a configmap (for example, `cassandra-configuration`) that includes the custom configuration file(s):

```console
existingConfiguration=cassandra-configuration
```

> Note: this will override any other Cassandra configuration variable set in the chart.

### Initializing the database

The [Bitnami cassandra](https://github.com/bitnami/bitnami-docker-cassandra) image allows having initialization scripts mounted in `/docker-entrypoint.initdb`. This is done in the chart by setting the parameter `initDBConfigMap` with the name of a configmap (for example, `init-db`) that includes the necessary `sh` or `cql` scripts:

```console
initDBConfigMap=init-db
```

If the scripts contain sensitive information, you can use the `initDBSecret` parameter as well (both can be used at the same time).

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami cassandra](https://github.com/bitnami/bitnami-docker-cassandra) image stores the cassandra data at the `/bitnami/cassandra` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

It's necessary to set the `dbUser.password` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use. Please note down the password and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release bitnami/cassandra --set dbUser.password=[PASSWORD]
```

| Note: you need to substitute the placeholder _[PASSWORD]_ with the value obtained in the installation notes.

### To 7.0.0

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

### To 6.0.0

- Several parameters were renamed or disappeared in favor of new ones on this major version:
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
  - Parameters prefixed with `statefulset.` were renamed removing the prefix. E.g. `statefulset.rollingUpdatePartition` -> renamed to `rollingUpdatePartition`.
  - `cluster.replicaCount` is renamed to `replicaCount`.
  - `cluster.domain` is renamed to `clusterDomain`.
- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. To upgrade to `6.0.0`, install a new release of the Cassandra chart, and migrate the data from your previous release. To do so, create an snapshot of the database, and restore it on the new database. Check [this guide](https://cassandra.apache.org/doc/latest/operating/backups.html#snapshots) for more information.

### To 5.4.0

The `minimumAvailable` option has been renamed to `minAvailable` for consistency with other charts. This is not a breaking change as `minimumAvailable` never worked before because of an error in chart templates.

### To 5.0.0

An issue in StatefulSet manifest of the 4.x chart series rendered chart upgrades to be broken. The 5.0.0 series fixes this issue. To upgrade to the 5.x series you need to manually delete the Cassandra StatefulSet before executing the `helm upgrade` command.

```bash
kubectl delete sts -l release=<RELEASE_NAME>
helm upgrade <RELEASE_NAME> ...
```

### To 4.0.0

This release changes uses Bitnami Cassandra container `3.11.4-debian-9-r188`, based on Bash.

### To 2.0.0

This release make it possible to specify custom initialization scripts in both cql and sh files.

#### Breaking changes

- `startupCQL` has been removed. Instead, for initializing the database, see [this section](#initializing-the-database).
