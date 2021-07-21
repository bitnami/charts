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

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                             | Value |
| ------------------- | ------------------------------------------------------- | ----- |
| `commonLabels`      | Add labels to all the deployed resources                | `{}`  |
| `commonAnnotations` | Add annotations to all the deployed resources           | `{}`  |
| `extraDeploy`       | Extra objects to deploy (value evaluated as a template) | `[]`  |


### Wavefront Common parameters

| Name                       | Description                                                                                                                          | Value                                |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------ |
| `clusterName`              | This is a unique name for the cluster (required)                                                                                     | `KUBERNETES_CLUSTER_NAME`            |
| `wavefront.url`            | Wavefront URL for your cluster (required)                                                                                            | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.token`          | Wavefront API Token (required)                                                                                                       | `YOUR_API_TOKEN`                     |
| `wavefront.existingSecret` | Name of an existing secret containing the token                                                                                      | `""`                                 |
| `podSecurityPolicy.create` | Specifies whether PodSecurityPolicy resources should be created                                                                      | `false`                              |
| `rbac.create`              | Specifies whether RBAC resources should be created                                                                                   | `true`                               |
| `serviceAccount.create`    | Create Wavefront service account                                                                                                     | `true`                               |
| `serviceAccount.name`      | Name of Wavefront service account                                                                                                    | `""`                                 |
| `projectPacific.enabled`   | Enable and create role binding for Tanzu Kubernetes cluster                                                                          | `false`                              |
| `tkgi.enabled`             | Properties for TKGI environments. If enabled, a role binding to handle pod security policy will be installed within the TKGI cluster | `false`                              |


### Collector parameters

| Name                                              | Description                                                                                                             | Value                                    |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `collector.enabled`                               | Setup and enable the Wavefront collector to gather metrics                                                              | `true`                                   |
| `collector.image.registry`                        | Wavefront collector Image registry                                                                                      | `docker.io`                              |
| `collector.image.repository`                      | Wavefront collector Image repository                                                                                    | `bitnami/wavefront-kubernetes-collector` |
| `collector.image.tag`                             | Wavefront collector Image tag (immutable tags are recommended)                                                          | `1.5.0-scratch-r0`                       |
| `collector.image.pullPolicy`                      | Image pull policy                                                                                                       | `IfNotPresent`                           |
| `collector.image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                        | `[]`                                     |
| `collector.hostAliases`                           | Deployment pod host aliases                                                                                             | `[]`                                     |
| `collector.useDaemonset`                          | Use Wavefront collector in Daemonset mode                                                                               | `true`                                   |
| `collector.usePKSPrefix`                          | If installing into a TKGi/PKS environment, set this to true. Prefixes metrics with 'pks.kubernetes.'                    | `false`                                  |
| `collector.maxProcs`                              | Maximum number of CPUs that can be used simultaneously                                                                  | `""`                                     |
| `collector.logLevel`                              | Log level. Allowed values: `info`, `debug` or `trace`                                                                   | `""`                                     |
| `collector.interval`                              | Default metrics collection interval                                                                                     | `""`                                     |
| `collector.flushInterval`                         | How often to force a metrics flush                                                                                      | `""`                                     |
| `collector.sinkDelay`                             | Timeout for exporting data                                                                                              | `""`                                     |
| `collector.useReadOnlyPort`                       | Use un-authenticated port for kubelet                                                                                   | `false`                                  |
| `collector.useProxy`                              | Use a Wavefront Proxy to send metrics through                                                                           | `true`                                   |
| `collector.proxyAddress`                          | Can be used to specify a specific address for the Wavefront Proxy                                                       | `""`                                     |
| `collector.kubernetesState`                       | Collect metrics about Kubernetes resource states                                                                        | `true`                                   |
| `collector.apiServerMetrics`                      | Collect metrics about Kubernetes API server                                                                             | `false`                                  |
| `collector.tags`                                  | Map of tags to apply to all metrics collected by the collector                                                          | `{}`                                     |
| `collector.hostOSMetrics`                         | If set to true, host OS metrics will be collected                                                                       | `false`                                  |
| `collector.filters.metricDenyList`                | Optimized metrics collection to omit peripheral metrics.                                                                | `[]`                                     |
| `collector.filters.tagExclude`                    | Filter out generated labels                                                                                             | `[]`                                     |
| `collector.events.enabled`                        | Events can also be collected and sent to Wavefront                                                                      | `false`                                  |
| `collector.discovery.enabled`                     | Rules based and Prometheus endpoints auto-discovery                                                                     | `true`                                   |
| `collector.discovery.annotationPrefix`            | When specified, this replaces `prometheus.io` as the prefix for annotations used to auto-discover Prometheus endpoints  | `""`                                     |
| `collector.discovery.enableRuntimeConfigs`        | Whether to enable runtime discovery configurations                                                                      | `true`                                   |
| `collector.discovery.config`                      | Configuration for rules based auto-discovery                                                                            | `[]`                                     |
| `collector.existingConfigmap`                     | Name of existing ConfigMap with collector configuration                                                                 | `""`                                     |
| `collector.command`                               | Override default container command (useful when using custom images)                                                    | `[]`                                     |
| `collector.args`                                  | Override default container args (useful when using custom images)                                                       | `[]`                                     |
| `collector.resources.limits`                      | The resources limits for the collector container                                                                        | `{}`                                     |
| `collector.resources.requests`                    | The requested resources for the collector container                                                                     | `{}`                                     |
| `collector.containerSecurityContext.enabled`      | Enable Container Security Context configuration                                                                         | `true`                                   |
| `collector.containerSecurityContext.runAsUser`    | Set Container's Security Context runAsUser                                                                              | `1001`                                   |
| `collector.containerSecurityContext.runAsNonRoot` | Set Container's Security Context runAsNonRoot                                                                           | `true`                                   |
| `collector.podSecurityContext.enabled`            | Enable Pod Security Context configuration                                                                               | `true`                                   |
| `collector.podSecurityContext.fsGroup`            | Group ID for the volumes of the pod                                                                                     | `1001`                                   |
| `collector.podAffinityPreset`                     | Wavefront collector pod affinity preset. Ignored if `collector.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                     |
| `collector.podAntiAffinityPreset`                 | Wavefront collector pod anti-affinity preset. Ignored if `collector.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                   |
| `collector.nodeAffinityPreset.type`               | Wavefront collector node affinity preset type. Ignored if `collector.affinity` is set. Allowed values: `soft` or `hard` | `""`                                     |
| `collector.nodeAffinityPreset.key`                | Wavefront collector node label key to match Ignored if `collector.affinity` is set.                                     | `""`                                     |
| `collector.nodeAffinityPreset.values`             | Wavefront collector node label values to match. Ignored if `collector.affinity` is set.                                 | `[]`                                     |
| `collector.affinity`                              | Wavefront collector affinity for pod assignment                                                                         | `{}`                                     |
| `collector.nodeSelector`                          | Wavefront collector node labels for pod assignment                                                                      | `{}`                                     |
| `collector.tolerations`                           | Wavefront collector tolerations for pod assignment                                                                      | `[]`                                     |
| `collector.podLabels`                             | Wavefront collector pod extra labels                                                                                    | `{}`                                     |
| `collector.podAnnotations`                        | Annotations for Wavefront collector pods                                                                                | `{}`                                     |
| `collector.priorityClassName`                     | Wavefront Collector pods' priority                                                                                      | `""`                                     |
| `collector.lifecycleHooks`                        | Lifecycle hooks for the Wavefront Collector container to automate configuration before or after startup                 | `{}`                                     |
| `collector.customLivenessProbe`                   | Override default liveness probe                                                                                         | `{}`                                     |
| `collector.customReadinessProbe`                  | Override default readiness probe                                                                                        | `{}`                                     |
| `collector.updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached                                          | `RollingUpdate`                          |
| `collector.extraEnvVars`                          | Extra environment variables to be set on collector container                                                            | `[]`                                     |
| `collector.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra environment variables                                                       | `""`                                     |
| `collector.extraEnvVarsSecret`                    | Name of existing Secret containing extra environment variables                                                          | `""`                                     |
| `collector.extraVolumes`                          | Optionally specify extra list of additional volumes for collector container                                             | `[]`                                     |
| `collector.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for collector container                                        | `[]`                                     |
| `collector.initContainers`                        | Add init containers to the Wavefront proxy pods                                                                         | `[]`                                     |
| `collector.sidecars`                              | Add sidecars to the Wavefront proxy pods                                                                                | `[]`                                     |


### Proxy parameters

| Name                                          | Description                                                                                                                             | Value                     |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `proxy.enabled`                               | Setup and enable Wavefront proxy to send metrics through                                                                                | `true`                    |
| `proxy.image.registry`                        | Wavefront proxy image registry                                                                                                          | `docker.io`               |
| `proxy.image.repository`                      | Wavefront proxy image repository                                                                                                        | `bitnami/wavefront-proxy` |
| `proxy.image.tag`                             | Wavefront proxy image tag (immutable tags are recommended)                                                                              | `9.7.0-debian-10-r73`     |
| `proxy.image.pullPolicy`                      | Wavefront proxy image pull policy                                                                                                       | `IfNotPresent`            |
| `proxy.image.pullSecrets`                     | Specify docker-registry secret names as an array                                                                                        | `[]`                      |
| `proxy.hostAliases`                           | Deployment pod host aliases                                                                                                             | `[]`                      |
| `proxy.resources.limits`                      | The resources limits for the proxy container                                                                                            | `{}`                      |
| `proxy.resources.requests`                    | The requested resources for the proxy container                                                                                         | `{}`                      |
| `proxy.containerSecurityContext.enabled`      | Enable Container Security Context configuration                                                                                         | `true`                    |
| `proxy.containerSecurityContext.runAsUser`    | Set Container's Security Context runAsUser                                                                                              | `1001`                    |
| `proxy.containerSecurityContext.runAsNonRoot` | Set Container's Security Context runAsNonRoot                                                                                           | `true`                    |
| `proxy.podSecurityContext.enabled`            | Enable Pod Security Context configuration                                                                                               | `true`                    |
| `proxy.podSecurityContext.fsGroup`            | Group ID for the volumes of the pod                                                                                                     | `1001`                    |
| `proxy.podAffinityPreset`                     | Wavefront proxy pod affinity preset. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                               | `""`                      |
| `proxy.podAntiAffinityPreset`                 | Wavefront proxy pod anti-affinity preset. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                          | `soft`                    |
| `proxy.nodeAffinityPreset.type`               | Wavefront proxy node affinity preset type. Ignored if `proxy.affinity` is set. Allowed values: `soft` or `hard`                         | `""`                      |
| `proxy.nodeAffinityPreset.key`                | Wavefront proxy node label key to match Ignored if `proxy.affinity` is set.                                                             | `""`                      |
| `proxy.nodeAffinityPreset.values`             | Wavefront proxy node label values to match. Ignored if `proxy.affinity` is set.                                                         | `[]`                      |
| `proxy.affinity`                              | Wavefront proxy affinity for pod assignment                                                                                             | `{}`                      |
| `proxy.nodeSelector`                          | Wavefront proxy node labels for pod assignment                                                                                          | `{}`                      |
| `proxy.tolerations`                           | Wavefront proxy tolerations for pod assignment                                                                                          | `[]`                      |
| `proxy.podLabels`                             | Wavefront proxy pod extra labels                                                                                                        | `{}`                      |
| `proxy.podAnnotations`                        | Annotations for Wavefront proxy pods                                                                                                    | `{}`                      |
| `proxy.priorityClassName`                     | Wavefront proxy pods' priority class name                                                                                               | `""`                      |
| `proxy.lifecycleHooks`                        | Lifecycle hooks for the Wavefront proxy container to automate configuration before or after startup                                     | `{}`                      |
| `proxy.livenessProbe.enabled`                 | Enable livenessProbe                                                                                                                    | `true`                    |
| `proxy.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                 | `10`                      |
| `proxy.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                        | `20`                      |
| `proxy.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                       | `1`                       |
| `proxy.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                     | `6`                       |
| `proxy.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                                     | `1`                       |
| `proxy.readinessProbe.enabled`                | Enable readinessProbe                                                                                                                   | `true`                    |
| `proxy.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                | `10`                      |
| `proxy.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                       | `20`                      |
| `proxy.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                      | `1`                       |
| `proxy.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                    | `6`                       |
| `proxy.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                    | `1`                       |
| `proxy.customLivenessProbe`                   | Override default liveness probe                                                                                                         | `{}`                      |
| `proxy.customReadinessProbe`                  | Override default readiness probe                                                                                                        | `{}`                      |
| `proxy.updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached                                                          | `RollingUpdate`           |
| `proxy.extraEnvVars`                          | Extra environment variables to be set on proxy container                                                                                | `[]`                      |
| `proxy.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra environment variables                                                                       | `""`                      |
| `proxy.extraEnvVarsSecret`                    | Name of existing Secret containing extra environment variables                                                                          | `""`                      |
| `proxy.extraVolumes`                          | Optionally specify extra list of additional volumes for proxy container                                                                 | `[]`                      |
| `proxy.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for proxy container                                                            | `[]`                      |
| `proxy.initContainers`                        | Add init containers to the Wavefront proxy pods                                                                                         | `[]`                      |
| `proxy.sidecars`                              | Add sidecars to the Wavefront proxy pods                                                                                                | `[]`                      |
| `proxy.replicas`                              | Replicas to deploy for Wavefront proxy (usually 1)                                                                                      | `1`                       |
| `proxy.port`                                  | The port number the proxy will listen on for metrics in Wavefront data format                                                           | `2878`                    |
| `proxy.tracePort`                             | The port number the proxy will listen on for tracing spans in Wavefront trace data format (usually 30000)                               | `""`                      |
| `proxy.jaegerPort`                            | The port number the proxy will listen on for tracing spans in Jaeger data format (usually 30001)                                        | `""`                      |
| `proxy.traceJaegerHttpListenerPort`           | TCP ports to receive Jaeger Thrift formatted data via HTTP. The data is then sent to Wavefront in Wavefront span format (usually 30080) | `""`                      |
| `proxy.traceJaegerGrpcListenerPort`           | TCP ports to receive Jaeger GRPC formatted data via HTTP (usually 14250)                                                                | `""`                      |
| `proxy.zipkinPort`                            | The port number the proxy will listen on for tracing spans in Zipkin data format (usually 9411)                                         | `""`                      |
| `proxy.traceSamplingRate`                     | Sampling rate to apply to tracing spans sent to the proxy                                                                               | `""`                      |
| `proxy.traceSamplingDuration`                 | When set to greater than 0, spans that exceed this duration will force trace to be sampled (ms)                                         | `""`                      |
| `proxy.traceJaegerApplicationName`            | Custom application name for traces received on Jaeger's traceJaegerListenerPorts or traceJaegerHttpListenerPorts.                       | `""`                      |
| `proxy.traceZipkinApplicationName`            | Custom application name for traces received on Zipkin's traceZipkinListenerPorts.                                                       | `""`                      |
| `proxy.histogramPort`                         | Port for histogram distribution format data (usually 40000)                                                                             | `""`                      |
| `proxy.histogramMinutePort`                   | Port to accumulate 1-minute based histograms on Wavefront data format (usually 40001)                                                   | `""`                      |
| `proxy.histogramHourPort`                     | Port to accumulate 1-hour based histograms on Wavefront data format (usually 40002)                                                     | `""`                      |
| `proxy.histogramDayPort`                      | Port to accumulate 1-day based histograms on Wavefront data format (usually 40003)                                                      | `""`                      |
| `proxy.deltaCounterPort`                      | Port to accumulate 1-minute delta counters on Wavefront data format (usually 50000)                                                     | `""`                      |
| `proxy.args`                                  | Any configuration property can be passed to the proxy via command line args in the format: `--<property_name> <value>`                  | `[]`                      |
| `proxy.heap`                                  | Wavefront proxy Java heap maximum usage (java -Xmx command line option)                                                                 | `""`                      |
| `proxy.existingConfigmap`                     | Name of existing ConfigMap with Proxy preprocessor configuration                                                                        | `""`                      |
| `proxy.preprocessor`                          | Preprocessor rules is a powerful way to apply filtering or to enhance metrics as they flow                                              | `{}`                      |


### Kube State Metrics parameters

| Name                         | Description                                                                                                                      | Value   |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `kube-state-metrics.enabled` | If enabled the kube-state-metrics chart will be installed as a subchart and the collector will be configured to capture metrics. | `false` |


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

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use DaemonSet (preferred) or Deployment

It is possible to deploy the Collector as a `Daemonset` or a `Deployment`. Refer to the documentation for [detailed information on the differences between these options](https://docs.bitnami.com/kubernetes/apps/wavefront/configuration/configure-collector/).

The most common use case is to deploy the Wavefront Collector as a `DaemonSet` to obtain information from the different nodes. However, there are some use cases where a `Deployment` can be used to gather data (at application level) without deploying a pod per node.

### Change Wavefront version

To modify the application version used in this chart, specify a [different image tag](https://hub.docker.com/r/bitnami/Wavefront-kubernetes-collector/tags/) using the `collector.image.tag` parameter. For example, `collector.image.tag=X.Y.Z`. This approach is also applicable to other images like the proxy.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/apps/wavefront/configuration/configure-sidecar-init-containers/).

### Add extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: WAVEFRONT_WHATEVER
    value: value
```

Alternatively, use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Set Pod affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 3.0.0

This major updates the kube-state-metrics subchart to it newest major, 2.0.0, which contains name changes to a few of its values. For more information on this subchart's major, please refer to [kube-state-metrics upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/kube-state-metrics#to-200).

### To 2.0.0

The wavefront-collector container has been moved to scratch. From now on the content of wavefront-collector container will be just the wavefront-collector binary, so it will not have a shell.

### To 1.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/wavefront/administration/upgrade-helm3/).
