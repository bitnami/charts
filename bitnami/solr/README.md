# Solr

[Solr](https://lucene.apache.org/solr/) is highly reliable, scalable and fault tolerant, providing distributed indexing, replication and load-balanced querying, automated failover and recovery, centralized configuration and more..

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/solr
```

## Introduction

This chart bootstraps a [Solr](https://github.com/bitnami/bitnami-docker-solr) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

-   Kubernetes 1.12+
-   Helm 3.1.0
-   PV provisioner support in the underlying infrastructure
-   ReadWriteMany volumes for deployment scaling

## Installing the Chart

 To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/solr
```

These commands deploy Solr on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all history too.

## Parameters

The following tables lists the configurable parameters of the solr chart and their default values.

### Global parameters

| Parameter                 | Description                                         | Default                                                     |
| ------------------------- | --------------------------------------------------- | ----------------------------------------------------------- |
| `global.imageRegistry`    | Global Docker image registry                        | `nil`                                                       |
| `global.imagePullSecrets` | Global Docker registry secret names as an array     | `[]` (does not add image pull secrets to deployed pods)     |
| `global.storageClass`     | Global storage class for dynamic provisioning       | `nil`                                                       |

### Common parameters

| Parameter                                                 | Description                                                  | Default                                                   |
| --------------------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------- |
| `nameOverride`                                            | String to partially override solr.fullname template with a string | `nil`                                                     |
| `fullnameOverride`                                        | String to fully override solr.fullname template with a string | `nil`                                                     |
| `clusterDomain`                                           | Kubernetes cluster domain                                    | `cluster.local`                                           |
| `commonLabels`                                            | Common lables to add to the Kuberentes objects               | `{}`                                                      |
| `commonAnnotations`                                       | Common annotations to add to the Kubernetes objects          |                                                           |
| `extraDeploy`                                             | Array of extra objects to deploy with the release (evaluated as a template). | `nil`                                                     |
| `replicaCount`                                            | Number of solr replicas                                      | `{}`                                                      |
| `image.registry`                                          | Solr Image registry                                          | `docker.io`                                               |
| `image.repository`                                        | Solr Image name                                              | `bitnami/solr`                                            |
| `image.tag`                                               | Solr Image tag                                               | `{TAG_NAME}`                                              |
| `image.pullPolicy`                                        | Image pull policy                                            | `IfNotPresent`                                            |
| `image.pullSecrets`                                       | Specify docker-registry secret names as an array             | `nil`                                                     |
| `podLabels`                                               | Additional labels for pods pod                               | `{}`                                                      |
| `podAnnotations`                                          | Additional annotations for pods                              | {}                                                        |
| `podManagementPolicy`                                     | Management Policy for Solr StatefulSet                       | `Parallel`                                                |
| `podSecurityContext.fsGroup`                              | Group ID for the pods.                                       | `1001`                                                    |
| `containerSecurityContext.runAsUser`                      | User ID for the containers.                                  | `1001`                                                    |
| `serviceAccount.create`                                   | Specifies whether a ServiceAccount should be created         | `false`                                                   |
| `serviceAccount.name`                                     | The name of the ServiceAccount to create                     | Generated using the `common.names.fullname` template      |
| `persistence.enabled`                                     | Use a PVC to persist data.                                   | `true`                                                    |
| `persistence.annotations`                                 | Persistence Annotations for Solr                             | `{}`                                                      |
| `persistence.mountPath`                                   | Persistence mount path for Solr                              | `{}`                                                      |
| `persistence.storageClass`                                | Storage class of backing PVC                                 | `generic`                                                 |
| `persistence.accessModes`                                 | Persistent Volume Access Modes                               | `[ReadWriteOnce]`                                         |
| `persistence.size`                                        | Size of data volume                                          | `8Gi`                                                     |
| `updateStrategy`                                          | Update strategy for StatefulSet                              | onDelete                                                  |
| `rollingUpdate`                                           | Rolling Update configuration                                 | `nil`                                                     |
| `volumePermissions.enabled`                               | Enable init container that changes volume permissions in the registry (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                   |
| `volumePermissions.image.registry`                        | Init container volume-permissions image registry             | `docker.io`                                               |
| `volumePermissions.image.repository`                      | Init container volume-permissions image name                 | `bitnami/bitnami-shell`                                   |
| `volumePermissions.image.tag`                             | Init container volume-permissions image tag                  | `"10"`                                                    |
| `volumePermissions.image.pullPolicy`                      | Init container volume-permissions image pull policy          | `Always`                                                  |
| `volumePermissions.resources`                             | Init container volume-permissions CPU/Memory resource requests/limits | {}                                                        |
| `volumePermissions.image.pullSecrets`                     | Specify docker-registry secret names as an array             | `[]` (does not add image pull secrets to deployed pods)   |
| `volumePermissions.containerSecurityContext.enabled`      | Container security context for volume permissions            | `true`                                                    |
| `volumePermissions.containerSecurityContext.runAsUser`    | Container security context fsGroup for volume permissions    | `1001`                                                    |
| `volumePermissions.containerSecurityContext.runAsNonRoot` | Container security context runAsNonRoot for volume permissions | `true`                                                    |
| `lifecycleHooks`                                          | Lifecycle hook to automate configuration before or after start | `{}`                                                      |

### Solr statefulset parameters

| Parameter                              | Description                                                  | Default                            |
| -------------------------------------- | ------------------------------------------------------------ | ---------------------------------- |
| `coreName`                             | Name of the default core to be created                       | `my-core`                          |
| `cloudEnabled`                         | Enable Solr cloud mode                                       | `true`                             |
| `cloudBootstrap`                       | Bootstrap the Solr cloud cluster on the install              | `true`                             |
| `collection`                           | Name of the collection to be created                         | `my-collection`                    |
| `collectionShards`                     | Number of collection shards                                  | `1`                                |
| `collectionReplicas`                   | Number of collection replicas                                | `2`                                |
| `containerPort`                        | Port number where Solr is running inside the container       | `8983`                             |
| `serverDirectory`                      | Name of the created directory for the server                 | `server`                           |
| `javaMem`                              | Java memory options to pass to the Solr container            | `nil`                              |
| `heap`                                 | Java Heap options to pass to the solr container              | `nil`                              |
| `authentication.enabled`               | Enable Solr authentication                                   | `true`                             |
| `authentication.adminUsername`         | Solr admin username                                          | `admin`                            |
| `authentication.adminPassword`         | Solr admin password. Autogenerated if not provided.          | `mil`                              |
| `existingSecret`                       | Existing secret with Solr password                           | `nil`                              |
| `command`                              | Override Solr entrypoint string.                             | `nil`                              |
| `args`                                 | Arguments for the provided command if needed                 | `nil`                              |
| `podAffinityPreset`                    | Solr pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                               |
| `podAntiAffinityPreset`                | Solr pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `soft`                             |
| `nodeAffinityPreset.type`              | Solr node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                               |
| `nodeAffinityPreset.key`               | Solr node label key to match Ignored if `affinity` is set.   | `""`                               |
| `nodeAffinityPreset.values`            | Solr node label values to match. Ignored if `affinity` is set. | `[]`                               |
| `affinity`                             | Affinity for Solr pods assignment                            | `{}` (evaluated as a template)     |
| `nodeSelector`                         | Node labels for Solr pods assignment                         | `{}` (evaluated as a template)     |
| `tolerations`                          | Tolerations for Solr pods assignment                         | `[]` (evaluated as a template)     |
| `livenessProbe.enabled`                | Turn on and off liveness probe.                              | `true`                             |
| `livenessProbe.initialDelaySeconds`    | Delay before liveness probe is initiated.                    | `30`                               |
| `livenessProbe.periodSeconds`          | How often to perform the probe.                              | `30`                               |
| `livenessProbe.timeoutSeconds`         | When the probe times out.                                    | `5`                                |
| `livenessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                |
| `livenessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded. | `5`                                |
| `readinessProbe.enabled`               | Turn on and off readiness probe.                             | `true`                             |
| `readinessProbe.initialDelaySeconds`   | Delay before readiness probe is initiated.                   | `5`                                |
| `readinessProbe.periodSeconds`         | How often to perform the probe.                              | `10`                               |
| `readinessProbe.timeoutSeconds`        | When the probe times out.                                    | `1`                                |
| `readinessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                |
| `readinessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded. | `5`                                |
| `customLivenessProbe`                  | Override default liveness probe                              | `nil`                              |
| `customReadinessProbe`                 | Override default readiness probe                             | `nil`                              |
| `extraVolumes`                         | Array of extra volumes to be added to all pods (evaluated as a template) | `[]`                               |
| `extraVolumeMounts`                    | Array of extra volume mounts to be added to all pods (evaluated as a template) | `[]`                               |
| `hostAliases`                          | Add deployment host aliases                                  | `[]`                               |
| `affinity`                             | Affinity settings for Solr pod assignment                    | `{}`                               |
| `extraEnvVars`                         | Array containing extra env vars to be added to all pods (evaluated as a template) | `[]`                               |
| `extraEnvVarsCM`                       | ConfigMap containing extra env vars to be added to all pods (evaluated as a template) | `nil`                              |
| `extraEnvVarsSecret`                   | Secret containing extra env vars to be added to all pods (evaluated as a template) | `nil`                              |
| `initContainers`                       | Init containers to add to the cronjob container              | `{}`                               |
| `sidecars`                             | Attach additional containers to the pod (evaluated as a template) | `nil`                              |
| `resources`                            | Solr CPU/Memory resource requests/limits                     | `{Memory: "256Mi", CPU: "100m"}`   |

### Solr SSL parameters

| Parameter                              | Description                                                  | Default                            |
| -------------------------------------- | ------------------------------------------------------------ | ---------------------------------- |
| `tls.enabled`                          | Enable the TLS/SSL configuration                             | `false`                            |
| `tls.certificatesSecretName`           | Set the name of the secret that contains the certificates. It should contains two keys called "keystore.p12" and "truststore.12"                                                  | `nil`                             |
| `tls.passwordsSecretName`              | Set the name of the secret that contains the passwords for the certificate files. It should contains two keys called "tls-keystore-password" and "tls-truststore-password".       | `nil`                             |

### Solr Traffic Exposure Parameters

| Parameter                        | Description                                              | Default                        |
| -------------------------------- | -------------------------------------------------------- | ------------------------------ |
| `service.port`                   | Kubernetes Service port.                                 | `6379`                         |
| `service.annotations`            | annotations for solr service                             | {}                             |
| `service.labels`                 | Additional labels for solr service                       | {}                             |
| `service.type`                   | Service type for default solr service                    | `ClusterIP`                    |
| `service.nodePorts.http`         | Node ports for the http service                          | `""`                           |
| `service.nodePorts.https`        | Node ports for the https service                         | `""`                           |
| `service.loadBalancerIP`         | loadBalancerIP if service.type is `LoadBalancer`         | `nil`                          |
| `ingress.enabled`                | Enable ingress controller resource                       | `false`                        |
| `ingress.apiVersion`             | Override default Ingress Api version                     | `nil`                          |
| `ingress.certManager`            | Add annotations for cert-manager                         | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                    | `solr.local`                   |
| `ingress.pathType`               | Path type for the ingress resource                       | `ImplementationSpecific`       |
| `ingress.path`                   | Default path for the ingress resource                    | `/`                            |
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

### Zookeeper parameters

| Parameter                                       | Description                                                  | Default                                                      |
| ----------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `zookeeper.enabled`                             | Enable Zookeeper deployment. Needed for Solr cloud.          | `true`                                                       |
| `zookeeper.persistence.enabled`                 | Enabled persistence for Zookeeper                            | `true`                                                       |
| `zookeeper.port`                                | Zookeeper port service port                                  | `2181`                                                       |
| `zookeeper.replicaCount`                        | Number of Zookeeper cluster replicas                         | `3`                                                          |
| `zookeeper.fourlwCommandsWhitelist`             | Zookeeper four letters commands to enable                    | `srvr,mntr,conf,ruok`                                        |
| `externalZookeeper.servers`                     | Servers for an already existing Zookeeper.                   | `[]`                                                         |
| `zookeeper.service.publishNotReadyAddresses`    | Publish not Ready ips for zookeeper                          | `true`                                                       |

### Exporter deployment parameters

| Parameter                                       | Description                                                  | Default                                                      |
| ----------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `exporter.enabled`                              | Start a side-car prometheus exporter                         | `false`                                                      |
| `exporter.image.registry`                       | Solr exporter image registry                                 | `docker.io`                                                  |
| `exporter.image.repository`                     | Solr exporter image name                                     | `bitnami/solr-exporter`                                      |
| `exporter.image.tag`                            | Solr exporter image tag                                      | `{TAG_NAME}`                                                 |
| `exporter.image.pullPolicy`                     | Image pull policy                                            | `IfNotPresent`                                               |
| `exporter.image.pullSecrets`                    | Specify docker-registry secret names as an array             | `nil`                                                        |
| `exporter.updateStrategy`                       | Specify exporter deployment update strategy                  | `RollingUpdate`                                              |
| `exporter.configFile`                           | Config file for the Solr prometheus exporter                 | `/opt/bitnami/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml` |
| `exporter.port`                                 | Solr exporter port                                           | `9983`                                                       |
| `exporter.threads`                              | Number of Solr exporter Threads                              | `7`                                                          |
| `exporter.podLabels`                            | Additional labels for Metrics exporter pod                   | {}                                                           |
| `exporter.podAnnotations`                       | Additional annotations for Metrics exporter pod              | {}                                                           |
| `exporter.resources`                            | Exporter resource requests/limit                             | Memory: `256Mi`, CPU: `100m`                                 |
| `exporter.service.type`                         | Kubernetes Service type (solr metrics)                       | `ClusterIP`                                                  |
| `exporter.service.annotations`                  | Annotations for the services to monitor.                     | {}                                                           |
| `exporter.service.labels`                       | Additional labels for the metrics service                    | {}                                                           |
| `exporter.service.loadBalancerIP`               | loadBalancerIP if solr metrics service type is `LoadBalancer` | `nil`                                                        |
| `exporter.service.nodePorts.http`               | Node ports for the http exporter service                     | `""`                                                         |
| `exporter.service.nodePorts.https`              | Node ports for the https exporter service                    | `""`                                                         |
| `exporter.service.loadBalancerSourceRanges`     | Exporter Load Balancer Source ranges                         | `nil`                                                        |
| `exporter.command`                              | Override Solr entrypoint string.                             | `nil`                                                        |
| `exporter.args`                                 | Arguments for the provided command if needed                 | `nil`                                                        |
| `exporter.podAffinityPreset`                    | Solr pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                                         |
| `exporter.podAntiAffinityPreset`                | Solr pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `soft`                                                       |
| `exporter.nodeAffinityPreset.type`              | Solr node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                                         |
| `exporter.nodeAffinityPreset.key`               | Solr node label key to match Ignored if `affinity` is set.   | `""`                                                         |
| `exporter.nodeAffinityPreset.values`            | Solr node label values to match. Ignored if `affinity` is set. | `[]`                                                         |
| `exporter.hostAliases`                          | Add deployment host aliases                                  | `[]`                                                         |
| `exporter.affinity`                             | Affinity for Solr pods assignment                            | `{}` (evaluated as a template)                               |
| `exporter.nodeSelector`                         | Node labels for Solr pods assignment                         | `{}` (evaluated as a template)                               |
| `exporter.tolerations`                          | Tolerations for Solr pods assignment                         | `[]` (evaluated as a template)                               |
| `exporter.livenessProbe.enabled`                | Turn on and off liveness probe.                              | `true`                                                       |
| `exporter.livenessProbe.initialDelaySeconds`    | Delay before liveness probe is initiated.                    | `10`                                                         |
| `exporter.livenessProbe.periodSeconds`          | How often to perform the probe.                              | `5`                                                          |
| `exporter.livenessProbe.timeoutSeconds`         | When the probe times out.                                    | `15`                                                         |
| `exporter.livenessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed. | `15`                                                         |
| `exporter.livenessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded. | `15`                                                         |
| `exporter.readinessProbe.enabled`               | Turn on and off readiness probe.                             | `true`                                                       |
| `exporter.readinessProbe.initialDelaySeconds`   | Delay before readiness probe is initiated.                   | `10`                                                         |
| `exporter.readinessProbe.periodSeconds`         | How often to perform the probe.                              | `5`                                                          |
| `exporter.readinessProbe.timeoutSeconds`        | When the probe times out.                                    | `15`                                                         |
| `exporter.readinessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed. | `15`                                                         |
| `exporter.readinessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded. | `15`                                                         |
| `exporter.customLivenessProbe`                  | Override default liveness probe                              | `nil`                                                        |
| `exporter.customReadinessProbe`                 | Override default readiness probe                             | `nil`                                                        |
| `exporter.extraVolumes`                         | Array of extra volumes to be added to all pods (evaluated as a template) | `[]`                                                         |
| `exporter.extraVolumeMounts`                    | Array of extra volume mounts to be added to all pods (evaluated as a template) | `[]`                                                         |
| `exporter.affinity`                             | Affinity settings for Solr pod assignment                    | `{}`                                                         |
| `exporter.extraEnvVars`                         | Array containing extra env vars to be added to all pods (evaluated as a template) | `[]`                                                         |
| `exporter.extraEnvVarsCM`                       | ConfigMap containing extra env vars to be added to all pods (evaluated as a template) | `nil`                                                        |
| `exporter.extraEnvVarsSecret`                   | Secret containing extra env vars to be added to all pods (evaluated as a template) | `nil`                                                        |
| `exporter.initContainers`                       | Init containers to add to the cronjob container              | `{}`                                                         |
| `exporter.sidecars`                             | Attach additional containers to the pod (evaluated as a template) | `nil`                                                        |
| `exporter.podSecurityContext.fsGroup`           | Group ID for the pods.                                       | `1001`                                                       |
| `exporter.containerSecurityContext.runAsUser`   | User ID for the containers.                                  | `1001`                                                       |
| `exporter.service.port`                         | Kubernetes Service port.                                     | `6379`                                                       |
| `exporter.service.annotations`                  | annotations for solr exporter service                        | {}                                                           |
| `exporter.service.labels`                       | Additional labels for solr exporter service                  | {}                                                           |
| `exporter.service.type`                         | Service type for default solr exporter service               | `ClusterIP`                                                  |
| `exporter.service.nodePorts`                    | Node ports for the service                                   | `{}`                                                         |
| `exporter.service.loadBalancerIP`               | loadBalancerIP if service.type is `LoadBalancer`             | `nil`                                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set solrCloud.enabled=true bitnami/solr
```

The above command enabled the Solr Cloud mode.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/solr
```

> **Tip**: You can use the default [values.yaml](values.yaml)
>
> NOTE: The Solr exporter is not supported when deploying Solr with authentication enabled.

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Solr version

To modify the Solr version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/solr/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ZOOKEEPER_VERSION
    value: 6
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Solr (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Solr](https://github.com/bitnami/bitnami-docker-solr) image can persist data. If enabled, the persisted path is `/bitnami/solr` by default.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adding extra volumes

The Bitnami Solr chart supports mounting extra volumes (either PVCs, secrets or configmaps) by using the `extraVolumes` and `extraVolumeMounts` property. This can be combined with advanced operations like adding extra init containers and sidecars.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
