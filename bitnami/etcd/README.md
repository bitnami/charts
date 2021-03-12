# etcd

[etcd](https://www.etcd.org/) is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/etcd
```

## Introduction

This chart bootstraps a [etcd](https://github.com/bitnami/bitnami-docker-etcd) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
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

The following tables lists the configurable parameters of the etcd chart and their default values per section/component:

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

### etcd parameters

| Parameter                           | Description                                                                               | Default                                                 |
|-------------------------------------|-------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`                    | etcd image registry                                                                       | `docker.io`                                             |
| `image.repository`                  | etcd image name                                                                           | `bitnami/etcd`                                          |
| `image.tag`                         | etcd image tag                                                                            | `{TAG_NAME}`                                            |
| `image.pullPolicy`                  | etcd image pull policy                                                                    | `IfNotPresent`                                          |
| `image.pullSecrets`                 | Specify docker-registry secret names as an array                                          | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                       | Specify if debug values should be set                                                     | `false`                                                 |
| `auth.rbac.enabled`                 | Switch to enable RBAC authentication                                                      | `true`                                                  |
| `auth.rbac.allowNoneAuthentication` | Allow to use etcd without configuring RBAC authentication                                 | `true`                                                  |
| `auth.rbac.rootPassword`            | Password for the root user                                                                | `nil`                                                   |
| `auth.rbac.existingSecret`          | Name of the existing secret containing the root password                                  | `nil`                                                   |
| `auth.client.secureTransport`       | Switch to encrypt client-to-server communications using TLS certificates                  | `false`                                                 |
| `auth.client.useAutoTLS`            | Switch to automatically create the TLS certificates                                       | `false`                                                 |
| `auth.client.enableAuthentication`  | Switch to enable host authentication using TLS certificates. Requires existing secret     | `secret`                                                |
| `auth.client.existingSecret`        | Name of the existing secret containing cert files for client-to-server communications     | `nil`                                                   |
| `auth.client.certFilename`          | Name of the file containing the client certificate                                        | `cert.pem`                                              |
| `auth.client.certKeyFilename`       | Name of the file containing the client certificate private key                            | `key.pem`                                               |
| `auth.client.caFilename`            | Name of the file containing the client CA certificate                                     | `""`                                                    |
| `auth.peer.secureTransport`         | Switch to encrypt server-to-server communications using TLS certificates                  | `false`                                                 |
| `auth.peer.useAutoTLS`              | Switch to automatically create the TLS certificates                                       | `false`                                                 |
| `auth.peer.enableAuthentication`    | Switch to enable host authentication using TLS certificates. Requires existing secret     | `false`                                                 |
| `auth.peer.existingSecret`          | Name of the existing secret containing cert files for server-to-server communications     | `nil`                                                   |
| `auth.peer.certFilename`            | Name of the file containing the peer certificate                                          | `cert.pem`                                              |
| `auth.peer.certKeyFilename`         | Name of the file containing the peer certificate private key                              | `key.pem`                                               |
| `auth.peer.caFilename`              | Name of the file containing the peer CA certificate                                       | `""`                                                    |
| `initialClusterState`               | Initial cluster state. Allowed values: 'new' or 'existing'                                | `nil`                                                   |
| `maxProcs`                          | Set GOMAXPROCS environment variable to limit the number of CPUs                           | `nil`                                                   |
| `removeMemberOnContainerTermination`| Use a PreStop hook to remove the etcd members from the cluster on container termination   | `true`                                                  |
| `configuration`                     | etcd configuration. Specify content for etcd.conf.yml                                     | `nil`                                                   |
| `existingConfigmap`                 | Name of existing ConfigMap with etcd configuration                                        | `nil`                                                   |
| `command`                           | Default container command (useful when using custom images)                               | `nil`                                                   |
| `args`                              | Default container args (useful when using custom images)                                  | `nil`                                                   |
| `extraEnvVars`                      | Extra environment variables to be set on etcd container                                   | `{}`                                                    |
| `extraEnvVarsCM`                    | Name of existing ConfigMap containing extra env vars                                      | `nil`                                                   |
| `extraEnvVarsSecret`                | Name of existing Secret containing extra env vars                                         | `nil`                                                   |

### etcd statefulset parameters

| Parameter                   | Description                                                                               | Default                        |
|-----------------------------|-------------------------------------------------------------------------------------------|--------------------------------|
| `replicaCount`              | Number of etcd replicas to deploy                                                         | `1`                            |
| `containerPorts.client`     | Client port to expose at container level                                                  | `2379`                         |
| `containerPorts.peer`       | Peer port to expose at container level                                                    | `2380`                         |
| `podSecurityContext`        | etcd pods' Security Context                                                               | Check `values.yaml` file       |
| `containerSecurityContext`  | etcd containers' Security Context                                                         | Check `values.yaml` file       |
| `resources.limits`          | The resources limits for the etcd container                                               | `{}`                           |
| `resources.requests`        | The requested resources for the etcd container                                            | `{}`                           |
| `hostAliases`               | etcd pod host aliases                                                                     | `[]`                           |
| `lifecycleHooks`            | Override default etcd container hooks                                                     | `{}`                           |
| `livenessProbe`             | Liveness probe configuration for etcd                                                     | Check `values.yaml` file       |
| `readinessProbe`            | Readiness probe configuration for etcd                                                    | Check `values.yaml` file       |
| `startupProbe`              | Startup probe configuration for etcd                                                      | Check `values.yaml` file       |
| `customLivenessProbe`       | Override default liveness probe                                                           | `nil`                          |
| `customReadinessProbe`      | Override default readiness probe                                                          | `nil`                          |
| `customStartupProbe`        | Override default startup probe                                                            | `nil`                          |
| `updateStrategy`            | Strategy to use to update pods                                                            | Check `values.yaml` file       |
| `podManagementPolicy`       | Pod management policy for the etcd statefulset                                            | `Parallel`                     |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                           |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                           |
| `affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template) |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template) |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template) |
| `podLabels`                 | Extra labels for etcd pods                                                                | `{}`                           |
| `podAnnotations`            | Annotations for etcd pods                                                                 | `{}`                           |
| `priorityClassName`         | Controller priorityClassName                                                              | `nil`                          |
| `extraVolumeMounts`         | Optionally specify extra list of additional volumeMounts for etcd container(s)            | `[]`                           |
| `extraVolumes`              | Optionally specify extra list of additional volumes for etcd pods                         | `[]`                           |
| `initContainers`            | Add additional init containers to the etcd pods                                           | `{}` (evaluated as a template) |
| `sidecars`                  | Add additional sidecar containers to the etcd pods                                        | `{}` (evaluated as a template) |

### Exposure parameters

| Parameter                          | Description                                                                        | Default                        |
|------------------------------------|------------------------------------------------------------------------------------|--------------------------------|
| `service.type`                     | Kubernetes Service type                                                            | `ClusterIP`                    |
| `service.port`                     | etcd client port                                                                   | `2379`                         |
| `service.clientPortNameOverride`   | etcd client port name override                                                     | `nil`                          |
| `service.peerPort`                 | etcd peer port                                                                     | `2380`                         |
| `service.peerPortNameOverride`     | etcd peer port name override                                                       | `nil`                          |
| `service.nodePorts.clientPort`     | Kubernetes etcd client node port                                                   | `""`                           |
| `service.nodePorts.peerPort`       | Kubernetes etcd peer node port                                                     | `""`                           |
| `service.loadBalancerIP`           | LoadBalancerIP for the service                                                     | `nil`                          |
| `service.loadBalancerSourceRanges` | Address(es) that are allowed when service is LoadBalancer                          | `[]`                           |
| `service.externalIPs`              | ExternalIPs for the service                                                        | `[]`                           |
| `service.annotations`              | Additional annotations for the etcd service                                        | `{}` (evaluated as a template) |

### Persistence parameters

| Parameter                          | Description                                                                        | Default                        |
|------------------------------------|------------------------------------------------------------------------------------|--------------------------------|
| `persistence.enabled`              | Enable etcd data persistence using PVC                                             | `true`                         |
| `persistence.storageClass`         | PVC Storage Class for etcd data volume                                             | `nil`                          |
| `persistence.accessMode`           | PVC Access Mode for etcd data volume                                               | `ReadWriteOnce`                |
| `persistence.size`                 | PVC Storage Request for etcd data volume                                           | `8Gi`                          |
| `persistence.selector`             | Selector to match an existing Persistent Volume                                    | `{}`(evaluated as a template)  |
| `persistence.annotations`          | Annotations for the PVC                                                            | `{}`(evaluated as a template)  |

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

| Parameter                                  | Description                                                                           | Default                                                     |
|--------------------------------------------|---------------------------------------------------------------------------------------|-------------------------------------------------------------|
| `metrics.enabled`                          | Expose etcd metrics                                                                   | `false`                                                     |
| `metrics.podAnnotations`                   | Annotations for enabling prometheus to access the metrics endpoint                    | {`prometheus.io/scrape: "true",prometheus.io/port: "2379"`} |
| `metrics.podMonitor.enabled`               | Create PodMonitor Resource for scraping metrics using PrometheusOperator              | `false`                                                     |
| `metrics.podMonitor.namespace`             | Namespace in which Prometheus is running                                              | `nil`                                                       |
| `metrics.podMonitor.interval`              | Specify the interval at which metrics should be scraped                               | `30s`                                                       |
| `metrics.podMonitor.scrapeTimeout`         | Specify the timeout after which the scrape is ended                                   | `nil`                                                       |
| `metrics.podMonitor.additionalLabels`      | Additional labels that can be used so PodMonitors will be discovered by Prometheus    | `{}`                                                        |
| `metrics.podMonitor.scheme`                | Scheme to use for scraping                                                            | `http`                                                      |
| `metrics.podMonitor.tlsConfig`             | TLS configuration used for scrape endpoints used by Prometheus                        | `nil`                                                       |

### Snapshotting parameters

| Parameter                                       | Description                                                                           | Default                                                     |
|-------------------------------------------------|---------------------------------------------------------------------------------------|-------------------------------------------------------------|
| `startFromSnapshot.enabled`                     | Initialize new cluster recovering an existing snapshot                                | `false`                                                     |
| `startFromSnapshot.existingClaim`               | PVC containing the existing snapshot                                                  | `nil`                                                       |
| `startFromSnapshot.snapshotFilename`            | Snapshot filename                                                                     | `nil`                                                       |
| `disasterRecovery.enabled`                      | Enable auto disaster recovery by periodically snapshotting the keyspace               | `false`                                                     |
| `disasterRecovery.cronjob.schedule`             | Schedule in Cron format to save snapshots                                             | `*/30 * * * *`                                              |
| `disasterRecovery.cronjob.historyLimit`         | Number of successful finished jobs to retain                                          | `1`                                                         |
| `disasterRecovery.cronjob.snapshotHistoryLimit` | Number of etcd snapshots to retain, tagged by date                                    | `1`                                                         |
| `disasterRecovery.cronjob.podAnnotations`       | Pod annotations for cronjob pods                                                      | `{}` (evaluated as a template)                              |
| `disasterRecovery.cronjob.resources.limits`     | Cronjob container resource limits                                                     | `{}`                                                        |
| `disasterRecovery.cronjob.resources.requests`   | Cronjob container resource requests                                                   | `{}`                                                        |
| `disasterRecovery.pvc.existingClaim`            | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template.    | `nil`                                                       |
| `disasterRecovery.pvc.size`                     | PVC Storage Request                                                                   | `2Gi`                                                       |
| `disasterRecovery.pvc.storageClassName`         | Storage Class for snapshots volume                                                    | `nfs`                                                       |

### Other parameters

| Parameter                  | Description                                                    | Default |
|----------------------------|----------------------------------------------------------------|---------|
| `pdb.create`               | Enable/disable a Pod Disruption Budget creation                | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `nil`   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set auth.rbac.rootPassword=secretpassword bitnami/etcd
```

The above command sets the etcd `root` account password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/etcd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Cluster configuration

The Bitnami etcd chart can be used to bootstrap an etcd cluster, easy to scale and with available features to implement disaster recovery.

Refer to the [chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/etcd/get-started/understand-default-configuration/) for more information about all these details.

### Enable security for etcd

The etcd chart can be configured with Role-based access control and TLS encryption to improve its security.

[Learn more about security in the chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/etcd/administration/enable-security/).

### Persistence

The [Bitnami etcd](https://github.com/bitnami/bitnami-docker-etcd) image stores the etcd data at the `/bitnami/etcd` path of the container. Persistent Volume Claims are used to keep the data across statefulsets.

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning by default. An existing PersistentVolumeClaim can also be defined for this purpose.

[Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/etcd/configuration/understand-chart-persistence/).

### Backup and restore the etcd keyspace

The Bitnami etcd chart provides mechanisms to bootstrap the etcd cluster restoring an existing snapshot before initializing. 

[Learn more about backup/restore features in the chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/etcd/administration/backup-restore/).

### Exposing etcd metrics

The metrics exposed by etcd can be exposed to be scraped by Prometheus. This can be done by adding the required annotations for Prometheus to discover the metrics endpoints or creating a PodMonitor entry if you are using the Prometheus Operator.

[Learn more about exposing metrics in the chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/etcd/administration/enable-metrics/).

### Using custom configuration

In order to use custom configuration parameters, two options are available:

- Using environment variables: etcd allows setting environment variables that map to configuration settings. In order to set extra environment variables, you can use the `extraEnvVars` property. Alternatively, you can use a ConfigMap or a Secret with the environment variables using the `extraEnvVarsCM` or the `extraEnvVarsSecret` properties.

```yaml
extraEnvVars:
  - name: ETCD_AUTO_COMPACTION_RETENTION
    value: "0"
  - name: ETCD_HEARTBEAT_INTERVAL
    value: "150"
```

- Using a custom `etcd.conf.yml`: The etcd chart allows mounting a custom `etcd.conf.yml` file as ConfigMap. In order to so, you can use the `configuration` property. Alternatively, you can use an existing ConfigMap using the `existingConfigmap` parameter.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the etcd app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### To 6.0.0

This version introduces several features and performance improvements:

- The statefulset can now be scaled using `kubectl scale` command. Using `helm upgrade` to recalculate available endpoints is no longer needed.
- The scripts used for bootstrapping, runtime reconfiguration, and disaster recovery have been refactored and moved to the etcd container (see [this PR](https://github.com/bitnami/bitnami-docker-etcd/pull/13)) with two purposes: removing technical debt & improving the stability.
- Several parameters were reorganized to simplify the structure and follow the same standard used on other Bitnami charts:
  - `etcd.initialClusterState` is renamed to `initialClusterState`.
  - `statefulset.replicaCount` is renamed to `replicaCount`.
  - `statefulset.podManagementPolicy` is renamed to `podManagementPolicy`.
  - `statefulset.updateStrategy` and `statefulset.rollingUpdatePartition` are merged into `updateStrategy`.
  - `securityContext.*` is deprecated in favor of `podSecurityContext` and `containerSecurityContext`.
  - `configFileConfigMap` is deprecated in favor of `configuration` and `existingConfigmap`.
  - `envVarsConfigMap` is deprecated in favor of `extraEnvVars`, `extraEnvVarsCM` and `extraEnvVarsSecret`.
  - `allowNoneAuthentication` is renamed to `auth.rbac.allowNoneAuthentication`.
- New parameters/features were added:
  - `extraDeploy` to deploy any extra desired object.
  - `initContainers` and `sidecars` to define custom init containers and sidecars.
  - `extraVolumes` and `extraVolumeMounts` to define custom volumes and mount points.
  - Probes can be now customized, and support to startup probes is added.
  - LifecycleHooks can be customized using `lifecycleHooks` parameter.
  - The default command/args can be customized using `command` and `args` parameters.
- Metrics integration with Prometheus Operator does no longer use a ServiceMonitor object, but a PodMonitor instead.

Consequences:

- Backwards compatibility is not guaranteed unless you adapt you **values.yaml** according to the changes described above.

### To 5.2.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 5.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/etcd/administration/upgrade-helm3/).

### To 4.4.14

In this release we addressed a vulnerability that showed the `ETCD_ROOT_PASSWORD` environment variable in the application logs. Users are advised to update immediately. More information in [this issue](https://github.com/bitnami/charts/issues/1901).

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
  --set persistence.enabled=true \
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
