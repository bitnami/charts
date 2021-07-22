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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects (sub-charts are not considered)                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `[]`            |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `[]`            |


### Cassandra parameters

| Name                          | Description                                                                                                            | Value                    |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `image.registry`              | Cassandra image registry                                                                                               | `docker.io`              |
| `image.repository`            | Cassandra image repository                                                                                             | `bitnami/cassandra`      |
| `image.tag`                   | Cassandra image tag (immutable tags are recommended)                                                                   | `3.11.10-debian-10-r149` |
| `image.pullPolicy`            | image pull policy                                                                                                      | `IfNotPresent`           |
| `image.pullSecrets`           | Cassandra image pull secrets                                                                                           | `[]`                     |
| `image.debug`                 | Enable image debug mode                                                                                                | `false`                  |
| `dbUser.user`                 | Cassandra admin user                                                                                                   | `cassandra`              |
| `dbUser.forcePassword`        | Force the user to provide a non                                                                                        | `false`                  |
| `dbUser.password`             | Password for `dbUser.user`. Randomly generated if empty                                                                | `""`                     |
| `dbUser.existingSecret`       | Use an existing secret object for `dbUser.user` password (will ignore `dbUser.password`)                               | `""`                     |
| `initDBConfigMap`             | ConfigMap with cql scripts. Useful for creating a keyspace and pre-populating data                                     | `""`                     |
| `initDBSecret`                | Secret with cql script (with sensitive data). Useful for creating a keyspace and pre-populating data                   | `""`                     |
| `existingConfiguration`       | ConfigMap with custom cassandra configuration files. This overrides any other Cassandra configuration set in the chart | `""`                     |
| `cluster.name`                | Cassandra cluster name                                                                                                 | `cassandra`              |
| `cluster.seedCount`           | Number of seed nodes                                                                                                   | `1`                      |
| `cluster.numTokens`           | Number of tokens for each node                                                                                         | `256`                    |
| `cluster.datacenter`          | Datacenter name                                                                                                        | `dc1`                    |
| `cluster.rack`                | Rack name                                                                                                              | `rack1`                  |
| `cluster.enableRPC`           | Enable Thrift RPC endpoint                                                                                             | `true`                   |
| `cluster.endpointSnitch`      | Endpoint Snitch                                                                                                        | `SimpleSnitch`           |
| `cluster.internodeEncryption` | DEPRECATED: use tls.internode and tls.client instead. Encryption values.                                               | `none`                   |
| `cluster.clientEncryption`    | Client Encryption                                                                                                      | `false`                  |
| `cluster.extraSeeds`          | For an external/second cassandra ring.                                                                                 | `[]`                     |
| `jvm.extraOpts`               | Set the value for Java Virtual Machine extra options                                                                   | `""`                     |
| `jvm.maxHeapSize`             | Set Java Virtual Machine maximum heap size (MAX_HEAP_SIZE). Calculated automatically if `nil`                          | `""`                     |
| `jvm.newHeapSize`             | Set Java Virtual Machine new heap size (HEAP_NEWSIZE). Calculated automatically if `nil`                               | `""`                     |
| `command`                     | Command for running the container (set to default if not set). Use array form                                          | `[]`                     |
| `args`                        | Args for running the container (set to default if not set). Use array form                                             | `[]`                     |
| `extraEnvVars`                | Extra environment variables to be set on cassandra container                                                           | `[]`                     |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                                                                   | `""`                     |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                                                                      | `""`                     |


### Statefulset parameters

| Name                                 | Description                                                                               | Value           |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                       | Number of Cassandra replicas                                                              | `1`             |
| `updateStrategy`                     | updateStrategy for Cassandra statefulset                                                  | `RollingUpdate` |
| `hostAliases`                        | Add deployment host aliases                                                               | `[]`            |
| `rollingUpdatePartition`             | Partition update strategy                                                                 | `""`            |
| `podManagementPolicy`                | StatefulSet pod management policy                                                         | `OrderedReady`  |
| `priorityClassName`                  | Cassandra pods' priority.                                                                 | `""`            |
| `podAnnotations`                     | Additional pod annotations                                                                | `{}`            |
| `podLabels`                          | Additional pod labels                                                                     | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `affinity`                           | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                        | Tolerations for pod assignment                                                            | `[]`            |
| `topologySpreadConstraints`          | Topology Spread Constraints for pod assignment                                            | `[]`            |
| `podSecurityContext.enabled`         | Enabled Cassandra pods' Security Context                                                  | `true`          |
| `podSecurityContext.fsGroup`         | Set Cassandra pod's Security Context fsGroup                                              | `1001`          |
| `containerSecurityContext.enabled`   | Enabled Cassandra containers' Security Context                                            | `true`          |
| `containerSecurityContext.runAsUser` | et Cassandra container's Security Context runAsUser                                       | `1001`          |
| `resources.limits`                   | The resources limits for Cassandra containers                                             | `{}`            |
| `resources.requests`                 | The requested resources for Cassandra containers                                          | `{}`            |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `60`            |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `30`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `5`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `60`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `5`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                       | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                      | `{}`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for cassandra container               | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for cassandra container          | `[]`            |
| `initContainers`                     | Add additional init containers to the cassandra pods                                      | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the cassandra pods                                   | `[]`            |
| `pdb.create`                         | Enable/disable a Pod Disruption Budget creation                                           | `false`         |
| `pdb.minAvailable`                   | Mininimum number of pods that must still be available after the eviction                  | `1`             |
| `pdb.maxUnavailable`                 | Max number of pods that can be unavailable after the eviction                             | `""`            |
| `hostNetwork`                        | Enable HOST Network                                                                       | `false`         |
| `containerPorts.intra`               | Intra Port on the Host and Container                                                      | `7000`          |
| `containerPorts.tls`                 | TLS Port on the Host and Container                                                        | `7001`          |
| `containerPorts.jmx`                 | JMX Port on the Host and Container                                                        | `7199`          |
| `containerPorts.cql`                 | CQL Port on the Host and Container                                                        | `9042`          |
| `containerPorts.thrift`              | Thrift Port on the Host and Container                                                     | `9160`          |


### RBAC parameters

| Name                         | Description                                                | Value  |
| ---------------------------- | ---------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Enable the creation of a ServiceAccount for Cassandra pods | `true` |
| `serviceAccount.name`        | The name of the ServiceAccount to use.                     | `""`   |
| `serviceAccount.annotations` | Annotations for Cassandra Service Account                  | `{}`   |


### Traffic Exposure Parameters

| Name                          | Description                                               | Value       |
| ----------------------------- | --------------------------------------------------------- | ----------- |
| `service.type`                | Cassandra service type                                    | `ClusterIP` |
| `service.port`                | Cassandra service CQL Port                                | `9042`      |
| `service.thriftPort`          | Cassandra service Thrift Port                             | `9160`      |
| `service.metricsPort`         | Cassandra service metrics port                            | `8080`      |
| `service.nodePorts.cql`       | Node port for CQL                                         | `""`        |
| `service.nodePorts.thrift`    | Node port for Thrift                                      | `""`        |
| `service.nodePorts.metrics`   | Node port for metrics                                     | `""`        |
| `service.loadBalancerIP`      | LoadBalancerIP if service type is `LoadBalancer`          | `""`        |
| `service.annotations`         | Provide any additional annotations which may be required. | `{}`        |
| `networkPolicy.enabled`       | Specifies whether a NetworkPolicy should be created       | `false`     |
| `networkPolicy.allowExternal` | Don't require client label for connections                | `true`      |


### Persistence parameters

| Name                             | Description                                                                                        | Value                |
| -------------------------------- | -------------------------------------------------------------------------------------------------- | -------------------- |
| `persistence.enabled`            | Enable Cassandra data persistence using PVC, use a Persistent Volume Claim, If false, use emptyDir | `true`               |
| `persistence.storageClass`       | PVC Storage Class for Cassandra data volume                                                        | `""`                 |
| `persistence.commitStorageClass` | PVC Storage Class for Cassandra Commit Log volume                                                  | `""`                 |
| `persistence.annotations`        | Persistent Volume Claim annotations                                                                | `{}`                 |
| `persistence.accessModes`        | Persistent Volume Access Mode                                                                      | `[]`                 |
| `persistence.size`               | PVC Storage Request for Cassandra data volume                                                      | `8Gi`                |
| `persistence.mountPath`          | The path the data volume will be mounted at                                                        | `/bitnami/cassandra` |


### Volume Permissions parameters

| Name                                          | Description                                                                     | Value                   |
| --------------------------------------------- | ------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume | `false`                 |
| `volumePermissions.image.registry`            | Init container volume                                                           | `docker.io`             |
| `volumePermissions.image.repository`          | Init container volume                                                           | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                 | Init container volume                                                           | `10-debian-10-r138`     |
| `volumePermissions.image.pullPolicy`          | Init container volume                                                           | `Always`                |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                | `[]`                    |
| `volumePermissions.resources.limits`          | The resources limits for the container                                          | `{}`                    |
| `volumePermissions.resources.requests`        | The requested resources for the container                                       | `{}`                    |
| `volumePermissions.securityContext.runAsUser` | User ID for the init container                                                  | `0`                     |


### Metrics parameters

| Name                                   | Description                                                                                            | Value                        |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------ | ---------------------------- |
| `metrics.enabled`                      | Start a side-car prometheus exporter                                                                   | `false`                      |
| `metrics.image.registry`               | Cassandra exporter image registry                                                                      | `docker.io`                  |
| `metrics.image.repository`             | Cassandra exporter image name                                                                          | `bitnami/cassandra-exporter` |
| `metrics.image.tag`                    | Cassandra exporter image tag                                                                           | `2.3.4-debian-10-r463`       |
| `metrics.image.pullPolicy`             | image pull policy                                                                                      | `IfNotPresent`               |
| `metrics.image.pullSecrets`            | Specify docker-registry secret names as an array                                                       | `[]`                         |
| `metrics.resources.limits`             | The resources limits for the container                                                                 | `{}`                         |
| `metrics.resources.requests`           | The requested resources for the container                                                              | `{}`                         |
| `metrics.podAnnotations`               | Metrics exporter pod Annotation and Labels                                                             | `{}`                         |
| `metrics.serviceMonitor.enabled`       | If `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`                      |
| `metrics.serviceMonitor.namespace`     | Namespace in which Prometheus is running                                                               | `monitoring`                 |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                           | `""`                         |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                | `""`                         |
| `metrics.serviceMonitor.selector`      | Prometheus instance selector labels                                                                    | `{}`                         |
| `metrics.containerPorts.http`          | HTTP Port on the Host and Container                                                                    | `8080`                       |
| `metrics.containerPorts.jmx`           | JMX Port on the Host and Container                                                                     | `5555`                       |


### TLS/SSL parameters

| Name                      | Description                                                                                   | Value   |
| ------------------------- | --------------------------------------------------------------------------------------------- | ------- |
| `tls.internodeEncryption` | Set internode encryption                                                                      | `none`  |
| `tls.clientEncryption`    | Set client-server encryption                                                                  | `false` |
| `tls.autoGenerated`       | Generate automatically self-signed TLS certificates. Currently only supports PEM certificates | `false` |
| `tls.existingSecret`      | Existing secret that contains Cassandra Keystore and truststore                               | `""`    |
| `tls.passwordsSecret`     | Secret containing the Keystore and Truststore passwords if needed                             | `""`    |
| `tls.keystorePassword`    | Password for the keystore, if needed.                                                         | `""`    |
| `tls.truststorePassword`  | Password for the truststore, if needed.                                                       | `""`    |
| `tls.resources.limits`    | The resources limits for the TLS init container                                               | `{}`    |
| `tls.resources.requests`  | The requested resources for the TLS init container                                            | `{}`    |


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
