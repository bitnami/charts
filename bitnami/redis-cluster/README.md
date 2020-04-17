
# Redis Cluster

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## TL;DR;

```bash
# Testing configuration
$ helm install my-release bitnami/redis-cluster
```

```bash
# Production configuration
$ helm install my-release bitnami/redis-cluster --values values-production.yaml
```

## Introduction

This chart bootstraps a [Redis](https://github.com/bitnami/bitnami-docker-redis) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

### Choose between Redis Helm Chart and Redis Cluster Helm Chart

You can choose any of the two Redis Helm charts for deploying a Redis cluster.
While [Redis Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/redis) will deploy a master-slave cluster using Redis Sentinel, the [Redis Cluster Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster) will deploy a Redis Cluster topology with sharding.
The main features of each chart are the following:
| Redis                                     | Redis Cluster                                               |
| ----------------------------------------- | ----------------------------------------------------------- |
| Supports multiple databases               | Supports only one database. Better if you have a big dataset |
| Single write point (single master)        | Multiple write points (multiple masters)                    |
| ![Redis Topology](img/redis-topology.png) | ![Redis Cluster Topology](img/redis-cluster-topology.png)   |


## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/redis-cluster
```

The command deploys Redis on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

NOTE: if you get a timeout error waiting for the hook to complete increase the default timeout (300s) to a higher one, for example:

```
helm install --timeout 600s myrelease bitnami/redis-cluster
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Redis chart and their default values.

#### Global parameters

| Parameter                                     | Description                                                                                                                                         | Default                                                 |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`                        | Global Docker image registry                                                                                                                        | `nil`                                                   |
| `global.imagePullSecrets`                     | Global Docker registry secret names as an array                                                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                         | Global storage class for dynamic provisioning                                                                                                       | `nil`                                                   |
| `global.redis.password`                       | Redis password (overrides `password`)                                                                                                               | `nil`                                                   |

#### Common parameters

| Parameter                                     | Description                                                                                                                                         | Default                                                 |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `image.registry`                              | Redis Image registry                                                                                                                                | `docker.io`                                             |
| `image.repository`                            | Redis Image name                                                                                                                                    | `bitnami/redis`                                         |
| `image.tag`                                   | Redis Image tag                                                                                                                                     | `{TAG_NAME}`                                            |
| `image.pullPolicy`                            | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |
| `nameOverride`                                | String to partially override redis.fullname template with a string (will prepend the release name)                                                  | `nil`                                                   |
| `fullnameOverride`                            | String to fully override redis.fullname template with a string                                                                                      | `nil`                                                   |
| `existingSecret`                              | Name of existing secret object (for password authentication)                                                                                        | `nil`                                                   |
| `existingSecretPasswordKey`                   | Name of key containing password to be retrieved from the existing secret                                                                            | `nil`                                                   |
| `usePassword`                                 | Use password                                                                                                                                        | `true`                                                  |
| `usePasswordFile`                             | Mount passwords as files instead of environment variables                                                                                           | `false`                                                 |
| `password`                                    | Redis password (ignored if existingSecret set)                                                                                                      |              Randomly generated                                      |
| `configmap`                                   | Additional common Redis node configuration (this value is evaluated as a template)                                                                  |                 See values.yaml                                         |
| `clusterDomain`                               | Kubernetes DNS Domain name to use                                                                                                                   | `cluster.local`                                         |
| `networkPolicy.enabled`                       | Enable NetworkPolicy                                                                                                                                | `false`                                                 |
| `networkPolicy.allowExternal`                 | Don't require client label for connections                                                                                                          | `true`                                                  |
| `networkPolicy.ingressNSMatchLabels`          | Allow connections from other namespaces                                                                                                             | `{}`                                                    |
| `networkPolicy.ingressNSPodMatchLabels`       | For other namespaces match by pod labels and namespace labels                                                                                       | `{}`                                                    |
| `podSecurityContext.enabled`                  | Enable pods' security context                                                                                                                            | `true`                                                  |
| `podSecurityContext.fsGroup`                  | Group ID for the pods.                                                                                                                         | `1001`                                                  |
| `podSecurityContext.runAsUser`                | User ID for the pods.                                                                                                                          | `1001`                                                  |
| `podSecurityContext.sysctls`                  | Set namespaced sysctls for the pods.                                                                                                           | `nil`                                                   |
| `containerSecurityContext.enabled`            | Enable container's security context                                                                                                                            | `true`                                                  |
| `containerSecurityContext.fsGroup`            | Group ID for the containers.                                                                                                                         | `1001`                                                  |
| `containerSecurityContext.runAsUser`          | User ID for the containers.                                                                                                                          | `1001`                                                  |
| `containerSecurityContext.sysctls`            | Set namespaced sysctls for the containers.                                                                                                           | `nil`                                                   |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                | `false`                                                 |
| `serviceAccount.name`                         | The name of the ServiceAccount to create                                                                                                            | Generated using the fullname template                                   |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                                                                  | `false`                                                 |
| `rbac.role.rules`                             | Rules to create                                                                                                                                     | `[]`                                                    |
| `persistence.enabled`                         | Use a PVC to persist data.                                                                                                                          | `true`                                                  |
| `persistence.path`                            | Path to mount the volume at, to use other images                                                                                                    | `/bitnami/redis/data`                                                 |
| `persistence.subPath`                         | Subdirectory of the volume to mount at                                                                                                              | `""`                                                    |
| `persistence.storageClass`                    | Storage class of backing PVC                                                                                                                        | `generic`                                               |
| `persistence.accessModes`                     | Persistent Volume Access Modes                                                                                                                      | `[ReadWriteOnce]`                                       |
| `persistence.size`                            | Size of data volume                                                                                                                                 | `8Gi`                                                   |
| `persistence.matchLabels`                     | matchLabels persistent volume selector                                                                                                              | `{}`                                                    |
| `persistence.matchExpressions`                | matchExpressions persistent volume selector                                                                                                         | `{}`                                                    |
| `statefulset.updateStrategy`                  | Update strategy for StatefulSet                                                                                                                     | onDelete                                                |
| `statefulset.rollingUpdatePartition`          | Partition update strategy                                                                                                                           | `nil`                                                   |
| `podLabels`                                   | Additional labels for Redis pod                                                                                                                     | {}                                                      |
| `podAnnotations`                              | Additional annotations for Redis pod                                                                                                                | {}                                                      |
| `redisPort`                                   | Redis port.                                                                                                                                         | `6379`                                                  |
| `command`                                     | Redis entrypoint string. The command `redis-server` is executed if this is not provided.                                                            | `nil`                                                   |
| `args`                                        | Arguments for the provided command if needed                                                                                                        |              `nil`                                                   |
| `configmap`                                   | Additional Redis configuration for the nodes (this value is evaluated as a template)                                                                | `nil`                                                   |
| `extraFlags`                                  | Redis additional command line flags                                                                                                                 | []                                                      |
| `nodeSelector`                                | Redis Node labels for pod assignment                                                                                                                | {"beta.kubernetes.io/arch": "amd64"}                    |
| `tolerations`                                 | Toleration labels for Redis pod assignment                                                                                                          | []                                                      |
| `affinity`                                    | Affinity settings for Redis pod assignment                                                                                                          | {}                                                      |
| `schedulerName`                               | Name of an alternate scheduler                                                                                                                      | `nil`                                                   |
| `service.port`                                | Kubernetes Service port.                                                                                                                            | `6379`                                                  |
| `service.annotations`                         | annotations for redis service                                                                                                                       | {}                                                      |
| `service.labels`                              | Additional labels for redis service                                                                                                                 | {}                                                      |
| `resources`                                   | Redis CPU/Memory resource requests/limits                                                                                                           | Memory: `256Mi`, CPU: `100m`                                             |
| `livenessProbe.enabled`                       | Turn on and off liveness probe.                                                                                                                     | `true`                                                  |
| `livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated.                                                                                                           | `30`                                                    |
| `livenessProbe.periodSeconds`                 | How often to perform the probe.                                                                                                                     | `30`                                                    |
| `livenessProbe.timeoutSeconds`                | When the probe times out.                                                                                                                           | `5`                                                     |
| `livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed.                                                        | `1`                                                     |
| `livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                          | `5`                                                     |
| `readinessProbe.enabled`                      | Turn on and off readiness probe.                                                                                                                    | `true`                                                  |
| `readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated.                                                                                                          | `5`                                                     |
| `readinessProbe.periodSeconds`                | How often to perform the probe.                                                                                                                     | `10`                                                    |
| `readinessProbe.timeoutSeconds`               | When the probe times out.                                                                                                                           | `1`                                                     |
| `readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed.                                                        | `1`                                                     |
| `readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                          | `5`                                                     |
| `priorityClassName`                           | Redis Master pod priorityClassName                                                                                                                  | {}                                                      |
| `volumePermissions.enabled`                   | Enable init container that changes volume permissions in the registry (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                                                    | `docker.io`                                             |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                                                        | `bitnami/minideb`                                                |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                                                         | `buster`                                                |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                                                 | `Always`                                                |
| `volumePermissions.resources`                 | Init container volume-permissions CPU/Memory resource requests/limits                                                                               | {}                                                      |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                                                    | `[]` (does not add image pull secrets to deployed pods)                |
| `extraVolumes`                                | Array of extra volumes to be added to all pods (evaluated as a template). Requires setting `extraVolumeMounts`                                      | `[]`                                                    |
| `extraVolumeMounts`                           | Array of extra volume mounts to be added to all pods (evaluated as a template). Normally used with `extraVolumes`                                   | `[]`                                                    |
| `extraEnvVars`                                | Array containing extra env vars to be added to all pods (evaluated as a template)                                                                   | `[]`                                                    |
| `extraEnvVarsConfigMap`                       | ConfigMap containing extra env vars to be added to all pods (evaluated as a template)                                                               | `nil`                                                   |
| `extraEnvVarsSecret`                          | Secret containing extra env vars to be added to all pods (evaluated as a template)                                                                  | `nil`                                                   |
| `extraInitContainers`                         | Init containers to add to the cronjob container                                                                                                     | {}                                                      |
| `podSecurityPolicy.create`                    | Specifies whether a PodSecurityPolicy should be created                                                                                             | `false`                                                 |
| `sidecars`                                    | Attach additional containers to the pod (evaluated as a template)                                                                                   | `nil`   

#### Redis cluster parameters

| Parameter                                     | Description                                                                                                                                         | Default                                                 |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `cluster.init`                                | Enable the creation of a job that initializes the Redis Cluster                                                                                     | `true`                                                  |
| `cluster.activeDeadlineSeconds`               | Number of seconds that the job to create the cluster will be waiting for the nodes to be ready                                                      | `600`                                                   |
| `cluster.nodes`                               | Number of nodes in the Redis cluster                                                                                                                | `6`                                                     |
| `cluster.replicas`                            | Number of replicas for every master in the cluster                                                                                                  | `1`                                                     |
| `cluster.busPort`                             | Port for the Redis gossip protocol                                                                                                                  | `16379`                                                 |
| `cluster.externalAccess.enabled`              | Enable access to the Redis cluster from Outside the Kubernetes Cluster                                                                              | `false`                                                 |
| `cluster.externalAccess.service.type`         | Type for the services used to expose every Pod                                                                                                      | `LoadBalancer`                                          |
| `cluster.externalAccess.service.port`         | Port for the services used to expose every Pod                                                                                                      | `6379`                                                  |
| `cluster.externalAccess.service.loadBalancerIP` | Array of LoadBalancer IPs used to expose every Pod of the Redis cluster when `cluster.externalAccess.service.type` is `LoadBalancer`              | `[]`                                                    |
| `cluster.externalAccess.service.annotations`  | Annotations to add to the services used to expose every Pod of the Redis Cluster                                                                    | `{}`                                                    |
| `cluster.update.addNodes`                     | Boolean to specify if you want to add nodes after the upgrade                                                                                       | `false`                                                 |
| `cluster.update.currentNumberOfNodes`         | Number of currently deployed Redis  nodes                                                                                                           | `6`                                                     |
| `cluster.update.newExternalIPs`               | External IPs obtained from the services for the new nodes to add to the cluster                                                                     |                `nil`                                                   |

#### Metrics sidecar parameters

| Parameter                                     | Description                                                                                                                                         | Default                                                 |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `metrics.enabled`                             | Start a side-car prometheus exporter                                                                                                                | `false`                                                 |
| `metrics.image.registry`                      | Redis exporter image registry                                                                                                                       | `docker.io`                                             |
| `metrics.image.repository`                    | Redis exporter image name                                                                                                                           | `bitnami/redis-exporter`                                               |
| `metrics.image.tag`                           | Redis exporter image tag                                                                                                                            | `{TAG_NAME}`                                            |
| `metrics.image.pullPolicy`                    | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |
| `metrics.extraArgs`                           | Extra arguments for the binary; possible values [here](https://github.com/oliver006/redis_exporter#flags)                                           | {}                                                      |
| `metrics.podLabels`                           | Additional labels for Metrics exporter pod                                                                                                          | {}                                                      |
| `metrics.podAnnotations`                      | Additional annotations for Metrics exporter pod                                                                                                     | {}                                                      |
| `metrics.resources`                           | Exporter resource requests/limit                                                                                                                    | Memory: `256Mi`, CPU: `100m`                                             |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                              | `false`                                                 |
| `metrics.serviceMonitor.namespace`            | Optional namespace which Prometheus is running in                                                                                                   | `nil`                                                   |
| `metrics.serviceMonitor.interval`             | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                                              | `nil`                                                   |
| `metrics.serviceMonitor.selector`             | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                          | `{ prometheus: kube-prometheus }`                                      |
| `metrics.service.type`                        | Kubernetes Service type (redis metrics)                                                                                                             | `ClusterIP`                                             |
| `metrics.service.annotations`                 | Annotations for the services to monitor.                                                                                                            | {}                                                      |
| `metrics.service.labels`                      | Additional labels for the metrics service                                                                                                           | {}                                                      |
| `metrics.service.loadBalancerIP`              | loadBalancerIP if redis metrics service type is `LoadBalancer`                                                                                      | `nil`                                                   |
| `metrics.priorityClassName`                   | Metrics exporter pod priorityClassName                                                                                                              | {}                                                      |
| `metrics.prometheusRule.enabled`              | Set this to true to create prometheusRules for Prometheus operator                                                                                  | `false`                                                 |
| `metrics.prometheusRule.additionalLabels`     | Additional labels that can be used so prometheusRules will be discovered by Prometheus                                                              | `{}`                                                    |
| `metrics.prometheusRule.namespace`            | namespace where prometheusRules resource should be created                                                                                          | Same namespace as redis                                                   |
| `metrics.prometheusRule.rules`                | [rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) to be created, check values for an example.                     | `[]`                                                    |
                                                |

#### Sysctl Image parameters

| Parameter                                     | Description                                                                                                                                         | Default                                                 |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `sysctlImage.enabled`                         | Enable an init container to modify Kernel settings                                                                                                  | `false`                                                 |
| `sysctlImage.command`                         | sysctlImage command to execute                                                                                                                      | []                                                      |
| `sysctlImage.registry`                        | sysctlImage Init container registry                                                                                                                 | `docker.io`                                             |
| `sysctlImage.repository`                      | sysctlImage Init container name                                                                                                                     | `bitnami/minideb`                                                |
| `sysctlImage.tag`                             | sysctlImage Init container tag                                                                                                                      | `buster`                                                |
| `sysctlImage.pullPolicy`                      | sysctlImage Init container pull policy                                                                                                              | `Always`                                                |
| `sysctlImage.mountHostSys`                    | Mount the host `/sys` folder to `/host-sys`                                                                                                         | `false`                                                 |
| `sysctlImage.resources`                       | sysctlImage Init container CPU/Memory resource requests/limits                                                                                      | {}                                                      |
| `sysctlImage.pullSecrets`                     | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set password=secretpassword \
    bitnami/redis-cluster
```

The above command sets the Redis server password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/redis-cluster
```

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Note for minikube users**: Current versions of minikube (v0.24.1 at the time of writing) provision `hostPath` persistent volumes that are only writable by root. Using chart defaults cause pod failure for the Redis pod as it attempts to write to the `/bitnami` directory. Consider installing Redis with `--set persistence.enabled=false`. See minikube issue [1990](https://github.com/kubernetes/minikube/issues/1990) for more information.

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Enable NetworkPolicy:
```diff
- networkPolicy.enabled: false
+ networkPolicy.enabled: true
```

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### Cluster topology

The Helm Chart will deploy by default 3 redis masters and 3 replicas. By default the Redis Cluster is not accessible from outside the Kubernetes cluster, to the Redis cluster to the outside set `cluster.externalAccess.enabled=true`, it will create in the first installation only 6 LoadBalancer services, one for each Redis node, once you have the external IPs of each service you will need to perform an upgrade passing those IPs to the `cluster.externalAccess.service.loadbalancerIP` array.

The replicas will be read-only replicas of the masters. By default only one service is exposed (when not using the external access mode). You will connect your client to the exposed service, regardless you need to read or write. When a write operation arrives to a replica it will redirect the client to the master node. For example, using `redis-cli` you will need to provide the `-c` flag for `redis-cli` to follow the redirection automatically.

Using the external access mode, you can connect to any of the pods and the slaves will redirect the client in the same way as explained before, but the all the IPs will be public.

In case the master crashes, one of the slaves will be promoted to master. The slots stored by the crashed master will be unavailable until the slave finish the promotion. If a master and all his slaves crash, the cluster will be down until one of them is up again. To avoid downtime, it is possible to configure the number of Redis nodes with `cluster.nodes` and the number of replicas that will be assigned to each master with `cluster.replicas`. For example:
  - `cluster.nodes=9` ( 3 master plus 2 replicas for each master)
  - `cluster.replicas=2`

Providing the values above, the cluster will have 3 masters and, each master, will have 2 replicas.

> NOTE: By default `cluster.init` will be set to `true` in order to initialize the Redis Cluster in the first installation. If for testing purpose you only want to deploy or upgrade the nodes but avoiding the creation of the cluster you can set `cluster.init` to `false`.

#### Adding a new node to the cluster

There is a job that will be executed using a `post-upgrade` hook that will allow you to add a new node. To use it, you should provide some parameters to the upgrade:

- Pass as `password` the password used in the installation time. If you did not provide a password follow the intructions from the NOTES.txt to get the generated password.
- Set the desired number of nodes at `cluster.nodes`.
- Set the number of current nodes at `cluster.update.currentNumberOfNodes`.
- Set to true `cluster.update.addNodes`.

The following will be an example to add one more node:

```
helm upgrade --timeout 600s <release> --set "password=${REDIS_PASSWORD},cluster.nodes=7,cluster.update.addNodes=true,cluster.update.currentNumberOfNodes=6" bitnami/redis-cluster
```

Where `REDIS_PASSWORD` is the password obtained with the command that appears after the first installation of the Helm Chart.
The cluster will continue up while restarting pods one by one as the quorum is not lost.

##### External Access

If you are using external access, to add a new node you will need to perform two upgrades. First upgrade the release to add a new Redis node and to get a LoadBalancerIP service. For example:

```
helm upgrade <release> --set "password=${REDIS_PASSWORD},cluster.externalAccess.enabled=true,cluster.externalAccess.service.type=LoadBalancer,cluster.externalAccess.service.loadBalancerIP[0]=<loadBalancerip-0>,cluster.externalAccess.service.loadBalancerIP[1]=<loadbalanacerip-1>,cluster.externalAccess.service.loadBalancerIP[2]=<loadbalancerip-2>,cluster.externalAccess.service.loadBalancerIP[3]=<loadbalancerip-3>,cluster.externalAccess.service.loadBalancerIP[4]=<loadbalancerip-4>,cluster.externalAccess.service.loadBalancerIP[5]=<loadbalancerip-5>,cluster.externalAccess.service.loadBalancerIP[6]=,cluster.nodes=7,cluster.init=false bitnami/redis-cluster
```

> Important here to provide the loadBalancerIP parameters for the new nodes empty to not get an index error.

As we want to add a new node, we are setting `cluster.nodes=7` and we leave empty the LoadBalancerIP for the new node, so the cluster will provide the correct one.
`REDIS_PASSWORD` is the password obtained with the command that appears after the first installation of the Helm Chart.
At this point, you will have a new Redis Pod that will remain in `crashLoopBackOff` state until we provide the LoadBalancerIP for the new service.
Now, wait until the cluster provides the new LoadBalancerIP for the new service and perform the second upgrade:

```
helm upgrade <release> --set "password=${REDIS_PASSWORD},cluster.externalAccess.enabled=true,cluster.externalAccess.service.type=LoadBalancer,cluster.externalAccess.service.loadBalancerIP[0]=<loadbalancerip-0>,cluster.externalAccess.service.loadBalancerIP[1]=<loadbalancerip-1>,cluster.externalAccess.service.loadBalancerIP[2]=<loadbalancerip-2>,cluster.externalAccess.service.loadBalancerIP[3]=<loadbalancerip-3>,cluster.externalAccess.service.loadBalancerIP[4]=<loadbalancerip-4>,cluster.externalAccess.service.loadBalancerIP[5]=<loadbalancerip-5>,cluster.externalAccess.service.loadBalancerIP[6]=<loadbalancerip-6>,cluster.nodes=7,cluster.init=false,cluster.update.addNodes=true,cluster.update.newExternalIPs[0]=<load-balancerip-6>" bitnami/redis-cluster
```

Note we are providing the new IPs at `cluster.update.newExternalIPs`, the flag `cluster.update.addNodes=true` to enable the creation of the Job that adds a new node and now we are setting the LoadBalancerIP of the new service instead of leave it empty.

> NOTE: To avoid the creation of the Job that initializes the Redis Cluster again, you will need to provide `cluster.init=false`.

#### Scale down the cluster

To scale down the redis cluster just perform a normal upgrade setting the `cluster.nodes` value to the desired number of nodes. It should not be less than `6`. Also it is needed to provide the password using the `password`. For example, having more than 6 nodes, to scale down the cluster to 6 nodes:

```
helm upgrade --timeout 600s <release> --set "password=${REDIS_PASSWORD},cluster.nodes=6" .
```

The cluster will continue working during the update as long as the quorum is not lost.

> NOTE: To avoid the creation of the Job that initializes the Redis Cluster again, you will need to provide `cluster.init=false`.

### Using password file
To use a password file for Redis you need to create a secret containing the password.

> *NOTE*: It is important that the file with the password must be called `redis-password`

And then deploy the Helm Chart using the secret name as parameter:

```console
usePassword=true
usePasswordFile=true
existingSecret=redis-password-secret
metrics.enabled=true
```

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Redis (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: REDIS_WHATEVER
    value: value
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9121) is exposed in the service. Metrics can be scraped from within the cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml). If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.

### Host Kernel Settings
Redis may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages.
To do so, you can set up a privileged initContainer with the `sysctlImage` config values, for example:
```
sysctlImage:
  enabled: true
  mountHostSys: true
  command:
    - /bin/sh
    - -c
    - |-
      install_packages procps
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```

Alternatively, for Kubernetes 1.12+ you can set `podSecurityContext.sysctls` which will configure sysctls for master and slave pods. Example:

```yaml
podSecurityContext:
  sysctls:
  - name: net.core.somaxconn
    value: "10000"
```

Note that this will not disable transparent huge tables.

## Helm Upgrade

 By default `cluster.init` will be set to `true` in order to initialize the Redis Cluster in the first installation. If for testing purpose you only want to deploy or upgrade the nodes but avoiding the creation of the cluster you can set `cluster.init` to `false`.

## Persistence

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at the `/bitnami` path. The volume is created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

## NetworkPolicy

To enable network policy for Redis, install
[a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin),
and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

With NetworkPolicy enabled, only pods with the generated client label will be
able to connect to Redis. This label will be displayed in the output
after a successful install.

With `networkPolicy.ingressNSMatchLabels` pods from other namespaces can connect to redis. Set `networkPolicy.ingressNSPodMatchLabels` to match pod labels in matched namespace. For example, for a namespace labeled `redis=external` and pods in that namespace labeled `redis-client=true` the fields should be set:

```
networkPolicy:
  enabled: true
  ingressNSMatchLabels:
    redis: external
  ingressNSPodMatchLabels:
    redis-client: true
```

## Notable changes

### 2.0.0

The version `1.0.0` was using a label in the Statefulset's volumeClaimTemplate that didn't allow to upgrade the chart. The version `2.0.0` fixed that issue. Also it adds more docs in the README.md.
