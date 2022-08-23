<!--- app-name: Spring Cloud Data Flow -->

# Spring Cloud Data Flow packaged by Bitnami

Spring Cloud Data Flow is a microservices-based toolkit for building streaming and batch data processing pipelines in Cloud Foundry and Kubernetes.

[Overview of Spring Cloud Data Flow](https://github.com/spring-cloud/spring-cloud-dataflow)


                           
## TL;DR

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/spring-cloud-dataflow
```

## Introduction

This chart bootstraps a [Spring Cloud Data Flow](https://github.com/bitnami/containers/tree/main/bitnami/spring-cloud-dataflow) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
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

| Name                | Description                                                                           | Value           |
| ------------------- | ------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override scdf.fullname template (will maintain the release name). | `""`            |
| `fullnameOverride`  | String to fully override scdf.fullname template.                                      | `""`            |
| `commonAnnotations` | Annotations to add to all deployed objects                                            | `{}`            |
| `commonLabels`      | Labels to add to all deployed objects                                                 | `{}`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                  | `""`            |
| `clusterDomain`     | Default Kubernetes cluster domain                                                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release                                     | `[]`            |


### Dataflow Server parameters

| Name                                                | Description                                                                                                                                | Value                                                |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| `server.image.registry`                             | Spring Cloud Dataflow image registry                                                                                                       | `docker.io`                                          |
| `server.image.repository`                           | Spring Cloud Dataflow image repository                                                                                                     | `bitnami/spring-cloud-dataflow`                      |
| `server.image.tag`                                  | Spring Cloud Dataflow image tag (immutable tags are recommended)                                                                           | `2.9.4-debian-11-r25`                                |
| `server.image.digest`                               | Spring Cloud Dataflow image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                      | `""`                                                 |
| `server.image.pullPolicy`                           | Spring Cloud Dataflow image pull policy                                                                                                    | `IfNotPresent`                                       |
| `server.image.pullSecrets`                          | Specify docker-registry secret names as an array                                                                                           | `[]`                                                 |
| `server.image.debug`                                | Enable image debug mode                                                                                                                    | `false`                                              |
| `server.hostAliases`                                | Deployment pod host aliases                                                                                                                | `[]`                                                 |
| `server.composedTaskRunner.image.registry`          | Spring Cloud Dataflow Composed Task Runner image registry                                                                                  | `docker.io`                                          |
| `server.composedTaskRunner.image.repository`        | Spring Cloud Dataflow Composed Task Runner image repository                                                                                | `bitnami/spring-cloud-dataflow-composed-task-runner` |
| `server.composedTaskRunner.image.tag`               | Spring Cloud Dataflow Composed Task Runner image tag (immutable tags are recommended)                                                      | `2.9.4-debian-11-r23`                                |
| `server.composedTaskRunner.image.digest`            | Spring Cloud Dataflow Composed Task Runner image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                                 |
| `server.configuration.streamingEnabled`             | Enables or disables streaming data processing                                                                                              | `true`                                               |
| `server.configuration.batchEnabled`                 | Enables or disables batch data (tasks and schedules) processing                                                                            | `true`                                               |
| `server.configuration.accountName`                  | The name of the account to configure for the Kubernetes platform                                                                           | `default`                                            |
| `server.configuration.trustK8sCerts`                | Trust K8s certificates when querying the Kubernetes API                                                                                    | `false`                                              |
| `server.configuration.containerRegistries`          | Container registries configuration                                                                                                         | `{}`                                                 |
| `server.configuration.grafanaInfo`                  | Endpoint to the grafana instance (Deprecated: use the metricsDashboard instead)                                                            | `""`                                                 |
| `server.configuration.metricsDashboard`             | Endpoint to the metricsDashboard instance                                                                                                  | `""`                                                 |
| `server.configuration.defaultSpringApplicationJSON` | Injects default values for environment variable SPRING_APPLICATION_JSON                                                                    | `true`                                               |
| `server.existingConfigmap`                          | ConfigMap with Spring Cloud Dataflow Server Configuration                                                                                  | `""`                                                 |
| `server.command`                                    | Override default container command (useful when using custom images)                                                                       | `[]`                                                 |
| `server.args`                                       | Override default container args (useful when using custom images)                                                                          | `[]`                                                 |
| `server.lifecycleHooks`                             | for the Dataflow server container(s) to automate configuration before or after startup                                                     | `{}`                                                 |
| `server.extraEnvVars`                               | Extra environment variables to be set on Dataflow server container                                                                         | `[]`                                                 |
| `server.extraEnvVarsCM`                             | ConfigMap with extra environment variables                                                                                                 | `""`                                                 |
| `server.extraEnvVarsSecret`                         | Secret with extra environment variables                                                                                                    | `""`                                                 |
| `server.replicaCount`                               | Number of Dataflow server replicas to deploy                                                                                               | `1`                                                  |
| `server.podAffinityPreset`                          | Dataflow server pod affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                 | `""`                                                 |
| `server.podAntiAffinityPreset`                      | Dataflow server pod anti-affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                            | `soft`                                               |
| `server.containerPort`                              | Dataflow server port                                                                                                                       | `8080`                                               |
| `server.nodeAffinityPreset.type`                    | Dataflow server node affinity preset type. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                           | `""`                                                 |
| `server.nodeAffinityPreset.key`                     | Dataflow server node label key to match Ignored if `server.affinity` is set.                                                               | `""`                                                 |
| `server.nodeAffinityPreset.values`                  | Dataflow server node label values to match. Ignored if `server.affinity` is set.                                                           | `[]`                                                 |
| `server.affinity`                                   | Dataflow server affinity for pod assignment                                                                                                | `{}`                                                 |
| `server.nodeSelector`                               | Dataflow server node labels for pod assignment                                                                                             | `{}`                                                 |
| `server.tolerations`                                | Dataflow server tolerations for pod assignment                                                                                             | `[]`                                                 |
| `server.podAnnotations`                             | Annotations for Dataflow server pods                                                                                                       | `{}`                                                 |
| `server.updateStrategy.type`                        | Deployment strategy type for Dataflow server pods.                                                                                         | `RollingUpdate`                                      |
| `server.podLabels`                                  | Extra labels for Dataflow Server pods                                                                                                      | `{}`                                                 |
| `server.priorityClassName`                          | Dataflow Server pods' priority                                                                                                             | `""`                                                 |
| `server.schedulerName`                              | Name of the k8s scheduler (other than default)                                                                                             | `""`                                                 |
| `server.topologySpreadConstraints`                  | Topology Spread Constraints for pod assignment                                                                                             | `[]`                                                 |
| `server.podSecurityContext.enabled`                 | Enabled Dataflow Server pods' Security Context                                                                                             | `true`                                               |
| `server.podSecurityContext.fsGroup`                 | Group ID for the volumes of the pod                                                                                                        | `1001`                                               |
| `server.containerSecurityContext.enabled`           | Enabled Dataflow Server containers' Security Context                                                                                       | `true`                                               |
| `server.containerSecurityContext.runAsUser`         | Set Dataflow Server container's Security Context runAsUser                                                                                 | `1001`                                               |
| `server.resources.limits`                           | The resources limits for the Dataflow server container                                                                                     | `{}`                                                 |
| `server.resources.requests`                         | The requested resources for the Dataflow server container                                                                                  | `{}`                                                 |
| `server.startupProbe.enabled`                       | Enable startupProbe                                                                                                                        | `false`                                              |
| `server.startupProbe.initialDelaySeconds`           | Initial delay seconds for startupProbe                                                                                                     | `120`                                                |
| `server.startupProbe.periodSeconds`                 | Period seconds for startupProbe                                                                                                            | `20`                                                 |
| `server.startupProbe.timeoutSeconds`                | Timeout seconds for startupProbe                                                                                                           | `1`                                                  |
| `server.startupProbe.failureThreshold`              | Failure threshold for startupProbe                                                                                                         | `6`                                                  |
| `server.startupProbe.successThreshold`              | Success threshold for startupProbe                                                                                                         | `1`                                                  |
| `server.livenessProbe.enabled`                      | Enable livenessProbe                                                                                                                       | `true`                                               |
| `server.livenessProbe.initialDelaySeconds`          | Initial delay seconds for livenessProbe                                                                                                    | `120`                                                |
| `server.livenessProbe.periodSeconds`                | Period seconds for livenessProbe                                                                                                           | `20`                                                 |
| `server.livenessProbe.timeoutSeconds`               | Timeout seconds for livenessProbe                                                                                                          | `1`                                                  |
| `server.livenessProbe.failureThreshold`             | Failure threshold for livenessProbe                                                                                                        | `6`                                                  |
| `server.livenessProbe.successThreshold`             | Success threshold for livenessProbe                                                                                                        | `1`                                                  |
| `server.readinessProbe.enabled`                     | Enable readinessProbe                                                                                                                      | `true`                                               |
| `server.readinessProbe.initialDelaySeconds`         | Initial delay seconds for readinessProbe                                                                                                   | `120`                                                |
| `server.readinessProbe.periodSeconds`               | Period seconds for readinessProbe                                                                                                          | `20`                                                 |
| `server.readinessProbe.timeoutSeconds`              | Timeout seconds for readinessProbe                                                                                                         | `1`                                                  |
| `server.readinessProbe.failureThreshold`            | Failure threshold for readinessProbe                                                                                                       | `6`                                                  |
| `server.readinessProbe.successThreshold`            | Success threshold for readinessProbe                                                                                                       | `1`                                                  |
| `server.customStartupProbe`                         | Override default startup probe                                                                                                             | `{}`                                                 |
| `server.customLivenessProbe`                        | Override default liveness probe                                                                                                            | `{}`                                                 |
| `server.customReadinessProbe`                       | Override default readiness probe                                                                                                           | `{}`                                                 |
| `server.service.type`                               | Kubernetes service type                                                                                                                    | `ClusterIP`                                          |
| `server.service.port`                               | Service HTTP port                                                                                                                          | `8080`                                               |
| `server.service.nodePort`                           | Specify the nodePort value for the LoadBalancer and NodePort service types                                                                 | `""`                                                 |
| `server.service.clusterIP`                          | Dataflow server service cluster IP                                                                                                         | `""`                                                 |
| `server.service.externalTrafficPolicy`              | Enable client source IP preservation                                                                                                       | `Cluster`                                            |
| `server.service.loadBalancerIP`                     | Load balancer IP if service type is `LoadBalancer`                                                                                         | `""`                                                 |
| `server.service.loadBalancerSourceRanges`           | Addresses that are allowed when service is LoadBalancer                                                                                    | `[]`                                                 |
| `server.service.extraPorts`                         | Extra ports to expose (normally used with the `sidecar` value)                                                                             | `[]`                                                 |
| `server.service.annotations`                        | Provide any additional annotations which may be required. Evaluated as a template.                                                         | `{}`                                                 |
| `server.service.sessionAffinity`                    | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                       | `None`                                               |
| `server.service.sessionAffinityConfig`              | Additional settings for the sessionAffinity                                                                                                | `{}`                                                 |
| `server.ingress.enabled`                            | Enable ingress controller resource                                                                                                         | `false`                                              |
| `server.ingress.path`                               | The Path to WordPress. You may need to set this to '/*' in order to use this with ALB ingress controllers.                                 | `/`                                                  |
| `server.ingress.apiVersion`                         | Force Ingress API version (automatically detected if not set)                                                                              | `""`                                                 |
| `server.ingress.pathType`                           | Ingress path type                                                                                                                          | `ImplementationSpecific`                             |
| `server.ingress.hostname`                           | Default host for the ingress resource                                                                                                      | `dataflow.local`                                     |
| `server.ingress.annotations`                        | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.           | `{}`                                                 |
| `server.ingress.tls`                                | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                            | `false`                                              |
| `server.ingress.certManager`                        | Add the corresponding annotations for cert-manager integration                                                                             | `false`                                              |
| `server.ingress.extraHosts`                         | The list of additional hostnames to be covered with this ingress record.                                                                   | `[]`                                                 |
| `server.ingress.extraPaths`                         | An array with additional arbitrary paths that may need to be added to the ingress under the main host                                      | `[]`                                                 |
| `server.ingress.extraTls`                           | The tls configuration for additional hostnames to be covered with this ingress record.                                                     | `[]`                                                 |
| `server.ingress.secrets`                            | If you're providing your own certificates, please use this to add the certificates as secrets                                              | `[]`                                                 |
| `server.ingress.ingressClassName`                   | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                              | `""`                                                 |
| `server.ingress.extraRules`                         | Additional rules to be covered with this ingress record                                                                                    | `[]`                                                 |
| `server.initContainers`                             | Add init containers to the Dataflow Server pods                                                                                            | `[]`                                                 |
| `server.sidecars`                                   | Add sidecars to the Dataflow Server pods                                                                                                   | `[]`                                                 |
| `server.pdb.create`                                 | Enable/disable a Pod Disruption Budget creation                                                                                            | `false`                                              |
| `server.pdb.minAvailable`                           | Minimum number/percentage of pods that should remain scheduled                                                                             | `1`                                                  |
| `server.pdb.maxUnavailable`                         | Maximum number/percentage of pods that may be made unavailable                                                                             | `""`                                                 |
| `server.autoscaling.enabled`                        | Enable autoscaling for Dataflow server                                                                                                     | `false`                                              |
| `server.autoscaling.minReplicas`                    | Minimum number of Dataflow server replicas                                                                                                 | `""`                                                 |
| `server.autoscaling.maxReplicas`                    | Maximum number of Dataflow server replicas                                                                                                 | `""`                                                 |
| `server.autoscaling.targetCPU`                      | Target CPU utilization percentage                                                                                                          | `""`                                                 |
| `server.autoscaling.targetMemory`                   | Target Memory utilization percentage                                                                                                       | `""`                                                 |
| `server.extraVolumes`                               | Extra Volumes to be set on the Dataflow Server Pod                                                                                         | `[]`                                                 |
| `server.extraVolumeMounts`                          | Extra VolumeMounts to be set on the Dataflow Container                                                                                     | `[]`                                                 |
| `server.jdwp.enabled`                               | Set to true to enable Java debugger                                                                                                        | `false`                                              |
| `server.jdwp.port`                                  | Specify port for remote debugging                                                                                                          | `5005`                                               |
| `server.proxy`                                      | Add proxy configuration for SCDF server                                                                                                    | `{}`                                                 |
| `server.applicationProperties`                      | Specify common application properties added by SCDF server to streams and/or tasks                                                         | `{}`                                                 |


### Dataflow Skipper parameters

| Name                                         | Description                                                                                                          | Value                          |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `skipper.enabled`                            | Enable Spring Cloud Skipper component                                                                                | `true`                         |
| `skipper.hostAliases`                        | Deployment pod host aliases                                                                                          | `[]`                           |
| `skipper.image.registry`                     | Spring Cloud Skipper image registry                                                                                  | `docker.io`                    |
| `skipper.image.repository`                   | Spring Cloud Skipper image repository                                                                                | `bitnami/spring-cloud-skipper` |
| `skipper.image.tag`                          | Spring Cloud Skipper image tag (immutable tags are recommended)                                                      | `2.8.4-debian-11-r25`          |
| `skipper.image.digest`                       | Spring Cloud Skipper image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                           |
| `skipper.image.pullPolicy`                   | Spring Cloud Skipper image pull policy                                                                               | `IfNotPresent`                 |
| `skipper.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                     | `[]`                           |
| `skipper.image.debug`                        | Enable image debug mode                                                                                              | `false`                        |
| `skipper.configuration.accountName`          | The name of the account to configure for the Kubernetes platform                                                     | `default`                      |
| `skipper.configuration.trustK8sCerts`        | Trust K8s certificates when querying the Kubernetes API                                                              | `false`                        |
| `skipper.existingConfigmap`                  | Name of existing ConfigMap with Skipper server configuration                                                         | `""`                           |
| `skipper.command`                            | Override default container command (useful when using custom images)                                                 | `[]`                           |
| `skipper.args`                               | Override default container args (useful when using custom images)                                                    | `[]`                           |
| `skipper.lifecycleHooks`                     | for the Skipper container(s) to automate configuration before or after startup                                       | `{}`                           |
| `skipper.extraEnvVars`                       | Extra environment variables to be set on Skipper server container                                                    | `[]`                           |
| `skipper.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra environment variables                                                    | `""`                           |
| `skipper.extraEnvVarsSecret`                 | Name of existing Secret containing extra environment variables                                                       | `""`                           |
| `skipper.replicaCount`                       | Number of Skipper server replicas to deploy                                                                          | `1`                            |
| `skipper.podAffinityPreset`                  | Skipper pod affinity preset. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard`                  | `""`                           |
| `skipper.podAntiAffinityPreset`              | Skipper pod anti-affinity preset. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard`             | `soft`                         |
| `skipper.nodeAffinityPreset.type`            | Skipper node affinity preset type. Ignored if `skipper.affinity` is set. Allowed values: `soft` or `hard`            | `""`                           |
| `skipper.nodeAffinityPreset.key`             | Skipper node label key to match Ignored if `skipper.affinity` is set.                                                | `""`                           |
| `skipper.nodeAffinityPreset.values`          | Skipper node label values to match. Ignored if `skipper.affinity` is set.                                            | `[]`                           |
| `skipper.affinity`                           | Skipper affinity for pod assignment                                                                                  | `{}`                           |
| `skipper.nodeSelector`                       | Skipper node labels for pod assignment                                                                               | `{}`                           |
| `skipper.tolerations`                        | Skipper tolerations for pod assignment                                                                               | `[]`                           |
| `skipper.podAnnotations`                     | Annotations for Skipper server pods                                                                                  | `{}`                           |
| `skipper.updateStrategy.type`                | Deployment strategy type for Skipper server pods.                                                                    | `RollingUpdate`                |
| `skipper.podLabels`                          | Extra labels for Skipper pods                                                                                        | `{}`                           |
| `skipper.priorityClassName`                  | Controller priorityClassName                                                                                         | `""`                           |
| `skipper.schedulerName`                      | Name of the k8s scheduler (other than default)                                                                       | `""`                           |
| `skipper.topologySpreadConstraints`          | Topology Spread Constraints for pod assignment                                                                       | `[]`                           |
| `skipper.podSecurityContext.enabled`         | Enabled Skipper pods' Security Context                                                                               | `true`                         |
| `skipper.podSecurityContext.fsGroup`         | Group ID for the volumes of the pod                                                                                  | `1001`                         |
| `skipper.containerSecurityContext.enabled`   | Enabled Datafkiw Skipper containers' Security Context                                                                | `true`                         |
| `skipper.containerSecurityContext.runAsUser` | Set Dataflow Skipper container's Security Context runAsUser                                                          | `1001`                         |
| `skipper.resources.limits`                   | The resources limits for the Skipper server container                                                                | `{}`                           |
| `skipper.resources.requests`                 | The requested resources for the Skipper server container                                                             | `{}`                           |
| `skipper.startupProbe.enabled`               | Enable startupProbe                                                                                                  | `false`                        |
| `skipper.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                               | `120`                          |
| `skipper.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                                      | `20`                           |
| `skipper.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                                     | `1`                            |
| `skipper.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                                   | `6`                            |
| `skipper.startupProbe.successThreshold`      | Success threshold for startupProbe                                                                                   | `1`                            |
| `skipper.livenessProbe.enabled`              | Enable livenessProbe                                                                                                 | `true`                         |
| `skipper.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                              | `120`                          |
| `skipper.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                                     | `20`                           |
| `skipper.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                                    | `1`                            |
| `skipper.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                                  | `6`                            |
| `skipper.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                                  | `1`                            |
| `skipper.readinessProbe.enabled`             | Enable readinessProbe                                                                                                | `true`                         |
| `skipper.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                             | `120`                          |
| `skipper.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                                    | `20`                           |
| `skipper.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                                   | `1`                            |
| `skipper.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                                 | `6`                            |
| `skipper.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                                 | `1`                            |
| `skipper.customStartupProbe`                 | Override default startup probe                                                                                       | `{}`                           |
| `skipper.customLivenessProbe`                | Override default liveness probe                                                                                      | `{}`                           |
| `skipper.customReadinessProbe`               | Override default readiness probe                                                                                     | `{}`                           |
| `skipper.service.type`                       | Kubernetes service type                                                                                              | `ClusterIP`                    |
| `skipper.service.port`                       | Service HTTP port                                                                                                    | `80`                           |
| `skipper.service.nodePort`                   | Service HTTP node port                                                                                               | `""`                           |
| `skipper.service.clusterIP`                  | Skipper server service cluster IP                                                                                    | `""`                           |
| `skipper.service.externalTrafficPolicy`      | Enable client source IP preservation                                                                                 | `Cluster`                      |
| `skipper.service.loadBalancerIP`             | Load balancer IP if service type is `LoadBalancer`                                                                   | `""`                           |
| `skipper.service.loadBalancerSourceRanges`   | Address that are allowed when service is LoadBalancer                                                                | `[]`                           |
| `skipper.service.extraPorts`                 | Extra ports to expose (normally used with the `sidecar` value)                                                       | `[]`                           |
| `skipper.service.annotations`                | Annotations for Skipper server service                                                                               | `{}`                           |
| `skipper.service.sessionAffinity`            | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                 | `None`                         |
| `skipper.service.sessionAffinityConfig`      | Additional settings for the sessionAffinity                                                                          | `{}`                           |
| `skipper.initContainers`                     | Add init containers to the Dataflow Skipper pods                                                                     | `[]`                           |
| `skipper.sidecars`                           | Add sidecars to the Skipper pods                                                                                     | `[]`                           |
| `skipper.pdb.create`                         | Enable/disable a Pod Disruption Budget creation                                                                      | `false`                        |
| `skipper.pdb.minAvailable`                   | Minimum number/percentage of pods that should remain scheduled                                                       | `1`                            |
| `skipper.pdb.maxUnavailable`                 | Maximum number/percentage of pods that may be made unavailable                                                       | `""`                           |
| `skipper.autoscaling.enabled`                | Enable autoscaling for Skipper server                                                                                | `false`                        |
| `skipper.autoscaling.minReplicas`            | Minimum number of Skipper server replicas                                                                            | `""`                           |
| `skipper.autoscaling.maxReplicas`            | Maximum number of Skipper server replicas                                                                            | `""`                           |
| `skipper.autoscaling.targetCPU`              | Target CPU utilization percentage                                                                                    | `""`                           |
| `skipper.autoscaling.targetMemory`           | Target Memory utilization percentage                                                                                 | `""`                           |
| `skipper.extraVolumes`                       | Extra Volumes to be set on the Skipper Pod                                                                           | `[]`                           |
| `skipper.extraVolumeMounts`                  | Extra VolumeMounts to be set on the Skipper Container                                                                | `[]`                           |
| `skipper.jdwp.enabled`                       | Enable Java Debug Wire Protocol (JDWP)                                                                               | `false`                        |
| `skipper.jdwp.port`                          | JDWP TCP port for remote debugging                                                                                   | `5005`                         |
| `externalSkipper.host`                       | Host of a external Skipper Server                                                                                    | `localhost`                    |
| `externalSkipper.port`                       | External Skipper Server port number                                                                                  | `7577`                         |


### Deployer parameters

| Name                                          | Description                                                                                                                                     | Value          |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `deployer.resources.limits`                   | Streaming applications resource limits                                                                                                          | `{}`           |
| `deployer.resources.requests`                 | Streaming applications resource requests                                                                                                        | `{}`           |
| `deployer.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                                                        | `120`          |
| `deployer.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                                                         | `90`           |
| `deployer.nodeSelector`                       | The node selectors to apply to the streaming applications deployments in "key:value" format                                                     | `""`           |
| `deployer.tolerations`                        | Streaming applications tolerations                                                                                                              | `[]`           |
| `deployer.volumeMounts`                       | Streaming applications extra volume mounts                                                                                                      | `{}`           |
| `deployer.volumes`                            | Streaming applications extra volumes                                                                                                            | `{}`           |
| `deployer.environmentVariables`               | Streaming applications environment variables                                                                                                    | `[]`           |
| `deployer.podSecurityContext.enabled`         | Enabled pods' Security Context of the deployed pods batch or stream pods                                                                        | `true`         |
| `deployer.podSecurityContext.runAsUser`       | Set Dataflow Streams container's Security Context runAsUser                                                                                     | `1001`         |
| `deployer.imagePullSecrets`                   | Streaming applications imagePullSecrets                                                                                                         | `[]`           |
| `deployer.secretRefs`                         | Streaming applications secretRefs                                                                                                               | `[]`           |
| `deployer.entryPointStyle`                    | An entry point style affects how application properties are passed to the container to be deployed. Allowed values: exec (default), shell, boot | `exec`         |
| `deployer.imagePullPolicy`                    | An image pull policy defines when a Docker image should be pulled to the local registry. Allowed values: IfNotPresent (default), Always, Never  | `IfNotPresent` |


### RBAC parameters

| Name                                          | Description                                                                                                             | Value  |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for Dataflow server and Skipper server pods                                     | `true` |
| `serviceAccount.name`                         | Name of the created serviceAccount. If not set and create is true, a name is generated using the scdf.fullname template | `""`   |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                          | `true` |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                              | `{}`   |
| `rbac.create`                                 | Whether to create and use RBAC resources or not                                                                         | `true` |


### Metrics parameters

| Name                                         | Description                                                                                                                | Value                              |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `metrics.enabled`                            | Enable Prometheus metrics                                                                                                  | `false`                            |
| `metrics.image.registry`                     | Prometheus Rsocket Proxy image registry                                                                                    | `docker.io`                        |
| `metrics.image.repository`                   | Prometheus Rsocket Proxy image repository                                                                                  | `bitnami/prometheus-rsocket-proxy` |
| `metrics.image.tag`                          | Prometheus Rsocket Proxy image tag (immutable tags are recommended)                                                        | `1.4.0-debian-11-r26`              |
| `metrics.image.digest`                       | Prometheus Rsocket Proxy image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag   | `""`                               |
| `metrics.image.pullPolicy`                   | Prometheus Rsocket Proxy image pull policy                                                                                 | `IfNotPresent`                     |
| `metrics.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                           | `[]`                               |
| `metrics.resources.limits`                   | The resources limits for the Prometheus Rsocket Proxy container                                                            | `{}`                               |
| `metrics.resources.requests`                 | The requested resources for the Prometheus Rsocket Proxy container                                                         | `{}`                               |
| `metrics.replicaCount`                       | Number of Prometheus Rsocket Proxy replicas to deploy                                                                      | `1`                                |
| `metrics.podAffinityPreset`                  | Prometheus Rsocket Proxy pod affinity preset. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`       | `""`                               |
| `metrics.podAntiAffinityPreset`              | Prometheus Rsocket Proxy pod anti-affinity preset. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                             |
| `metrics.nodeAffinityPreset.type`            | Prometheus Rsocket Proxy node affinity preset type. Ignored if `metrics.affinity` is set. Allowed values: `soft` or `hard` | `""`                               |
| `metrics.nodeAffinityPreset.key`             | Prometheus Rsocket Proxy node label key to match Ignored if `metrics.affinity` is set.                                     | `""`                               |
| `metrics.nodeAffinityPreset.values`          | Prometheus Rsocket Proxy node label values to match. Ignored if `metrics.affinity` is set.                                 | `[]`                               |
| `metrics.affinity`                           | Prometheus Rsocket Proxy affinity for pod assignment                                                                       | `{}`                               |
| `metrics.nodeSelector`                       | Prometheus Rsocket Proxy node labels for pod assignment                                                                    | `{}`                               |
| `metrics.hostAliases`                        | Prometheus Proxy pods host aliases                                                                                         | `[]`                               |
| `metrics.tolerations`                        | Prometheus Rsocket Proxy tolerations for pod assignment                                                                    | `[]`                               |
| `metrics.podAnnotations`                     | Annotations for Prometheus Rsocket Proxy pods                                                                              | `{}`                               |
| `metrics.podLabels`                          | Extra labels for Prometheus Proxy pods                                                                                     | `{}`                               |
| `metrics.podSecurityContext.enabled`         | Enabled Prometheus Proxy pods' Security Context                                                                            | `false`                            |
| `metrics.podSecurityContext.fsGroup`         | Set Prometheus Proxy pod's Security Context fsGroup                                                                        | `1001`                             |
| `metrics.containerSecurityContext.enabled`   | Enabled Prometheus Proxy containers' Security Context                                                                      | `false`                            |
| `metrics.containerSecurityContext.runAsUser` | Set Prometheus Proxy containers' Security Context runAsUser                                                                | `1001`                             |
| `metrics.command`                            | Override default container command (useful when using custom images)                                                       | `[]`                               |
| `metrics.args`                               | Override default container args (useful when using custom images)                                                          | `[]`                               |
| `metrics.lifecycleHooks`                     | for the Prometheus Proxy container(s) to automate configuration before or after startup                                    | `{}`                               |
| `metrics.extraEnvVars`                       | Array with extra environment variables to add to Prometheus Proxy nodes                                                    | `[]`                               |
| `metrics.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for Prometheus Proxy nodes                                            | `""`                               |
| `metrics.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for Prometheus Proxy nodes                                               | `""`                               |
| `metrics.extraVolumes`                       | Optionally specify extra list of additional volumes for the Prometheus Proxy pod(s)                                        | `[]`                               |
| `metrics.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the Prometheus Proxy container(s)                             | `[]`                               |
| `metrics.containerPorts.http`                | Prometheus Proxy HTTP container port                                                                                       | `8080`                             |
| `metrics.containerPorts.rsocket`             | Prometheus Proxy Rsocket container port                                                                                    | `7001`                             |
| `metrics.sidecars`                           | Add additional sidecar containers to the Prometheus Proxy pod(s)                                                           | `[]`                               |
| `metrics.initContainers`                     | Add additional init containers to the Prometheus Proxy pod(s)                                                              | `[]`                               |
| `metrics.updateStrategy.type`                | Prometheus Proxy deployment strategy type.                                                                                 | `RollingUpdate`                    |
| `metrics.priorityClassName`                  | Prometheus Rsocket Proxy pods' priority.                                                                                   | `""`                               |
| `metrics.schedulerName`                      | Name of the k8s scheduler (other than default)                                                                             | `""`                               |
| `metrics.topologySpreadConstraints`          | Topology Spread Constraints for pod assignment                                                                             | `[]`                               |
| `metrics.service.type`                       | Prometheus Proxy service type                                                                                              | `ClusterIP`                        |
| `metrics.service.ports.http`                 | Prometheus Rsocket Proxy HTTP port                                                                                         | `8080`                             |
| `metrics.service.ports.rsocket`              | Prometheus Rsocket Proxy Rsocket port                                                                                      | `7001`                             |
| `metrics.service.nodePorts.http`             | Node port for HTTP                                                                                                         | `""`                               |
| `metrics.service.nodePorts.rsocket`          | Node port for Rsocket                                                                                                      | `""`                               |
| `metrics.service.clusterIP`                  | Prometheys Proxy service Cluster IP                                                                                        | `""`                               |
| `metrics.service.loadBalancerIP`             | Prometheys Proxy service Load Balancer IP                                                                                  | `""`                               |
| `metrics.service.loadBalancerSourceRanges`   | Prometheys Proxy service Load Balancer sources                                                                             | `[]`                               |
| `metrics.service.externalTrafficPolicy`      | Prometheys Proxy service external traffic policy                                                                           | `Cluster`                          |
| `metrics.service.extraPorts`                 | Extra ports to expose (normally used with the `sidecar` value)                                                             | `[]`                               |
| `metrics.service.annotations`                | Annotations for the Prometheus Rsocket Proxy service                                                                       | `{}`                               |
| `metrics.service.sessionAffinity`            | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                       | `None`                             |
| `metrics.service.sessionAffinityConfig`      | Additional settings for the sessionAffinity                                                                                | `{}`                               |
| `metrics.serviceMonitor.enabled`             | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                     | `false`                            |
| `metrics.serviceMonitor.namespace`           | Namespace in which ServiceMonitor is created if different from release                                                     | `""`                               |
| `metrics.serviceMonitor.jobLabel`            | The name of the label on the target service to use as the job name in prometheus.                                          | `""`                               |
| `metrics.serviceMonitor.interval`            | Interval at which metrics should be scraped.                                                                               | `""`                               |
| `metrics.serviceMonitor.scrapeTimeout`       | Timeout after which the scrape is ended                                                                                    | `""`                               |
| `metrics.serviceMonitor.relabelings`         | RelabelConfigs to apply to samples before scraping                                                                         | `[]`                               |
| `metrics.serviceMonitor.metricRelabelings`   | MetricRelabelConfigs to apply to samples before ingestion                                                                  | `[]`                               |
| `metrics.serviceMonitor.selector`            | ServiceMonitor selector labels                                                                                             | `{}`                               |
| `metrics.serviceMonitor.labels`              | Extra labels for the ServiceMonitor                                                                                        | `{}`                               |
| `metrics.serviceMonitor.honorLabels`         | honorLabels chooses the metric's labels on collisions with target labels                                                   | `false`                            |
| `metrics.pdb.create`                         | Enable/disable a Pod Disruption Budget creation                                                                            | `false`                            |
| `metrics.pdb.minAvailable`                   | Minimum number/percentage of pods that should remain scheduled                                                             | `1`                                |
| `metrics.pdb.maxUnavailable`                 | Maximum number/percentage of pods that may be made unavailable                                                             | `""`                               |
| `metrics.autoscaling.enabled`                | Enable autoscaling for Prometheus Rsocket Proxy                                                                            | `false`                            |
| `metrics.autoscaling.minReplicas`            | Minimum number of Prometheus Rsocket Proxy replicas                                                                        | `""`                               |
| `metrics.autoscaling.maxReplicas`            | Maximum number of Prometheus Rsocket Proxy replicas                                                                        | `""`                               |
| `metrics.autoscaling.targetCPU`              | Target CPU utilization percentage                                                                                          | `""`                               |
| `metrics.autoscaling.targetMemory`           | Target Memory utilization percentage                                                                                       | `""`                               |


### Init Container parameters

| Name                                 | Description                                                                                                                     | Value                 |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `waitForBackends.enabled`            | Wait for the database and other services (such as Kafka or RabbitMQ) used when enabling streaming                               | `true`                |
| `waitForBackends.image.registry`     | Init container wait-for-backend image registry                                                                                  | `docker.io`           |
| `waitForBackends.image.repository`   | Init container wait-for-backend image name                                                                                      | `bitnami/kubectl`     |
| `waitForBackends.image.tag`          | Init container wait-for-backend image tag                                                                                       | `1.24.3-debian-11-r8` |
| `waitForBackends.image.digest`       | Init container wait-for-backend image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                  |
| `waitForBackends.image.pullPolicy`   | Init container wait-for-backend image pull policy                                                                               | `IfNotPresent`        |
| `waitForBackends.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                                | `[]`                  |
| `waitForBackends.resources.limits`   | Init container wait-for-backend resource limits                                                                                 | `{}`                  |
| `waitForBackends.resources.requests` | Init container wait-for-backend resource requests                                                                               | `{}`                  |


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

The above command installs Spring Cloud Data Flow chart with 2 Dataflow server replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml bitnami/spring-cloud-dataflow
```

> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/blob/master/bitnami/spring-cloud-dataflow/values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Features

If you only need to deploy tasks and schedules, streaming and Skipper can be disabled:

```console
server.configuration.batchEnabled=true
server.configuration.streamingEnabled=false
skipper.enabled=false
rabbitmq.enabled=false
```

If you only need to deploy streams, tasks and schedules can be disabled:

```console
server.configuration.batchEnabled=false
server.configuration.streamingEnabled=true
skipper.enabled=true
rabbitmq.enabled=true
```

NOTE: Both `server.configuration.batchEnabled` and `server.configuration.streamingEnabled` should not be set to `false` at the same time.

### Messaging solutions

There are two supported messaging solutions in this chart:

- RabbitMQ (default)
- Kafka

To change the messaging layer to Kafka, use the following parameters:

```console
rabbitmq.enabled=false
kafka.enabled=true
```

Only one messaging layer can be used at a given time.

### Using an external database

Sometimes you may want to have Spring Cloud components connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.scheme=mariadb
externalDatabase.host=myexternalhost
externalDatabase.port=3306
externalDatabase.password=mypassword
externalDatabase.dataflow.user=mydataflowuser
externalDatabase.dataflow.database=mydataflowdatabase
externalDatabase.dataflow.user=myskipperuser
externalDatabase.dataflow.database=myskipperdatabase
```

NOTE: When using the individual properties (scheme, host, port, database, an optional jdbcParameters) this chart will format the JDBC URL as `jdbc:{scheme}://{host}:{port}/{database}{jdbcParameters}`. The URL format follows that of the MariaDB database drive but may not work for other database vendors.

To use an alternate database vendor (other than MariaDB) you can use the `externalDatabase.dataflow.url` and `externalDatabase.skipper.url` properties to provide the JDBC URLs for the dataflow server and skipper respectively. If these properties are defined, they will take precedence over the individual attributes. As an example of configuring an external MS SQL Server database:

```console
mariadb.enabled=false
externalDatabase.password=mypassword
externalDatabase.dataflow.url=jdbc:sqlserver://mssql-server:1433
externalDatabase.dataflow.user=mydataflowuser
externalDatabase.skipper.url=jdbc:sqlserver://mssql-server:1433
externalDatabase.skipper.user=myskipperuser
externalDatabase.hibernateDialect=org.hibernate.dialect.SQLServer2012Dialect
```

NOTE: If you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

### Adding extra flags

In case you want to add extra environment variables to any Spring Cloud component, you can use `XXX.extraEnvs` parameter(s), where XXX is placeholder you need to replace with the actual component(s). For instance, to add extra flags to Spring Cloud Data Flow, use:

```yaml
server:
  extraEnvs:
    - name: FOO
      value: BAR
```

### Using custom Dataflow configuration

This helm chart supports using custom configuration for Dataflow server.

You can specify the configuration for Dataflow server by setting the `server.existingConfigmap` parameter to an external ConfigMap with the configuration file.

### Using custom Skipper configuration

This helm chart supports using custom configuration for Skipper server.

You can specify the configuration for Skipper server by setting the `skipper.existingConfigmap` parameter to an external ConfigMap with the configuration file.

### Sidecars and Init Containers

If you need additional containers to run within the same pod as Dataflow or Skipper components (e.g. an additional metrics or logging exporter), you can do so via the `XXX.sidecars` parameter(s), where XXX is the placeholder you need to replace with the actual component(s). Simply define your container according to the Kubernetes container spec.

```yaml
server:
  sidecars:
    - name: your-image-name
      image: your-image
      imagePullPolicy: Always
      ports:
        - name: portname
          containerPort: 1234
```

Similarly, you can add extra init containers using the `XXX.initContainers` parameter(s).

```yaml
server:
  initContainers:
    - name: your-image-name
      image: your-image
      imagePullPolicy: Always
      ports:
        - name: portname
          containerPort: 1234
```

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as nginx-ingress or traefik you can utilize the ingress controller to serve your Spring Cloud Data Flow server.

To enable ingress integration, please set `server.ingress.enabled` to `true`

#### Hosts

Most likely you will only want to have one hostname that maps to this Spring Cloud Data Flow installation. If that's your case, the property `server.ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `server.ingress.extraHosts` object is can be specified as an array. You can also use `server.ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `server.ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

#### TLS

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required. There are four common use cases:

- Helm generates/manages certificate secrets based on the parameters.
- User generates/manages certificates separately.
- Helm creates self-signed certificates and generates/manages certificate secrets.
- An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.
In the first two cases, it's needed a certificate and a key. We would expect them to look like this:
- certificate files should look like (and there can be more than one certificate if there is a certificate chain)
  ```console
  -----BEGIN CERTIFICATE-----
  MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
  ...
  jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
  -----END CERTIFICATE-----
  ```
- keys should look like:
  ```console
  -----BEGIN RSA PRIVATE KEY-----
  MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
  ...
  wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
  -----END RSA PRIVATE KEY-----
  ```
- If you are going to use Helm to manage the certificates based on the parameters, please copy these values into the `certificate` and `key` values for a given `server.ingress.secrets` entry.
- In case you are going to manage TLS secrets separately, please know that you must create a TLS secret with name *INGRESS_HOSTNAME-tls* (where *INGRESS_HOSTNAME* is a placeholder to be replaced with the hostname you set using the `server.ingress.hostname` parameter).
- To use self-signed certificates created by Helm, set `server.ingress.tls` to `true` and `server.ingress.certManager` to `false`.
- If your cluster has a [cert-manager](https://github.com/jetstack/cert-manager) add-on to automate the management and issuance of TLS certificates, set `server.ingress.certManager` boolean to true to enable the corresponding annotations for cert-manager.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

If you enabled RabbitMQ chart to be used as the messaging solution for Skipper to manage streaming content, then it's necessary to set the `rabbitmq.auth.password` and `rabbitmq.auth.erlangCookie` parameters when upgrading for readiness/liveness probes to work properly. Inspect the RabbitMQ secret to obtain the password and the Erlang cookie, then you can upgrade your chart using the command below:

### To 12.0.0

This major updates the Kafka subchart to its newest major, 18.0.0. No major issues are expected during the upgrade.

### To 11.0.0

This chart bumps the RabbitMQ version to 3.10.x. No issues are expected during the upgrade.

### To 10.0.0

This major updates the Kafka subchart to its newest major, 17.0.0. No major issues are expected during the upgrade.

### To 9.0.0

This major updates the RabbitMQ subchart to its newest major, 9.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq#to-900) you can find more information about the changes introduced in that version.

### To 8.0.0

This major release bumps the MariaDB version to 10.6. Follow the [upstream instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-105-to-mariadb-106/) for upgrading from MariaDB 10.5 to 10.6. No major issues are expected during the upgrade.

### To 7.0.0

This major updates the Kafka subchart to its newest major, 16.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1600) you can find more information about the changes introduced in that version.

### To 6.0.0

This major release updates the Kafka subchart to its newest major `15.x.x`, which contains several changes in the supported values and bumps Kafka major version to `3.x` series (check the [upgrade notes](https://github.com/bitnami/charts/blob/master/bitnami/kafka/README.md#to-1500) to obtain more information).

To upgrade to *6.0.0* from *5.x* using Kafka as messaging solution, it should be done by maintaining the Kafka `2.x` series. To do so, follow the instructions below (the following example assumes that the release name is *scdf* and the release namespace *default*):

1. Obtain the credentials on your current release:

```bash
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default scdf-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default scdf-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
```

2. Upgrade your release using the same Kafka version:

```bash
export CURRENT_KAFKA_VERSION=$(kubectl exec scdf-kafka-0 -- bash -c 'echo $BITNAMI_IMAGE_VERSION')
helm upgrade scdf bitnami/spring-cloud-dataflow \
  --set rabbitmq.enabled=false \
  --set kafka.enabled=true \
  --set kafka.image.tag=$CURRENT_KAFKA_VERSION \
  --set mariadb.auth.password=$MARIADB_PASSWORD \
  --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD
```

### To 5.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `serviceMonitor.extraLabels` renamed as `serviceMonitor.labels`.
- `server.strategyType` and `skikker.strategyType` have been replaced by `server.updateStrategy` and `skikker.updateStrategy` respectively. While `strategyType` was interpreted as a String, while `updateStrategy` is interpreted as an object.
- The service account token is now set to automount `false` by default. To change this, set the value `serviceAccount.automountServiceAccountToken` to `true`.

Additionally updates the MariaDB subchart to its newest major, 10.0.0, which contains similar changes. [Here](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-1000) you can find more information about the changes introduced in this version.

### To 4.0.0

This major updates the Kafka subchart its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1400) you can find more information about the changes introduced in this version.

### To 3.0.0

This major updates the Kafka subchart to its newest major 13.0.0. For more information on this subchart's major, please refer to [kafka upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/kafka#to-1300).

### To 2.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### v0.x.x

```bash
helm upgrade my-release bitnami/spring-cloud-dataflow --set mariadb.rootUser.password=[MARIADB_ROOT_PASSWORD] --set rabbitmq.auth.password=[RABBITMQ_PASSWORD] --set rabbitmq.auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```

### v1.x.x

```bash
helm upgrade my-release bitnami/spring-cloud-dataflow --set mariadb.auth.rootPassword=[MARIADB_ROOT_PASSWORD] --set rabbitmq.auth.password=[RABBITMQ_PASSWORD] --set rabbitmq.auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```

### To 1.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatibilities. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `1.0.0`, you will need to reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `dataflow`):

> NOTE: Please, create a backup of your database before running any of those actions.

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```bash
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default dataflow-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default dataflow-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=dataflow -o jsonpath="{.items[0].metadata.name}")
export RABBITMQ_PASSWORD=$(kubectl get secret --namespace default dataflow-rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)
export RABBITMQ_ERLANG_COOKIE=$(kubectl get secret --namespace default dataflow-rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling Data Flow replicas to 0:

```bash
helm upgrade dataflow bitnami/spring-cloud-dataflow --version 0.7.4 \
  --set server.replicaCount=0 \
  --set skipper.replicaCount=0 \
  --set mariadb.enabled=false \
  --set rabbitmq.auth.password=$RABBITMQ_PASSWORD \
  --set rabbitmq.auth.erlangCookie=$RABBITMQ_ERLANG_COOKIE
```

Finally, upgrade you release to 1.0.0 reusing the existing PVC, and enabling back MariaDB:

```bash
helm upgrade dataflow bitnami/spring-cloud-dataflow \
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