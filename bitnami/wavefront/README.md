# Wavefront Collector for Kubernetes

[Wavefront](https://wavefront.com) is a cloud-native monitoring and analytics platform that provides
three dimensional microservices observability with metrics, histograms and OpenTracing-compatible distributed tracing.

## Introduction

This chart will deploy the Wavefront Collector for Kubernetes and Wavefront Proxy to your
Kubernetes cluster.  You can use this chart to install multiple Wavefront Proxy releases,
though only one Wavefront Collector for Kubernetes per cluster should be used.

You can learn more about the Wavefront and Kubernetes integration [here](https://docs.wavefront.com/wavefront_kubernetes.html)

## Installation

**Helm 2**
```
helm install wavefront/wavefront --name wavefront --namespace wavefront \
    --set clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.token=<YOUR_API_TOKEN>
```

**Helm 3+**

_If not already done, create a namespace to install this chart_
```
kubectl create namespace wavefront

helm install wavefront wavefront/wavefront --namespace wavefront \
    --set clusterName=<K8s-CLUSTER-NAME> \
    --set wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.token=<YOUR_API_TOKEN>
```

## Configuration

The [values.yaml](./values.yaml) file contains information about all configuration
options for this chart.

The **requried** options are `clusterName`, `wavefront.url` and `wavefront.token`.
You will need to provide values for those options for a successful installation of the chart.

## Parameters

The following tables lists the configurable parameters of the Wavefront chart and their default values.

| Parameter | Description | Default |
| --- | --- | --- |
| `clusterName` | Unique name for the Kubernetes cluster | `KUBERNETES_CLUSTER_NAME` |
| `wavefront.url` | Wavefront URL for your cluster | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.token` | Wavefront API Token | `YOUR_API_TOKEN` |
| `collector.enabled` | Setup and enable the Wavefront collector to gather metrics | `true` |
| `collector.image.repository` | Wavefront collector image registry and name | `wavefronthq/wavefront-kubernetes-collector` |
| `collector.image.tag` | Wavefront collector image tag | `{TAG_NAME}` |
| `colletor.image.pullPolicy` | Wavefront collector image pull policy | `IfNotPresent` |
| `collector.useDaemonset` | Use Wavefront collector in Daemonset mode | `true` |
| `collector.maxProx` | Max number of CPU cores that can be used (< 1 for default) | `0` |
| `collector.logLevel` | Min logging level (info, debug, trace) | `info` |
| `collector.interval` | Default metrics collection interval | `60s` |
| `collector.flushInterval` | How often to force a metrics flush | `10s` |
| `collector.sinkDelay` | Timout for exporting data | `10s` |
| `collector.useReadOnlyPort` | Use un-authenticated port for kubelet | `false` |
| `collector.useProxy` | Use a Wavefront Proxy to send metrics through | `true` |
| `collector.proxyAddress` | Non-default Wavefront Proxy address to use, should only be set when `proxy.enabled` is false | `nil` |
| `collector.apiServerMetrics` | Collect metrics about Kubernetes API server | `false` |
| `collector.kubernetesState` | Collect metrics about Kubernetes resource states [see more](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes/blob/master/docs/metrics.md#kubernetes-state-source) | `true` |
| `collector.tags` | Map of tags (key/value) to add to all metrics collected | `nil` |
| `collector.discovery.enabled` | Rules based and Prometheus endpoints auto-discovery  | `true` |
| `collector.discovery.annotationPrefix` | Replaces `prometheus.io` as prefix for annotations of auto-discovered Prometheus endpoints | `prometheus.io` |
| `collector.discovery.enableRuntimeConfigs` | Enable runtime discovery rules [see more](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes/blob/master/docs/discovery.md#runtime-configurations) | `false` |
| `collector.discovery.config` | Configuration for rules based auto-discovery [see more](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes/blob/master/docs/discovery.md) | `nil` |
| `collector.resources` | CPU/Memory resource requests/limits | CPU: `200m`/`200m`, Memory: `10Mi`/`256Mi` |
| `proxy.enabled` | Setup and enable Wavefront proxy to send metrics through | `true` |
| `proxy.image.repository` | Wavefront proxy image registry and name | `wavefronthq/proxy` |
| `proxy.image.tag` | Wavefront proxy image tag | `{TAG_NAME}` |
| `proxy.image.pullPolicy` | Wavefront proxy image pull policy | `IfNotPresent` |
| `proxy.replicas` | Replicas to deploy for Wavefront proxy (usually 1) | `1` |
| `proxy.port` | Primary port for Wavefront data format metrics | `2878` |
| `proxy.tracePort` | Port for distributed tracing data (usually 30000) | `nil` |
| `proxy.jaegerPort` | Port for Jaeger format distributed tracing data (usually 30001) | `nil` |
| `proxy.traceJaegerHttpListenerPort` | Port for Jaeger Thrift format data (usually 30080) | `nil` |
| `proxy.zipkinPort` | Port for Zipkin format distribued tracing data (usually 9411)| `nil` |
| `proxy.traceSamplingRate` | Distributed tracing data sampling rate (0 to 1) | `nil` |
| `proxy.traceSamplingDuration` | When set to greater than 0, spans that exceed this duration will force trace to be sampled (ms) | `nil` |
| `proxy.histogramPort` | Port for histogram distribution format data (usually 40000) | `nil` |
| `proxy.histogramMinutePort` | Port to accumulate 1-minute based histograms on Wavefront data format (usually 40001) | `nil` |
| `proxy.histogramHourPort` | Port to accumulate 1-hour based histograms on Wavefront data format (usually 40002) | `nil` |
| `proxy.histogramDayPort` | Port to accumulate 1-day based histograms on Wavefront data format (usually 40003) | `nil` |
| `proxy.deltaCounterPort` | Port to accumulate 1-minute delta counters on Wavefront data format (usually 50000) | `nil` |
| `proxy.args` | Additional Wavefront proxy properties to be passed as command line arguments in the `--<property_name> <value>` format.  Multiple properties can be specified.  [See more](https://docs.wavefront.com/proxies_configuring.html) | `nil` |
| `proxy.heap` | Wavefront proxy Java heap maximum usage (java -Xmx command line option) | `nil` |
| `proxy.preprocessor.rules.yaml` | YAML configuraiton for Wavefront proxy preprocessor rules. [See more](https://docs.wavefront.com/proxies_preprocessor_rules.html) | `nil` |
| `rbac.create` | Create RBAC resources | `true` |
| `serviceAccount.create` | Create Wavefront service account  | `true` |
| `serviceAccount.name` | Name of Wavefront service account | `nil` |
| `kubeStateMetrics.enabled` | Setup and enable Kube State Metrics for collection | `false` |
| `projectPacific.enabled` | Enable and create role binding for Tanzu kubernetes cluster | `false` |


## Upgrading
### Upgrading from 1.0
Openshift support has been removed from the helm chart.  Use the Wavefront Openshift operator available [here](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes/tree/master/deploy/openshift) instead.

The `collector.kubernetesSource` parameter has been replaced with the `collector.useReadOnlyPort` option.
