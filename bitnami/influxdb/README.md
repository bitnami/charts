<!--- app-name: InfluxDB&trade; -->

# Bitnami Stack for InfluxDB(TM)

InfluxDB(TM) is an open source time-series database. It is a core component of the TICK (Telegraf, InfluxDB(TM), Chronograf, Kapacitor) stack.

[Overview of InfluxDB&trade;](https://www.influxdata.com/products/influxdb-overview)

InfluxDB(TM) is a trademark owned by InfluxData, which is not affiliated with, and does not endorse, this site.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/influxdb
```

## Introduction

This chart bootstraps a [influxdb](https://github.com/bitnami/bitnami-docker-influxdb) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
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
|:--------------------------|:------------------------------------------------|:------|
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `""`  |


### Common parameters

| Name                     | Description                                                                                           | Value           |
|:-------------------------|:------------------------------------------------------------------------------------------------------|:----------------|
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                                  | `""`            |
| `nameOverride`           | String to partially override influxdb.fullname template with a string (will prepend the release name) | `""`            |
| `fullnameOverride`       | String to fully override influxdb.fullname template with a string                                     | `""`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                                     | `cluster.local` |
| `commonAnnotations`      | Annotations to add to all deployed objects                                                            | `{}`            |
| `commonLabels`           | Labels to add to all deployed objects                                                                 | `{}`            |
| `extraDeploy`            | Array of extra objects to deploy with the release                                                     | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)               | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                                  | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                                     | `["infinity"]`  |


### InfluxDB&trade; parameters

| Name                                             | Description                                                                                                                                                                                                                                                          | Value                 |
|:-------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------|
| `image.registry`                                 | InfluxDB&trade; image registry                                                                                                                                                                                                                                       | `docker.io`           |
| `image.repository`                               | InfluxDB&trade; image repository                                                                                                                                                                                                                                     | `bitnami/influxdb`    |
| `image.tag`                                      | InfluxDB&trade; image tag (immutable tags are recommended)                                                                                                                                                                                                           | `2.1.1-debian-10-r48` |
| `image.pullPolicy`                               | InfluxDB&trade; image pull policy                                                                                                                                                                                                                                    | `IfNotPresent`        |
| `image.pullSecrets`                              | Specify docker-registry secret names as an array                                                                                                                                                                                                                     | `[]`                  |
| `image.debug`                                    | Specify if debug logs should be enabled                                                                                                                                                                                                                              | `false`               |
| `architecture`                                   | InfluxDB&trade; architecture (`standalone` or `high-availability`)                                                                                                                                                                                                   | `standalone`          |
| `auth.enabled`                                   | Enable/disable authentication (Variable to keep compatibility with InfluxDB&trade; v1, in v2 it will be ignored)                                                                                                                                                     | `true`                |
| `auth.usePasswordFiles`                          | Whether to use files to provide secrets instead of env vars.                                                                                                                                                                                                         | `false`               |
| `auth.admin.username`                            | InfluxDB&trade; admin user name                                                                                                                                                                                                                                      | `admin`               |
| `auth.admin.password`                            | InfluxDB&trade; admin user's password                                                                                                                                                                                                                                | `""`                  |
| `auth.admin.token`                               | InfluxDB&trade; admin user's token. Only valid with InfluxDB&trade; v2                                                                                                                                                                                               | `""`                  |
| `auth.admin.org`                                 | InfluxDB&trade; admin user's org. Only valid with InfluxDB&trade; v2                                                                                                                                                                                                 | `primary`             |
| `auth.admin.bucket`                              | InfluxDB&trade; admin user's bucket. Only valid with InfluxDB&trade; v2                                                                                                                                                                                              | `primary`             |
| `auth.createUserToken`                           | Whether to create tokens for the different users. Take into account these tokens are going to be created by CLI randomly and they will not be accessible from a secret. See more influxdb 2.0 [auth ref](https://docs.influxdata.com/influxdb/v2.0/security/tokens/) | `false`               |
| `auth.user.username`                             | Name for InfluxDB&trade; user with 'admin' privileges on the bucket specified at `auth.user.bucket` and `auth.user.org` or `auth.admin.org`                                                                                                                          | `""`                  |
| `auth.user.password`                             | InfluxDB&trade; password for `user.name` user                                                                                                                                                                                                                        | `""`                  |
| `auth.user.org`                                  | Org to be created on first run                                                                                                                                                                                                                                       | `""`                  |
| `auth.user.bucket`                               | Bucket to be created on first run                                                                                                                                                                                                                                    | `""`                  |
| `auth.readUser.username`                         | Name for InfluxDB&trade; user with 'read' privileges on the bucket specified at `auth.user.bucket`                                                                                                                                                                   | `""`                  |
| `auth.readUser.password`                         | InfluxDB&trade; password for `auth.readUser.username` user                                                                                                                                                                                                           | `""`                  |
| `auth.writeUser.username`                        | Name for InfluxDB&trade; user with 'read' privileges on the bucket specified at `auth.user.bucket`                                                                                                                                                                   | `""`                  |
| `auth.writeUser.password`                        | InfluxDB&trade; password for `auth.writeUser.username` user                                                                                                                                                                                                          | `""`                  |
| `auth.existingSecret`                            | Name of existing Secret object with InfluxDB&trade; credentials (`auth.admin.password`, `auth.user.password`, `auth.readUser.password`, and `auth.writeUser.password` will be ignored and picked up from this secret)                                                | `""`                  |
| `influxdb.configuration`                         | Specify content for influxdb.conf                                                                                                                                                                                                                                    | `""`                  |
| `influxdb.existingConfiguration`                 | Name of existing ConfigMap object with the InfluxDB&trade; configuration (`influxdb.configuration` will be ignored).                                                                                                                                                 | `""`                  |
| `influxdb.initdbScripts`                         | Dictionary of initdb scripts                                                                                                                                                                                                                                         | `{}`                  |
| `influxdb.initdbScriptsCM`                       | Name of existing ConfigMap object with the initdb scripts (`influxdb.initdbScripts` will be ignored).                                                                                                                                                                | `""`                  |
| `influxdb.initdbScriptsSecret`                   | Secret with initdb scripts that contain sensitive information (Note: can be used with `initdbScriptsConfigMap` or `initdbScripts`)                                                                                                                                   | `""`                  |
| `influxdb.replicaCount`                          | The number of InfluxDB&trade; replicas to deploy                                                                                                                                                                                                                     | `1`                   |
| `influxdb.podAffinityPreset`                     | InfluxDB&trade; Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                                  | `""`                  |
| `influxdb.podAntiAffinityPreset`                 | InfluxDB&trade; Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                             | `soft`                |
| `influxdb.nodeAffinityPreset.type`               | InfluxDB&trade; Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                            | `""`                  |
| `influxdb.nodeAffinityPreset.key`                | InfluxDB&trade; Node label key to match Ignored if `affinity` is set.                                                                                                                                                                                                | `""`                  |
| `influxdb.nodeAffinityPreset.values`             | InfluxDB&trade; Node label values to match. Ignored if `affinity` is set.                                                                                                                                                                                            | `[]`                  |
| `influxdb.affinity`                              | InfluxDB&trade; Affinity for pod assignment                                                                                                                                                                                                                          | `{}`                  |
| `influxdb.nodeSelector`                          | InfluxDB&trade; Node labels for pod assignment                                                                                                                                                                                                                       | `{}`                  |
| `influxdb.tolerations`                           | InfluxDB&trade; Tolerations for pod assignment                                                                                                                                                                                                                       | `[]`                  |
| `influxdb.podAnnotations`                        | Annotations for InfluxDB&trade; pods                                                                                                                                                                                                                                 | `{}`                  |
| `influxdb.podLabels`                             | Extra labels for InfluxDB&trade; pods                                                                                                                                                                                                                                | `{}`                  |
| `influxdb.hostAliases`                           | InfluxDB&trade; pods host aliases                                                                                                                                                                                                                                    | `[]`                  |
| `influxdb.updateStrategy.type`                   | InfluxDB&trade; statefulset/deployment strategy type                                                                                                                                                                                                                 | `RollingUpdate`       |
| `influxdb.priorityClassName`                     | InfluxDB&trade; pods' priorityClassName                                                                                                                                                                                                                              | `""`                  |
| `influxdb.schedulerName`                         | Name of the k8s scheduler (other than default)                                                                                                                                                                                                                       | `""`                  |
| `influxdb.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                                                                                                                                                                                       | `[]`                  |
| `influxdb.podManagementPolicy`                   | podManagementPolicy to manage scaling operation of InfluxDB&trade; pods                                                                                                                                                                                              | `OrderedReady`        |
| `influxdb.podSecurityContext.enabled`            | Enabled InfluxDB&trade; pods' Security Context                                                                                                                                                                                                                       | `true`                |
| `influxdb.podSecurityContext.fsGroup`            | Set InfluxDB&trade; pod's Security Context fsGroup                                                                                                                                                                                                                   | `1001`                |
| `influxdb.containerSecurityContext.enabled`      | Enabled InfluxDB&trade; containers' Security Context                                                                                                                                                                                                                 | `true`                |
| `influxdb.containerSecurityContext.runAsUser`    | Set InfluxDB&trade; containers' Security Context runAsUser                                                                                                                                                                                                           | `1001`                |
| `influxdb.containerSecurityContext.runAsNonRoot` | Set Controller container's Security Context runAsNonRoot                                                                                                                                                                                                             | `true`                |
| `influxdb.resources.limits`                      | The resources limits for the container                                                                                                                                                                                                                               | `{}`                  |
| `influxdb.resources.requests`                    | The requested resources for the container                                                                                                                                                                                                                            | `{}`                  |
| `influxdb.command`                               | Override default container command (useful when using custom images)                                                                                                                                                                                                 | `[]`                  |
| `influxdb.args`                                  | Override default container args (useful when using custom images)                                                                                                                                                                                                    | `[]`                  |
| `influxdb.lifecycleHooks`                        | for the InfluxDB&trade; container(s) to automate configuration before or after startup                                                                                                                                                                               | `{}`                  |
| `influxdb.extraEnvVars`                          | Array containing extra env vars to configure InfluxDB&trade;                                                                                                                                                                                                         | `[]`                  |
| `influxdb.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for InfluxDB&trade; nodes                                                                                                                                                                                       | `""`                  |
| `influxdb.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for InfluxDB&trade; nodes                                                                                                                                                                                          | `""`                  |
| `influxdb.extraVolumes`                          | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting extraVolumeMounts                                                                                                                                                     | `[]`                  |
| `influxdb.extraVolumeMounts`                     | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with extraVolumes.                                                                                                                                                  | `[]`                  |
| `influxdb.containerPorts.http`                   | InfluxDB&trade; container HTTP port                                                                                                                                                                                                                                  | `8086`                |
| `influxdb.containerPorts.rpc`                    | InfluxDB&trade; container RPC port                                                                                                                                                                                                                                   | `8088`                |
| `influxdb.startupProbe.enabled`                  | Enable startupProbe                                                                                                                                                                                                                                                  | `false`               |
| `influxdb.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                                                                                                                                                               | `180`                 |
| `influxdb.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                                                                                                                                                                      | `45`                  |
| `influxdb.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                                                                                                                                                                     | `30`                  |
| `influxdb.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                                                                                                                                                                   | `6`                   |
| `influxdb.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                                                                                                                                                                   | `1`                   |
| `influxdb.livenessProbe.enabled`                 | Enable livenessProbe                                                                                                                                                                                                                                                 | `true`                |
| `influxdb.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                                                                                                                                              | `180`                 |
| `influxdb.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                                                                                                                                                     | `45`                  |
| `influxdb.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                                                                                                                                                    | `30`                  |
| `influxdb.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                                                                                                                                                  | `6`                   |
| `influxdb.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                                                                                                                                                                  | `1`                   |
| `influxdb.readinessProbe.enabled`                | Enable readinessProbe                                                                                                                                                                                                                                                | `true`                |
| `influxdb.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                                                                                                                                             | `60`                  |
| `influxdb.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                                                                                                                                                    | `45`                  |
| `influxdb.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                                                                                                                                                   | `30`                  |
| `influxdb.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                                                                                                                                                 | `6`                   |
| `influxdb.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                                                                                                                                                 | `1`                   |
| `influxdb.customStartupProbe`                    | Override default startup probe                                                                                                                                                                                                                                       | `{}`                  |
| `influxdb.customLivenessProbe`                   | Override default liveness probe                                                                                                                                                                                                                                      | `{}`                  |
| `influxdb.customReadinessProbe`                  | Override default readiness probe                                                                                                                                                                                                                                     | `{}`                  |
| `influxdb.sidecars`                              | Add additional sidecar containers to the InfluxDB&trade; pod(s)                                                                                                                                                                                                      | `[]`                  |
| `influxdb.initContainers`                        | Add additional init containers to the InfluxDB&trade; pod(s)                                                                                                                                                                                                         | `[]`                  |
| `influxdb.service.type`                          | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                                                                                                                                                                  | `ClusterIP`           |
| `influxdb.service.ports.http`                    | InfluxDB&trade; HTTP port                                                                                                                                                                                                                                            | `8086`                |
| `influxdb.service.ports.rpc`                     | InfluxDB&trade; RPC port                                                                                                                                                                                                                                             | `8088`                |
| `influxdb.service.nodePorts`                     | Specify the nodePort(s) value for the LoadBalancer and NodePort service types.                                                                                                                                                                                       | `{}`                  |
| `influxdb.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                                                                                     | `""`                  |
| `influxdb.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                                                                                                                                                                                | `[]`                  |
| `influxdb.service.clusterIP`                     | Static clusterIP or None for headless services                                                                                                                                                                                                                       | `""`                  |
| `influxdb.service.externalTrafficPolicy`         | InfluxDB&trade; service external traffic policy                                                                                                                                                                                                                      | `Cluster`             |
| `influxdb.service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                                                                                                                                                                       | `[]`                  |
| `influxdb.service.annotations`                   | Annotations for InfluxDB&trade; service                                                                                                                                                                                                                              | `{}`                  |
| `influxdb.service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                                                                                 | `None`                |
| `influxdb.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                                                                                                                                                          | `{}`                  |


### InfluxDB Relay&trade; parameters

| Name                                          | Description                                                                                                            | Value                      |
|:----------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------|:---------------------------|
| `relay.image.registry`                        | InfluxDB Relay&trade; image registry                                                                                   | `docker.io`                |
| `relay.image.repository`                      | InfluxDB Relay&trade; image repository                                                                                 | `bitnami/influxdb-relay`   |
| `relay.image.tag`                             | InfluxDB Relay&trade; image tag (immutable tags are recommended)                                                       | `0.20200717.0-scratch-r14` |
| `relay.image.pullPolicy`                      | InfluxDB Relay&trade; image pull policy                                                                                | `IfNotPresent`             |
| `relay.image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                       | `[]`                       |
| `relay.configuration`                         | InfluxDB Relay&trade; Configuration. Specify content for relay.toml                                                    | `""`                       |
| `relay.existingConfiguration`                 | Name of existing ConfigMap object with the InfluxDB Relay&trade; configuration (`relay.configuration` will be ignored) | `""`                       |
| `relay.replicaCount`                          | The number of InfluxDB Relay&trade; replicas to deploy                                                                 | `1`                        |
| `relay.updateStrategy.type`                   | InfluxDB Relay&trade; deployment strategy type.                                                                        | `RollingUpdate`            |
| `relay.podAnnotations`                        | Annotations for InfluxDB Relay&trade; pods                                                                             | `{}`                       |
| `relay.podLabels`                             | Extra labels for InfluxDB Relay&trade; pods                                                                            | `{}`                       |
| `relay.hostAliases`                           | InfluxDB Relay&trade; pods host aliases                                                                                | `[]`                       |
| `relay.podAffinityPreset`                     | InfluxDB Relay&trade; Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`              | `""`                       |
| `relay.podAntiAffinityPreset`                 | InfluxDB Relay&trade; Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`         | `soft`                     |
| `relay.nodeAffinityPreset.type`               | InfluxDB Relay&trade; Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                       |
| `relay.nodeAffinityPreset.key`                | InfluxDB Relay&trade; Node label key to match Ignored if `affinity` is set.                                            | `""`                       |
| `relay.nodeAffinityPreset.values`             | InfluxDB Relay&trade; Node label values to match. Ignored if `affinity` is set.                                        | `[]`                       |
| `relay.affinity`                              | InfluxDB Relay&trade; Affinity for pod assignment                                                                      | `{}`                       |
| `relay.nodeSelector`                          | InfluxDB Relay&trade; Node labels for pod assignment                                                                   | `{}`                       |
| `relay.tolerations`                           | InfluxDB Relay&trade; Tolerations for pod assignment                                                                   | `[]`                       |
| `relay.priorityClassName`                     | InfluxDB Relay&trade; pods' priorityClassName                                                                          | `""`                       |
| `relay.schedulerName`                         | Name of the k8s scheduler (other than default)                                                                         | `""`                       |
| `relay.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                                                         | `[]`                       |
| `relay.podSecurityContext.enabled`            | Enabled InfluxDB Relay&trade; pods' Security Context                                                                   | `true`                     |
| `relay.podSecurityContext.fsGroup`            | Set InfluxDB Relay&trade; pod's Security Context fsGroup                                                               | `1001`                     |
| `relay.containerSecurityContext.enabled`      | Enabled InfluxDB Relay&trade; containers' Security Context                                                             | `true`                     |
| `relay.containerSecurityContext.runAsUser`    | Set InfluxDB Relay&trade; containers' Security Context runAsUser                                                       | `1001`                     |
| `relay.containerSecurityContext.runAsNonRoot` | Set Controller container's Security Context runAsNonRoot                                                               | `true`                     |
| `relay.resources.limits`                      | The resources limits for the container                                                                                 | `{}`                       |
| `relay.resources.requests`                    | The requested resources for the container                                                                              | `{}`                       |
| `relay.command`                               | Override default container command (useful when using custom images)                                                   | `[]`                       |
| `relay.args`                                  | Override default container args (useful when using custom images)                                                      | `[]`                       |
| `relay.lifecycleHooks`                        | for the InfluxDB Relay&trade; container(s) to automate configuration before or after startup                           | `{}`                       |
| `relay.extraEnvVars`                          | Array containing extra env vars to configure InfluxDB Relay&trade;                                                     | `[]`                       |
| `relay.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for InfluxDB Relay&trade; nodes                                   | `""`                       |
| `relay.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for InfluxDB Relay&trade; nodes                                      | `""`                       |
| `relay.extraVolumes`                          | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting extraVolumeMounts       | `[]`                       |
| `relay.extraVolumeMounts`                     | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with extraVolumes.    | `[]`                       |
| `relay.startupProbe.enabled`                  | Enable startupProbe                                                                                                    | `false`                    |
| `relay.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                 | `30`                       |
| `relay.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                        | `10`                       |
| `relay.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                       | `5`                        |
| `relay.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                     | `6`                        |
| `relay.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                     | `1`                        |
| `relay.livenessProbe.enabled`                 | Enable livenessProbe                                                                                                   | `true`                     |
| `relay.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                | `30`                       |
| `relay.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                       | `10`                       |
| `relay.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                      | `5`                        |
| `relay.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                    | `6`                        |
| `relay.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                    | `1`                        |
| `relay.readinessProbe.enabled`                | Enable readinessProbe                                                                                                  | `true`                     |
| `relay.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                               | `5`                        |
| `relay.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                      | `10`                       |
| `relay.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                     | `5`                        |
| `relay.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                   | `6`                        |
| `relay.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                   | `1`                        |
| `relay.customStartupProbe`                    | Override default startup probe                                                                                         | `{}`                       |
| `relay.customLivenessProbe`                   | Override default liveness probe                                                                                        | `{}`                       |
| `relay.customReadinessProbe`                  | Override default readiness probe                                                                                       | `{}`                       |
| `relay.containerPorts`                        | Container ports                                                                                                        | `{}`                       |
| `relay.sidecars`                              | Add additional sidecar containers to the InfluxDB Relay&trade; pod(s)                                                  | `[]`                       |
| `relay.initContainers`                        | Add additional init containers to the InfluxDB Relay&trade; pod(s)                                                     | `[]`                       |
| `relay.service.type`                          | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                    | `ClusterIP`                |
| `relay.service.ports.http`                    | InfluxDB Relay&trade; HTTP port                                                                                        | `9096`                     |
| `relay.service.nodePorts.http`                | Kubernetes HTTP node port                                                                                              | `""`                       |
| `relay.service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                                                       | `""`                       |
| `relay.service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                                                  | `[]`                       |
| `relay.service.clusterIP`                     | Static clusterIP or None for headless services                                                                         | `""`                       |
| `relay.service.annotations`                   | Annotations for InfluxDB Relay&trade; service                                                                          | `{}`                       |
| `relay.service.externalTrafficPolicy`         | InfluxDB Relay&trade; service external traffic policy                                                                  | `Cluster`                  |
| `relay.service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                         | `[]`                       |
| `relay.service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                   | `None`                     |
| `relay.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                            | `{}`                       |


### InfluxDB Collectd&trade; parameters

| Name                                        | Description                                                                               | Value       |
|:--------------------------------------------|:------------------------------------------------------------------------------------------|:------------|
| `collectd.enabled`                          | InfluxDB Collectd&trade; service enable                                                   | `false`     |
| `collectd.service.type`                     | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                       | `ClusterIP` |
| `collectd.service.port`                     | InfluxDB Collectd&trade; UDP port (should match with corresponding port in influxdb.conf) | `25826`     |
| `collectd.service.nodePort`                 | Kubernetes HTTP node port                                                                 | `""`        |
| `collectd.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                          | `""`        |
| `collectd.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                     | `[]`        |
| `collectd.service.clusterIP`                | Static clusterIP or None for headless services                                            | `""`        |
| `collectd.service.externalTrafficPolicy`    | InfluxDB Collectd&trade; service external traffic policy                                  | `Cluster`   |
| `collectd.service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                            | `[]`        |
| `collectd.service.annotations`              | Annotations for InfluxDB Collectd&trade; service                                          | `{}`        |
| `collectd.service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                      | `None`      |
| `collectd.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                               | `{}`        |


### Exposing parameters

| Name                       | Description                                                                                                                      | Value                    |
|:---------------------------|:---------------------------------------------------------------------------------------------------------------------------------|:-------------------------|
| `ingress.enabled`          | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.tls`              | Create TLS Secret                                                                                                                | `false`                  |
| `ingress.pathType`         | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`       | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`         | Default host for the ingress resource                                                                                            | `influxdb.local`         |
| `ingress.path`             | Ingress path*' in order to use this                                                                                              | `/`                      |
| `ingress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.extraHosts`       | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`       | Additional arbitrary path/backend objects                                                                                        | `[]`                     |
| `ingress.extraTls`         | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`          | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |


### Metrics parameters

| Name                                       | Description                                                                                                                                 | Value               |
|:-------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------|:--------------------|
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                                                     | `false`             |
| `metrics.service.type`                     | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                                         | `ClusterIP`         |
| `metrics.service.port`                     | InfluxDB&trade; Prometheus port                                                                                                             | `9122`              |
| `metrics.service.nodePort`                 | Kubernetes HTTP node port                                                                                                                   | `""`                |
| `metrics.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                                                                            | `""`                |
| `metrics.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                                                       | `[]`                |
| `metrics.service.clusterIP`                | Static clusterIP or None for headless services                                                                                              | `""`                |
| `metrics.service.annotations`              | Annotations for the Prometheus metrics service                                                                                              | `{}`                |
| `metrics.service.externalTrafficPolicy`    | Service external traffic policy                                                                                                             | `Cluster`           |
| `metrics.service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                              | `[]`                |
| `metrics.service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                        | `None`              |
| `metrics.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                                 | `{}`                |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                      | `false`             |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                                                                    | `""`                |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                                                                | `""`                |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                                                     | `""`                |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                          | `[]`                |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                                   | `[]`                |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                                         | `{}`                |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                                                                    | `false`             |
| `networkPolicy.enabled`                    | Enable NetworkPolicy                                                                                                                        | `false`             |
| `networkPolicy.allowExternal`              | Don't require client label for connections                                                                                                  | `true`              |
| `persistence.enabled`                      | Enable data persistence                                                                                                                     | `true`              |
| `persistence.existingClaim`                | Use a existing PVC which must be created manually before bound                                                                              | `""`                |
| `persistence.storageClass`                 | Specify the `storageClass` used to provision the volume                                                                                     | `""`                |
| `persistence.accessModes`                  | Access mode of data volume                                                                                                                  | `["ReadWriteOnce"]` |
| `persistence.size`                         | Size of data volume                                                                                                                         | `8Gi`               |
| `persistence.annotations`                  | Persistent Volume Claim annotations                                                                                                         | `{}`                |
| `serviceAccount.enabled`                   | Enable service account (Note: Service Account will only be automatically created if `serviceAccount.name` is not set)                       | `false`             |
| `serviceAccount.name`                      | Name of an already existing service account. Setting this value disables the automatic service account creation                             | `""`                |
| `psp.create`                               | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later | `false`             |
| `rbac.create`                              | Create Role and RoleBinding (required for PSP to work)                                                                                      | `false`             |


### Volume permissions parameters

| Name                                          | Description                                                                                                       | Value                   |
|:----------------------------------------------|:------------------------------------------------------------------------------------------------------------------|:------------------------|
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume mountpoint to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                  | `docker.io`             |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                      | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                       | `10-debian-10-r312`     |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                               | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                  | `[]`                    |
| `volumePermissions.securityContext.runAsUser` | User ID for the init container (when facing issues in OpenShift or uid unknown, try value "auto")                 | `0`                     |


### InfluxDB&trade; backup parameters

| Name                                              | Description                                                                                             | Value                      |
|:--------------------------------------------------|:--------------------------------------------------------------------------------------------------------|:---------------------------|
| `backup.enabled`                                  | Enable InfluxDB&trade; backup                                                                           | `false`                    |
| `backup.directory`                                | Directory where backups are stored                                                                      | `/backups`                 |
| `backup.retentionDays`                            | Retention time in days for backups (older backups are deleted)                                          | `10`                       |
| `backup.cronjob.schedule`                         | Schedule in Cron format to save snapshots                                                               | `0 2 * * *`                |
| `backup.cronjob.historyLimit`                     | Number of successful finished jobs to retain                                                            | `1`                        |
| `backup.cronjob.podAnnotations`                   | Pod annotations                                                                                         | `{}`                       |
| `backup.cronjob.securityContext.enabled`          | Enable security context for InfluxDB&trade;                                                             | `true`                     |
| `backup.cronjob.securityContext.fsGroup`          | Group ID for the InfluxDB&trade; filesystem                                                             | `1001`                     |
| `backup.cronjob.securityContext.runAsUser`        | Group ID for the InfluxDB&trade; filesystem                                                             | `1001`                     |
| `backup.podAffinityPreset`                        | Backup &trade; Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`      | `""`                       |
| `backup.podAntiAffinityPreset`                    | Backup&trade; Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                     |
| `backup.nodeAffinityPreset.type`                  | Backup&trade; Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                       |
| `backup.nodeAffinityPreset.key`                   | Backup&trade; Node label key to match Ignored if `affinity` is set.                                     | `""`                       |
| `backup.nodeAffinityPreset.values`                | Backup&trade; Node label values to match. Ignored if `affinity` is set.                                 | `[]`                       |
| `backup.affinity`                                 | Backup&trade; Affinity for backup pod assignment                                                        | `{}`                       |
| `backup.nodeSelector`                             | Backup&trade; Node labels for backup pod assignment                                                     | `{}`                       |
| `backup.tolerations`                              | Backup&trade; Tolerations for backup pod assignment                                                     | `[]`                       |
| `backup.uploadProviders.google.enabled`           | enable upload to google storage bucket                                                                  | `false`                    |
| `backup.uploadProviders.google.secret`            | json secret with serviceaccount data to access Google storage bucket                                    | `""`                       |
| `backup.uploadProviders.google.secretKey`         | service account secret key name                                                                         | `key.json`                 |
| `backup.uploadProviders.google.existingSecret`    | Name of existing secret object with Google serviceaccount json credentials                              | `""`                       |
| `backup.uploadProviders.google.bucketName`        | google storage bucket name name                                                                         | `gs://bucket/influxdb`     |
| `backup.uploadProviders.google.image.registry`    | Google Cloud SDK image registry                                                                         | `docker.io`                |
| `backup.uploadProviders.google.image.repository`  | Google Cloud SDK image name                                                                             | `bitnami/google-cloud-sdk` |
| `backup.uploadProviders.google.image.tag`         | Google Cloud SDK image tag                                                                              | `0.368.0-debian-10-r6`     |
| `backup.uploadProviders.google.image.pullPolicy`  | Google Cloud SDK image pull policy                                                                      | `IfNotPresent`             |
| `backup.uploadProviders.google.image.pullSecrets` | Specify docker-registry secret names as an array                                                        | `[]`                       |
| `backup.uploadProviders.azure.enabled`            | Enable upload to azure storage container                                                                | `false`                    |
| `backup.uploadProviders.azure.secret`             | Secret with credentials to access Azure storage                                                         | `""`                       |
| `backup.uploadProviders.azure.secretKey`          | Service account secret key name                                                                         | `connection-string`        |
| `backup.uploadProviders.azure.existingSecret`     | Name of existing secret object                                                                          | `""`                       |
| `backup.uploadProviders.azure.containerName`      | Destination container                                                                                   | `influxdb-container`       |
| `backup.uploadProviders.azure.image.registry`     | Azure CLI image registry                                                                                | `docker.io`                |
| `backup.uploadProviders.azure.image.repository`   | Azure CLI image repository                                                                              | `bitnami/azure-cli`        |
| `backup.uploadProviders.azure.image.tag`          | Azure CLI image tag (immutable tags are recommended)                                                    | `2.32.0-debian-10-r13`     |
| `backup.uploadProviders.azure.image.pullPolicy`   | Azure CLI image pull policy                                                                             | `IfNotPresent`             |
| `backup.uploadProviders.azure.image.pullSecrets`  | Specify docker-registry secret names as an array                                                        | `[]`                       |
| `backup.uploadProviders.aws.enabled`              | Enable upload to aws s3 bucket                                                                          | `false`                    |
| `backup.uploadProviders.aws.accessKeyID`          | Access Key ID to access aws s3                                                                          | `""`                       |
| `backup.uploadProviders.aws.secretAccessKey`      | Secret Access Key to access aws s3                                                                      | `""`                       |
| `backup.uploadProviders.aws.region`               | Region of aws s3 bucket                                                                                 | `us-east-1`                |
| `backup.uploadProviders.aws.existingSecret`       | Name of existing secret object                                                                          | `""`                       |
| `backup.uploadProviders.aws.bucketName`           | aws s3 bucket name                                                                                      | `s3://bucket/influxdb`     |
| `backup.uploadProviders.aws.image.registry`       | AWS CLI image registry                                                                                  | `docker.io`                |
| `backup.uploadProviders.aws.image.repository`     | AWS CLI image repository                                                                                | `bitnami/aws-cli`          |
| `backup.uploadProviders.aws.image.tag`            | AWS CLI image tag (immutable tags are recommended)                                                      | `2.4.7-debian-10-r4`       |
| `backup.uploadProviders.aws.image.pullPolicy`     | AWS CLI image pull policy                                                                               | `IfNotPresent`             |
| `backup.uploadProviders.aws.image.pullSecrets`    | Specify docker-registry secret names as an array                                                        | `[]`                       |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set auth.admin.username=admin-user bitnami/influxdb
```

The above command sets the InfluxDB&trade; admin user to `admin-user`.

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

You can install the InfluxDB&trade; chart with two different architecture setups: "standalone" or "high-availability", you can use the `architecture` parameter:

```console
architecture="standalone"
architecture="high-availability"
```

The standalone architecture installs a deployment with one InfluxDB&trade; server (it cannot be scaled):

```
                ------------------
               |     Ingress      |
               |    Controller    |
                ------------------
                        |
                        | /query
                        | /write
                        \/
                 ----------------
                |  InfluxDB(TM)  |
                |      svc       |
                 ----------------
                        |
                        \/
                  --------------
                 | InfluxDB(TM) |
                 |    Server    |
                 |     Pod      |
                  --------------
```

The high availability install a statefulset with N InfluxDB&trade; servers and M InfluxDB Relay&trade; instances:

```
                    ------------------
                   |     Ingress      |
                   |    Controller    |
                    ------------------
                           | |
                           | |
               ------------   -------------
              |                            |
              | /write              /query |
             \/                            \/
       --------------------    --------------------
      | InfluxDB Relay(TM) |  |    InfluxDB(TM)    |
      |          svc       |  |         svc        |
       --------------------    --------------------
       -----------|-|---------------|-----|-----------|
      |           | |               |     |           \/
 --------------   | |               |     |   --------------
|   InfluxDB   |  | |               |     |  | InfluxDB(TM) |
|  Relay(TM)   |<-| |               |     |->|    Server    |
|     Pod      |    |               |        |     Pod      |
 --------------     |               |         --------------
      |             |               |           ^
      --------------|---------------|--------   |
                    |               |       |   |
  ------------------|---------------|------------
  |                 |               |       |
  |                 |               |       \/
 ---------------    |               |    --------------
|    InfluxDB   |   |               |   | InfluxDB(TM) |
|   Relay(TM)   |<--|               |-->|  Server      |
|      Pod      |                       |   Pod        |
 ---------------                         --------------
      |                                   ^
      |-----------------------------------|
```

When using the high-availability architecture, it is recommended to configure sticky sessions using `--set influxdb.service.sessionAffinity="ClientIP"` or configuring the IngressController accordingly.

### Configure the way how to expose InfluxDB&trade;

- **Ingress**: The ingress controller must be installed in the Kubernetes cluster. Set `ingress.enabled=true` to expose InfluxDB&trade; through Ingress.
- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster. Set `influxdb.service.type=ClusterIP` to choose this service type.
- **NodePort**: Exposes the service on each Node's IP at a static port (the NodePort). You'll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`. Set `influxdb.service.type=NodePort` to choose this service type.
- **LoadBalancer**: Exposes the service externally using a cloud provider's load balancer. Set `influxdb.service.type=LoadBalancer` to choose this service type.

### Using custom configuration

This helm chart supports to customize the whole configuration file.

Add your custom configuration file to "files/conf" in your working directory. This file will be mounted as a configMap to the containers and it will be used for configuring InfluxDB&trade;.

Alternatively, you can specify the InfluxDB&trade; configuration using the `influxdb.configuration` parameter.

In addition to these options, you can also set an external ConfigMap with all the configuration files. This is done by setting the `influxdb.existingConfiguration` parameter. Note that this will override the two previous options.

### Adding extra environment variables

In case you want to add extra environment variables, you can use the `influxdb.extraEnvVars` property.

```yaml
extraEnvVars:
  - name: INFLUXDB_DATA_QUERY_LOG_ENABLED
    value: "true"
```

### Initialize a fresh instance

The [Bitnami InfluxDB&trade;](https://github.com/bitnami/bitnami-docker-influxdb) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

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

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

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

### To 4.0.0

This major release completely removes support for InfluxDB&trade; branch 1.x.x. You can use images for versions ~1.x.x taking into account the chart may need some modification to run with them.

If you were using InfluxDB&trade; +2.0 no issues are expected during upgrade.

### To 3.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `influxdb.service.port` was deprecated, we recommend using `influxdb.service.ports.http` instead.
- `influxdb.service.rpcPort` was deprecated, we recommend using `influxdb.service.ports.rpc` instead.
- `relay.service.port` was deprecated, we recommend using `relay.service.ports.http` instead.
- `relay.service.nodePort` was renamed as `relay.service.nodePorts.http`.
- `influxdb.securityContext` split into `influxdb.containerSecurityContext` and `influxdb.podSecurityContext`.
- `relay.securityContext` split into `relay.containerSecurityContext` and `relay.podSecurityContext`.
- `influxdb.updateStrategy` and `relay.updateStrategy`changed from String type (previously default to 'rollingUpdate') to Object type, allowing users to configure other updateStrategy parameters, similar to other charts.

### To 2.0.0

This version adds support to InfluxDB&trade; +2.0, since this version the chart is only verified to work with InfluxDB&trade; +2.0 bitnami images.
However, you can use images for versions ~1.x.x taking into account the chart may need some modification to run with them.

#### Installing InfluxDB&trade; v1 in chart v2.

```
$ helm install bitnami/influxdb --set image.tag=1.8.3-debian-10-r88
```

As a consecuece some breaking changes have been included in this version.

- Authentication values has been moved to `auth.<property>...`.
- We keep `auth.readUser` and `auth.writeUser` user options in order to be compatible with InfluxDB&trade; v1. If you are using InfluxDB&trade; 2.0, please, use the CLI to create user and tokens through initDb scripts at `influxdb.initdbScripts` or the UI due to we are not able to automacally provide a token for them to be used. See more [InfluxDB&trade; 2.0 auth](https://docs.influxdata.com/influxdb/v2.0/security/tokens/)
- InfluxDB&trade; 2.0 has removed database concept, now it is called Bucket so the property `database` has been also moved to `auth.user.bucket`.
- Removed support for `files/docker-entrypoint-initdb.d/*.{sh,txt}`, please use `.influxdb.initdbScripts` or `.Values.influxdb.initdbScriptsCM` instead.
- Removed support for `files/conf/influxdb.conf`, please use `.influxdb.configuration` or `.influxdb.existingConfiguration` instead.
- Removed support for `files/conf/relay.toml`, please use `.Values.relay.configuration` or `.Values.relay.existingConfiguration` instead.
- `ingress.hosts` parameter has been replaced by `ingress.hostname` and `ingress.extraHosts` that may give us a bit more flexibility.

#### Migrating form InfluxDB&trade; v1 to v2

Since this release could mean lot of concepts changes, we strongly recommend to not do it direcly using the chart upgrade. Please, read more info in their [upgrade guide](https://docs.influxdata.com/influxdb/v2.0/upgrade/v1-to-v2/).

We actually recommend to backup all the data form a previous helm release, install new release using latest version of the chart and images and then restore data following their guides.

#### Upgrading the chart form 1.x.x to 2.x.x using InfluxDB&trade; v1 images.

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

## License

Copyright &copy; 2022 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
