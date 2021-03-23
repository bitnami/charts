# ASP.NET Core

[ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core) is an open-source framework created by Microsoft for building cloud-enabled, modern applications.

## TL;DR

```console
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-release bitnami/aspnet-core
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps an [ASP.NET Core](https://github.com/bitnami/bitnami-docker-aspnet-core) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/aspnet-core
```

These commands deploy a ASP.NET Core application on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the ASP.NET Core chart and their default values per section/component:

### Global parameters

| Parameter                               | Description                                                | Default                                                 |
|-----------------------------------------|------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                  | Global Docker image registry                               | `nil`                                                   |
| `global.imagePullSecrets`               | Global Docker registry secret names as an array            | `[]` (does not add image pull secrets to deployed pods) |

### Common parameters

| Parameter                               | Description                                                | Default                                                 |
|-----------------------------------------|------------------------------------------------------------|---------------------------------------------------------|
| `nameOverride`                          | String to partially override aspnet-core.fullname          | `nil`                                                   |
| `fullnameOverride`                      | String to fully override aspnet-core.fullname              | `nil`                                                   |
| `clusterDomain`                         | Default Kubernetes cluster domain                          | `cluster.local`                                         |
| `commonLabels`                          | Labels to add to all deployed objects                      | `{}`                                                    |
| `commonAnnotations`                     | Annotations to add to all deployed objects                 | `{}`                                                    |
| `extraDeploy`                           | Array of extra objects to deploy with the release          | `[]` (evaluated as a template)                          |
| `kubeVersion`                        | Force target Kubernetes version (using Helm capabilities if not set)                                                    | `nil`                          |

### ASP.NET Core parameters

| Parameter                               | Description                                                                              | Default                                                 |
|-----------------------------------------|------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`                        | ASP.NET Core image registry                                                              | `docker.io`                                             |
| `image.repository`                      | ASP.NET Core image name                                                                  | `bitnami/aspnet-core`                                   |
| `image.tag`                             | ASP.NET Core image tag                                                                   | `{TAG_NAME}`                                            |
| `image.pullPolicy`                      | ASP.NET Core image pull policy                                                           | `IfNotPresent`                                          |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                         | `[]` (does not add image pull secrets to deployed pods) |
| `command`                               | Override default container command (useful when using custom images)                     | `nil`                                                   |a
| `args`                                  | Override default container args (useful when using custom images)                        | `nil`                                                   |
| `bindURLs`                              | URLs to bind                                                                             | `http://+:8080`                                         |
| `extraEnvVars`                          | Extra environment variables to be set on ASP.NET Core container                          | `{}`                                                    |
| `extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                     | `nil`                                                   |
| `extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                        | `nil`                                                   |

### ASP.NET Core deployment parameters

| Parameter                             | Description                                                                                | Default                                                 |
|---------------------------------------|--------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `replicaCount`                        | Number of ASP.NET Core replicas to deploy                                                  | `1`                                                     |
| `hostAliases`                    | Add deployment host aliases                                                               | `[]`                                          |
| `strategyType`                        | Deployment Strategy Type                                                                   | `RollingUpdate`                                         |
| `podAffinityPreset`                   | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`        | `""`                                                    |
| `podAntiAffinityPreset`               | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`   | `soft`                                                  |
| `nodeAffinityPreset.type`             | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                    |
| `nodeAffinityPreset.key`              | Node label key to match Ignored if `affinity` is set.                                      | `""`                                                    |
| `affinity`                            | Affinity for pod assignment                                                                | `{}` (evaluated as a template)                          |
| `nodeSelector`                        | Node labels for pod assignment                                                             | `{}` (evaluated as a template)                          |
| `tolerations`                         | Tolerations for pod assignment                                                             | `[]` (evaluated as a template)                          |
| `priorityClassName`                   | Controller priorityClassName                                                               | `nil`                                                   |
| `podSecurityContext`                  | ASP.NET Core pods' Security Context                                                        | Check `values.yaml` file                                |
| `containerSecurityContext`            | ASP.NET Corecontainers' Security Context                                                   | Check `values.yaml` file                                |
| `containerPort`                       | Port to expose at container level                                                          | `8080`                                                  |
| `resources.limits`                    | The resources limits for the ASP.NET Core container                                        | `{}`                                                    |
| `resources.requests`                  | The requested resources for the ASP.NET Core container                                     | `{}`                                                    |
| `podAnnotations`                      | Annotations for ASP.NET Core pods                                                          | `{}`                                                    |
| `lifecycleHooks`                      | LifecycleHooks to set additional configuration at startup.                                 | `{}` (evaluated as a template)                          |
| `livenessProbe`                       | Liveness probe configuration for ASP.NET Core                                              | Check `values.yaml` file                                |
| `readinessProbe`                      | Readiness probe configuration for ASP.NET Core                                             | Check `values.yaml` file                                |
| `customLivenessProbe`                 | Override default liveness probe                                                            | `nil`                                                   |
| `customReadinessProbe`                | Override default readiness probe                                                           | `nil`                                                   |
| `extraVolumeMounts`                   | Optionally specify extra list of additional volumeMounts for ASP.NET Core container(s)     | `[]`                                                    |
| `extraVolumes`                        | Optionally specify extra list of additional volumes for ASP.NET Core statefulset           | `[]`                                                    |
| `initContainers`                      | Add additional init containers to the ASP.NET Core pods                                    | `{}` (evaluated as a template)                          |
| `sidecars`                            | Add additional sidecar containers to the ASP.NET Core pods                                 | `{}` (evaluated as a template)                          |
| `pdb.create`                          | Enable/disable a Pod Disruption Budget creation                                            | `false`                                                 |
| `pdb.minAvailable`                    | Minimum number/percentage of pods that should remain scheduled                             | `1`                                                     |
| `pdb.maxUnavailable`                  | Maximum number/percentage of pods that may be made unavailable                             | `nil`                                                   |
| `autoscaling.enabled`                 | Enable autoscaling for ASP.NET Core                                                        | `false`                                                 |
| `autoscaling.minReplicas`             | Minimum number of ASP.NET Core replicas                                                    | `nil`                                                   |
| `autoscaling.maxReplicas`             | Maximum number of ASP.NET Core replicas                                                    | `nil`                                                   |
| `autoscaling.targetCPU`               | Target CPU utilization percentage                                                          | `nil`                                                   |
| `autoscaling.targetMemory`            | Target Memory utilization percentage                                                       | `nil`                                                   |

### Custom ASP.NET Core application parameters

| Parameter                                         | Description                                                                    | Default                                                            |
|---------------------------------------------------|--------------------------------------------------------------------------------|--------------------------------------------------------------------|
| `appFromExternalRepo.enabled`                     | Enable to download/build ASP.NET Core app from external git repository         | `true`                                                             |
| `appFromExternalRepo.clone.image.registry`        | GIT image registry                                                             | `docker.io`                                                        |
| `appFromExternalRepo.clone.image.repository`      | GIT image name                                                                 | `bitnami/git`                                                      |
| `appFromExternalRepo.clone.image.tag`             | GIT image tag                                                                  | `{TAG_NAME}`                                                       |
| `appFromExternalRepo.clone.image.pullPolicy`      | GIT image pull policy                                                          | `IfNotPresent`                                                     |
| `appFromExternalRepo.clone.image.pullSecrets`     | Specify docker-registry secret names as an array                               | `[]` (does not add image pull secrets to deployed pods)            |
| `appFromExternalRepo.clone.repository`            | GIT Repository to clone                                                        | `https://github.com/dotnet/AspNetCore.Docs.git`                    |
| `appFromExternalRepo.clone.revision`              | GIT revision to checkout                                                       | `main`                                                             |
| `appFromExternalRepo.clone.extraVolumeMounts`     | Add extra volume mounts for the GIT container                                  | `[]`                                                               |
| `appFromExternalRepo.publish.image.registry`      | .NET SDK image registry                                                        | `docker.io`                                                        |
| `appFromExternalRepo.publish.image.repository`    | .NET SDK Image name                                                            | `bitnami/git`                                                      |
| `appFromExternalRepo.publish.image.tag`           | .NET SDK Image tag                                                             | `{TAG_NAME}`                                                       |
| `appFromExternalRepo.publish.image.pullPolicy`    | .NET SDK image pull policy                                                     | `IfNotPresent`                                                     |
| `appFromExternalRepo.publish.image.pullSecrets`   | Specify docker-registry secret names as an array                               | `[]` (does not add image pull secrets to deployed pods)            |
| `appFromExternalRepo.publish.subFolder`           | Sub folder under the Git repository containin the ASP.NET Core app             | `spnetcore/fundamentals/servers/kestrel/samples/3.x/KestrelSample` |
| `appFromExternalRepo.publish.extraFlags`          | Extra flags to be appended to "dotnet publish" command                         | `[]`                                                               |
| `appFromExternalRepo.startCommand`                | Command used to start ASP.NET Core app                                         | `["dotnet", "KestrelSample.dll"]`                                  |
| `appFromExistingPVC.enabled`                      | Enable mounting your ASP.NET Core app from an existing PVC                     | `false`                                                            |
| `appFromExistingPVC.existingClaim`                | A existing Persistent Volume Claim containing your ASP.NET Core app            | `nil`                                                              |

### Exposure parameters

| Parameter                               | Description                                                                              | Default                                                 |
|-----------------------------------------|------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `service.type`                          | Kubernetes service type                                                                  | `ClusterIP`                                             |
| `service.port`                          | Service HTTP port                                                                        | `8081`                                                  |
| `service.nodePort`                      | Service HTTP node port                                                                   | `nil`                                                   |
| `service.clusterIP`                     | ASP.NET Core service clusterIP IP                                                        | `None`                                                  |
| `service.externalTrafficPolicy`         | Enable client source IP preservation                                                     | `Cluster`                                               |
| `service.loadBalancerIP`                | loadBalancerIP if service type is `LoadBalancer`                                         | `nil`                                                   |
| `service.loadBalancerSourceRanges`      | Address that are allowed when service is LoadBalancer                                    | `[]`                                                    |
| `service.annotations`                   | Annotations for ASP.NET Core service                                                     | `{}`                                                    |
| `ingress.enabled`                       | Enable ingress controller resource                                                       | `false`                                                 |
| `ingress.apiVersion`             | Force Ingress API version (automatically detected if not set) | ``                             |
| `ingress.path`                   | Ingress path                                                  | `/`                            |
| `ingress.pathType`               | Ingress path type                                             | `ImplementationSpecific`       |
| `ingress.certManager`                   | Add annotations for cert-manager                                                         | `false`                                                 |
| `ingress.hostname`                      | Default host for the ingress resource                                                    | `aspnet-core.local`                                     |
| `ingress.tls`                           | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter        | `false`                                                 |
| `ingress.annotations`                   | Ingress annotations                                                                      | `[]`                                                    |
| `ingress.extraHosts[0].name`            | Additional hostnames to be covered                                                       | `nil`                                                   |
| `ingress.extraHosts[0].path`            | Additional hostnames to be covered                                                       | `nil`                                                   |
| `ingress.extraTls[0].hosts[0]`          | TLS configuration for additional hostnames to be covered                                 | `nil`                                                   |
| `ingress.extraTls[0].secretName`        | TLS configuration for additional hostnames to be covered                                 | `nil`                                                   |
| `ingress.secrets[0].name`               | TLS Secret Name                                                                          | `nil`                                                   |
| `ingress.secrets[0].certificate`        | TLS Secret Certificate                                                                   | `nil`                                                   |
| `ingress.secrets[0].key`                | TLS Secret Key                                                                           | `nil`                                                   |
| `healthIngress.enabled`                 | Enable healthIngress controller resource                                                 | `false`                                                 |
| `healthIngress.certManager`             | Add annotations for cert-manager                                                         | `false`                                                 |
| `healthIngress.hostname`                | Default host for the healthIngress resource                                              | `aspnet-core.local`                                     |
| `healthIngress.tls`                     | Enable TLS configuration for the hostname defined at `healthIngress.hostname` parameter  | `false`                                                 |
| `healthIngress.annotations`             | Ingress annotations                                                                      | `[]`                                                    |
| `healthIngress.extraHosts[0].name`      | Additional hostnames to be covered                                                       | `nil`                                                   |
| `healthIngress.extraHosts[0].path`      | Additional hostnames to be covered                                                       | `nil`                                                   |
| `healthIngress.extraTls[0].hosts[0]`    | TLS configuration for additional hostnames to be covered                                 | `nil`                                                   |
| `healthIngress.extraTls[0].secretName`  | TLS configuration for additional hostnames to be covered                                 | `nil`                                                   |
| `healthIngress.secrets[0].name`         | TLS Secret Name                                                                          | `nil`                                                   |
| `healthIngress.secrets[0].certificate`  | TLS Secret Certificate                                                                   | `nil`                                                   |
| `healthIngress.secrets[0].key`          | TLS Secret Key                                                                           | `nil`                                                   |

### RBAC parameters

| Parameter                               | Description                                                         | Default                                                 |
|-----------------------------------------|---------------------------------------------------------------------|---------------------------------------------------------|
| `serviceAccount.create`                 | Enable the creation of a ServiceAccount for ASP.NET Core pods       | `true`                                                  |
| `serviceAccount.name`                   | Name of the created ServiceAccount                                  | Generated using the `aspnet-core.fullname` template     |
| `serviceAccount.annotations`            | Annotations for ASP.NET Core ServiceAccount                         | `{}`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set replicaCount=2 bitnami/aspnet-core
```

The above command install ASP.NET Core chart with 2 replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/aspnet-core
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

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

Find more information about the process to create your own image in the guide below:

- [Develop and Publish an ASP.NET Web Application using Bitnami Containers](https://docs.bitnami.com/tutorials/develop-aspnet-application-bitnami-containers).

#### Cloning your ASP.NET Core application code from a GIT repository

This is done using two different init containers:

- `clone-repository`: uses the [Bitnami GIT Image](https://github.com/bitnami/bitnami-docker-git) to download the repository.
- `dotnet-publish`: uses the [Bitnami .Net SDK Image](https://github.com/bitnami/bitnami-docker-dotnet-sdk) to build/publish the ASP.NET Core application.

To use this feature, set the `appFromExternalRepo.enabled` to `true` and set the repository and branch to use setting the `appFromExternalRepo.clone.repository` and `appFromExternalRepo.clone.revision` parameters. Then, specify the sub folder under the Git repository containing the ASP.NET Core app setting the `appFromExternalRepo.publish.subFolder` parameter. Finally, provide the start command to use setting the `appFromExternalRepo.startCommand`.

> Note: you can append any custom flag for the "dotnet publish" command setting the `appFromExternalRepo.publish.extraFlags` parameter.

For example, you can deploy a sample [Kestrel server](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel) using the parameters below:

```console
appFromExternalRepo.enabled=true
appFromExternalRepo.clone.repository=https://github.com/dotnet/AspNetCore.Docs.git
appFromExternalRepo.clone.revision=main
appFromExternalRepo.publish.aspnetcore/fundamentals/servers/kestrel/samples/3.x/KestrelSample
appFromExternalRepo.startCommand[0]=dotnet
appFromExternalRepo.startCommand[1]=KestrelSample.dll
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
      labels: {{- include "common.labels.standard" . | nindent 6 }}
        {{- if .Values.commonLabels }}
        {{- include "common.tplvalues.render" ( dict "value" .Values.commonLabels "context" $ ) | nindent 6 }}
        {{- end }}
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

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to serve your ASP.NET Core application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this ASP.NET Core installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.0.0

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
