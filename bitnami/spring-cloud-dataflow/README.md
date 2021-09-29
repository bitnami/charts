# Spring Cloud Data Flow

[Spring Cloud Data Flow](https://dataflow.spring.io/) is a microservices-based Streaming and Batch data processing pipeline in Cloud Foundry and Kubernetes.

## TL;DR

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/spring-cloud-dataflow
```

## Introduction

This chart bootstraps a [Spring Cloud Data Flow](https://github.com/bitnami/bitnami-docker-spring-cloud-dataflow) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/spring-cloud-dataflow
```

These commands deploy Spring Cloud Data Flow on the Kubernetes cluster with the default configuration. The [parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` chart:

```bash
helm uninstall my-release
```

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name               | Description                                                                           | Value           |
| ------------------ | ------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`     | String to partially override scdf.fullname template (will maintain the release name). | `""`            |
| `fullnameOverride` | String to fully override scdf.fullname template.                                      | `""`            |
| `kubeVersion`      | Force target Kubernetes version (using Helm capabilities if not set)                  | `""`            |
| `clusterDomain`    | Default Kubernetes cluster domain                                                     | `cluster.local` |
| `extraDeploy`      | Array of extra objects to deploy with the release                                     | `[]`            |


### Dataflow Server parameters

| Name                                         | Description                                                                                                      | Value                                                |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `server.image.registry`                      | Spring Cloud Dataflow image registry                                                                             | `docker.io`                                          |
| `server.image.repository`                    | Spring Cloud Dataflow image repository                                                                           | `bitnami/spring-cloud-dataflow`                      |
| `server.image.tag`                           | Spring Cloud Dataflow image tag (immutable tags are recommended)                                                 | `2.8.2-debian-10-r22`                                |
| `server.image.pullPolicy`                    | Spring Cloud Dataflow image pull policy                                                                          | `IfNotPresent`                                       |
| `server.image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                 | `[]`                                                 |
| `server.image.debug`                         | Enable image debug mode                                                                                          | `false`                                              |
| `server.hostAliases`                         | Deployment pod host aliases                                                                                      | `[]`                                                 |
| `server.composedTaskRunner.image.registry`   | Spring Cloud Dataflow Composed Task Runner image registry                                                        | `docker.io`                                          |
| `server.composedTaskRunner.image.repository` | Spring Cloud Dataflow Composed Task Runner image repository                                                      | `bitnami/spring-cloud-dataflow-composed-task-runner` |
| `server.composedTaskRunner.image.tag`        | Spring Cloud Dataflow Composed Task Runner image tag (immutable tags are recommended)                            | `2.8.2-debian-10-r22`                                |
| `server.configuration.streamingEnabled`      | Enables or disables streaming data processing                                                                    | `true`                                               |
| `server.configuration.batchEnabled`          | Enables or disables batch data (tasks and schedules) processing                                                  | `true`                                               |
| `server.configuration.accountName`           | The name of the account to configure for the Kubernetes platform                                                 | `default`                                            |
| `server.configuration.trustK8sCerts`         | Trust K8s certificates when querying the Kubernetes API                                                          | `false`                                              |
| `server.configuration.containerRegistries`   | Container registries configuration                                                                               | `{}`                                                 |
| `server.configuration.grafanaInfo`           | Endpoint to the grafana instance (Deprecated: use the metricsDashboard instead)                                  | `""`                                                 |
| `server.configuration.metricsDashboard`      | Endpoint to the metricsDashboard instance                                                                        | `""`                                                 |
| `server.existingConfigmap`                   | ConfigMap with Spring Cloud Dataflow Server Configuration                                                        | `""`                                                 |
| `server.extraEnvVars`                        | Extra environment variables to be set on Dataflow server container                                               | `[]`                                                 |
| `server.extraEnvVarsCM`                      | ConfigMap with extra environment variables                                                                       | `""`                                                 |
| `server.extraEnvVarsSecret`                  | Secret with extra environment variables                                                                          | `""`                                                 |
| `server.replicaCount`                        | Number of Dataflow server replicas to deploy                                                                     | `1`                                                  |
| `server.strategyType`                        | StrategyType, can be set to RollingUpdate or Recreate by default                                                 | `RollingUpdate`                                      |
| `server.podAffinityPreset`                   | Dataflow server pod affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                 |
| `server.podAntiAffinityPreset`               | Dataflow server pod anti-affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                               |
| `server.containerPort`                       | Dataflow server port                                                                                             | `8080`                                               |
| `server.nodeAffinityPreset.type`             | Dataflow server node affinity preset type. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                 |
| `server.nodeAffinityPreset.key`              | Dataflow server node label key to match Ignored if `server.affinity` is set.                                     | `""`                                                 |
| `server.nodeAffinityPreset.values`           | Dataflow server node label values to match. Ignored if `server.affinity` is set.                                 | `[]`                                                 |
| `server.affinity`                            | Dataflow server affinity for pod assignment                                                                      | `{}`                                                 |
| `server.nodeSelector`                        | Dataflow server node labels for pod assignment                                                                   | `{}`                                                 |
| `server.tolerations`                         | Dataflow server tolerations for pod assignment                                                                   | `[]`                                                 |
| `server.podAnnotations`                      | Annotations for Dataflow server pods                                                                             | `{}`                                                 |
| `server.priorityClassName`                   | Dataflow Server pods' priority                                                                                   | `""`                                                 |
| `server.podSecurityContext.fsGroup`          | Group ID for the volumes of the pod                                                                              | `1001`                                               |
| `server.containerSecurityContext.runAsUser`  | Set Dataflow Server container's Security Context runAsUser                                                       | `1001`                                               |
| `server.resources.limits`                    | The resources limits for the Dataflow server container                                                           | `{}`                                                 |
| `server.resources.requests`                  | The requested resources for the Dataflow server container                                                        | `{}`                                                 |
| `server.livenessProbe.enabled`               | Enable livenessProbe                                                                                             | `true`                                               |
| `server.livenessProbe.initialDelaySeconds`   | Initial delay seconds for livenessProbe                                                                          | `120`                                                |
| `server.livenessProbe.periodSeconds`         | Period seconds for livenessProbe                                                                                 | `20`                                                 |
| `server.livenessProbe.timeoutSeconds`        | Timeout seconds for livenessProbe                                                                                | `1`                                                  |
| `server.livenessProbe.failureThreshold`      | Failure threshold for livenessProbe                                                                              | `6`                                                  |
| `server.livenessProbe.successThreshold`      | Success threshold for livenessProbe                                                                              | `1`                                                  |
| `server.readinessProbe.enabled`              | Enable readinessProbe                                                                                            | `true`                                               |
| `server.readinessProbe.initialDelaySeconds`  | Initial delay seconds for readinessProbe                                                                         | `120`                                                |
| `server.readinessProbe.periodSeconds`        | Period seconds for readinessProbe                                                                                | `20`                                                 |
| `server.readinessProbe.timeoutSeconds`       | Timeout seconds for readinessProbe                                                                               | `1`                                                  |
| `server.readinessProbe.failureThreshold`     | Failure threshold for readinessProbe                                                                             | `6`                                                  |
| `server.readinessProbe.successThreshold`     | Success threshold for readinessProbe                                                                             | `1`                                                  |
| `server.customLivenessProbe`                 | Override default liveness probe                                                                                  | `{}`                                                 |
| `server.customReadinessProbe`                | Override default readiness probe                                                                                 | `{}`                                                 |
| `server.service.type`                        | Kubernetes service type                                                                                          | `ClusterIP`                                          |
| `server.service.port`                        | Service HTTP port                                                                                                | `8080`                                               |
| `server.service.nodePort`                    | Specify the nodePort value for the LoadBalancer and NodePort service types                                       | `""`                                                 |
| `server.service.clusterIP`                   | Dataflow server service cluster IP                                                                               | `""`                                                 |
| `server.service.externalTrafficPolicy`       | Enable client source IP preservation                                                                             | `Cluster`                                            |
| `server.service.loadBalancerIP`              | Load balancer IP if service type is `LoadBalancer`                                                               | `""`                                                 |
| `server.service.loadBalancerSourceRanges`    | Addresses that are allowed when service is LoadBalancer                                                          | `[]`                                                 |
| `server.service.annotations`                 | Provide any additional annotations which may be required. Evaluated as a template.                               | `{}`                                                 |
| `server.ingress.enabled`                     | Enable ingress controller resource                                                                               | `false`                                              |
| `server.ingress.path`                        | The Path to WordPress. You may need to set this to '/*' in order to use this with ALB ingress controllers.       | `/`                                                  |
| `server.ingress.pathType`                    | Ingress path type                                                                                                | `ImplementationSpecific`                             |
| `server.ingress.certManager`                 | Set this to true in order to add the corresponding annotations for cert-manager                                  | `false`                                              |
| `server.ingress.hostname`                    | Default host for the ingress resource                                                                            | `dataflow.local`                                     |
| `server.ingress.annotations`                 | Ingress annotations                                                                                              | `{}`                                                 |
| `server.ingress.tls`                         | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                  | `false`                                              |
| `server.ingress.extraHosts`                  | The list of additional hostnames to be covered with this ingress record.                                         | `[]`                                                 |
| `server.ingress.extraTls`                    | The tls configuration for additional hostnames to be covered with this ingress record.                           | `[]`                                                 |
| `server.ingress.secrets`                     | If you're providing your own certificates, please use this to add the certificates as secrets                    | `[]`                                                 |
| `server.initContainers`                      | Add init containers to the Dataflow Server pods                                                                  | `[]`                                                 |
| `server.sidecars`                            | Add sidecars to the Dataflow Server pods                                                                         | `[]`                                                 |
| `server.pdb.create`                          | Enable/disable a Pod Disruption Budget creation                                                                  | `false`                                              |
| `server.pdb.minAvailable`                    | Minimum number/percentage of pods that should remain scheduled                                                   | `1`                                                  |
| `server.pdb.maxUnavailable`                  | Maximum number/percentage of pods that may be made unavailable                                                   | `""`                                                 |
| `server.autoscaling.enabled`                 | Enable autoscaling for Dataflow server                                                                           | `false`                                              |
| `server.autoscaling.minReplicas`             | Minimum number of Dataflow server replicas                                                                       | `""`                                                 |
| `server.autoscaling.maxReplicas`             | Maximum number of Dataflow server replicas                                                                       | `""`                                                 |
| `server.autoscaling.targetCPU`               | Target CPU utilization percentage                                                                                | `""`                                                 |
| `server.autoscaling.targetMemory`            | Target Memory utilization percentage                                                                             | `""`                                                 |
| `server.extraVolumes`                        | Extra Volumes to be set on the Dataflow Server Pod                                                               | `[]`                                                 |
| `server.extraVolumeMounts`                   | Extra VolumeMounts to be set on the Dataflow Container                                                           | `[]`                                                 |
| `server.jdwp.enabled`                        | Set to true to enable Java debugger                                                                              | `false`                                              |
| `server.jdwp.port`                           | Specify port for remote debugging                                                                                | `5005`                                               |
| `server.proxy`                               | Add proxy configuration for SCDF server                                                                          | `{}`                                                 |


### Dataflow Skipper parameters

| Name                                         | Description                                                                                               | Value                          |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `skipper.enabled`                            | Enable Spring Cloud Skipper component                                                                     | `true`                         |
| `skipper.hostAliases`                        | Deployment pod host aliases                                                                               | `[]`                           |
| `skipper.image.registry`                     | Spring Cloud Skipper image registry                                                                       | `docker.io`                    |
| `skipper.image.repository`                   | Spring Cloud Skipper image repository                                                                     | `bitnami/spring-cloud-skipper` |
| `skipper.image.tag`                          | Spring Cloud Skipper image tag (immutable tags are recommended)                                           | `2.7.2-debian-10-r22`          |
| `skipper.image.pullPolicy`                   | Spring Cloud Skipper image pull policy                                                                    | `IfNotPresent`                 |
| `skipper.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                          | `[]`                           |
| `skipper.image.debug`                        | Enable image debug mode                                                                                   | `false`                        |
| `skipper.configuration.accountName`          | The name of the account to configure for the Kubernetes platform                                          | `default`                      |
| `skipper.configuration.trustK8sCerts`        | Trust K8s certificates when querying the Kubernetes API                                                   | `false`                        |
| `skipper.existingConfigmap`                  | Name of existing ConfigMap with Skipper server configuration                                              | `""`                           |
| `skipper.extraEnvVars`                       | Extra environment variables to be set on Skipper server container                                         | `[]`                           |
| `skipper.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra environment variables                                         | `""`                           |
| `skipper.extraEnvVarsSecret`                 | Name of existing Secret containing extra environment variables                                            | `""`                           |
| `skipper.replicaCount`                       | Number of Skipper server replicas to deploy                                                               | `1`                            |
| `skipper.strategyType`                       | Deployment Strategy Type                                                                                  | `RollingUpdate`                |
| `skipper.podAffinityPreset`                  | Skipper pod affinity preset. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `skipper.podAntiAffinityPreset`              | Skipper pod anti-affinity preset. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `skipper.nodeAffinityPreset.type`            | Skipper node affinity preset type. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `skipper.nodeAffinityPreset.key`             | Skipper node label key to match Ignored if `skipper.affinity` is set.                                     | `""`                           |
| `skipper.nodeAffinityPreset.values`          | Skipper node label values to match. Ignored if `skipper.affinity` is set.                                 | `[]`                           |
| `skipper.affinity`                           | Skipper affinity for pod assignment                                                                       | `{}`                           |
| `skipper.nodeSelector`                       | Skipper node labels for pod assignment                                                                    | `{}`                           |
| `skipper.tolerations`                        | Skipper tolerations for pod assignment                                                                    | `[]`                           |
| `skipper.podAnnotations`                     | Annotations for Skipper server pods                                                                       | `{}`                           |
| `skipper.priorityClassName`                  | Controller priorityClassName                                                                              | `""`                           |
| `skipper.podSecurityContext.fsGroup`         | Group ID for the volumes of the pod                                                                       | `1001`                         |
| `skipper.containerSecurityContext.runAsUser` | Set Dataflow Skipper container's Security Context runAsUser                                               | `1001`                         |
| `skipper.resources.limits`                   | The resources limits for the Skipper server container                                                     | `{}`                           |
| `skipper.resources.requests`                 | The requested resources for the Skipper server container                                                  | `{}`                           |
| `skipper.livenessProbe.enabled`              | Enable livenessProbe                                                                                      | `true`                         |
| `skipper.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                   | `120`                          |
| `skipper.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                          | `20`                           |
| `skipper.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                         | `1`                            |
| `skipper.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                       | `6`                            |
| `skipper.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                       | `1`                            |
| `skipper.readinessProbe.enabled`             | Enable readinessProbe                                                                                     | `true`                         |
| `skipper.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                  | `120`                          |
| `skipper.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                         | `20`                           |
| `skipper.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                        | `1`                            |
| `skipper.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                      | `6`                            |
| `skipper.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                      | `1`                            |
| `skipper.customLivenessProbe`                | Override default liveness probe                                                                           | `{}`                           |
| `skipper.customReadinessProbe`               | Override default readiness probe                                                                          | `{}`                           |
| `skipper.service.type`                       | Kubernetes service type                                                                                   | `ClusterIP`                    |
| `skipper.service.port`                       | Service HTTP port                                                                                         | `80`                           |
| `skipper.service.nodePort`                   | Service HTTP node port                                                                                    | `""`                           |
| `skipper.service.clusterIP`                  | Skipper server service cluster IP                                                                         | `""`                           |
| `skipper.service.externalTrafficPolicy`      | Enable client source IP preservation                                                                      | `Cluster`                      |
| `skipper.service.loadBalancerIP`             | Load balancer IP if service type is `LoadBalancer`                                                        | `""`                           |
| `skipper.service.loadBalancerSourceRanges`   | Address that are allowed when service is LoadBalancer                                                     | `[]`                           |
| `skipper.service.annotations`                | Annotations for Skipper server service                                                                    | `{}`                           |
| `skipper.initContainers`                     | Add init containers to the Dataflow Skipper pods                                                          | `[]`                           |
| `skipper.sidecars`                           | Add sidecars to the Skipper pods                                                                          | `[]`                           |
| `skipper.pdb.create`                         | Enable/disable a Pod Disruption Budget creation                                                           | `false`                        |
| `skipper.pdb.minAvailable`                   | Minimum number/percentage of pods that should remain scheduled                                            | `1`                            |
| `skipper.pdb.maxUnavailable`                 | Maximum number/percentage of pods that may be made unavailable                                            | `""`                           |
| `skipper.autoscaling.enabled`                | Enable autoscaling for Skipper server                                                                     | `false`                        |
| `skipper.autoscaling.minReplicas`            | Minimum number of Skipper server replicas                                                                 | `""`                           |
| `skipper.autoscaling.maxReplicas`            | Maximum number of Skipper server replicas                                                                 | `""`                           |
| `skipper.autoscaling.targetCPU`              | Target CPU utilization percentage                                                                         | `""`                           |
| `skipper.autoscaling.targetMemory`           | Target Memory utilization percentage                                                                      | `""`                           |
| `skipper.extraVolumes`                       | Extra Volumes to be set on the Skipper Pod                                                                | `[]`                           |
| `skipper.extraVolumeMounts`                  | Extra VolumeMounts to be set on the Skipper Container                                                     | `[]`                           |
| `skipper.jdwp.enabled`                       | Enable Java Debug Wire Protocol (JDWP)                                                                    | `false`                        |
| `skipper.jdwp.port`                          | JDWP TCP port for remote debugging                                                                        | `5005`                         |
| `externalSkipper.host`                       | Host of a external Skipper Server                                                                         | `localhost`                    |
| `externalSkipper.port`                       | External Skipper Server port number                                                                       | `7577`                         |


### Deployer parameters

| Name                                          | Description                                                                                 | Value  |
| --------------------------------------------- | ------------------------------------------------------------------------------------------- | ------ |
| `deployer.resources.limits`                   | Streaming applications resource limits                                                      | `{}`   |
| `deployer.resources.requests`                 | Streaming applications resource requests                                                    | `{}`   |
| `deployer.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                     | `90`   |
| `deployer.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                    | `120`  |
| `deployer.nodeSelector`                       | The node selectors to apply to the streaming applications deployments in "key:value" format | `""`   |
| `deployer.tolerations`                        | Streaming applications tolerations                                                          | `{}`   |
| `deployer.volumeMounts`                       | Streaming applications extra volume mounts                                                  | `{}`   |
| `deployer.volumes`                            | Streaming applications extra volumes                                                        | `{}`   |
| `deployer.environmentVariables`               | Streaming applications environment variables                                                | `""`   |
| `deployer.podSecurityContext.runAsUser`       | Set Dataflow Streams container's Security Context runAsUser                                 | `1001` |


### RBAC parameters

| Name                    | Description                                                                         | Value  |
| ----------------------- | ----------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create` | Enable the creation of a ServiceAccount for Dataflow server and Skipper server pods | `true` |
| `serviceAccount.name`   | Name of the created serviceAccount                                                  | `""`   |
| `rbac.create`           | Whether to create and use RBAC resources or not                                     | `true` |


### Metrics parameters

| Name                                   | Description                                                                                                                | Value                              |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `metrics.enabled`                      | Enable Prometheus metrics                                                                                                  | `false`                            |
| `metrics.image.registry`               | Prometheus Rsocket Proxy image registry                                                                                    | `docker.io`                        |
| `metrics.image.repository`             | Prometheus Rsocket Proxy image repository                                                                                  | `bitnami/prometheus-rsocket-proxy` |
| `metrics.image.tag`                    | Prometheus Rsocket Proxy image tag (immutable tags are recommended)                                                        | `1.3.0-debian-10-r270`             |
| `metrics.image.pullPolicy`             | Prometheus Rsocket Proxy image pull policy                                                                                 | `IfNotPresent`                     |
| `metrics.image.pullSecrets`            | Specify docker-registry secret names as an array                                                                           | `[]`                               |
| `metrics.resources.limits`             | The resources limits for the Prometheus Rsocket Proxy container                                                            | `{}`                               |
| `metrics.resources.requests`           | The requested resources for the Prometheus Rsocket Proxy container                                                         | `{}`                               |
| `metrics.replicaCount`                 | Number of Prometheus Rsocket Proxy replicas to deploy                                                                      | `1`                                |
| `metrics.podAffinityPreset`            | Prometheus Rsocket Proxy pod affinity preset. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`       | `""`                               |
| `metrics.podAntiAffinityPreset`        | Prometheus Rsocket Proxy pod anti-affinity preset. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                             |
| `metrics.nodeAffinityPreset.type`      | Prometheus Rsocket Proxy node affinity preset type. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard` | `""`                               |
| `metrics.nodeAffinityPreset.key`       | Prometheus Rsocket Proxy node label key to match Ignored if `metrics.affinity` is set.                                     | `""`                               |
| `metrics.nodeAffinityPreset.values`    | Prometheus Rsocket Proxy node label values to match. Ignored if `metrics.affinity` is set.                                 | `[]`                               |
| `metrics.affinity`                     | Prometheus Rsocket Proxy affinity for pod assignment                                                                       | `{}`                               |
| `metrics.nodeSelector`                 | Prometheus Rsocket Proxy node labels for pod assignment                                                                    | `{}`                               |
| `metrics.tolerations`                  | Prometheus Rsocket Proxy tolerations for pod assignment                                                                    | `[]`                               |
| `metrics.podAnnotations`               | Annotations for Prometheus Rsocket Proxy pods                                                                              | `{}`                               |
| `metrics.priorityClassName`            | Prometheus Rsocket Proxy pods' priority.                                                                                   | `""`                               |
| `metrics.service.httpPort`             | Prometheus Rsocket Proxy HTTP port                                                                                         | `8080`                             |
| `metrics.service.rsocketPort`          | Prometheus Rsocket Proxy Rsocket port                                                                                      | `7001`                             |
| `metrics.service.annotations`          | Annotations for the Prometheus Rsocket Proxy service                                                                       | `{}`                               |
| `metrics.serviceMonitor.enabled`       | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                     | `false`                            |
| `metrics.serviceMonitor.extraLabels`   | Labels to add to ServiceMonitor, in case prometheus operator is configured with serviceMonitorSelector                     | `{}`                               |
| `metrics.serviceMonitor.namespace`     | Namespace in which ServiceMonitor is created if different from release                                                     | `""`                               |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped.                                                                               | `""`                               |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                                    | `""`                               |
| `metrics.pdb.create`                   | Enable/disable a Pod Disruption Budget creation                                                                            | `false`                            |
| `metrics.pdb.minAvailable`             | Minimum number/percentage of pods that should remain scheduled                                                             | `1`                                |
| `metrics.pdb.maxUnavailable`           | Maximum number/percentage of pods that may be made unavailable                                                             | `""`                               |
| `metrics.autoscaling.enabled`          | Enable autoscaling for Prometheus Rsocket Proxy                                                                            | `false`                            |
| `metrics.autoscaling.minReplicas`      | Minimum number of Prometheus Rsocket Proxy replicas                                                                        | `""`                               |
| `metrics.autoscaling.maxReplicas`      | Maximum number of Prometheus Rsocket Proxy replicas                                                                        | `""`                               |
| `metrics.autoscaling.targetCPU`        | Target CPU utilization percentage                                                                                          | `""`                               |
| `metrics.autoscaling.targetMemory`     | Target Memory utilization percentage                                                                                       | `""`                               |


### Init Container parameters

| Name                                 | Description                                                                                       | Value                  |
| ------------------------------------ | ------------------------------------------------------------------------------------------------- | ---------------------- |
| `waitForBackends.enabled`            | Wait for the database and other services (such as Kafka or RabbitMQ) used when enabling streaming | `true`                 |
| `waitForBackends.image.registry`     | Init container wait-for-backend image registry                                                    | `docker.io`            |
| `waitForBackends.image.repository`   | Init container wait-for-backend image name                                                        | `bitnami/kubectl`      |
| `waitForBackends.image.tag`          | Init container wait-for-backend image tag                                                         | `1.19.15-debian-10-r4` |
| `waitForBackends.image.pullPolicy`   | Init container wait-for-backend image pull policy                                                 | `IfNotPresent`         |
| `waitForBackends.image.pullSecrets`  | Specify docker-registry secret names as an array                                                  | `[]`                   |
| `waitForBackends.resources.limits`   | Init container wait-for-backend resource limits                                                   | `{}`                   |
| `waitForBackends.resources.requests` | Init container wait-for-backend resource requests                                                 | `{}`                   |


### Database parameters

| Name                                      | Description                                                                                         | Value        |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------ |
| `mariadb.enabled`                         | Enable/disable MariaDB chart installation                                                           | `true`       |
| `mariadb.architecture`                    | MariaDB architecture. Allowed values: `standalone` or `replication`                                 | `standalone` |
| `mariadb.auth.rootPassword`               | Password for the MariaDB `root` user                                                                | `""`         |
| `mariadb.auth.username`                   | Username of new user to create                                                                      | `dataflow`   |
| `mariadb.auth.password`                   | Password for the new user                                                                           | `change-me`  |
| `mariadb.auth.database`                   | Database name to create                                                                             | `dataflow`   |
| `mariadb.auth.forcePassword`              | Force users to specify required passwords in the database                                           | `false`      |
| `mariadb.auth.usePasswordFiles`           | Mount credentials as a file instead of using an environment variable                                | `false`      |
| `mariadb.initdbScripts`                   | Specify dictionary of scripts to be run at first boot                                               | `{}`         |
| `flyway.enabled`                          | Enable/disable flyway running Dataflow and Skipper Database creation scripts on startup             | `true`       |
| `externalDatabase.host`                   | Host of the external database                                                                       | `localhost`  |
| `externalDatabase.port`                   | External database port number                                                                       | `3306`       |
| `externalDatabase.driver`                 | The fully qualified name of the JDBC Driver class                                                   | `""`         |
| `externalDatabase.scheme`                 | The scheme is a vendor-specific or shared protocol string that follows the "jdbc:" of the URL       | `""`         |
| `externalDatabase.password`               | Password for the above username                                                                     | `""`         |
| `externalDatabase.existingPasswordSecret` | Existing secret with database password                                                              | `""`         |
| `externalDatabase.existingPasswordKey`    | Key of the existing secret with database password, defaults to `datasource-password`                | `""`         |
| `externalDatabase.dataflow.url`           | JDBC URL for dataflow server. Overrides external scheme, host, port, database, and jdbc parameters. | `""`         |
| `externalDatabase.dataflow.database`      | Name of the existing database to be used by Dataflow server                                         | `dataflow`   |
| `externalDatabase.dataflow.username`      | Existing username in the external db to be used by Dataflow server                                  | `dataflow`   |
| `externalDatabase.skipper.url`            | JDBC URL for skipper. Overrides external scheme, host, port, database, and jdbc parameters.         | `""`         |
| `externalDatabase.skipper.database`       | Name of the existing database to be used by Skipper server                                          | `skipper`    |
| `externalDatabase.skipper.username`       | Existing username in the external db to be used by Skipper server                                   | `skipper`    |
| `externalDatabase.hibernateDialect`       | Hibernate Dialect used by Dataflow/Skipper servers                                                  | `""`         |


### RabbitMQ chart parameters

| Name                                      | Description                                                                     | Value       |
| ----------------------------------------- | ------------------------------------------------------------------------------- | ----------- |
| `rabbitmq.enabled`                        | Enable/disable RabbitMQ chart installation                                      | `true`      |
| `rabbitmq.auth.username`                  | RabbitMQ username                                                               | `user`      |
| `externalRabbitmq.enabled`                | Enable/disable external RabbitMQ                                                | `false`     |
| `externalRabbitmq.host`                   | Host of the external RabbitMQ                                                   | `localhost` |
| `externalRabbitmq.port`                   | External RabbitMQ port number                                                   | `5672`      |
| `externalRabbitmq.username`               | External RabbitMQ username                                                      | `guest`     |
| `externalRabbitmq.password`               | External RabbitMQ password. It will be saved in a kubernetes secret             | `guest`     |
| `externalRabbitmq.vhost`                  | External RabbitMQ virtual host. It will be saved in a kubernetes secret         | `""`        |
| `externalRabbitmq.existingPasswordSecret` | Existing secret with RabbitMQ password. It will be saved in a kubernetes secret | `""`        |


### Kafka chart parameters

| Name                                  | Description                             | Value            |
| ------------------------------------- | --------------------------------------- | ---------------- |
| `kafka.enabled`                       | Enable/disable Kafka chart installation | `false`          |
| `kafka.replicaCount`                  | Number of Kafka brokers                 | `1`              |
| `kafka.offsetsTopicReplicationFactor` | Kafka Secret Key                        | `1`              |
| `kafka.zookeeper.replicaCount`        | Number of Zookeeper replicas            | `1`              |
| `externalKafka.enabled`               | Enable/disable external Kafka           | `false`          |
| `externalKafka.brokers`               | External Kafka brokers                  | `localhost:9092` |
| `externalKafka.zkNodes`               | External Zookeeper nodes                | `localhost:2181` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set server.replicaCount=2 bitnami/spring-cloud-dataflow
```

The above command install Spring Cloud Data Flow chart with 2 Dataflow server replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml bitnami/spring-cloud-dataflow
```

> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/blob/master/bitnami/spring-cloud-dataflow/values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Disable specific features

If you only need to deploy tasks and schedules, streaming and Skipper can be disabled by setting the `server.configuration.streamingEnabled`, `skipper.enabled` and `rabbitmq.enabled` parameters to `false`.

If you only need to deploy streams, tasks and schedules can be disabled by setting the `server.configuration.batchEnabled` parameter to `false`.

NOTE: Both `server.configuration.batchEnabled` and `server.configuration.streamingEnabled` should not be set to `false` at the same time.

For more information and example configuration, refer to the [chart documentation on disabling features](https://docs.bitnami.com/kubernetes/infrastructure/spring-cloud-dataflow/configuration/disable-streaming-batch-features/).

### Select a different messaging solution

There are two supported messaging solutions in this chart: RabbitMQ (default) and Kafka.

To change the messaging layer to Kafka, use the the following configuration:

```console
rabbitmq.enabled=false
kafka.enabled=true
```

NOTE: Only one messaging layer can be used at a given time.

### Use an external database

Sometimes, you may want to have Spring Cloud components connect to an external database rather than a database within your cluster - for example, when using a managed database service, or when running a single database server for all your applications. To do this, set the `mariadb.enabled` parameter to `false` and specify the credentials for the external database using the `externalDatabase.*` parameters.

Refer to the [chart documentation on using an external database](https://docs.bitnami.com/kubernetes/infrastructure/spring-cloud-dataflow/configuration/use-external-database/) for more details and an example.

### Add extra environment variables

In case you want to add extra environment variables to any Spring Cloud component, you can use `XXX.extraEnvs` parameter(s), where XXX is placeholder you need to replace with the actual component(s). For instance, to add extra flags to Spring Cloud Data Flow, use:

```yaml
server:
  extraEnvs:
    - name: FOO
      value: BAR
```

### Use custom Dataflow configuration

This Helm chart supports using custom configuration for the Dataflow server. Specify the configuration for the Dataflow server by setting the `server.existingConfigmap` parameter to an external ConfigMap with the configuration file.

### Use custom Skipper configuration

This Helm chart supports using custom configuration for the Skipper server. Specify the configuration for the Skipper server by setting the `skipper.existingConfigmap` parameter to an external ConfigMap with the configuration file.

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as EJBCA (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. Similarly, you can add extra init containers using the `initContainers` parameter.

[Learn more about configuring and using sidecar and init containers](https://docs.bitnami.com/kubernetes/infrastructure/spring-cloud-dataflow/configuration/configure-sidecar-init-containers/).

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `server.ingress.enabled` to `true`. The `server.ingress.hostname` property can be used to set the host name. The `server.ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/infrastructure/spring-cloud-dataflow/configuration/configure-ingress/).

### Configure TLS Secrets for use with Ingress

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/ghost/administration/enable-tls-ingress/).

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use any of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

If you enabled RabbitMQ chart to be used as the messaging solution for Skipper to manage streaming content, then it's necessary to set the `rabbitmq.auth.password` and `rabbitmq.auth.erlangCookie` parameters when upgrading for readiness/liveness probes to work properly. Inspect the RabbitMQ secret to obtain the password and the Erlang cookie, then you can upgrade your chart using the command below:

### To 4.0.0

This major updates the Kafka subchart its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1400) you can find more information about the changes introduced in this version.

### To 3.0.0

This major updates the Kafka subchart to its newest major 13.0.0. For more information on this subchart's major, please refer to [kafka upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1300).

### To 2.0.0


[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/spring-cloud-dataflow/administration/upgrade-helm3/).

### v0.x.x

```bash
helm upgrade my-release bitnami/spring-cloud-dataflow --set mariadb.rootUser.password=[MARIADB_ROOT_PASSWORD] --set rabbitmq.auth.password=[RABBITMQ_PASSWORD] --set rabbitmq.auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```

### v1.x.x

```bash
helm upgrade my-release bitnami/spring-cloud-dataflow --set mariadb.auth.rootPassword=[MARIADB_ROOT_PASSWORD] --set rabbitmq.auth.password=[RABBITMQ_PASSWORD] --set rabbitmq.auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```

## Notable changes

### v1.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `1.0.0`, you will need to reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `dataflow`):

> NOTE: Please, create a backup of your database before running any of those actions.

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default dataflow-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default dataflow-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=dataflow -o jsonpath="{.items[0].metadata.name}")
export RABBITMQ_PASSWORD=$(kubectl get secret --namespace default dataflow-rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 --decode)
export RABBITMQ_ERLANG_COOKIE=$(kubectl get secret --namespace default dataflow-rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 --decode)
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling Data Flow replicas to 0:

```console
$ helm upgrade dataflow bitnami/spring-cloud-dataflow --version 0.7.4 \
  --set server.replicaCount=0 \
  --set skipper.replicaCount=0 \
  --set mariadb.enabled=false \
  --set rabbitmq.auth.password=$RABBITMQ_PASSWORD \
  --set rabbitmq.auth.erlangCookie=$RABBITMQ_ERLANG_COOKIE
```

Finally, upgrade you release to 1.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade dataflow bitnami/spring-cloud-dataflow \
  --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC \
  --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD \
  --set mariadb.auth.password=$MARIADB_PASSWORD \
  --set rabbitmq.auth.password=$RABBITMQ_PASSWORD \
  --set rabbitmq.auth.erlangCookie=$RABBITMQ_ERLANG_COOKIE
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=dataflow,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```
