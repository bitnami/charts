# phpfpm

PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some additional features useful for sites of any size, especially busier sites.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/phpfpm
```

## Introduction

This chart bootstraps an phpfpm deployment on a Kubernetes cluster using the Helm package manager.

Bitnami charts can be used with Kubeapps for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/phpfpm
```

The command deploys phpfpm on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
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
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### phpfpm Parameters

| Name                                           | Description                                                                                      | Value                       |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------------------- |
| `phpfpm.image.registry`                        | phpfpm image registry                                                                            | `docker.io`                 |
| `phpfpm.image.repository`                      | phpfpm image repository                                                                          | `bitnami/php-fpm`           |
| `phpfpm.image.tag`                             | phpfpm image tag (immutable tags are recommended)                                                | `7.4.26-prod-debian-10-r26` |
| `phpfpm.image.pullPolicy`                      | phpfpm image pull policy                                                                         | `IfNotPresent`              |
| `phpfpm.image.pullSecrets`                     | phpfpm image pull secrets                                                                        | `[]`                        |
| `phpfpm.image.debug`                           | Enable phpfpm image debug mode                                                                   | `false`                     |
| `phpfpm.replicaCount`                          | Number of phpfpm replicas to deploy                                                              | `1`                         |
| `phpfpm.containerPorts.tcp`                    | phpfpm HTTP container port                                                                       | `9000`                      |
| `phpfpm.containerExtraPorts`                   | Extra ports to expose at container level                                                         | `{}`                        |
| `phpfpm.livenessProbe.enabled`                 | Enable livenessProbe on phpfpm containers                                                        | `true`                      |
| `phpfpm.livenessProbe.tcpSocket.port`          | Liveness Probe TCP Socket                                                                        | `9000`                      |
| `phpfpm.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                          | `15`                        |
| `phpfpm.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                 | `10`                        |
| `phpfpm.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                | `5`                         |
| `phpfpm.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                              | `3`                         |
| `phpfpm.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                              | `1`                         |
| `phpfpm.readinessProbe.enabled`                | Enable readinessProbe on phpfpm containers                                                       | `true`                      |
| `phpfpm.readinessProbe.tcpSocket.port`         | Liveness Probe TCP Socket                                                                        | `9000`                      |
| `phpfpm.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                         | `15`                        |
| `phpfpm.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                | `10`                        |
| `phpfpm.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                               | `5`                         |
| `phpfpm.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                             | `3`                         |
| `phpfpm.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                             | `1`                         |
| `phpfpm.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                              | `{}`                        |
| `phpfpm.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                             | `{}`                        |
| `phpfpm.customStartupProbe`                    | Custom startupProbe that overrides the default one                                               | `{}`                        |
| `phpfpm.resources.limits`                      | The resources limits for the phpfpm containers                                                   | `{}`                        |
| `phpfpm.resources.requests`                    | The requested resources for the phpfpm containers                                                | `{}`                        |
| `phpfpm.podSecurityContext.enabled`            | Enabled phpfpm pods' Security Context                                                            | `true`                      |
| `phpfpm.podSecurityContext.fsGroup`            | Set phpfpm pod's Security Context fsGroup                                                        | `1001`                      |
| `phpfpm.containerSecurityContext.enabled`      | Enabled phpfpm containers' Security Context                                                      | `true`                      |
| `phpfpm.containerSecurityContext.runAsUser`    | Set phpfpm containers' Security Context runAsUser                                                | `1001`                      |
| `phpfpm.containerSecurityContext.runAsNonRoot` | Set phpfpm containers' Security Context runAsNonRoot                                             | `true`                      |
| `phpfpm.command`                               | Override default container command (useful when using custom images)                             | `[]`                        |
| `phpfpm.args`                                  | Override default container args (useful when using custom images)                                | `[]`                        |
| `phpfpm.hostAliases`                           | phpfpm pods host aliases                                                                         | `[]`                        |
| `phpfpm.podLabels`                             | Extra labels for phpfpm pods                                                                     | `{}`                        |
| `phpfpm.podAnnotations`                        | Annotations for phpfpm pods                                                                      | `{}`                        |
| `phpfpm.podAffinityPreset`                     | Pod affinity preset. Ignored if `phpfpm.affinity` is set. Allowed values: `soft` or `hard`       | `""`                        |
| `phpfpm.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `phpfpm.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                      |
| `phpfpm.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `phpfpm.affinity` is set. Allowed values: `soft` or `hard` | `""`                        |
| `phpfpm.nodeAffinityPreset.key`                | Node label key to match. Ignored if `phpfpm.affinity` is set                                     | `""`                        |
| `phpfpm.nodeAffinityPreset.values`             | Node label values to match. Ignored if `phpfpm.affinity` is set                                  | `[]`                        |
| `phpfpm.affinity`                              | Affinity for phpfpm pods assignment                                                              | `{}`                        |
| `phpfpm.nodeSelector`                          | Node labels for phpfpm pods assignment                                                           | `{}`                        |
| `phpfpm.tolerations`                           | Tolerations for phpfpm pods assignment                                                           | `[]`                        |
| `phpfpm.updateStrategy.type`                   | phpfpm statefulset strategy type                                                                 | `RollingUpdate`             |
| `phpfpm.priorityClassName`                     | phpfpm pods' priorityClassName                                                                   | `""`                        |
| `phpfpm.schedulerName`                         | Name of the k8s scheduler (other than default) for phpfpm pods                                   | `""`                        |
| `phpfpm.lifecycleHooks`                        | for the phpfpm container(s) to automate configuration before or after startup                    | `{}`                        |
| `phpfpm.extraEnvVars`                          | Array with extra environment variables to add to phpfpm nodes                                    | `[]`                        |
| `phpfpm.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for phpfpm nodes                            | `nil`                       |
| `phpfpm.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for phpfpm nodes                               | `nil`                       |
| `phpfpm.extraVolumes`                          | Optionally specify extra list of additional volumes for the phpfpm pod(s)                        | `[]`                        |
| `phpfpm.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the phpfpm container(s)             | `[]`                        |
| `phpfpm.sidecars`                              | Add additional sidecar containers to the phpfpm pod(s)                                           | `{}`                        |
| `phpfpm.initContainers`                        | Add additional init containers to the phpfpm pod(s)                                              | `{}`                        |


### php-fpm configuration

| Name                          | Description                                                                                                         | Value |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------- | ----- |
| `phpfpmConfiguration`         | php-fpm configuration                                                                                               | `{}`  |
| `phpfpmExtendedConfiguration` | Extended Runtime Config Parameters PHP has been configured at compile time to scan the /opt/bitnami/php/etc/conf.d/ | `{}`  |
| `phpfpmExtendedConfConfigMap` | specify an existing configmap used as extra php-fpm ini files.                                                      | `""`  |
| `phpfpmExistingConfConfigmap` | specify an existing configmap used as php-fpm configuration.                                                        | `""`  |


### Traffic Exposure Parameters

| Name                                       | Description                                                                                    | Value          |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------- | -------------- |
| `networkPolicy.enabled`                    | Enable creation of NetworkPolicy resources. Only Ingress traffic is filtered for now.          | `false`        |
| `networkPolicy.allowExternal`              | Don't require client label for connections                                                     | `true`         |
| `networkPolicy.explicitNamespacesSelector` | A Kubernetes LabelSelector to explicitly select namespaces from which traffic could be allowed | `{}`           |
| `service.type`                             | phpfpm service type                                                                            | `LoadBalancer` |
| `service.ports.tcp`                        | phpfpm service TCP port                                                                        | `9000`         |
| `service.nodePorts.tcp`                    | Node port for HTTP                                                                             | `nil`          |
| `service.clusterIP`                        | phpfpm service Cluster IP                                                                      | `nil`          |
| `service.loadBalancerIP`                   | phpfpm service Load Balancer IP                                                                | `nil`          |
| `service.loadBalancerSourceRanges`         | phpfpm service Load Balancer sources                                                           | `[]`           |
| `service.externalTrafficPolicy`            | phpfpm service external traffic policy                                                         | `Cluster`      |
| `service.annotations`                      | Additional custom annotations for phpfpm service                                               | `{}`           |
| `service.extraPorts`                       | Extra ports to expose in phpfpm service (normally used with the `sidecars` value)              | `[]`           |


### Init Container Parameters

| Name | Description | Value |
| ---- | ----------- | ----- |




