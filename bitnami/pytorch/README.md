# PyTorch

[PyTorch](http://pytorch.org/) is a deep learning platform that accelerates the transition from research prototyping to production deployment. It is built for full integration into Python that enables you to use it with its libraries and main packages.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/pytorch
```

## Introduction

This chart bootstraps a [PyTorch](https://github.com/bitnami/bitnami-docker-pytorch) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

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
$ helm install my-release bitnami/pytorch
```

These commands deploy PyTorch on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the PyTorch chart and their default values.

| Parameter                             | Description                                                                                                                                               | Default                                                 |
|---------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                | Global Docker image registry                                                                                                                              | `nil`                                                   |
| `global.imagePullSecrets`             | Global Docker registry secret names as an array                                                                                                           | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                 | Global storage class for dynamic provisioning                                                                                                             | `nil`                                                   |
| `image.registry`                      | PyTorch image registry                                                                                                                                    | `docker.io`                                             |
| `image.repository`                    | PyTorch image name                                                                                                                                        | `bitnami/pytorch`                                       |
| `image.tag`                           | PyTorch image tag                                                                                                                                         | `{TAG_NAME}`                                            |
| `image.pullPolicy`                    | Image pull policy                                                                                                                                         | `IfNotPresent`                                          |
| `image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                         | Specify if debug logs should be enabled                                                                                                                   | `false`                                                 |
| `git.registry`                        | Git image registry                                                                                                                                        | `docker.io`                                             |
| `git.repository`                      | Git image name                                                                                                                                            | `bitnami/git`                                           |
| `git.tag`                             | Git image tag                                                                                                                                             | `{TAG_NAME}`                                            |
| `git.pullPolicy`                      | Git image pull policy                                                                                                                                     | `IfNotPresent`                                          |
| `git.pullSecrets`                     | Specify docker-registry secret names as an array                                                                                                          | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                        | String to partially override common.names.fullname template with a string (will prepend the release name)                                                 | `nil`                                                   |
| `fullnameOverride`                    | String to fully override common.names.fullname template with a string                                                                                     | `nil`                                                   |
| `hostAliases`                         | Add deployment host aliases                                                                                                                               | `[]`                                                    |
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                                                          | `docker.io`                                             |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                                                              | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`         | Init container volume-permissions image tag                                                                                                               | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                |
| `volumePermissions.resources`         | Init container resource requests/limit                                                                                                                    | `nil`                                                   |
| `service.type`                        | Kubernetes service type                                                                                                                                   | `ClusterIP`                                             |
| `entrypoint.file`                     | Main entrypoint to your application                                                                                                                       | `''`                                                    |
| `entrypoint.args`                     | Args required by your entrypoint                                                                                                                          | `nil`                                                   |
| `mode`                                | Run PyTorch in standalone or distributed mode (possible values: `standalone`, `distributed`)                                                              | `standalone`                                            |
| `worldSize`                           | Number of nodes that will execute your code                                                                                                               | `nil`                                                   |
| `port`                                | PyTorch master port                                                                                                                                       | `49875`                                                 |
| `configMap`                           | Config map that contains the files you want to load in PyTorch                                                                                            | `nil`                                                   |
| `cloneFilesFromGit.enabled`           | Enable in order to download files from git repository                                                                                                     | `false`                                                 |
| `cloneFilesFromGit.repository`        | Repository that holds the files                                                                                                                           | `nil`                                                   |
| `cloneFilesFromGit.revision`          | Revision from the repository to checkout                                                                                                                  | `master`                                                |
| `cloneFilesFromGit.extraVolumeMounts` | Add extra volume mounts for the GIT container                                                                                                             | `[]`                                                    |
| `extraEnvVars`                        | Extra environment variables to add to master and workers pods                                                                                             | `nil`                                                   |
| `podAffinityPreset`                   | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                                                    |
| `podAntiAffinityPreset`               | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `soft`                                                  |
| `nodeAffinityPreset.type`             | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                 | `""`                                                    |
| `nodeAffinityPreset.key`              | Node label key to match Ignored if `affinity` is set.                                                                                                     | `""`                                                    |
| `nodeAffinityPreset.values`           | Node label values to match. Ignored if `affinity` is set.                                                                                                 | `[]`                                                    |
| `affinity`                            | Affinity for pod assignment                                                                                                                               | `{}` (evaluated as a template)                          |
| `nodeSelector`                        | Node labels for pod assignment                                                                                                                            | `{}` (evaluated as a template)                          |
| `tolerations`                         | Tolerations for pod assignment                                                                                                                            | `[]` (evaluated as a template)                          |
| `resources`                           | Pod resources                                                                                                                                             | `{}`                                                    |
| `securityContext.enabled`             | Enable security context                                                                                                                                   | `true`                                                  |
| `securityContext.fsGroup`             | Group ID for the container                                                                                                                                | `1001`                                                  |
| `securityContext.runAsUser`           | User ID for the container                                                                                                                                 | `1001`                                                  |
| `livenessProbe.enabled`               | Enable/disable the Liveness probe                                                                                                                         | `true`                                                  |
| `livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                                                                                  | `5`                                                     |
| `livenessProbe.periodSeconds`         | How often to perform the probe                                                                                                                            | `5`                                                     |
| `livenessProbe.timeoutSeconds`        | When the probe times out                                                                                                                                  | `5`                                                     |
| `livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed.                                                              | `1`                                                     |
| `livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `5`                                                     |
| `readinessProbe.enabled`              | Enable/disable the Readiness probe                                                                                                                        | `true`                                                  |
| `readinessProbe.initialDelaySeconds`  | Delay before readiness probe is initiated                                                                                                                 | `5`                                                     |
| `readinessProbe.periodSeconds`        | How often to perform the probe                                                                                                                            | `5`                                                     |
| `readinessProbe.timeoutSeconds`       | When the probe times out                                                                                                                                  | `1`                                                     |
| `readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.                                                              | `1`                                                     |
| `readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                | `5`                                                     |
| `persistence.enabled`                 | Use a PVC to persist data                                                                                                                                 | `true`                                                  |
| `persistence.mountPath`               | Path to mount the volume at                                                                                                                               | `/bitnami/pytorch`                                      |
| `persistence.storageClass`            | Storage class of backing PVC                                                                                                                              | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`              | Use volume as ReadOnly or ReadWrite                                                                                                                       | `ReadWriteOnce`                                         |
| `persistence.size`                    | Size of data volume                                                                                                                                       | `8Gi`                                                   |
| `persistence.annotations`             | Persistent Volume annotations                                                                                                                             | `{}`                                                    |
| `extraVolumes`                        | Array to add extra volumes                                                                                                                                | `[]` (evaluated as a template)                          |
| `extraVolumeMounts`                   | Array to add extra mount                                                                                                                                  | `[]` (evaluated as a template)                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set mode=distributed \
  --set worldSize=4 \
    bitnami/pytorch
```

The above command create 4 pods for PyTorch: one master and three workers.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/pytorch
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Loading your files

The PyTorch chart supports three different ways to load your files. In order of priority, they are:

  1. Existing config map
  2. Files under the `files` directory
  3. Cloning a git repository

This means that if you specify a config map with your files, it won't look for the `files/` directory nor the git repository.

In order to use use an existing config map, set the `configMap=my-config-map` parameter.

To load your files from the `files/` directory you don't have to set any option. Just copy your files inside and don't specify a `ConfigMap`.

Finally, if you want to clone a git repository you can use those parameters:

```console
cloneFilesFromGit.enabled=true
cloneFilesFromGit.repository=https://github.com/my-user/my-repo
cloneFilesFromGit.revision=master
```

## Persistence

The [Bitnami PyTorch](https://github.com/bitnami/bitnami-docker-pytorch) image can persist data. If enabled, the persisted path is `/bitnami/pytorch` by default.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### 2.1.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 2.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/
