# Memcached

> [Memcached](https://memcached.org/) is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/memcached
```

## Introduction

This chart bootstraps a [Memcached](https://github.com/bitnami/bitnami-docker-memcached) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/memcached
```

These commands deploy Memcached on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following tables lists the configurable parameters of the Memcached chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |

### Common parameters

| Parameter           | Description                                                          | Default                        |
|---------------------|----------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname                   | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname                       | `nil`                          |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`                           |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |

### Memcached parameters

| Parameter                                      | Description                                                                                    | Default                                                      |
|------------------------------------------------|------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `image.registry`                               | Memcached image registry                                                                       | `docker.io`                                                  |
| `image.repository`                             | Memcached Image name                                                                           | `bitnami/memcached`                                          |
| `image.tag`                                    | Memcached Image tag                                                                            | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                             | Memcached image pull policy                                                                    | `IfNotPresent`                                               |
| `image.pullSecrets`                            | Specify docker-registry secret names as an array                                               | `[]` (does not add image pull secrets to deployed pods)      |
| `architecture`                                 | Memcached architecture. Allowed values: standalone or high-availability                        | `standalone`                                                 |
| `replicaCount`                                 | Number of containers                                                                           | `1`                                                          |
| `command`                                      | Default container command (useful when using custom images)                                    | `[]`                                                         |
| `arguments`                                    | Default container args (useful when using custom images)                                       | `["/run.sh"]`                                                |
| `extraEnv`                                     | Additional env vars to pass                                                                    | `{}`                                                         |
| `hostAliases`                                  | Add deployment host aliases                                                                    | `[]`                                                         |
| `memcachedUsername`                            | Memcached admin user                                                                           | `nil`                                                        |
| `memcachedPassword`                            | Memcached admin password                                                                       | `nil`                                                        |
| `podDisruptionBudget.create`                   | Whether to create a pod disruption budget                                                      | `false`                                                      |
| `podDisruptionBudget.minAvailable`             | Minimum number of pods that need to be available                                               | `nil`                                                        |
| `podDisruptionBudget.maxUnavailable`           | Maximum number of pods that can be unavailable                                                 | `1`                                                          |
| `service.type`                                 | Kubernetes service type for Memcached                                                          | `ClusterIP`                                                  |
| `service.port`                                 | Memcached service port                                                                         | `11211`                                                      |
| `service.nodePort`                             | Kubernetes Service nodePort                                                                    | `nil`                                                        |
| `service.loadBalancerIP`                       | `loadBalancerIP` if service type is `LoadBalancer`                                             | `nil`                                                        |
| `service.annotations`                          | Additional annotations for Memcached service                                                   | `{}`                                                         |
| `resources.requests`                           | CPU/Memory resource requests                                                                   | `{memory: "256Mi", cpu: "250m"}`                             |
| `resources.limits`                             | CPU/Memory resource limits                                                                     | `{}`                                                         |
| `portName`                                     | Name of the main port exposed by memcached                                                     | `memcache`                                                   |
| `persistence.enabled`                          | Enable persistence using PVC (Requires architecture: "high-availability")                      | `true`                                                       |
| `persistence.storageClass`                     | PVC Storage Class for Memcached volume                                                         | `nil` (uses alpha storage class annotation)                  |
| `persistence.accessMode`                       | PVC Access Mode for Memcached volume                                                           | `ReadWriteOnce`                                              |
| `persistence.size`                             | PVC Storage Request for Memcached volume                                                       | `8Gi`                                                        |
| `securityContext.enabled`                      | Enable security context                                                                        | `true`                                                       |
| `securityContext.fsGroup`                      | Group ID for the container                                                                     | `1001`                                                       |
| `securityContext.runAsUser`                    | User ID for the container                                                                      | `1001`                                                       |
| `securityContext.readOnlyRootFilesystem`       | Enable read-only filesystem                                                                    | `false`                                                      |
| `podAnnotations`                               | Pod annotations                                                                                | `{}`                                                         |
| `podAffinityPreset`                            | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`            | `""`                                                         |
| `podAntiAffinityPreset`                        | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `soft`                                                       |
| `podLabels`                                    | Add additional labels to the pod (evaluated as a template)                                     | `nil`                                                        |
| `nodeAffinityPreset.type`                      | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`      | `""`                                                         |
| `nodeAffinityPreset.key`                       | Node label key to match. Ignored if `affinity` is set.                                         | `""`                                                         |
| `nodeAffinityPreset.values`                    | Node label values to match. Ignored if `affinity` is set.                                      | `[]`                                                         |
| `affinity`                                     | Affinity for pod assignment                                                                    | `{}` (evaluated as a template)                               |
| `nodeSelector`                                 | Node labels for pod assignment                                                                 | `{}` (evaluated as a template)                               |
| `tolerations`                                  | Tolerations for pod assignment                                                                 | `[]` (evaluated as a template)                               |
| `topologySpreadConstraints`                    | Topology Spread Constraints for pod assignment                                                 | `{}` (evaluated as a template)                               |
| `priorityClassName`                            | Controller priorityClassName                                                                   | `nil`                                                        |
| `initContainers`                               | Add additional init containers to the Memcached pod                                            | `{}` (evaluated as a template)                               |
| `sidecars`                                     | Add additional sidecar containers to the Memcached pod                                         | `{}` (evaluated as a template)                               |
| `serviceAccount.create`                        | Enable creation of ServiceAccount for memcached pods                                           | `true`                                                       |
| `serviceAccount.name`                          | The name of the service account to use. If not set and `create` is `true`, a name is generated | Generated using the `memcached.serviceAccountName` template  |
| `serviceAccount.automountServiceAccountToken`  | Enable/disable auto mounting of the service account token                                      | `true`                                                       |
| `metrics.enabled`                              | Start a side-car prometheus exporter                                                           | `false`                                                      |
| `metrics.image.registry`                       | Memcached exporter image registry                                                              | `docker.io`                                                  |
| `metrics.image.repository`                     | Memcached exporter image name                                                                  | `bitnami/memcached-exporter`                                 |
| `metrics.image.tag`                            | Memcached exporter image tag                                                                   | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                     | Image pull policy                                                                              | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`                    | Specify docker-registry secret names as an array                                               | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`                       | Additional annotations for Metrics exporter                                                    | `{prometheus.io/scrape: "true", prometheus.io/port: "9150"}` |
| `metrics.resources`                            | Exporter resource requests/limit                                                               | `{}`                                                         |
| `metrics.portName`                             | Memcached exporter port name                                                                   | `metrics`                                                    |
| `metrics.service.type`                         | Kubernetes service type for Prometheus metrics                                                 | `ClusterIP`                                                  |
| `metrics.service.port`                         | Prometheus metrics service port                                                                | `9150`                                                       |
| `metrics.service.annotations`                  | Prometheus exporter svc annotations                                                            | `{prometheus.io/scrape: "true", prometheus.io/port: "9150"}` |
| `metrics.serviceMonitor.enabled`               | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator                | `false`                                                      |
| `metrics.serviceMonitor.namespace`             | The namespace in which the ServiceMonitor will be created                                      | `nil`                                                        |
| `metrics.serviceMonitor.interval`              | The interval at which metrics should be scraped                                                | `nil`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`         | The timeout after which the scrape is ended                                                    | `nil`                                                        |
| `metrics.serviceMonitor.selector`              | Additional labels for ServiceMonitor resource                                                  | `nil`                                                        |
| `metrics.serviceMonitor.metricRelabelings`     | Metrics relabelings to add to the scrape endpoint, applied before ingestion                    | `nil`                                                        |
| `metrics.serviceMonitor.relabelings`           | Metrics relabelings to add to the scrape endpoint, applied before scraping                     | `nil`                                                        |
| `volumePermissions.image.registry`             | Init container volume-permissions image registry                                               | `docker.io`                                                  |
| `volumePermissions.image.repository`           | Init container volume-permissions image name                                                   | `bitnami/bitnami-shell`                                      |
| `volumePermissions.image.tag`                  | Init container volume-permissions image tag                                                    | `"10"`                                                       |
| `volumePermissions.image.pullPolicy`           | Init container volume-permissions image pull policy                                            | `Always`                                                     |
| `volumePermissions.image.pullSecrets`          | Specify docker-registry secret names as an array                                               | `[]` (does not add image pull secrets to deployed pods)      |
| `volumePermissions.resources.limits`           | Init container volume-permissions resource  limits                                             | `{}`                                                         |
| `volumePermissions.resources.requests`         | Init container volume-permissions resource  requests                                           | `{}`                                                         |

The above parameters map to the environment variables defined in the [bitnami/memcached](http://github.com/bitnami/bitnami-docker-memcached) container image. For more information please refer to the [bitnami/memcached](http://github.com/bitnami/bitnami-docker-memcached) container image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release --set memcachedUsername=user,memcachedPassword=password bitnami/memcached
```

The above command sets the Memcached admin account username and password to `user` and `password` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/memcached
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/memcached/configuration/configure-sidecar-init-containers/).

### Set Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter(s). Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

When using `architecture: "high-availability"` the [Bitnami Memcached](https://github.com/bitnami/bitnami-docker-memcached) image stores the cache-state at the `/cache-state` path of the container if enabled.

Persistent Volume Claims (PVCs) are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Notable changes

### 4.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 4.0.0. The following example assumes that the release name is memcached:

```console
$ kubectl delete deployment  memcached --cascade=false
$ helm upgrade memcached bitnami/memcached
```

### 3.0.0

This release uses the new bash based `bitnami/memcached` container which uses bash scripts for the start up logic of the container and is smaller in size.

## Upgrading

### To 5.3.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 5.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/infrastructure/memcached/administration/upgrade-helm3/).

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is memcached:

```console
$ kubectl patch deployment memcached --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
