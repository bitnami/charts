<!--- app-name: Argo Workflows -->

# Argo Workflows packaged by Bitnami

Argo Workflows is meant to orchestrate Kubernetes jobs in parallel. It uses DAG and step-based workflows

[Overview of Argo Workflows](https://argoproj.github.io/workflows)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/argo-workflows
```

## Introduction

This chart bootstraps a [Argo Workflows](https://argoproj.github.io/workflows) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/argo-workflowss
```

The command deploys Argo Workflows on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                   | Description                                                                                                                                                                                                           | Value           |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`          | Override Kubernetes version                                                                                                                                                                                           | `""`            |
| `nameOverride`         | String to partially override common.names.fullname                                                                                                                                                                    | `""`            |
| `fullnameOverride`     | String to fully override common.names.fullname                                                                                                                                                                        | `""`            |
| `commonLabels`         | Labels to add to all deployed objects                                                                                                                                                                                 | `{}`            |
| `commonAnnotations`    | Annotations to add to all deployed objects                                                                                                                                                                            | `{}`            |
| `clusterDomain`        | Kubernetes cluster domain name                                                                                                                                                                                        | `cluster.local` |
| `extraDeploy`          | Array of extra objects to deploy with the release                                                                                                                                                                     | `[]`            |
| `rbac.singleNamespace` | Restrict Argo to only deploy into a single namespace by apply Roles and RoleBindings instead of the Cluster equivalents, and start argo-cli with the --namespaced flag. Use it in clusters with strict access policy. | `false`         |
| `createAggregateRoles` | Create Aggregated cluster roles                                                                                                                                                                                       | `true`          |


### Argo Workflows Server configuration parameters

| Name                                                     | Description                                                                                                         | Value                       |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `server.image.registry`                                  | server image registry                                                                                               | `docker.io`                 |
| `server.image.repository`                                | server image repository                                                                                             | `bitnami/argo-workflow-cli` |
| `server.image.tag`                                       | server image tag (immutable tags are recommended)                                                                   | `3.3.9-scratch-r2`          |
| `server.image.digest`                                    | server image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag              | `""`                        |
| `server.image.pullPolicy`                                | server image pull policy                                                                                            | `Always`                    |
| `server.image.pullSecrets`                               | server image pull secrets                                                                                           | `[]`                        |
| `server.enabled`                                         | Enable server deployment                                                                                            | `true`                      |
| `server.replicaCount`                                    | Number of server replicas to deploy                                                                                 | `1`                         |
| `server.livenessProbe.enabled`                           | Enable livenessProbe on server nodes                                                                                | `true`                      |
| `server.livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                             | `10`                        |
| `server.livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                    | `20`                        |
| `server.livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                   | `1`                         |
| `server.livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                 | `3`                         |
| `server.livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                 | `1`                         |
| `server.readinessProbe.enabled`                          | Enable readinessProbe on server nodes                                                                               | `true`                      |
| `server.readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                            | `10`                        |
| `server.readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                   | `20`                        |
| `server.readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                  | `1`                         |
| `server.readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                | `3`                         |
| `server.readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                | `1`                         |
| `server.startupProbe.enabled`                            | Enable startupProbe                                                                                                 | `false`                     |
| `server.startupProbe.path`                               | Path to check for startupProbe                                                                                      | `/`                         |
| `server.startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                              | `300`                       |
| `server.startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                     | `10`                        |
| `server.startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                    | `5`                         |
| `server.startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                  | `6`                         |
| `server.startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                  | `1`                         |
| `server.customLivenessProbe`                             | Server custom livenessProbe that overrides the default one                                                          | `{}`                        |
| `server.customReadinessProbe`                            | Server custom readinessProbe that overrides the default one                                                         | `{}`                        |
| `server.customStartupProbe`                              | Server custom startupProbe that overrides the default one                                                           | `{}`                        |
| `server.resources.limits`                                | The resources limits for the server containers                                                                      | `{}`                        |
| `server.resources.requests`                              | The requested resources for the server containers                                                                   | `{}`                        |
| `server.podSecurityContext.enabled`                      | Enabled server pods' Security Context                                                                               | `true`                      |
| `server.podSecurityContext.fsGroup`                      | Set server pod's Security Context fsGroup                                                                           | `1001`                      |
| `server.containerSecurityContext.enabled`                | Enabled server containers' Security Context                                                                         | `true`                      |
| `server.containerSecurityContext.runAsUser`              | Set server containers' Security Context runAsUser                                                                   | `1001`                      |
| `server.containerSecurityContext.runAsNonRoot`           | Set server containers' Security Context runAsNonRoot                                                                | `true`                      |
| `server.containerSecurityContext.readOnlyRootFilesystem` | Set read only root file system pod's Security Conte                                                                 | `true`                      |
| `server.rbac.create`                                     | Create RBAC resources for the Argo workflows server                                                                 | `true`                      |
| `server.extraArgs`                                       | Extra arguments for the server command line                                                                         | `""`                        |
| `server.auth.enabled`                                    | Enable authentication                                                                                               | `true`                      |
| `server.auth.mode`                                       | Set authentication mode. Either `server`, `client` or `sso`.                                                        | `client`                    |
| `server.auth.sso.enabled`                                | Enable SSO configuration for the server auth mode                                                                   | `false`                     |
| `server.auth.sso.issuer`                                 | Root URL for the OIDC identity provider                                                                             | `""`                        |
| `server.auth.sso.clientId.name`                          | Name of the secret containing the OIDC client ID                                                                    | `""`                        |
| `server.auth.sso.clientId.key`                           | Key in the secret to obtain the OIDC client ID                                                                      | `""`                        |
| `server.auth.sso.clientSecret.name`                      | Name of the secret containing the OIDC client secret                                                                | `""`                        |
| `server.auth.sso.clientSecret.key`                       | Key in the secret to obtain the OIDC client secret                                                                  | `""`                        |
| `server.auth.sso.redirectUrl`                            | The OIDC redirect URL. Should be in the form <argo-root-url>/oauth2/callback.                                       | `""`                        |
| `server.auth.sso.rbac.enabled`                           | Create RBAC resources for SSO                                                                                       | `true`                      |
| `server.auth.sso.rbac.secretWhitelist`                   | Restricts the secrets that the server can read                                                                      | `[]`                        |
| `server.auth.sso.scopes`                                 | Scopes requested from the SSO ID provider                                                                           | `[]`                        |
| `server.clusterWorkflowTemplates.enabled`                | Create ClusterRole and CRB for the controoler to access ClusterWorkflowTemplates                                    | `true`                      |
| `server.clusterWorkflowTemplates.enableEditing`          | Give the server permissions to edit ClusterWorkflowTemplates                                                        | `true`                      |
| `server.pdb.enabled`                                     | Create Pod Disruption Budget for the server component                                                               | `false`                     |
| `server.pdb.minAvailable`                                | Sets the min number of pods availables for the Pod Disruption Budget                                                | `1`                         |
| `server.pdb.maxUnavailable`                              | Sets the max number of pods unavailable for the Pod Disruption Budget                                               | `1`                         |
| `server.secure`                                          | Run Argo server in secure mode                                                                                      | `false`                     |
| `server.baseHref`                                        | Base href of the Argo Workflows deployment                                                                          | `/`                         |
| `server.containerPorts.web`                              | argo Server container port                                                                                          | `2746`                      |
| `server.serviceAccount.create`                           | Specifies whether a ServiceAccount should be created                                                                | `true`                      |
| `server.serviceAccount.name`                             | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`                        |
| `server.serviceAccount.automountServiceAccountToken`     | Automount service account token for the server service account                                                      | `true`                      |
| `server.serviceAccount.annotations`                      | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                          | `{}`                        |
| `server.command`                                         | Override default container command (useful when using custom images)                                                | `[]`                        |
| `server.args`                                            | Override default container args (useful when using custom images)                                                   | `[]`                        |
| `server.hostAliases`                                     | server pods host aliases                                                                                            | `[]`                        |
| `server.podLabels`                                       | Extra labels for server pods                                                                                        | `{}`                        |
| `server.podAnnotations`                                  | Annotations for server pods                                                                                         | `{}`                        |
| `server.podAffinityPreset`                               | Pod affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                          | `""`                        |
| `server.podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                     | `soft`                      |
| `server.nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `server.affinity` is set. Allowed values: `soft` or `hard`                    | `""`                        |
| `server.nodeAffinityPreset.key`                          | Node label key to match. Ignored if `server.affinity` is set                                                        | `""`                        |
| `server.nodeAffinityPreset.values`                       | Node label values to match. Ignored if `server.affinity` is set                                                     | `[]`                        |
| `server.affinity`                                        | Affinity for server pods assignment                                                                                 | `{}`                        |
| `server.nodeSelector`                                    | Node labels for server pods assignment                                                                              | `{}`                        |
| `server.tolerations`                                     | Tolerations for server pods assignment                                                                              | `[]`                        |
| `server.updateStrategy.type`                             | server statefulset strategy type                                                                                    | `RollingUpdate`             |
| `server.topologySpreadConstraints`                       | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in             | `[]`                        |
| `server.schedulerName`                                   | Alternate scheduler for the server deployment                                                                       | `""`                        |
| `server.priorityClassName`                               | server pods' priorityClassName                                                                                      | `""`                        |
| `server.lifecycleHooks`                                  | for the server container(s) to automate configuration before or after startup                                       | `{}`                        |
| `server.extraEnvVars`                                    | Array with extra environment variables to add to server nodes                                                       | `[]`                        |
| `server.extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for server nodes                                               | `""`                        |
| `server.extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for server nodes                                                  | `""`                        |
| `server.extraVolumes`                                    | Optionally specify extra list of additional volumes for the server pod(s)                                           | `[]`                        |
| `server.extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the server container(s)                                | `[]`                        |
| `server.sidecars`                                        | Add additional sidecar containers to the server pod(s)                                                              | `[]`                        |
| `server.initContainers`                                  | Add additional init containers to the server pod(s)                                                                 | `[]`                        |
| `server.service.type`                                    | server service type                                                                                                 | `ClusterIP`                 |
| `server.service.ports.http`                              | server service HTTP port                                                                                            | `80`                        |
| `server.service.nodePorts.http`                          | Node port for HTTP                                                                                                  | `""`                        |
| `server.service.clusterIP`                               | server service Cluster IP                                                                                           | `""`                        |
| `server.service.loadBalancerIP`                          | server service Load Balancer IP                                                                                     | `""`                        |
| `server.service.loadBalancerSourceRanges`                | server service Load Balancer sources                                                                                | `[]`                        |
| `server.service.externalTrafficPolicy`                   | server service external traffic policy                                                                              | `Cluster`                   |
| `server.service.annotations`                             | Additional custom annotations for server service                                                                    | `{}`                        |
| `server.service.extraPorts`                              | Extra port to expose on the server service                                                                          | `[]`                        |


### Argo Workflows Controller configuration parameters

| Name                                                         | Description                                                                                                                   | Value                              |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `controller.image.registry`                                  | controller image registry                                                                                                     | `docker.io`                        |
| `controller.image.repository`                                | controller image repository                                                                                                   | `bitnami/argo-workflow-controller` |
| `controller.image.tag`                                       | controller image tag (immutable tags are recommended)                                                                         | `3.3.9-scratch-r1`                 |
| `controller.image.digest`                                    | controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                    | `""`                               |
| `controller.image.pullPolicy`                                | controller image pull policy                                                                                                  | `IfNotPresent`                     |
| `controller.image.pullSecrets`                               | controller image pull secrets                                                                                                 | `[]`                               |
| `controller.replicaCount`                                    | Number of controller replicas to deploy                                                                                       | `1`                                |
| `controller.livenessProbe.enabled`                           | Enable livenessProbe on controller nodes                                                                                      | `true`                             |
| `controller.livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                       | `90`                               |
| `controller.livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                              | `60`                               |
| `controller.livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                             | `30`                               |
| `controller.livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                           | `3`                                |
| `controller.livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                           | `1`                                |
| `controller.readinessProbe.enabled`                          | Enable readinessProbe on controller nodes                                                                                     | `true`                             |
| `controller.readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                      | `30`                               |
| `controller.readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                             | `60`                               |
| `controller.readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                            | `30`                               |
| `controller.readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                          | `3`                                |
| `controller.readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                          | `1`                                |
| `controller.startupProbe.enabled`                            | Enable startupProbe                                                                                                           | `false`                            |
| `controller.startupProbe.path`                               | Path to check for startupProbe                                                                                                | `/`                                |
| `controller.startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                        | `300`                              |
| `controller.startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                               | `10`                               |
| `controller.startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                              | `5`                                |
| `controller.startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                            | `6`                                |
| `controller.startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                            | `1`                                |
| `controller.customLivenessProbe`                             | Controller custom livenessProbe that overrides the default one                                                                | `{}`                               |
| `controller.customReadinessProbe`                            | Controller custom readinessProbe that overrides the default one                                                               | `{}`                               |
| `controller.customStartupProbe`                              | Controller custom startupProbe that overrides the default one                                                                 | `{}`                               |
| `controller.resources.limits`                                | The resources limits for the controller containers                                                                            | `{}`                               |
| `controller.resources.requests`                              | The requested resources for the controller containers                                                                         | `{}`                               |
| `controller.podSecurityContext.enabled`                      | Enabled controller pods' Security Context                                                                                     | `true`                             |
| `controller.podSecurityContext.fsGroup`                      | Set controller pod's Security Context fsGroup                                                                                 | `1001`                             |
| `controller.containerSecurityContext.enabled`                | Enabled controller containers' Security Context                                                                               | `true`                             |
| `controller.containerSecurityContext.runAsUser`              | Set controller containers' Security Context runAsUser                                                                         | `1001`                             |
| `controller.containerSecurityContext.runAsNonRoot`           | Set controller containers' Security Context runAsNonRoot                                                                      | `true`                             |
| `controller.containerSecurityContext.readOnlyRootFilesystem` | Set read only root file system pod's Security Conte                                                                           | `true`                             |
| `controller.containerPorts.metrics`                          | Port to expose controller metrics                                                                                             | `9090`                             |
| `controller.containerPorts.telemetry`                        | Port to expose controller telemetry                                                                                           | `8081`                             |
| `controller.rbac.create`                                     | Create RBAC resources for the Argo workflows controller                                                                       | `true`                             |
| `controller.existingConfigMap`                               |                                                                                                                               | `""`                               |
| `controller.extraArgs`                                       | Extra arguments for the controller command line                                                                               | `""`                               |
| `controller.config`                                          | Controller configmap configuration content                                                                                    | `{}`                               |
| `controller.instanceID.enabled`                              | Enable submission filtering based on instanceID attribute. Requires to set instanceID.useReleaseName or instanceID.explicitID | `false`                            |
| `controller.instanceID.useReleaseName`                       | Use the release name to filter submissions                                                                                    | `false`                            |
| `controller.instanceID.explicitID`                           | Filter submissions based on an explicit instance ID                                                                           | `""`                               |
| `controller.clusterWorkflowTemplates.enabled`                | Whether to create a ClusterRole and Cluster Role Binding to access ClusterWokflowTemplates resources                          | `true`                             |
| `controller.metrics.enabled`                                 | Enable controller metrics exporter                                                                                            | `false`                            |
| `controller.metrics.path`                                    | Path to expose controller metrics                                                                                             | `/metrics`                         |
| `controller.metrics.serviceMonitor.enabled`                  | Enable prometheus service monitor configuration                                                                               | `false`                            |
| `controller.telemetry.enabled`                               | Enable telemetry for the controller                                                                                           | `false`                            |
| `controller.telemetry.path`                                  | Path to expose telemetry information                                                                                          | `/telemetry`                       |
| `controller.workflowWorkers`                                 | Number of workflow workers to deploy                                                                                          | `32`                               |
| `controller.workflowNamespaces`                              | Namespaces allowed to run workflows                                                                                           | `["default"]`                      |
| `controller.workflowDefaults`                                | Default Workflow Values                                                                                                       | `{}`                               |
| `controller.logging.level`                                   | Level for the controller logging                                                                                              | `info`                             |
| `controller.logging.globalLevel`                             | Global logging level for the controller                                                                                       | `0`                                |
| `controller.pdb.enabled`                                     | Create Pod Disruption Budget for the controller component                                                                     | `false`                            |
| `controller.pdb.minAvailable`                                | Sets the min number of pods availables for the Pod Disruption Budget                                                          | `1`                                |
| `controller.pdb.maxUnavailable`                              | Sets the max number of pods unavailable for the Pod Disruption Budget                                                         | `1`                                |
| `controller.serviceAccount.create`                           | Specifies whether a ServiceAccount should be created                                                                          | `true`                             |
| `controller.serviceAccount.name`                             | Name of the service account to use. If not set and create is true, a name is generated using the fullname template.           | `""`                               |
| `controller.serviceAccount.automountServiceAccountToken`     | Automount service account token for the server service account                                                                | `true`                             |
| `controller.serviceAccount.annotations`                      | Annotations for service account. Evaluated as a template. Only used if `create` is `true`.                                    | `{}`                               |
| `controller.command`                                         | Override default container command (useful when using custom images)                                                          | `[]`                               |
| `controller.args`                                            | Override default container args (useful when using custom images)                                                             | `[]`                               |
| `controller.hostAliases`                                     | controller pods host aliases                                                                                                  | `[]`                               |
| `controller.podLabels`                                       | Extra labels for controller pods                                                                                              | `{}`                               |
| `controller.podAnnotations`                                  | Annotations for controller pods                                                                                               | `{}`                               |
| `controller.podAffinityPreset`                               | Pod affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`                                | `""`                               |
| `controller.podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`                           | `soft`                             |
| `controller.nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`                          | `""`                               |
| `controller.nodeAffinityPreset.key`                          | Node label key to match. Ignored if `controller.affinity` is set                                                              | `""`                               |
| `controller.nodeAffinityPreset.values`                       | Node label values to match. Ignored if `controller.affinity` is set                                                           | `[]`                               |
| `controller.affinity`                                        | Affinity for controller pods assignment                                                                                       | `{}`                               |
| `controller.nodeSelector`                                    | Node labels for controller pods assignment                                                                                    | `{}`                               |
| `controller.tolerations`                                     | Tolerations for controller pods assignment                                                                                    | `[]`                               |
| `controller.updateStrategy.type`                             | controller statefulset strategy type                                                                                          | `RollingUpdate`                    |
| `controller.topologySpreadConstraints`                       | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in                       | `[]`                               |
| `controller.schedulerName`                                   | Alternate scheduler for the server controller                                                                                 | `""`                               |
| `controller.priorityClassName`                               | controller pods' priorityClassName                                                                                            | `""`                               |
| `controller.lifecycleHooks`                                  | for the controller container(s) to automate configuration before or after startup                                             | `{}`                               |
| `controller.extraEnvVars`                                    | Array with extra environment variables to add to controller nodes                                                             | `[]`                               |
| `controller.extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for controller nodes                                                     | `""`                               |
| `controller.extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for controller nodes                                                        | `""`                               |
| `controller.extraVolumes`                                    | Optionally specify extra list of additional volumes for the controller pod(s)                                                 | `[]`                               |
| `controller.extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the controller container(s)                                      | `[]`                               |
| `controller.sidecars`                                        | Add additional sidecar containers to the controller pod(s)                                                                    | `[]`                               |
| `controller.initContainers`                                  | Add additional init containers to the controller pod(s)                                                                       | `[]`                               |
| `controller.service.type`                                    | controller service type                                                                                                       | `ClusterIP`                        |
| `controller.service.ports.metrics`                           | Metrics port for the controller                                                                                               | `8080`                             |
| `controller.service.ports.telemetry`                         | Telemetry port for the controller                                                                                             | `8081`                             |
| `controller.service.nodePorts.metrics`                       | Node port for HTTP                                                                                                            | `""`                               |
| `controller.service.nodePorts.telemetry`                     | Node port for HTTPS                                                                                                           | `""`                               |
| `controller.service.clusterIP`                               | controller service Cluster IP                                                                                                 | `""`                               |
| `controller.service.loadBalancerIP`                          | controller service Load Balancer IP                                                                                           | `""`                               |
| `controller.service.loadBalancerSourceRanges`                | controller service Load Balancer sources                                                                                      | `[]`                               |
| `controller.service.externalTrafficPolicy`                   | controller service external traffic policy                                                                                    | `Cluster`                          |
| `controller.service.annotations`                             | Additional custom annotations for controller service                                                                          | `{}`                               |
| `controller.service.extraPorts`                              | Extra port to expose on the controller service                                                                                | `[]`                               |


### Executor configuration section

| Name                                                       | Description                                                                                              | Value                        |
| ---------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `executor.image.registry`                                  | executor image registry                                                                                  | `docker.io`                  |
| `executor.image.repository`                                | executor image repository                                                                                | `bitnami/argo-workflow-exec` |
| `executor.image.tag`                                       | executor image tag (immutable tags are recommended)                                                      | `3.3.9-debian-11-r5`         |
| `executor.image.digest`                                    | executor image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                         |
| `executor.image.pullPolicy`                                | executor image pull policy                                                                               | `Always`                     |
| `executor.image.pullSecrets`                               | executor image pull secrets                                                                              | `[]`                         |
| `executor.resources.limits`                                | The resources limits for the init container                                                              | `{}`                         |
| `executor.resources.requests`                              | The requested resources for the init container                                                           | `{}`                         |
| `executor.extraEnvVars`                                    | Array with extra environment variables to add to server nodes                                            | `[]`                         |
| `executor.containerSecurityContext.enabled`                | Enabled executor pods' Security Context                                                                  | `true`                       |
| `executor.containerSecurityContext.fsGroup`                | Set executor pod's Security Context fsGroup                                                              | `1001`                       |
| `executor.containerSecurityContext.readOnlyRootFilesystem` | Set read only root file system pod's Security Context                                                    | `true`                       |


### Traffic Exposure Parameters

| Name                       | Description                                                                                                                      | Value                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress record generation for server                                                                                      | `false`                  |
| `ingress.pathType`         | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`       | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`         | Default host for the ingress record                                                                                              | `server.local`           |
| `ingress.path`             | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`              | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`       | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`       | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`       | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`         | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`          | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`       | Additional rules to be covered with this ingress record                                                                          | `[]`                     |


### Workflows configuration

| Name                                                    | Description                                                                                | Value   |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ------- |
| `workflows.serviceAccount.create`                       | Whether to create a service account to run workflows                                       | `false` |
| `workflows.serviceAccount.name`                         | Service account name to run workflows                                                      | `""`    |
| `workflows.serviceAccount.automountServiceAccountToken` | Automount service account token for the workflows service account                          | `true`  |
| `workflows.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if `create` is `true`. | `{}`    |
| `workflows.rbac.create`                                 | Whether to create RBAC resource to run workflows                                           | `true`  |


### PostgreSQL subchart

| Name                                  | Description                                                            | Value               |
| ------------------------------------- | ---------------------------------------------------------------------- | ------------------- |
| `postgresql.enabled`                  | Enable PostgreSQL subchart and controller persistence using PostgreSQL | `true`              |
| `postgresql.service.ports.postgresql` | PostgreSQL port                                                        | `5432`              |
| `postgresql.auth.username`            | PostgreSQL username                                                    | `postgres`          |
| `postgresql.auth.database`            | PortgreSQL database name                                               | `bn_argo_workflows` |
| `postgresql.auth.password`            | PortgreSQL database password                                           | `""`                |


### MySQL subchart

| Name                        | Description                                                  | Value               |
| --------------------------- | ------------------------------------------------------------ | ------------------- |
| `mysql.enabled`             | Enable MySQL subchart and controller persistence using MySQL | `false`             |
| `mysql.service.ports.mysql` | MySQL port                                                   | `3306`              |
| `mysql.auth.username`       | MySQL username                                               | `mysql`             |
| `mysql.auth.database`       | MySQL database name                                          | `bn_argo_workflows` |
| `mysql.auth.password`       | MySQL database password                                      | `""`                |


### External Database configuration

| Name                              | Description                                                                 | Value               |
| --------------------------------- | --------------------------------------------------------------------------- | ------------------- |
| `externalDatabase.enabled`        | Enable using externaldatabase and the controller to use persistence with it | `false`             |
| `externalDatabase.host`           | External Database server host                                               | `localhost`         |
| `externalDatabase.port`           | External Database server port                                               | `3306`              |
| `externalDatabase.username`       | External Database username                                                  | `bn_wordpress`      |
| `externalDatabase.password`       | External Database user password                                             | `""`                |
| `externalDatabase.database`       | External Database database name                                             | `bitnami_wordpress` |
| `externalDatabase.existingSecret` | The name of an existing secret with database credentials                    | `""`                |
| `externalDatabase.type`           | Either postgresql or mysql                                                  | `""`                |


See https://github.com/bitnami-labs/readme-generator-for-helm to create the table

The above parameters map to the env variables defined in [bitnami/argo-workflow-cli](https://github.com/bitnami/containers/tree/main/bitnami/argo-workflow-cli). For more information please refer to the [bitnami/argo-workflow-cli](https://github.com/bitnami/containers/tree/main/bitnami/argo-workflow-cli) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set argo-workflowsUsername=admin \
  --set argo-workflowsPassword=password \
  --set mysql.auth.rootPassword=secretpassword \
    bitnami/argo-workflows
```

The above command sets the Argo Workflows administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MySQL `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/argo-workflows
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Database support

You may want to have Argo Workflows controller connected to a database to store controller evidences. To achieve this, the chart can be deployed with the PostgreSQL or MySQL dependency (see next section to configure an external database instead of using the dependency). In order to configure the database, just change `postgresql.enabled=true` (default configuration) or `mysql.enabled=true`. The database will be configured automatically. Here is an example:

```console
postgresql.enabled=true
```

If your installaion does not require to to store controller evidences, you can disable the controller persistence by setting `postgresql.enabled=false`, `mysql.enabled=false` and ` externalDatabase.enabled=false`.

#### External database

You may want to have Argo Workflows controller connected to an external database to store controller evidences. To achieve this, the chart allows you to specify credentials for an external database (using either postgresql or mysql) with the [`controller.persistence.postgresql.enabled` or `controller.persistence.mysql.enabled` parameter](#parameters). You should also set `persistence.enabled` to `true`. Here is an example:

```console
externalDatabase.enabled=true
externalDatabase.type=postgresql
externalDatabase.host=<database_host>
externalDatabase.port=5432
externalDatabase.user=<database_user>
externalDatabase.password=<database_password>
externalDatabase.database=bitnami_wordpress
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/infrastructure/argo-workflows//configuration/configure-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/infrastructure/argo-workflows/administration/enable-tls-ingress/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
argo-workflows:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as argo-workflows (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/infrastructure/argo-workflows/configuration/configure-sidecar-init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

Refer to the [chart documentation for more information about how to upgrade from previous releases](https://docs.bitnami.com/kubernetes/infrastructure/argo-workflows/administration/upgrade/).

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
