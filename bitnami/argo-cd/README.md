<!--- app-name: Argo CD -->

# Argo CD packaged by Bitnami

Argo CD is a continuous delivery tool for Kubernetes based on GitOps.

[Overview of Argo CD](https://argoproj.github.io/cd)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/argo-cd
```

## Introduction

This chart bootstraps an Argo CD deployment on a Kubernetes cluster using the Helm package manager.

Bitnami charts can be used with Kubeapps for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/argo-cd
```

The command deploys argo-cd on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `""`            |
| `nameOverride`      | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`            |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |


### Argo CD image parameters

| Name                | Description                                        | Value                 |
| ------------------- | -------------------------------------------------- | --------------------- |
| `image.registry`    | Argo CD image registry                             | `docker.io`           |
| `image.repository`  | Argo CD image repository                           | `bitnami/argo-cd`     |
| `image.tag`         | Argo CD image tag (immutable tags are recommended) | `2.3.3-debian-10-r32` |
| `image.pullPolicy`  | Argo CD image pull policy                          | `IfNotPresent`        |
| `image.pullSecrets` | Argo CD image pull secrets                         | `[]`                  |
| `image.debug`       | Enable Argo CD image debug mode                    | `false`               |


### Argo CD application controller parameters

| Name                                                           | Description                                                                                          | Value           |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | --------------- |
| `controller.replicaCount`                                      | Number of Argo CD replicas to deploy                                                                 | `1`             |
| `controller.startupProbe.enabled`                              | Enable startupProbe on Argo CD nodes                                                                 | `false`         |
| `controller.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                               | `10`            |
| `controller.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                      | `10`            |
| `controller.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                     | `1`             |
| `controller.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                   | `3`             |
| `controller.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                   | `1`             |
| `controller.livenessProbe.enabled`                             | Enable livenessProbe on Argo CD nodes                                                                | `true`          |
| `controller.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                              | `10`            |
| `controller.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                     | `10`            |
| `controller.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                    | `1`             |
| `controller.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                  | `3`             |
| `controller.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                  | `1`             |
| `controller.readinessProbe.enabled`                            | Enable readinessProbe on Argo CD nodes                                                               | `true`          |
| `controller.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                             | `10`            |
| `controller.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                    | `10`            |
| `controller.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                   | `1`             |
| `controller.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                 | `3`             |
| `controller.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                 | `1`             |
| `controller.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                   | `{}`            |
| `controller.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                  | `{}`            |
| `controller.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                 | `{}`            |
| `controller.resources.limits`                                  | The resources limits for the Argo CD containers                                                      | `{}`            |
| `controller.resources.requests`                                | The requested resources for the Argo CD containers                                                   | `{}`            |
| `controller.podSecurityContext.enabled`                        | Enabled Argo CD pods' Security Context                                                               | `true`          |
| `controller.podSecurityContext.fsGroup`                        | Set Argo CD pod's Security Context fsGroup                                                           | `1001`          |
| `controller.containerSecurityContext.enabled`                  | Enabled Argo CD containers' Security Context                                                         | `true`          |
| `controller.containerSecurityContext.runAsUser`                | Set Argo CD containers' Security Context runAsUser                                                   | `1001`          |
| `controller.containerSecurityContext.allowPrivilegeEscalation` | Set Argo CD containers' Security Context allowPrivilegeEscalation                                    | `false`         |
| `controller.containerSecurityContext.capabilities.drop`        | Set Argo CD containers' Security Context capabilities to be dropped                                  | `["all"]`       |
| `controller.containerSecurityContext.readOnlyRootFilesystem`   | Set Argo CD containers' Security Context readOnlyRootFilesystem                                      | `false`         |
| `controller.containerSecurityContext.runAsNonRoot`             | Set Argo CD container's Security Context runAsNonRoot                                                | `true`          |
| `controller.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                 | `true`          |
| `controller.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                               | `""`            |
| `controller.serviceAccount.automountServiceAccountToken`       | Automount service account token for the application controller service account                       | `true`          |
| `controller.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.           | `{}`            |
| `controller.clusterAdminAccess`                                | Enable K8s cluster admin access for the application controller                                       | `true`          |
| `controller.clusterRoleRules`                                  | Use custom rules for the application controller's cluster role                                       | `[]`            |
| `controller.logFormat`                                         | Format for the Argo CD application controller logs. Options: [text, json]                            | `text`          |
| `controller.logLevel`                                          | Log level for the Argo CD application controller                                                     | `info`          |
| `controller.containerPorts.controller`                         | Argo CD application controller port number                                                           | `8082`          |
| `controller.containerPorts.metrics`                            | Argo CD application controller metrics port number                                                   | `8082`          |
| `controller.service.type`                                      | Argo CD service type                                                                                 | `ClusterIP`     |
| `controller.service.port`                                      | Argo CD application controller service port                                                          | `8082`          |
| `controller.service.nodePort`                                  | Node port for Argo CD application controller service                                                 | `""`            |
| `controller.service.clusterIP`                                 | Argo CD application controller service Cluster IP                                                    | `""`            |
| `controller.service.loadBalancerIP`                            | Argo CD application controller service Load Balancer IP                                              | `""`            |
| `controller.service.loadBalancerSourceRanges`                  | Argo CD application controller service Load Balancer sources                                         | `[]`            |
| `controller.service.externalTrafficPolicy`                     | Argo CD application controller service external traffic policy                                       | `Cluster`       |
| `controller.service.annotations`                               | Additional custom annotations for Argo CD application controller service                             | `{}`            |
| `controller.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                       | `[]`            |
| `controller.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                 | `None`          |
| `controller.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                          | `{}`            |
| `controller.metrics.enabled`                                   | Enable Argo CD application controller metrics                                                        | `false`         |
| `controller.metrics.service.type`                              | Argo CD application controller service type                                                          | `ClusterIP`     |
| `controller.metrics.service.port`                              | Argo CD application controller metrics service port                                                  | `8082`          |
| `controller.metrics.service.nodePort`                          | Node port for the application controller service                                                     | `""`            |
| `controller.metrics.service.clusterIP`                         | Argo CD application controller metrics service Cluster IP                                            | `""`            |
| `controller.metrics.service.loadBalancerIP`                    | Argo CD application controller service Load Balancer IP                                              | `""`            |
| `controller.metrics.service.loadBalancerSourceRanges`          | Argo CD application controller service Load Balancer sources                                         | `[]`            |
| `controller.metrics.service.externalTrafficPolicy`             | Argo CD application controller service external traffic policy                                       | `Cluster`       |
| `controller.metrics.service.annotations`                       | Additional custom annotations for Argo CD application controller service                             | `{}`            |
| `controller.metrics.service.sessionAffinity`                   | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                 | `None`          |
| `controller.metrics.service.sessionAffinityConfig`             | Additional settings for the sessionAffinity                                                          | `{}`            |
| `controller.metrics.serviceMonitor.enabled`                    | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                         | `false`         |
| `controller.metrics.serviceMonitor.namespace`                  | Namespace which Prometheus is running in                                                             | `""`            |
| `controller.metrics.serviceMonitor.jobLabel`                   | The name of the label on the target service to use as the job name in prometheus.                    | `""`            |
| `controller.metrics.serviceMonitor.interval`                   | Interval at which metrics should be scraped                                                          | `30s`           |
| `controller.metrics.serviceMonitor.scrapeTimeout`              | Timeout after which the scrape is ended                                                              | `10s`           |
| `controller.metrics.serviceMonitor.relabelings`                | RelabelConfigs to apply to samples before scraping                                                   | `[]`            |
| `controller.metrics.serviceMonitor.metricRelabelings`          | MetricRelabelConfigs to apply to samples before ingestion                                            | `[]`            |
| `controller.metrics.serviceMonitor.selector`                   | ServiceMonitor selector labels                                                                       | `{}`            |
| `controller.metrics.serviceMonitor.honorLabels`                | honorLabels chooses the metric's labels on collisions with target labels                             | `false`         |
| `controller.metrics.rules.enabled`                             | Enable render extra rules for PrometheusRule object                                                  | `false`         |
| `controller.metrics.rules.spec`                                | Rules to render into the PrometheusRule object                                                       | `[]`            |
| `controller.metrics.rules.selector`                            | Selector for the PrometheusRule object                                                               | `{}`            |
| `controller.metrics.rules.namespace`                           | Namespace where to create the PrometheusRule object                                                  | `monitoring`    |
| `controller.metrics.rules.additionalLabels`                    | Additional lables to add to the PrometheusRule object                                                | `{}`            |
| `controller.command`                                           | Override default container command (useful when using custom images)                                 | `[]`            |
| `controller.defaultArgs.statusProcessors`                      | Default status processors for Argo CD controller                                                     | `20`            |
| `controller.defaultArgs.operationProcessors`                   | Default operation processors for Argo CD controller                                                  | `10`            |
| `controller.defaultArgs.appResyncPeriod`                       | Default application resync period for Argo CD controller                                             | `180`           |
| `controller.defaultArgs.selfHealTimeout`                       | Default self heal timeout for Argo CD controller                                                     | `5`             |
| `controller.args`                                              | Override default container args (useful when using custom images). Overrides the defaultArgs.        | `[]`            |
| `controller.extraArgs`                                         | Add extra arguments to the default arguments for the Argo CD controller                              | `[]`            |
| `controller.hostAliases`                                       | Argo CD pods host aliases                                                                            | `[]`            |
| `controller.podLabels`                                         | Extra labels for Argo CD pods                                                                        | `{}`            |
| `controller.podAnnotations`                                    | Annotations for Argo CD pods                                                                         | `{}`            |
| `controller.podAffinityPreset`                                 | Pod affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `controller.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `controller.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `controller.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `controller.affinity` is set                                     | `""`            |
| `controller.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `controller.affinity` is set                                  | `[]`            |
| `controller.affinity`                                          | Affinity for Argo CD pods assignment                                                                 | `{}`            |
| `controller.nodeSelector`                                      | Node labels for Argo CD pods assignment                                                              | `{}`            |
| `controller.tolerations`                                       | Tolerations for Argo CD pods assignment                                                              | `[]`            |
| `controller.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                       | `""`            |
| `controller.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                       | `[]`            |
| `controller.updateStrategy.type`                               | Argo CD statefulset strategy type                                                                    | `RollingUpdate` |
| `controller.priorityClassName`                                 | Argo CD pods' priorityClassName                                                                      | `""`            |
| `controller.lifecycleHooks`                                    | for the Argo CD container(s) to automate configuration before or after startup                       | `{}`            |
| `controller.extraEnvVars`                                      | Array with extra environment variables to add to Argo CD nodes                                       | `[]`            |
| `controller.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Argo CD nodes                               | `""`            |
| `controller.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Argo CD nodes                                  | `""`            |
| `controller.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Argo CD pod(s)                           | `[]`            |
| `controller.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Argo CD container(s)                | `[]`            |
| `controller.sidecars`                                          | Add additional sidecar containers to the Argo CD pod(s)                                              | `[]`            |
| `controller.initContainers`                                    | Add additional init containers to the Argo CD pod(s)                                                 | `[]`            |


### Argo CD server Parameters

| Name                                                       | Description                                                                                                                     | Value                    |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `server.replicaCount`                                      | Number of Argo CD server replicas to deploy                                                                                     | `1`                      |
| `server.startupProbe.enabled`                              | Enable startupProbe on Argo CD server nodes                                                                                     | `false`                  |
| `server.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                          | `10`                     |
| `server.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                 | `10`                     |
| `server.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                | `1`                      |
| `server.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                              | `3`                      |
| `server.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                              | `1`                      |
| `server.livenessProbe.enabled`                             | Enable livenessProbe on Argo CD server nodes                                                                                    | `true`                   |
| `server.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                         | `10`                     |
| `server.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                | `10`                     |
| `server.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                               | `1`                      |
| `server.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                             | `3`                      |
| `server.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                             | `1`                      |
| `server.readinessProbe.enabled`                            | Enable readinessProbe on Argo CD server nodes                                                                                   | `true`                   |
| `server.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                        | `10`                     |
| `server.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                               | `10`                     |
| `server.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                              | `1`                      |
| `server.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                            | `3`                      |
| `server.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                            | `1`                      |
| `server.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                              | `{}`                     |
| `server.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                             | `{}`                     |
| `server.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                            | `{}`                     |
| `server.resources.limits`                                  | The resources limits for the Argo CD server containers                                                                          | `{}`                     |
| `server.resources.requests`                                | The requested resources for the Argo CD server containers                                                                       | `{}`                     |
| `server.podSecurityContext.enabled`                        | Enabled Argo CD server pods' Security Context                                                                                   | `true`                   |
| `server.podSecurityContext.fsGroup`                        | Set Argo CD server pod's Security Context fsGroup                                                                               | `1001`                   |
| `server.containerSecurityContext.enabled`                  | Enabled Argo CD server containers' Security Context                                                                             | `true`                   |
| `server.containerSecurityContext.runAsUser`                | Set Argo CD server containers' Security Context runAsUser                                                                       | `1001`                   |
| `server.containerSecurityContext.allowPrivilegeEscalation` | Set Argo CD server containers' Security Context allowPrivilegeEscalation                                                        | `false`                  |
| `server.containerSecurityContext.capabilities.drop`        | Set Argo CD containers' server Security Context capabilities to be dropped                                                      | `["all"]`                |
| `server.containerSecurityContext.readOnlyRootFilesystem`   | Set Argo CD containers' server Security Context readOnlyRootFilesystem                                                          | `false`                  |
| `server.containerSecurityContext.runAsNonRoot`             | Set Argo CD server containers' Security Context runAsNonRoot                                                                    | `true`                   |
| `server.autoscaling.enabled`                               | Enable Argo CD server deployment autoscaling                                                                                    | `false`                  |
| `server.autoscaling.minReplicas`                           | Argo CD server deployment autoscaling minimum number of replicas                                                                | `1`                      |
| `server.autoscaling.maxReplicas`                           | Argo CD server deployment autoscaling maximum number of replicas                                                                | `5`                      |
| `server.autoscaling.targetCPU`                             | Argo CD server deployment autoscaling target CPU percentage                                                                     | `50`                     |
| `server.autoscaling.targetMemory`                          | Argo CD server deployment autoscaling target CPU memory                                                                         | `50`                     |
| `server.insecure`                                          | Disable HTTPS redirection for Argo CD server                                                                                    | `false`                  |
| `server.logFormat`                                         | ArgoCD server logs format. Options: [text, json]                                                                                | `text`                   |
| `server.logLevel`                                          | ArgoCD server logs level                                                                                                        | `info`                   |
| `server.configEnabled`                                     | Enable Argo CD server config                                                                                                    | `true`                   |
| `server.url`                                               | Argo CD server base URL. Required when configuring SSO. Required when enabling dex.                                             | `""`                     |
| `server.config`                                            | Argo CD server configuration that will end on the argocd-cm Config Map                                                          | `{}`                     |
| `server.ingress.enabled`                                   | Enable the creation of an ingress for the Argo CD server                                                                        | `false`                  |
| `server.ingress.pathType`                                  | Path type for the Argo CD server ingress                                                                                        | `ImplementationSpecific` |
| `server.ingress.apiVersion`                                | Ingress API version for the Argo CD server ingress                                                                              | `""`                     |
| `server.ingress.hostname`                                  | Ingress hostname for the Argo CD server ingress                                                                                 | `argocd.server.local`    |
| `server.ingress.annotations`                               | Annotations for the Argo CD server ingress. To enable certificate autogeneration, place here your cert-manager annotations.     | `{}`                     |
| `server.ingress.tls`                                       | Enable TLS for the Argo CD server ingress                                                                                       | `false`                  |
| `server.ingress.extraHosts`                                | Extra hosts array for the Argo CD server ingress                                                                                | `[]`                     |
| `server.ingress.path`                                      | Path array for the Argo CD server ingress                                                                                       | `/`                      |
| `server.ingress.extraPaths`                                | Extra paths for the Argo CD server ingress                                                                                      | `[]`                     |
| `server.ingress.extraTls`                                  | Extra TLS configuration for the Argo CD server ingress                                                                          | `[]`                     |
| `server.ingress.secrets`                                   | Secrets array to mount into the Ingress                                                                                         | `[]`                     |
| `server.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                   | `""`                     |
| `server.ingress.selfSigned`                                | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                    | `false`                  |
| `server.ingress.extraRules`                                | Additional rules to be covered with this ingress record                                                                         | `[]`                     |
| `server.metrics.enabled`                                   | Enable metrics for the Argo CD server                                                                                           | `false`                  |
| `server.metrics.service.type`                              | Argo CD server service type                                                                                                     | `ClusterIP`              |
| `server.metrics.service.port`                              | Argo CD server metrics service port                                                                                             | `8083`                   |
| `server.metrics.service.nodePort`                          | Node port for Argo CD server metrics service                                                                                    | `""`                     |
| `server.metrics.service.clusterIP`                         | Argo CD server metrics service Cluster IP                                                                                       | `""`                     |
| `server.metrics.service.loadBalancerIP`                    | Argo CD server service Load Balancer IP                                                                                         | `""`                     |
| `server.metrics.service.loadBalancerSourceRanges`          | Argo CD server service Load Balancer sources                                                                                    | `[]`                     |
| `server.metrics.service.externalTrafficPolicy`             | Argo CD server service external traffic policy                                                                                  | `Cluster`                |
| `server.metrics.service.annotations`                       | Additional custom annotations for Argo CD server service                                                                        | `{}`                     |
| `server.metrics.service.sessionAffinity`                   | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                            | `None`                   |
| `server.metrics.service.sessionAffinityConfig`             | Additional settings for the sessionAffinity                                                                                     | `{}`                     |
| `server.metrics.serviceMonitor.enabled`                    | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                                                    | `false`                  |
| `server.metrics.serviceMonitor.namespace`                  | Namespace which Prometheus is running in                                                                                        | `""`                     |
| `server.metrics.serviceMonitor.jobLabel`                   | The name of the label on the target service to use as the job name in prometheus.                                               | `""`                     |
| `server.metrics.serviceMonitor.interval`                   | Interval at which metrics should be scraped                                                                                     | `30s`                    |
| `server.metrics.serviceMonitor.scrapeTimeout`              | Timeout after which the scrape is ended                                                                                         | `10s`                    |
| `server.metrics.serviceMonitor.relabelings`                | RelabelConfigs to apply to samples before scraping                                                                              | `[]`                     |
| `server.metrics.serviceMonitor.metricRelabelings`          | MetricRelabelConfigs to apply to samples before ingestion                                                                       | `[]`                     |
| `server.metrics.serviceMonitor.selector`                   | ServiceMonitor selector labels                                                                                                  | `{}`                     |
| `server.metrics.serviceMonitor.honorLabels`                | honorLabels chooses the metric's labels on collisions with target labels                                                        | `false`                  |
| `server.ingressGrpc.enabled`                               | Enable the creation of an ingress for the Argo CD gRPC server                                                                   | `false`                  |
| `server.ingressGrpc.pathType`                              | Path type for the Argo CD gRPC server ingress                                                                                   | `ImplementationSpecific` |
| `server.ingressGrpc.apiVersion`                            | Ingress API version for the Argo CD gRPC server ingress                                                                         | `""`                     |
| `server.ingressGrpc.hostname`                              | Ingress hostname for the Argo CD gRPC server ingress                                                                            | `argocd.server.local`    |
| `server.ingressGrpc.annotations`                           | Annotations for the Argo CD gRPC server ingress. To enable certificate autogeneration, place here your cert-manager annotations | `{}`                     |
| `server.ingressGrpc.tls`                                   | Enable TLS for the Argo CD server ingress                                                                                       | `false`                  |
| `server.ingressGrpc.extraHosts`                            | Extra hosts array for the Argo CD gRPC server ingress                                                                           | `[]`                     |
| `server.ingressGrpc.path`                                  | Path array for the Argo CD gRPC server ingress                                                                                  | `/`                      |
| `server.ingressGrpc.extraPaths`                            | Extra paths for the Argo CD gRPC server ingress                                                                                 | `[]`                     |
| `server.ingressGrpc.extraTls`                              | Extra TLS configuration for the Argo CD gRPC server ingress                                                                     | `[]`                     |
| `server.ingressGrpc.secrets`                               | Secrets array to mount into the Ingress                                                                                         | `[]`                     |
| `server.ingressGrpc.ingressClassName`                      | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                   | `""`                     |
| `server.ingressGrpc.selfSigned`                            | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                    | `false`                  |
| `server.ingressGrpc.extraRules`                            | Additional rules to be covered with this ingress record                                                                         | `[]`                     |
| `server.containerPorts.http`                               | Argo CD server HTTP container port                                                                                              | `8080`                   |
| `server.containerPorts.https`                              | Argo CD server HTTPS container port                                                                                             | `8443`                   |
| `server.containerPorts.metrics`                            | Argo CD server metrics container port                                                                                           | `8083`                   |
| `server.service.type`                                      | Argo CD service type                                                                                                            | `ClusterIP`              |
| `server.service.ports.http`                                | HTTP port for the gRPC ingress when enabled                                                                                     | `80`                     |
| `server.service.ports.https`                               | HTTPS port for the gRPC ingress when enabled                                                                                    | `443`                    |
| `server.service.nodePorts.http`                            | Node port for HTTP                                                                                                              | `""`                     |
| `server.service.nodePorts.https`                           | Node port for HTTPS                                                                                                             | `""`                     |
| `server.service.clusterIP`                                 | Argo CD service Cluster IP                                                                                                      | `""`                     |
| `server.service.loadBalancerIP`                            | Argo CD service Load Balancer IP                                                                                                | `""`                     |
| `server.service.loadBalancerSourceRanges`                  | Argo CD service Load Balancer sources                                                                                           | `[]`                     |
| `server.service.externalTrafficPolicy`                     | Argo CD service external traffic policy                                                                                         | `Cluster`                |
| `server.service.annotations`                               | Additional custom annotations for Argo CD service                                                                               | `{}`                     |
| `server.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                                                  | `[]`                     |
| `server.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                            | `None`                   |
| `server.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                     | `{}`                     |
| `server.command`                                           | Override default container command (useful when using custom images)                                                            | `[]`                     |
| `server.args`                                              | Override default container args (useful when using custom images)                                                               | `[]`                     |
| `server.extraArgs`                                         | concat to the default args                                                                                                      | `[]`                     |
| `server.hostAliases`                                       | Argo CD server pods host aliases                                                                                                | `[]`                     |
| `server.podLabels`                                         | Extra labels for Argo CD server pods                                                                                            | `{}`                     |
| `server.podAnnotations`                                    | Annotations for Argo CD server pods                                                                                             | `{}`                     |
| `server.podAffinityPreset`                                 | Pod affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                      | `""`                     |
| `server.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`                   |
| `server.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                                | `""`                     |
| `server.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `server.affinity` is set                                                                    | `""`                     |
| `server.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `server.affinity` is set                                                                 | `[]`                     |
| `server.affinity`                                          | Affinity for Argo CD server pods assignment                                                                                     | `{}`                     |
| `server.nodeSelector`                                      | Node labels for Argo CD server pods assignment                                                                                  | `{}`                     |
| `server.tolerations`                                       | Tolerations for Argo CD server pods assignment                                                                                  | `[]`                     |
| `server.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                  | `""`                     |
| `server.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                  | `[]`                     |
| `server.updateStrategy.type`                               | Argo CD server statefulset strategy type                                                                                        | `RollingUpdate`          |
| `server.priorityClassName`                                 | Argo CD server pods' priorityClassName                                                                                          | `""`                     |
| `server.lifecycleHooks`                                    | for the Argo CD server container(s) to automate configuration before or after startup                                           | `{}`                     |
| `server.extraEnvVars`                                      | Array with extra environment variables to add to Argo CD server nodes                                                           | `[]`                     |
| `server.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Argo CD server nodes                                                   | `""`                     |
| `server.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Argo CD server nodes                                                      | `""`                     |
| `server.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Argo CD server pod(s)                                               | `[]`                     |
| `server.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Argo CD server container(s)                                    | `[]`                     |
| `server.sidecars`                                          | Add additional sidecar containers to the Argo CD server pod(s)                                                                  | `[]`                     |
| `server.initContainers`                                    | Add additional init containers to the Argo CD server pod(s)                                                                     | `[]`                     |
| `server.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                            | `true`                   |
| `server.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                          | `""`                     |
| `server.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                  | `true`                   |
| `server.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                      | `{}`                     |


### Argo CD repo server Parameters

| Name                                                           | Description                                                                                          | Value           |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | --------------- |
| `repoServer.replicaCount`                                      | Number of Argo CD repo server replicas to deploy                                                     | `1`             |
| `repoServer.startupProbe.enabled`                              | Enable startupProbe on Argo CD repo server nodes                                                     | `false`         |
| `repoServer.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                               | `10`            |
| `repoServer.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                      | `10`            |
| `repoServer.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                     | `1`             |
| `repoServer.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                   | `3`             |
| `repoServer.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                   | `1`             |
| `repoServer.livenessProbe.enabled`                             | Enable livenessProbe on Argo CD repo server nodes                                                    | `true`          |
| `repoServer.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                              | `10`            |
| `repoServer.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                     | `10`            |
| `repoServer.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                    | `1`             |
| `repoServer.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                  | `3`             |
| `repoServer.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                  | `1`             |
| `repoServer.readinessProbe.enabled`                            | Enable readinessProbe on Argo CD repo server nodes                                                   | `true`          |
| `repoServer.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                             | `10`            |
| `repoServer.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                    | `10`            |
| `repoServer.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                   | `1`             |
| `repoServer.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                 | `3`             |
| `repoServer.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                 | `1`             |
| `repoServer.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                   | `{}`            |
| `repoServer.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                  | `{}`            |
| `repoServer.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                 | `{}`            |
| `repoServer.resources.limits`                                  | The resources limits for the Argo CD repo server containers                                          | `{}`            |
| `repoServer.resources.requests`                                | The requested resources for the Argo CD repo server containers                                       | `{}`            |
| `repoServer.podSecurityContext.enabled`                        | Enabled Argo CD repo server pods' Security Context                                                   | `true`          |
| `repoServer.podSecurityContext.fsGroup`                        | Set Argo CD repo server pod's Security Context fsGroup                                               | `1001`          |
| `repoServer.containerSecurityContext.enabled`                  | Enabled Argo CD repo server containers' Security Context                                             | `true`          |
| `repoServer.containerSecurityContext.runAsUser`                | Set Argo CD repo server containers' Security Context runAsUser                                       | `1001`          |
| `repoServer.containerSecurityContext.allowPrivilegeEscalation` | Set Argo CD repo server containers' Security Context allowPrivilegeEscalation                        | `false`         |
| `repoServer.containerSecurityContext.capabilities.drop`        | Set Argo CD containers' repo server Security Context capabilities to be dropped                      | `["all"]`       |
| `repoServer.containerSecurityContext.readOnlyRootFilesystem`   | Set Argo CD containers' repo server Security Context readOnlyRootFilesystem                          | `false`         |
| `repoServer.containerSecurityContext.runAsNonRoot`             | Set Argo CD repo server containers' Security Context runAsNonRoot                                    | `true`          |
| `repoServer.service.type`                                      | Repo server service type                                                                             | `ClusterIP`     |
| `repoServer.service.port`                                      | Repo server service port                                                                             | `8081`          |
| `repoServer.service.nodePort`                                  | Node port for the repo server service                                                                | `""`            |
| `repoServer.service.clusterIP`                                 | Repo server service Cluster IP                                                                       | `""`            |
| `repoServer.service.loadBalancerIP`                            | Repo server service Load Balancer IP                                                                 | `""`            |
| `repoServer.service.loadBalancerSourceRanges`                  | Repo server service Load Balancer sources                                                            | `[]`            |
| `repoServer.service.externalTrafficPolicy`                     | Repo server service external traffic policy                                                          | `Cluster`       |
| `repoServer.service.annotations`                               | Additional custom annotations for Repo server service                                                | `{}`            |
| `repoServer.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                       | `[]`            |
| `repoServer.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                 | `None`          |
| `repoServer.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                          | `{}`            |
| `repoServer.logFormat`                                         | Format for the Argo CD repo server logs. Options: [text, json]                                       | `text`          |
| `repoServer.logLevel`                                          | Log level for the Argo CD repo server                                                                | `info`          |
| `repoServer.containerPorts.repoServer`                         | Container port for Argo CD repo server                                                               | `8081`          |
| `repoServer.containerPorts.metrics`                            | Metrics port for Argo CD repo server                                                                 | `8084`          |
| `repoServer.metrics.enabled`                                   | Enable metrics for the Argo CD repo server                                                           | `false`         |
| `repoServer.metrics.service.type`                              | Argo CD repo server service type                                                                     | `ClusterIP`     |
| `repoServer.metrics.service.port`                              | Argo CD repo server metrics service port                                                             | `8084`          |
| `repoServer.metrics.service.nodePort`                          | Node port for the repo server metrics service                                                        | `""`            |
| `repoServer.metrics.service.clusterIP`                         | Argo CD repo server metrics service Cluster IP                                                       | `""`            |
| `repoServer.metrics.service.loadBalancerIP`                    | Argo CD repo server service Load Balancer IP                                                         | `""`            |
| `repoServer.metrics.service.loadBalancerSourceRanges`          | Argo CD repo server service Load Balancer sources                                                    | `[]`            |
| `repoServer.metrics.service.externalTrafficPolicy`             | Argo CD repo server service external traffic policy                                                  | `Cluster`       |
| `repoServer.metrics.service.annotations`                       | Additional custom annotations for Argo CD repo server service                                        | `{}`            |
| `repoServer.metrics.service.sessionAffinity`                   | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                 | `None`          |
| `repoServer.metrics.service.sessionAffinityConfig`             | Additional settings for the sessionAffinity                                                          | `{}`            |
| `repoServer.metrics.serviceMonitor.enabled`                    | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                         | `false`         |
| `repoServer.metrics.serviceMonitor.namespace`                  | Namespace which Prometheus is running in                                                             | `""`            |
| `repoServer.metrics.serviceMonitor.jobLabel`                   | The name of the label on the target service to use as the job name in prometheus.                    | `""`            |
| `repoServer.metrics.serviceMonitor.interval`                   | Interval at which metrics should be scraped                                                          | `30s`           |
| `repoServer.metrics.serviceMonitor.scrapeTimeout`              | Timeout after which the scrape is ended                                                              | `10s`           |
| `repoServer.metrics.serviceMonitor.relabelings`                | RelabelConfigs to apply to samples before scraping                                                   | `[]`            |
| `repoServer.metrics.serviceMonitor.metricRelabelings`          | MetricRelabelConfigs to apply to samples before ingestion                                            | `[]`            |
| `repoServer.metrics.serviceMonitor.selector`                   | ServiceMonitor selector labels                                                                       | `{}`            |
| `repoServer.metrics.serviceMonitor.honorLabels`                | honorLabels chooses the metric's labels on collisions with target labels                             | `false`         |
| `repoServer.autoscaling.enabled`                               | Enable Argo CD repo server deployment autoscaling                                                    | `false`         |
| `repoServer.autoscaling.minReplicas`                           | Argo CD repo server deployment autoscaling minimum number of replicas                                | `1`             |
| `repoServer.autoscaling.maxReplicas`                           | Argo CD repo server deployment autoscaling maximum number of replicas                                | `5`             |
| `repoServer.autoscaling.targetCPU`                             | Argo CD repo server deployment autoscaling target CPU percentage                                     | `50`            |
| `repoServer.autoscaling.targetMemory`                          | Argo CD repo server deployment autoscaling target CPU memory                                         | `50`            |
| `repoServer.serviceAccount.create`                             | Specifies whether a ServiceAccount for repo server should be created                                 | `true`          |
| `repoServer.serviceAccount.name`                               | The name of the ServiceAccount for repo server to use.                                               | `""`            |
| `repoServer.serviceAccount.automountServiceAccountToken`       | Automount service account token for the repo server service account                                  | `true`          |
| `repoServer.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.           | `{}`            |
| `repoServer.command`                                           | Override default container command (useful when using custom images)                                 | `[]`            |
| `repoServer.args`                                              | Override default container args (useful when using custom images)                                    | `[]`            |
| `repoServer.extraArgs`                                         | Add extra args to the default repo server args                                                       | `[]`            |
| `repoServer.hostAliases`                                       | Argo CD repo server pods host aliases                                                                | `[]`            |
| `repoServer.podLabels`                                         | Extra labels for Argo CD repo server pods                                                            | `{}`            |
| `repoServer.podAnnotations`                                    | Annotations for Argo CD repo server pods                                                             | `{}`            |
| `repoServer.podAffinityPreset`                                 | Pod affinity preset. Ignored if `repoServer.affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `repoServer.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `repoServer.affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `repoServer.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `repoServer.affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `repoServer.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `repoServer.affinity` is set                                     | `""`            |
| `repoServer.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `repoServer.affinity` is set                                  | `[]`            |
| `repoServer.affinity`                                          | Affinity for Argo CD repo server pods assignment                                                     | `{}`            |
| `repoServer.nodeSelector`                                      | Node labels for Argo CD repo server pods assignment                                                  | `{}`            |
| `repoServer.tolerations`                                       | Tolerations for Argo CD repo server pods assignment                                                  | `[]`            |
| `repoServer.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                       | `""`            |
| `repoServer.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                       | `[]`            |
| `repoServer.updateStrategy.type`                               | Argo CD repo server statefulset strategy type                                                        | `RollingUpdate` |
| `repoServer.priorityClassName`                                 | Argo CD repo server pods' priorityClassName                                                          | `""`            |
| `repoServer.lifecycleHooks`                                    | for the Argo CD repo server container(s) to automate configuration before or after startup           | `{}`            |
| `repoServer.extraEnvVars`                                      | Array with extra environment variables to add to Argo CD repo server nodes                           | `[]`            |
| `repoServer.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Argo CD repo server nodes                   | `""`            |
| `repoServer.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Argo CD repo server nodes                      | `""`            |
| `repoServer.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Argo CD repo server pod(s)               | `[]`            |
| `repoServer.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Argo CD repo server container(s)    | `[]`            |
| `repoServer.sidecars`                                          | Add additional sidecar containers to the Argo CD repo server pod(s)                                  | `[]`            |
| `repoServer.initContainers`                                    | Add additional init containers to the Argo CD repo server pod(s)                                     | `[]`            |


### Dex Parameters

| Name                                                    | Description                                                                                   | Value                  |
| ------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ---------------------- |
| `dex.image.registry`                                    | Dex image registry                                                                            | `docker.io`            |
| `dex.image.repository`                                  | Dex image repository                                                                          | `bitnami/dex`          |
| `dex.image.tag`                                         | Dex image tag (immutable tags are recommended)                                                | `2.31.1-debian-10-r48` |
| `dex.image.pullPolicy`                                  | Dex image pull policy                                                                         | `IfNotPresent`         |
| `dex.image.pullSecrets`                                 | Dex image pull secrets                                                                        | `[]`                   |
| `dex.image.debug`                                       | Enable Dex image debug mode                                                                   | `false`                |
| `dex.enabled`                                           | Enable the creation of a Dex deployment for SSO                                               | `false`                |
| `dex.replicaCount`                                      | Number of Dex replicas to deploy                                                              | `1`                    |
| `dex.startupProbe.enabled`                              | Enable startupProbe on Dex nodes                                                              | `false`                |
| `dex.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                        | `10`                   |
| `dex.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                               | `10`                   |
| `dex.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                              | `1`                    |
| `dex.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                            | `3`                    |
| `dex.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                            | `1`                    |
| `dex.livenessProbe.enabled`                             | Enable livenessProbe on Dex nodes                                                             | `true`                 |
| `dex.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                       | `10`                   |
| `dex.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                              | `10`                   |
| `dex.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                             | `1`                    |
| `dex.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                           | `3`                    |
| `dex.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                           | `1`                    |
| `dex.readinessProbe.enabled`                            | Enable readinessProbe on Dex nodes                                                            | `true`                 |
| `dex.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                      | `10`                   |
| `dex.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                             | `10`                   |
| `dex.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                            | `1`                    |
| `dex.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                          | `3`                    |
| `dex.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                          | `1`                    |
| `dex.customStartupProbe`                                | Custom startupProbe that overrides the default one                                            | `{}`                   |
| `dex.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                           | `{}`                   |
| `dex.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                          | `{}`                   |
| `dex.resources.limits`                                  | The resources limits for the Dex containers                                                   | `{}`                   |
| `dex.resources.requests`                                | The requested resources for the Dex containers                                                | `{}`                   |
| `dex.podSecurityContext.enabled`                        | Enabled Dex pods' Security Context                                                            | `true`                 |
| `dex.podSecurityContext.fsGroup`                        | Set Dex pod's Security Context fsGroup                                                        | `1001`                 |
| `dex.containerSecurityContext.enabled`                  | Enabled Dex containers' Security Context                                                      | `true`                 |
| `dex.containerSecurityContext.runAsUser`                | Set Dex containers' Security Context runAsUser                                                | `1001`                 |
| `dex.containerSecurityContext.allowPrivilegeEscalation` | Set Dex containers' Security Context allowPrivilegeEscalation                                 | `false`                |
| `dex.containerSecurityContext.readOnlyRootFilesystem`   | Set Dex containers' server Security Context readOnlyRootFilesystem                            | `false`                |
| `dex.containerSecurityContext.runAsNonRoot`             | Set Dex containers' Security Context runAsNonRoot                                             | `true`                 |
| `dex.service.type`                                      | Dex service type                                                                              | `ClusterIP`            |
| `dex.service.ports.http`                                | Dex HTTP service port                                                                         | `5556`                 |
| `dex.service.ports.grpc`                                | Dex grpc service port                                                                         | `5557`                 |
| `dex.service.nodePorts.http`                            | HTTP node port for the Dex service                                                            | `""`                   |
| `dex.service.nodePorts.grpc`                            | gRPC node port for the Dex service                                                            | `""`                   |
| `dex.service.clusterIP`                                 | Dex service Cluster IP                                                                        | `""`                   |
| `dex.service.loadBalancerIP`                            | Dex service Load Balancer IP                                                                  | `""`                   |
| `dex.service.loadBalancerSourceRanges`                  | Dex service Load Balancer sources                                                             | `[]`                   |
| `dex.service.externalTrafficPolicy`                     | Dex service external traffic policy                                                           | `Cluster`              |
| `dex.service.annotations`                               | Additional custom annotations for Dex service                                                 | `{}`                   |
| `dex.service.extraPorts`                                | Extra ports to expose (normally used with the `sidecar` value)                                | `[]`                   |
| `dex.service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                          | `None`                 |
| `dex.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                   | `{}`                   |
| `dex.containerPorts.http`                               | Dex container HTTP port                                                                       | `5556`                 |
| `dex.containerPorts.grpc`                               | Dex gRPC port                                                                                 | `5557`                 |
| `dex.containerPorts.metrics`                            | Dex metrics port                                                                              | `5558`                 |
| `dex.metrics.enabled`                                   | Enable metrics for Dex                                                                        | `false`                |
| `dex.metrics.service.type`                              | Dex service type                                                                              | `ClusterIP`            |
| `dex.metrics.service.port`                              | Dex metrics service port                                                                      | `5558`                 |
| `dex.metrics.service.nodePort`                          | Node port for the Dex service                                                                 | `""`                   |
| `dex.metrics.service.clusterIP`                         | Dex service metrics service Cluster IP                                                        | `""`                   |
| `dex.metrics.service.loadBalancerIP`                    | Dex service Load Balancer IP                                                                  | `""`                   |
| `dex.metrics.service.loadBalancerSourceRanges`          | Dex service Load Balancer sources                                                             | `[]`                   |
| `dex.metrics.service.externalTrafficPolicy`             | Dex service external traffic policy                                                           | `Cluster`              |
| `dex.metrics.service.annotations`                       | Additional custom annotations for Dex service                                                 | `{}`                   |
| `dex.metrics.service.sessionAffinity`                   | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                          | `None`                 |
| `dex.metrics.service.sessionAffinityConfig`             | Additional settings for the sessionAffinity                                                   | `{}`                   |
| `dex.metrics.serviceMonitor.enabled`                    | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                  | `false`                |
| `dex.metrics.serviceMonitor.namespace`                  | Namespace which Prometheus is running in                                                      | `""`                   |
| `dex.metrics.serviceMonitor.jobLabel`                   | The name of the label on the target service to use as the job name in prometheus.             | `""`                   |
| `dex.metrics.serviceMonitor.interval`                   | Interval at which metrics should be scraped                                                   | `30s`                  |
| `dex.metrics.serviceMonitor.scrapeTimeout`              | Timeout after which the scrape is ended                                                       | `10s`                  |
| `dex.metrics.serviceMonitor.relabelings`                | RelabelConfigs to apply to samples before scraping                                            | `[]`                   |
| `dex.metrics.serviceMonitor.metricRelabelings`          | MetricRelabelConfigs to apply to samples before ingestion                                     | `[]`                   |
| `dex.metrics.serviceMonitor.selector`                   | ServiceMonitor selector labels                                                                | `{}`                   |
| `dex.metrics.serviceMonitor.honorLabels`                | honorLabels chooses the metric's labels on collisions with target labels                      | `false`                |
| `dex.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created for Dex                                  | `true`                 |
| `dex.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                        | `""`                   |
| `dex.serviceAccount.automountServiceAccountToken`       | Automount service account token for the Dex service account                                   | `true`                 |
| `dex.serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.    | `{}`                   |
| `dex.command`                                           | Override default container command (useful when using custom images)                          | `[]`                   |
| `dex.args`                                              | Override default container args (useful when using custom images)                             | `[]`                   |
| `dex.extraArgs`                                         | Add extra args to the default args for Dex                                                    | `[]`                   |
| `dex.hostAliases`                                       | Dex pods host aliases                                                                         | `[]`                   |
| `dex.podLabels`                                         | Extra labels for Dex pods                                                                     | `{}`                   |
| `dex.podAnnotations`                                    | Annotations for Dex pods                                                                      | `{}`                   |
| `dex.podAffinityPreset`                                 | Pod affinity preset. Ignored if `dex.affinity` is set. Allowed values: `soft` or `hard`       | `""`                   |
| `dex.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `dex.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                 |
| `dex.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `dex.affinity` is set. Allowed values: `soft` or `hard` | `""`                   |
| `dex.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `dex.affinity` is set                                     | `""`                   |
| `dex.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `dex.affinity` is set                                  | `[]`                   |
| `dex.affinity`                                          | Affinity for Dex pods assignment                                                              | `{}`                   |
| `dex.nodeSelector`                                      | Node labels for Dex pods assignment                                                           | `{}`                   |
| `dex.tolerations`                                       | Tolerations for Dex pods assignment                                                           | `[]`                   |
| `dex.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                | `""`                   |
| `dex.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                | `[]`                   |
| `dex.updateStrategy.type`                               | Dex statefulset strategy type                                                                 | `RollingUpdate`        |
| `dex.priorityClassName`                                 | Dex pods' priorityClassName                                                                   | `""`                   |
| `dex.lifecycleHooks`                                    | for the Dex container(s) to automate configuration before or after startup                    | `{}`                   |
| `dex.extraEnvVars`                                      | Array with extra environment variables to add to Dex nodes                                    | `[]`                   |
| `dex.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Dex nodes                            | `""`                   |
| `dex.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Dex nodes                               | `""`                   |
| `dex.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Dex pod(s)                        | `[]`                   |
| `dex.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Dex container(s)             | `[]`                   |
| `dex.sidecars`                                          | Add additional sidecar containers to the Dex pod(s)                                           | `[]`                   |
| `dex.initContainers`                                    | Add additional init containers to the Dex pod(s)                                              | `[]`                   |


### Shared config for Argo CD components

| Name                                           | Description                                                                                           | Value  |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------ |
| `config.knownHosts`                            | Known hosts to be added to the known hosts list by default. Check the values to see the default value | `""`   |
| `config.extraKnownHosts`                       | Add extra known hosts to the known hosts list                                                         | `""`   |
| `config.createExtraKnownHosts`                 | Whether to create or not the extra known hosts configmap                                              | `true` |
| `config.styles`                                | Custom CSS styles                                                                                     | `""`   |
| `config.existingStylesConfigmap`               | Use an existing styles configmap                                                                      | `""`   |
| `config.tlsCerts`                              | TLS certificates used to verify the authenticity of the repository servers                            | `{}`   |
| `config.secret.create`                         | Whether to create or not the secret                                                                   | `true` |
| `config.secret.annotations`                    | General secret extra annotations                                                                      | `{}`   |
| `config.secret.githubSecret`                   | GitHub secret to configure webhooks                                                                   | `""`   |
| `config.secret.gitlabSecret`                   | GitLab secret to configure webhooks                                                                   | `""`   |
| `config.secret.bitbucketServerSecret`          | BitBucket secret to configure webhooks                                                                | `""`   |
| `config.secret.bitbucketUUID`                  | BitBucket UUID to configure webhooks                                                                  | `""`   |
| `config.secret.gogsSecret`                     | Gogs secret to configure webhooks                                                                     | `""`   |
| `config.secret.extra`                          | Extra keys to add to the configuration secret.                                                        | `{}`   |
| `config.secret.argocdServerTlsConfig.key`      | TLS key for the Argo CD config secret                                                                 | `""`   |
| `config.secret.argocdServerTlsConfig.crt`      | TLS certificate for the Argo CD config secret                                                         | `""`   |
| `config.secret.argocdServerAdminPassword`      | Argo CD server admin password. Autogenerated by default.                                              | `""`   |
| `config.secret.argocdServerAdminPasswordMtime` | Argo CD server password modification time                                                             | `""`   |
| `config.secret.repositoryCredentials`          | Repository credentials to add to the Argo CD server confgi secret                                     | `{}`   |
| `config.clusterCredentials`                    | Configure external cluster credentials                                                                | `[]`   |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                   |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `10-debian-10-r424`     |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |


### Other Parameters

| Name                                      | Description                                                                 | Value                 |
| ----------------------------------------- | --------------------------------------------------------------------------- | --------------------- |
| `rbac.create`                             | Specifies whether RBAC resources should be created                          | `true`                |
| `redis.image.registry`                    | Argo CD controller image registry                                           | `docker.io`           |
| `redis.image.repository`                  | Argo CD controller image repository                                         | `bitnami/redis`       |
| `redis.image.tag`                         | Argo CD controller image tag (immutable tags are recommended)               | `6.2.7-debian-10-r15` |
| `redis.image.pullPolicy`                  | Argo CD controller image pull policy                                        | `IfNotPresent`        |
| `redis.image.pullSecrets`                 | Argo CD controller image pull secrets                                       | `[]`                  |
| `redis.enabled`                           | Enable Redis dependency                                                     | `true`                |
| `redis.nameOverride`                      | Name override for the Redis dependency                                      | `""`                  |
| `redis.service.port`                      | Service port for Redis dependency                                           | `6379`                |
| `redis.auth.enabled`                      | Enable Redis dependency authentication                                      | `true`                |
| `redis.auth.existingSecret`               | Existing secret to load redis dependency password                           | `""`                  |
| `redis.auth.existingSecretPasswordKey`    | Pasword key name inside the existing secret                                 | `redis-password`      |
| `redis.architecture`                      | Redis&reg; architecture. Allowed values: `standalone` or `replication`    | `standalone`          |
| `externalRedis.host`                      | External Redis host                                                         | `""`                  |
| `externalRedis.port`                      | External Redis port                                                         | `6379`                |
| `externalRedis.password`                  | External Redis password                                                     | `""`                  |
| `externalRedis.existingSecret`            | Existing secret for the external redis                                      | `""`                  |
| `externalRedis.existingSecretPasswordKey` | Password key for the existing secret containing the external redis password | `redis-password`      |


The above parameters map to the env variables defined in [bitnami/argo-cd](https://github.com/bitnami/bitnami-docker-argo-cd). For more information please refer to the [bitnami/argo-cd](https://github.com/bitnami/bitnami-docker-argo-cd) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set controller.replicaCount=2 \
  --set server.metrics.enabled=true \
    bitnami/argo-cd
```

The above command sets the argo-cd controller replicas to 2, and enabled argo-cd server metrics.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/argo-cd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Argo CD.

To enable Ingress integration, set `server.ingress.enabled` to `true` for the http ingress or `server.grpcIngress.enabled` to `true` for the gRPC ingress. The `xxx.ingress.hostname` property can be used to set the host name. The `xxx.ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/infrastructure/argo-cd/configuration/configure-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/infrastructure/argo-cd/administration/enable-tls-ingress/).

Apart from the Ingress TLS certificates, Argo CD repo server will auto-generate a secret named `argocd-repo-server-tls`. This secret contains the TLS configuration for the Argo CD components. The secret will be created only if it does not exist, so if you want to add custom TLS configuration you can create a secret with that name before installing the chart.

### Default config maps and secrets

The chart has hardcoded names for some ConfigMaps and Secrets like `argocd-ssh-known-hosts-cm`, `argocd-repo-server-tls` or `argocd-ssh-known-hosts-cm`. Argo CD will search for those specific names when the chart installed, so installing the chart twice in the same namespaces is not possible due to this restriction.
For more information about each configmap or secret check the references at the corresponding YAML files.

### Using SSO

In order to use SSO you need to enable Dex by setting `dex.enabled=true`. You can follow [this guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#1-register-the-application-in-the-identity-provider) to configure your Argo CD deployment into your identity provider. After that, you need to configure Argo CD like described [here](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#2-configure-argo-cd-for-sso). You can set the Dex configuration at `server.config.dex\.config` that will populate the `argocd-cm` config map.

> NOTE: `dex.config` is the key of the object. IF you are using the Helm CLI to set the parameter you need to scape the `.` like `--set server.config.dex\.config`.

> IMPORTANT: if you enable Dex without configuring it you will get an error similar to `msg="dex is not configured"`, and the Dex pod will never reach the running state.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
argo-cd:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as argo-cd (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/infrastructure/argo-cd/configuration/configure-sidecar-init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.0.0

This major update the Redis&reg; subchart to its newest major, 16.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1600) you can find more info about the specific changes.

Additionally, this chart has been standardised adding features from other charts.

### To 2.0.0

This major update the Redis&reg; subchart to its newest major, 15.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1500) you can find more info about the specific changes.

### To 1.0.0

In this version, the `image` block is defined once and is used in the different templates, while in the previous version, the `image` block was duplicated for every component

```yaml
image:
  registry: docker.io
  repository: bitnami/argo-cd
  tag: 2.0.5
```
VS
```yaml
controller:
  image:
    registry: docker.io
    repository: bitnami/argo-cd
    tag: 2.0.5
...
server:
  image:
    registry: docker.io
    repository: bitnami/argo-cd
    tag: 2.0.5
...
repoServer:
  image:
    registry: docker.io
    repository: bitnami/argo-cd
    tag: 2.0.5
```

See [PR#7113](https://github.com/bitnami/charts/pull/7113) for more info about the implemented changes

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