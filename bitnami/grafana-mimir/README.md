<!--- app-name: Grafana Mimir -->

# Grafana Mimir packaged by Bitnami

Grafana Mimir is an open source, horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus.

[Overview of Grafana Mimir](https://grafana.com/oss/mimir/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ helm repo add my-repo https://charts.bitnami.com/bitnami
$ helm install my-release my-repo/grafana-mimir
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Grafana Mimir](https://github.com/grafana/mimir) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/infrastructure/grafana-mimir/get-started/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release my-repo/grafana-mimir
```

The command deploys grafana-mimir on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### Common Grafana Mimir Parameters

| Name                                | Description                                                                                                                                              | Value                    |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `mimir.image.registry`              | Grafana Mimir image registry                                                                                                                             | `docker.io`              |
| `mimir.image.repository`            | Grafana Mimir image repository                                                                                                                           | `bitnami/grafana-mimir`  |
| `mimir.image.tag`                   | Grafana Mimir image tag (immutable tags are recommended)                                                                                                 | `2.5.0-debian-11-r6`     |
| `mimir.image.digest`                | Grafana Mimir image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                     |
| `mimir.image.pullPolicy`            | Grafana Mimir image pull policy                                                                                                                          | `IfNotPresent`           |
| `mimir.image.pullSecrets`           | Grafana Mimir image pull secrets                                                                                                                         | `[]`                     |
| `mimir.image.debug`                 | Enable Grafana Mimir image debug mode                                                                                                                    | `false`                  |
| `mimir.dataDir`                     | path to the Mimir data directory                                                                                                                         | `/bitnami/grafana-mimir` |
| `mimir.configuration`               | Mimir components configuration                                                                                                                           | `""`                     |
| `mimir.overrideConfiguration`       | Loki components configuration override. Values defined here takes precedence over mimir.configuration                                                    | `{}`                     |
| `mimir.existingConfigmap`           | Name of a ConfigMap with the Loki configuration                                                                                                          | `""`                     |
| `mimir.containerPorts.http-metrics` | Grafana Mimir HTTP metrics container port                                                                                                                | `8080`                   |
| `mimir.containerPorts.grpc`         | Grafana Mimir GRPC container port                                                                                                                        | `9095`                   |
| `mimir.containerPorts.memberlist`   | Grafana Mimir memberlist container port                                                                                                                  | `7946`                   |


### Compactor Deployment Parameters

| Name                                              | Description                                                                                         | Value               |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------- |
| `compactor.extraEnvVars`                          | Array with extra environment variables to add to compactor nodes                                    | `[]`                |
| `compactor.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for compactor nodes                            | `""`                |
| `compactor.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for compactor nodes                               | `""`                |
| `compactor.command`                               | Override default container command (useful when using custom images)                                | `[]`                |
| `compactor.args`                                  | Override default container args (useful when using custom images)                                   | `[]`                |
| `compactor.extraArgs`                             | Add additional argsto the default container args (useful to override configuration)                 | `[]`                |
| `compactor.replicaCount`                          | Number of Compactor replicas to deploy                                                              | `1`                 |
| `compactor.podManagementPolicy`                   | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join  | `OrderedReady`      |
| `compactor.livenessProbe.enabled`                 | Enable livenessProbe on Compactor nodes                                                             | `true`              |
| `compactor.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                             | `60`                |
| `compactor.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                    | `10`                |
| `compactor.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                   | `1`                 |
| `compactor.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                 | `3`                 |
| `compactor.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                 | `1`                 |
| `compactor.readinessProbe.enabled`                | Enable readinessProbe on Compactor nodes                                                            | `true`              |
| `compactor.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                            | `60`                |
| `compactor.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                   | `10`                |
| `compactor.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                  | `1`                 |
| `compactor.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                | `3`                 |
| `compactor.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                | `1`                 |
| `compactor.startupProbe.enabled`                  | Enable startupProbe on Compactor containers                                                         | `false`             |
| `compactor.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                              | `30`                |
| `compactor.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                     | `10`                |
| `compactor.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                    | `1`                 |
| `compactor.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                  | `15`                |
| `compactor.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                  | `1`                 |
| `compactor.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                 | `{}`                |
| `compactor.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                | `{}`                |
| `compactor.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                  | `{}`                |
| `compactor.resources.limits`                      | The resources limits for the compactor containers                                                   | `{}`                |
| `compactor.resources.requests`                    | The requested resources for the compactor containers                                                | `{}`                |
| `compactor.podSecurityContext.enabled`            | Enabled Compactor pods' Security Context                                                            | `true`              |
| `compactor.podSecurityContext.fsGroup`            | Set Compactor pod's Security Context fsGroup                                                        | `1001`              |
| `compactor.containerSecurityContext.enabled`      | Enabled Compactor containers' Security Context                                                      | `true`              |
| `compactor.containerSecurityContext.runAsUser`    | Set Compactor containers' Security Context runAsUser                                                | `1001`              |
| `compactor.containerSecurityContext.runAsNonRoot` | Set Compactor containers' Security Context runAsNonRoot                                             | `true`              |
| `compactor.lifecycleHooks`                        | for the compactor container(s) to automate configuration before or after startup                    | `{}`                |
| `compactor.hostAliases`                           | compactor pods host aliases                                                                         | `[]`                |
| `compactor.podLabels`                             | Extra labels for compactor pods                                                                     | `{}`                |
| `compactor.podAnnotations`                        | Annotations for compactor pods                                                                      | `{}`                |
| `compactor.podAffinityPreset`                     | Pod affinity preset. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard`       | `""`                |
| `compactor.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard`  | `soft`              |
| `compactor.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard` | `""`                |
| `compactor.nodeAffinityPreset.key`                | Node label key to match. Ignored if `compactor.affinity` is set                                     | `""`                |
| `compactor.nodeAffinityPreset.values`             | Node label values to match. Ignored if `compactor.affinity` is set                                  | `[]`                |
| `compactor.affinity`                              | Affinity for Compactor pods assignment                                                              | `{}`                |
| `compactor.nodeSelector`                          | Node labels for Compactor pods assignment                                                           | `{}`                |
| `compactor.tolerations`                           | Tolerations for Compactor pods assignment                                                           | `[]`                |
| `compactor.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains     | `[]`                |
| `compactor.priorityClassName`                     | Compactor pods' priorityClassName                                                                   | `""`                |
| `compactor.schedulerName`                         | Kubernetes pod scheduler registry                                                                   | `""`                |
| `compactor.terminationGracePeriodSeconds`         | Seconds pod needs to terminate gracefully                                                           | `""`                |
| `compactor.updateStrategy.type`                   | Compactor statefulset strategy type                                                                 | `RollingUpdate`     |
| `compactor.updateStrategy.rollingUpdate`          | Compactor statefulset rolling update configuration parameters                                       | `{}`                |
| `compactor.extraVolumes`                          | Optionally specify extra list of additional volumes for the Compactor pod(s)                        | `[]`                |
| `compactor.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Compactor container(s)             | `[]`                |
| `compactor.sidecars`                              | Add additional sidecar containers to the Compactor pod(s)                                           | `[]`                |
| `compactor.initContainers`                        | Add additional init containers to the Compactor pod(s)                                              | `[]`                |
| `compactor.persistence.enabled`                   | Enable persistence in Compactor instances                                                           | `true`              |
| `compactor.persistence.existingClaim`             | Name of an existing PVC to use                                                                      | `""`                |
| `compactor.persistence.storageClass`              | PVC Storage Class for Memcached data volume                                                         | `""`                |
| `compactor.persistence.accessModes`               | PVC Access modes                                                                                    | `["ReadWriteOnce"]` |
| `compactor.persistence.size`                      | PVC Storage Request for Memcached data volume                                                       | `8Gi`               |
| `compactor.persistence.annotations`               | Additional PVC annotations                                                                          | `{}`                |
| `compactor.persistence.selector`                  | Selector to match an existing Persistent Volume for Compactor's data PVC                            | `{}`                |
| `compactor.persistence.dataSource`                | PVC data source                                                                                     | `{}`                |


### Compactor Traffic Exposure Parameters

| Name                                         | Description                                                      | Value       |
| -------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `compactor.service.type`                     | Compactor service type                                           | `ClusterIP` |
| `compactor.service.ports.http-metrics`       | Compactor HTTP service port                                      | `8080`      |
| `compactor.service.ports.grpc`               | Compactor GRPC service port                                      | `9095`      |
| `compactor.service.nodePorts.http-metrics`   | Node port for HTTP                                               | `""`        |
| `compactor.service.nodePorts.grpc`           | Node port for GRPC                                               | `9095`      |
| `compactor.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                      | `{}`        |
| `compactor.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin | `None`      |
| `compactor.service.clusterIP`                | Compactor service Cluster IP                                     | `""`        |
| `compactor.service.loadBalancerIP`           | Compactor service Load Balancer IP                               | `""`        |
| `compactor.service.loadBalancerSourceRanges` | Compactor service Load Balancer sources                          | `[]`        |
| `compactor.service.externalTrafficPolicy`    | Compactor service external traffic policy                        | `Cluster`   |
| `compactor.service.annotations`              | Additional custom annotations for Compactor service              | `{}`        |
| `compactor.service.extraPorts`               | Extra ports to expose in the Compactor service                   | `[]`        |
| `compactor.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                  | `false`     |
| `compactor.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled   | `1`         |
| `compactor.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable   | `""`        |


### Distributor Deployment Parameters

| Name                                                | Description                                                                                           | Value           |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | --------------- |
| `distributor.extraEnvVars`                          | Array with extra environment variables to add to distributor nodes                                    | `[]`            |
| `distributor.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for distributor nodes                            | `""`            |
| `distributor.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for distributor nodes                               | `""`            |
| `distributor.command`                               | Override default container command (useful when using custom images)                                  | `[]`            |
| `distributor.args`                                  | Override default container args (useful when using custom images)                                     | `[]`            |
| `distributor.extraArgs`                             | Add additional argsto the default container args (useful to override configuration)                   | `[]`            |
| `distributor.replicaCount`                          | Number of Compactor replicas to deploy                                                                | `1`             |
| `distributor.livenessProbe.enabled`                 | Enable livenessProbe on Compactor nodes                                                               | `true`          |
| `distributor.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                               | `60`            |
| `distributor.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                      | `10`            |
| `distributor.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                     | `1`             |
| `distributor.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                   | `3`             |
| `distributor.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                   | `1`             |
| `distributor.readinessProbe.enabled`                | Enable readinessProbe on Compactor nodes                                                              | `true`          |
| `distributor.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                              | `60`            |
| `distributor.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                     | `10`            |
| `distributor.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                    | `1`             |
| `distributor.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                  | `3`             |
| `distributor.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                  | `1`             |
| `distributor.startupProbe.enabled`                  | Enable startupProbe on Compactor containers                                                           | `false`         |
| `distributor.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                | `30`            |
| `distributor.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                       | `10`            |
| `distributor.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                      | `1`             |
| `distributor.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                    | `15`            |
| `distributor.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                    | `1`             |
| `distributor.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                   | `{}`            |
| `distributor.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                  | `{}`            |
| `distributor.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                    | `{}`            |
| `distributor.resources.limits`                      | The resources limits for the distributor containers                                                   | `{}`            |
| `distributor.resources.requests`                    | The requested resources for the distributor containers                                                | `{}`            |
| `distributor.podSecurityContext.enabled`            | Enabled Compactor pods' Security Context                                                              | `true`          |
| `distributor.podSecurityContext.fsGroup`            | Set Compactor pod's Security Context fsGroup                                                          | `1001`          |
| `distributor.containerSecurityContext.enabled`      | Enabled Compactor containers' Security Context                                                        | `true`          |
| `distributor.containerSecurityContext.runAsUser`    | Set Compactor containers' Security Context runAsUser                                                  | `1001`          |
| `distributor.containerSecurityContext.runAsNonRoot` | Set Compactor containers' Security Context runAsNonRoot                                               | `true`          |
| `distributor.lifecycleHooks`                        | for the distributor container(s) to automate configuration before or after startup                    | `{}`            |
| `distributor.hostAliases`                           | distributor pods host aliases                                                                         | `[]`            |
| `distributor.podLabels`                             | Extra labels for distributor pods                                                                     | `{}`            |
| `distributor.podAnnotations`                        | Annotations for distributor pods                                                                      | `{}`            |
| `distributor.podAffinityPreset`                     | Pod affinity preset. Ignored if `distributor.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `distributor.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `distributor.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `distributor.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `distributor.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `distributor.nodeAffinityPreset.key`                | Node label key to match. Ignored if `distributor.affinity` is set                                     | `""`            |
| `distributor.nodeAffinityPreset.values`             | Node label values to match. Ignored if `distributor.affinity` is set                                  | `[]`            |
| `distributor.affinity`                              | Affinity for Compactor pods assignment                                                                | `{}`            |
| `distributor.nodeSelector`                          | Node labels for Compactor pods assignment                                                             | `{}`            |
| `distributor.tolerations`                           | Tolerations for Compactor pods assignment                                                             | `[]`            |
| `distributor.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains       | `[]`            |
| `distributor.priorityClassName`                     | Compactor pods' priorityClassName                                                                     | `""`            |
| `distributor.schedulerName`                         | Kubernetes pod scheduler registry                                                                     | `""`            |
| `distributor.terminationGracePeriodSeconds`         | Seconds pod needs to terminate gracefully                                                             | `""`            |
| `distributor.updateStrategy.type`                   | Compactor statefulset strategy type                                                                   | `RollingUpdate` |
| `distributor.updateStrategy.rollingUpdate`          | Compactor statefulset rolling update configuration parameters                                         | `{}`            |
| `distributor.extraVolumes`                          | Optionally specify extra list of additional volumes for the Compactor pod(s)                          | `[]`            |
| `distributor.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Compactor container(s)               | `[]`            |
| `distributor.sidecars`                              | Add additional sidecar containers to the Compactor pod(s)                                             | `[]`            |
| `distributor.initContainers`                        | Add additional init containers to the Compactor pod(s)                                                | `[]`            |


### Compactor Traffic Exposure Parameters

| Name                                           | Description                                                      | Value       |
| ---------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `distributor.service.type`                     | Compactor service type                                           | `ClusterIP` |
| `distributor.service.ports.http-metrics`       | Compactor HTTP service port                                      | `8080`      |
| `distributor.service.ports.grpc`               | Compactor GRPC service port                                      | `9095`      |
| `distributor.service.nodePorts.http-metrics`   | Node port for HTTP                                               | `""`        |
| `distributor.service.nodePorts.grpc`           | Node port for GRPC                                               | `9095`      |
| `distributor.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                      | `{}`        |
| `distributor.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin | `None`      |
| `distributor.service.clusterIP`                | Compactor service Cluster IP                                     | `""`        |
| `distributor.service.loadBalancerIP`           | Compactor service Load Balancer IP                               | `""`        |
| `distributor.service.loadBalancerSourceRanges` | Compactor service Load Balancer sources                          | `[]`        |
| `distributor.service.externalTrafficPolicy`    | Compactor service external traffic policy                        | `Cluster`   |
| `distributor.service.annotations`              | Additional custom annotations for Compactor service              | `{}`        |
| `distributor.service.extraPorts`               | Extra ports to expose in the Compactor service                   | `[]`        |
| `distributor.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                  | `false`     |
| `distributor.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled   | `1`         |
| `distributor.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable   | `""`        |


### Gateway Deployment Parameters

| Name                                            | Description                                                                                           | Value                 |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------- | --------------------- |
| `gateway.enabled`                               | Enable Gateway deployment                                                                             | `true`                |
| `gateway.image.registry`                        | Nginx image registry                                                                                  | `docker.io`           |
| `gateway.image.repository`                      | Nginx image repository                                                                                | `bitnami/nginx`       |
| `gateway.image.tag`                             | Nginx image tag (immutable tags are recommended)                                                      | `1.23.3-debian-11-r8` |
| `gateway.image.digest`                          | Nginx image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                  |
| `gateway.image.pullPolicy`                      | Nginx image pull policy                                                                               | `IfNotPresent`        |
| `gateway.image.pullSecrets`                     | Nginx image pull secrets                                                                              | `[]`                  |
| `gateway.image.debug`                           | Enable debugging in the initialization process                                                        | `false`               |
| `gateway.extraEnvVars`                          | Array with extra environment variables to add to gateway nodes                                        | `[]`                  |
| `gateway.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for gateway nodes                                | `""`                  |
| `gateway.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for gateway nodes                                   | `""`                  |
| `gateway.command`                               | Override default container command (useful when using custom images)                                  | `[]`                  |
| `gateway.args`                                  | Override default container args (useful when using custom images)                                     | `[]`                  |
| `gateway.verboseLogging`                        | Show the gateway access_log                                                                           | `false`               |
| `gateway.replicaCount`                          | Number of Gateway replicas to deploy                                                                  | `1`                   |
| `gateway.auth.enabled`                          | Enable basic auth                                                                                     | `false`               |
| `gateway.auth.username`                         | Basic auth username                                                                                   | `user`                |
| `gateway.auth.password`                         | Basic auth password                                                                                   | `""`                  |
| `gateway.auth.existingSecret`                   | Name of a secret containing the Basic auth password                                                   | `""`                  |
| `gateway.livenessProbe.enabled`                 | Enable livenessProbe on Gateway nodes                                                                 | `true`                |
| `gateway.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                               | `10`                  |
| `gateway.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                      | `10`                  |
| `gateway.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                     | `1`                   |
| `gateway.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                   | `3`                   |
| `gateway.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                   | `1`                   |
| `gateway.readinessProbe.enabled`                | Enable readinessProbe on Gateway nodes                                                                | `true`                |
| `gateway.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                              | `10`                  |
| `gateway.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                     | `10`                  |
| `gateway.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                    | `1`                   |
| `gateway.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                  | `3`                   |
| `gateway.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                  | `1`                   |
| `gateway.startupProbe.enabled`                  | Enable startupProbe on Gateway containers                                                             | `false`               |
| `gateway.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                | `10`                  |
| `gateway.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                       | `10`                  |
| `gateway.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                      | `1`                   |
| `gateway.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                    | `15`                  |
| `gateway.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                    | `1`                   |
| `gateway.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                   | `{}`                  |
| `gateway.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                  | `{}`                  |
| `gateway.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                    | `{}`                  |
| `gateway.containerPorts.http`                   | Gateway HTTP port                                                                                     | `8080`                |
| `gateway.resources.limits`                      | The resources limits for the gateway containers                                                       | `{}`                  |
| `gateway.resources.requests`                    | The requested resources for the gateway containers                                                    | `{}`                  |
| `gateway.podSecurityContext.enabled`            | Enabled Gateway pods' Security Context                                                                | `true`                |
| `gateway.podSecurityContext.fsGroup`            | Set Gateway pod's Security Context fsGroup                                                            | `1001`                |
| `gateway.containerSecurityContext.enabled`      | Enabled Gateway containers' Security Context                                                          | `true`                |
| `gateway.containerSecurityContext.runAsUser`    | Set Gateway containers' Security Context runAsUser                                                    | `1001`                |
| `gateway.containerSecurityContext.runAsNonRoot` | Set Gateway containers' Security Context runAsNonRoot                                                 | `true`                |
| `gateway.lifecycleHooks`                        | for the gateway container(s) to automate configuration before or after startup                        | `{}`                  |
| `gateway.hostAliases`                           | gateway pods host aliases                                                                             | `[]`                  |
| `gateway.podLabels`                             | Extra labels for gateway pods                                                                         | `{}`                  |
| `gateway.podAnnotations`                        | Annotations for gateway pods                                                                          | `{}`                  |
| `gateway.podAffinityPreset`                     | Pod affinity preset. Ignored if `gateway.affinity` is set. Allowed values: `soft` or `hard`           | `""`                  |
| `gateway.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `gateway.affinity` is set. Allowed values: `soft` or `hard`      | `soft`                |
| `gateway.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `gateway.affinity` is set. Allowed values: `soft` or `hard`     | `""`                  |
| `gateway.nodeAffinityPreset.key`                | Node label key to match. Ignored if `gateway.affinity` is set                                         | `""`                  |
| `gateway.nodeAffinityPreset.values`             | Node label values to match. Ignored if `gateway.affinity` is set                                      | `[]`                  |
| `gateway.affinity`                              | Affinity for Gateway pods assignment                                                                  | `{}`                  |
| `gateway.nodeSelector`                          | Node labels for Gateway pods assignment                                                               | `{}`                  |
| `gateway.tolerations`                           | Tolerations for Gateway pods assignment                                                               | `[]`                  |
| `gateway.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains       | `[]`                  |
| `gateway.priorityClassName`                     | Gateway pods' priorityClassName                                                                       | `""`                  |
| `gateway.schedulerName`                         | Kubernetes pod scheduler registry                                                                     | `""`                  |
| `gateway.updateStrategy.type`                   | Gateway statefulset strategy type                                                                     | `RollingUpdate`       |
| `gateway.updateStrategy.rollingUpdate`          | Gateway statefulset rolling update configuration parameters                                           | `{}`                  |
| `gateway.extraVolumes`                          | Optionally specify extra list of additional volumes for the Gateway pod(s)                            | `[]`                  |
| `gateway.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Gateway container(s)                 | `[]`                  |
| `gateway.sidecars`                              | Add additional sidecar containers to the Gateway pod(s)                                               | `[]`                  |
| `gateway.initContainers`                        | Add additional init containers to the Gateway pod(s)                                                  | `[]`                  |


### Gateway Traffic Exposure Parameters

| Name                                       | Description                                                                                                                      | Value                    |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `gateway.service.type`                     | Gateway service type                                                                                                             | `ClusterIP`              |
| `gateway.service.ports.http`               | Gateway HTTP service port                                                                                                        | `80`                     |
| `gateway.service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `gateway.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `gateway.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `gateway.service.clusterIP`                | Gateway service Cluster IP                                                                                                       | `""`                     |
| `gateway.service.loadBalancerIP`           | Gateway service Load Balancer IP                                                                                                 | `""`                     |
| `gateway.service.loadBalancerSourceRanges` | Gateway service Load Balancer sources                                                                                            | `[]`                     |
| `gateway.service.externalTrafficPolicy`    | Gateway service external traffic policy                                                                                          | `Cluster`                |
| `gateway.service.annotations`              | Additional custom annotations for Gateway service                                                                                | `{}`                     |
| `gateway.service.extraPorts`               | Extra ports to expose in the Gateway service                                                                                     | `[]`                     |
| `gateway.ingress.enabled`                  | Enable ingress record generation for Loki Gateway                                                                                | `false`                  |
| `gateway.ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `gateway.ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `gateway.ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `gateway.ingress.hostname`                 | Default host for the ingress record                                                                                              | `grafana-mimir.local`    |
| `gateway.ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `gateway.ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `gateway.ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `gateway.ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `gateway.ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `gateway.ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `gateway.ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `gateway.ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |


### Ingester Deployment Parameters

| Name                                             | Description                                                                                        | Value               |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | ------------------- |
| `ingester.extraEnvVars`                          | Array with extra environment variables to add to ingester nodes                                    | `[]`                |
| `ingester.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for ingester nodes                            | `""`                |
| `ingester.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for ingester nodes                               | `""`                |
| `ingester.command`                               | Override default container command (useful when using custom images)                               | `[]`                |
| `ingester.args`                                  | Override default container args (useful when using custom images)                                  | `[]`                |
| `ingester.extraArgs`                             | Add additional argsto the default container args (useful to override configuration)                | `[]`                |
| `ingester.replicaCount`                          | Number of Compactor replicas to deploy                                                             | `1`                 |
| `ingester.podManagementPolicy`                   | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join | `OrderedReady`      |
| `ingester.livenessProbe.enabled`                 | Enable livenessProbe on Compactor nodes                                                            | `true`              |
| `ingester.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                |
| `ingester.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `10`                |
| `ingester.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `1`                 |
| `ingester.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `3`                 |
| `ingester.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `1`                 |
| `ingester.readinessProbe.enabled`                | Enable readinessProbe on Compactor nodes                                                           | `true`              |
| `ingester.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `60`                |
| `ingester.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                |
| `ingester.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `1`                 |
| `ingester.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `3`                 |
| `ingester.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `1`                 |
| `ingester.startupProbe.enabled`                  | Enable startupProbe on Compactor containers                                                        | `false`             |
| `ingester.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `30`                |
| `ingester.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                |
| `ingester.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `1`                 |
| `ingester.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `15`                |
| `ingester.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `1`                 |
| `ingester.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                |
| `ingester.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                |
| `ingester.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                |
| `ingester.resources.limits`                      | The resources limits for the ingester containers                                                   | `{}`                |
| `ingester.resources.requests`                    | The requested resources for the ingester containers                                                | `{}`                |
| `ingester.podSecurityContext.enabled`            | Enabled Compactor pods' Security Context                                                           | `true`              |
| `ingester.podSecurityContext.fsGroup`            | Set Compactor pod's Security Context fsGroup                                                       | `1001`              |
| `ingester.containerSecurityContext.enabled`      | Enabled Compactor containers' Security Context                                                     | `true`              |
| `ingester.containerSecurityContext.runAsUser`    | Set Compactor containers' Security Context runAsUser                                               | `1001`              |
| `ingester.containerSecurityContext.runAsNonRoot` | Set Compactor containers' Security Context runAsNonRoot                                            | `true`              |
| `ingester.lifecycleHooks`                        | for the ingester container(s) to automate configuration before or after startup                    | `{}`                |
| `ingester.hostAliases`                           | ingester pods host aliases                                                                         | `[]`                |
| `ingester.podLabels`                             | Extra labels for ingester pods                                                                     | `{}`                |
| `ingester.podAnnotations`                        | Annotations for ingester pods                                                                      | `{}`                |
| `ingester.podAffinityPreset`                     | Pod affinity preset. Ignored if `ingester.affinity` is set. Allowed values: `soft` or `hard`       | `""`                |
| `ingester.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `ingester.affinity` is set. Allowed values: `soft` or `hard`  | `soft`              |
| `ingester.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `ingester.affinity` is set. Allowed values: `soft` or `hard` | `""`                |
| `ingester.nodeAffinityPreset.key`                | Node label key to match. Ignored if `ingester.affinity` is set                                     | `""`                |
| `ingester.nodeAffinityPreset.values`             | Node label values to match. Ignored if `ingester.affinity` is set                                  | `[]`                |
| `ingester.affinity`                              | Affinity for Compactor pods assignment                                                             | `{}`                |
| `ingester.nodeSelector`                          | Node labels for Compactor pods assignment                                                          | `{}`                |
| `ingester.tolerations`                           | Tolerations for Compactor pods assignment                                                          | `[]`                |
| `ingester.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains    | `[]`                |
| `ingester.priorityClassName`                     | Compactor pods' priorityClassName                                                                  | `""`                |
| `ingester.schedulerName`                         | Kubernetes pod scheduler registry                                                                  | `""`                |
| `ingester.terminationGracePeriodSeconds`         | Seconds pod needs to terminate gracefully                                                          | `""`                |
| `ingester.updateStrategy.type`                   | Compactor statefulset strategy type                                                                | `RollingUpdate`     |
| `ingester.updateStrategy.rollingUpdate`          | Compactor statefulset rolling update configuration parameters                                      | `{}`                |
| `ingester.extraVolumes`                          | Optionally specify extra list of additional volumes for the Compactor pod(s)                       | `[]`                |
| `ingester.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Compactor container(s)            | `[]`                |
| `ingester.sidecars`                              | Add additional sidecar containers to the Compactor pod(s)                                          | `[]`                |
| `ingester.initContainers`                        | Add additional init containers to the Compactor pod(s)                                             | `[]`                |
| `ingester.persistence.enabled`                   | Enable persistence in Compactor instances                                                          | `true`              |
| `ingester.persistence.existingClaim`             | Name of an existing PVC to use                                                                     | `""`                |
| `ingester.persistence.storageClass`              | PVC Storage Class for Memcached data volume                                                        | `""`                |
| `ingester.persistence.accessModes`               | PVC Access modes                                                                                   | `["ReadWriteOnce"]` |
| `ingester.persistence.size`                      | PVC Storage Request for Memcached data volume                                                      | `8Gi`               |
| `ingester.persistence.annotations`               | Additional PVC annotations                                                                         | `{}`                |
| `ingester.persistence.selector`                  | Selector to match an existing Persistent Volume for Compactor's data PVC                           | `{}`                |
| `ingester.persistence.dataSource`                | PVC data source                                                                                    | `{}`                |


### Compactor Traffic Exposure Parameters

| Name                                        | Description                                                      | Value       |
| ------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `ingester.service.type`                     | Compactor service type                                           | `ClusterIP` |
| `ingester.service.ports.http-metrics`       | Compactor HTTP service port                                      | `8080`      |
| `ingester.service.ports.grpc`               | Compactor GRPC service port                                      | `9095`      |
| `ingester.service.nodePorts.http-metrics`   | Node port for HTTP                                               | `""`        |
| `ingester.service.nodePorts.grpc`           | Node port for GRPC                                               | `9095`      |
| `ingester.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                      | `{}`        |
| `ingester.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin | `None`      |
| `ingester.service.clusterIP`                | Compactor service Cluster IP                                     | `""`        |
| `ingester.service.loadBalancerIP`           | Compactor service Load Balancer IP                               | `""`        |
| `ingester.service.loadBalancerSourceRanges` | Compactor service Load Balancer sources                          | `[]`        |
| `ingester.service.externalTrafficPolicy`    | Compactor service external traffic policy                        | `Cluster`   |
| `ingester.service.annotations`              | Additional custom annotations for Compactor service              | `{}`        |
| `ingester.service.extraPorts`               | Extra ports to expose in the Compactor service                   | `[]`        |
| `ingester.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                  | `false`     |
| `ingester.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled   | `1`         |
| `ingester.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable   | `""`        |


### Querier Deployment Parameters

| Name                                            | Description                                                                                       | Value           |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------- | --------------- |
| `querier.extraEnvVars`                          | Array with extra environment variables to add to querier nodes                                    | `[]`            |
| `querier.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for querier nodes                            | `""`            |
| `querier.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for querier nodes                               | `""`            |
| `querier.command`                               | Override default container command (useful when using custom images)                              | `[]`            |
| `querier.args`                                  | Override default container args (useful when using custom images)                                 | `[]`            |
| `querier.extraArgs`                             | Add additional argsto the default container args (useful to override configuration)               | `[]`            |
| `querier.replicaCount`                          | Number of Compactor replicas to deploy                                                            | `1`             |
| `querier.livenessProbe.enabled`                 | Enable livenessProbe on Compactor nodes                                                           | `true`          |
| `querier.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                           | `60`            |
| `querier.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                  | `10`            |
| `querier.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                 | `1`             |
| `querier.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                               | `3`             |
| `querier.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                               | `1`             |
| `querier.readinessProbe.enabled`                | Enable readinessProbe on Compactor nodes                                                          | `true`          |
| `querier.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                          | `60`            |
| `querier.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                 | `10`            |
| `querier.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                | `1`             |
| `querier.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                              | `3`             |
| `querier.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                              | `1`             |
| `querier.startupProbe.enabled`                  | Enable startupProbe on Compactor containers                                                       | `false`         |
| `querier.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                            | `30`            |
| `querier.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                   | `10`            |
| `querier.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                  | `1`             |
| `querier.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                | `15`            |
| `querier.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                | `1`             |
| `querier.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                               | `{}`            |
| `querier.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                              | `{}`            |
| `querier.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                | `{}`            |
| `querier.resources.limits`                      | The resources limits for the querier containers                                                   | `{}`            |
| `querier.resources.requests`                    | The requested resources for the querier containers                                                | `{}`            |
| `querier.podSecurityContext.enabled`            | Enabled Compactor pods' Security Context                                                          | `true`          |
| `querier.podSecurityContext.fsGroup`            | Set Compactor pod's Security Context fsGroup                                                      | `1001`          |
| `querier.containerSecurityContext.enabled`      | Enabled Compactor containers' Security Context                                                    | `true`          |
| `querier.containerSecurityContext.runAsUser`    | Set Compactor containers' Security Context runAsUser                                              | `1001`          |
| `querier.containerSecurityContext.runAsNonRoot` | Set Compactor containers' Security Context runAsNonRoot                                           | `true`          |
| `querier.lifecycleHooks`                        | for the ingester container(s) to automate configuration before or after startup                   | `{}`            |
| `querier.hostAliases`                           | ingester pods host aliases                                                                        | `[]`            |
| `querier.podLabels`                             | Extra labels for ingester pods                                                                    | `{}`            |
| `querier.podAnnotations`                        | Annotations for ingester pods                                                                     | `{}`            |
| `querier.podAffinityPreset`                     | Pod affinity preset. Ignored if `querier.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `querier.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `querier.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `querier.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `querier.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `querier.nodeAffinityPreset.key`                | Node label key to match. Ignored if `querier.affinity` is set                                     | `""`            |
| `querier.nodeAffinityPreset.values`             | Node label values to match. Ignored if `querier.affinity` is set                                  | `[]`            |
| `querier.affinity`                              | Affinity for Compactor pods assignment                                                            | `{}`            |
| `querier.nodeSelector`                          | Node labels for Compactor pods assignment                                                         | `{}`            |
| `querier.tolerations`                           | Tolerations for Compactor pods assignment                                                         | `[]`            |
| `querier.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains   | `[]`            |
| `querier.priorityClassName`                     | Compactor pods' priorityClassName                                                                 | `""`            |
| `querier.schedulerName`                         | Kubernetes pod scheduler registry                                                                 | `""`            |
| `querier.terminationGracePeriodSeconds`         | Seconds pod needs to terminate gracefully                                                         | `""`            |
| `querier.updateStrategy.type`                   | Compactor statefulset strategy type                                                               | `RollingUpdate` |
| `querier.updateStrategy.rollingUpdate`          | Compactor statefulset rolling update configuration parameters                                     | `{}`            |
| `querier.extraVolumes`                          | Optionally specify extra list of additional volumes for the Compactor pod(s)                      | `[]`            |
| `querier.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Compactor container(s)           | `[]`            |
| `querier.sidecars`                              | Add additional sidecar containers to the Compactor pod(s)                                         | `[]`            |
| `querier.initContainers`                        | Add additional init containers to the Compactor pod(s)                                            | `[]`            |


### Compactor Traffic Exposure Parameters

| Name                                       | Description                                                      | Value       |
| ------------------------------------------ | ---------------------------------------------------------------- | ----------- |
| `querier.service.type`                     | Compactor service type                                           | `ClusterIP` |
| `querier.service.ports.http-metrics`       | Compactor HTTP service port                                      | `8080`      |
| `querier.service.ports.grpc`               | Compactor GRPC service port                                      | `9095`      |
| `querier.service.nodePorts.http-metrics`   | Node port for HTTP                                               | `""`        |
| `querier.service.nodePorts.grpc`           | Node port for GRPC                                               | `9095`      |
| `querier.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                      | `{}`        |
| `querier.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin | `None`      |
| `querier.service.clusterIP`                | Compactor service Cluster IP                                     | `""`        |
| `querier.service.loadBalancerIP`           | Compactor service Load Balancer IP                               | `""`        |
| `querier.service.loadBalancerSourceRanges` | Compactor service Load Balancer sources                          | `[]`        |
| `querier.service.externalTrafficPolicy`    | Compactor service external traffic policy                        | `Cluster`   |
| `querier.service.annotations`              | Additional custom annotations for Compactor service              | `{}`        |
| `querier.service.extraPorts`               | Extra ports to expose in the Compactor service                   | `[]`        |
| `querier.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                  | `false`     |
| `querier.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled   | `1`         |
| `querier.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable   | `""`        |


### Query Frontend Deployment Parameters

| Name                                                   | Description                                                                                              | Value           |
| ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- | --------------- |
| `query-frontend.enabled`                               | Enable Distributor deployment                                                                            | `true`          |
| `query-frontend.extraEnvVars`                          | Array with extra environment variables to add to ingester nodes                                          | `[]`            |
| `query-frontend.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for ingester nodes                                  | `""`            |
| `query-frontend.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for ingester nodes                                     | `""`            |
| `query-frontend.command`                               | Override default container command (useful when using custom images)                                     | `[]`            |
| `query-frontend.args`                                  | Override default container args (useful when using custom images)                                        | `[]`            |
| `query-frontend.extraArgs`                             | Add additional argsto the default container args (useful to override configuration)                      | `[]`            |
| `query-frontend.replicaCount`                          | Number of Compactor replicas to deploy                                                                   | `1`             |
| `query-frontend.livenessProbe.enabled`                 | Enable livenessProbe on Compactor nodes                                                                  | `true`          |
| `query-frontend.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                  | `60`            |
| `query-frontend.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                         | `10`            |
| `query-frontend.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                        | `1`             |
| `query-frontend.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                      | `3`             |
| `query-frontend.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                      | `1`             |
| `query-frontend.readinessProbe.enabled`                | Enable readinessProbe on Compactor nodes                                                                 | `true`          |
| `query-frontend.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                 | `60`            |
| `query-frontend.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                        | `10`            |
| `query-frontend.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                       | `1`             |
| `query-frontend.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                     | `3`             |
| `query-frontend.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                     | `1`             |
| `query-frontend.startupProbe.enabled`                  | Enable startupProbe on Compactor containers                                                              | `false`         |
| `query-frontend.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                   | `30`            |
| `query-frontend.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                          | `10`            |
| `query-frontend.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                         | `1`             |
| `query-frontend.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                       | `15`            |
| `query-frontend.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                       | `1`             |
| `query-frontend.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                      | `{}`            |
| `query-frontend.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                     | `{}`            |
| `query-frontend.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                       | `{}`            |
| `query-frontend.resources.limits`                      | The resources limits for the ingester containers                                                         | `{}`            |
| `query-frontend.resources.requests`                    | The requested resources for the ingester containers                                                      | `{}`            |
| `query-frontend.podSecurityContext.enabled`            | Enabled Compactor pods' Security Context                                                                 | `true`          |
| `query-frontend.podSecurityContext.fsGroup`            | Set Compactor pod's Security Context fsGroup                                                             | `1001`          |
| `query-frontend.containerSecurityContext.enabled`      | Enabled Compactor containers' Security Context                                                           | `true`          |
| `query-frontend.containerSecurityContext.runAsUser`    | Set Compactor containers' Security Context runAsUser                                                     | `1001`          |
| `query-frontend.containerSecurityContext.runAsNonRoot` | Set Compactor containers' Security Context runAsNonRoot                                                  | `true`          |
| `query-frontend.lifecycleHooks`                        | for the ingester container(s) to automate configuration before or after startup                          | `{}`            |
| `query-frontend.hostAliases`                           | ingester pods host aliases                                                                               | `[]`            |
| `query-frontend.podLabels`                             | Extra labels for ingester pods                                                                           | `{}`            |
| `query-frontend.podAnnotations`                        | Annotations for ingester pods                                                                            | `{}`            |
| `query-frontend.podAffinityPreset`                     | Pod affinity preset. Ignored if `query-frontend.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `query-frontend.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `query-frontend.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `query-frontend.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `query-frontend.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `query-frontend.nodeAffinityPreset.key`                | Node label key to match. Ignored if `query-frontend.affinity` is set                                     | `""`            |
| `query-frontend.nodeAffinityPreset.values`             | Node label values to match. Ignored if `query-frontend.affinity` is set                                  | `[]`            |
| `query-frontend.affinity`                              | Affinity for Compactor pods assignment                                                                   | `{}`            |
| `query-frontend.nodeSelector`                          | Node labels for Compactor pods assignment                                                                | `{}`            |
| `query-frontend.tolerations`                           | Tolerations for Compactor pods assignment                                                                | `[]`            |
| `query-frontend.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains          | `[]`            |
| `query-frontend.priorityClassName`                     | Compactor pods' priorityClassName                                                                        | `""`            |
| `query-frontend.schedulerName`                         | Kubernetes pod scheduler registry                                                                        | `""`            |
| `query-frontend.terminationGracePeriodSeconds`         | Seconds pod needs to terminate gracefully                                                                | `""`            |
| `query-frontend.updateStrategy.type`                   | Compactor statefulset strategy type                                                                      | `RollingUpdate` |
| `query-frontend.updateStrategy.rollingUpdate`          | Compactor statefulset rolling update configuration parameters                                            | `{}`            |
| `query-frontend.extraVolumes`                          | Optionally specify extra list of additional volumes for the Compactor pod(s)                             | `[]`            |
| `query-frontend.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Compactor container(s)                  | `[]`            |
| `query-frontend.sidecars`                              | Add additional sidecar containers to the Compactor pod(s)                                                | `[]`            |
| `query-frontend.initContainers`                        | Add additional init containers to the Compactor pod(s)                                                   | `[]`            |


### Compactor Traffic Exposure Parameters

| Name                                              | Description                                                      | Value       |
| ------------------------------------------------- | ---------------------------------------------------------------- | ----------- |
| `query-frontend.service.type`                     | Compactor service type                                           | `ClusterIP` |
| `query-frontend.service.ports.http-metrics`       | Compactor HTTP service port                                      | `8080`      |
| `query-frontend.service.ports.grpc`               | Compactor GRPC service port                                      | `9095`      |
| `query-frontend.service.nodePorts.http-metrics`   | Node port for HTTP                                               | `""`        |
| `query-frontend.service.nodePorts.grpc`           | Node port for GRPC                                               | `9095`      |
| `query-frontend.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                      | `{}`        |
| `query-frontend.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin | `None`      |
| `query-frontend.service.clusterIP`                | Compactor service Cluster IP                                     | `""`        |
| `query-frontend.service.loadBalancerIP`           | Compactor service Load Balancer IP                               | `""`        |
| `query-frontend.service.loadBalancerSourceRanges` | Compactor service Load Balancer sources                          | `[]`        |
| `query-frontend.service.externalTrafficPolicy`    | Compactor service external traffic policy                        | `Cluster`   |
| `query-frontend.service.annotations`              | Additional custom annotations for Compactor service              | `{}`        |
| `query-frontend.service.extraPorts`               | Extra ports to expose in the Compactor service                   | `[]`        |
| `query-frontend.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                  | `false`     |
| `query-frontend.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled   | `1`         |
| `query-frontend.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable   | `""`        |


### Store Gateway Deployment Parameters

| Name                                                  | Description                                                                                             | Value               |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `store-gateway.enabled`                               | Enable Store Gateway deployment                                                                         | `true`              |
| `store-gateway.extraEnvVars`                          | Array with extra environment variables to add to ingester nodes                                         | `[]`                |
| `store-gateway.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for ingester nodes                                 | `""`                |
| `store-gateway.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for ingester nodes                                    | `""`                |
| `store-gateway.command`                               | Override default container command (useful when using custom images)                                    | `[]`                |
| `store-gateway.args`                                  | Override default container args (useful when using custom images)                                       | `[]`                |
| `store-gateway.extraArgs`                             | Add additional argsto the default container args (useful to override configuration)                     | `[]`                |
| `store-gateway.replicaCount`                          | Number of Compactor replicas to deploy                                                                  | `1`                 |
| `store-gateway.podManagementPolicy`                   | Statefulset Pod management policy, it needs to be Parallel to be able to complete the cluster join      | `OrderedReady`      |
| `store-gateway.livenessProbe.enabled`                 | Enable livenessProbe on Compactor nodes                                                                 | `true`              |
| `store-gateway.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                 | `60`                |
| `store-gateway.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                        | `10`                |
| `store-gateway.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                       | `1`                 |
| `store-gateway.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                     | `3`                 |
| `store-gateway.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                     | `1`                 |
| `store-gateway.readinessProbe.enabled`                | Enable readinessProbe on Compactor nodes                                                                | `true`              |
| `store-gateway.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                | `60`                |
| `store-gateway.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                       | `10`                |
| `store-gateway.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                      | `1`                 |
| `store-gateway.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                    | `3`                 |
| `store-gateway.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                    | `1`                 |
| `store-gateway.startupProbe.enabled`                  | Enable startupProbe on Compactor containers                                                             | `false`             |
| `store-gateway.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                  | `30`                |
| `store-gateway.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                         | `10`                |
| `store-gateway.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                        | `1`                 |
| `store-gateway.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                      | `15`                |
| `store-gateway.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                      | `1`                 |
| `store-gateway.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                     | `{}`                |
| `store-gateway.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                    | `{}`                |
| `store-gateway.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                      | `{}`                |
| `store-gateway.resources.limits`                      | The resources limits for the ingester containers                                                        | `{}`                |
| `store-gateway.resources.requests`                    | The requested resources for the ingester containers                                                     | `{}`                |
| `store-gateway.podSecurityContext.enabled`            | Enabled Compactor pods' Security Context                                                                | `true`              |
| `store-gateway.podSecurityContext.fsGroup`            | Set Compactor pod's Security Context fsGroup                                                            | `1001`              |
| `store-gateway.containerSecurityContext.enabled`      | Enabled Compactor containers' Security Context                                                          | `true`              |
| `store-gateway.containerSecurityContext.runAsUser`    | Set Compactor containers' Security Context runAsUser                                                    | `1001`              |
| `store-gateway.containerSecurityContext.runAsNonRoot` | Set Compactor containers' Security Context runAsNonRoot                                                 | `true`              |
| `store-gateway.lifecycleHooks`                        | for the ingester container(s) to automate configuration before or after startup                         | `{}`                |
| `store-gateway.hostAliases`                           | ingester pods host aliases                                                                              | `[]`                |
| `store-gateway.podLabels`                             | Extra labels for ingester pods                                                                          | `{}`                |
| `store-gateway.podAnnotations`                        | Annotations for ingester pods                                                                           | `{}`                |
| `store-gateway.podAffinityPreset`                     | Pod affinity preset. Ignored if `store-gateway.affinity` is set. Allowed values: `soft` or `hard`       | `""`                |
| `store-gateway.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `store-gateway.affinity` is set. Allowed values: `soft` or `hard`  | `soft`              |
| `store-gateway.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `store-gateway.affinity` is set. Allowed values: `soft` or `hard` | `""`                |
| `store-gateway.nodeAffinityPreset.key`                | Node label key to match. Ignored if `store-gateway.affinity` is set                                     | `""`                |
| `store-gateway.nodeAffinityPreset.values`             | Node label values to match. Ignored if `store-gateway.affinity` is set                                  | `[]`                |
| `store-gateway.affinity`                              | Affinity for Compactor pods assignment                                                                  | `{}`                |
| `store-gateway.nodeSelector`                          | Node labels for Compactor pods assignment                                                               | `{}`                |
| `store-gateway.tolerations`                           | Tolerations for Compactor pods assignment                                                               | `[]`                |
| `store-gateway.topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains         | `[]`                |
| `store-gateway.priorityClassName`                     | Compactor pods' priorityClassName                                                                       | `""`                |
| `store-gateway.schedulerName`                         | Kubernetes pod scheduler registry                                                                       | `""`                |
| `store-gateway.terminationGracePeriodSeconds`         | Seconds pod needs to terminate gracefully                                                               | `""`                |
| `store-gateway.updateStrategy.type`                   | Compactor statefulset strategy type                                                                     | `RollingUpdate`     |
| `store-gateway.updateStrategy.rollingUpdate`          | Compactor statefulset rolling update configuration parameters                                           | `{}`                |
| `store-gateway.extraVolumes`                          | Optionally specify extra list of additional volumes for the Compactor pod(s)                            | `[]`                |
| `store-gateway.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the Compactor container(s)                 | `[]`                |
| `store-gateway.sidecars`                              | Add additional sidecar containers to the Compactor pod(s)                                               | `[]`                |
| `store-gateway.initContainers`                        | Add additional init containers to the Compactor pod(s)                                                  | `[]`                |
| `store-gateway.persistence.enabled`                   | Enable persistence in Compactor instances                                                               | `true`              |
| `store-gateway.persistence.existingClaim`             | Name of an existing PVC to use                                                                          | `""`                |
| `store-gateway.persistence.storageClass`              | PVC Storage Class for Memcached data volume                                                             | `""`                |
| `store-gateway.persistence.accessModes`               | PVC Access modes                                                                                        | `["ReadWriteOnce"]` |
| `store-gateway.persistence.size`                      | PVC Storage Request for Memcached data volume                                                           | `8Gi`               |
| `store-gateway.persistence.annotations`               | Additional PVC annotations                                                                              | `{}`                |
| `store-gateway.persistence.selector`                  | Selector to match an existing Persistent Volume for Compactor's data PVC                                | `{}`                |
| `store-gateway.persistence.dataSource`                | PVC data source                                                                                         | `{}`                |


### Compactor Traffic Exposure Parameters

| Name                                             | Description                                                      | Value       |
| ------------------------------------------------ | ---------------------------------------------------------------- | ----------- |
| `store-gateway.service.type`                     | Compactor service type                                           | `ClusterIP` |
| `store-gateway.service.ports.http-metrics`       | Compactor HTTP service port                                      | `8080`      |
| `store-gateway.service.ports.grpc`               | Compactor GRPC service port                                      | `9095`      |
| `store-gateway.service.nodePorts.http-metrics`   | Node port for HTTP                                               | `""`        |
| `store-gateway.service.nodePorts.grpc`           | Node port for GRPC                                               | `9095`      |
| `store-gateway.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                      | `{}`        |
| `store-gateway.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin | `None`      |
| `store-gateway.service.clusterIP`                | Compactor service Cluster IP                                     | `""`        |
| `store-gateway.service.loadBalancerIP`           | Compactor service Load Balancer IP                               | `""`        |
| `store-gateway.service.loadBalancerSourceRanges` | Compactor service Load Balancer sources                          | `[]`        |
| `store-gateway.service.externalTrafficPolicy`    | Compactor service external traffic policy                        | `Cluster`   |
| `store-gateway.service.annotations`              | Additional custom annotations for Compactor service              | `{}`        |
| `store-gateway.service.extraPorts`               | Extra ports to expose in the Compactor service                   | `[]`        |
| `store-gateway.pdb.create`                       | Enable/disable a Pod Disruption Budget creation                  | `false`     |
| `store-gateway.pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled   | `1`         |
| `store-gateway.pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable   | `""`        |


### Persistence Parameters

| Name                        | Description                                                                                             | Value                 |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | --------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `true`                |
| `persistence.mountPath`     | Path to mount the volume at.                                                                            | `/bitnami/mimir/data` |
| `persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                  |
| `persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                  |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                  |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]`   |
| `persistence.size`          | Size of data volume                                                                                     | `8Gi`                 |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                  |
| `persistence.selector`      | Selector to match an existing Persistent Volume for WordPress data PVC                                  | `{}`                  |
| `persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                  |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                              |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ---------------------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                            |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`                        |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell`            |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `11-debian-11-r%%IMAGE_REVISION%%` |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `IfNotPresent`                     |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                               |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                               |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                               |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                                |


### Other Parameters

| Name                                          | Description                                                                                            | Value   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                     | `false` |
| `rbac.rules`                                  | Custom RBAC rules to set                                                                               | `[]`    |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                   | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                 | `""`    |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)                                       | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                         | `true`  |
| `metrics.enabled`                             | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`            | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.annotations`          | Additional custom annotations for the ServiceMonitor                                                   | `{}`    |
| `metrics.serviceMonitor.labels`               | Extra labels for the ServiceMonitor                                                                    | `{}`    |
| `metrics.serviceMonitor.jobLabel`             | The name of the label on the target service to use as the job name in Prometheus                       | `""`    |
| `metrics.serviceMonitor.honorLabels`          | honorLabels chooses the metric's labels on collisions with target labels                               | `false` |
| `metrics.serviceMonitor.interval`             | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.serviceMonitor.metricRelabelings`    | Specify additional relabeling of metrics                                                               | `[]`    |
| `metrics.serviceMonitor.relabelings`          | Specify general relabeling                                                                             | `[]`    |
| `metrics.serviceMonitor.selector`             | Prometheus instance selector labels                                                                    | `{}`    |


### MinIO&reg; chart parameters

| Name                               | Description                                                                                                                       | Value                                                  |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `minio`                            | For full list of MinIO&reg; values configurations please refere [here](https://github.com/bitnami/charts/tree/main/bitnami/minio) |                                                        |
| `minio.enabled`                    | Enable/disable MinIO&reg; chart installation                                                                                      | `true`                                                 |
| `minio.auth.rootUser`              | MinIO&reg; root username                                                                                                          | `admin`                                                |
| `minio.auth.rootPassword`          | Password for MinIO&reg; root user                                                                                                 | `""`                                                   |
| `minio.auth.existingSecret`        | Name of an existing secret containing the MinIO&reg; credentials                                                                  | `""`                                                   |
| `minio.defaultBuckets`             | Comma, semi-colon or space separated list of MinIO&reg; buckets to create                                                         | `s3storage`                                            |
| `minio.provisioning.enabled`       | Enable/disable MinIO&reg; provisioning job                                                                                        | `true`                                                 |
| `minio.provisioning.extraCommands` | Extra commands to run on MinIO&reg; provisioning job                                                                              | `["mc anonymous set download provisioning/s3storage"]` |
| `minio.tls.enabled`                | Enable/disable MinIO&reg; TLS support                                                                                             | `false`                                                |
| `minio.service.type`               | MinIO&reg; service type                                                                                                           | `ClusterIP`                                            |
| `minio.service.loadBalancerIP`     | MinIO&reg; service LoadBalancer IP                                                                                                | `""`                                                   |
| `minio.service.ports.api`          | MinIO&reg; service port                                                                                                           | `80`                                                   |


See https://github.com/bitnami-labs/readme-generator-for-helm to create the table

The above parameters map to the env variables defined in [bitnami/grafana-mimir](https://github.com/bitnami/containers/tree/main/bitnami/grafana-mimir). For more information please refer to the [bitnami/grafana-mimir](https://github.com/bitnami/containers/tree/main/bitnami/grafana-mimir) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set mimir.image.debug=true \
  my-repo/grafana-mimir
```

The above command enables the Jaeger GRPC traces.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml my-repo/grafana-mimir
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.
### Mimir configuration

The mimir configuration file `mimir.yaml` is shared across the different components: `distributor`, `compactor`, `ingester`, `querier`, `query-frontend` and `store-gateway`. This is set in the `mimir.configuration` value. Check the official [Mimir Mimir documentation](https://grafana.com/docs/mimir/latest/operators-guide/configure/reference-configuration-parameters) for the list of possible configurations.

## Persistence

### Limitation

This chart does not function fully when using local filesystem as a persistence store. When using a local filesystem as a persistence store, querying will not be possible (or limited to the ingesters' in-memory caches). For a fully functional deployment of this helm chart, an object storage backend is required.

### Data

The [Bitnami grafana-mimir](https://github.com/bitnami/containers/tree/main/bitnami/grafana-mimir) image stores the grafana-mimir `ingester` data at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property inside each of the subsections: `distributor`, `compactor`, `ingester`, `querier`, `queryFrontend` and `vulture`.

```yaml
compactor:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

distributor:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

ingester:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

querier:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

queryFrontend:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error

vulture:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside each of the subsections: `distributor`, `compactor`, `ingester`, `querier`, `queryFrontend` and `vulture`.

### External cache support

You may want to have Grafana Mimir connect to an external Memcached rather than installing one inside your cluster. Typical reasons for this are to use a managed cache service, or to share a common cache server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalMemcached` parameter](#parameters). You should also disable the Memcached installation with the `memcached.enabled` option. Here is an example:

```console
memcached.enabled=false
externalMemcached.host=myexternalhost
externalMemcached.port=11211
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

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
limitations under the License.