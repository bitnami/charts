<!--- app-name: ASP.NET Core -->

# Bitnami package for ASP.NET Core

ASP.NET Core is an open-source framework for web application development created by Microsoft. It runs on both the full .NET Framework, on Windows, and the cross-platform .NET Core.

[Overview of ASP.NET Core](https://github.com/dotnet/aspnetcore)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/aspnet-core
```

Looking to use ASP.NET Core in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps an [ASP.NET Core](https://github.com/bitnami/containers/tree/main/bitnami/aspnet-core) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/aspnet-core
```

These commands deploy a ASP.NET Core application on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Deploying your custom ASP.NET Core application

The ASP.NET Core chart allows you to deploy a custom application using one of the following methods:

- Using a Docker image containing your ASP.NET Core application ready to be executed.
- Cloning your ASP.NET Core application code from a GIT repository.
- Mounting your ASP.NET Core application from an existing PVC

#### Using a Docker image containing your ASP.NET Core application ready to be executed

You can build your own Docker image containing your ASP.NET Core application ready to be executed. To do so, overwrite the default image setting the `image.*` parameters, and set your custom command and arguments setting the `command` and `args` parameters:

```console
appFromExternalRepo.enabled=false
image.registry=docker.io
image.repository=your-image
image.tag=your-tag
command=[command]
args=[arguments]
```

#### Cloning your ASP.NET Core application code from a GIT repository

This is done using two different init containers:

- `clone-repository`: uses the [Bitnami GIT Image](https://github.com/bitnami/containers/tree/main/bitnami/git) to download the repository.
- `dotnet-publish`: uses the [Bitnami .Net SDK Image](https://github.com/bitnami/containers/tree/main/bitnami/dotnet-sdk) to build/publish the ASP.NET Core application.

To use this feature, set the `appFromExternalRepo.enabled` to `true` and set the repository and branch to use setting the `appFromExternalRepo.clone.repository` and `appFromExternalRepo.clone.revision` parameters. Then, specify the sub folder under the Git repository containing the ASP.NET Core app setting the `appFromExternalRepo.publish.subFolder` parameter. Finally, provide the start command to use setting the `appFromExternalRepo.startCommand`.

> Note: you can append any custom flag for the "dotnet publish" command setting the `appFromExternalRepo.publish.extraFlags` parameter.

For example, you can deploy a sample [OCMinimal](https://learn.microsoft.com/en-us/aspnet/core/performance/caching/output) using the parameters below:

```console
appFromExternalRepo.enabled=true
appFromExternalRepo.clone.repository=https://github.com/dotnet/AspNetCore.Docs.git
appFromExternalRepo.clone.revision=main
appFromExternalRepo.publish.aspnetcore/performance/caching/output/samples/7.x/
appFromExternalRepo.startCommand[0]=dotnet
appFromExternalRepo.startCommand[1]=OCMinimal.dll
```

#### Mounting your ASP.NET Core application from an existing PVC

If you previously created a PVC with your application code ready to be executed, you can mount it in the ASP.NET Core container setting the `appFromExistingPVC.enabled` parameter to `true`. Then, specify the name of your existing PVC setting the `appFromExistingPVC.existingClaim` parameter.

For example, if you created a PVC named `my-custom-apsnet-core-app` containing your application, use the parameters below:

```console
appFromExistingPVC.enabled=true
appFromExistingPVC.existingClaim=my-custom-apsnet-core-app
```

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
kong:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the ASP.NET Core app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter. The following example would create a ConfigMap including some app's configuration, and it will mount it in the ASP.NET Core app's container:

```yaml
extraDeploy: |-
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: aspnet-core-configuration
      labels: {{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" $ ) | nindent 6 }}
      {{- if .Values.commonAnnotations }}
      annotations: {{- include "common.tplvalues.render" ( dict "value" .Values.commonAnnotations "context" $ ) | nindent 6 }}
      {{- end }}
    data:
      appsettings.json: |-
        {
          "AllowedHosts": "*"
        }
extraVolumeMounts:
  - name: configuration
    mountPath: /app/config/
    readOnly: true
extraVolumes:
  - name: configuration
    configMap:
      name: aspnet-core-configuration
```

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this ASP.NET Core installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                | Description                                       | Value           |
| ------------------- | ------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                       | `""`            |
| `nameOverride`      | String to partially override aspnet-core.fullname | `""`            |
| `fullnameOverride`  | String to fully override aspnet-core.fullname     | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace   | `""`            |
| `commonLabels`      | Labels to add to all deployed objects             | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects        | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                    | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release | `[]`            |

### ASP.NET Core parameters

| Name                 | Description                                                                                                  | Value                         |
| -------------------- | ------------------------------------------------------------------------------------------------------------ | ----------------------------- |
| `image.registry`     | ASP.NET Core image registry                                                                                  | `REGISTRY_NAME`               |
| `image.repository`   | ASP.NET Core image repository                                                                                | `REPOSITORY_NAME/aspnet-core` |
| `image.digest`       | ASP.NET Core image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                          |
| `image.pullPolicy`   | ASP.NET Core image pull policy                                                                               | `IfNotPresent`                |
| `image.pullSecrets`  | ASP.NET Core image pull secrets                                                                              | `[]`                          |
| `image.debug`        | Enable image debug mode                                                                                      | `false`                       |
| `command`            | Override default container command (useful when using custom images)                                         | `[]`                          |
| `args`               | Override default container args (useful when using custom images)                                            | `[]`                          |
| `bindURLs`           | URLs to bind                                                                                                 | `http://+:8080`               |
| `extraEnvVars`       | Extra environment variables to be set on ASP.NET Core container                                              | `[]`                          |
| `extraEnvVarsCM`     | ConfigMap with extra environment variables                                                                   | `""`                          |
| `extraEnvVarsSecret` | Secret with extra environment variables                                                                      | `""`                          |

### ASP.NET Core deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                  |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `replicaCount`                                      | Number of ASP.NET Core replicas to deploy                                                                                                                                                                         | `1`                    |
| `schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                    | `""`                   |
| `priorityClassName`                                 | ASP.NET Core pod priority class name                                                                                                                                                                              | `""`                   |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                   |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `false`                |
| `hostAliases`                                       | ASP.NET Core pod host aliases                                                                                                                                                                                     | `[]`                   |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for ASP.NET Core pods                                                                                                                                         | `[]`                   |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for ASP.NET Core container(s)                                                                                                                            | `[]`                   |
| `sidecars`                                          | Add additional sidecar containers to the ASP.NET Core pods                                                                                                                                                        | `[]`                   |
| `initContainers`                                    | Add additional init containers to the ASP.NET Core pods                                                                                                                                                           | `[]`                   |
| `lifecycleHooks`                                    | Add lifecycle hooks to the ASP.NET Core deployment                                                                                                                                                                | `{}`                   |
| `podAnnotations`                                    | Annotations for ASP.NET Core pods                                                                                                                                                                                 | `{}`                   |
| `podLabels`                                         | Extra labels for ASP.NET Core pods                                                                                                                                                                                | `{}`                   |
| `updateStrategy.type`                               | Deployment strategy type                                                                                                                                                                                          | `RollingUpdate`        |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                   |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                 |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                   |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`                   |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`                   |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                   |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                   |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                   |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`                |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                   |
| `containerPorts.http`                               | Port to expose at ASP.NET Core container level                                                                                                                                                                    | `8080`                 |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for WordPress container(s)                                                                                                                                      | `[]`                   |
| `podSecurityContext.enabled`                        | Enabled ASP.NET Core pods' Security Context                                                                                                                                                                       | `true`                 |
| `podSecurityContext.sysctls`                        | Set namespaced sysctls for the ASP.NET Core pods                                                                                                                                                                  | `[]`                   |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`               |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                   |
| `podSecurityContext.fsGroup`                        | Set Security Context fsGroup                                                                                                                                                                                      | `0`                    |
| `containerSecurityContext.enabled`                  | Enable Container Security Context                                                                                                                                                                                 | `true`                 |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                   |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                                                                                                        | `1001`                 |
| `containerSecurityContext.runAsGroup`               | Set containers' Security Context runAsGroup                                                                                                                                                                       | `1001`                 |
| `containerSecurityContext.runAsNonRoot`             | Set containers' Security Context runAsNonRoot                                                                                                                                                                     | `true`                 |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set containers' Security Context readOnlyRootFilesystem                                                                                                                                                           | `true`                 |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's privilege escalation                                                                                                                                                                              | `false`                |
| `containerSecurityContext.capabilities.add`         | Set container's Security Context allowed kernel capabilities                                                                                                                                                      | `["NET_BIND_SERVICE"]` |
| `containerSecurityContext.capabilities.drop`        | Set container's Security Context dropped kernel capabilities                                                                                                                                                      | `["ALL"]`              |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`       |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                 |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `10`                   |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `20`                   |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `1`                    |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`                    |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                    |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                 |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `10`                   |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `20`                   |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `1`                    |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`                    |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                    |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `10`                   |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `20`                   |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `1`                    |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`                    |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                    |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`                   |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`                   |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`                   |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `false`                |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `1`                    |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                                                                                                    | `""`                   |
| `autoscaling.enabled`                               | Enable autoscaling for ASP.NET Core                                                                                                                                                                               | `false`                |
| `autoscaling.minReplicas`                           | Minimum number of ASP.NET Core replicas                                                                                                                                                                           | `1`                    |
| `autoscaling.maxReplicas`                           | Maximum number of ASP.NET Core replicas                                                                                                                                                                           | `11`                   |
| `autoscaling.targetCPU`                             | Target CPU utilization percentage                                                                                                                                                                                 | `""`                   |
| `autoscaling.targetMemory`                          | Target Memory utilization percentage                                                                                                                                                                              | `""`                   |

### Custom ASP.NET Core application parameters

| Name                                            | Description                                                                                              | Value                                                |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `appFromExternalRepo.enabled`                   | Enable to download/build ASP.NET Core app from external git repository                                   | `true`                                               |
| `appFromExternalRepo.clone.image.registry`      | Git image registry                                                                                       | `REGISTRY_NAME`                                      |
| `appFromExternalRepo.clone.image.repository`    | Git image repository                                                                                     | `REPOSITORY_NAME/git`                                |
| `appFromExternalRepo.clone.image.digest`        | Git image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag      | `""`                                                 |
| `appFromExternalRepo.clone.image.pullPolicy`    | Git image pull policy                                                                                    | `IfNotPresent`                                       |
| `appFromExternalRepo.clone.image.pullSecrets`   | Git image pull secrets                                                                                   | `[]`                                                 |
| `appFromExternalRepo.clone.repository`          | Git repository to clone                                                                                  | `https://github.com/dotnet/AspNetCore.Docs.git`      |
| `appFromExternalRepo.clone.revision`            | Git revision to checkout                                                                                 | `main`                                               |
| `appFromExternalRepo.clone.depth`               | Depth of the repo to checkout (full clone if empty)                                                      | `1`                                                  |
| `appFromExternalRepo.clone.extraVolumeMounts`   | Add extra volume mounts for the GIT container                                                            | `[]`                                                 |
| `appFromExternalRepo.publish.image.registry`    | .NET SDK image registry                                                                                  | `REGISTRY_NAME`                                      |
| `appFromExternalRepo.publish.image.repository`  | .NET SDK image repository                                                                                | `REPOSITORY_NAME/dotnet-sdk`                         |
| `appFromExternalRepo.publish.image.digest`      | .NET SDK image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                                                 |
| `appFromExternalRepo.publish.image.pullPolicy`  | .NET SDK image pull policy                                                                               | `IfNotPresent`                                       |
| `appFromExternalRepo.publish.image.pullSecrets` | .NET SDK image pull secrets                                                                              | `[]`                                                 |
| `appFromExternalRepo.publish.subFolder`         | Sub folder under the Git repository containing the ASP.NET Core app                                      | `aspnetcore/performance/caching/output/samples/8.x/` |
| `appFromExternalRepo.publish.extraFlags`        | Extra flags to be appended to "dotnet publish" command                                                   | `[]`                                                 |
| `appFromExternalRepo.startCommand`              | Command used to start ASP.NET Core app                                                                   | `["dotnet","OCMinimal.dll"]`                         |
| `appFromExistingPVC.enabled`                    | Enable mounting your ASP.NET Core app from an existing PVC                                               | `false`                                              |
| `appFromExistingPVC.existingClaim`              | A existing Persistent Volume Claim containing your ASP.NET Core app                                      | `""`                                                 |

### Traffic Exposure Parameters

| Name                                    | Description                                                                                                                      | Value                    |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                          | ASP.NET Core service type                                                                                                        | `ClusterIP`              |
| `service.ports.http`                    | ASP.NET Core service HTTP port                                                                                                   | `80`                     |
| `service.nodePorts.http`                | Node ports to expose                                                                                                             | `""`                     |
| `service.clusterIP`                     | ASP.NET Core service Cluster IP                                                                                                  | `""`                     |
| `service.extraPorts`                    | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.loadBalancerIP`                | ASP.NET Core service Load Balancer IP                                                                                            | `""`                     |
| `service.loadBalancerSourceRanges`      | ASP.NET Core service Load Balancer sources                                                                                       | `[]`                     |
| `service.externalTrafficPolicy`         | ASP.NET Core service external traffic policy                                                                                     | `Cluster`                |
| `service.annotations`                   | Additional custom annotations for ASP.NET Core service                                                                           | `{}`                     |
| `service.sessionAffinity`               | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`         | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `ingress.enabled`                       | Enable ingress record generation for ASP.NET Core                                                                                | `false`                  |
| `ingress.pathType`                      | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                    | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                      | Default host for the ingress resource, a host pointing to this will be created                                                   | `aspnet-core.local`      |
| `ingress.path`                          | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                   | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                           | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.extraPaths`                    | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.selfSigned`                    | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.ingressClassName`              | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraHosts`                    | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraTls`                      | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                       | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`                    | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `healthIngress.enabled`                 | Enable healthIngress record generation for ASP.NET Core                                                                          | `false`                  |
| `healthIngress.pathType`                | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `healthIngress.path`                    | Default path for the ingress record                                                                                              | `/`                      |
| `healthIngress.hostname`                | When the health ingress is enabled, a host pointing to this will be created                                                      | `aspnet-core.local`      |
| `healthIngress.annotations`             | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `healthIngress.tls`                     | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `healthIngress.ingressClassName`        | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `healthIngress.extraHosts`              | n array with additional hostname(s) to be covered with the ingress record                                                        | `[]`                     |
| `healthIngress.extraTls`                | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `healthIngress.secrets`                 | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `healthIngress.extraRules`              | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `networkPolicy.enabled`                 | Specifies whether a NetworkPolicy should be created                                                                              | `true`                   |
| `networkPolicy.allowExternal`           | Don't require server label for connections                                                                                       | `true`                   |
| `networkPolicy.allowExternalEgress`     | Allow the pod to access any range of port and all destinations.                                                                  | `true`                   |
| `networkPolicy.extraIngress`            | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.extraEgress`             | Add extra ingress rules to the NetworkPolicy                                                                                     | `[]`                     |
| `networkPolicy.ingressNSMatchLabels`    | Labels to match to allow traffic from other namespaces                                                                           | `{}`                     |
| `networkPolicy.ingressNSPodMatchLabels` | Pod labels to match to allow traffic from other namespaces                                                                       | `{}`                     |

### RBAC parameters

| Name                                          | Description                                          | Value   |
| --------------------------------------------- | ---------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created | `true`  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.               | `""`    |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount | `{}`    |
| `serviceAccount.extraLabels`                  | Additional labels for the ServiceAccount             | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Automount service account token                      | `false` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release --set replicaCount=2 oci://REGISTRY_NAME/REPOSITORY_NAME/aspnet-core
```

The above command install ASP.NET Core chart with 2 replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/aspnet-core
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/aspnet-core/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 6.0.0

This major bump changes the following security defaults:

- `runAsUser` is changed from `0` to `1001`
- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.
- The `networkPolicy` section has been normalized amongst all Bitnami charts. It is added and enabled by default in all charts. This can be disabled by setting `networkPolicy.enabled=false`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 3.0.0

The ASP.NET Core application version has been updated to the major version `6`. The init container of the chart have also been adapted to use the `6.x` files.

### To 2.0.0

Some of the chart values were changed to adapt to the latest Bitnami standards. More specifically:

- `strategy` was changed to `updateStrategy`
- `containerPort` was changed to `containerPorts.http`
- `service.port` was changed to `service.ports.http`

No issues should be expected when upgrading.

### To 1.0.0

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