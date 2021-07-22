# grafana-tempo

[Grafana Tempo](https://github.com/grafana/tempo) is a an open source high-scale distributed tracing backend. It only requires object storage and supports integration with Grafana, Prometheus and Loki.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/grafana-tempo
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Grafana Tempo](https://github.com/grafana/tempo) Deployment in a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/infrastructure/grafana-tempo/get-started/understand-default-configuration/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/grafana-tempo
```

The command deploys grafana-tempo on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `global.imageRegistry`    | Global Docker image registry                    | `nil` |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `nil` |


### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `nil`           |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |


### Common Grafana Tempo Parameters

| Name                                   | Description                                                | Value                         |
| -------------------------------------- | ---------------------------------------------------------- | ----------------------------- |
| `tempo.image.registry`                 | Grafana Tempo image registry                               | `docker.io`                   |
| `tempo.image.repository`               | Grafana Tempo image repository                             | `bitnami/grafana-tempo`       |
| `tempo.image.tag`                      | Grafana Tempo image tag (immutable tags are recommended)   | `1.0.1-debian-10-r0`          |
| `tempo.image.pullPolicy`               | Grafana Tempo image pull policy                            | `IfNotPresent`                |
| `tempo.image.pullSecrets`              | Grafana Tempo image pull secrets                           | `[]`                          |
| `tempo.containerPort`                  | Tempo components web port                                  | `3100`                        |
| `tempo.grpcContainerPort`              | Tempo components GRPC port                                 | `9095`                        |
| `tempo.memBallastSizeMbs`              | Tempo components memory ballast size in MB                 | `1024`                        |
| `tempo.dataDir`                        | Tempo components data directory                            | `/bitnami/tempo-grafana/data` |
| `tempo.traces.jaeger.grpc`             | Enable Tempo to ingest Jaeger GRPC traces                  | `true`                        |
| `tempo.traces.jaeger.thriftBinary`     | Enable Tempo to ingest Jaeger Thrift Binary traces         | `false`                       |
| `tempo.traces.jaeger.thriftCompact`    | Enable Tempo to ingest Jaeger Thrift Compact traces        | `false`                       |
| `tempo.traces.jaeger.thriftHttp`       | Enable Tempo to ingest Jaeger Thrift HTTP traces           | `true`                        |
| `tempo.traces.zipkin`                  | Enable Tempo to ingest Zipkin traces                       | `false`                       |
| `tempo.traces.otlp.http`               | Enable Tempo to ingest Open Telementry HTTP traces         | `false`                       |
| `tempo.traces.otlp.grpc`               | Enable Tempo to ingest Open Telementry GRPC traces         | `false`                       |
| `tempo.traces.opencensus`              | Enable Tempo to ingest Open Census traces                  | `false`                       |
| `tempo.gossipRing.containerPort`       | gossip service HTTP port                                   | `7946`                        |
| `tempo.gossipRing.service.port`        | gossip headless service HTTP port                          | `7946`                        |
| `tempo.gossipRing.service.annotations` | Additional custom annotations for gossip headless service  | `{}`                          |
| `tempo.configuration`                  | Tempo components configuration                             | `""`                          |
| `tempo.existingConfigmap`              | name of a ConfigMap with the tempo configuration           | `nil`                         |
| `tempo.overridesConfiguration`         | Tempo components overrides configuration settings          | `""`                          |
| `tempo.existingOverridesConfigmap`     | name of a ConfigMap with the tempo overrides configuration | `nil`                         |


### Compactor Deployment Parameters

| Name                                           | Description                                                                                         | Value           |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------- | --------------- |
| `compactor.enabled`                            | Enable compactor deployment                                                                         | `true`          |
| `compactor.replicaCount`                       | Number of compactor replicas to deploy                                                              | `1`             |
| `compactor.livenessProbe.enabled`              | Enable livenessProbe on compactor nodes                                                             | `true`          |
| `compactor.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                             | `10`            |
| `compactor.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                    | `10`            |
| `compactor.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                   | `1`             |
| `compactor.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                 | `3`             |
| `compactor.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                 | `1`             |
| `compactor.readinessProbe.enabled`             | Enable readinessProbe on compactor nodes                                                            | `true`          |
| `compactor.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                            | `10`            |
| `compactor.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                   | `10`            |
| `compactor.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                  | `1`             |
| `compactor.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                | `3`             |
| `compactor.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                | `1`             |
| `compactor.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                 | `{}`            |
| `compactor.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                | `{}`            |
| `compactor.resources.limits`                   | The resources limits for the compactor containers                                                   | `{}`            |
| `compactor.resources.requests`                 | The requested resources for the compactor containers                                                | `{}`            |
| `compactor.podSecurityContext.enabled`         | Enabled compactor pods' Security Context                                                            | `true`          |
| `compactor.podSecurityContext.fsGroup`         | Set compactor pod's Security Context fsGroup                                                        | `1001`          |
| `compactor.containerSecurityContext.enabled`   | Enabled compactor containers' Security Context                                                      | `true`          |
| `compactor.containerSecurityContext.runAsUser` | Set compactor containers' Security Context runAsUser                                                | `1001`          |
| `compactor.command`                            | Override default container command (useful when using custom images)                                | `[]`            |
| `compactor.args`                               | Override default container args (useful when using custom images)                                   | `[]`            |
| `compactor.hostAliases`                        | compactor pods host aliases                                                                         | `[]`            |
| `compactor.podLabels`                          | Extra labels for compactor pods                                                                     | `{}`            |
| `compactor.podAnnotations`                     | Annotations for compactor pods                                                                      | `{}`            |
| `compactor.podAffinityPreset`                  | Pod affinity preset. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `compactor.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `compactor.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `compactor.nodeAffinityPreset.key`             | Node label key to match. Ignored if `compactor.affinity` is set                                     | `""`            |
| `compactor.nodeAffinityPreset.values`          | Node label values to match. Ignored if `compactor.affinity` is set                                  | `[]`            |
| `compactor.affinity`                           | Affinity for compactor pods assignment                                                              | `{}`            |
| `compactor.nodeSelector`                       | Node labels for compactor pods assignment                                                           | `{}`            |
| `compactor.tolerations`                        | Tolerations for compactor pods assignment                                                           | `[]`            |
| `compactor.updateStrategy.type`                | compactor statefulset strategy type                                                                 | `RollingUpdate` |
| `compactor.priorityClassName`                  | compactor pods' priorityClassName                                                                   | `""`            |
| `compactor.lifecycleHooks`                     | for the compactor container(s) to automate configuration before or after startup                    | `{}`            |
| `compactor.extraEnvVars`                       | Array with extra environment variables to add to compactor nodes                                    | `[]`            |
| `compactor.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for compactor nodes                            | `nil`           |
| `compactor.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for compactor nodes                               | `nil`           |
| `compactor.extraVolumes`                       | Optionally specify extra list of additional volumes for the compactor pod(s)                        | `[]`            |
| `compactor.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the compactor container(s)             | `[]`            |
| `compactor.sidecars`                           | Add additional sidecar containers to the compactor pod(s)                                           | `{}`            |
| `compactor.initContainers`                     | Add additional init containers to the compactor pod(s)                                              | `{}`            |


### Compactor Traffic Exposure Parameters

| Name                                         | Description                                         | Value       |
| -------------------------------------------- | --------------------------------------------------- | ----------- |
| `compactor.service.type`                     | compactor service type                              | `ClusterIP` |
| `compactor.service.port`                     | compactor service HTTP port                         | `3100`      |
| `compactor.service.nodePorts.http`           | Node port for HTTP                                  | `nil`       |
| `compactor.service.clusterIP`                | compactor service Cluster IP                        | `nil`       |
| `compactor.service.loadBalancerIP`           | compactor service Load Balancer IP                  | `nil`       |
| `compactor.service.loadBalancerSourceRanges` | compactor service Load Balancer sources             | `[]`        |
| `compactor.service.externalTrafficPolicy`    | compactor service external traffic policy           | `Cluster`   |
| `compactor.service.annotations`              | Additional custom annotations for compactor service | `{}`        |


### Distributor Deployment Parameters

| Name                                             | Description                                                                                           | Value           |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------- | --------------- |
| `distributor.replicaCount`                       | Number of distributor replicas to deploy                                                              | `1`             |
| `distributor.livenessProbe.enabled`              | Enable livenessProbe on distributor nodes                                                             | `true`          |
| `distributor.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                               | `10`            |
| `distributor.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                      | `10`            |
| `distributor.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                     | `1`             |
| `distributor.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                   | `3`             |
| `distributor.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                   | `1`             |
| `distributor.readinessProbe.enabled`             | Enable readinessProbe on distributor nodes                                                            | `true`          |
| `distributor.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                              | `10`            |
| `distributor.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                     | `10`            |
| `distributor.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                    | `1`             |
| `distributor.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                  | `3`             |
| `distributor.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                  | `1`             |
| `distributor.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                   | `{}`            |
| `distributor.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                  | `{}`            |
| `distributor.resources.limits`                   | The resources limits for the distributor containers                                                   | `{}`            |
| `distributor.resources.requests`                 | The requested resources for the distributor containers                                                | `{}`            |
| `distributor.podSecurityContext.enabled`         | Enabled distributor pods' Security Context                                                            | `true`          |
| `distributor.podSecurityContext.fsGroup`         | Set distributor pod's Security Context fsGroup                                                        | `1001`          |
| `distributor.containerSecurityContext.enabled`   | Enabled distributor containers' Security Context                                                      | `true`          |
| `distributor.containerSecurityContext.runAsUser` | Set distributor containers' Security Context runAsUser                                                | `1001`          |
| `distributor.command`                            | Override default container command (useful when using custom images)                                  | `[]`            |
| `distributor.args`                               | Override default container args (useful when using custom images)                                     | `[]`            |
| `distributor.hostAliases`                        | distributor pods host aliases                                                                         | `[]`            |
| `distributor.podLabels`                          | Extra labels for distributor pods                                                                     | `{}`            |
| `distributor.podAnnotations`                     | Annotations for distributor pods                                                                      | `{}`            |
| `distributor.podAffinityPreset`                  | Pod affinity preset. Ignored if `distributor.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `distributor.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `distributor.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `distributor.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `distributor.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `distributor.nodeAffinityPreset.key`             | Node label key to match. Ignored if `distributor.affinity` is set                                     | `""`            |
| `distributor.nodeAffinityPreset.values`          | Node label values to match. Ignored if `distributor.affinity` is set                                  | `[]`            |
| `distributor.affinity`                           | Affinity for distributor pods assignment                                                              | `{}`            |
| `distributor.nodeSelector`                       | Node labels for distributor pods assignment                                                           | `{}`            |
| `distributor.tolerations`                        | Tolerations for distributor pods assignment                                                           | `[]`            |
| `distributor.updateStrategy.type`                | distributor statefulset strategy type                                                                 | `RollingUpdate` |
| `distributor.priorityClassName`                  | distributor pods' priorityClassName                                                                   | `""`            |
| `distributor.lifecycleHooks`                     | for the distributor container(s) to automate configuration before or after startup                    | `{}`            |
| `distributor.extraEnvVars`                       | Array with extra environment variables to add to distributor nodes                                    | `[]`            |
| `distributor.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for distributor nodes                            | `nil`           |
| `distributor.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for distributor nodes                               | `nil`           |
| `distributor.extraVolumes`                       | Optionally specify extra list of additional volumes for the distributor pod(s)                        | `[]`            |
| `distributor.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the distributor container(s)             | `[]`            |
| `distributor.sidecars`                           | Add additional sidecar containers to the distributor pod(s)                                           | `{}`            |
| `distributor.initContainers`                     | Add additional init containers to the distributor pod(s)                                              | `{}`            |


### Distributor Traffic Exposure Parameters

| Name                                           | Description                                           | Value       |
| ---------------------------------------------- | ----------------------------------------------------- | ----------- |
| `distributor.service.type`                     | distributor service type                              | `ClusterIP` |
| `distributor.service.port`                     | distributor service HTTP port                         | `3100`      |
| `distributor.service.grpcPort`                 | distributor service HTTP port                         | `9095`      |
| `distributor.service.nodePorts.http`           | Node port for HTTP                                    | `nil`       |
| `distributor.service.nodePorts.grpc`           | Node port for GRPC                                    | `nil`       |
| `distributor.service.clusterIP`                | distributor service Cluster IP                        | `nil`       |
| `distributor.service.loadBalancerIP`           | distributor service Load Balancer IP                  | `nil`       |
| `distributor.service.loadBalancerSourceRanges` | distributor service Load Balancer sources             | `[]`        |
| `distributor.service.externalTrafficPolicy`    | distributor service external traffic policy           | `Cluster`   |
| `distributor.service.annotations`              | Additional custom annotations for distributor service | `{}`        |


### Ingester Deployment Parameters

| Name                                          | Description                                                                                        | Value           |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------- | --------------- |
| `ingester.replicaCount`                       | Number of ingester replicas to deploy                                                              | `1`             |
| `ingester.livenessProbe.enabled`              | Enable livenessProbe on ingester nodes                                                             | `true`          |
| `ingester.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                            | `10`            |
| `ingester.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                   | `10`            |
| `ingester.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                  | `1`             |
| `ingester.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                | `3`             |
| `ingester.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                | `1`             |
| `ingester.readinessProbe.enabled`             | Enable readinessProbe on ingester nodes                                                            | `true`          |
| `ingester.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                           | `10`            |
| `ingester.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                  | `10`            |
| `ingester.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                 | `1`             |
| `ingester.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                               | `3`             |
| `ingester.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                               | `1`             |
| `ingester.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                | `{}`            |
| `ingester.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                               | `{}`            |
| `ingester.resources.limits`                   | The resources limits for the ingester containers                                                   | `{}`            |
| `ingester.resources.requests`                 | The requested resources for the ingester containers                                                | `{}`            |
| `ingester.podSecurityContext.enabled`         | Enabled ingester pods' Security Context                                                            | `true`          |
| `ingester.podSecurityContext.fsGroup`         | Set ingester pod's Security Context fsGroup                                                        | `1001`          |
| `ingester.containerSecurityContext.enabled`   | Enabled ingester containers' Security Context                                                      | `true`          |
| `ingester.containerSecurityContext.runAsUser` | Set ingester containers' Security Context runAsUser                                                | `1001`          |
| `ingester.command`                            | Override default container command (useful when using custom images)                               | `[]`            |
| `ingester.args`                               | Override default container args (useful when using custom images)                                  | `[]`            |
| `ingester.hostAliases`                        | ingester pods host aliases                                                                         | `[]`            |
| `ingester.podLabels`                          | Extra labels for ingester pods                                                                     | `{}`            |
| `ingester.podAnnotations`                     | Annotations for ingester pods                                                                      | `{}`            |
| `ingester.podAffinityPreset`                  | Pod affinity preset. Ignored if `ingester.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `ingester.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `ingester.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `ingester.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `ingester.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `ingester.nodeAffinityPreset.key`             | Node label key to match. Ignored if `ingester.affinity` is set                                     | `""`            |
| `ingester.nodeAffinityPreset.values`          | Node label values to match. Ignored if `ingester.affinity` is set                                  | `[]`            |
| `ingester.affinity`                           | Affinity for ingester pods assignment                                                              | `{}`            |
| `ingester.nodeSelector`                       | Node labels for ingester pods assignment                                                           | `{}`            |
| `ingester.tolerations`                        | Tolerations for ingester pods assignment                                                           | `[]`            |
| `ingester.updateStrategy.type`                | ingester statefulset strategy type                                                                 | `RollingUpdate` |
| `ingester.priorityClassName`                  | ingester pods' priorityClassName                                                                   | `""`            |
| `ingester.lifecycleHooks`                     | for the ingester container(s) to automate configuration before or after startup                    | `{}`            |
| `ingester.extraEnvVars`                       | Array with extra environment variables to add to ingester nodes                                    | `[]`            |
| `ingester.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for ingester nodes                            | `nil`           |
| `ingester.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for ingester nodes                               | `nil`           |
| `ingester.extraVolumes`                       | Optionally specify extra list of additional volumes for the ingester pod(s)                        | `[]`            |
| `ingester.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the ingester container(s)             | `[]`            |
| `ingester.sidecars`                           | Add additional sidecar containers to the ingester pod(s)                                           | `{}`            |
| `ingester.initContainers`                     | Add additional init containers to the ingester pod(s)                                              | `{}`            |


### Ingester Persistence Parameters

| Name                                                   | Description                                | Value  |
| ------------------------------------------------------ | ------------------------------------------ | ------ |
| `ingester.persistence.enabled`                         | Enable persistence in ingester instances   | `true` |
| `ingester.persistence.storageClass`                    | Persistent Volumes storage class           | `nil`  |
| `ingester.persistence.subPath`                         | The subdirectory of the volume to mount to | `""`   |
| `ingester.persistence.accessModes`                     | Persistent Volumes access modes            | `[]`   |
| `ingester.persistence.size`                            | Persistent Volumes size                    | `8Gi`  |
| `ingester.persistence.annotations`                     | Persistent Volumes annotations             | `{}`   |
| `ingester.persistence.volumeClaimTemplates.selector`   | Persistent Volumes selector                | `nil`  |
| `ingester.persistence.volumeClaimTemplates.requests`   | Persistent Volumes requests                | `nil`  |
| `ingester.persistence.volumeClaimTemplates.dataSource` | Persistent Volumes data source             | `nil`  |


### Ingester Traffic Exposure Parameters

| Name                                        | Description                                        | Value       |
| ------------------------------------------- | -------------------------------------------------- | ----------- |
| `ingester.service.type`                     | ingester service type                              | `ClusterIP` |
| `ingester.service.port`                     | ingester service HTTP port                         | `3100`      |
| `ingester.service.grpcPort`                 | ingester service HTTP port                         | `9095`      |
| `ingester.service.nodePorts.http`           | Node port for HTTP                                 | `nil`       |
| `ingester.service.nodePorts.grpc`           | Node port for GRPC                                 | `nil`       |
| `ingester.service.clusterIP`                | ingester service Cluster IP                        | `nil`       |
| `ingester.service.loadBalancerIP`           | ingester service Load Balancer IP                  | `nil`       |
| `ingester.service.loadBalancerSourceRanges` | ingester service Load Balancer sources             | `[]`        |
| `ingester.service.externalTrafficPolicy`    | ingester service external traffic policy           | `Cluster`   |
| `ingester.service.annotations`              | Additional custom annotations for ingester service | `{}`        |


### Querier Deployment Parameters

| Name                                         | Description                                                                                       | Value           |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- | --------------- |
| `querier.replicaCount`                       | Number of querier replicas to deploy                                                              | `1`             |
| `querier.livenessProbe.enabled`              | Enable livenessProbe on querier nodes                                                             | `true`          |
| `querier.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                           | `10`            |
| `querier.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                  | `10`            |
| `querier.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                 | `1`             |
| `querier.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                               | `3`             |
| `querier.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                               | `1`             |
| `querier.readinessProbe.enabled`             | Enable readinessProbe on querier nodes                                                            | `true`          |
| `querier.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                          | `10`            |
| `querier.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                 | `10`            |
| `querier.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                | `1`             |
| `querier.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                              | `3`             |
| `querier.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                              | `1`             |
| `querier.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                               | `{}`            |
| `querier.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                              | `{}`            |
| `querier.resources.limits`                   | The resources limits for the querier containers                                                   | `{}`            |
| `querier.resources.requests`                 | The requested resources for the querier containers                                                | `{}`            |
| `querier.podSecurityContext.enabled`         | Enabled querier pods' Security Context                                                            | `true`          |
| `querier.podSecurityContext.fsGroup`         | Set querier pod's Security Context fsGroup                                                        | `1001`          |
| `querier.containerSecurityContext.enabled`   | Enabled querier containers' Security Context                                                      | `true`          |
| `querier.containerSecurityContext.runAsUser` | Set querier containers' Security Context runAsUser                                                | `1001`          |
| `querier.command`                            | Override default container command (useful when using custom images)                              | `[]`            |
| `querier.args`                               | Override default container args (useful when using custom images)                                 | `[]`            |
| `querier.hostAliases`                        | querier pods host aliases                                                                         | `[]`            |
| `querier.podLabels`                          | Extra labels for querier pods                                                                     | `{}`            |
| `querier.podAnnotations`                     | Annotations for querier pods                                                                      | `{}`            |
| `querier.podAffinityPreset`                  | Pod affinity preset. Ignored if `querier.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `querier.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `querier.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `querier.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `querier.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `querier.nodeAffinityPreset.key`             | Node label key to match. Ignored if `querier.affinity` is set                                     | `""`            |
| `querier.nodeAffinityPreset.values`          | Node label values to match. Ignored if `querier.affinity` is set                                  | `[]`            |
| `querier.affinity`                           | Affinity for querier pods assignment                                                              | `{}`            |
| `querier.nodeSelector`                       | Node labels for querier pods assignment                                                           | `{}`            |
| `querier.tolerations`                        | Tolerations for querier pods assignment                                                           | `[]`            |
| `querier.updateStrategy.type`                | querier statefulset strategy type                                                                 | `RollingUpdate` |
| `querier.priorityClassName`                  | querier pods' priorityClassName                                                                   | `""`            |
| `querier.lifecycleHooks`                     | for the querier container(s) to automate configuration before or after startup                    | `{}`            |
| `querier.extraEnvVars`                       | Array with extra environment variables to add to querier nodes                                    | `[]`            |
| `querier.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for querier nodes                            | `nil`           |
| `querier.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for querier nodes                               | `nil`           |
| `querier.extraVolumes`                       | Optionally specify extra list of additional volumes for the querier pod(s)                        | `[]`            |
| `querier.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the querier container(s)             | `[]`            |
| `querier.sidecars`                           | Add additional sidecar containers to the querier pod(s)                                           | `{}`            |
| `querier.initContainers`                     | Add additional init containers to the querier pod(s)                                              | `{}`            |


### Querier Traffic Exposure Parameters

| Name                                       | Description                                       | Value       |
| ------------------------------------------ | ------------------------------------------------- | ----------- |
| `querier.service.type`                     | querier service type                              | `ClusterIP` |
| `querier.service.port`                     | querier service HTTP port                         | `3100`      |
| `querier.service.grpcPort`                 | querier service HTTP port                         | `9095`      |
| `querier.service.nodePorts.http`           | Node port for HTTP                                | `nil`       |
| `querier.service.nodePorts.grpc`           | Node port for GRPC                                | `nil`       |
| `querier.service.clusterIP`                | querier service Cluster IP                        | `nil`       |
| `querier.service.loadBalancerIP`           | querier service Load Balancer IP                  | `nil`       |
| `querier.service.loadBalancerSourceRanges` | querier service Load Balancer sources             | `[]`        |
| `querier.service.externalTrafficPolicy`    | querier service external traffic policy           | `Cluster`   |
| `querier.service.annotations`              | Additional custom annotations for querier service | `{}`        |


### Query Frontend Deployment Parameters

| Name                                                     | Description                                                                                             | Value                         |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `queryFrontend.replicaCount`                             | Number of queryFrontend replicas to deploy                                                              | `1`                           |
| `queryFrontend.livenessProbe.enabled`                    | Enable livenessProbe on queryFrontend nodes                                                             | `true`                        |
| `queryFrontend.livenessProbe.initialDelaySeconds`        | Initial delay seconds for livenessProbe                                                                 | `10`                          |
| `queryFrontend.livenessProbe.periodSeconds`              | Period seconds for livenessProbe                                                                        | `10`                          |
| `queryFrontend.livenessProbe.timeoutSeconds`             | Timeout seconds for livenessProbe                                                                       | `1`                           |
| `queryFrontend.livenessProbe.failureThreshold`           | Failure threshold for livenessProbe                                                                     | `3`                           |
| `queryFrontend.livenessProbe.successThreshold`           | Success threshold for livenessProbe                                                                     | `1`                           |
| `queryFrontend.readinessProbe.enabled`                   | Enable readinessProbe on queryFrontend nodes                                                            | `true`                        |
| `queryFrontend.readinessProbe.initialDelaySeconds`       | Initial delay seconds for readinessProbe                                                                | `10`                          |
| `queryFrontend.readinessProbe.periodSeconds`             | Period seconds for readinessProbe                                                                       | `10`                          |
| `queryFrontend.readinessProbe.timeoutSeconds`            | Timeout seconds for readinessProbe                                                                      | `1`                           |
| `queryFrontend.readinessProbe.failureThreshold`          | Failure threshold for readinessProbe                                                                    | `3`                           |
| `queryFrontend.readinessProbe.successThreshold`          | Success threshold for readinessProbe                                                                    | `1`                           |
| `queryFrontend.customLivenessProbe`                      | Custom livenessProbe that overrides the default one                                                     | `{}`                          |
| `queryFrontend.customReadinessProbe`                     | Custom readinessProbe that overrides the default one                                                    | `{}`                          |
| `queryFrontend.resources.limits`                         | The resources limits for the queryFrontend containers                                                   | `{}`                          |
| `queryFrontend.resources.requests`                       | The requested resources for the queryFrontend containers                                                | `{}`                          |
| `queryFrontend.podSecurityContext.enabled`               | Enabled queryFrontend pods' Security Context                                                            | `true`                        |
| `queryFrontend.podSecurityContext.fsGroup`               | Set queryFrontend pod's Security Context fsGroup                                                        | `1001`                        |
| `queryFrontend.containerSecurityContext.enabled`         | Enabled queryFrontend containers' Security Context                                                      | `true`                        |
| `queryFrontend.containerSecurityContext.runAsUser`       | Set queryFrontend containers' Security Context runAsUser                                                | `1001`                        |
| `queryFrontend.command`                                  | Override default container command (useful when using custom images)                                    | `[]`                          |
| `queryFrontend.args`                                     | Override default container args (useful when using custom images)                                       | `[]`                          |
| `queryFrontend.hostAliases`                              | queryFrontend pods host aliases                                                                         | `[]`                          |
| `queryFrontend.podLabels`                                | Extra labels for queryFrontend pods                                                                     | `{}`                          |
| `queryFrontend.podAnnotations`                           | Annotations for queryFrontend pods                                                                      | `{}`                          |
| `queryFrontend.podAffinityPreset`                        | Pod affinity preset. Ignored if `queryFrontend.affinity` is set. Allowed values: `soft` or `hard`       | `""`                          |
| `queryFrontend.podAntiAffinityPreset`                    | Pod anti-affinity preset. Ignored if `queryFrontend.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                        |
| `queryFrontend.nodeAffinityPreset.type`                  | Node affinity preset type. Ignored if `queryFrontend.affinity` is set. Allowed values: `soft` or `hard` | `""`                          |
| `queryFrontend.nodeAffinityPreset.key`                   | Node label key to match. Ignored if `queryFrontend.affinity` is set                                     | `""`                          |
| `queryFrontend.nodeAffinityPreset.values`                | Node label values to match. Ignored if `queryFrontend.affinity` is set                                  | `[]`                          |
| `queryFrontend.affinity`                                 | Affinity for queryFrontend pods assignment                                                              | `{}`                          |
| `queryFrontend.nodeSelector`                             | Node labels for queryFrontend pods assignment                                                           | `{}`                          |
| `queryFrontend.tolerations`                              | Tolerations for queryFrontend pods assignment                                                           | `[]`                          |
| `queryFrontend.updateStrategy.type`                      | queryFrontend statefulset strategy type                                                                 | `RollingUpdate`               |
| `queryFrontend.priorityClassName`                        | queryFrontend pods' priorityClassName                                                                   | `""`                          |
| `queryFrontend.lifecycleHooks`                           | for the queryFrontend container(s) to automate configuration before or after startup                    | `{}`                          |
| `queryFrontend.extraEnvVars`                             | Array with extra environment variables to add to queryFrontend nodes                                    | `[]`                          |
| `queryFrontend.extraEnvVarsCM`                           | Name of existing ConfigMap containing extra env vars for queryFrontend nodes                            | `nil`                         |
| `queryFrontend.extraEnvVarsSecret`                       | Name of existing Secret containing extra env vars for queryFrontend nodes                               | `nil`                         |
| `queryFrontend.extraVolumes`                             | Optionally specify extra list of additional volumes for the queryFrontend pod(s)                        | `[]`                          |
| `queryFrontend.extraVolumeMounts`                        | Optionally specify extra list of additional volumeMounts for the queryFrontend container(s)             | `[]`                          |
| `queryFrontend.sidecars`                                 | Add additional sidecar containers to the queryFrontend pod(s)                                           | `{}`                          |
| `queryFrontend.initContainers`                           | Add additional init containers to the queryFrontend pod(s)                                              | `{}`                          |
| `queryFrontend.query.image.registry`                     | Grafana Tempo Query image registry                                                                      | `docker.io`                   |
| `queryFrontend.query.image.repository`                   | Grafana Tempo Query image repository                                                                    | `bitnami/grafana-tempo-query` |
| `queryFrontend.query.image.tag`                          | Grafana Tempo Query image tag (immutable tags are recommended)                                          | `1.0.1-debian-10-r0`          |
| `queryFrontend.query.image.pullPolicy`                   | Grafana Tempo Query image pull policy                                                                   | `IfNotPresent`                |
| `queryFrontend.query.image.pullSecrets`                  | Grafana Tempo Query image pull secrets                                                                  | `[]`                          |
| `queryFrontend.query.command`                            | Override default container command (useful when using custom images)                                    | `[]`                          |
| `queryFrontend.query.args`                               | Override default container args (useful when using custom images)                                       | `[]`                          |
| `queryFrontend.query.configuration`                      | Query sidecar configuration                                                                             | `""`                          |
| `queryFrontend.query.jaegerMetricsContainerPort`         | Jaeger metrics container port                                                                           | `16687`                       |
| `queryFrontend.query.jaegerUIContainerPort`              | Jaeger UI container port                                                                                | `16686`                       |
| `queryFrontend.query.existingConfigmap`                  | Name of a configmap with the query configuration                                                        | `nil`                         |
| `queryFrontend.query.livenessProbe.enabled`              | Enable livenessProbe on query sidecar nodes                                                             | `true`                        |
| `queryFrontend.query.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                 | `10`                          |
| `queryFrontend.query.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                        | `10`                          |
| `queryFrontend.query.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                       | `1`                           |
| `queryFrontend.query.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                     | `3`                           |
| `queryFrontend.query.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                     | `1`                           |
| `queryFrontend.query.readinessProbe.enabled`             | Enable readinessProbe on query sidecar nodes                                                            | `true`                        |
| `queryFrontend.query.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                | `10`                          |
| `queryFrontend.query.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                       | `10`                          |
| `queryFrontend.query.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                      | `1`                           |
| `queryFrontend.query.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                    | `3`                           |
| `queryFrontend.query.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                    | `1`                           |
| `queryFrontend.query.resources.limits`                   | The resources limits for the query sidecar containers                                                   | `{}`                          |
| `queryFrontend.query.resources.requests`                 | The requested resources for the query sidecar containers                                                | `{}`                          |
| `queryFrontend.query.lifecycleHooks`                     | for the query sidecar container(s) to automate configuration before or after startup                    | `{}`                          |
| `queryFrontend.query.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                     | `{}`                          |
| `queryFrontend.query.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                    | `{}`                          |
| `queryFrontend.query.extraEnvVars`                       | Array with extra environment variables to add to queryFrontend nodes                                    | `[]`                          |
| `queryFrontend.query.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for queryFrontend nodes                            | `nil`                         |
| `queryFrontend.query.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for queryFrontend nodes                               | `nil`                         |
| `queryFrontend.query.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the queryFrontend container(s)             | `[]`                          |
| `queryFrontend.query.containerSecurityContext.enabled`   | Enabled query-frontend query sidecar containers' Security Context                                       | `true`                        |
| `queryFrontend.query.containerSecurityContext.runAsUser` | Set query-frontend query sidecar containers' Security Context runAsUser                                 | `1001`                        |


### Query Frontend Traffic Exposure Parameters

| Name                                             | Description                                             | Value       |
| ------------------------------------------------ | ------------------------------------------------------- | ----------- |
| `queryFrontend.service.type`                     | queryFrontend service type                              | `ClusterIP` |
| `queryFrontend.service.port`                     | queryFrontend service HTTP port                         | `3100`      |
| `queryFrontend.service.grpcPort`                 | queryFrontend service HTTP port                         | `9095`      |
| `queryFrontend.service.nodePorts.http`           | Node port for HTTP                                      | `nil`       |
| `queryFrontend.service.nodePorts.grpc`           | Node port for GRPC                                      | `nil`       |
| `queryFrontend.service.clusterIP`                | queryFrontend service Cluster IP                        | `nil`       |
| `queryFrontend.service.loadBalancerIP`           | queryFrontend service Load Balancer IP                  | `nil`       |
| `queryFrontend.service.loadBalancerSourceRanges` | queryFrontend service Load Balancer sources             | `[]`        |
| `queryFrontend.service.externalTrafficPolicy`    | queryFrontend service external traffic policy           | `Cluster`   |
| `queryFrontend.service.annotations`              | Additional custom annotations for queryFrontend service | `{}`        |


### Vulture Deployment Parameters

| Name                                         | Description                                                                                       | Value                           |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------- |
| `vulture.enabled`                            | Enable vulture deployment                                                                         | `true`                          |
| `vulture.image.registry`                     | Grafana Vulture image registry                                                                    | `docker.io`                     |
| `vulture.image.repository`                   | Grafana Vulture image repository                                                                  | `bitnami/grafana-tempo-vulture` |
| `vulture.image.tag`                          | Grafana Vulture image tag (immutable tags are recommended)                                        | `1.0.1-debian-10-r0`            |
| `vulture.image.pullPolicy`                   | Grafana Vulture image pull policy                                                                 | `IfNotPresent`                  |
| `vulture.image.pullSecrets`                  | Grafana Vulture image pull secrets                                                                | `[]`                            |
| `vulture.replicaCount`                       | Number of vulture replicas to deploy                                                              | `1`                             |
| `vulture.livenessProbe.enabled`              | Enable livenessProbe on vulture nodes                                                             | `true`                          |
| `vulture.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                           | `10`                            |
| `vulture.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                  | `10`                            |
| `vulture.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                 | `1`                             |
| `vulture.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                               | `3`                             |
| `vulture.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                               | `1`                             |
| `vulture.readinessProbe.enabled`             | Enable readinessProbe on vulture nodes                                                            | `true`                          |
| `vulture.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                          | `10`                            |
| `vulture.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                 | `10`                            |
| `vulture.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                | `1`                             |
| `vulture.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                              | `3`                             |
| `vulture.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                              | `1`                             |
| `vulture.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                               | `{}`                            |
| `vulture.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                              | `{}`                            |
| `vulture.resources.limits`                   | The resources limits for the vulture containers                                                   | `{}`                            |
| `vulture.resources.requests`                 | The requested resources for the vulture containers                                                | `{}`                            |
| `vulture.podSecurityContext.enabled`         | Enabled vulture pods' Security Context                                                            | `true`                          |
| `vulture.podSecurityContext.fsGroup`         | Set vulture pod's Security Context fsGroup                                                        | `1001`                          |
| `vulture.containerSecurityContext.enabled`   | Enabled vulture containers' Security Context                                                      | `true`                          |
| `vulture.containerSecurityContext.runAsUser` | Set vulture containers' Security Context runAsUser                                                | `1001`                          |
| `vulture.command`                            | Override default container command (useful when using custom images)                              | `[]`                            |
| `vulture.args`                               | Override default container args (useful when using custom images)                                 | `[]`                            |
| `vulture.hostAliases`                        | vulture pods host aliases                                                                         | `[]`                            |
| `vulture.podLabels`                          | Extra labels for vulture pods                                                                     | `{}`                            |
| `vulture.podAnnotations`                     | Annotations for vulture pods                                                                      | `{}`                            |
| `vulture.podAffinityPreset`                  | Pod affinity preset. Ignored if `vulture.affinity` is set. Allowed values: `soft` or `hard`       | `""`                            |
| `vulture.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `vulture.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                          |
| `vulture.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `vulture.affinity` is set. Allowed values: `soft` or `hard` | `""`                            |
| `vulture.nodeAffinityPreset.key`             | Node label key to match. Ignored if `vulture.affinity` is set                                     | `""`                            |
| `vulture.nodeAffinityPreset.values`          | Node label values to match. Ignored if `vulture.affinity` is set                                  | `[]`                            |
| `vulture.containerPort`                      | Vulture container port                                                                            | `8080`                          |
| `vulture.affinity`                           | Affinity for vulture pods assignment                                                              | `{}`                            |
| `vulture.nodeSelector`                       | Node labels for vulture pods assignment                                                           | `{}`                            |
| `vulture.tolerations`                        | Tolerations for vulture pods assignment                                                           | `[]`                            |
| `vulture.updateStrategy.type`                | vulture statefulset strategy type                                                                 | `RollingUpdate`                 |
| `vulture.priorityClassName`                  | vulture pods' priorityClassName                                                                   | `""`                            |
| `vulture.lifecycleHooks`                     | for the vulture container(s) to automate configuration before or after startup                    | `{}`                            |
| `vulture.extraEnvVars`                       | Array with extra environment variables to add to vulture nodes                                    | `[]`                            |
| `vulture.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for vulture nodes                            | `nil`                           |
| `vulture.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for vulture nodes                               | `nil`                           |
| `vulture.extraVolumes`                       | Optionally specify extra list of additional volumes for the vulture pod(s)                        | `[]`                            |
| `vulture.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the vulture container(s)             | `[]`                            |
| `vulture.sidecars`                           | Add additional sidecar containers to the vulture pod(s)                                           | `{}`                            |
| `vulture.initContainers`                     | Add additional init containers to the vulture pod(s)                                              | `{}`                            |


### Vulture Traffic Exposure Parameters

| Name                                       | Description                                       | Value       |
| ------------------------------------------ | ------------------------------------------------- | ----------- |
| `vulture.service.type`                     | vulture service type                              | `ClusterIP` |
| `vulture.service.port`                     | vulture service HTTP port                         | `3100`      |
| `vulture.service.nodePorts.http`           | Node port for HTTP                                | `nil`       |
| `vulture.service.clusterIP`                | vulture service Cluster IP                        | `nil`       |
| `vulture.service.loadBalancerIP`           | vulture service Load Balancer IP                  | `nil`       |
| `vulture.service.loadBalancerSourceRanges` | vulture service Load Balancer sources             | `[]`        |
| `vulture.service.externalTrafficPolicy`    | vulture service external traffic policy           | `Cluster`   |
| `vulture.service.annotations`              | Additional custom annotations for vulture service | `{}`        |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                   |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `10`                    |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `Always`                |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |


### Other Parameters

| Name                     | Description                                                                             | Value   |
| ------------------------ | --------------------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`  | Specifies whether a ServiceAccount should be created                                    | `true`  |
| `serviceAccount.name`    | The name of the ServiceAccount to use.                                                  | `""`    |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false` |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `[]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `[]`    |


### Metrics Parameters

| Name                                   | Description                                                                     | Value   |
| -------------------------------------- | ------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                      | Enable metrics                                                                  | `false` |
| `metrics.serviceMonitor.enabled`       | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator | `false` |
| `metrics.serviceMonitor.namespace`     | The namespace in which the ServiceMonitor will be created                       | `nil`   |
| `metrics.serviceMonitor.interval`      | The interval at which metrics should be scraped                                 | `30s`   |
| `metrics.serviceMonitor.scrapeTimeout` | The timeout after which the scrape is ended                                     | `nil`   |
| `metrics.serviceMonitor.selector`      | Scrape selector                                                                 | `nil`   |


### External Memcached Parameters

| Name                     | Description                                   | Value   |
| ------------------------ | --------------------------------------------- | ------- |
| `externalMemcached.host` | Host of a running external memcached instance | `nil`   |
| `externalMemcached.port` | Port of a running external memcached instance | `11211` |


### Memcached Sub-chart Parameters

| Name                     | Description                | Value   |
| ------------------------ | -------------------------- | ------- |
| `memcached.enabled`      | Deploy memcached sub-chart | `true`  |
| `memcached.service.port` | Memcached service port     | `11211` |


See https://github.com/bitnami-labs/readme-generator-for-helm to create the table

The above parameters map to the env variables defined in [bitnami/grafana-tempo](http://github.com/bitnami/bitnami-docker-grafana-tempo). For more information please refer to the [bitnami/grafana-tempo](http://github.com/bitnami/bitnami-docker-grafana-tempo) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set tempo.traces.jaeger.grpc=true \
  bitnami/grafana-tempo
```

The above command enables the Jaeger GRPC traces.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/grafana-tempo
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.
### Tempo configuration

The tempo configuration file `tempo.yaml` is shared across the different components: `distributor`, `compactor`, `ingester`, `querier` and `queryFrontend`. This is set in the `tempo.configuration` value. Check the official [Tempo Grafana documentation](https://grafana.com/docs/tempo/latest/configuration/) for the list of possible configurations.

## Persistence

The [Bitnami grafana-tempo](https://github.com/bitnami/bitnami-docker-grafana-tempo) image stores the grafana-tempo `ingester` data at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. [Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/apps/grafana-tempo/configuration/chart-persistence/).

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

### Sidecars

If additional containers are needed in the same pod as grafana-tempo (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter inside each of the subsections: `distributor`, `compactor`, `ingester`, `querier`, `queryFrontend` and `vulture` . If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/grafana-tempo/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters inside each of the subsections: `distributor`, `compactor`, `ingester`, `querier`, `queryFrontend` and `vulture`.

### External cache support

You may want to have Grafana Tempo connect to an external Memcached rather than installing one inside your cluster. Typical reasons for this are to use a managed cache service, or to share a common cache server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalMemcached` parameter](#parameters). You should also disable the Memcached installation with the `memcached.enabled` option. Here is an example:

```console
memcached.enabled=false
externalMemcached.host=myexternalhost
externalMemcached.port=11211
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
