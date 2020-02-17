# Fluentd

[Fluentd](https://www.fluentd.org/) is an open source data collector, which lets you unify the data collection and consumption for a better use and understanding of data.

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/fluentd
```

## Introduction

This chart bootstraps a [Fluentd](https://github.com/bitnami/bitnami-docker-fluentd) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/fluentd
```

These commands deploy Fluentd on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` resources:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all history too.

## Parameters

The following tables lists the configurable parameters of the kibana chart and their default values.

| Parameter                                       | Description                                                                                                    | Default                                                                                                 |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `global.imageRegistry`                          | Global Docker image registry                                                                                   | `nil`                                                                                                   |
| `global.imagePullSecrets`                       | Global Docker registry secret names as an array                                                                | `[]` (does not add image pull secrets to deployed pods)                                                 |
| `image.registry`                                | Fluentd image registry                                                                                         | `docker.io`                                                                                             |
| `image.repository`                              | Fluentd image name                                                                                             | `bitnami/fluentd`                                                                                       |
| `image.tag`                                     | Fluentd image tag                                                                                              | `{TAG_NAME}`                                                                                            |
| `image.pullPolicy`                              | Fluentd image pull policy                                                                                      | `IfNotPresent`                                                                                          |
| `image.pullSecrets`                             | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods)                                                 |
| `nameOverride`                                  | String to partially override fluentd.fullname template with a string (will prepend the release name)           | `nil`                                                                                                   |
| `fullnameOverride`                              | String to fully override fluentd.fullname template with a string                                               | `nil`                                                                                                   |
| `clusterDomain`                                 | Kubernetes DNS domain name to use                                                                              | `cluster.local`                                                                                         |
| `forwarder.enabled`                             | Enable Fluentd aggregator                                                                                      | `true`                                                                                                  |
| `forwarder.securityContext.enabled`             | Enable security context for forwarder pods                                                                     | `true`                                                                                                  |
| `forwarder.securityContext.fsGroup`             | Group ID for forwarder's containers filesystem                                                                 | `0`                                                                                                     |
| `forwarder.securityContext.runAsUser`           | User ID for forwarder's containers                                                                             | `0`                                                                                                     |
| `forwarder.configFile`                          | Name of the config file that will be used by Fluentd at launch under the `/opt/bitnami/fluentd/conf` directory | `fluentd.conf`                                                                                          |
| `forwarder.configMap`                           | Name of the config map that contains the Fluentd configuration files                                           | `nil`                                                                                                   |
| `forwarder.extraArgs`                           | Extra arguments for the Fluentd command line                                                                   | `nil`                                                                                                   |
| `forwarder.extraEnv`                            | Extra environment variables to pass to the container                                                           | `[]`                                                                                                    |
| `forwarder.containerPorts`                      | Ports the forwarder containers will listen on                                                                  | `Check values.yaml`                                                                                     |
| `forwarder.service.type`                        | Kubernetes service type (`ClusterIP`, `NodePort`, or `LoadBalancer`) for the forwarders                        | `ClusterIP`                                                                                             |
| `forwarder.service.ports`                       | Array containing the forwarder service ports                                                                   | `Check values.yaml file`                                                                                |
| `forwarder.service.loadBalancerIP`              | loadBalancerIP if service type is `LoadBalancer`                                                               | `nil`                                                                                                   |
| `forwarder.service.loadBalancerSourceRanges`    | Addresses that are allowed when service is LoadBalancer                                                        | `[]`                                                                                                    |
| `forwarder.service.clusterIP`                   | Static clusterIP or None for headless services                                                                 | `nil`                                                                                                   |
| `forwarder.service.annotations`                 | Annotations for the forwarder service                                                                          | `{}`                                                                                                    |
| `forwarder.livenessProbe.enabled`               | Enable liveness probes for the forwarder                                                                       | `true`                                                                                                  |
| `forwarder.livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                                       | `60`                                                                                                    |
| `forwarder.livenessProbe.periodSeconds`         | How often to perform the probe                                                                                 | `10`                                                                                                    |
| `forwarder.livenessProbe.timeoutSeconds`        | When the probe times out                                                                                       | `5`                                                                                                     |
| `forwarder.livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `6`                                                                                                     |
| `forwarder.livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                                                                     |
| `forwarder.readinessProbe.enabled`              | Enable readiness probes for the forwarder                                                                      | `true`                                                                                                  |
| `forwarder.readinessProbe.initialDelaySeconds`  | Delay before readiness probe is initiated                                                                      | `5`                                                                                                     |
| `forwarder.readinessProbe.periodSeconds`        | How often to perform the probe                                                                                 | `10`                                                                                                    |
| `forwarder.readinessProbe.timeoutSeconds`       | When the probe times out                                                                                       | `5`                                                                                                     |
| `forwarder.readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `6`                                                                                                     |
| `forwarder.readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                                                                     |
| `forwarder.updateStrategy`                      | Update strategy for the forwarder DaemonSet                                                                    | `RollingUpdate`                                                                                         |
| `forwarder.resources`                           | Configure resource requests and limits                                                                         | `nil`                                                                                                   |
| `forwarder.nodeSelector`                        | Node labels for pod assignment                                                                                 | `{}`                                                                                                    |
| `forwarder.tolerations`                         | Tolerations for pod assignment                                                                                 | `[]`                                                                                                    |
| `forwarder.affinity`                            | Affinity for pod assignment                                                                                    | `{}`                                                                                                    |
| `forwarder.podAnnotations`                      | Pod annotations                                                                                                | `{}`                                                                                                    |
| `aggregator.enabled`                            | Enable Fluentd aggregator                                                                                      | `true`                                                                                                  |
| `aggregator.replicaCount`                       | Number of aggregator pods to deploy in the Stateful Set                                                        | `2`                                                                                                     |
| `aggregator.securityContext.enabled`            | Enable security context for aggregator pods                                                                    | `true`                                                                                                  |
| `aggregator.securityContext.fsGroup`            | Group ID for aggregator's containers filesystem                                                                | `1001`                                                                                                  |
| `aggregator.securityContext.runAsUser`          | User ID for aggregator's containers                                                                            | `1001`                                                                                                  |
| `aggregator.configFile`                         | Name of the config file that will be used by Fluentd at launch under the `/opt/bitnami/fluentd/conf` directory | `fluentd.conf`                                                                                          |
| `aggregator.configMap`                          | Name of the config map that contains the Fluentd configuration files                                           | `nil`                                                                                                   |
| `aggregator.port`                               | Kubernetes Service port - Fluentd transport port for the aggregators                                           | `24224`                                                                                                 |
| `aggregator.extraArgs`                          | Extra arguments for the Fluentd command line                                                                   | `nil`                                                                                                   |
| `aggregator.extraEnv`                           | Extra environment variables to pass to the container                                                           | `[]`                                                                                                    |
| `aggregator.containerPorts`                     | Ports the aggregator containers will listen on                                                                 | `Check values.yaml`                                                                                     |
| `aggregator.service.type`                       | Kubernetes service type (`ClusterIP`, `NodePort`, or `LoadBalancer`) for the aggregators                       | `ClusterIP`                                                                                             |
| `aggregator.service.ports`                      | Array containing the aggregator service ports                                                                  | `Check values.yaml file`                                                                                |
| `aggregator.service.loadBalancerIP`             | loadBalancerIP if service type is `LoadBalancer`                                                               | `nil`                                                                                                   |
| `aggregator.service.loadBalancerSourceRanges`   | Addresses that are allowed when service is LoadBalancer                                                        | `[]`                                                                                                    |
| `aggregator.service.clusterIP`                  | Static clusterIP or None for headless services                                                                 | `nil`                                                                                                   |
| `aggregator.service.annotations`                | Annotations for the aggregator service                                                                         | `{}`                                                                                                    |
| `aggregator.livenessProbe.enabled`              | Enable liveness probes for the aggregator                                                                      | `true`                                                                                                  |
| `aggregator.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                       | `60`                                                                                                    |
| `aggregator.livenessProbe.periodSeconds`        | How often to perform the probe                                                                                 | `10`                                                                                                    |
| `aggregator.livenessProbe.timeoutSeconds`       | When the probe times out                                                                                       | `5`                                                                                                     |
| `aggregator.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `6`                                                                                                     |
| `aggregator.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                                                                     |
| `aggregator.readinessProbe.enabled`             | Enable readiness probes for the aggregator                                                                     | `true`                                                                                                  |
| `aggregator.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                                      | `5`                                                                                                     |
| `aggregator.readinessProbe.periodSeconds`       | How often to perform the probe                                                                                 | `10`                                                                                                    |
| `aggregator.readinessProbe.timeoutSeconds`      | When the probe times out                                                                                       | `5`                                                                                                     |
| `aggregator.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `6`                                                                                                     |
| `aggregator.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed.                   | `1`                                                                                                     |
| `aggregator.updateStrategy`                     | Update strategy for the aggregator DaemonSet                                                                   | `RollingUpdate`                                                                                         |
| `aggregator.resources`                          | Configure resource requests and limits                                                                         | `nil`                                                                                                   |
| `aggregator.nodeSelector`                       | Node labels for pod assignment                                                                                 | `{}`                                                                                                    |
| `aggregator.tolerations`                        | Tolerations for pod assignment                                                                                 | `[]`                                                                                                    |
| `aggregator.affinity`                           | Affinity for pod assignment                                                                                    | `{}`                                                                                                    |
| `aggregator.podAnnotations`                     | Pod annotations                                                                                                | `{}`                                                                                                    |
| `serviceAccount.create`                         | Specify whether a ServiceAccount should be created                                                             | `true`                                                                                                  |
| `serviceAccount.name`                           | The name of the ServiceAccount to create                                                                       | Generated using the `fluentd.fullname` template                                                         |
| `rbac.create`                                   | Specify whether RBAC resources should be created and used                                                      | `true`                                                                                                  |
| `metrics.enabled`                               | Enable the export of Prometheus metrics                                                                        | `nil`                                                                                                   |
| `metrics.service.type`                          | Prometheus metrics service type                                                                                | `ClusterIP`                                                                                             |
| `metrics.service.loadBalancerIP`                | Load Balancer IP if the Prometheus metrics server type is `LoadBalancer`                                       | `nil`                                                                                                   |
| `metrics.service.port`                          | Prometheus metrics service port                                                                                | `24231`                                                                                                 |
| `metrics.service.annotations`                   | Annotations for Prometheus metrics service                                                                     | `{ prometheus.io/scrape: "true", prometheus.io/port: "80", prometheus.io/path: "_prometheus/metrics" }` |
| `metrics.serviceMonitor.enabled`                | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)         | `false`                                                                                                 |
| `metrics.serviceMonitor.namespace`              | Namespace in which Prometheus is running                                                                       | `nil`                                                                                                   |
| `metrics.serviceMonitor.interval`               | Interval at which metrics should be scraped.                                                                   | `nil` (Prometheus Operator default value)                                                               |
| `metrics.serviceMonitor.scrapeTimeout`          | Timeout after which the scrape is ended                                                                        | `nil` (Prometheus Operator default value)                                                               |
| `metrics.serviceMonitor.selector`               | Prometheus instance selector labels                                                                            | `nil`                                                                                                   |
| `tls.enabled`                                   | Enable the addition of TLS certificates                                                                        | `false`                                                                                                 |
| `tls.caCertificate`                             | Ca certificate                                                                                                 | Certificate Authority (CA) bundle content                                                               |
| `tls.serverCertificate`                         | Server certificate                                                                                             | Server certificate content                                                                              |
| `tls.serverKey`                                 | Server Key                                                                                                     | Server private key content                                                                              |
| `tls.existingSecret`                            | Existing secret with certificate content                                                                       | `nil`                                                                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set aggregator.port=24444 bitnami/fluentd
```

The above command sets the aggregators to listen on port 24444.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/fluentd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Number of aggregator nodes:
```diff
- aggregator.replicaCount: 1
+ aggregator.replicaCount: 2
```

- Enable prometheus to access fluentd metrics endpoint:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

To horizontally scale this chart once it has been deployed, you can upgrade the deployment using a new value for the `aggregator.replicaCount` parameter.

### Forwarding the logs to another service

By default, the aggregators in this chart will send the processed logs to the standard output. However, a common practice is to send them to another service, like Elasticsearch, instead. This can be achieved with this Helm Chart by mounting your own configuration files. For example:

**configmap.yaml**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: elasticsearch-output
data:
  fluentd.conf: |
    # Prometheus Exporter Plugin
    # input plugin that exports metrics
    <source>
      @type prometheus
      port {{ .Values.metrics.service.port }}
    </source>

    # input plugin that collects metrics from MonitorAgent
    <source>
      @type prometheus_monitor
      <labels>
        host ${hostname}
      </labels>
    </source>

    # input plugin that collects metrics for output plugin
    <source>
      @type prometheus_output_monitor
      <labels>
        host ${hostname}
      </labels>
    </source>
    {{- end }}

    # Ignore fluentd own events
    <match fluent.**>
      @type null
    </match>

    # TCP input to receive logs from the forwarders
    <source>
      @type forward
      bind 0.0.0.0
      port {{ .Values.aggregator.port }}
    </source>

    # HTTP input for the liveness and readiness probes
    <source>
      @type http
      bind 0.0.0.0
      port 9880
    </source>

    # Throw the healthcheck to the standard output instead of forwarding it
    <match fluentd.healthcheck>
      @type stdout
    </match>

    # Send the logs to the standard output
    <match **>
      @type elasticsearch
      include_tag_key true
      host "#{ENV['ELASTICSEARCH_HOST']}"
      port "#{ENV['ELASTICSEARCH_PORT']}"
      logstash_format true

      <buffer>
        @type file
        path /opt/bitnami/fluentd/logs/buffers/logs.buffer
        flush_thread_count 2
        flush_interval 5s
      </buffer>
    </match>
```

As an example, using the above configmap, you should specify the required parameters when upgrading or installing the chart:

```console
aggregator.configMap=elasticsearch-output
aggregator.extraEnv[0].name=ELASTICSEARCH_HOST
aggregator.extraEnv[0].value=your-ip-here
aggregator.extraEnv[1].name=ELASTICSEARCH_PORT
aggregator.extraEnv[1].value=your-port-here
```
