<!--- app-name: Parse Server -->

# Bitnami package for Parse Server

Parse is a platform that enables users to add a scalable and powerful backend to launch a full-featured app for iOS, Android, JavaScript, Windows, Unity, and more.

[Overview of Parse Server](http://parseplatform.org/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/parse
```

Looking to use Parse Server in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

This chart bootstraps a [Parse](https://github.com/bitnami/containers/tree/main/bitnami/parse) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/parse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys Parse on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Deploy your Cloud functions with Parse Cloud Code

The [Bitnami Parse](https://github.com/bitnami/containers/tree/main/bitnami/parse) image allows you to deploy your Cloud functions with Parse Cloud Code (a feature which allows running a piece of code in your Parse Server instead of the user's mobile devices). In order to add your custom scripts, they must be located inside the chart folder `files/cloud` so they can be consumed as a ConfigMap.

Alternatively, you can specify custom scripts using the `cloudCodeScripts` parameter as dict.

In addition to these options, you can also set an external ConfigMap with all the Cloud Code scripts. This is done by setting the `existingCloudCodeScriptsCM` parameter. Note that this will override the two previous options.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` (available in the `server` and `dashboard` sections) property.

```yaml
extraEnvVars:
  - name: PARSE_SERVER_ALLOW_CLIENT_CLASS_CREATION
    value: true
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such as KongPlugins, KongConsumers, amongst others. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example would activate a plugin at deployment time.

```yaml
## Extra objects to deploy (value evaluated as a template)
##
extraDeploy: |-
  - apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: {{ include "common.names.fullname" . }}-privileged
      namespace: {{ .Release.Namespace }}
      labels: {{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" $ ) | nindent 6 }}
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
      - kind: ServiceAccount
        name: default
        namespace: {{ .Release.Namespace }}
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` paremeter(s). Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Parse](https://github.com/bitnami/containers/tree/main/bitnami/parse) image stores the Parse data and configurations at the `/bitnami/parse` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common Parameters

| Name                     | Description                                                                                  | Value          |
| ------------------------ | -------------------------------------------------------------------------------------------- | -------------- |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`           |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`           |
| `namespaceOverride`      | String to fully override common.names.namespace                                              | `""`           |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilites if not set)                          | `""`           |
| `commonLabels`           | Add labels to all the deployed resources                                                     | `{}`           |
| `commonAnnotations`      | Add annotations to all the deployed resources                                                | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                         | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                            | `["infinity"]` |

### Parse server parameters

| Name                                                       | Description                                                                                                                                                                                                                     | Value                   |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `server.image.registry`                                    | Parse image registry                                                                                                                                                                                                            | `REGISTRY_NAME`         |
| `server.image.repository`                                  | Parse image repository                                                                                                                                                                                                          | `REPOSITORY_NAME/parse` |
| `server.image.digest`                                      | Parse image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                           | `""`                    |
| `server.image.pullPolicy`                                  | Image pull policy                                                                                                                                                                                                               | `IfNotPresent`          |
| `server.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                | `[]`                    |
| `server.image.debug`                                       | Enable image debug mode                                                                                                                                                                                                         | `false`                 |
| `server.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                              | `false`                 |
| `server.hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                                     | `[]`                    |
| `server.podLabels`                                         | Extra labels for Parse pods                                                                                                                                                                                                     | `{}`                    |
| `server.podAnnotations`                                    | Annotations for Parse pods                                                                                                                                                                                                      | `{}`                    |
| `server.forceOverwriteConfFile`                            | Overwrite config.json configuration file on each run (set to false if mounting a custom configuration file)                                                                                                                     | `true`                  |
| `server.podSecurityContext.enabled`                        | Enabled Parse Dashboard pods' Security Context                                                                                                                                                                                  | `true`                  |
| `server.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                              | `Always`                |
| `server.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                  | `[]`                    |
| `server.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                     | `[]`                    |
| `server.podSecurityContext.fsGroup`                        | Set Parse Dashboard pod's Security Context fsGroup                                                                                                                                                                              | `1001`                  |
| `server.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                            | `true`                  |
| `server.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                | `{}`                    |
| `server.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                      | `1001`                  |
| `server.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                     | `1001`                  |
| `server.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                   | `true`                  |
| `server.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                     | `false`                 |
| `server.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                         | `true`                  |
| `server.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                       | `false`                 |
| `server.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                              | `["ALL"]`               |
| `server.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                | `RuntimeDefault`        |
| `server.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                            | `[]`                    |
| `server.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                               | `[]`                    |
| `server.containerPorts.http`                               | Parse server port                                                                                                                                                                                                               | `1337`                  |
| `server.mountPath`                                         | Parse server API mount path                                                                                                                                                                                                     | `/parse`                |
| `server.appId`                                             | Parse server App ID                                                                                                                                                                                                             | `myappID`               |
| `server.masterKey`                                         | Parse server Master Key                                                                                                                                                                                                         | `""`                    |
| `server.masterKeyIps`                                      | Parse server Master setting an allowed IP address                                                                                                                                                                               | `0.0.0.0/0`             |
| `server.extraEnvVars`                                      | An array to add extra env vars                                                                                                                                                                                                  | `[]`                    |
| `server.extraEnvVarsCM`                                    | Name of a ConfigMap containing extra environment variables                                                                                                                                                                      | `""`                    |
| `server.extraEnvVarsSecret`                                | Name of a Secret containing extra environment variables                                                                                                                                                                         | `""`                    |
| `server.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Parse pod(s)                                                                                                                                                        | `[]`                    |
| `server.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Parse container(s)                                                                                                                                             | `[]`                    |
| `server.sidecars`                                          | Add additional sidecar containers to the Parse pod(s)                                                                                                                                                                           | `[]`                    |
| `server.initContainers`                                    | Add additional init containers to the Parse pod(s)                                                                                                                                                                              | `[]`                    |
| `server.enableCloudCode`                                   | Enable Parse Cloud Code                                                                                                                                                                                                         | `false`                 |
| `server.cloudCodeScripts`                                  | Cloud Code scripts                                                                                                                                                                                                              | `{}`                    |
| `server.existingCloudCodeScriptsCM`                        | ConfigMap with Cloud Code scripts (Note: Overrides `cloudCodeScripts`).                                                                                                                                                         | `""`                    |
| `server.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if server.resources is set (server.resources is recommended for production). | `nano`                  |
| `server.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                               | `{}`                    |
| `server.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                            | `true`                  |
| `server.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                         | `120`                   |
| `server.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                | `10`                    |
| `server.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                               | `5`                     |
| `server.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                             | `5`                     |
| `server.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                             | `1`                     |
| `server.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                           | `true`                  |
| `server.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                        | `30`                    |
| `server.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                               | `5`                     |
| `server.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                              | `5`                     |
| `server.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                            | `5`                     |
| `server.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                            | `1`                     |
| `server.startupProbe.enabled`                              | Enable startupProbe on Parse containers                                                                                                                                                                                         | `false`                 |
| `server.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                          | `0`                     |
| `server.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                 | `3`                     |
| `server.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                | `1`                     |
| `server.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                              | `15`                    |
| `server.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                              | `1`                     |
| `server.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                             | `{}`                    |
| `server.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                            | `{}`                    |
| `server.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                              | `{}`                    |
| `server.podAffinityPreset`                                 | Parse server pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                | `""`                    |
| `server.podAntiAffinityPreset`                             | Parse server pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                           | `soft`                  |
| `server.nodeAffinityPreset.type`                           | Parse server node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `""`                    |
| `server.nodeAffinityPreset.key`                            | Parse server node label key to match Ignored if `affinity` is set.                                                                                                                                                              | `""`                    |
| `server.nodeAffinityPreset.values`                         | Parse server node label values to match. Ignored if `affinity` is set.                                                                                                                                                          | `[]`                    |
| `server.affinity`                                          | Parse server affinity for pod assignment                                                                                                                                                                                        | `{}`                    |
| `server.nodeSelector`                                      | Parse server node labels for pod assignment                                                                                                                                                                                     | `{}`                    |
| `server.tolerations`                                       | Parse server tolerations for pod assignment                                                                                                                                                                                     | `[]`                    |
| `server.updateStrategy.type`                               | Parse statefulset strategy type                                                                                                                                                                                                 | `RollingUpdate`         |
| `server.priorityClassName`                                 | Parse pods' priorityClassName                                                                                                                                                                                                   | `""`                    |
| `server.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                        | `[]`                    |
| `server.schedulerName`                                     | Name of the k8s scheduler (other than default) for Parse pods                                                                                                                                                                   | `""`                    |
| `server.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                               | `""`                    |
| `server.lifecycleHooks`                                    | for the Parse container(s) to automate configuration before or after startup                                                                                                                                                    | `{}`                    |
| `server.service.type`                                      | Kubernetes Service type                                                                                                                                                                                                         | `LoadBalancer`          |
| `server.service.ports.http`                                | Service HTTP port (Dashboard)                                                                                                                                                                                                   | `1337`                  |
| `server.service.nodePorts.http`                            | Kubernetes HTTP node port                                                                                                                                                                                                       | `""`                    |
| `server.service.clusterIP`                                 | Service Cluster IP                                                                                                                                                                                                              | `""`                    |
| `server.service.loadBalancerIP`                            | Service Load Balancer IP                                                                                                                                                                                                        | `""`                    |
| `server.service.loadBalancerSourceRanges`                  | Service Load Balancer sources                                                                                                                                                                                                   | `[]`                    |
| `server.service.externalTrafficPolicy`                     | Service external traffic policy                                                                                                                                                                                                 | `Cluster`               |
| `server.service.annotations`                               | Additional custom annotations for Service                                                                                                                                                                                       | `{}`                    |
| `server.service.extraPorts`                                | Extra ports to expose in Service (normally used with the `sidecars` value)                                                                                                                                                      | `[]`                    |
| `server.service.sessionAffinity`                           | Control where client requests go, to the same pod or round-robin                                                                                                                                                                | `None`                  |
| `server.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                     | `{}`                    |
| `server.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                             | `true`                  |
| `server.networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                                      | `true`                  |
| `server.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                 | `true`                  |
| `server.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                    |
| `server.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                    | `[]`                    |
| `server.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                          | `{}`                    |
| `server.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                      | `{}`                    |

### Dashboard Parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value                             |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `dashboard.enabled`                                           | Enable parse dashboard                                                                                                                                                                                                                | `true`                            |
| `dashboard.image.registry`                                    | Dashboard image registry                                                                                                                                                                                                              | `REGISTRY_NAME`                   |
| `dashboard.image.repository`                                  | Dashboard image repository                                                                                                                                                                                                            | `REPOSITORY_NAME/parse-dashboard` |
| `dashboard.image.digest`                                      | Dashboard image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                             | `""`                              |
| `dashboard.image.pullPolicy`                                  | image pull policy                                                                                                                                                                                                                     | `IfNotPresent`                    |
| `dashboard.image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                                                      | `[]`                              |
| `dashboard.image.debug`                                       | Enable Parse Dashboard image debug mode                                                                                                                                                                                               | `false`                           |
| `dashboard.replicaCount`                                      | Number of Parse Dashboard replicas to deploy                                                                                                                                                                                          | `1`                               |
| `dashboard.containerPorts.http`                               | Parse Dashboard HTTP container port                                                                                                                                                                                                   | `4040`                            |
| `dashboard.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `false`                           |
| `dashboard.hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                                           | `[]`                              |
| `dashboard.podSecurityContext.enabled`                        | Enabled Parse Dashboard pods' Security Context                                                                                                                                                                                        | `true`                            |
| `dashboard.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`                          |
| `dashboard.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`                              |
| `dashboard.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`                              |
| `dashboard.podSecurityContext.fsGroup`                        | Set Parse Dashboard pod's Security Context fsGroup                                                                                                                                                                                    | `1001`                            |
| `dashboard.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`                            |
| `dashboard.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `{}`                              |
| `dashboard.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `1001`                            |
| `dashboard.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `1001`                            |
| `dashboard.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `true`                            |
| `dashboard.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`                           |
| `dashboard.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`                            |
| `dashboard.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`                           |
| `dashboard.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`                         |
| `dashboard.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault`                  |
| `dashboard.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                  | `[]`                              |
| `dashboard.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                     | `[]`                              |
| `dashboard.username`                                          | Parse Dashboard application username                                                                                                                                                                                                  | `user`                            |
| `dashboard.password`                                          | Parse Dashboard application password                                                                                                                                                                                                  | `""`                              |
| `dashboard.appName`                                           | Parse Dashboard application name                                                                                                                                                                                                      | `MyDashboard`                     |
| `dashboard.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if dashboard.resources is set (dashboard.resources is recommended for production). | `nano`                            |
| `dashboard.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`                              |
| `dashboard.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                  | `true`                            |
| `dashboard.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `240`                             |
| `dashboard.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`                              |
| `dashboard.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `5`                               |
| `dashboard.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `5`                               |
| `dashboard.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`                               |
| `dashboard.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                 | `true`                            |
| `dashboard.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `30`                              |
| `dashboard.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `5`                               |
| `dashboard.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `5`                               |
| `dashboard.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `5`                               |
| `dashboard.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`                               |
| `dashboard.startupProbe.enabled`                              | Enable startupProbe on Parse Dashboard containers                                                                                                                                                                                     | `false`                           |
| `dashboard.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `0`                               |
| `dashboard.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `3`                               |
| `dashboard.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `2`                               |
| `dashboard.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `15`                              |
| `dashboard.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`                               |
| `dashboard.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                   | `{}`                              |
| `dashboard.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                  | `{}`                              |
| `dashboard.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                    | `{}`                              |
| `dashboard.podLabels`                                         | Extra labels for Parse Dashboard pods                                                                                                                                                                                                 | `{}`                              |
| `dashboard.podAnnotations`                                    | Annotations for Parse Dashboard pods                                                                                                                                                                                                  | `{}`                              |
| `dashboard.podAffinityPreset`                                 | Parse dashboard pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`                              |
| `dashboard.podAntiAffinityPreset`                             | Parse dashboard pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                              | `soft`                            |
| `dashboard.nodeAffinityPreset.type`                           | Parse dashboard node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `""`                              |
| `dashboard.nodeAffinityPreset.key`                            | Parse dashboard node label key to match Ignored if `affinity` is set.                                                                                                                                                                 | `""`                              |
| `dashboard.nodeAffinityPreset.values`                         | Parse dashboard node label values to match. Ignored if `affinity` is set.                                                                                                                                                             | `[]`                              |
| `dashboard.affinity`                                          | Parse dashboard affinity for pod assignment                                                                                                                                                                                           | `{}`                              |
| `dashboard.nodeSelector`                                      | Parse dashboard node labels for pod assignment                                                                                                                                                                                        | `{}`                              |
| `dashboard.tolerations`                                       | Parse dashboard tolerations for pod assignment                                                                                                                                                                                        | `[]`                              |
| `dashboard.updateStrategy.type`                               | Parse statefulset strategy type                                                                                                                                                                                                       | `RollingUpdate`                   |
| `dashboard.priorityClassName`                                 | Parse pods' priorityClassName                                                                                                                                                                                                         | `""`                              |
| `dashboard.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                              | `[]`                              |
| `dashboard.schedulerName`                                     | Name of the k8s scheduler (other than default) for Parse pods                                                                                                                                                                         | `""`                              |
| `dashboard.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                                     | `""`                              |
| `dashboard.lifecycleHooks`                                    | for the Parse container(s) to automate configuration before or after startup                                                                                                                                                          | `{}`                              |
| `dashboard.parseServerUrlProtocol`                            | Protocol used by Parse Dashboard to form the URLs to Parse server                                                                                                                                                                     | `http`                            |
| `dashboard.extraEnvVars`                                      | An array to add extra env vars                                                                                                                                                                                                        | `[]`                              |
| `dashboard.extraEnvVarsCM`                                    | Name of a ConfigMap containing extra environment variables                                                                                                                                                                            | `""`                              |
| `dashboard.extraEnvVarsSecret`                                | Name of a Secret containing extra environment variables                                                                                                                                                                               | `""`                              |
| `dashboard.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Parse pod(s)                                                                                                                                                              | `[]`                              |
| `dashboard.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Parse container(s)                                                                                                                                                   | `[]`                              |
| `dashboard.sidecars`                                          | Add additional sidecar containers to the Parse pod(s)                                                                                                                                                                                 | `[]`                              |
| `dashboard.initContainers`                                    | Add additional init containers to the Parse pod(s)                                                                                                                                                                                    | `[]`                              |
| `dashboard.forceOverwriteConfFile`                            | Overwrite config.json configuration file on each run (set to false if mounting a custom configuration file)                                                                                                                           | `true`                            |
| `dashboard.service.type`                                      | Kubernetes Service type                                                                                                                                                                                                               | `LoadBalancer`                    |
| `dashboard.service.ports.http`                                | Service HTTP port (Dashboard)                                                                                                                                                                                                         | `80`                              |
| `dashboard.service.nodePorts.http`                            | Kubernetes HTTP node port                                                                                                                                                                                                             | `""`                              |
| `dashboard.service.clusterIP`                                 | Service Cluster IP                                                                                                                                                                                                                    | `""`                              |
| `dashboard.service.loadBalancerIP`                            | Service Load Balancer IP                                                                                                                                                                                                              | `""`                              |
| `dashboard.service.loadBalancerSourceRanges`                  | Service Load Balancer sources                                                                                                                                                                                                         | `[]`                              |
| `dashboard.service.externalTrafficPolicy`                     | Service external traffic policy                                                                                                                                                                                                       | `Cluster`                         |
| `dashboard.service.annotations`                               | Additional custom annotations for Service                                                                                                                                                                                             | `{}`                              |
| `dashboard.service.extraPorts`                                | Extra ports to expose in Service (normally used with the `sidecars` value)                                                                                                                                                            | `[]`                              |
| `dashboard.service.sessionAffinity`                           | Control where client requests go, to the same pod or round-robin                                                                                                                                                                      | `None`                            |
| `dashboard.service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                                           | `{}`                              |
| `dashboard.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                   | `true`                            |
| `dashboard.networkPolicy.allowExternal`                       | Don't require label for connections                                                                                                                                                                                                   | `true`                            |
| `dashboard.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                       | `true`                            |
| `dashboard.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                              |
| `dashboard.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                          | `[]`                              |
| `dashboard.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                | `{}`                              |
| `dashboard.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                            | `{}`                              |

### Traffic Exposure Parameters

| Name                           | Description                                                                                                                      | Value                    |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`              | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.ingressClassName`     | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.tls`                  | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.selfSigned`           | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.annotations`          | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.dashboard.hostname`   | Default host for the ingress resource                                                                                            | `parse-dashboard.local`  |
| `ingress.dashboard.path`       | The Path to Parse. You may need to set this to '/*' in order to use this with ALB ingress controllers.                           | `/`                      |
| `ingress.dashboard.pathType`   | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.dashboard.extraHosts` | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.dashboard.extraPaths` | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.server.hostname`      | Default host for the ingress resource                                                                                            | `parse-server.local`     |
| `ingress.server.path`          | Default path for the ingress resource*' in order to use this with ALB ingress controllers.                                       | `/`                      |
| `ingress.server.pathType`      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.server.extraHosts`    | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.server.extraPaths`    | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`             | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`              | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`           | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Persistence Parameters

| Name                        | Description                                                        | Value               |
| --------------------------- | ------------------------------------------------------------------ | ------------------- |
| `persistence.enabled`       | Enable Parse persistence using PVC                                 | `true`              |
| `persistence.storageClass`  | PVC Storage Class for Parse volume                                 | `""`                |
| `persistence.accessModes`   | PVC Access Mode for Parse volume                                   | `["ReadWriteOnce"]` |
| `persistence.size`          | PVC Storage Request for Parse volume                               | `8Gi`               |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence                 | `""`                |
| `persistence.selector`      | Selector to match an existing Persistent Volume for Parse data PVC | `{}`                |
| `persistence.dataSource`    | Custom PVC data source                                             | `{}`                |
| `persistence.annotations`   | Persistent Volume Claim annotations                                | `{}`                |

### Volume Permissions parameters

| Name                                          | Description                                                                                                                                                                                                                                           | Value                      |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `volumePermissions.enabled`                   | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                                                             | `false`                    |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                                                                                                                                                      | `REGISTRY_NAME`            |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                                                                                                                                                          | `REPOSITORY_NAME/os-shell` |
| `volumePermissions.image.digest`              | Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                     | `""`                       |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                                                                                                                                                   | `IfNotPresent`             |
| `volumePermissions.image.pullSecrets`         | Init container volume-permissions image pull secrets                                                                                                                                                                                                  | `[]`                       |
| `volumePermissions.resourcesPreset`           | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `none`                     |
| `volumePermissions.resources`                 | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                     | `{}`                       |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                                                                                                                  | `true`                     |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                                                                                                                                                | `""`                       |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template)                                                                                                                                                                                      | `{}`                       |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                                                                                                                                                        | `false`                    |

### MongoDB&reg; Parameters

| Name                               | Description                                                                                                                                                                                                | Value           |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `mongodb.enabled`                  | Enable MongoDB&reg; chart                                                                                                                                                                                  | `true`          |
| `mongodb.auth.enabled`             | Enable MongoDB&reg; password authentication                                                                                                                                                                | `true`          |
| `mongodb.auth.rootPassword`        | MongoDB&reg; admin password                                                                                                                                                                                | `""`            |
| `mongodb.auth.username`            | MongoDB&reg; user                                                                                                                                                                                          | `bn_parse`      |
| `mongodb.auth.password`            | MongoDB&reg; user password                                                                                                                                                                                 | `""`            |
| `mongodb.auth.database`            | MongoDB&reg; database                                                                                                                                                                                      | `bitnami_parse` |
| `mongodb.persistence.enabled`      | Enable MongoDB&reg; persistence using PVC                                                                                                                                                                  | `true`          |
| `mongodb.persistence.storageClass` | PVC Storage Class for MongoDB&reg; volume                                                                                                                                                                  | `""`            |
| `mongodb.persistence.accessMode`   | PVC Access Mode for MongoDB&reg; volume                                                                                                                                                                    | `ReadWriteOnce` |
| `mongodb.persistence.size`         | PVC Storage Request for MongoDB&reg; volume                                                                                                                                                                | `8Gi`           |
| `mongodb.resourcesPreset`          | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `small`         |
| `mongodb.resources`                | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                          | `{}`            |

> **Note**:
>
> For the Parse application function correctly, you should specify the `parseHost` parameter to specify the FQDN (recommended) or the public IP address of the Parse service.
>
> Optionally, you can specify the `loadBalancerIP` parameter to assign a reserved IP address to the Parse service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```console
> $ gcloud compute addresses create parse-public-ip
> ```
>
> The reserved IP address can be associated to the Parse service by specifying it as the value of the `loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set dashboard.username=admin,dashboard.password=password \
    oci://REGISTRY_NAME/REPOSITORY_NAME/parse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets the Parse administrator account username and password to `admin` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/parse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/parse/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 22.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 21.0.0

This major updates the MongoDB&reg; subchart to its newest major, [14.0.0](https://github.com/bitnami/charts/tree/main/bitnami/mongodb#to-1400). No major issues are expected during the upgrade.

### To 19.0.0

This major updates the MongoDB&reg; subchart to its newest major, [13.0.0](https://github.com/bitnami/charts/tree/main/bitnami/mongodb#to-1300). No major issues are expected during the upgrade.

### To 18.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `server.port` is renamed to `server.containerPorts.http`
- `service.port` is renamed to `dashboard.service.ports.http`
- `metrics.containerPort` is renamed to `metrics.containerPorts.metrics`
- `service.nodePort` is renamed to `dashboard.service.nodePorts.http`
- `persistence.accessMode` is renamed to `persistence.accessModes` as list
- `securityContext` is splitted into `podSecurityContext` and `containerSecurityContext` and moved into the different sections (`mongos`, `shardsvr.dataNode`, `shardsvr.arbiter`and `configsvr`):
  - `securityContext.fsGroup` is renamed to `XXX.podSecurityContext.fsGroup`
  - `securityContext.runAsUser` is renamed to `XXX.containerSecurityContext.runAsUser`
  - `securityContext.runAsNonRoot` is renamed to `XXX.containerSecurityContext.runAsNonRoot`

Also MongoDB&reg; subchart container images were updated to 5.0.x and it can affect compatibility with older versions of MongoDB&reg;.

- <https://github.com/bitnami/charts/tree/main/bitnami/mongodb#to-1200>

### To 16.0.0

In this version, the mongodb-exporter bundled as part of the bitnami/mongodb dependency was updated to a new version which, even it is not a major change, can contain breaking changes (from `0.11.X` to `0.30.X`).

Please visit the release notes from the upstream project at <https://github.com/percona/mongodb_exporter/releases>

### To 15.0.0

The [Bitnami Parse](https://github.com/bitnami/containers/tree/main/bitnami/parse) and [Bitnami Parse Dashboard](https://github.com/bitnami/containers/tree/main/bitnami/parse-dashboard) images were refactored and now the source code is published in GitHub in the `rootfs` folder of the container images.

Compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected.

### To 14.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.dashboard.hostname` and `ingress.server.hostname` values. When defining more than one, set the `ingress.dashboard.extraHosts` and `ingress.server.extraHosts` arrays. Apart from this case, no issues are expected to appear when upgrading.

### To 13.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- <https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 12.0.0

MongoDB&reg; subchart container images were updated to 4.4.x and it can affect compatibility with older versions of MongoDB&reg;.

- <https://github.com/bitnami/charts/tree/main/bitnami/mongodb#to-900>

### To 11.0.0

Backwards compatibility is not guaranteed since breaking changes were included in MongoDB&reg; subchart. More information in the link below:

- <https://github.com/bitnami/charts/tree/main/bitnami/mongodb#to-800>

### To 10.0.0

Backwards compatibility is not guaranteed. The following notables changes were included:

- **parse-dashboard** is bumped to the branch 2 (major version)
- Labels are adapted to follow the Helm charts best practices.

### To 5.1.0

Parse & Parse Dashboard containers were moved to a non-root approach. There shouldn't be any issue when upgrading since the corresponding `securityContext` is enabled by default. Both container images and chart can be upgraded by running the command below:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/parse
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

If you use a previous container image (previous to **3.1.2-r14** for Parse or **1.2.0-r69** for Parse Dashboard), disable the `securityContext` by running the command below:

```console
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/parse --set server.securityContext.enabled=false,dashboard.securityContext.enabled=false,server.image.tag=XXX,dashboard.image.tag=YYY
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is parse:

```console
kubectl patch deployment parse-parse-dashboard --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl patch deployment parse-parse-server --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl patch deployment parse-mongodb --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.