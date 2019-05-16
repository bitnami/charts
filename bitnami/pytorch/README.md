# PyTorch

[PyTorch](http://pytorch.org/) is a deep learning platform that accelerates the transition from research prototyping to production deployment. It is built for full integration into Python that enables you to use it with its libraries and main packages.

## TL;DR;

```console
$ helm install bitnami/pytorch
```

## Introduction

This chart bootstraps a [PyTorch](https://github.com/bitnami/bitnami-docker-pytorch) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/pytorch
```

The command deploys PyTorch on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the MinIO chart and their default values.

| Parameter                            | Description                                                                                  | Default                                                 |
| ------------------------------------ | -------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`               | Global Docker image registry                                                                 | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                              | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                     | PyTorch image registry                                                                       | `docker.io`                                             |
| `image.repository`                   | PyTorch image name                                                                           | `bitnami/pytorch`                                       |
| `image.tag`                          | PyTorch image tag                                                                            | `{VERSION}`                                             |
| `image.pullPolicy`                   | Image pull policy                                                                            | `IfNotPresent`                                          |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                        | Specify if debug logs should be enabled                                                      | `false`                                                 |
| `git.registry`                       | Git image registry                                                                           | `docker.io`                                             |
| `git.repository`                     | Git image name                                                                               | `bitnami/git`                                           |
| `git.tag`                            | Git image tag                                                                                | `latest`                                                |
| `git.pullPolicy`                     | Git image pull policy                                                                        | `Always`                                                |
| `git.pullSecrets`                    | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods) |
| `entrypoint.file`                    | Main entrypoint to your application                                                          | `''`                                                    |
| `entrypoint.args`                    | Args required by your entrypoint                                                             | `nil`                                                   |
| `mode`                               | Run PyTorch in standalone or distributed mode (possible values: `standalone`, `distributed`) | `standalone`                                            |
| `worldSize`                          | Number of nodes that will execute your code                                                  | `nil`                                                   |
| `port`                               | PyTorch master port                                                                          | `49875`                                                 |
| `configMap`                          | Config map that contains the files you want to load in PyTorch                               | `nil`                                                   |
| `cloneFilesFromGit.enabled`          | Enable in order to download files from git repository                                        | `false`                                                 |
| `cloneFilesFromGit.repository`       | Repository that holds the files                                                              | `nil`                                                   |
| `cloneFilesFromGit.revision`         | Revision from the repository to checkout                                                     | `master`                                                |
| `extraEnvVars`                       | Extra environment variables to add to master and workers pods                                | `nil`                                                   |
| `nodeSelector`                       | Node labels for pod assignment                                                               | `{}`                                                    |
| `tolerations`                        | Toleration labels for pod assignment                                                         | `[]`                                                    |
| `affinity`                           | Map of node/pod affinities                                                                   | `{}`                                                    |
| `resources`                          | Pod resources                                                                                | `{}`                                                    |
| `securityContext.enabled`            | Enable security context                                                                      | `true`                                                  |
| `securityContext.fsGroup`            | Group ID for the container                                                                   | `1001`                                                  |
| `securityContext.runAsUser`          | User ID for the container                                                                    | `1001`                                                  |
| `livenessProbe.enabled`              | Enable/disable the Liveness probe                                                            | `true`                                                  |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                     | `5`                                                     |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                               | `5`                                                     |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                     | `5`                                                     |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                                     |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `5`                                                     |
| `readinessProbe.enabled`             | Enable/disable the Readiness probe                                                           | `true`                                                  |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                    | `5`                                                     |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                               | `5`                                                     |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                     | `1`                                                     |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                                     |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `5`                                                     |
| `persistence.enabled`                | Use a PVC to persist data                                                                    | `true`                                                  |
| `persistence.mountPath`              | Path to mount the volume at                                                                  | `/bitnami/pytorch`                                      |
| `persistence.storageClass`           | Storage class of backing PVC                                                                 | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`             | Use volume as ReadOnly or ReadWrite                                                          | `ReadWriteOnce`                                         |
| `persistence.size`                   | Size of data volume                                                                          | `8Gi`                                                   |
| `persistence.annotations`            | Persistent Volume annotations                                                                | `{}`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set mode=distributed \
  --set worldSize=4 \
    bitnami/pytorch
```

The above command create 4 pods for PyTorch: one master and three workers.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/pytorch
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Loading your files

The PyTorch chart supports three different ways to load your files. In order of priority, they are:

  1. Existing config map 
  2. Files under the `files` directory 
  3. Cloning a git repository

This means that if you specify a config map with your files, it won't look for the `files/` directory nor the git repository.

In order to use use an existing config map:

```console
$ helm install --name my-release \
  --set configMap=my-config-map \
  bitnami/pytorch
```

To load your files from the `files/` directory you don't have to set any option. Just copy your files inside and don't specify a `ConfigMap`: 

```console
$ helm install --name my-release \
  bitnami/pytorch
```

Finally, if you want to clone a git repository:

```console
$ helm install --name my-release \
  --set cloneFilesFromGit.enabled=true \
  --set cloneFilesFromGit.repository=https://github.com/my-user/my-repo \
  --set cloneFilesFromGit.revision=master \
  bitnami/pytorch
```

## Persistence

The [Bitnami PyTorch](https://github.com/bitnami/bitnami-docker-pytorch) image can persist data. If enabled, the persisted path is `/bitnami/pytorch` by default.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.
