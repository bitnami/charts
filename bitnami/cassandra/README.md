# cassandra

[Apache Cassandra](https://cassandra.apache.org) is a free and open-source distributed database management system designed to handle large amounts of data across many commodity servers or datacenters.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/cassandra
```

## Introduction

This chart bootstraps an [Apache Cassandra](https://github.com/bitnami/bitnami-docker-cassandra) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

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

These commands deploy one node with Apache Cassandra on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

### RBAC parameters

| Parameter                    | Description                                                | Default                                           |
|------------------------------|------------------------------------------------------------|---------------------------------------------------|
| `serviceAccount.create`      | Enable the creation of a ServiceAccount for Cassandra pods | `true`                                            |
| `serviceAccount.name`        | Name of the created ServiceAccount                         | Generated using the `cassandra.fullname` template |
| `serviceAccount.annotations` | Annotations for Cassandra Service Account                  | `{}` (evaluated as a template)                    |

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

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Enable TLS

This chart supports TLS between client and server and between nodes, as explained below:

* For internode cluster encryption, set the `cluster.internodeEncryption` chart parameter to a value different from `none`. Available values are `all`, `dc` or `rack`.
* For client-server encryption, set the `cluster.clientEncryption` chart parameter to `true`.

In both cases, it is also necessary to create a secret containing the keystore and truststore certificates and their corresponding protection passwords. This secret is to be passed to the chart via the `tlsEncryptionSecretName` parameter at deployment-time.

Refer to the chart documentation for more [information on creating the secret and a TLS deployment example](https://docs.bitnami.com/kubernetes/infrastructure/cassandra/administration/enable-tls/).

### Use a custom configuration file

This chart also supports mounting custom configuration file(s) for Apache Cassandra. This is achieved by setting the `existingConfiguration` parameter with the name of a ConfigMap that includes the custom configuration file(s).

> NOTE: This ConfigMap will override other Apache Cassandra configuration variables set in the chart.

Refer to the chart documentation for more [information on customizing an Apache Cassandra deployment](https://docs.bitnami.com/kubernetes/infrastructure/cassandra/configuration/customize-new-instance/).

### Initialize the database

The [Bitnami Apache Cassandra image](https://github.com/bitnami/bitnami-docker-cassandra) image supports the use of custom scripts to initialize a fresh instance. This may be done by creating a Kubernetes ConfigMap that includes the necessary *sh* or *cql* scripts and passing this ConfigMap to the chart via the *initDBConfigMap* parameter.

Refer to the chart documentation for more [information on customizing an Apache Cassandra deployment](https://docs.bitnami.com/kubernetes/infrastructure/cassandra/configuration/customize-new-instance/).

### Set pod affinity

This chart allows you to set custom pod affinity using the `XXX.affinity` parameter(s). Find more information about pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Apache Cassandra](https://github.com/bitnami/bitnami-docker-cassandra) image stores the Apache Cassandra data at the `/bitnami/cassandra` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it. There are two approaches to achieve this:

* Use Kubernetes SecurityContexts by setting the `podSecurityContext.enabled` and `containerSecurityContext.enabled` to `true`. This option is enabled by default in the chart. However, this feature does not work in all Kubernetes distributions.
* Use an init container to change the ownership of the volume before mounting it in the final destination. Enable this container by setting the `volumePermissions.enabled` parameter to `true`.

## Backup and restore

Refer to our detailed tutorial on [backing up and restoring Bitnami Apache Cassandra deployments on Kubernetes](https://docs.bitnami.com/tutorials/backup-restore-data-cassandra-kubernetes/).

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

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/cassandra/administration/upgrade-helm3/).

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
