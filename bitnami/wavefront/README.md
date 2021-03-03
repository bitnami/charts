# Wavefront Collector for Kubernetes

[Wavefront](https://wavefront.com) is a cloud-native monitoring and analytics platform that provides three dimensional microservices observability with metrics, histograms and OpenTracing-compatible distributed tracing.

## TL;DR

```console
$ kubectl create namespace wavefront
$ helm install my-release bitnami/wavefront --namespace wavefront \
    --set clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.token=<YOUR_API_TOKEN>
```

## Introduction

This chart will deploy the Wavefront Collector for Kubernetes and Wavefront Proxy to your Kubernetes cluster. You can use this chart to install multiple Wavefront Proxy releases, though only one Wavefront Collector for Kubernetes per cluster should be used.

You can learn more about the Wavefront and Kubernetes integration [in the official documentation](https://docs.wavefront.com/wavefront_kubernetes.html)

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release` (if not already done, create a `wavefront` namespace):

```console
$ kubectl create namespace wavefront
$ helm install my-release bitnami/wavefront --namespace wavefront \
    --set clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.token=<YOUR_API_TOKEN>
```

The command deploys Wavefront on the Kubernetes cluster in the `wavefront` namespace using the configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

The **required** parameters are `clusterName`, `wavefront.url` and `wavefront.token`. You will need to provide values for those options for a successful installation of the chart.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. If you want to also remove the namespace please execute `kubectl delete namespace wavefront`.

## Parameters

The following table lists the configurable parameters of the Wavefront chart and their default values.

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter                  | Description                                                                 | Default                              |
|----------------------------|-----------------------------------------------------------------------------|--------------------------------------|
| `clusterName`              | Unique name for the Kubernetes cluster (required)                           | `KUBERNETES_CLUSTER_NAME`            |
| `wavefront.url`            | Wavefront URL for your cluster (required)                                   | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.token`          | Wavefront API Token (required)                                              | `YOUR_API_TOKEN`                     |
| `wavefront.existingSecret` | Name of an existing secret containing the token                             | `nil`                                |
| `commonLabels`             | Labels to add to all deployed objects                                       | `{}`                                 |
| `commonAnnotations`        | Annotations to add to all deployed objects                                  | `{}`                                 |
| `extraDeploy`              | Array of extra objects to deploy with the release                           | `[]` (evaluated as a template)       |
| `rbac.create`              | Create RBAC resources                                                       | `true`                               |
| `serviceAccount.create`    | Create Wavefront service account                                            | `true`                               |
| `serviceAccount.name`      | Name of Wavefront service account                                           | `nil`                                |
| `podSecurityPolicy.create` | Create a PodSecurityPolicy resources                                        | `false`                              |
| `projectPacific.enabled`   | Enable and create role binding for Tanzu kubernetes cluster                 | `false`                              |
| `tkgi.enabled`             | Enable and create role binding for Tanzu Kubernetes Grid Integrated Edition | `false`                              |

### Collector parameters

| Parameter                                  | Description                                                                                                             | Default                                   |
|--------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| `collector.enabled`                        | Setup and enable the Wavefront collector to gather metrics                                                              | `true`                                    |
| `collector.image.registry`                 | Wavefront collector Image registry                                                                                      | `docker.io`                               |
| `collector.image.repository`               | Wavefront collector Image name                                                                                          | `bitnami/wavefront-kubernetes-collector`  |
| `collector.image.tag`                      | Wavefront collector Image tag                                                                                           | `{TAG_NAME}`                              |
| `collector.image.pullPolicy`               | Image pull policy                                                                                                       | `IfNotPresent`                            |
| `collector.image.pullSecrets`              | Specify docker-registry secret names as an array                                                                        | `nil`                                     |
| `collector.useDaemonset`                   | Use Wavefront collector in Daemonset mode                                                                               | `true`                                    |
| `collector.usePKSPrefix`                   | (TKGi only) Prefix metrics with 'pks.kubernetes.'                                                                       | `false`                                   |
| `collector.hostAliases`                    | Add deployment host aliases                                                                                             | `[]`                                      |
| `collector.maxProx`                        | Max number of CPU cores that can be used (< 1 for default)                                                              | `0`                                       |
| `collector.logLevel`                       | Min logging level (info, debug, trace)                                                                                  | `info`                                    |
| `collector.interval`                       | Default metrics collection interval                                                                                     | `60s`                                     |
| `collector.flushInterval`                  | How often to force a metrics flush                                                                                      | `10s`                                     |
| `collector.sinkDelay`                      | Timeout for exporting data                                                                                              | `10s`                                     |
| `collector.useReadOnlyPort`                | Use un-authenticated port for kubelet                                                                                   | `false`                                   |
| `collector.useProxy`                       | Use a Wavefront Proxy to send metrics through                                                                           | `true`                                    |
| `collector.proxyAddress`                   | Non-default Wavefront Proxy address to use, should only be set when `proxy.enabled` is false                            | `nil`                                     |
| `collector.apiServerMetrics`               | Collect metrics about Kubernetes API server                                                                             | `false`                                   |
| `collector.kubernetesState`                | Collect metrics about Kubernetes resource states                                                                        | `true`                                    |
| `collector.filters`                        | Filters to apply towards all collected metrics                                                                          | See values.yaml                           |
| `collector.tags`                           | Map of tags (key/value) to add to all metrics collected                                                                 | `nil`                                     |
| `collector.events.enabled`                 | Events can also be collected and sent to Wavefront                                                                      | `false`                                   |
| `collector.discovery.enabled`              | Rules based and Prometheus endpoints auto-discovery                                                                     | `true`                                    |
| `collector.discovery.annotationPrefix`     | Replaces `prometheus.io` as prefix for annotations of auto-discovered Prometheus endpoints                              | `prometheus.io`                           |
| `collector.discovery.enableRuntimeConfigs` | Enable runtime discovery rules                                                                                          | `true`                                    |
| `collector.discovery.config`               | Configuration for rules based auto-discovery                                                                            | `nil`                                     |
| `collector.existingConfigmap`              | Name of existing ConfigMap with collector configuration                                                                 | `nil`                                     |
| `collector.command`                        | Override default container command (useful when using custom images)                                                    | `nil`                                     |
| `collector.args`                           | Override default container args (useful when using custom images)                                                       | `nil`                                     |
| `collector.resources.limits`               | The resources limits for the collector container                                                                        | `{}`                                      |
| `collector.resources.requests`             | The requested resources for the collector container                                                                     | `{}`                                      |
| `collector.containerSecurityContext`       | Container security podSecurityContext                                                                                   | `{ runAsUser: 1001, runAsNonRoot: true }` |
| `collector.podSecurityContext`             | Pod security                                                                                                            | `{ fsGroup: 1001 }`                       |
| `collector.podAffinityPreset`              | Wavefront collector pod affinity preset. Ignored if `collector.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                      |
| `collector.podAntiAffinityPreset`          | Wavefront collector pod anti-affinity preset. Ignored if `collector.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                    |
| `collector.nodeAffinityPreset.type`        | Wavefront collector node affinity preset type. Ignored if `collector.affinity` is set. Allowed values: `soft` or `hard` | `""`                                      |
| `collector.nodeAffinityPreset.key`         | Wavefront collector node label key to match Ignored if `collector.affinity` is set.                                     | `""`                                      |
| `collector.nodeAffinityPreset.values`      | Wavefront collector node label values to match. Ignored if `collector.affinity` is set.                                 | `[]`                                      |
| `collector.affinity`                       | Wavefront collector affinity for pod assignment                                                                         | `{}` (evaluated as a template)            |
| `collector.nodeSelector`                   | Wavefront collector node labels for pod assignment                                                                      | `{}` (evaluated as a template)            |
| `collector.tolerations`                    | Wavefront collector tolerations for pod assignment                                                                      | `[]` (evaluated as a template)            |
| `collector.podLabels`                      | Add additional labels to the pod (evaluated as a template)                                                              | `nil`                                     |
| `collector.podAnnotations`                 | Annotations for Wavefront collector pods                                                                                | `{}`                                      |
| `collector.priorityClassName`              | Collector priorityClassName                                                                                             | `nil`                                     |
| `collector.lifecycleHooks`                 | LifecycleHooks to set additional configuration at startup.                                                              | `{}` (evaluated as a template)            |
| `collector.customLivenessProbe`            | Override default liveness probe                                                                                         | `nil`                                     |
| `collector.customReadinessProbe`           | Override default readiness probe                                                                                        | `nil`                                     |
| `collector.updateStrategy`                 | Deployment update strategy                                                                                              | `nil`                                     |
| `collector.extraEnvVars`                   | Extra environment variables to be set on collector container                                                            | `{}`                                      |
| `collector.extraEnvVarsCM`                 | Name of existing ConfigMap containing extra env vars                                                                    | `nil`                                     |
| `collector.extraEnvVarsSecret`             | Name of existing Secret containing extra env vars                                                                       | `nil`                                     |
| `collector.extraVolumeMounts`              | Optionally specify extra list of additional volumeMounts for collector container                                        | `[]`                                      |
| `collector.extraVolumes`                   | Optionally specify extra list of additional volumes for collector container                                             | `[]`                                      |
| `collector.initContainers`                 | Add additional init containers to the collector pods                                                                    | `{}` (evaluated as a template)            |
| `collector.sidecars`                       | Add additional sidecar containers to the collector pods                                                                 | `{}` (evaluated as a template)            |

### Proxy parameters

| Parameter                           | Description                                                                                                            | Default                                   |
|-------------------------------------|------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| `proxy.enabled`                     | Setup and enable Wavefront proxy to send metrics through                                                               | `true`                                    |
| `proxy.image.registry`              | Wavefront proxy Image registry                                                                                         | `docker.io`                               |
| `proxy.image.repository`            | Wavefront proxy Image name                                                                                             | `bitnami/wavefront-proxy`                 |
| `proxy.image.tag`                   | Wavefront proxy Image tag                                                                                              | `{TAG_NAME}`                              |
| `proxy.image.pullPolicy`            | Image pull policy                                                                                                      | `IfNotPresent`                            |
| `proxy.image.pullSecrets`           | Specify docker-registry secret names as an array                                                                       | `nil`                                     |
| `proxy.replicas`                    | Replicas to deploy for Wavefront proxy (usually 1)                                                                     | `1`                                       |
| `proxy.resources.limits`            | The resources limits for the proxy container                                                                           | `{}`                                      |
| `proxy.resources.requests`          | The requested resources for the proxy container                                                                        | `{}`                                      |
| `proxy.containerSecurityContext`    | Container security podSecurityContext                                                                                  | `{ runAsUser: 1001, runAsNonRoot: true }` |
| `proxy.podSecurityContext`          | Pod security                                                                                                           | `{ fsGroup: 1001 }`                       |
| `proxy.podAffinityPreset`           | Wavefront proxy pod affinity preset. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`              | `""`                                      |
| `proxy.podAntiAffinityPreset`       | Wavefront proxy pod anti-affinity preset. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`         | `soft`                                    |
| `proxy.nodeAffinityPreset.type`     | Wavefront proxy node affinity preset type. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`        | `""`                                      |
| `proxy.nodeAffinityPreset.key`      | Wavefront proxy node label key to match Ignored if `proxy.affinity` is set.                                            | `""`                                      |
| `proxy.nodeAffinityPreset.values`   | Wavefront proxy node label values to match. Ignored if `proxy.affinity` is set.                                        | `[]`                                      |
| `proxy.affinity`                    | Wavefront proxy affinity for pod assignment                                                                            | `{}` (evaluated as a template)            |
| `proxy.nodeSelector`                | Wavefront proxy node labels for pod assignment                                                                         | `{}` (evaluated as a template)            |
| `proxy.tolerations`                 | Wavefront proxy tolerations for pod assignment                                                                         | `[]` (evaluated as a template)            |
| `proxy.hostAliases`                 | Add deployment host aliases                                                                                            | `[]`                                      |
| `proxy.podLabels`                   | Add additional labels to the pod (evaluated as a template)                                                             | `nil`                                     |
| `proxy.podAnnotations`              | Annotations for Wavefront proxy pods                                                                                   | `{}`                                      |
| `proxy.priorityClassName`           | Proxy priorityClassName                                                                                                | `nil`                                     |
| `proxy.lifecycleHooks`              | LifecycleHooks to set additional configuration at startup.                                                             | `{}` (evaluated as a template)            |
| `proxy.livenessProbe`               | Liveness probe configuration for Wavefront proxy                                                                       | Check `values.yaml` file                  |
| `proxy.readinessProbe`              | Readiness probe configuration for Wavefront proxy                                                                      | Check `values.yaml` file                  |
| `proxy.customLivenessProbe`         | Override default liveness probe                                                                                        | `nil`                                     |
| `proxy.customReadinessProbe`        | Override default readiness probe                                                                                       | `nil`                                     |
| `proxy.updateStrategy`              | Deployment update strategy                                                                                             | `nil`                                     |
| `proxy.extraEnvVars`                | Extra environment variables to be set on proxy container                                                               | `{}`                                      |
| `proxy.extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                                                                   | `nil`                                     |
| `proxy.extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                                                                      | `nil`                                     |
| `proxy.extraVolumeMounts`           | Optionally specify extra list of additional volumeMounts for proxy container                                           | `[]`                                      |
| `proxy.extraVolumes`                | Optionally specify extra list of additional volumes for proxy container                                                | `[]`                                      |
| `proxy.initContainers`              | Add additional init containers to the proxy pods                                                                       | `{}` (evaluated as a template)            |
| `proxy.sidecars`                    | Add additional sidecar containers to the proxy pods                                                                    | `{}` (evaluated as a template)            |
| `proxy.port`                        | Primary port for Wavefront data format metrics                                                                         | `2878`                                    |
| `proxy.tracePort`                   | Port for distributed tracing data (usually 30000)                                                                      | `nil`                                     |
| `proxy.jaegerPort`                  | Port for Jaeger format distributed tracing data (usually 30001)                                                        | `nil`                                     |
| `proxy.traceJaegerHttpListenerPort` | Port for Jaeger Thrift format data (usually 30080)                                                                     | `nil`                                     |
| `proxy.zipkinPort`                  | Port for Zipkin format distributed tracing data (usually 9411)                                                         | `nil`                                     |
| `proxy.traceSamplingRate`           | Distributed tracing data sampling rate (0 to 1)                                                                        | `nil`                                     |
| `proxy.traceSamplingDuration`       | When set to greater than 0, spans that exceed this duration will force trace to be sampled (ms)                        | `nil`                                     |
| `proxy.traceJaegerApplicationName`  | Custom application name for traces received on Jaeger's traceJaegerListenerPorts or traceJaegerHttpListenerPorts.      | `nil`                                     |
| `proxy.traceZipkinApplicationName`  | Custom application name for traces received on Zipkin's traceZipkinListenerPorts.                                      | `nil`                                     |
| `proxy.histogramPort`               | Port for histogram distribution format data (usually 40000)                                                            | `nil`                                     |
| `proxy.histogramMinutePort`         | Port to accumulate 1-minute based histograms on Wavefront data format (usually 40001)                                  | `nil`                                     |
| `proxy.histogramHourPort`           | Port to accumulate 1-hour based histograms on Wavefront data format (usually 40002)                                    | `nil`                                     |
| `proxy.histogramDayPort`            | Port to accumulate 1-day based histograms on Wavefront data format (usually 40003)                                     | `nil`                                     |
| `proxy.deltaCounterPort`            | Port to accumulate 1-minute delta counters on Wavefront data format (usually 50000)                                    | `nil`                                     |
| `proxy.args`                        | Additional Wavefront proxy properties to be passed as command line arguments in the `--<property_name> <value>` format | `nil`                                     |
| `proxy.heap`                        | Wavefront proxy Java heap maximum usage (java -Xmx command line option)                                                | `nil`                                     |
| `proxy.existingConfigmap`           | Name of existing ConfigMap with Proxy preprocessor configuration                                                       | `nil`                                     |
| `proxy.preprocessor.rules.yaml`     | YAML configuration for Wavefront proxy preprocessor rules                                                              | `nil`                                     |

### Kube State Metrics parameters

| Parameter                    | Description                                        | Default |
|------------------------------|----------------------------------------------------|---------|
| `kube-state-metrics.enabled` | Setup and enable Kube State Metrics for collection | `false` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set proxy.replicas=3 \
    bitnami/wavefront
```

The above command sets 3 proxy replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/wavefront
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### DaemonSet (preferred) VS Deployment

It is possible to deploy the collector as a `Daemonset` or a `Deployment`.

Using it as `Deployment`, Kubernetes will deploy the Wavefront collector in one node, while deploying it as `DaemonSet` Kubernetes will attempt to adhere to a one-Pod-per-node model. `DaemonSet` will not run more than one replica per node. In the same way, if you add a node to the cluster then `DaemonSet` will automatically spawn pod on that node, which `Deployment` will not do.

At the end the most common use case is deploy the Wavefront collector as `DaemonSet` to obtain information from the different nodes, but there are some use cases where you want to use a `Deployment` to obtain some data (application level) without deploying a pod per node.

### Change Wavefront version

To modify the Wavefront version used in this chart you can specify a [valid image tag](https://hub.docker.com/r/bitnami/Wavefront-kubernetes-collector/tags/) using the `collector.image.tag` parameter. For example, `collector.image.tag=X.Y.Z`. This approach is also applicable to other images like the proxy.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Wavefront (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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
  - name: WAVEFRONT_WHATEVER
    value: value
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

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
