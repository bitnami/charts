<!--- app-name: Pinniped -->

# Bitnami package for Pinniped

Pinniped is an identity service provider for Kubernetes. It supplies a consistent and unified login experience across all your clusters. Pinniped is securely integrated with enterprise IDP protocols.

[Overview of Pinniped](https://pinniped.dev/)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/pinniped
```

Looking to use Pinniped in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Pinniped](https://pinniped.dev/) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/pinniped
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys pinniped on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

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

If additional containers are needed in the same pod as pinniped (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
    containerPort: 1234
```

If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter (where available), as shown in the example below:

```yaml
service:
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

> NOTE: This Helm chart already includes sidecar containers for the Prometheus exporters (where applicable). These can be activated by adding the `--enable-metrics=true` parameter at deployment time. The `sidecars` parameter should therefore only be used for any extra sidecar containers.

If additional init containers are needed in the same pod, they can be defined using the `initContainers` parameter. Here is an example:

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

Learn more about [sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/) and [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami pinniped](https://github.com/bitnami/containers/tree/main/bitnami/pinniped) image stores the pinniped data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                | Description                                                                                              | Value                      |
| ------------------- | -------------------------------------------------------------------------------------------------------- | -------------------------- |
| `kubeVersion`       | Override Kubernetes version                                                                              | `""`                       |
| `nameOverride`      | String to partially override common.names.name                                                           | `""`                       |
| `fullnameOverride`  | String to fully override common.names.fullname                                                           | `""`                       |
| `namespaceOverride` | String to fully override common.names.namespace                                                          | `""`                       |
| `commonLabels`      | Labels to add to all deployed objects                                                                    | `{}`                       |
| `commonAnnotations` | Annotations to add to all deployed objects                                                               | `{}`                       |
| `clusterDomain`     | Kubernetes cluster domain name                                                                           | `cluster.local`            |
| `extraDeploy`       | Array of extra objects to deploy with the release                                                        | `[]`                       |
| `image.registry`    | Pinniped image registry                                                                                  | `REGISTRY_NAME`            |
| `image.repository`  | Pinniped image repository                                                                                | `REPOSITORY_NAME/pinniped` |
| `image.digest`      | Pinniped image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                       |
| `image.pullPolicy`  | Pinniped image pull policy                                                                               | `IfNotPresent`             |
| `image.pullSecrets` | Pinniped image pull secrets                                                                              | `[]`                       |

### Concierge Parameters

| Name                                                          | Description                                                                                                                                                                                                                           | Value            |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `concierge.enabled`                                           | Deploy Concierge                                                                                                                                                                                                                      | `true`           |
| `concierge.replicaCount`                                      | Number of Concierge replicas to deploy                                                                                                                                                                                                | `1`              |
| `concierge.containerPorts.api`                                | Concierge API container port                                                                                                                                                                                                          | `10250`          |
| `concierge.containerPorts.proxy`                              | Concierge Proxy container port                                                                                                                                                                                                        | `8444`           |
| `concierge.configurationPorts.aggregatedAPIServerPort`        | Concierge API configuration port                                                                                                                                                                                                      | `10250`          |
| `concierge.configurationPorts.impersonationProxyServerPort`   | Concierge Proxy configuration port                                                                                                                                                                                                    | `8444`           |
| `concierge.hostNetwork`                                       | Concierge API and Proxy container hostNetwork                                                                                                                                                                                         | `false`          |
| `concierge.dnsPolicy`                                         | Concierge API and Proxy container dnsPolicy                                                                                                                                                                                           | `""`             |
| `concierge.configuration`                                     | Concierge pinniped.yaml configuration file                                                                                                                                                                                            | `""`             |
| `concierge.credentialIssuerConfig`                            | Configuration for the credential issuer                                                                                                                                                                                               | `""`             |
| `concierge.livenessProbe.enabled`                             | Enable livenessProbe on Concierge containers                                                                                                                                                                                          | `true`           |
| `concierge.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                               | `10`             |
| `concierge.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                      | `10`             |
| `concierge.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                     | `1`              |
| `concierge.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                   | `3`              |
| `concierge.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                   | `1`              |
| `concierge.readinessProbe.enabled`                            | Enable readinessProbe on Concierge containers                                                                                                                                                                                         | `true`           |
| `concierge.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                              | `10`             |
| `concierge.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                     | `10`             |
| `concierge.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                    | `1`              |
| `concierge.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                  | `3`              |
| `concierge.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                  | `1`              |
| `concierge.startupProbe.enabled`                              | Enable startupProbe on Concierge containers                                                                                                                                                                                           | `false`          |
| `concierge.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                | `10`             |
| `concierge.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                       | `10`             |
| `concierge.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                      | `1`              |
| `concierge.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                    | `3`              |
| `concierge.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                    | `1`              |
| `concierge.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                   | `{}`             |
| `concierge.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                  | `{}`             |
| `concierge.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                    | `{}`             |
| `concierge.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if concierge.resources is set (concierge.resources is recommended for production). | `nano`           |
| `concierge.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                     | `{}`             |
| `concierge.podSecurityContext.enabled`                        | Enabled Concierge pods' Security Context                                                                                                                                                                                              | `true`           |
| `concierge.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                    | `Always`         |
| `concierge.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                        | `[]`             |
| `concierge.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                           | `[]`             |
| `concierge.podSecurityContext.fsGroup`                        | Set Concierge pod's Security Context fsGroup                                                                                                                                                                                          | `1001`           |
| `concierge.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                  | `true`           |
| `concierge.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                      | `nil`            |
| `concierge.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                            | `1001`           |
| `concierge.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                           | `1001`           |
| `concierge.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                         | `true`           |
| `concierge.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                           | `false`          |
| `concierge.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                               | `true`           |
| `concierge.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                             | `false`          |
| `concierge.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                    | `["ALL"]`        |
| `concierge.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                      | `RuntimeDefault` |
| `concierge.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for Concierge                                                                                                                                                        | `""`             |
| `concierge.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                  | `[]`             |
| `concierge.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                     | `[]`             |
| `concierge.deployAPIService`                                  | Deploy the APIService objects                                                                                                                                                                                                         | `true`           |
| `concierge.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                    | `true`           |
| `concierge.hostAliases`                                       | Concierge pods host aliases                                                                                                                                                                                                           | `[]`             |
| `concierge.podLabels`                                         | Extra labels for Concierge pods                                                                                                                                                                                                       | `{}`             |
| `concierge.podAnnotations`                                    | Annotations for Concierge pods                                                                                                                                                                                                        | `{}`             |
| `concierge.podAffinityPreset`                                 | Pod affinity preset. Ignored if `concierge.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                         | `""`             |
| `concierge.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `concierge.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `soft`           |
| `concierge.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `concierge.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                   | `""`             |
| `concierge.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `concierge.affinity` is set                                                                                                                                                                       | `""`             |
| `concierge.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `concierge.affinity` is set                                                                                                                                                                    | `[]`             |
| `concierge.affinity`                                          | Affinity for Concierge pods assignment                                                                                                                                                                                                | `{}`             |
| `concierge.nodeSelector`                                      | Node labels for Concierge pods assignment                                                                                                                                                                                             | `{}`             |
| `concierge.tolerations`                                       | Tolerations for Concierge pods assignment                                                                                                                                                                                             | `[]`             |
| `concierge.updateStrategy.type`                               | Concierge statefulset strategy type                                                                                                                                                                                                   | `RollingUpdate`  |
| `concierge.priorityClassName`                                 | Concierge pods' priorityClassName                                                                                                                                                                                                     | `""`             |
| `concierge.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                              | `{}`             |
| `concierge.schedulerName`                                     | Name of the k8s scheduler (other than default) for Concierge pods                                                                                                                                                                     | `""`             |
| `concierge.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                                     | `""`             |
| `concierge.lifecycleHooks`                                    | for the Concierge container(s) to automate configuration before or after startup                                                                                                                                                      | `{}`             |
| `concierge.extraEnvVars`                                      | Array with extra environment variables to add to Concierge nodes                                                                                                                                                                      | `[]`             |
| `concierge.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Concierge nodes                                                                                                                                                              | `""`             |
| `concierge.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Concierge nodes                                                                                                                                                                 | `""`             |
| `concierge.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Concierge pod(s)                                                                                                                                                          | `[]`             |
| `concierge.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Concierge container(s)                                                                                                                                               | `[]`             |
| `concierge.sidecars`                                          | Add additional sidecar containers to the Concierge pod(s)                                                                                                                                                                             | `[]`             |
| `concierge.initContainers`                                    | Add additional init containers to the Concierge pod(s)                                                                                                                                                                                | `[]`             |
| `concierge.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                       | `true`           |
| `concierge.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                        | `""`             |
| `concierge.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `concierge.pdb.minAvailable` and `concierge.pdb.maxUnavailable` are empty.                                                                    | `""`             |

### Concierge RBAC settings

| Name                                                                         | Description                                                                   | Value   |
| ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------- |
| `concierge.rbac.create`                                                      | Create Concierge RBAC objects                                                 | `true`  |
| `concierge.serviceAccount.concierge.name`                                    | Name of an existing Service Account for the Concierge Deployment              | `""`    |
| `concierge.serviceAccount.concierge.create`                                  | Create a Service Account for the Concierge Deployment                         | `true`  |
| `concierge.serviceAccount.concierge.automountServiceAccountToken`            | Auto mount token for the Concierge Deployment Service Account                 | `false` |
| `concierge.serviceAccount.concierge.annotations`                             | Annotations for the Concierge Service Account                                 | `{}`    |
| `concierge.serviceAccount.impersonationProxy.name`                           | Name of an existing Service Account for the Concierge Impersonator            | `""`    |
| `concierge.serviceAccount.impersonationProxy.create`                         | Create a Service Account for the Concierge Impersonator                       | `true`  |
| `concierge.serviceAccount.impersonationProxy.automountServiceAccountToken`   | Auto mount token for the Concierge Impersonator Service Account               | `false` |
| `concierge.serviceAccount.impersonationProxy.annotations`                    | Annotations for the Concierge Service Account                                 | `{}`    |
| `concierge.serviceAccount.kubeCertAgentService.name`                         | Name of an existing Service Account for the Concierge kube-cert-agent-service | `""`    |
| `concierge.serviceAccount.kubeCertAgentService.create`                       | Create a Service Account for the Concierge kube-cert-agent-service            | `true`  |
| `concierge.serviceAccount.kubeCertAgentService.automountServiceAccountToken` | Auto mount token for the Concierge kube-cert-agent-service Service Account    | `false` |
| `concierge.serviceAccount.kubeCertAgentService.annotations`                  | Annotations for the Concierge Service Account                                 | `{}`    |

### Concierge Traffic Exposure Parameters

| Name                                              | Description                                                                                        | Value       |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------- | ----------- |
| `concierge.service.type`                          | Concierge service type                                                                             | `ClusterIP` |
| `concierge.service.ports.https`                   | Concierge service HTTPS port                                                                       | `443`       |
| `concierge.service.nodePorts.https`               | Node port for HTTPS                                                                                | `""`        |
| `concierge.service.clusterIP`                     | Concierge service Cluster IP                                                                       | `""`        |
| `concierge.service.labels`                        | Add labels to the service                                                                          | `{}`        |
| `concierge.service.loadBalancerIP`                | Concierge service Load Balancer IP                                                                 | `""`        |
| `concierge.service.loadBalancerSourceRanges`      | Concierge service Load Balancer sources                                                            | `[]`        |
| `concierge.service.externalTrafficPolicy`         | Concierge service external traffic policy                                                          | `Cluster`   |
| `concierge.service.annotations`                   | Additional custom annotations for Concierge service                                                | `{}`        |
| `concierge.service.extraPorts`                    | Extra ports to expose in Concierge service (normally used with the `sidecars` value)               | `[]`        |
| `concierge.service.sessionAffinity`               | Control where client requests go, to the same pod or round-robin                                   | `None`      |
| `concierge.service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                        | `{}`        |
| `concierge.networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                | `true`      |
| `concierge.networkPolicy.kubeAPIServerPorts`      | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security) | `[]`        |
| `concierge.networkPolicy.allowExternal`           | Don't require server label for connections                                                         | `true`      |
| `concierge.networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                    | `true`      |
| `concierge.networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `concierge.networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                       | `[]`        |
| `concierge.networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                             | `{}`        |
| `concierge.networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                         | `{}`        |

### Supervisor Parameters

| Name                                                           | Description                                                                                                                                                                                                                             | Value            |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `supervisor.enabled`                                           | Deploy Supervisor                                                                                                                                                                                                                       | `true`           |
| `supervisor.replicaCount`                                      | Number of Supervisor replicas to deploy                                                                                                                                                                                                 | `1`              |
| `supervisor.containerPorts.api`                                | Supervisor API container port                                                                                                                                                                                                           | `10250`          |
| `supervisor.containerPorts.https`                              | Supervisor HTTPS container port                                                                                                                                                                                                         | `8443`           |
| `supervisor.deployAPIService`                                  | Deploy the APIService objects                                                                                                                                                                                                           | `true`           |
| `supervisor.configuration`                                     | Supervisor pinniped.yaml configuration file                                                                                                                                                                                             | `""`             |
| `supervisor.livenessProbe.enabled`                             | Enable livenessProbe on Supervisor containers                                                                                                                                                                                           | `true`           |
| `supervisor.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                 | `10`             |
| `supervisor.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                        | `10`             |
| `supervisor.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                       | `1`              |
| `supervisor.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                     | `3`              |
| `supervisor.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                     | `1`              |
| `supervisor.readinessProbe.enabled`                            | Enable readinessProbe on Supervisor containers                                                                                                                                                                                          | `true`           |
| `supervisor.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                | `10`             |
| `supervisor.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                       | `10`             |
| `supervisor.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                      | `1`              |
| `supervisor.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                    | `3`              |
| `supervisor.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                    | `1`              |
| `supervisor.startupProbe.enabled`                              | Enable startupProbe on Supervisor containers                                                                                                                                                                                            | `false`          |
| `supervisor.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                  | `10`             |
| `supervisor.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                         | `10`             |
| `supervisor.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                        | `1`              |
| `supervisor.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                      | `3`              |
| `supervisor.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                      | `1`              |
| `supervisor.customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                                                     | `{}`             |
| `supervisor.customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                                                    | `{}`             |
| `supervisor.customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                                      | `{}`             |
| `supervisor.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if supervisor.resources is set (supervisor.resources is recommended for production). | `nano`           |
| `supervisor.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`             |
| `supervisor.podSecurityContext.enabled`                        | Enabled Supervisor pods' Security Context                                                                                                                                                                                               | `true`           |
| `supervisor.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                      | `Always`         |
| `supervisor.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                          | `[]`             |
| `supervisor.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                             | `[]`             |
| `supervisor.podSecurityContext.fsGroup`                        | Set Supervisor pod's Security Context fsGroup                                                                                                                                                                                           | `1001`           |
| `supervisor.containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                                                                                                                                    | `true`           |
| `supervisor.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                        | `nil`            |
| `supervisor.containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                                              | `1001`           |
| `supervisor.containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                                             | `1001`           |
| `supervisor.containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                                                                                                                           | `true`           |
| `supervisor.containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                                                                                                                             | `false`          |
| `supervisor.containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                                                                                                                                 | `true`           |
| `supervisor.containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                                                                                                                               | `false`          |
| `supervisor.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                      | `["ALL"]`        |
| `supervisor.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                        | `RuntimeDefault` |
| `supervisor.existingConfigmap`                                 | The name of an existing ConfigMap with your custom configuration for Supervisor                                                                                                                                                         | `""`             |
| `supervisor.command`                                           | Override default container command (useful when using custom images)                                                                                                                                                                    | `[]`             |
| `supervisor.args`                                              | Override default container args (useful when using custom images)                                                                                                                                                                       | `[]`             |
| `supervisor.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                      | `true`           |
| `supervisor.hostAliases`                                       | Supervisor pods host aliases                                                                                                                                                                                                            | `[]`             |
| `supervisor.podLabels`                                         | Extra labels for Supervisor pods                                                                                                                                                                                                        | `{}`             |
| `supervisor.podAnnotations`                                    | Annotations for Supervisor pods                                                                                                                                                                                                         | `{}`             |
| `supervisor.podAffinityPreset`                                 | Pod affinity preset. Ignored if `supervisor.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                          | `""`             |
| `supervisor.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `supervisor.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `soft`           |
| `supervisor.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `supervisor.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `""`             |
| `supervisor.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `supervisor.affinity` is set                                                                                                                                                                        | `""`             |
| `supervisor.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `supervisor.affinity` is set                                                                                                                                                                     | `[]`             |
| `supervisor.affinity`                                          | Affinity for Supervisor pods assignment                                                                                                                                                                                                 | `{}`             |
| `supervisor.nodeSelector`                                      | Node labels for Supervisor pods assignment                                                                                                                                                                                              | `{}`             |
| `supervisor.tolerations`                                       | Tolerations for Supervisor pods assignment                                                                                                                                                                                              | `[]`             |
| `supervisor.updateStrategy.type`                               | Supervisor statefulset strategy type                                                                                                                                                                                                    | `RollingUpdate`  |
| `supervisor.priorityClassName`                                 | Supervisor pods' priorityClassName                                                                                                                                                                                                      | `""`             |
| `supervisor.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                                                | `{}`             |
| `supervisor.schedulerName`                                     | Name of the k8s scheduler (other than default) for Supervisor pods                                                                                                                                                                      | `""`             |
| `supervisor.terminationGracePeriodSeconds`                     | Seconds Redmine pod needs to terminate gracefully                                                                                                                                                                                       | `""`             |
| `supervisor.lifecycleHooks`                                    | for the Supervisor container(s) to automate configuration before or after startup                                                                                                                                                       | `{}`             |
| `supervisor.extraEnvVars`                                      | Array with extra environment variables to add to Supervisor nodes                                                                                                                                                                       | `[]`             |
| `supervisor.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for Supervisor nodes                                                                                                                                                               | `""`             |
| `supervisor.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for Supervisor nodes                                                                                                                                                                  | `""`             |
| `supervisor.extraVolumes`                                      | Optionally specify extra list of additional volumes for the Supervisor pod(s)                                                                                                                                                           | `[]`             |
| `supervisor.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the Supervisor container(s)                                                                                                                                                | `[]`             |
| `supervisor.sidecars`                                          | Add additional sidecar containers to the Supervisor pod(s)                                                                                                                                                                              | `[]`             |
| `supervisor.initContainers`                                    | Add additional init containers to the Supervisor pod(s)                                                                                                                                                                                 | `[]`             |
| `supervisor.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                         | `true`           |
| `supervisor.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                          | `""`             |
| `supervisor.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `supervisor.pdb.minAvailable` and `supervisor.pdb.maxUnavailable` are empty.                                                                    | `""`             |

### Supervisor RBAC settings

| Name                                                     | Description                                                       | Value   |
| -------------------------------------------------------- | ----------------------------------------------------------------- | ------- |
| `supervisor.rbac.create`                                 | Create Supervisor RBAC objects                                    | `true`  |
| `supervisor.serviceAccount.name`                         | Name of an existing Service Account for the Supervisor Deployment | `""`    |
| `supervisor.serviceAccount.create`                       | Create a Service Account for the Supervisor Deployment            | `true`  |
| `supervisor.serviceAccount.automountServiceAccountToken` | Auto mount token for the Supervisor Deployment Service Account    | `false` |
| `supervisor.serviceAccount.annotations`                  | Annotations for the Supervisor Service Account                    | `{}`    |

### Supervisor Traffic Exposure Parameters

| Name                                                 | Description                                                                                                                      | Value                       |
| ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `supervisor.service.api.type`                        | Supervisor API service type                                                                                                      | `ClusterIP`                 |
| `supervisor.service.api.ports.https`                 | Supervisor API service HTTPS port                                                                                                | `443`                       |
| `supervisor.service.api.ports.aggregatedAPIServer`   | Supervisor aggregated API server port                                                                                            | `10250`                     |
| `supervisor.service.api.nodePorts.https`             | Node port for HTTPS                                                                                                              | `""`                        |
| `supervisor.service.api.clusterIP`                   | Supervisor service Cluster IP                                                                                                    | `""`                        |
| `supervisor.service.api.labels`                      | Add labels to the service                                                                                                        | `{}`                        |
| `supervisor.service.api.loadBalancerIP`              | Supervisor service Load Balancer IP                                                                                              | `""`                        |
| `supervisor.service.api.loadBalancerSourceRanges`    | Supervisor service Load Balancer sources                                                                                         | `[]`                        |
| `supervisor.service.api.externalTrafficPolicy`       | Supervisor service external traffic policy                                                                                       | `Cluster`                   |
| `supervisor.service.api.annotations`                 | Additional custom annotations for Supervisor service                                                                             | `{}`                        |
| `supervisor.service.api.extraPorts`                  | Extra ports to expose in Supervisor service (normally used with the `sidecars` value)                                            | `[]`                        |
| `supervisor.service.api.sessionAffinity`             | Control where client requests go, to the same pod or round-robin                                                                 | `None`                      |
| `supervisor.service.api.sessionAffinityConfig`       | Additional settings for the sessionAffinity                                                                                      | `{}`                        |
| `supervisor.service.public.type`                     | Supervisor user-facing service type                                                                                              | `LoadBalancer`              |
| `supervisor.service.public.ports.https`              | Supervisor user-facing service HTTPS port                                                                                        | `443`                       |
| `supervisor.service.public.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                        |
| `supervisor.service.public.clusterIP`                | Supervisor service Cluster IP                                                                                                    | `""`                        |
| `supervisor.service.public.labels`                   | Add labels to the service                                                                                                        | `{}`                        |
| `supervisor.service.public.loadBalancerIP`           | Supervisor service Load Balancer IP                                                                                              | `""`                        |
| `supervisor.service.public.loadBalancerSourceRanges` | Supervisor service Load Balancer sources                                                                                         | `[]`                        |
| `supervisor.service.public.externalTrafficPolicy`    | Supervisor service external traffic policy                                                                                       | `Cluster`                   |
| `supervisor.service.public.annotations`              | Additional custom annotations for Supervisor service                                                                             | `{}`                        |
| `supervisor.service.public.extraPorts`               | Extra ports to expose in Supervisor service (normally used with the `sidecars` value)                                            | `[]`                        |
| `supervisor.service.public.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                      |
| `supervisor.service.public.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                        |
| `supervisor.networkPolicy.enabled`                   | Specifies whether a NetworkPolicy should be created                                                                              | `true`                      |
| `supervisor.networkPolicy.kubeAPIServerPorts`        | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                               | `[]`                        |
| `supervisor.networkPolicy.allowExternal`             | Don't require server label for connections                                                                                       | `true`                      |
| `supervisor.networkPolicy.allowExternalEgress`       | Allow the pod to access any range of port and all destinations.                                                                  | `true`                      |
| `supervisor.networkPolicy.extraIngress`              | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                        |
| `supervisor.networkPolicy.extraEgress`               | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                        |
| `supervisor.networkPolicy.ingressNSMatchLabels`      | Labels to match to allow traffic from other namespaces                                                                           | `{}`                        |
| `supervisor.networkPolicy.ingressNSPodMatchLabels`   | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                        |
| `supervisor.ingress.enabled`                         | Enable ingress record generation for Pinniped Supervisor                                                                         | `false`                     |
| `supervisor.ingress.pathType`                        | Ingress path type                                                                                                                | `ImplementationSpecific`    |
| `supervisor.ingress.apiVersion`                      | Force Ingress API version (automatically detected if not set)                                                                    | `""`                        |
| `supervisor.ingress.ingressClassName`                | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                        |
| `supervisor.ingress.hostname`                        | Default host for the ingress record                                                                                              | `pinniped-supervisor.local` |
| `supervisor.ingress.path`                            | Default path for the ingress record                                                                                              | `/`                         |
| `supervisor.ingress.annotations`                     | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                        |
| `supervisor.ingress.tls`                             | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                     |
| `supervisor.ingress.selfSigned`                      | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                     |
| `supervisor.ingress.extraHosts`                      | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                        |
| `supervisor.ingress.extraPaths`                      | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                        |
| `supervisor.ingress.extraTls`                        | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                        |
| `supervisor.ingress.secrets`                         | Custom TLS certificates as secrets                                                                                               | `[]`                        |
| `supervisor.ingress.extraRules`                      | Additional rules to be covered with this ingress record                                                                          | `[]`                        |

See <https://github.com/bitnami/readme-generator-for-helm> to create the table

The above parameters map to the env variables defined in [bitnami/pinniped](https://github.com/bitnami/containers/tree/main/bitnami/pinniped). For more information please refer to the [bitnami/pinniped](https://github.com/bitnami/containers/tree/main/bitnami/pinniped) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set supervisor.enabled=false \
    oci://REGISTRY_NAME/REPOSITORY_NAME/pinniped
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The above command sets disables the supervisor compoment deployment.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/pinniped
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/pinniped/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 2.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 1.0.0

This version brings a breaking change into the configuration, eliminating abused reuse of Pinniped service parameters.
The `supervisor.service` object is now separated into `supervisor.service.api` which configures the service used by Pinniped internally, and `supervisor.service.public` which configures the service the users interact with.
In case configuration was specified in the `supervisor.service` object, now it needs to be redistributed into the two new objects. Keep in mind that the API service default service type was also changed to `ClusterIP` to reflect more on how the API service is used by default. Also the formerly `supervisor.service.ports.aggregatedAPIService` parameter is now only available under the API service configuration, because it is not a relevant parameter for the user-facing service.

### To 0.4.0

This version updates Pinniped to its newest version, 0.20.x. For more information, please refer to [the release notes](https://github.com/vmware-tanzu/pinniped/releases/tag/v0.20.0).

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