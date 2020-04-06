# etcd

[etcd](https://www.etcd.org/) is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/etcd
```

## Introduction

This chart bootstraps a [etcd](https://github.com/bitnami/bitnami-docker-etcd) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/etcd
```

These commands deploy etcd on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the etcd chart and their default values.

| Parameter                                         | Description                                                                                                                                               | Default                                                     |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `global.imageRegistry`                            | Global Docker image registry                                                                                                                              | `nil`                                                       |
| `global.imagePullSecrets`                         | Global Docker registry secret names as an array                                                                                                           | `[]` (does not add image pull secrets to deployed pods)     |
| `global.storageClass`                             | Global storage class for dynamic provisioning                                                                                                             | `nil`                                                       |
| `image.registry`                                  | etcd image registry                                                                                                                                       | `docker.io`                                                 |
| `image.repository`                                | etcd image name                                                                                                                                           | `bitnami/etcd`                                              |
| `image.tag`                                       | etcd image tag                                                                                                                                            | `{TAG_NAME}`                                                |
| `image.pullPolicy`                                | etcd image pull policy                                                                                                                                    | `IfNotPresent`                                              |
| `image.pullSecrets`                               | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods)     |
| `image.debug`                                     | Specify if debug values should be set                                                                                                                     | `false`                                                     |
| `nameOverride`                                    | String to partially override etcd.fullname template with a string (will prepend the release name)                                                         | `nil`                                                       |
| `fullnameOverride`                                | String to fully override etcd.fullname template with a string                                                                                             | `nil`                                                       |
| `volumePermissions.enabled`                       | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                     |
| `volumePermissions.image.registry`                | Init container volume-permissions image registry                                                                                                          | `docker.io`                                                 |
| `volumePermissions.image.repository`              | Init container volume-permissions image name                                                                                                              | `bitnami/minideb`                                           |
| `volumePermissions.image.tag`                     | Init container volume-permissions image tag                                                                                                               | `buster`                                                    |
| `volumePermissions.image.pullPolicy`              | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                    |
| `volumePermissions.resources`                     | Init container resource requests/limit                                                                                                                    | `nil`                                                       |
| `statefulset.updateStrategy`                      | Update strategy for the stateful set                                                                                                                      | `RollingUpdate`                                             |
| `statefulset.rollingUpdatePartition`              | Partition for Rolling Update strategy                                                                                                                     | `nil`                                                       |
| `statefulset.podManagementPolicy`                 | Pod management policy for the stateful set                                                                                                                | `OrderedReady`                                              |
| `statefulset.replicaCount`                        | Number of etcd nodes                                                                                                                                      | `1`                                                         |
| `configFileConfigMap`                             | ConfigMap that contains a etcd.conf.yaml to be mounted                                                                                                    | `nil`                                                       |
| `envVarsConfigMap`                                | ConfigMap that contains environment variables to be set in the container                                                                                  | `nil`                                                       |
| `allowNoneAuthentication`                         | Allow to use etcd without configuring RBAC authentication                                                                                                 | `true`                                                      |
| `maxProcs`                                        | Set GOMAXPROCS environment variable to limit the number of CPUs                                                                                           | `nil`                                                       |
| `auth.rbac.enabled`                               | Switch to enable the etcd authentication.                                                                                                                 | `true`                                                      |
| `auth.rbac.rootPassword`                          | Password for the root user                                                                                                                                | `nil`                                                       |
| `auth.rbac.existingSecret`                        | Name of the existing secret containing the root password                                                                                                  | `nil`                                                       |
| `auth.client.secureTransport`                     | Switch to encrypt client communication using TLS certificates                                                                                             | `false`                                                     |
| `auth.client.useAutoTLS`                          | Switch to automatically create the TLS certificates                                                                                                       | `false`                                                     |
| `auth.client.enableAuthentication`                | Switch to enable host authentication using TLS certificates. Requires existing secret.                                                                    | `secret`                                                    |
| `auth.client.existingSecret`                      | Name of the existing secret containing cert files for client communication.                                                                               | `nil`                                                       |
| `auth.peer.secureTransport`                       | Switch to encrypt peer communication using TLS certificates                                                                                               | `false`                                                     |
| `auth.peer.useAutoTLS`                            | Switch to automatically create the TLS certificates                                                                                                       | `false`                                                     |
| `auth.peer.enableAuthentication`                  | Switch to enable host authentication using TLS certificates. Requires existing secret.                                                                    | `false`                                                     |
| `auth.peer.existingSecret`                        | Name of the existing secret containing cert files for peer communication.                                                                                 | `nil`                                                       |
| `securityContext.enabled`                         | Enable security context                                                                                                                                   | `true`                                                      |
| `securityContext.fsGroup`                         | Group ID for the container                                                                                                                                | `1001`                                                      |
| `securityContext.runAsUser`                       | User ID for the container                                                                                                                                 | `1001`                                                      |
| `clusterDomain`                                   | Default Kubernetes cluster domain                                                                                                                         | `cluster.local`                                             |
| `service.type`                                    | Kubernetes Service type                                                                                                                                   | `ClusterIP`                                                 |
| `service.port`                                    | etcd client port                                                                                                                                          | `2379`                                                      |
| `service.peerPort`                                | etcd peer port                                                                                                                                            | `2380`                                                      |
| `service.nodePorts.clientPort`                    | Kubernetes etcd client node port                                                                                                                          | `""`                                                        |
| `service.nodePorts.peerPort`                      | Kubernetes etcd peer node port                                                                                                                            | `""`                                                        |
| `service.annotations`                             | Annotations for etcd service                                                                                                                              | `{}`                                                        |
| `service.loadBalancerIP`                          | loadBalancerIP if etcd service type is `LoadBalancer`                                                                                                     | `nil`                                                       |
| `persistence.enabled`                             | Enable persistence using PVC                                                                                                                              | `true`                                                      |
| `persistence.storageClass`                        | PVC Storage Class for etcd volume                                                                                                                         | `nil`                                                       |
| `persistence.accessMode`                          | PVC Access Mode for etcd volume                                                                                                                           | `ReadWriteOnce`                                             |
| `persistence.size`                                | PVC Storage Request for etcd volume                                                                                                                       | `8Gi`                                                       |
| `persistence.annotations`                         | Annotations for the PVC                                                                                                                                   | `{}`                                                        |
| `resources`                                       | CPU/Memory resource requests/limits                                                                                                                       | Memory: `256Mi`, CPU: `250m`                                |
| `livenessProbe.enabled`                           | Turn on and off liveness probe                                                                                                                            | `true`                                                      |
| `livenessProbe.initialDelaySeconds`               | Delay before liveness probe is initiated                                                                                                                  | `10`                                                        |
| `livenessProbe.periodSeconds`                     | How often to perform the probe                                                                                                                            | `10`                                                        |
| `livenessProbe.timeoutSeconds`                    | When the probe times out                                                                                                                                  | `5`                                                         |
| `livenessProbe.failureThreshold`                  | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `2`                                                         |
| `livenessProbe.successThreshold`                  | Minimum consecutive successes for the probe to be considered successful after having failed                                                               | `1`                                                         |
| `readinessProbe.enabled`                          | Turn on and off readiness probe                                                                                                                           | `true`                                                      |
| `readinessProbe.initialDelaySeconds`              | Delay before liveness probe is initiated                                                                                                                  | `15`                                                        |
| `readinessProbe.periodSeconds`                    | How often to perform the probe                                                                                                                            | `10`                                                        |
| `readinessProbe.timeoutSeconds`                   | When the probe times out                                                                                                                                  | `5`                                                         |
| `readinessProbe.failureThreshold`                 | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `6`                                                         |
| `readinessProbe.successThreshold`                 | Minimum consecutive successes for the probe to be considered successful after having failed                                                               | `1`                                                         |
| `podAnnotations`                                  | Annotations to be added to pods                                                                                                                           | `{}`                                                        |
| `affinity`                                        | Map of node/pod affinities                                                                                                                                | `{}` (The value is evaluated as a template)                 |
| `nodeSelector`                                    | Node labels for pod assignment                                                                                                                            | `{}` (The value is evaluated as a template)                 |
| `tolerations`                                     | Tolerations for pod assignment                                                                                                                            | `[]` (The value is evaluated as a template)                 |
| `priorityClassName`                               | Name of the existing priority class to be used by etcd pods.                                                                                              | `""`                                                        |
| `metrics.enabled`                                 | Enable Prometheus exporter to expose etcd metrics                                                                                                         | `false`                                                     |
| `metrics.podAnnotations`                          | Annotations for enabling prometheus to access the metrics endpoint                                                                                        | {`prometheus.io/scrape: "true",prometheus.io/port: "2379"`} |
| `metrics.serviceMonitor.enabled`                  | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                    | `false`                                                     |
| `metrics.serviceMonitor.namespace`                | Namespace in which Prometheus is running                                                                                                                  | `nil`                                                       |
| `metrics.serviceMonitor.interval`                 | Interval at which metrics should be scraped.                                                                                                              | `nil` (Prometheus Operator default value)                   |
| `metrics.serviceMonitor.scrapeTimeout`            | Timeout after which the scrape is ended                                                                                                                   | `nil` (Prometheus Operator default value)                   |
| `metrics.serviceMonitor.selector`                 | Prometheus instance selector labels                                                                                                                       | `nil`                                                       |
| `startFromSnapshot.enabled`                       | Initialize new cluster recovering an existing snapshot                                                                                                    | `false`                                                     |
| `startFromSnapshot.existingClaim`                 | PVC containing the existing snapshot                                                                                                                      | `nil`                                                       |
| `startFromSnapshot.snapshotFilename`              | Snapshot filename                                                                                                                                         | `nil`                                                       |
| `disasterRecovery.enabled`                        | Enable auto disaster recovery by periodically snapshotting the keyspace                                                                                   | `false`                                                     |
| `disasterRecovery.debug`                          | Enable debug logging for snapshots                                                                                                                        | `false`                                                     |
| `disasterRecovery.cronjob.schedule`               | Schedule in Cron format to save snapshots                                                                                                                 | `*/30 * * * *`                                              |
| `disasterRecovery.cronjob.historyLimit`           | Number of successful finished jobs to retain                                                                                                              | `1`                                                         |
| `disasterRecovery.cronjob.snapshotHistoryLimit`   | Number of etcd snapshots to retain, tagged by date                                                                                                        | `1`                                                         |
| `disasterRecovery.cronjob.podAnnotations`         | Pod annotations for cronjob pods                                                                                                                          | `{}`                                                        |
| `disasterRecovery.pvc.existingClaim`              | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template.                                                                        | `nil`                                                       |
| `disasterRecovery.pvc.size`                       | PVC Storage Request                                                                                                                                       | `2Gi`                                                       |
| `disasterRecovery.pvc.storageClassName`           | Storage Class for snapshots volume                                                                                                                        | `nfs`                                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set auth.rbac.rootPassword=secretpassword bitnami/etcd
```

The above command sets the etcd `root` account password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/etcd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Number of etcd nodes:
```diff
- statefulset.replicaCount: 1
+ statefulset.replicaCount: 3
```

- Switch to encrypt client communication using TLS certificates:
```diff
- auth.client.secureTransport: false
+ auth.client.secureTransport: true
```

- Switch to enable host authentication using TLS certificates:
```diff
- auth.client.enableAuthentication: false
+ auth.client.enableAuthentication: true
```

- Switch to encrypt peer communication using TLS certificates:
```diff
- auth.peer.secureTransport: false
+ auth.peer.secureTransport: true
```

- Switch to automatically create the TLS certificates:
```diff
- auth.peer.useAutoTLS: false
+ auth.peer.useAutoTLS: true
```

- Enable prometheus to access etcd metrics endpoint:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

To horizontally scale this chart once it has been deployed, you can upgrade the deployment using a new value for the `statefulset.replicaCount` parameter.

### Using custom configuration

In order to use custom configuration parameters, two options are available:

- Using environment variables: etcd allows setting environment variables that map to configuration settings. In order to set extra environment variables, use the `envVarsConfigMap` value to point to a ConfigMap (shown in the below example) that contains them. This ConfigMap can be created with the `-f /tmp/configurationEnvVars.yaml` flag. Then deploy the chart with the `envVarsConfigMap=etcd-env-vars` parameter:

```console
$ cat << EOF > /tmp/configurationEnvVars.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: etcd-env-vars
  namespace: default
data:
  ETCD_AUTO_COMPACTION_RETENTION: "0"
  ETCD_HEARTBEAT_INTERVAL: "150"
EOF
```

- Using a custom `etcd.conf.yml`: The etcd chart allows mounting a custom etcd.conf.yml file as ConfigMap (named, for example, etcd-conf) and deploy it using the `configFileConfigMap=etcd-conf` parameter.

### Enable security for etcd

#### Configure RBAC

In order to enable [Role-based access control for etcd](https://coreos.com/etcd/docs/latest/op-guide/authentication.html) you can set the following parameters:

```console
auth.rbac.enabled=true
auth.rbac.rootPassword=YOUR-PASSWORD
```

The previous command will deploy etcd creating a `root` user with its associate `root` role with access to everything. The rest of users will use the `guest` role and won't have permissions to do anything.

#### Configure certificated for peer communication

In order to enable secure transport between peer nodes deploy the helm chart with these options:

```console
auth.peer.secureTransport=true
auth.peer.useAutoTLS=true
```

#### Configure certificates for client communication

In order to enable secure transport between client and server you have to create a secret containing the cert and key files and the CA used to sign those client certificates.

You can create that secret and deploy the helm chart with these options:

```console
auth.client.secureTransport=true
auth.client.enableAuthentication=true
auth.client.existingSecret=etcd-client-certs
```

> Ref: [etcd security model](https://coreos.com/etcd/docs/latest/op-guide/security.html)
>
> Ref: [Generate self-signed certificagtes for etcd](https://coreos.com/os/docs/latest/generate-self-signed-certificates.html)

### Disaster recovery

You can enable auto disaster recovery by periodically snapshotting the keyspace. If the cluster permanently loses more than (N-1)/2 members, it tries to recover the cluster from a previous snapshot. You can enable it using the following parameters:

```console
persistence.enable=true
disasterRecovery.enabled=true
disasterRecovery.pvc.size=2Gi
disasterRecovery.pvc.storageClassName=nfs
```

> **Note**: Disaster recovery feature requires using volumes with ReadWriteMany access mode. For instance, you can use the stable/nfs-server-provisioner chart to provide NFS PVCs.

## Persistence

The [Bitnami etcd](https://github.com/bitnami/bitnami-docker-etcd) image stores the etcd data at the `/bitnami/etcd` path of the container. Persistent Volume Claims are used to keep the data across statefulsets.

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. See the [Parameters](#parameters) section to configure the PVC.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Notable changes

### 4.4.14

In this release we addressed a vulnerability that showed the `ETCD_ROOT_PASSWORD` environment variable in the application logs. Users are advised to update immediately. More information in [this issue](https://github.com/bitnami/charts/issues/1901).


## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed. The following notables changes were included:

- **etcdctl** uses v3 API.
- Adds support for auto disaster recovery.
- Labels are adapted to follow the Helm charts best practices.

To upgrade from previous charts versions, create a snapshot of the keyspace and restore it in a new etcd cluster. Only v3 API data can be restored.
You can use the command below to upgrade your chart by starting a new cluster using an existing snapshot, available in an existing PVC, to initialize the members:

```console
$ helm install new-release bitnami/etcd \
  --set statefulset.replicaCount=3 \
  --set persistence.enable=true \
  --set persistence.size=8Gi \
  --set startFromSnapshot.enabled=true \
  --set startFromSnapshot.existingClaim=my-claim \
  --set startFromSnapshot.snapshotFilename=my-snapshot.db
```

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is etcd:

```console
$ kubectl delete statefulset etcd --cascade=false
```
