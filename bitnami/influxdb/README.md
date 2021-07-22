# InfluxDB<sup>TM</sup>

[InfluxDB<sup>TM</sup>](https://www.influxdata.com/products/influxdb-overview/) is an open source time-series database designed to handle large write and read loads in real-time.

Disclaimer: The respective trademarks mentioned in the offering are owned by the respective companies. We do not provide a commercial license for any of these products. This listing has an open-source license. InfluxDB<sup>TM</sup> and InfluxDB Relay<sup>TM</sup> are run and maintained by InfluxData, which is a completely separate project from Bitnami.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/influxdb
```

## Introduction

This chart bootstraps a [influxdb](https://github.com/bitnami/bitnami-docker-influxdb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/influxdb
```

These commands deploy influxdb on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil` |


### Common parameters

| Name                     | Description                                                                                           | Value           |
| ------------------------ | ----------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                  | `nil`           |
| `nameOverride`           | String to partially override influxdb.fullname template with a string (will prepend the release name) | `nil`           |
| `fullnameOverride`       | String to fully override influxdb.fullname template with a string                                     | `nil`           |
| `clusterDomain`          | Default Kubernetes cluster domain                                                                     | `cluster.local` |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                            | `{}`            |
| `commonLabels`           | Labels to add to all deployed objects                                                                 | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                     | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)               | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                  | `[]`            |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                     | `[]`            |


### InfluxDB<sup>TM</sup> parameters

| Name                                          | Description                                                                                                                                                                                                                                                          | Value                 |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`                              | InfluxDB<sup>TM</sup> image registry                                                                                                                                                                                                                                 | `docker.io`           |
| `image.repository`                            | InfluxDB<sup>TM</sup> image repository                                                                                                                                                                                                                               | `bitnami/influxdb`    |
| `image.tag`                                   | InfluxDB<sup>TM</sup> image tag (immutable tags are recommended)                                                                                                                                                                                                     | `2.0.7-debian-10-r32` |
| `image.pullPolicy`                            | InfluxDB<sup>TM</sup> image pull policy                                                                                                                                                                                                                              | `IfNotPresent`        |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array                                                                                                                                                                                                                     | `[]`                  |
| `image.debug`                                 | Specify if debug logs should be enabled                                                                                                                                                                                                                              | `false`               |
| `architecture`                                | InfluxDB<sup>TM</sup> architecture (`standalone` or `high-availability`)                                                                                                                                                                                             | `standalone`          |
| `auth.enabled`                                | Enable/disable authentication (Variable to keep compatibility with InfluxDB<sup>TM</sup> v1, in v2 it will be ignored)                                                                                                                                               | `true`                |
| `auth.usePasswordFiles`                       | Whether to use files to provide secrets instead of env vars.                                                                                                                                                                                                         | `false`               |
| `auth.admin.username`                         | InfluxDB<sup>TM</sup> admin user name                                                                                                                                                                                                                                | `admin`               |
| `auth.admin.password`                         | InfluxDB<sup>TM</sup> admin user's password                                                                                                                                                                                                                          | `nil`                 |
| `auth.admin.token`                            | InfluxDB<sup>TM</sup> admin user's token. Only valid with InfluxDB<sup>TM</sup> v2                                                                                                                                                                                   | `nil`                 |
| `auth.admin.org`                              | InfluxDB<sup>TM</sup> admin user's org. Only valid with InfluxDB<sup>TM</sup> v2                                                                                                                                                                                     | `primary`             |
| `auth.admin.bucket`                           | InfluxDB<sup>TM</sup> admin user's bucket. Only valid with InfluxDB<sup>TM</sup> v2                                                                                                                                                                                  | `primary`             |
| `auth.createUserToken`                        | Whether to create tokens for the different users. Take into account these tokens are going to be created by CLI randomly and they will not be accessible from a secret. See more influxdb 2.0 [auth ref](https://docs.influxdata.com/influxdb/v2.0/security/tokens/) | `false`               |
| `auth.user.username`                          | Name for InfluxDB<sup>TM</sup> user with 'admin' privileges on the bucket specified at `auth.user.bucket` and `auth.user.org` or `auth.admin.org`                                                                                                                    | `nil`                 |
| `auth.user.password`                          | InfluxDB<sup>TM</sup> password for `user.name` user                                                                                                                                                                                                                  | `nil`                 |
| `auth.user.org`                               | Org to be created on first run                                                                                                                                                                                                                                       | `nil`                 |
| `auth.user.bucket`                            | Bucket to be created on first run                                                                                                                                                                                                                                    | `nil`                 |
| `auth.readUser.username`                      | Name for InfluxDB<sup>TM</sup> user with 'read' privileges on the bucket specified at `auth.user.bucket`                                                                                                                                                             | `nil`                 |
| `auth.readUser.password`                      | InfluxDB<sup>TM</sup> password for `auth.readUser.username` user                                                                                                                                                                                                     | `nil`                 |
| `auth.writeUser.username`                     | Name for InfluxDB<sup>TM</sup> user with 'read' privileges on the bucket specified at `auth.user.bucket`                                                                                                                                                             | `nil`                 |
| `auth.writeUser.password`                     | InfluxDB<sup>TM</sup> password for `auth.writeUser.username` user                                                                                                                                                                                                    | `nil`                 |
| `auth.existingSecret`                         | Name of existing Secret object with InfluxDB<sup>TM</sup> credentials (`auth.admin.password`, `auth.user.password`, `auth.readUser.password`, and `auth.writeUser.password` will be ignored and picked up from this secret)                                          | `nil`                 |
| `influxdb.configuration`                      | Specify content for influxdb.conf                                                                                                                                                                                                                                    | `nil`                 |
| `influxdb.existingConfiguration`              | Name of existing ConfigMap object with the InfluxDB<sup>TM</sup> configuration (`influxdb.configuration` will be ignored).                                                                                                                                           | `nil`                 |
| `influxdb.initdbScripts`                      | Dictionary of initdb scripts                                                                                                                                                                                                                                         | `nil`                 |
| `influxdb.initdbScriptsCM`                    | Name of existing ConfigMap object with the initdb scripts (`influxdb.initdbScripts` will be ignored).                                                                                                                                                                | `nil`                 |
| `influxdb.initdbScriptsSecret`                | Secret with initdb scripts that contain sensitive information (Note: can be used with `initdbScriptsConfigMap` or `initdbScripts`)                                                                                                                                   | `nil`                 |
| `influxdb.extraEnvVars`                       | Array containing extra env vars to configure InfluxDB<sup>TM</sup>                                                                                                                                                                                                   | `nil`                 |
| `influxdb.replicaCount`                       | The number of InfluxDB<sup>TM</sup> replicas to deploy                                                                                                                                                                                                               | `1`                   |
| `influxdb.updateStrategy`                     | Update strategy, can be set to RollingUpdate or OnDelete by default.                                                                                                                                                                                                 | `RollingUpdate`       |
| `influxdb.podManagementPolicy`                | Pod Management Policy [`OrderedReady` or `Parallel`]                                                                                                                                                                                                                 | `OrderedReady`        |
| `influxdb.podAffinityPreset`                  | InfluxDB<sup>TM</sup> Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                            | `""`                  |
| `influxdb.podAntiAffinityPreset`              | InfluxDB<sup>TM</sup> Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                       | `soft`                |
| `influxdb.nodeAffinityPreset.type`            | InfluxDB<sup>TM</sup> Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                      | `""`                  |
| `influxdb.nodeAffinityPreset.key`             | InfluxDB<sup>TM</sup> Node label key to match Ignored if `affinity` is set.                                                                                                                                                                                          | `""`                  |
| `influxdb.nodeAffinityPreset.values`          | InfluxDB<sup>TM</sup> Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                                      | `[]`                  |
| `influxdb.affinity`                           | InfluxDB<sup>TM</sup> Affinity for pod assignment                                                                                                                                                                                                                    | `{}`                  |
| `influxdb.nodeSelector`                       | InfluxDB<sup>TM</sup> Node labels for pod assignment                                                                                                                                                                                                                 | `{}`                  |
| `influxdb.tolerations`                        | InfluxDB<sup>TM</sup> Tolerations for pod assignment                                                                                                                                                                                                                 | `[]`                  |
| `influxdb.extraVolumes`                       | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting extraVolumeMounts                                                                                                                                                     | `[]`                  |
| `influxdb.extraVolumeMounts`                  | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with extraVolumes.                                                                                                                                                  | `[]`                  |
| `influxdb.securityContext.enabled`            | Enable security context for InfluxDB<sup>TM</sup>                                                                                                                                                                                                                    | `true`                |
| `influxdb.securityContext.fsGroup`            | Group ID for the InfluxDB<sup>TM</sup> filesystem                                                                                                                                                                                                                    | `1001`                |
| `influxdb.securityContext.runAsUser`          | User ID for the InfluxDB<sup>TM</sup> container                                                                                                                                                                                                                      | `1001`                |
| `influxdb.resources.limits`                   | The resources limits for the container                                                                                                                                                                                                                               | `{}`                  |
| `influxdb.resources.requests`                 | The requested resources for the container                                                                                                                                                                                                                            | `{}`                  |
| `influxdb.livenessProbe.enabled`              | Enable livenessProbe                                                                                                                                                                                                                                                 | `true`                |
| `influxdb.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                                                                                                                                                              | `180`                 |
| `influxdb.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                                                                                                                                                                     | `45`                  |
| `influxdb.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                                                                                                                                                                    | `30`                  |
| `influxdb.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                                                                                                                                                                  | `6`                   |
| `influxdb.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                                                                                                                                                                  | `1`                   |
| `influxdb.readinessProbe.enabled`             | Enable readinessProbe                                                                                                                                                                                                                                                | `true`                |
| `influxdb.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                                                                                                                                                             | `60`                  |
| `influxdb.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                                                                                                                                                                    | `45`                  |
| `influxdb.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                                                                                                                                                                   | `30`                  |
| `influxdb.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                                                                                                                                                                 | `6`                   |
| `influxdb.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                                                                                                                                                                 | `1`                   |
| `influxdb.customLivenessProbe`                | Override default liveness probe                                                                                                                                                                                                                                      | `{}`                  |
| `influxdb.customReadinessProbe`               | Override default readiness probe                                                                                                                                                                                                                                     | `{}`                  |
| `influxdb.containerPorts`                     | Container ports                                                                                                                                                                                                                                                      | `{}`                  |
| `influxdb.service.type`                       | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                                                                                                                                                                  | `ClusterIP`           |
| `influxdb.service.port`                       | InfluxDB<sup>TM</sup> HTTP port                                                                                                                                                                                                                                      | `8086`                |
| `influxdb.service.rpcPort`                    | InfluxDB<sup>TM</sup> RPC port                                                                                                                                                                                                                                       | `8088`                |
| `influxdb.service.nodePorts`                  | Specify the nodePort(s) value for the LoadBalancer and NodePort service types.                                                                                                                                                                                       | `{}`                  |
| `influxdb.service.loadBalancerIP`             | loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                                                                     | `nil`                 |
| `influxdb.service.loadBalancerSourceRanges`   | Address that are allowed when service is LoadBalancer                                                                                                                                                                                                                | `[]`                  |
| `influxdb.service.clusterIP`                  | Static clusterIP or None for headless services                                                                                                                                                                                                                       | `nil`                 |
| `influxdb.service.annotations`                | Annotations for InfluxDB<sup>TM</sup> service                                                                                                                                                                                                                        | `{}`                  |
| `influxdb.service.sessionAffinity`            | Session affinity for the InfluxDB<sup>TM</sup> service                                                                                                                                                                                                               | `nil`                 |
| `influxdb.service.sessionAffinityConfig`      | Additional settings for the sessionAffinity                                                                                                                                                                                                                          | `{}`                  |


### InfluxDB Relay<sup>TM</sup> parameters

| Name                                       | Description                                                                                                                  | Value                     |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `relay.image.registry`                     | InfluxDB Relay<sup>TM</sup> image registry                                                                                   | `docker.io`               |
| `relay.image.repository`                   | InfluxDB Relay<sup>TM</sup> image repository                                                                                 | `bitnami/influxdb-relay`  |
| `relay.image.tag`                          | InfluxDB Relay<sup>TM</sup> image tag (immutable tags are recommended)                                                       | `0.20200717.0-scratch-r7` |
| `relay.image.pullPolicy`                   | InfluxDB Relay<sup>TM</sup> image pull policy                                                                                | `IfNotPresent`            |
| `relay.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                             | `[]`                      |
| `relay.configuration`                      | InfluxDB Relay(TM) Configuration. Specify content for relay.toml                                                             | `{}`                      |
| `relay.existingConfiguration`              | Name of existing ConfigMap object with the InfluxDB Relay<sup>TM</sup> configuration (`relay.configuration` will be ignored) | `nil`                     |
| `relay.replicaCount`                       | The number of InfluxDB Relay<sup>TM</sup> replicas to deploy                                                                 | `1`                       |
| `relay.updateStrategy`                     | Update strategy, can be set to RollingUpdate or OnDelete by default.                                                         | `RollingUpdate`           |
| `relay.podAffinityPreset`                  | InfluxDB Relay<sup>TM</sup> Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`              | `""`                      |
| `relay.podAntiAffinityPreset`              | InfluxDB Relay<sup>TM</sup> Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`         | `soft`                    |
| `relay.nodeAffinityPreset.type`            | InfluxDB Relay<sup>TM</sup> Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                      |
| `relay.nodeAffinityPreset.key`             | InfluxDB Relay<sup>TM</sup> Node label key to match Ignored if `affinity` is set.                                            | `""`                      |
| `relay.nodeAffinityPreset.values`          | InfluxDB Relay<sup>TM</sup> Node label values to match. Ignored if `affinity` is set.                                        | `[]`                      |
| `relay.affinity`                           | InfluxDB Relay<sup>TM</sup> Affinity for pod assignment                                                                      | `{}`                      |
| `relay.nodeSelector`                       | InfluxDB Relay<sup>TM</sup> Node labels for pod assignment                                                                   | `{}`                      |
| `relay.tolerations`                        | InfluxDB Relay<sup>TM</sup> Tolerations for pod assignment                                                                   | `[]`                      |
| `relay.extraVolumes`                       | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting extraVolumeMounts             | `[]`                      |
| `relay.extraVolumeMounts`                  | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with extraVolumes.          | `[]`                      |
| `relay.securityContext.enabled`            | Enable security context for InfluxDB Relay<sup>TM</sup>                                                                      | `true`                    |
| `relay.securityContext.fsGroup`            | Group ID for the InfluxDB Relay<sup>TM</sup> filesystem                                                                      | `1001`                    |
| `relay.securityContext.runAsUser`          | User ID for the InfluxDB Relay<sup>TM</sup> container                                                                        | `1001`                    |
| `relay.resources.limits`                   | The resources limits for the container                                                                                       | `{}`                      |
| `relay.resources.requests`                 | The requested resources for the container                                                                                    | `{}`                      |
| `relay.livenessProbe.enabled`              | Enable livenessProbe                                                                                                         | `true`                    |
| `relay.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                      | `30`                      |
| `relay.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                             | `10`                      |
| `relay.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                            | `5`                       |
| `relay.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                          | `6`                       |
| `relay.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                          | `1`                       |
| `relay.readinessProbe.enabled`             | Enable readinessProbe                                                                                                        | `true`                    |
| `relay.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                     | `5`                       |
| `relay.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                            | `10`                      |
| `relay.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                           | `5`                       |
| `relay.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                         | `6`                       |
| `relay.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                         | `1`                       |
| `relay.customLivenessProbe`                | Override default liveness probe                                                                                              | `{}`                      |
| `relay.customReadinessProbe`               | Override default readiness probe                                                                                             | `{}`                      |
| `relay.containerPorts`                     | Container ports                                                                                                              | `{}`                      |
| `relay.service.type`                       | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                          | `ClusterIP`               |
| `relay.service.port`                       | InfluxDB Relay<sup>TM</sup> HTTP port                                                                                        | `9096`                    |
| `relay.service.nodePort`                   | Kubernetes HTTP node port                                                                                                    | `""`                      |
| `relay.service.loadBalancerIP`             | loadBalancerIP if service type is `LoadBalancer`                                                                             | `nil`                     |
| `relay.service.loadBalancerSourceRanges`   | Address that are allowed when service is LoadBalancer                                                                        | `[]`                      |
| `relay.service.clusterIP`                  | Static clusterIP or None for headless services                                                                               | `nil`                     |
| `relay.service.annotations`                | Annotations for InfluxDB Relay<sup>TM</sup> service                                                                          | `{}`                      |


### InfluxDB Collectd<sup>TM</sup> parameters

| Name                                        | Description                                                                                     | Value       |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------- |
| `collectd.enabled`                          | InfluxDB Collectd<sup>TM</sup> service enable                                                   | `false`     |
| `collectd.service.type`                     | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                             | `ClusterIP` |
| `collectd.service.port`                     | InfluxDB Collectd<sup>TM</sup> UDP port (should match with corresponding port in influxdb.conf) | `25826`     |
| `collectd.service.nodePort`                 | Kubernetes HTTP node port                                                                       | `""`        |
| `collectd.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                                | `nil`       |
| `collectd.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                           | `[]`        |
| `collectd.service.clusterIP`                | Static clusterIP or None for headless services                                                  | `nil`       |
| `collectd.service.annotations`              | Annotations for InfluxDB Collectd<sup>TM</sup> service                                          | `{}`        |


### Exposing parameters

| Name                  | Description                                                                                   | Value                    |
| --------------------- | --------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`     | Enable ingress controller resource                                                            | `false`                  |
| `ingress.tls`         | Create TLS Secret                                                                             | `false`                  |
| `ingress.certManager` | Add annotations for cert-manager                                                              | `false`                  |
| `ingress.pathType`    | Ingress path type                                                                             | `ImplementationSpecific` |
| `ingress.apiVersion`  | Force Ingress API version (automatically detected if not set)                                 | `nil`                    |
| `ingress.hostname`    | Default host for the ingress resource                                                         | `influxdb.local`         |
| `ingress.path`        | Ingress path*' in order to use this                                                           | `ImplementationSpecific` |
| `ingress.annotations` | Ingress annotations                                                                           | `{}`                     |
| `ingress.extraHosts`  | The list of additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `ingress.extraPaths`  | Additional arbitrary path/backend objects                                                     | `[]`                     |
| `ingress.extraTls`    | The tls configuration for additional hostnames to be covered with this ingress record.        | `[]`                     |
| `ingress.secrets`     | If you're providing your own certificates, please use this to add the certificates as secrets | `[]`                     |


### Metrics parameters

| Name                                       | Description                                                                                            | Value       |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ | ----------- |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                | `false`     |
| `metrics.service.type`                     | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                    | `ClusterIP` |
| `metrics.service.port`                     | InfluxDB<sup>TM</sup> Prometheus port                                                                  | `9122`      |
| `metrics.service.nodePort`                 | Kubernetes HTTP node port                                                                              | `""`        |
| `metrics.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                                       | `nil`       |
| `metrics.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                  | `[]`        |
| `metrics.service.clusterIP`                | Static clusterIP or None for headless services                                                         | `nil`       |
| `metrics.service.annotations`              | Annotations for the Prometheus metrics service                                                         | `{}`        |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false`     |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                               | `nil`       |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                           | `nil`       |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                | `nil`       |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                    | `{}`        |
| `networkPolicy.enabled`                    | Enable NetworkPolicy                                                                                   | `false`     |
| `networkPolicy.allowExternal`              | Don't require client label for connections                                                             | `true`      |
| `persistence.enabled`                      | Enable data persistence                                                                                | `true`      |
| `persistence.existingClaim`                | Use a existing PVC which must be created manually before bound                                         | `nil`       |
| `persistence.storageClass`                 | Specify the `storageClass` used to provision the volume                                                | `nil`       |
| `persistence.accessModes`                  | Access mode of data volume                                                                             | `[]`        |
| `persistence.size`                         | Size of data volume                                                                                    | `8Gi`       |


### Volume permissions parameters

| Name                                          | Description                                                                                                       | Value                   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume mountpoint to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                  | `docker.io`             |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                      | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                       | `10-debian-10-r138`     |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                               | `Always`                |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                  | `[]`                    |
| `volumePermissions.securityContext.runAsUser` | User ID for the init container (when facing issues in OpenShift or uid unknown, try value "auto")                 | `0`                     |


### InfluxDB<sup>TM</sup> backup parameters

| Name                                              | Description                                                                                                   | Value                      |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `backup.enabled`                                  | Enable InfluxDB<sup>TM</sup> backup                                                                           | `false`                    |
| `backup.directory`                                | Directory where backups are stored                                                                            | `/backups`                 |
| `backup.retentionDays`                            | Retention time in days for backups (older backups are deleted)                                                | `10`                       |
| `backup.cronjob.schedule`                         | Schedule in Cron format to save snapshots                                                                     | `0 2 * * *`                |
| `backup.cronjob.historyLimit`                     | Number of successful finished jobs to retain                                                                  | `1`                        |
| `backup.cronjob.podAnnotations`                   | Pod annotations                                                                                               | `{}`                       |
| `backup.cronjob.securityContext.enabled`          | Enable security context for InfluxDB<sup>TM</sup>                                                             | `true`                     |
| `backup.cronjob.securityContext.fsGroup`          | Group ID for the InfluxDB<sup>TM</sup> filesystem                                                             | `1001`                     |
| `backup.cronjob.securityContext.runAsUser`        | Group ID for the InfluxDB<sup>TM</sup> filesystem                                                             | `1001`                     |
| `backup.podAffinityPreset`                        | Backup <sup>TM</sup> Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`      | `""`                       |
| `backup.podAntiAffinityPreset`                    | Backup<sup>TM</sup> Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                     |
| `backup.nodeAffinityPreset.type`                  | Backup<sup>TM</sup> Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                       |
| `backup.nodeAffinityPreset.key`                   | Backup<sup>TM</sup> Node label key to match Ignored if `affinity` is set.                                     | `""`                       |
| `backup.nodeAffinityPreset.values`                | Backup<sup>TM</sup> Node label values to match. Ignored if `affinity` is set.                                 | `[]`                       |
| `backup.affinity`                                 | Backup<sup>TM</sup> Affinity for backup pod assignment                                                        | `{}`                       |
| `backup.nodeSelector`                             | Backup<sup>TM</sup> Node labels for backup pod assignment                                                     | `{}`                       |
| `backup.tolerations`                              | Backup<sup>TM</sup> Tolerations for backup pod assignment                                                     | `[]`                       |
| `backup.uploadProviders.google.enabled`           | enable upload to google storage bucket                                                                        | `false`                    |
| `backup.uploadProviders.google.secret`            | json secret with serviceaccount data to access Google storage bucket                                          | `""`                       |
| `backup.uploadProviders.google.secretKey`         | service account secret key name                                                                               | `key.json`                 |
| `backup.uploadProviders.google.existingSecret`    | Name of existing secret object with Google serviceaccount json credentials                                    | `""`                       |
| `backup.uploadProviders.google.bucketName`        | google storage bucket name name                                                                               | `gs://bucket/influxdb`     |
| `backup.uploadProviders.google.image.registry`    | Google Cloud SDK image registry                                                                               | `docker.io`                |
| `backup.uploadProviders.google.image.repository`  | Google Cloud SDK image name                                                                                   | `bitnami/google-cloud-sdk` |
| `backup.uploadProviders.google.image.tag`         | Google Cloud SDK image tag                                                                                    | `0.348.0-debian-10-r5`     |
| `backup.uploadProviders.google.image.pullPolicy`  | Google Cloud SDK image pull policy                                                                            | `IfNotPresent`             |
| `backup.uploadProviders.google.image.pullSecrets` | Specify docker-registry secret names as an array                                                              | `[]`                       |
| `backup.uploadProviders.azure.enabled`            | Enable upload to azure storage container                                                                      | `false`                    |
| `backup.uploadProviders.azure.secret`             | Secret with credentials to access Azure storage                                                               | `""`                       |
| `backup.uploadProviders.azure.secretKey`          | Service account secret key name                                                                               | `connection-string`        |
| `backup.uploadProviders.azure.existingSecret`     | Name of existing secret object                                                                                | `""`                       |
| `backup.uploadProviders.azure.containerName`      | Destination container                                                                                         | `influxdb-container`       |
| `backup.uploadProviders.azure.image.registry`     | Azure CLI image registry                                                                                      | `docker.io`                |
| `backup.uploadProviders.azure.image.repository`   | Azure CLI image repository                                                                                    | `bitnami/azure-cli`        |
| `backup.uploadProviders.azure.image.tag`          | Azure CLI image tag (immutable tags are recommended)                                                          | `2.26.1-debian-10-r4`      |
| `backup.uploadProviders.azure.image.pullPolicy`   | Azure CLI image pull policy                                                                                   | `IfNotPresent`             |
| `backup.uploadProviders.azure.image.pullSecrets`  | Specify docker-registry secret names as an array                                                              | `[]`                       |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set auth.admin.username=admin-user bitnami/influxdb
```

The above command sets the InfluxDB<sup>TM</sup> admin user to `admin-user`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/influxdb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Standalone vs High Availability architecture

You can install the InfluxDB<sup>TM</sup> chart with two different architecture setups: "standalone" or "high-availability", you can use the `architecture` parameter:

```console
architecture="standalone"
architecture="high-availability"
```

The standalone architecture installs a deployment with one InfluxDB<sup>TM</sup> server (it cannot be scaled):

```
               ┌──────────────────┐
               │     Ingress      │
               │    Controller    │
               └────────┬─────────┘
                        |
                        │ /query
                        │ /write
                        ▼
                ┌────────────────┐
                │  InfluxDB(TM)  │
                |      svc       │
                └───────┬────────┘
                        │
                        ▼
                 ┌──────────────┐
                 │ InfluxDB(TM) │
                 │    Server    │
                 │     Pod      │
                 └──────────────┘
```

The high availability install a statefulset with N InfluxDB<sup>TM</sup> servers and M InfluxDB Relay<sup>TM</sup> instances:

```
                   ┌──────────────────┐
                   │     Ingress      │
                   │    Controller    │
                   └───────┬─┬────────┘
                           │ │
                           │ │
              ┌────────────┘ └─────────────┐
              │                            │
              │ /write              /query │
              ▼                            ▼
      ┌────────────────────┐  ┌────────────────────┐
      │ InfluxDB Relay(TM) │  │    InfluxDB(TM)    │
      │          svc       │  │         svc        │
      └───────────┬─┬──────┘  └─────┬─────┬────────┘
      ┌────────── │─|───────────────|─────│───────┐
      |           │ |               |     │       ▼
┌─────┴────────┐  │ |               |     │  ┌──────────────┐
│   InfluxDB   │  │ |               |     │  │ InfluxDB(TM) │
│  Relay(TM)   │◀─┘ |               |     └─▶│    Server    │
│     Pod      │    │               │        │     Pod      │
└─────┬────────┘    │               │        └──────────────┘
      |             │               │           ▲
      └─────────────│───────────────│───────┐   |
                    │               │       |   |
  ┌──────────────── │───────────────│───────────┘
  |                 │               │       |
  |                 │               │       ▼
┌─┴─────────────┐   │               │   ┌──────────────┐
│    InfluxDB   │   │               │   │ InfluxDB(TM) │
│   Relay(TM)   │◀──┘               └──▶│  Server      │
│      Pod      │                       │   Pod        │
└─────┬─────────┘                       └──────────────┘
      |                                   ▲
      └───────────────────────────────────┘
```

When using the high-availability architecture, it is recommended to configure sticky sessions using `--set influxdb.service.sessionAffinity="ClientIP"` or configuring the IngressController accordingly.

### Configure the way how to expose InfluxDB<sup>TM</sup>

- **Ingress**: The ingress controller must be installed in the Kubernetes cluster. Set `ingress.enabled=true` to expose InfluxDB<sup>TM</sup> through Ingress.
- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster. Set `influxdb.service.type=ClusterIP` to choose this service type.
- **NodePort**: Exposes the service on each Node's IP at a static port (the NodePort). You’ll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`. Set `influxdb.service.type=NodePort` to choose this service type.
- **LoadBalancer**: Exposes the service externally using a cloud provider's load balancer. Set `influxdb.service.type=LoadBalancer` to choose this service type.

### Using custom configuration

This helm chart supports to customize the whole configuration file.

Add your custom configuration file to "files/conf" in your working directory. This file will be mounted as a configMap to the containers and it will be used for configuring InfluxDB<sup>TM</sup>.

Alternatively, you can specify the InfluxDB<sup>TM</sup> configuration using the `influxdb.configuration` parameter.

In addition to these options, you can also set an external ConfigMap with all the configuration files. This is done by setting the `influxdb.existingConfiguration` parameter. Note that this will override the two previous options.

### Adding extra environment variables

In case you want to add extra environment variables, you can use the `influxdb.extraEnvVars` property.

```yaml
extraEnvVars:
  - name: INFLUXDB_DATA_QUERY_LOG_ENABLED
    value: "true"
```

### Initialize a fresh instance

The [Bitnami InfluxDB<sup>TM</sup>](https://github.com/bitnami/bitnami-docker-influxdb) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

Alternatively, you can specify custom scripts using the `influxdb.initdbScripts` parameter.

In addition to these options, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `influxdb.initdbScriptsCM` parameter. Note that this will override the two previous options. parameter.

The allowed extensions are `.sh`, and `.txt`.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The data is persisted by default using PVC(s). You can disable the persistence setting the `persistence.enabled` parameter to `false`.
A default `StorageClass` is needed in the Kubernetes cluster to dynamically provision the volumes. Specify another StorageClass in the `persistence.storageClass` or set `persistence.existingClaim` if you have already existing persistent volumes to use.

### Adjust permissions of persistent volume mountpoint

As the images run as non-root by default, it is necessary to adjust the ownership of the persistent volumes so that the containers can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this **initContainer** by setting `volumePermissions.enabled` to `true`.
There are K8s distribution, such as OpenShift, where you can dynamically define the UID to run this **initContainer**. To do so, set the `volumePermissions.securityContext.runAsUser` to `auto`.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrade

It's necessary to specify the existing passwords while performing an upgrade to ensure the secrets are not updated with invalid randomly generated passwords. Remember to specify the existing values of the `auth.admin.password`, `user.pwd`, ` auth.readUser.password` and `auth.writeUser.password` parameters when upgrading the chart:

```bash
$ helm upgrade my-release bitnami/influxdb \
    --set auth.admin.password=[ADMIN_USER_PASSWORD] \
    --set auth.user.password=[USER_PASSWORD] \
    --set auth.readUser.password=[READ_USER_PASSWORD] \
    --set auth.writeUser.password=[WRITE_USER_PASSWORD]
```

> Note: you need to substitute the placeholders _[ADMIN_USER_PASSWORD]_, _[USER_PASSWORD]_, _[READ_USER_PASSWORD]_, and _[WRITE_USER_PASSWORD]_ with the values obtained from instructions in the installation notes.

## Upgrading

### To 2.0.0

This version adds support to InfluxDB<sup>TM</sup> +2.0, since this version the chart is only verified to work with InfluxDB<sup>TM</sup> +2.0 bitnami images.
However, you can use images for versions ~1.x.x taking into account the chart may need some modification to run with them.

#### Installing InfluxDB<sup>TM</sup> v1 in chart v2.

```
$ helm install bitnami/influxdb --set image.tag=1.8.3-debian-10-r88
```

As a consecuece some breaking changes have been included in this version.

- Authentication values has been moved to `auth.<property>...`.
- We keep `auth.readUser` and `auth.writeUser` user options in order to be compatible with InfluxDB<sup>TM</sup> v1. If you are using InfluxDB<sup>TM</sup> 2.0, please, use the CLI to create user and tokens through initDb scripts at `influxdb.initdbScripts` or the UI due to we are not able to automacally provide a token for them to be used. See more [InfluxDB<sup>TM</sup> 2.0 auth](https://docs.influxdata.com/influxdb/v2.0/security/tokens/)
- InfluxDB<sup>TM</sup> 2.0 has removed database concept, now it is called Bucket so the property `database` has been also moved to `auth.user.bucket`.
- Removed support for `files/docker-entrypoint-initdb.d/*.{sh,txt}`, please use `.influxdb.initdbScripts` or `.Values.influxdb.initdbScriptsCM` instead.
- Removed support for `files/conf/influxdb.conf`, please use `.influxdb.configuration` or `.influxdb.existingConfiguration` instead.
- Removed support for `files/conf/relay.toml`, please use `.Values.relay.configuration` or `.Values.relay.existingConfiguration` instead.
- `ingress.hosts` parameter has been replaced by `ingress.hostname` and `ingress.extraHosts` that may give us a bit more flexibility.

#### Migrating form InfluxDB<sup>TM</sup> v1 to v2

Since this release could mean lot of concepts changes, we strongly recommend to not do it direcly using the chart upgrade. Please, read more info in their [upgrade guide](https://docs.influxdata.com/influxdb/v2.0/upgrade/v1-to-v2/).

We actually recommend to backup all the data form a previous helm release, install new release using latest version of the chart and images and then restore data following their guides.

#### Upgrading the chart form 1.x.x to 2.x.x using InfluxDB<sup>TM</sup> v1 images.

> NOTE: Please, create a backup of your database before running any of those actions.

Having an already existing chart release called `influxdb` and deployed like

```console
$ helm install influxdb bitnami/influxdb
```

##### Export secrets and required values to update

```console
$ export INFLUXDB_ADMIN_PASSWORD=$(kubectl get secret --namespace default influxdb -o jsonpath="{.data.admin-user-password}" | base64 --decode)
```

##### Upgrade the chart release

> NOTE: Please remember to migrate all the values to its new path following the above notes, e.g: `adminUser.pwd` -> `auth.admin.password`.

```console
$ helm upgrade influxdb bitnami/influxdb --set image.tag=1.8.3-debian-10-r99 \
  --set auth.admin.password=${INFLUXDB_ADMIN_PASSWORD}
```

### To 1.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 1.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the _Chart.yaml_ file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/
