# Apache MXNet (Incubating)

[Apache MXNet (Incubating)](https://mxnet.apache.org/) is a deep learning platform that accelerates the transition from research prototyping to production deployment. It is built for full integration into Python that enables you to use it with its libraries and main packages.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/mxnet
```

## Introduction

This chart bootstraps an [Apache MXNet (Incubating)](https://github.com/bitnami/bitnami-docker-mxnet) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

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
$ helm install my-release bitnami/mxnet
```

These commands deploy Apache MXNet (Incubating) on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Mxnet chart and their default values.

### Global Parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter          | Description                                        | Default |
|--------------------|----------------------------------------------------|---------|
| `nameOverride`     | String to partially override common.names.fullname | `nil`   |
| `fullnameOverride` | String to fully override common.names.fullname     | `nil`   |

### Common Mxnet parameters

| Parameter                             | Description                                                                                                    | Default                                                 |
|---------------------------------------|----------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `image.registry`                      | Apache MXNet (Incubating) image registry                                                                       | `docker.io`                                             |
| `image.repository`                    | Apache MXNet (Incubating) image name                                                                           | `bitnami/mxnet`                                         |
| `image.tag`                           | Apache MXNet (Incubating) image tag                                                                            | `{TAG_NAME}`                                            |
| `image.pullPolicy`                    | Image pull policy                                                                                              | `IfNotPresent`                                          |
| `image.pullSecrets`                   | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                         | Specify if debug logs should be enabled                                                                        | `false`                                                 |
| `git.registry`                        | Git image registry                                                                                             | `docker.io`                                             |
| `git.repository`                      | Git image name                                                                                                 | `bitnami/git`                                           |
| `git.tag`                             | Git image tag                                                                                                  | `{TAG_NAME}`                                            |
| `git.pullPolicy`                      | Git image pull policy                                                                                          | `IfNotPresent`                                          |
| `git.pullSecrets`                     | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.enabled`           | Enable init container that changes volume permissions in the data directory                                    | `false`                                                 |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                               | `docker.io`                                             |
| `volumePermissions.image.repository`  | Init container volume-permissions image name                                                                   | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`         | Init container volume-permissions image tag                                                                    | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                            | `Always`                                                |
| `volumePermissions.resources`         | Init container resource requests/limit                                                                         | `nil`                                                   |
| `entrypoint.file`                     | Main entrypoint to your application. If not specified, it will be a `sleep infinity` command                   | `''`                                                    |
| `entrypoint.args`                     | Args required by your entrypoint                                                                               | `nil`                                                   |
| `entrypoint.workDir`                  | Working directory for launching the entrypoint                                                                 | `'/app'`                                                |
| `podManagementPolicy`                 | StatefulSet (worker and server nodes) pod management policy                                                    | `Parallel`                                              |
| `mode`                                | Run Apache MXNet (Incubating) in standalone or distributed mode (possible values: `standalone`, `distributed`) | `standalone`                                            |
| `hostAliases`                         | Add deployment host aliases                                                                                    | `[]`                                                    |
| `commonExtraEnvVars`                  | Extra environment variables to add to server, scheduler and worker nodes                                       | `nil`                                                   |
| `configMap`                           | Config map that contains the files you want to load in Apache MXNet (Incubating)                               | `nil`                                                   |
| `cloneFilesFromGit.enabled`           | Enable in order to download files from git repository                                                          | `false`                                                 |
| `cloneFilesFromGit.repository`        | Repository that holds the files                                                                                | `nil`                                                   |
| `cloneFilesFromGit.revision`          | Revision from the repository to checkout                                                                       | `master`                                                |
| `cloneFilesFromGit.extraVolumeMounts` | Add extra volume mounts for the GIT container                                                                 | `[]`                                                    |
| `existingSecret`                      | Name of a secret with sensitive data to mount in the pods                                                      | `nil`                                                   |
| `service.type`                        | Kubernetes service type                                                                                        | `ClusterIP`                                             |
| `resources.limits`                    | The resources limits for the Mxnet container                                                                   | `{}`                                                    |
| `resources.requests`                  | The requested resources for the Mxnet container                                                                | `{}`                                                    |
| `podAffinityPreset`                   | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                            | `""`                                                    |
| `podAntiAffinityPreset`               | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                       | `soft`                                                  |
| `nodeAffinityPreset.type`             | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                      | `""`                                                    |
| `nodeAffinityPreset.key`              | Node label key to match Ignored if `affinity` is set.                                                          | `""`                                                    |
| `nodeAffinityPreset.values`           | Node label values to match. Ignored if `affinity` is set.                                                      | `[]`                                                    |
| `affinity`                            | Affinity for pod assignment                                                                                    | `{}` (evaluated as a template)                          |
| `nodeSelector`                        | Node labels for pod assignment                                                                                 | `{}` (evaluated as a template)                          |
| `tolerations`                         | Tolerations for pod assignment                                                                                 | `[]` (evaluated as a template)                          |
| `securityContext.enabled`             | Enable security context                                                                                        | `true`                                                  |
| `securityContext.fsGroup`             | Group ID for the container                                                                                     | `1001`                                                  |
| `securityContext.runAsUser`           | User ID for the container                                                                                      | `1001`                                                  |
| `livenessProbe.enabled`               | Enable/disable the Liveness probe                                                                              | `true`                                                  |
| `livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                                       | `5`                                                     |
| `livenessProbe.periodSeconds`         | How often to perform the probe                                                                                 | `5`                                                     |
| `livenessProbe.timeoutSeconds`        | When the probe times out                                                                                       | `5`                                                     |
| `livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                     |
| `livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `5`                                                     |
| `readinessProbe.enabled`              | Enable/disable the Readiness probe                                                                             | `true`                                                  |
| `readinessProbe.initialDelaySeconds`  | Delay before readiness probe is initiated                                                                      | `5`                                                     |
| `readinessProbe.periodSeconds`        | How often to perform the probe                                                                                 | `5`                                                     |
| `readinessProbe.timeoutSeconds`       | When the probe times out                                                                                       | `1`                                                     |
| `readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                     |
| `readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `5`                                                     |
| `persistence.enabled`                 | Use a PVC to persist data                                                                                      | `false`                                                 |
| `persistence.mountPath`               | Path to mount the volume at                                                                                    | `/bitnami/mxnet`                                        |
| `persistence.storageClass`            | Storage class of backing PVC                                                                                   | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`              | Use volume as ReadOnly or ReadWrite                                                                            | `ReadWriteOnce`                                         |
| `persistence.size`                    | Size of data volume                                                                                            | `8Gi`                                                   |
| `persistence.annotations`             | Persistent Volume annotations                                                                                  | `{}`                                                    |
| `sidecars`                            | Attach additional containers to the pods (scheduler, worker and server nodes)                                  | `[]`                                                    |
| `initContainers`                      | Attach additional init containers to the pods (scheduler, worker and server nodes)                             | `[]`                                                    |
| `extraVolumes`                        | Array to add extra volumes                                                                                     | `[]` (evaluated as a template)                          |
| `extraVolumeMounts`                   | Array to add extra mount                                                                                       | `[]` (evaluated as a template)                          |

### Mxnet Server parameters (only for distributed mode)

| Parameter                          | Description                                                                                            | Default                        |
|------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------|
| `server.replicaCount`              | Number of Server nodes that will execute your code                                                     | `1`                            |
| `server.extraEnvVars`              | Extra environment variables to add to the Server nodes                                                 | `[]`                           |
| `server.hostAliases`               | Add deployment host aliases                                                                            | `[]`                           |
| `server.podAffinityPreset`         | Mxnet Server pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `server.podAntiAffinityPreset`     | Mxnet Server pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `server.nodeAffinityPreset.type`   | Mxnet Server node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `server.nodeAffinityPreset.key`    | Mxnet Server node label key to match Ignored if `affinity` is set.                                     | `""`                           |
| `server.nodeAffinityPreset.values` | Mxnet Server node label values to match. Ignored if `affinity` is set.                                 | `[]`                           |
| `server.affinity`                  | Mxnet Server affinity for pod assignment                                                               | `{}` (evaluated as a template) |
| `server.nodeSelector`              | Mxnet Server node labels for pod assignment                                                            | `{}` (evaluated as a template) |
| `server.tolerations`               | Mxnet Server tolerations for pod assignment                                                            | `[]` (evaluated as a template) |
| `server.resources.limits`          | The resources limits for the Mxnet Server container                                                    | `{}`                           |
| `server.resources.requests`        | The requested resources for the Mxnet Server container                                                 | `{}`                           |

### Mxnet Worker parameters (only for distributed mode)

| Parameter                          | Description                                                                                            | Default                        |
|------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------|
| `worker.replicaCount`              | Number of Worker nodes that will execute your code                                                     | `1`                            |
| `worker.extraEnvVars`              | Extra environment variables to add to the Server nodes                                                 | `[]`                           |
| `worker.hostAliases`               | Add deployment host aliases                                                                            | `[]`                           |
| `worker.podAffinityPreset`         | Mxnet Worker pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `worker.podAntiAffinityPreset`     | Mxnet Worker pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `worker.nodeAffinityPreset.type`   | Mxnet Worker node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `worker.nodeAffinityPreset.key`    | Mxnet Worker node label key to match Ignored if `affinity` is set.                                     | `""`                           |
| `worker.nodeAffinityPreset.values` | Mxnet Worker node label values to match. Ignored if `affinity` is set.                                 | `[]`                           |
| `worker.affinity`                  | Mxnet Worker affinity for pod assignment                                                               | `{}` (evaluated as a template) |
| `worker.nodeSelector`              | Mxnet Worker node labels for pod assignment                                                            | `{}` (evaluated as a template) |
| `worker.tolerations`               | Mxnet Worker tolerations for pod assignment                                                            | `[]` (evaluated as a template) |
| `worker.resources.limits`          | The resources limits for the Mxnet Worker container                                                    | `{}`                           |
| `worker.resources.requests`        | The requested resources for the Mxnet Worker container                                                 | `{}`                           |

### Mxnet Scheduler parameters (only for distributed mode)

| Parameter                             | Description                                                                                               | Default                        |
|---------------------------------------|-----------------------------------------------------------------------------------------------------------|--------------------------------|
| `scheduler.replicaCount`              | Number of Scheduler nodes that will execute your code                                                     | `1`                            |
| `scheduler.extraEnvVars`              | Extra environment variables to add to the Server nodes                                                    | `[]`                           |
| `scheduler.hostAliases`               | Add deployment host aliases                                                                               | `[]`                           |
| `scheduler.podAffinityPreset`         | Mxnet Scheduler pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                           |
| `scheduler.podAntiAffinityPreset`     | Mxnet Scheduler pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                         |
| `scheduler.nodeAffinityPreset.type`   | Mxnet Scheduler node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                           |
| `scheduler.nodeAffinityPreset.key`    | Mxnet Scheduler node label key to match Ignored if `affinity` is set.                                     | `""`                           |
| `scheduler.nodeAffinityPreset.values` | Mxnet Scheduler node label values to match. Ignored if `affinity` is set.                                 | `[]`                           |
| `scheduler.affinity`                  | Mxnet Scheduler affinity for pod assignment                                                               | `{}` (evaluated as a template) |
| `scheduler.nodeSelector`              | Mxnet Scheduler node labels for pod assignment                                                            | `{}` (evaluated as a template) |
| `scheduler.tolerations`               | Mxnet Scheduler tolerations for pod assignment                                                            | `[]` (evaluated as a template) |
| `scheduler.resources.limits`          | The resources limits for the Mxnet Scheduler container                                                    | `{}`                           |
| `scheduler.resources.requests`        | The requested resources for the Mxnet Scheduler container                                                 | `{}`                           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set mode=distributed \
  --set server.replicaCount=2 \
  --set worker.replicaCount=3 \
    bitnami/mxnet
```

The above command creates 6 pods for Apache MXNet (Incubating): one scheduler, two servers, and three workers.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/mxnet
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Loading your files

The Apache MXNet (Incubating) chart supports three different ways to load your files. In order of priority, they are:

  1. Existing config map
  2. Files under the `files` directory
  3. Cloning a git repository

This means that if you specify a config map with your files, it won't look for the `files/` directory nor the git repository.

In order to use use an existing config map you can set the `configMap=my-config-map` parameter.

To load your files from the `files/` directory you don't have to set any option. Just copy your files inside and don't specify a `ConfigMap`.

Finally, if you want to clone a git repository you can use the following parameters:

```console
cloneFilesFromGit.enabled=true
cloneFilesFromGit.repository=https://github.com/my-user/my-repo
cloneFilesFromGit.revision=master
```

In case you want to add a file that includes sensitive information, pass a secret object using the `existingSecret` parameter. All the files in the secret will be mounted in the `/secrets` folder.

### Distributed training example

We will use the gluon example from the [Apache MXNet (Incubating) official repository](https://github.com/apache/incubator-mxnet/tree/master/example/gluon). Launch it with the following values:

```console
mode=distributed
cloneFilesFromGit.enabled=true
cloneFilesFromGit.repository=https://github.com/apache/incubator-mxnet.git
cloneFilesFromGit.revision=master
entrypoint.file=image_classification.py
entrypoint.args="--dataset cifar10 --model vgg11 --epochs 1 --kvstore dist_sync"
entrypoint.workDir=/app/example/gluon/
```

Check the logs of the worker node:

```console
INFO:root:Starting new image-classification task:, Namespace(batch_norm=False, batch_size=32, builtin_profiler=0, data_dir='', dataset='cifar10', dtype='float32', epochs=1, gpus='', kvstore='dist_sync', log_interval=50, lr=0.1, lr_factor=0.1, lr_steps='30,60,90', mode=None, model='vgg11', momentum=0.9, num_workers=4, prefix='', profile=False, resume='', save_frequency=10, seed=123, start_epoch=0, use_pretrained=False, use_thumbnail=False, wd=0.0001)
INFO:root:downloaded http://data.mxnet.io/mxnet/data/cifar10.zip into data/cifar10.zip successfully
[10:05:40] src/io/iter_image_recordio_2.cc:172: ImageRecordIOParser2: data/cifar/train.rec, use 1 threads for decoding..
[10:05:45] src/io/iter_image_recordio_2.cc:172: ImageRecordIOParser2: data/cifar/test.rec, use 1 threads for decoding..
```

If you want to increase the verbosity, set the environment variable `PS_VERBOSE=1` or `PS_VERBOSE=2` using the `commonEnvVars` value.

```console
mode=distributed
cloneFilesFromGit.enabled=true
cloneFilesFromGit.repository=https://github.com/apache/incubator-mxnet.git
cloneFilesFromGit.revision=master
entrypoint.file=image_classification.py
entrypoint.args="--dataset cifar10 --model vgg11 --epochs 1 --kvstore dist_sync"
entrypoint.workDir=/app/example/gluon/
commonExtraEnvVars[0].name=PS_VERBOSE
commonExtraEnvVars[0].value=1
```

You will now see log entries in the scheduler and server nodes.

```console
[14:22:44] src/van.cc:290: Bind to role=scheduler, id=1, ip=10.32.0.11, port=9092, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=9 to node role=worker, ip=10.32.0.17, port=55423, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=11 to node role=worker, ip=10.32.0.16, port=60779, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=13 to node role=worker, ip=10.32.0.15, port=39817, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=15 to node role=worker, ip=10.32.0.14, port=48119, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=8 to node role=server, ip=10.32.0.13, port=56713, is_recovery=0
[14:22:53] src/van.cc:56: assign rank=10 to node role=server, ip=10.32.0.12, port=57099, is_recovery=0
[14:22:53] src/van.cc:83: the scheduler is connected to 4 workers and 2 servers
[14:22:53] src/van.cc:183: Barrier count for 7 : 1
[14:22:53] src/van.cc:183: Barrier count for 7 : 2
[14:22:53] src/van.cc:183: Barrier count for 7 : 3
[14:22:53] src/van.cc:183: Barrier count for 7 : 4
...
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Apache MXNet (Incubating) (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

## Persistence

The [Bitnami Apache MXNet (Incubating)](https://github.com/bitnami/bitnami-docker-mxnet) image can persist data. If enabled, the persisted path is `/bitnami/mxnet` by default.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 2.1.0

Some parameters disappeared in favor of new ones:

- `schedulerExtraEnvVars` and `schedulerPort` -> deprecated in favor of `scheduler.extraEnvVars` and `scheduler.port`, respectively.
- `serverExtraEnvVars` and `serverCount` -> deprecated in favor of `server.extraEnvVars` and `server.replicaCount`, respectively.
- `workerExtraEnvVars` and `workerCount` -> deprecated in favor of `worker.extraEnvVars` and `worker.replicaCount`, respectively.

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

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
