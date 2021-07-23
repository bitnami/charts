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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name                | Description                                       | Value           |
| ------------------- | ------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                       | `""`            |
| `nameOverride`      | String to partially override aspnet-core.fullname | `""`            |
| `fullnameOverride`  | String to fully override aspnet-core.fullname     | `""`            |
| `commonLabels`      | Labels to add to all deployed objects             | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects        | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                    | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release | `[]`            |


### ASP.NET Core parameters

| Name                 | Description                                                          | Value                 |
| -------------------- | -------------------------------------------------------------------- | --------------------- |
| `image.registry`     | ASP.NET Core image registry                                          | `docker.io`           |
| `image.repository`   | ASP.NET Core image repository                                        | `bitnami/aspnet-core` |
| `image.tag`          | ASP.NET Core image tag (immutable tags are recommended)              | `3.1.17-debian-10-r0` |
| `image.pullPolicy`   | ASP.NET Core image pull policy                                       | `IfNotPresent`        |
| `image.pullSecrets`  | ASP.NET Core image pull secrets                                      | `[]`                  |
| `command`            | Override default container command (useful when using custom images) | `[]`                  |
| `args`               | Override default container args (useful when using custom images)    | `[]`                  |
| `bindURLs`           | URLs to bind                                                         | `http://+:8080`       |
| `extraEnvVars`       | Extra environment variables to be set on ASP.NET Core container      | `[]`                  |
| `extraEnvVarsCM`     | ConfigMap with extra environment variables                           | `""`                  |
| `extraEnvVarsSecret` | Secret with extra environment variables                              | `""`                  |


### ASP.NET Core deployment parameters

| Name                                 | Description                                                                               | Value           |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                       | Number of ASP.NET Core replicas to deploy                                                 | `1`             |
| `strategyType`                       | ASP.NET Core deployment strategy type. Set it to `RollingUpdate` or `Recreate`            | `RollingUpdate` |
| `priorityClassName`                  | ASP.NET Core pod priority class name                                                      | `""`            |
| `hostAliases`                        | ASP.NET Core pod host aliases                                                             | `[]`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for ASP.NET Core pods                 | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for ASP.NET Core container(s)    | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the ASP.NET Core pods                                | `[]`            |
| `initContainers`                     | Add additional init containers to the ASP.NET Core pods                                   | `[]`            |
| `lifecycleHooks`                     | Add lifecycle hooks to the ASP.NET Core deployment                                        | `{}`            |
| `podAnnotations`                     | Annotations for ASP.NET Core pods                                                         | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `affinity`                           | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                        | Tolerations for pod assignment                                                            | `[]`            |
| `resources.limits`                   | The resources limits for the ASP.NET Core container                                       | `{}`            |
| `resources.requests`                 | The requested resources for the ASP.NET Core container                                    | `{}`            |
| `containerPort`                      | Port to expose at ASP.NET Core container level                                            | `8080`          |
| `podSecurityContext.enabled`         | Enabled ASP.NET Core pods' Security Context                                               | `false`         |
| `podSecurityContext.sysctls`         | Set namespaced sysctls for the ASP.NET Core pods                                          | `{}`            |
| `containerSecurityContext.enabled`   | Enabled ASP.NET Core containers' Security Context                                         | `false`         |
| `containerSecurityContext.runAsUser` | Set ASP.NET Core container's Security Context runAsUser                                   | `0`             |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `10`            |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `20`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `1`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `10`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `20`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `1`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                       | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                      | `{}`            |
| `pdb.create`                         | Enable/disable a Pod Disruption Budget creation                                           | `false`         |
| `pdb.minAvailable`                   | Minimum number/percentage of pods that should remain scheduled                            | `1`             |
| `pdb.maxUnavailable`                 | Maximum number/percentage of pods that may be made unavailable                            | `""`            |
| `autoscaling.enabled`                | Enable autoscaling for ASP.NET Core                                                       | `false`         |
| `autoscaling.minReplicas`            | Minimum number of ASP.NET Core replicas                                                   | `1`             |
| `autoscaling.maxReplicas`            | Maximum number of ASP.NET Core replicas                                                   | `11`            |
| `autoscaling.targetCPU`              | Target CPU utilization percentage                                                         | `""`            |
| `autoscaling.targetMemory`           | Target Memory utilization percentage                                                      | `""`            |


### Custom ASP.NET Core application parameters

| Name                                            | Description                                                            | Value                                                               |
| ----------------------------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `appFromExternalRepo.enabled`                   | Enable to download/build ASP.NET Core app from external git repository | `true`                                                              |
| `appFromExternalRepo.clone.image.registry`      | Git image registry                                                     | `docker.io`                                                         |
| `appFromExternalRepo.clone.image.repository`    | Git image repository                                                   | `bitnami/git`                                                       |
| `appFromExternalRepo.clone.image.tag`           | Git image tag (immutable tags are recommended)                         | `2.32.0-debian-10-r31`                                              |
| `appFromExternalRepo.clone.image.pullPolicy`    | Git image pull policy                                                  | `IfNotPresent`                                                      |
| `appFromExternalRepo.clone.image.pullSecrets`   | Git image pull secrets                                                 | `[]`                                                                |
| `appFromExternalRepo.clone.repository`          | Git repository to clone                                                | `https://github.com/dotnet/AspNetCore.Docs.git`                     |
| `appFromExternalRepo.clone.revision`            | Git revision to checkout                                               | `main`                                                              |
| `appFromExternalRepo.clone.extraVolumeMounts`   | Add extra volume mounts for the GIT container                          | `[]`                                                                |
| `appFromExternalRepo.publish.image.registry`    | .NET SDK image registry                                                | `docker.io`                                                         |
| `appFromExternalRepo.publish.image.repository`  | .NET SDK image repository                                              | `bitnami/dotnet-sdk`                                                |
| `appFromExternalRepo.publish.image.tag`         | .NET SDK image tag (immutable tags are recommended)                    | `3.1.410-debian-10-r28`                                             |
| `appFromExternalRepo.publish.image.pullPolicy`  | .NET SDK image pull policy                                             | `IfNotPresent`                                                      |
| `appFromExternalRepo.publish.image.pullSecrets` | .NET SDK image pull secrets                                            | `[]`                                                                |
| `appFromExternalRepo.publish.subFolder`         | Sub folder under the Git repository containing the ASP.NET Core app    | `aspnetcore/fundamentals/servers/kestrel/samples/3.x/KestrelSample` |
| `appFromExternalRepo.publish.extraFlags`        | Extra flags to be appended to "dotnet publish" command                 | `[]`                                                                |
| `appFromExternalRepo.startCommand`              | Command used to start ASP.NET Core app                                 | `[]`                                                                |
| `appFromExistingPVC.enabled`                    | Enable mounting your ASP.NET Core app from an existing PVC             | `false`                                                             |
| `appFromExistingPVC.existingClaim`              | A existing Persistent Volume Claim containing your ASP.NET Core app    | `""`                                                                |


### Traffic Exposure Parameters

| Name                               | Description                                                                         | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | ASP.NET Core service type                                                           | `ClusterIP`              |
| `service.port`                     | ASP.NET Core service HTTP port                                                      | `80`                     |
| `service.nodePort`                 | Node ports to expose                                                                | `""`                     |
| `service.clusterIP`                | ASP.NET Core service Cluster IP                                                     | `""`                     |
| `service.loadBalancerIP`           | ASP.NET Core service Load Balancer IP                                               | `""`                     |
| `service.loadBalancerSourceRanges` | ASP.NET Core service Load Balancer sources                                          | `[]`                     |
| `service.externalTrafficPolicy`    | ASP.NET Core service external traffic policy                                        | `Cluster`                |
| `service.annotations`              | Additional custom annotations for ASP.NET Core service                              | `{}`                     |
| `ingress.enabled`                  | Enable ingress record generation for ASP.NET Core                                   | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                   | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                       | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource, a host pointing to this will be created      | `aspnet-core.local`      |
| `ingress.path`                     | Default path for the ingress record                                                 | `ImplementationSpecific` |
| `ingress.annotations`              | Additional custom annotations for the ingress record                                | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter       | `false`                  |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                      | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record          | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                  | `[]`                     |
| `healthIngress.enabled`            | Enable healthIngress record generation for ASP.NET Core                             | `false`                  |
| `healthIngress.hostname`           | When the health ingress is enabled, a host pointing to this will be created         | `aspnet-core.local`      |
| `healthIngress.annotations`        | Additional custom annotations for the ingress record                                | `{}`                     |
| `healthIngress.tls`                | Enable TLS configuration for the host defined at `ingress.hostname` parameter       | `false`                  |
| `healthIngress.certManager`        | Set this to true in order to add the corresponding annotations for cert-manager     | `false`                  |
| `healthIngress.extraHosts`         | n array with additional hostname(s) to be covered with the ingress record           | `[]`                     |
| `healthIngress.extraTls`           | TLS configuration for additional hostname(s) to be covered with this ingress record | `[]`                     |
| `healthIngress.secrets`            | Custom TLS certificates as secrets                                                  | `[]`                     |


### RBAC parameters

| Name                         | Description                                          | Value  |
| ---------------------------- | ---------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a ServiceAccount should be created | `true` |
| `serviceAccount.name`        | The name of the ServiceAccount to use.               | `""`   |
| `serviceAccount.annotations` | Additional custom annotations for the ServiceAccount | `{}`   |


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
