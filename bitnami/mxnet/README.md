# MXNet

[MXNet](https://mxnet.apache.org/) is a deep learning platform that accelerates the transition from research prototyping to production deployment. It is built for full integration into Python that enables you to use it with its libraries and main packages.

## TL;DR;

```console
$ helm install bitnami/mxnet
```

## Introduction

This chart bootstraps a [MXNet](https://github.com/bitnami/bitnami-docker-mxnet) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/mxnet
```

The command deploys MXNet on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured.

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
|--------------------------------------|----------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`               | Global Docker image registry                                                                 | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                              | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                     | MXNet image registry                                                                         | `docker.io`                                             |
| `image.repository`                   | MXNet image name                                                                             | `bitnami/MXNet`                                         |
| `image.tag`                          | MXNet image tag                                                                              | `{TAG_NAME}`                                            |
| `image.pullPolicy`                   | Image pull policy                                                                            | `IfNotPresent`                                          |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                        | Specify if debug logs should be enabled                                                      | `false`                                                 |
| `git.registry`                       | Git image registry                                                                           | `docker.io`                                             |
| `git.repository`                     | Git image name                                                                               | `bitnami/git`                                           |
| `git.tag`                            | Git image tag                                                                                | `{TAG_NAME}`                                            |
| `git.pullPolicy`                     | Git image pull policy                                                                        | `IfNotPresent`                                          |
| `git.pullSecrets`                    | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods) |
| `service.type`                       | Kubernetes service type                                                                      | `ClusterIP`                                             |
| `entrypoint.file`                    | Main entrypoint to your application. If not speficied, it will be a `sleep infinity` command | `''`                                                    |
| `entrypoint.args`                    | Args required by your entrypoint                                                             | `nil`                                                   |
| `entrypoint.workDir`                 | Working directory for launching the entrypoint                                               | `'/app'`                                                |
| `podManagementPolicy`                | StatefulSet (worker and server nodes) pod management policy                                  | `Parallel`                                              |
| `mode`                               | Run MXNet in standalone or distributed mode (possible values: `standalone`, `distributed`)   | `standalone`                                            |
| `serverCount`                        | Number of server nodes that will execute your code                                           | `1`                                                     |
| `workerCount`                        | Number of worker nodes that will execute your code                                           | `1`                                                     |
| `schedulerPort`                      | MXNet scheduler port (only for distributed mode)                                             | `49875`                                                 |
| `configMap`                          | Config map that contains the files you want to load in MXNet                                 | `nil`                                                   |
| `cloneFilesFromGit.enabled`          | Enable in order to download files from git repository                                        | `false`                                                 |
| `cloneFilesFromGit.repository`       | Repository that holds the files                                                              | `nil`                                                   |
| `cloneFilesFromGit.revision`         | Revision from the repository to checkout                                                     | `master`                                                |
| `commonExtraEnvVars`                 | Extra environment variables to add to server, scheduler and worker nodes                     | `nil`                                                   |
| `workerExtraEnvVars`                 | Extra environment variables to add to the worker nodes                                       | `nil`                                                   |
| `serverExtraEnvVars`                 | Extra environment variables to add to the server nodes                                       | `nil`                                                   |
| `schedulerExtraEnvVars`              | Extra environment variables to add to the scheduler node                                     | `nil`                                                   |
| `sidecars`                           | Attach additional containers to the pods (scheduler, worker and server nodes)                | `nil`                                                   |
| `initContainers`                     | Attach additional init containers to the pods (scheduler, worker and server nodes)           | `nil`                                                   |
| `existingSecret`                     | Name of a secret with sensitive data to mount in the pods                                    | `nil`                                                   |
| `nodeSelector`                       | Node labels for pod assignment (this value is evaluated as a template)                       | `{}`                                                    |
| `tolerations`                        | Toleration labels for pod assignment (this value is evaluated as a template)                 | `[]`                                                    |
| `affinity`                           | Map of node/pod affinities (this value is evaluated as a template)                           | `{}`                                                    |
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
| `persistence.enabled`                | Use a PVC to persist data                                                                    | `false`                                                 |
| `persistence.mountPath`              | Path to mount the volume at                                                                  | `/bitnami/mxnet`                                        |
| `persistence.storageClass`           | Storage class of backing PVC                                                                 | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`             | Use volume as ReadOnly or ReadWrite                                                          | `ReadWriteOnce`                                         |
| `persistence.size`                   | Size of data volume                                                                          | `8Gi`                                                   |
| `persistence.annotations`            | Persistent Volume annotations                                                                | `{}`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set mode=distributed \
  --set serverCount=2 \
  --set workerCount=3 \
    bitnami/mxnet
```

The above command creates 6 pods for MXNet: one scheduler, two servers, and three workers.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/mxnet
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml bitnami/mxnet
```

- Run MXNet in distributed mode:
```diff
- mode: standalone
+ mode: distributed
```

- Number of server nodes that will execute your code:
```diff
- serverCount: 1
+ serverCount: 2
```

- Number of worker nodes that will execute your code:
```diff
- workerCount: 1
+ workerCount: 4
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Loading your files

The MXNet chart supports three different ways to load your files. In order of priority, they are:

  1. Existing config map
  2. Files under the `files` directory
  3. Cloning a git repository

This means that if you specify a config map with your files, it won't look for the `files/` directory nor the git repository.

In order to use use an existing config map:

```console
$ helm install --name my-release \
  --set configMap=my-config-map \
  bitnami/mxnet
```

To load your files from the `files/` directory you don't have to set any option. Just copy your files inside and don't specify a `ConfigMap`:

```console
$ helm install --name my-release \
  bitnami/mxnet
```

Finally, if you want to clone a git repository:

```console
$ helm install --name my-release \
  --set cloneFilesFromGit.enabled=true \
  --set cloneFilesFromGit.repository=https://github.com/my-user/my-repo \
  --set cloneFilesFromGit.revision=master \
  bitnami/mxnet
```

In case you want to add a file that includes sensitive information, pass a secret object using the `existingSecret` parameter. All the files in the secret will be mounted in the `/secrets` folder. 

### Distributed training example

We will use the gluon example from the [MXNet official repository](https://github.com/apache/incubator-mxnet/tree/master/example/gluon). Launch it with the following command:

```console
$ helm install --name my-release \
  --set mode=distributed \
  --set cloneFilesFromGit.enabled=true \
  --set cloneFilesFromGit.repository=https://github.com/apache/incubator-mxnet.git \
  --set cloneFilesFromGit.revision=master \
  --set entrypoint.file=image_classification.py \
  --set entrypoint.args="--dataset cifar10 --model vgg11 --epochs 1 --kvstore dist_sync" \
  --set entrypoint.workDir=/app/example/gluon/ \
  bitnami/mxnet
```

Check the logs of the worker node:

```console
$ kubectl logs my-release-mxnet-worker-0 -f

INFO:root:Starting new image-classification task:, Namespace(batch_norm=False, batch_size=32, builtin_profiler=0, data_dir='', dataset='cifar10', dtype='float32', epochs=1, gpus='', kvstore='dist_sync', log_interval=50, lr=0.1, lr_factor=0.1, lr_steps='30,60,90', mode=None, model='vgg11', momentum=0.9, num_workers=4, prefix='', profile=False, resume='', save_frequency=10, seed=123, start_epoch=0, use_pretrained=False, use_thumbnail=False, wd=0.0001)
INFO:root:downloaded http://data.mxnet.io/mxnet/data/cifar10.zip into data/cifar10.zip successfully
[10:05:40] src/io/iter_image_recordio_2.cc:172: ImageRecordIOParser2: data/cifar/train.rec, use 1 threads for decoding..
[10:05:45] src/io/iter_image_recordio_2.cc:172: ImageRecordIOParser2: data/cifar/test.rec, use 1 threads for decoding..
```

If you want to increase the verbosity, set the environment variable `PS_VERBOSE=1` or `PS_VERBOSE=2` using the `commonEnvVars` value.

```console
$ helm install --name my-release \
  --set mode=distributed \
  --set cloneFilesFromGit.enabled=true \
  --set cloneFilesFromGit.repository=https://github.com/apache/incubator-mxnet.git \
  --set cloneFilesFromGit.revision=master \
  --set entrypoint.file=image_classification.py \
  --set entrypoint.args="--dataset cifar10 --model vgg11 --epochs 1 --kvstore dist_sync" \
  --set entrypoint.workDir=/app/example/gluon/ \
  --set commonExtraEnvVars[0].name=PS_VERBOSE \
  --set commonExtraEnvVars[0].value=1 \
  bitnami/mxnet
```

You will now see log entries in the scheduler and server nodes.

```console
$ kubectl logs my-release-mxnet-server-0
[14:22:53] src/van.cc:290: Bind to role=server, ip=10.32.0.12, port=57099, is_recovery=0
[14:22:53] src/van.cc:238: S[10] is connected to others

$ kubectl logs my-release-mxnet-scheduler-67dbd4bb7c-px2wf
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

## Persistence

The [Bitnami MXNet](https://github.com/bitnami/bitnami-docker-mxnet) image can persist data. If enabled, the persisted path is `/bitnami/mxnet` by default.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

## Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as MXNet (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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
