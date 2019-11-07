# cassandra

[Apache Cassandra](https://cassandra.apache.org) is a free and open-source distributed database management system designed to handle large amounts of data across many commodity servers or datacenters.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install bitnami/cassandra
```

## Introduction

This chart bootstraps a [Cassandra](https://github.com/bitnami/bitnami-docker-cassandra) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install --name my-release bitnami/cassandra
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

The following tables lists the configurable parameters of the cassandra chart and their default values.

| Parameter                            | Description                                                                                                                                               | Default                                                      |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `global.imageRegistry`               | Global Docker Image registry                                                                                                                              | `nil`                                                        |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                                                                           | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                | Global storage class for dynamic provisioning                                                                                                             | `nil`                                                        |
| `image.registry`                     | Cassandra Image registry                                                                                                                                  | `docker.io`                                                  |
| `image.repository`                   | Cassandra Image name                                                                                                                                      | `bitnami/cassandra`                                          |
| `image.tag`                          | Cassandra Image tag                                                                                                                                       | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                   | Image pull policy                                                                                                                                         | `IfNotPresent`                                               |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods)      |
| `image.debug`                        | Specify if debug logs should be enabled                                                                                                                   | `false`                                                      |
| `nameOverride`                       | String to partially override cassandra.fullname template with a string (will prepend the release name)                                                    | `nil`                                                        |
| `fullnameOverride`                   | String to fully override cassandra.fullname template with a string                                                                                        | `nil`                                                        |
| `entrypoint`                         | Cassandra container entrypoint (in case you want to use a different image)                                                                                | `/app-entrypoint.sh`                                         |
| `cmd`                                | Cassandra container cmd (in case you want to use a different image)                                                                                       | `/run.sh`                                                    |
| `volumePermissions.enabled`          | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                      |
| `volumePermissions.image.registry`   | Init container volume-permissions image registry                                                                                                          | `docker.io`                                                  |
| `volumePermissions.image.repository` | Init container volume-permissions image name                                                                                                              | `bitnami/minideb`                                            |
| `volumePermissions.image.tag`        | Init container volume-permissions image tag                                                                                                               | `stretch`                                                    |
| `volumePermissions.image.pullPolicy` | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                     |
| `volumePermissions.resources`        | Init container resource requests/limit                                                                                                                    | `nil`                                                        |
| `service.type`                       | Kubernetes Service type                                                                                                                                   | `ClusterIP`                                                  |
| `service.port`                       | CQL Port for the Kubernetes service                                                                                                                       | `9042`                                                       |
| `service.thriftPort`                 | Thrift Port for the Kubernetes service                                                                                                                    | `9160`                                                       |
| `service.nodePorts.cql`             | Kubernetes CQL node port                                                                                                                                  | `""`                                                         |
| `service.nodePorts.rcp`              | Kubernetes Thrift node port                                                                                                                               | `""`                                                         |
| `service.loadBalancerIP`             | LoadBalancerIP if service type is `LoadBalancer`                                                                                                          | `nil`                                                        |
| `service.annotations`                | Annotations for the service                                                                                                                               | {}                                                           |
| `persistence.enabled`                | Use PVCs to persist data                                                                                                                                  | `true`                                                       |
| `persistence.storageClass`           | Persistent Volume Storage Class                                                                                                                           | `generic`                                                    |
| `persistence.annotations`            | Persistent Volume Claim annotations Annotations                                                                                                           | {}                                                           |
| `persistence.accessModes`            | Persistent Volume Access Modes                                                                                                                            | `[ReadWriteOnce]`                                            |
| `persistence.size`                   | Persistent Volume Size                                                                                                                                    | `8Gi`                                                        |
| `tlsEncryptionSecretName`            | Secret with keystore, keystore password, truststore and truststore password                                                                               | `{}`                                                         |
| `resources`                          | CPU/Memory resource requests/limits                                                                                                                       | `{}`                                                         |
| `existingConfiguration`              | Pointer to a configMap that contains custom Cassandra configuration files. This will override any Cassandra configuration variable set in the chart       | `{}`                                                         |
| `cluster.name`                       | Cassandra cluster name                                                                                                                                    | `cassandra`                                                  |
| `cluster.replicaCount`               | Number of Cassandra nodes                                                                                                                                 | `1`                                                          |
| `cluster.seedCount`                  | Number of seed nodes (note: must be greater or equal than 1 and less or equal to `cluster.replicaCount`)                                                  | `1`                                                          |
| `cluster.numTokens`                  | Number of tokens for each node                                                                                                                            | `256`                                                        |
| `cluster.datacenter`                 | Datacenter name                                                                                                                                           | `dc1`                                                        |
| `cluster.rack`                       | Rack name                                                                                                                                                 | `rack1`                                                      |
| `cluster.enableRPC`                  | Enable Thrift RPC endpoint                                                                                                                                | `true`                                                       |
| `cluster.minimumAvailable`           | Minimum nuber of instances that must be available in the cluster (used of PodDisruptionBudget)                                                            | `1`                                                          |
| `cluster.internodeEncryption`        | Set internode encryption. NOTE: A value different from 'none' requires setting `tlsEncryptionSecretName`                                                  | `none`                                                       |
| `cluster.clientEncryption`           | Set client-server encryption. NOTE: A value different from 'false' requires setting `tlsEncryptionSecretName`                                             | `false`                                                      |
| `cluster.jvm.extraOpts`              | Set the value for Java Virtual Machine extra optinos (JVM_EXTRA_OPTS)                                                                                     | `nil`                                                        |
| `cluster.jvm.maxHeapSize`            | Set Java Virtual Machine maximum heap size (MAX_HEAP_SIZE). Calculated automatically if `nil`                                                             | `nil`                                                        |
| `cluster.jvm.newHeapSize`            | Set Java Virtual Machine new heap size (HEAP_NEWSIZE). Calculated automatically if `nil`                                                                  | `nil`                                                        |
| `cluster.domain`                     | Set the kubernetes cluster domain                                                                                                                         | `cluster.local`                                              |
| `dbUser.user`                        | Cassandra admin user                                                                                                                                      | `cassandra`                                                  |
| `dbUser.forcePassword`               | Force the user to provide a non-empty password for `dbUser.user`                                                                                          | `false`                                                      |
| `dbUser.password`                    | Password for `dbUser.user`. Randomly generated if empty                                                                                                   | (Random generated)                                           |
| `dbUser.existingSecret`              | Use an existing secret object for `dbUser.user` password (will ignore `dbUser.password`)                                                                  | `nil`                                                        |
| `initDBConfigMap`                    | Configmap for initialization CQL commands (done in the first node). Useful for creating keyspaces at startup, for instance                                | `nil`                                                        |
| `livenessProbe.enabled`              | Turn on and off liveness probe                                                                                                                            | `true`                                                       |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                                                                  | `30`                                                         |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                                                                                            | `30`                                                         |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                                                                                  | `5`                                                          |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                                                               | `1`                                                          |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `5`                                                          |
| `readinessProbe.enabled`             | Turn on and off readiness probe                                                                                                                           | `true`                                                       |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                                                                                 | `5`                                                          |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                                                                                            | `10`                                                         |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                                                                                  | `5`                                                          |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed                                                               | `1`                                                          |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `5`                                                          |
| `podAnnotations`                     | Additional pod annotations                                                                                                                                | `{}`                                                         |
| `podLabels`                          | Additional pod labels                                                                                                                                     | `{}`                                                         |
| `statefulset.updateStrategy`         | Update strategy for StatefulSet                                                                                                                           | onDelete                                                     |
| `statefulset.rollingUpdatePartition` | Partition update strategy                                                                                                                                 | `nil`                                                        |
| `securityContext.enabled`            | Enable security context                                                                                                                                   | `true`                                                       |
| `securityContext.fsGroup`            | Group ID for the container                                                                                                                                | `1001`                                                       |
| `securityContext.runAsUser`          | User ID for the container                                                                                                                                 | `1001`                                                       |
| `affinity`                           | Enable node/pod affinity                                                                                                                                  | {}                                                           |
| `tolerations`                        | Toleration labels for pod assignment                                                                                                                      | \[]                                                          |
| `networkPolicy.enabled`              | Enable NetworkPolicy                                                                                                                                      | `false`                                                      |
| `networkPolicy.allowExternal`        | Don't require client label for connections                                                                                                                | `true`                                                       |
| `metrics.enabled`                    | Start a side-car prometheus exporter                                                                                                                      | `false`                                                      |
| `metrics.image.registry`             | Cassandra exporter Image registry                                                                                                                         | `docker.io`                                                  |
| `metrics.image.repository`           | Cassandra exporter Image name                                                                                                                             | `bitnami/cassandra-exporter`                                 |
| `metrics.image.tag`                  | Cassandra exporter Image tag                                                                                                                              | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`           | Image pull policy                                                                                                                                         | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`          | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`             | Additional annotations for Metrics exporter                                                                                                               | `{prometheus.io/scrape: "true", prometheus.io/port: "8080"}` |
| `metrics.resources`                  | Exporter resource requests/limit                                                                                                                          | `{}`                                                         |


The above parameters map to the env variables defined in [bitnami/cassandra](http://github.com/bitnami/bitnami-docker-cassandra). For more information please refer to the [bitnami/cassandra](http://github.com/bitnami/bitnami-docker-cassandra) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set dbUser.user=admin,dbUser.password=password\
    bitnami/cassandra
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/cassandra
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Number of Cassandra and seed nodes:
```diff
- master.replicaCount: 1
- master.seedCount: 1
+ master.replicaCount: 3
+ master.seedCount: 2
```

- Minimum nuber of instances that must be available in the cluster:
```diff
- cluster.minimumAvailable: 1
+ cluster.minimumAvailable: 2
```

- Force the user to provide a non-empty password for `dbUser.user`:
```diff
- dbUser.forcePassword: false
+ dbUser.forcePassword: true
```

- Enable NetworkPolicy:
```diff
- networkPolicy.enabled: false
+ networkPolicy.enabled: true
```

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### Enable TLS for Cassandra

You can enable TLS between client and server and between nodes. In order to do so, you need to set the following values:

 * For internode cluster encryption, set `cluster.internodeEncryption` to a value different from `none`. Available values are `all`, `dc` or `rack`.
 * For client-server encryption, set `cluster.clientEncryption` to true.

In addition to this, you **must** create a secret containing the *keystore* and *truststore* certificates and their corresponding protection passwords. Then, set the `tlsEncryptionSecretName`  when deploying the chart.

You can create the secret (named for example `cassandra-tls`) using `--from-file=./keystore`, `--from-file=./truststore`, `--from-literal=keystore-password=PUT_YOUR_KEYSTORE_PASSWORD` and `--from-literal=truststore-password=PUT_YOUR_TRUSTSTORE_PASSWORD` options, assuming you have your certificates in your working directory (replace the PUT_YOUR_KEYSTORE_PASSWORD and PUT_YOUR_TRUSTSTORE_PASSWORD placeholders).To deploy Cassandra with TLS you can use those parameters:

```console
cluster.internodeEncryption=all
cluster.clientEncryption=true
tlsEncryptionSecretName=cassandra-tls
```

### Initializing the database

The [Bitnami cassandra](https://github.com/bitnami/bitnami-docker-cassandra) image allows having initialization scripts mounted in `/docker-entrypoint.initdb`. This is done in the chart by adding files in the `files/docker-entrypoint-initdb.d` folder (in order to do so, clone this chart) or by setting the `initDBConfigMap` value with a `ConfigMap` (named, for example, `init-db`) that includes the necessary `sh` or `cql` scripts:

```console
initDBConfigMap=init-db
```

## Persistence

The [Bitnami cassandra](https://github.com/bitnami/bitnami-docker-cassandra) image stores the cassandra data at the `/bitnami/cassandra` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Upgrade

### 4.0.0

This release changes uses Bitnami Cassandra container `3.11.4-debian-9-r188`, based on Bash.

### 2.0.0

This release make it possible to specify custom initialization scripts in both cql and sh files.

#### Breaking changes

- `startupCQL` has been removed. Instead, for initializing the database, see [this section](#initializing-the-database).
