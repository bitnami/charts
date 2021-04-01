# Tomcat

[Apache Tomcat](http://tomcat.apache.org/), often referred to as Tomcat, is an open-source web server and servlet container developed by the Apache Software Foundation. Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages, Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment for Java code to run in.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/tomcat
```

## Introduction

This chart bootstraps a [Tomcat](https://github.com/bitnami/bitnami-docker-tomcat) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/tomcat
```

These commands deploy Tomcat on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Tomcat chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                          | Default                        |
|---------------------|----------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname                   | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname                       | `nil`                          |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`                           |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `nil`                          |

### Tomcat parameters

| Parameter                     | Description                                                          | Default                                                 |
|-------------------------------|----------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`              | Tomcat image registry                                                | `docker.io`                                             |
| `image.repository`            | Tomcat image name                                                    | `bitnami/tomcat`                                        |
| `image.tag`                   | Tomcat image tag                                                     | `{TAG_NAME}`                                            |
| `image.pullPolicy`            | Tomcat image pull policy                                             | `IfNotPresent`                                          |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                     | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                 | Specify if debug logs should be enabled                              | `false`                                                 |
| `hostAliases`                 | Add deployment host aliases                                          | `[]`                                                    |
| `tomcatUsername`              | Tomcat admin user                                                    | `user`                                                  |
| `tomcatPassword`              | Tomcat admin password                                                | _random 10 character alphanumeric string_               |
| `tomcatAllowRemoteManagement` | Enable remote access to management interface                         | `0` (disabled)                                          |
| `command`                     | Override default container command (useful when using custom images) | `nil`                                                   |
| `args`                        | Override default container args (useful when using custom images)    | `nil`                                                   |
| `extraEnvVars`                | Extra environment variables to be set on Tomcat container            | `{}`                                                    |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                 | `nil`                                                   |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                    | `nil`                                                   |

### Tomcat deployment parameters

| Parameter                   | Description                                                                               | Default                                     |
|-----------------------------|-------------------------------------------------------------------------------------------|---------------------------------------------|
| `replicaCount`              | Specify number of Tomcat replicas                                                         | `1`                                         |
| `containerPort`             | HTTP port to expose at container level                                                    | `8080`                                      |
| `podSecurityContext`        | Tomcat pods' Security Context                                                             | Check `values.yaml` file                    |
| `containerSecurityContext`  | Tomcat containers' Security Context                                                       | Check `values.yaml` file                    |
| `resources.limits`          | The resources limits for the Tomcat container                                             | `{}`                                        |
| `resources.requests`        | The requested resources for the Tomcat container                                          | `{"memory": "512Mi", "cpu": "300m"}`        |
| `livenessProbe`             | Liveness probe configuration for Tomcat                                                   | Check `values.yaml` file                    |
| `readinessProbe`            | Readiness probe configuration for Tomcat                                                  | Check `values.yaml` file                    |
| `customLivenessProbe`       | Override default liveness probe                                                           | `nil`                                       |
| `customReadinessProbe`      | Override default readiness probe                                                          | `nil`                                       |
| `updateStrategy`            | Strategy to use to update Pods                                                            | Check `values.yaml` file                    |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                        |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                      |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                        |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                        |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                        |
| `affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template)              |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template)              |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)              |
| `podLabels`                 | Extra labels for Tomcat pods                                                              | `{}` (evaluated as a template)              |
| `podAnnotations`            | Annotations for Tomcat pods                                                               | `{}` (evaluated as a template)              |
| `extraVolumeMounts`         | Optionally specify extra list of additional volumeMounts for Tomcat container(s)          | `[]`                                        |
| `extraVolumes`              | Optionally specify extra list of additional volumes for Tomcat pods                       | `[]`                                        |
| `initContainers`            | Add additional init containers to the Tomcat pods                                         | `{}` (evaluated as a template)              |
| `sidecars`                  | Add additional sidecar containers to the Tomcat pods                                      | `{}` (evaluated as a template)              |
| `persistence.enabled`       | Enable persistence using PVC                                                              | `true`                                      |
| `persistence.storageClass`  | PVC Storage Class for Tomcat volume                                                       | `nil` (uses alpha storage class annotation) |
| `persistence.existingClaim` | An Existing PVC name for Tomcat volume                                                    | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`    | PVC Access Mode for Tomcat volume                                                         | `ReadWriteOnce`                             |
| `persistence.size`          | PVC Storage Request for Tomcat volume                                                     | `8Gi`                                       |

### Exposure parameters

| Parameter                        | Description                                                                       | Default                        |
|----------------------------------|-----------------------------------------------------------------------------------|--------------------------------|
| `service.type`                   | Kubernetes Service type                                                           | `LoadBalancer`                 |
| `service.port`                   | Service HTTP port                                                                 | `80`                           |
| `service.nodePort`               | Kubernetes http node port                                                         | `""`                           |
| `service.loadBalancerIP`         | Kubernetes LoadBalancerIP to request                                              | `nil`                          |
| `service.externalTrafficPolicy`  | Enable client source IP preservation                                              | `Cluster`                      |
| `service.annotations`            | Annotations for Tomcat service                                                    | `{}` (evaluated as a template) |
| `ingress.enabled`                | Enable ingress controller resource                                                | `false`                        |
| `ingress.apiVersion`             | Force Ingress API version (automatically detected if not set)                     | ``                             |
| `ingress.path`                   | Ingress path                                                                      | `/`                            |
| `ingress.pathType`               | Ingress path type                                                                 | `ImplementationSpecific`       |
| `ingress.certManager`            | Add annotations for cert-manager                                                  | `false`                        |
| `ingress.hostname`               | Default host for the ingress resource                                             | `tomcat.local`                 |
| `ingress.tls`                    | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter | `false`                        |
| `ingress.annotations`            | Ingress annotations                                                               | `{}` (evaluated as a template) |
| `ingress.extraHosts[0].name`     | Additional hostnames to be covered                                                | `nil`                          |
| `ingress.extraHosts[0].path`     | Additional hostnames to be covered                                                | `nil`                          |
| `ingress.extraTls[0].hosts[0]`   | TLS configuration for additional hostnames to be covered                          | `nil`                          |
| `ingress.extraTls[0].secretName` | TLS configuration for additional hostnames to be covered                          | `nil`                          |
| `ingress.secrets[0].name`        | TLS Secret Name                                                                   | `nil`                          |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                                                            | `nil`                          |
| `ingress.secrets[0].key`         | TLS Secret Key                                                                    | `nil`                          |

### Volume Permissions parameters

| Parameter                              | Description                                                                 | Default                                                 |
|----------------------------------------|-----------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory | `false`                                                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                            | `docker.io`                                             |
| `volumePermissions.image.repository`   | Init container volume-permissions image name                                | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag                                 | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                         | `Always`                                                |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                            | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.resources.limits`   | Init container volume-permissions resource  limits                          | `{}`                                                    |
| `volumePermissions.resources.requests` | Init container volume-permissions resource  requests                        | `{}`                                                    |

The above parameters map to the env variables defined in [bitnami/tomcat](http://github.com/bitnami/bitnami-docker-tomcat). For more information please refer to the [bitnami/tomcat](http://github.com/bitnami/bitnami-docker-tomcat) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set tomcatUser=manager,tomcatPassword=password bitnami/tomcat
```

The above command sets the Tomcat management username and password to `manager` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/tomcat
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Change Tomcat version

To modify the Tomcat version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/tomcat/tags/) using the `image.tag` parameter. For example, `image.tag=X.Y.Z`. This approach is also applicable to other images like exporters.

## Persistence

The [Bitnami Tomcat](https://github.com/bitnami/bitnami-docker-tomcat) image stores the Tomcat data and configurations at the `/bitnami/tomcat` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the Tomcat app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 8.0.0

- Chart labels were adapted to follow the [Helm charts standard labels](https://helm.sh/docs/chart_best_practices/labels/#standard-labels).
- Ingress configuration was also adapted to follow the Helm charts best practices.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

Consequences:

- Backwards compatibility is not guaranteed. However, you can easily workaround this issue by removing Tomcat deployment before upgrading (the following example assumes that the release name is `tomcat`):

```console
$ export TOMCAT_PASSWORD=$(kubectl get secret --namespace default tomcat -o jsonpath="{.data.tomcat-password}" | base64 --decode)
$ kubectl delete deployments.apps tomcat
$ helm upgrade tomcat bitnami/tomcat --set tomcatPassword=$TOMCAT_PASSWORD
```

### To 7.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

### Useful links

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 5.0.0

This release updates the Bitnami Tomcat container to `9.0.26-debian-9-r0`, which is based on Bash instead of Node.js.

### To 2.1.0

Tomcat container was moved to a non-root approach. There shouldn't be any issue when upgrading since the corresponding `securityContext` is enabled by default. Both the container image and the chart can be upgraded by running the command below:

```
$ helm upgrade my-release bitnami/tomcat
```

If you use a previous container image (previous to **8.5.35-r26**) disable the `securityContext` by running the command below:

```
$ helm upgrade my-release bitnami/tomcat --set securityContext.enabled=false,image.tag=XXX
```

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is tomcat:

```console
$ kubectl patch deployment tomcat --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
