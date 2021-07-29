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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                                                          | Value           |
| ------------------- | ------------------------------------------------------------------------------------ | --------------- |
| `nameOverride`      | String to partially override solr.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override solr.fullname template                                      | `""`            |
| `clusterDomain`     | Kubernetes cluster domain                                                            | `cluster.local` |
| `commonLabels`      | Add labels to all the deployed resources                                             | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                        | `{}`            |
| `extraDeploy`       | Extra objects to deploy (value evaluated as a template)                              | `[]`            |


### Solr parameters

| Name                           | Description                                                   | Value                 |
| ------------------------------ | ------------------------------------------------------------- | --------------------- |
| `image.registry`               | Solr image registry                                           | `docker.io`           |
| `image.repository`             | Solr image repository                                         | `bitnami/solr`        |
| `image.tag`                    | Solr image tag (immutable tags are recommended)               | `8.9.0-debian-10-r15` |
| `image.pullPolicy`             | image pull policy                                             | `IfNotPresent`        |
| `image.pullSecrets`            | Specify docker-registry secret names as an array              | `[]`                  |
| `coreName`                     | Solr core name to be created                                  | `my-core`             |
| `cloudEnabled`                 | Enable Solr cloud mode                                        | `true`                |
| `cloudBootstrap`               | Enable cloud bootstrap. It will be performed from the node 0. | `true`                |
| `collection`                   | Solr collection name                                          | `my-collection`       |
| `collectionShards`             | Number of collection shards                                   | `1`                   |
| `collectionReplicas`           | Number of collection replicas                                 | `2`                   |
| `containerPort`                | Port number where Solr is running inside the container        | `8983`                |
| `serverDirectory`              | Name of the created directory for the server                  | `server`              |
| `javaMem`                      | Java memory options to pass to the Solr container             | `""`                  |
| `heap`                         | Java Heap options to pass to the solr container               | `""`                  |
| `authentication.enabled`       | Enable Solr authentication                                    | `true`                |
| `authentication.adminUsername` | Solr admin username                                           | `admin`               |
| `authentication.adminPassword` | Solr admin password. Autogenerated if not provided.           | `""`                  |
| `existingSecret`               | Existing secret with Solr password                            | `""`                  |
| `command`                      | Override Solr entrypoint string                               | `[]`                  |
| `args`                         | Arguments for the provided command if needed                  | `[]`                  |
| `extraEnvVars`                 | Additional environment variables to set                       | `[]`                  |
| `extraEnvVarsCM`               | ConfigMap with extra environment variables                    | `""`                  |
| `extraEnvVarsSecret`           | Secret with extra environment variables                       | `""`                  |


### Solr statefulset parameters

| Name                                                      | Description                                                                                                                                         | Value                   |
| --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `hostAliases`                                             | Deployment pod host aliases                                                                                                                         | `[]`                    |
| `replicaCount`                                            | Number of solr replicas                                                                                                                             | `3`                     |
| `livenessProbe.enabled`                                   | Enable livenessProbe                                                                                                                                | `true`                  |
| `livenessProbe.initialDelaySeconds`                       | Initial delay seconds for livenessProbe                                                                                                             | `30`                    |
| `livenessProbe.periodSeconds`                             | Period seconds for livenessProbe                                                                                                                    | `10`                    |
| `livenessProbe.timeoutSeconds`                            | Timeout seconds for livenessProbe                                                                                                                   | `5`                     |
| `livenessProbe.failureThreshold`                          | Failure threshold for livenessProbe                                                                                                                 | `6`                     |
| `livenessProbe.successThreshold`                          | Success threshold for livenessProbe                                                                                                                 | `1`                     |
| `readinessProbe.enabled`                                  | Enable readinessProbe                                                                                                                               | `true`                  |
| `readinessProbe.initialDelaySeconds`                      | Initial delay seconds for readinessProbe                                                                                                            | `5`                     |
| `readinessProbe.periodSeconds`                            | Period seconds for readinessProbe                                                                                                                   | `10`                    |
| `readinessProbe.timeoutSeconds`                           | Timeout seconds for readinessProbe                                                                                                                  | `5`                     |
| `readinessProbe.failureThreshold`                         | Failure threshold for readinessProbe                                                                                                                | `6`                     |
| `readinessProbe.successThreshold`                         | Success threshold for readinessProbe                                                                                                                | `1`                     |
| `resources.limits`                                        | The resources limits for the container                                                                                                              | `{}`                    |
| `resources.requests`                                      | The requested resources for the container                                                                                                           | `{}`                    |
| `containerSecurityContext.enabled`                        | Enable Solr containers' Security Context                                                                                                            | `true`                  |
| `containerSecurityContext.runAsUser`                      | User ID for the containers                                                                                                                          | `1001`                  |
| `containerSecurityContext.runAsNonRoot`                   | Enable Solr containers' Security Context runAsNonRoot                                                                                               | `true`                  |
| `podSecurityContext.enabled`                              | Enable Solr pods' Security Context                                                                                                                  | `true`                  |
| `podSecurityContext.fsGroup`                              | Group ID for the pods.                                                                                                                              | `1001`                  |
| `podAffinityPreset`                                       | Solr pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                            | `""`                    |
| `podAntiAffinityPreset`                                   | Solr pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                       | `soft`                  |
| `nodeAffinityPreset.type`                                 | Solr node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                      | `""`                    |
| `nodeAffinityPreset.key`                                  | Solr node label key to match Ignored if `affinity` is set.                                                                                          | `""`                    |
| `nodeAffinityPreset.values`                               | Solr node label values to match. Ignored if `affinity` is set.                                                                                      | `[]`                    |
| `affinity`                                                | Affinity settings for Solr pod assignment. Evaluated as a template                                                                                  | `{}`                    |
| `nodeSelector`                                            | Node labels for Solr pods assignment. Evaluated as a template                                                                                       | `{}`                    |
| `tolerations`                                             | Tolerations for Solr pods assignment. Evaluated as a template                                                                                       | `[]`                    |
| `podLabels`                                               | Additional labels for pods pod                                                                                                                      | `{}`                    |
| `podAnnotations`                                          | Additional annotations for pods                                                                                                                     | `{}`                    |
| `podManagementPolicy`                                     | Management Policy for Solr StatefulSet                                                                                                              | `Parallel`              |
| `priorityClassName`                                       | Solr pods' priority.                                                                                                                                | `""`                    |
| `lifecycleHooks`                                          | lifecycleHooks for the Solr container to automate configuration before or after startup                                                             | `{}`                    |
| `customLivenessProbe`                                     | Override default liveness probe                                                                                                                     | `{}`                    |
| `customReadinessProbe`                                    | Override default readiness probe                                                                                                                    | `{}`                    |
| `updateStrategy.type`                                     | Update strategy - only really applicable for deployments with RWO PVs attached                                                                      | `RollingUpdate`         |
| `updateStrategy.rollingUpdate`                            | Deployment rolling update configuration parameters                                                                                                  | `{}`                    |
| `extraVolumes`                                            | Extra volumes to add to the deployment                                                                                                              | `[]`                    |
| `extraVolumeMounts`                                       | Extra volume mounts to add to the container                                                                                                         | `[]`                    |
| `initContainers`                                          | Add init containers to the Solr pods                                                                                                                | `[]`                    |
| `sidecars`                                                | Add sidecars to the Solr pods                                                                                                                       | `[]`                    |
| `volumePermissions.enabled`                               | Enable init container that changes volume permissions in the registry (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                 |
| `volumePermissions.image.registry`                        | Init container volume-permissions image registry                                                                                                    | `docker.io`             |
| `volumePermissions.image.repository`                      | Init container volume-permissions image name                                                                                                        | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                             | Init container volume-permissions image tag                                                                                                         | `10-debian-10-r131`     |
| `volumePermissions.image.pullPolicy`                      | Init container volume-permissions image pull policy                                                                                                 | `Always`                |
| `volumePermissions.image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                                                    | `[]`                    |
| `volumePermissions.resources.limits`                      | The resources limits for the container                                                                                                              | `{}`                    |
| `volumePermissions.resources.requests`                    | The requested resources for the container                                                                                                           | `{}`                    |
| `volumePermissions.containerSecurityContext.enabled`      | Container security context for volume permissions                                                                                                   | `true`                  |
| `volumePermissions.containerSecurityContext.runAsUser`    | Container security context fsGroup for volume permissions                                                                                           | `1001`                  |
| `volumePermissions.containerSecurityContext.runAsNonRoot` | Container security context runAsNonRoot for volume permissions                                                                                      | `true`                  |
| `persistence.enabled`                                     | Use a PVC to persist data.                                                                                                                          | `true`                  |
| `persistence.existingClaim`                               | A manually managed Persistent Volume and Claim                                                                                                      | `""`                    |
| `persistence.storageClass`                                | Storage class of backing PVC                                                                                                                        | `""`                    |
| `persistence.accessModes`                                 | Persistent Volume Access Modes                                                                                                                      | `[]`                    |
| `persistence.size`                                        | Size of data volume                                                                                                                                 | `8Gi`                   |
| `persistence.annotations`                                 | Persistence annotations for Solr                                                                                                                    | `{}`                    |
| `persistence.mountPath`                                   | Persistence mount path for Solr                                                                                                                     | `/bitnami/solr`         |
| `serviceAccount.create`                                   | Specifies whether a ServiceAccount should be created                                                                                                | `false`                 |
| `serviceAccount.name`                                     | The name of the ServiceAccount to create                                                                                                            | `""`                    |


### Solr SSL parameters

| Name                         | Description                                                                      | Value   |
| ---------------------------- | -------------------------------------------------------------------------------- | ------- |
| `tls.enabled`                | Enable the TLS/SSL configuration                                                 | `false` |
| `tls.autoGenerated`          | Create self-signed TLS certificates. Currently only supports PEM certificates    | `false` |
| `tls.certificatesSecretName` | Name of the secret that contains the certificates                                | `""`    |
| `tls.passwordsSecretName`    | Set the name of the secret that contains the passwords for the certificate files | `""`    |
| `tls.keystorePassword`       | Password to access the keystore when it's password-protected                     | `""`    |
| `tls.truststorePassword`     | Password to access the truststore when it's password-protected                   | `""`    |
| `tls.resources.limits`       | The resources limits for the TLS init container                                  | `{}`    |
| `tls.resources.requests`     | The requested resources for the TLS init container                               | `{}`    |


### Solr Traffic Exposure Parameters

| Name                      | Description                                                                                           | Value                    |
| ------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`            | Service type for default solr service                                                                 | `ClusterIP`              |
| `service.port`            | HTTP Port                                                                                             | `8983`                   |
| `service.annotations`     | Annotations for solr service                                                                          | `{}`                     |
| `service.labels`          | Additional labels for solr service                                                                    | `{}`                     |
| `service.loadBalancerIP`  | Load balancer IP for the Solr Service (optional, cloud specific)                                      | `""`                     |
| `service.nodePorts.http`  | Node ports for the HTTP service                                                                       | `""`                     |
| `service.nodePorts.https` | Node ports for the HTTPS service                                                                      | `""`                     |
| `ingress.enabled`         | Enable ingress controller resource                                                                    | `false`                  |
| `ingress.certManager`     | Set this to true in order to add the corresponding annotations for cert-manager                       | `false`                  |
| `ingress.pathType`        | Path type for the ingress resource                                                                    | `ImplementationSpecific` |
| `ingress.apiVersion`      | Override API Version (automatically detected if not set)                                              | `""`                     |
| `ingress.hostname`        | Default host for the ingress resource                                                                 | `solr.local`             |
| `ingress.path`            | The Path to Solr. You may need to set this to '/*' in order to use this with ALB ingress controllers. | `ImplementationSpecific` |
| `ingress.annotations`     | Ingress annotations                                                                                   | `{}`                     |
| `ingress.tls`             | Enable TLS configuration for the hostname defined at ingress.hostname parameter                       | `false`                  |
| `ingress.existingSecret`  | The name of an existing Secret in the same namespase to use on the generated Ingress resource         | `""`                     |
| `ingress.extraHosts`      | The list of additional hostnames to be covered with this ingress record.                              | `[]`                     |
| `ingress.extraPaths`      | Any additional arbitrary paths that may need to be added to the ingress under the main host.          | `[]`                     |
| `ingress.extraTls`        | The tls configuration for additional hostnames to be covered with this ingress record.                | `[]`                     |
| `ingress.secrets`         | If you're providing your own certificates, please use this to add the certificates as secrets         | `[]`                     |


### Zookeeper parameters

| Name                                         | Description                                         | Value                 |
| -------------------------------------------- | --------------------------------------------------- | --------------------- |
| `zookeeper.enabled`                          | Enable Zookeeper deployment. Needed for Solr cloud  | `true`                |
| `zookeeper.persistence.enabled`              | Enabled persistence for Zookeeper                   | `true`                |
| `zookeeper.port`                             | Zookeeper port service port                         | `2181`                |
| `zookeeper.replicaCount`                     | Number of Zookeeper cluster replicas                | `3`                   |
| `zookeeper.fourlwCommandsWhitelist`          | Zookeeper four letters commands to enable           | `srvr,mntr,conf,ruok` |
| `zookeeper.service.publishNotReadyAddresses` | Publish not Ready ips for zookeeper                 | `true`                |
| `externalZookeeper.servers`                  | Server or list of external zookeeper servers to use | `[]`                  |


### Exporter deployment parameters

| Name                                             | Description                                                                                                                     | Value                                                                         |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| `exporter.enabled`                               | Start a side-car prometheus exporter                                                                                            | `false`                                                                       |
| `exporter.image.registry`                        | Solr exporter image registry                                                                                                    | `docker.io`                                                                   |
| `exporter.image.repository`                      | Solr exporter image name                                                                                                        | `bitnami/solr`                                                                |
| `exporter.image.tag`                             | Solr exporter image tag                                                                                                         | `8.9.0-debian-10-r14`                                                         |
| `exporter.image.pullPolicy`                      | Image pull policy                                                                                                               | `IfNotPresent`                                                                |
| `exporter.image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                                | `[]`                                                                          |
| `exporter.livenessProbe.enabled`                 | Enable livenessProbe                                                                                                            | `true`                                                                        |
| `exporter.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                         | `10`                                                                          |
| `exporter.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                | `5`                                                                           |
| `exporter.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                               | `15`                                                                          |
| `exporter.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                             | `15`                                                                          |
| `exporter.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                             | `1`                                                                           |
| `exporter.readinessProbe.enabled`                | Enable readinessProbe                                                                                                           | `true`                                                                        |
| `exporter.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                        | `10`                                                                          |
| `exporter.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                               | `5`                                                                           |
| `exporter.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                              | `15`                                                                          |
| `exporter.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                            | `15`                                                                          |
| `exporter.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                            | `15`                                                                          |
| `exporter.configFile`                            | Config file with metrics to export by the Solr prometheus exporter. To change it mount a different file using `extraConfigMaps` | `/opt/bitnami/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml` |
| `exporter.port`                                  | Solr exporter port                                                                                                              | `9983`                                                                        |
| `exporter.threads`                               | Number of Solr exporter threads                                                                                                 | `7`                                                                           |
| `exporter.command`                               | Override Solr entrypoint string.                                                                                                | `[]`                                                                          |
| `exporter.args`                                  | Arguments for the provided command if needed                                                                                    | `[]`                                                                          |
| `exporter.resources.limits`                      | The resources limits for the container                                                                                          | `{}`                                                                          |
| `exporter.resources.requests`                    | The requested resources for the container                                                                                       | `{}`                                                                          |
| `exporter.containerSecurityContext.enabled`      | Enable Solr exporter containers' Security Context                                                                               | `true`                                                                        |
| `exporter.containerSecurityContext.runAsUser`    | User ID for the containers.                                                                                                     | `1001`                                                                        |
| `exporter.containerSecurityContext.runAsNonRoot` | Enable Solr exporter containers' Security Context runAsNonRoot                                                                  | `true`                                                                        |
| `exporter.podSecurityContext.enabled`            | Enable Solr exporter pods' Security Context                                                                                     | `true`                                                                        |
| `exporter.podSecurityContext.fsGroup`            | Group ID for the pods.                                                                                                          | `1001`                                                                        |
| `exporter.podAffinityPreset`                     | Solr pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                        | `""`                                                                          |
| `exporter.podAntiAffinityPreset`                 | Solr pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                   | `soft`                                                                        |
| `exporter.nodeAffinityPreset.type`               | Solr node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                  | `""`                                                                          |
| `exporter.nodeAffinityPreset.key`                | Solr node label key to match Ignored if `affinity` is set.                                                                      | `""`                                                                          |
| `exporter.nodeAffinityPreset.values`             | Solr node label values to match. Ignored if `affinity` is set.                                                                  | `[]`                                                                          |
| `exporter.affinity`                              | Affinity settings for Solr pod assignment. Evaluated as a template                                                              | `{}`                                                                          |
| `exporter.nodeSelector`                          | Node labels for Solr pods assignment. Evaluated as a template                                                                   | `{}`                                                                          |
| `exporter.tolerations`                           | Tolerations for Solr pods assignment. Evaluated as a template                                                                   | `[]`                                                                          |
| `exporter.podLabels`                             | Additional labels for Metrics exporter pod                                                                                      | `{}`                                                                          |
| `exporter.podAnnotations`                        | Additional annotations for Metrics exporter pod                                                                                 | `{}`                                                                          |
| `exporter.customLivenessProbe`                   | Override default liveness probe%%MAIN_CONTAINER_NAME%%                                                                          | `{}`                                                                          |
| `exporter.customReadinessProbe`                  | Override default readiness probe%%MAIN_CONTAINER_NAME%%                                                                         | `{}`                                                                          |
| `exporter.updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached                                                  | `RollingUpdate`                                                               |
| `exporter.updateStrategy.rollingUpdate`          | Deployment rolling update configuration parameters                                                                              | `{}`                                                                          |
| `exporter.extraEnvVars`                          | Additional environment variables to set                                                                                         | `[]`                                                                          |
| `exporter.extraEnvVarsCM`                        | ConfigMap with extra environment variables                                                                                      | `""`                                                                          |
| `exporter.extraEnvVarsSecret`                    | Secret with extra environment variables                                                                                         | `""`                                                                          |
| `exporter.extraVolumes`                          | Extra volumes to add to the deployment                                                                                          | `[]`                                                                          |
| `exporter.extraVolumeMounts`                     | Extra volume mounts to add to the container                                                                                     | `[]`                                                                          |
| `exporter.initContainers`                        | Add init containers to the %%MAIN_CONTAINER_NAME%% pods                                                                         | `[]`                                                                          |
| `exporter.sidecars`                              | Add sidecars to the %%MAIN_CONTAINER_NAME%% pods                                                                                | `[]`                                                                          |
| `exporter.service.type`                          | Service type for default solr exporter service                                                                                  | `ClusterIP`                                                                   |
| `exporter.service.annotations`                   | annotations for solr exporter service                                                                                           | `{}`                                                                          |
| `exporter.service.labels`                        | Additional labels for solr exporter service                                                                                     | `{}`                                                                          |
| `exporter.service.port`                          | Kubernetes Service port                                                                                                         | `9983`                                                                        |
| `exporter.service.loadBalancerIP`                | Load balancer IP for the Solr Exporter Service (optional, cloud specific)                                                       | `""`                                                                          |
| `exporter.service.nodePorts.http`                | Node ports for the HTTP exporter service                                                                                        | `""`                                                                          |
| `exporter.service.nodePorts.https`               | Node ports for the HTTPS exporter service                                                                                       | `""`                                                                          |
| `exporter.service.loadBalancerSourceRanges`      | Exporter Load Balancer Source ranges                                                                                            | `[]`                                                                          |
| `exporter.hostAliases`                           | Deployment pod host aliases                                                                                                     | `[]`                                                                          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set cloudEnabled=true bitnami/solr
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

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Solr version

To modify the Solr version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/solr/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

### Add extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ZOOKEEPER_VERSION
    value: 6
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/solr/configuration/configure-sidecar-init-containers/).

### Set Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Solr](https://github.com/bitnami/bitnami-docker-solr) image can persist data. If enabled, the persisted path is `/bitnami/solr` by default.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Add extra volumes

The Bitnami Solr chart supports mounting extra volumes (either PVCs, secrets or configmaps) by using the `extraVolumes` and `extraVolumeMounts` property. This can be combined with advanced operations like adding extra init containers and sidecars.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.0.0

This major updates the Zookeeper subchart to it newest major, 7.0.0, which renames all TLS-related settings. For more information on this subchart's major, please refer to [zookeeper upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/zookeeper#to-700).
