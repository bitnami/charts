<!--- app-name: Pinniped -->

# Pinniped packaged by Bitnami

Pinniped is an identity service provider for Kubernetes. Provides a consistent, unified login experience across all your clusters, allowing enteprise IDP protocols.

[Overview of Pinniped](https://pinniped.dev/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ helm repo add my-repo https://charts.bitnami.com/bitnami
$ helm install my-release my-repo/pinniped
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Grafana Loki](https://github.com/grafana/loki) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/infrastructure/grafana-loki/get-started/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release my-repo/pinniped
```

The command deploys pinniped on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                | Description                                                                                              | Value               |
| ------------------- | -------------------------------------------------------------------------------------------------------- | ------------------- |
| `kubeVersion`       | Override Kubernetes version                                                                              | `""`                |
| `nameOverride`      | String to partially override common.names.name                                                           | `""`                |
| `fullnameOverride`  | String to fully override common.names.fullname                                                           | `""`                |
| `namespaceOverride` | String to fully override common.names.namespace                                                          | `""`                |
| `commonLabels`      | Labels to add to all deployed objects                                                                    | `{}`                |
| `commonAnnotations` | Annotations to add to all deployed objects                                                               | `{}`                |
| `clusterDomain`     | Kubernetes cluster domain name                                                                           | `cluster.local`     |
| `extraDeploy`       | Array of extra objects to deploy with the release                                                        | `[]`                |
| `image.registry`    | Pinniped image registry                                                                                  | `docker.io`         |
| `image.repository`  | Pinniped image repository                                                                                | `bitnami/pinniped`  |
| `image.tag`         | Pinniped image tag (immutable tags are recommended)                                                      | `0.20.0-scratch-r0` |
| `image.digest`      | Pinniped image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                |
| `image.pullPolicy`  | Pinniped image pull policy                                                                               | `IfNotPresent`      |
| `image.pullSecrets` | Pinniped image pull secrets                                                                              | `[]`                |


### Concierge Parameters

| Name                                                        | Description                                                                                                              | Value           |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `concierge.enabled`                                         | Deploy Concierge                                                                                                         | `true`          |
| `concierge.replicaCount`                                    | Number of Concierge replicas to deploy                                                                                   | `1`             |
| `concierge.containerPorts.api`                              | Concierge API container port                                                                                             | `10250`         |
| `concierge.containerPorts.proxy`                            | Concierge Proxy container port                                                                                           | `8443`          |
| `concierge.configurationPorts.aggregatedAPIServerPort`      | Concierge API configuration port                                                                                         | `""`            |
| `concierge.configurationPorts.impersonationProxyServerPort` | Concierge Proxy configuration port                                                                                       | `""`            |
| `concierge.hostNetwork`                                     | Concierge API and Proxy container hostNetwork                                                                            | `false`         |
| `concierge.dnsPolicy`                                       | Concierge API and Proxy container dnsPolicy                                                                              | `""`            |
| `concierge.configuration`                                   | Concierge pinniped.yaml configuration file                                                                               | `""`            |
| `concierge.credentialIssuerConfig`                          | Configuration for the credential issuer                                                                                  | `""`            |
| `concierge.livenessProbe.enabled`                           | Enable livenessProbe on Concierge containers                                                                             | `true`          |
| `concierge.livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                  | `10`            |
| `concierge.livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                         | `10`            |
| `concierge.livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                        | `1`             |
| `concierge.livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                      | `3`             |
| `concierge.livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                      | `1`             |
| `concierge.readinessProbe.enabled`                          | Enable readinessProbe on Concierge containers                                                                            | `true`          |
| `concierge.readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                 | `10`            |
| `concierge.readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                        | `10`            |
| `concierge.readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                       | `1`             |
| `concierge.readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                     | `3`             |
| `concierge.readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                     | `1`             |
| `concierge.startupProbe.enabled`                            | Enable startupProbe on Concierge containers                                                                              | `false`         |
| `concierge.startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                   | `10`            |
| `concierge.startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                          | `10`            |
| `concierge.startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                         | `1`             |
| `concierge.startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                       | `3`             |
| `concierge.startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                       | `1`             |
| `concierge.customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                      | `{}`            |
| `concierge.customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                     | `{}`            |
| `concierge.customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                       | `{}`            |
| `concierge.resources.limits`                                | The resources limits for the Concierge containers                                                                        | `{}`            |
| `concierge.resources.requests`                              | The requested resources for the Concierge containers                                                                     | `{}`            |
| `concierge.podSecurityContext.enabled`                      | Enabled Concierge pods' Security Context                                                                                 | `true`          |
| `concierge.podSecurityContext.fsGroup`                      | Set Concierge pod's Security Context fsGroup                                                                             | `1001`          |
| `concierge.containerSecurityContext.enabled`                | Enabled Concierge containers' Security Context                                                                           | `true`          |
| `concierge.containerSecurityContext.runAsUser`              | Set Concierge containers' Security Context runAsUser                                                                     | `1001`          |
| `concierge.containerSecurityContext.runAsNonRoot`           | Set Concierge containers' Security Context runAsNonRoot                                                                  | `true`          |
| `concierge.containerSecurityContext.readOnlyRootFilesystem` | Enable readOnlyRootFilesystem                                                                                            | `false`         |
| `concierge.existingConfigmap`                               | The name of an existing ConfigMap with your custom configuration for Concierge                                           | `""`            |
| `concierge.command`                                         | Override default container command (useful when using custom images)                                                     | `[]`            |
| `concierge.args`                                            | Override default container args (useful when using custom images)                                                        | `[]`            |
| `concierge.deployAPIService`                                | Deploy the APIService objects                                                                                            | `true`          |
| `concierge.hostAliases`                                     | Concierge pods host aliases                                                                                              | `[]`            |
| `concierge.podLabels`                                       | Extra labels for Concierge pods                                                                                          | `{}`            |
| `concierge.podAnnotations`                                  | Annotations for Concierge pods                                                                                           | `{}`            |
| `concierge.podAffinityPreset`                               | Pod affinity preset. Ignored if `concierge.affinity` is set. Allowed values: `soft` or `hard`                            | `""`            |
| `concierge.podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `concierge.affinity` is set. Allowed values: `soft` or `hard`                       | `soft`          |
| `concierge.nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `concierge.affinity` is set. Allowed values: `soft` or `hard`                      | `""`            |
| `concierge.nodeAffinityPreset.key`                          | Node label key to match. Ignored if `concierge.affinity` is set                                                          | `""`            |
| `concierge.nodeAffinityPreset.values`                       | Node label values to match. Ignored if `concierge.affinity` is set                                                       | `[]`            |
| `concierge.affinity`                                        | Affinity for Concierge pods assignment                                                                                   | `{}`            |
| `concierge.nodeSelector`                                    | Node labels for Concierge pods assignment                                                                                | `{}`            |
| `concierge.tolerations`                                     | Tolerations for Concierge pods assignment                                                                                | `[]`            |
| `concierge.updateStrategy.type`                             | Concierge statefulset strategy type                                                                                      | `RollingUpdate` |
| `concierge.priorityClassName`                               | Concierge pods' priorityClassName                                                                                        | `""`            |
| `concierge.topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `{}`            |
| `concierge.schedulerName`                                   | Name of the k8s scheduler (other than default) for Concierge pods                                                        | `""`            |
| `concierge.terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`            |
| `concierge.lifecycleHooks`                                  | for the Concierge container(s) to automate configuration before or after startup                                         | `{}`            |
| `concierge.extraEnvVars`                                    | Array with extra environment variables to add to Concierge nodes                                                         | `[]`            |
| `concierge.extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for Concierge nodes                                                 | `""`            |
| `concierge.extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for Concierge nodes                                                    | `""`            |
| `concierge.extraVolumes`                                    | Optionally specify extra list of additional volumes for the Concierge pod(s)                                             | `[]`            |
| `concierge.extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the Concierge container(s)                                  | `[]`            |
| `concierge.sidecars`                                        | Add additional sidecar containers to the Concierge pod(s)                                                                | `[]`            |
| `concierge.initContainers`                                  | Add additional init containers to the Concierge pod(s)                                                                   | `[]`            |


### Concierge RBAC settings

| Name                                                                         | Description                                                                   | Value  |
| ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------ |
| `concierge.rbac.create`                                                      | Create Concierge RBAC objects                                                 | `true` |
| `concierge.serviceAccount.concierge.name`                                    | Name of an existing Service Account for the Concierge Deployment              | `""`   |
| `concierge.serviceAccount.concierge.create`                                  | Create a Service Account for the Concierge Deployment                         | `true` |
| `concierge.serviceAccount.concierge.automountServiceAccountToken`            | Auto mount token for the Concierge Deployment Service Account                 | `true` |
| `concierge.serviceAccount.concierge.annotations`                             | Annotations for the Concierge Service Account                                 | `{}`   |
| `concierge.serviceAccount.impersonationProxy.name`                           | Name of an existing Service Account for the Concierge Impersonator            | `""`   |
| `concierge.serviceAccount.impersonationProxy.create`                         | Create a Service Account for the Concierge Impersonator                       | `true` |
| `concierge.serviceAccount.impersonationProxy.automountServiceAccountToken`   | Auto mount token for the Concierge Impersonator Service Account               | `true` |
| `concierge.serviceAccount.impersonationProxy.annotations`                    | Annotations for the Concierge Service Account                                 | `{}`   |
| `concierge.serviceAccount.kubeCertAgentService.name`                         | Name of an existing Service Account for the Concierge kube-cert-agent-service | `""`   |
| `concierge.serviceAccount.kubeCertAgentService.create`                       | Create a Service Account for the Concierge kube-cert-agent-service            | `true` |
| `concierge.serviceAccount.kubeCertAgentService.automountServiceAccountToken` | Auto mount token for the Concierge kube-cert-agent-service Service Account    | `true` |
| `concierge.serviceAccount.kubeCertAgentService.annotations`                  | Annotations for the Concierge Service Account                                 | `{}`   |


### Concierge Traffic Exposure Parameters

| Name                                         | Description                                                                          | Value       |
| -------------------------------------------- | ------------------------------------------------------------------------------------ | ----------- |
| `concierge.service.type`                     | Concierge service type                                                               | `ClusterIP` |
| `concierge.service.ports.https`              | Concierge service HTTPS port                                                         | `443`       |
| `concierge.service.nodePorts.https`          | Node port for HTTPS                                                                  | `""`        |
| `concierge.service.clusterIP`                | Concierge service Cluster IP                                                         | `""`        |
| `concierge.service.labels`                   | Add labels to the service                                                            | `{}`        |
| `concierge.service.loadBalancerIP`           | Concierge service Load Balancer IP                                                   | `""`        |
| `concierge.service.loadBalancerSourceRanges` | Concierge service Load Balancer sources                                              | `[]`        |
| `concierge.service.externalTrafficPolicy`    | Concierge service external traffic policy                                            | `Cluster`   |
| `concierge.service.annotations`              | Additional custom annotations for Concierge service                                  | `{}`        |
| `concierge.service.extraPorts`               | Extra ports to expose in Concierge service (normally used with the `sidecars` value) | `[]`        |
| `concierge.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                     | `None`      |
| `concierge.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                          | `{}`        |


### Supervisor Parameters

| Name                                                         | Description                                                                                                              | Value           |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `supervisor.enabled`                                         | Deploy Supervisor                                                                                                        | `true`          |
| `supervisor.replicaCount`                                    | Number of Supervisor replicas to deploy                                                                                  | `1`             |
| `supervisor.containerPorts.https`                            | Supervisor HTTP container port                                                                                           | `8443`          |
| `supervisor.deployAPIService`                                | Deploy the APIService objects                                                                                            | `true`          |
| `supervisor.configuration`                                   | Supervisor pinniped.yaml configuration file                                                                              | `""`            |
| `supervisor.livenessProbe.enabled`                           | Enable livenessProbe on Supervisor containers                                                                            | `true`          |
| `supervisor.livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                  | `10`            |
| `supervisor.livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                         | `10`            |
| `supervisor.livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                        | `1`             |
| `supervisor.livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                      | `3`             |
| `supervisor.livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                      | `1`             |
| `supervisor.readinessProbe.enabled`                          | Enable readinessProbe on Supervisor containers                                                                           | `true`          |
| `supervisor.readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                 | `10`            |
| `supervisor.readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                        | `10`            |
| `supervisor.readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                       | `1`             |
| `supervisor.readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                     | `3`             |
| `supervisor.readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                     | `1`             |
| `supervisor.startupProbe.enabled`                            | Enable startupProbe on Supervisor containers                                                                             | `false`         |
| `supervisor.startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                   | `10`            |
| `supervisor.startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                          | `10`            |
| `supervisor.startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                         | `1`             |
| `supervisor.startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                       | `3`             |
| `supervisor.startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                       | `1`             |
| `supervisor.customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                      | `{}`            |
| `supervisor.customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                     | `{}`            |
| `supervisor.customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                       | `{}`            |
| `supervisor.resources.limits`                                | The resources limits for the Supervisor containers                                                                       | `{}`            |
| `supervisor.resources.requests`                              | The requested resources for the Supervisor containers                                                                    | `{}`            |
| `supervisor.podSecurityContext.enabled`                      | Enabled Supervisor pods' Security Context                                                                                | `true`          |
| `supervisor.podSecurityContext.fsGroup`                      | Set Supervisor pod's Security Context fsGroup                                                                            | `1001`          |
| `supervisor.containerSecurityContext.enabled`                | Enabled Supervisor containers' Security Context                                                                          | `true`          |
| `supervisor.containerSecurityContext.runAsUser`              | Set Supervisor containers' Security Context runAsUser                                                                    | `1001`          |
| `supervisor.containerSecurityContext.runAsNonRoot`           | Set Supervisor containers' Security Context runAsNonRoot                                                                 | `true`          |
| `supervisor.containerSecurityContext.readOnlyRootFilesystem` | Enable readOnlyRootFilesystem                                                                                            | `false`         |
| `supervisor.existingConfigmap`                               | The name of an existing ConfigMap with your custom configuration for Supervisor                                          | `""`            |
| `supervisor.command`                                         | Override default container command (useful when using custom images)                                                     | `[]`            |
| `supervisor.args`                                            | Override default container args (useful when using custom images)                                                        | `[]`            |
| `supervisor.hostAliases`                                     | Supervisor pods host aliases                                                                                             | `[]`            |
| `supervisor.podLabels`                                       | Extra labels for Supervisor pods                                                                                         | `{}`            |
| `supervisor.podAnnotations`                                  | Annotations for Supervisor pods                                                                                          | `{}`            |
| `supervisor.podAffinityPreset`                               | Pod affinity preset. Ignored if `supervisor.affinity` is set. Allowed values: `soft` or `hard`                           | `""`            |
| `supervisor.podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `supervisor.affinity` is set. Allowed values: `soft` or `hard`                      | `soft`          |
| `supervisor.nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `supervisor.affinity` is set. Allowed values: `soft` or `hard`                     | `""`            |
| `supervisor.nodeAffinityPreset.key`                          | Node label key to match. Ignored if `supervisor.affinity` is set                                                         | `""`            |
| `supervisor.nodeAffinityPreset.values`                       | Node label values to match. Ignored if `supervisor.affinity` is set                                                      | `[]`            |
| `supervisor.affinity`                                        | Affinity for Supervisor pods assignment                                                                                  | `{}`            |
| `supervisor.nodeSelector`                                    | Node labels for Supervisor pods assignment                                                                               | `{}`            |
| `supervisor.tolerations`                                     | Tolerations for Supervisor pods assignment                                                                               | `[]`            |
| `supervisor.updateStrategy.type`                             | Supervisor statefulset strategy type                                                                                     | `RollingUpdate` |
| `supervisor.priorityClassName`                               | Supervisor pods' priorityClassName                                                                                       | `""`            |
| `supervisor.topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `{}`            |
| `supervisor.schedulerName`                                   | Name of the k8s scheduler (other than default) for Supervisor pods                                                       | `""`            |
| `supervisor.terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                        | `""`            |
| `supervisor.lifecycleHooks`                                  | for the Supervisor container(s) to automate configuration before or after startup                                        | `{}`            |
| `supervisor.extraEnvVars`                                    | Array with extra environment variables to add to Supervisor nodes                                                        | `[]`            |
| `supervisor.extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for Supervisor nodes                                                | `""`            |
| `supervisor.extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for Supervisor nodes                                                   | `""`            |
| `supervisor.extraVolumes`                                    | Optionally specify extra list of additional volumes for the Supervisor pod(s)                                            | `[]`            |
| `supervisor.extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the Supervisor container(s)                                 | `[]`            |
| `supervisor.sidecars`                                        | Add additional sidecar containers to the Supervisor pod(s)                                                               | `[]`            |
| `supervisor.initContainers`                                  | Add additional init containers to the Supervisor pod(s)                                                                  | `[]`            |


### Supervisor RBAC settings

| Name                                                     | Description                                                       | Value  |
| -------------------------------------------------------- | ----------------------------------------------------------------- | ------ |
| `supervisor.rbac.create`                                 | Create Supervisor RBAC objects                                    | `true` |
| `supervisor.serviceAccount.name`                         | Name of an existing Service Account for the Supervisor Deployment | `""`   |
| `supervisor.serviceAccount.create`                       | Create a Service Account for the Supervisor Deployment            | `true` |
| `supervisor.serviceAccount.automountServiceAccountToken` | Auto mount token for the Supervisor Deployment Service Account    | `true` |
| `supervisor.serviceAccount.annotations`                  | Annotations for the Supervisor Service Account                    | `{}`   |


### Supervisor Traffic Exposure Parameters

| Name                                          | Description                                                                                                                      | Value                       |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `supervisor.service.type`                     | Supervisor service type                                                                                                          | `LoadBalancer`              |
| `supervisor.service.ports.https`              | Supervisor service HTTPS port                                                                                                    | `443`                       |
| `supervisor.service.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                        |
| `supervisor.service.clusterIP`                | Supervisor service Cluster IP                                                                                                    | `""`                        |
| `supervisor.service.labels`                   | Add labels to the service                                                                                                        | `{}`                        |
| `supervisor.service.loadBalancerIP`           | Supervisor service Load Balancer IP                                                                                              | `""`                        |
| `supervisor.service.loadBalancerSourceRanges` | Supervisor service Load Balancer sources                                                                                         | `[]`                        |
| `supervisor.service.externalTrafficPolicy`    | Supervisor service external traffic policy                                                                                       | `Cluster`                   |
| `supervisor.service.annotations`              | Additional custom annotations for Supervisor service                                                                             | `{}`                        |
| `supervisor.service.extraPorts`               | Extra ports to expose in Supervisor service (normally used with the `sidecars` value)                                            | `[]`                        |
| `supervisor.service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                      |
| `supervisor.service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                        |
| `supervisor.ingress.enabled`                  | Enable ingress record generation for Pinniped Supervisor                                                                         | `false`                     |
| `supervisor.ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific`    |
| `supervisor.ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                        |
| `supervisor.ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                        |
| `supervisor.ingress.hostname`                 | Default host for the ingress record                                                                                              | `pinniped-supervisor.local` |
| `supervisor.ingress.path`                     | Default path for the ingress record                                                                                              | `/`                         |
| `supervisor.ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                        |
| `supervisor.ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                     |
| `supervisor.ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                     |
| `supervisor.ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                        |
| `supervisor.ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                        |
| `supervisor.ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                        |
| `supervisor.ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                        |
| `supervisor.ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                        |


See https://github.com/bitnami-labs/readme-generator-for-helm to create the table

The above parameters map to the env variables defined in [bitnami/pinniped](https://github.com/bitnami/containers/tree/main/bitnami/pinniped). For more information please refer to the [bitnami/pinniped](https://github.com/bitnami/containers/tree/main/bitnami/pinniped) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set supervisor.enabled=false \
    my-repo/pinniped
```

The above command sets disables the supervisor compoment deployment.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml my-repo/pinniped
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami pinniped](https://github.com/bitnami/containers/tree/main/bitnami/pinniped) image stores the pinniped data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. [Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/apps/pinniped/configuration/chart-persistence/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
pinniped:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as pinniped (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/pinniped/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 0.4.0

This version updates Pinniped to its newest version, 0.20.x. For more information, please refer to [the release notes](https://github.com/vmware-tanzu/pinniped/releases/tag/v0.20.0).

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