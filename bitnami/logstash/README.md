# Logstash

[Logstash](https://www.elastic.co/products/logstash) is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite "stash".

## TL;DR;

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/logstash
```

## Introduction

This chart bootstraps a [logstash](https://github.com/bitnami/bitnami-docker-logstash) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.12+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/logstash
```

These commands deploy logstash on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` statefulset:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Use the option `--purge` to delete all history too.

## Parameters

The following tables lists the configurable parameters of the Logstash chart and their default values.

| Parameter                                  | Description                                                                                                          | Default                                                 |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                     | Global Docker image registry                                                                                         | `nil`                                                   |
| `global.imagePullSecrets`                  | Global Docker registry secret names as an array                                                                      | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                      | Global storage class for dynamic provisioning                                                                        | `nil`                                                   |
| `image.registry`                           | Logstash image registry                                                                                              | `docker.io`                                             |
| `image.repository`                         | Logstash image name                                                                                                  | `bitnami/logstash`                                      |
| `image.tag`                                | Logstash image tag                                                                                                   | `{TAG_NAME}`                                            |
| `image.pullPolicy`                         | Logstash image pull policy                                                                                           | `IfNotPresent`                                          |
| `image.pullSecrets`                        | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                              | Specify if debug logs should be enabled                                                                              | `false`                                                 |
| `nameOverride`                             | String to partially override logstash.fullname template with a string (will prepend the release name)                | `nil`                                                   |
| `fullnameOverride`                         | String to fully override logstash.fullname template with a string                                                    | `nil`                                                   |
| `clusterDomain`                            | Default Kubernetes cluster domain                                                                                    | `cluster.local`                                         |
| `configFileName`                           | Logstash configuration file name. It must match the name of the configuration file mounted as a configmap.           | `logstash.conf`                                         |
| `enableMonitoringAPI`                      | Whether to enable the Logstash Monitoring API or not  Kubernetes cluster domain                                      | `true`                                                  |
| `monitoringAPIPort`                        | Logstash Monitoring API Port                                                                                         | `9600`                                                  |
| `extraEnvVars`                             | Array containing extra env vars to configure Logstash                                                                | `nil`                                                   |
| `input`                                    | Input Plugins configuration                                                                                          | `Check values.yaml file`                                |
| `filter`                                   | Filter Plugins configuration                                                                                         | `nil`                                                   |
| `output`                                   | Output Plugins configuration                                                                                         | `Check values.yaml file`                                |
| `existingConfiguration`                    | Name of existing ConfigMap object with the Logstash configuration (`input`, `filter`, and `output` will be ignored). | `nil`                                                   |
| `containerPorts`                           | Array containing the ports to open in the Logstash container                                                         | `Check values.yaml file`                                |
| `replicaCount`                             | The number of Logstash replicas to deploy                                                                            | `1`                                                     |
| `updateStrategy`                           | Update strategy (`RollingUpdate`, or `OnDelete`)                                                                     | `RollingUpdate`                                         |
| `podManagementPolicy`                      | Pod management policy                                                                                                | `OrderedReady`                                          |
| `podAnnotations`                           | Pod annotations                                                                                                      | `{}` (The value is evaluated as a template)             |
| `affinity`                                 | Affinity for pod assignment                                                                                          | `{}` (The value is evaluated as a template)             |
| `nodeSelector`                             | Node labels for pod assignment                                                                                       | `{}` (The value is evaluated as a template)             |
| `tolerations`                              | Tolerations for pod assignment                                                                                       | `[]` (The value is evaluated as a template)             |
| `priorityClassName`                        | Controller priorityClassName                                                                                         | `nil`                                                   |
| `securityContext.enabled`                  | Enable security context for Logstash                                                                                 | `true`                                                  |
| `securityContext.fsGroup`                  | Group ID for the Logstash filesystem                                                                                 | `1001`                                                  |
| `securityContext.runAsUser`                | User ID for the Logstash container                                                                                   | `1001`                                                  |
| `resources.limits`                         | The resources limits for the Logstash container                                                                      | `{}`                                                    |
| `resources.requests`                       | The requested resources for the Logstash container                                                                   | `{}`                                                    |
| `livenessProbe`                            | Liveness probe configuration for Logstash                                                                            | `Check values.yaml file`                                |
| `readinessProbe`                           | Readiness probe configuration for Logstash                                                                           | `Check values.yaml file`                                |
| `service.type`                             | Kubernetes service type (`ClusterIP`, `NodePort`, or `LoadBalancer`)                                                 | `ClusterIP`                                             |
| `service.ports`                            | Array containing the Logstash service ports                                                                          | `Check values.yaml file`                                |
| `service.annotations`                      | Annotations for Logstash service                                                                                     | `{}`                                                    |
| `service.loadBalancerIP`                   | loadBalancerIP if service type is `LoadBalancer`                                                                     | `nil`                                                   |
| `service.loadBalancerSourceRanges`         | Address that are allowed when service is LoadBalancer                                                                | `[]`                                                    |
| `service.clusterIP`                        | Static clusterIP or None for headless services                                                                       | `nil`                                                   |
| `ingress.enabled`                          | Enable ingress controller resource                                                                                   | `false`                                                 |
| `ingress.certManager`                      | Add annotations for cert-manager                                                                                     | `false`                                                 |
| `ingress.annotations`                      | Ingress annotations                                                                                                  | `{}`                                                    |
| `ingress.hosts[0].name`                    | Hostname for Logstash service                                                                                        | `logstash.local`                                        |
| `ingress.hosts[0].path`                    | Path within the url structure                                                                                        | `/`                                                     |
| `ingress.tls[0].hosts[0]`                  | TLS hosts                                                                                                            | `logstash.local`                                        |
| `ingress.tls[0].secretName`                | TLS Secret (certificates)                                                                                            | `logstash.local-tls`                                    |
| `ingress.secrets[0].name`                  | TLS Secret Name                                                                                                      | `nil`                                                   |
| `ingress.secrets[0].certificate`           | TLS Secret Certificate                                                                                               | `nil`                                                   |
| `ingress.secrets[0].key`                   | TLS Secret Key                                                                                                       | `nil`                                                   |
| `metrics.enabled`                          | Enable the export of Prometheus metrics                                                                              | `false`                                                 |
| `metrics.image.registry`                   | Logstash Relay image registry                                                                                        | `docker.io`                                             |
| `metrics.image.repository`                 | Logstash Relay image name                                                                                            | `bitnami/logstash-exporter`                             |
| `metrics.image.tag`                        | Logstash Relay image tag                                                                                             | `{TAG_NAME}`                                            |
| `metrics.image.pullPolicy`                 | Logstash Relay image pull policy                                                                                     | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.resources.limits`                 | The resources limits for the Logstash Prometheus Exporter container                                                  | `{}`                                                    |
| `metrics.resources.requests`               | The requested resources for the Logstash Prometheus Exporter container                                               | `{}`                                                    |
| `metrics.livenessProbe`                    | Liveness probe configuration for Logstash Prometheus Exporter                                                        | `Check values.yaml file`                                |
| `metrics.readinessProbe`                   | Readiness probe configuration for Logstash Prometheus Exporter                                                       | `Check values.yaml file`                                |
| `metrics.service.type`                     | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                  | `ClusterIP`                                             |
| `metrics.service.port`                     | Logstash Prometheus Exporter port                                                                                    | `9122`                                                  |
| `metrics.service.nodePort`                 | Kubernetes HTTP node port                                                                                            | `""`                                                    |
| `metrics.service.annotations`              | Annotations for Logstash Prometheus Exporter service                                                                 | `Check values.yaml file`                                |
| `metrics.service.loadBalancerIP`           | loadBalancerIP if service type is `LoadBalancer`                                                                     | `nil`                                                   |
| `metrics.service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                                | `[]`                                                    |
| `metrics.service.clusterIP`                | Static clusterIP or None for headless services                                                                       | `nil`                                                   |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)               | `false`                                                 |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                                             | `nil`                                                   |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                                         | `nil` (Prometheus Operator default value)               |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                              | `nil` (Prometheus Operator default value)               |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                  | `nil`                                                   |
| `podDisruptionBudget.create`               | If true, create a pod disruption budget for pods.                                                                    | `false`                                                 |
| `podDisruptionBudget.minAvailable`         | Minimum number / percentage of pods that should remain scheduled                                                     | `1`                                                     |
| `podDisruptionBudget.maxUnavailable`       | Maximum number / percentage of pods that may be made unavailable                                                     | `nil`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set enableMonitoringAPI=false bitnami/logstash
```

The above command disables the Logstash Monitoring API.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/logstash
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`:

- Increase the number of Logstash replicas:

```diff
- replicaCount: 1
+ replicaCount: 3
```

- Enable Prometheus metrics:

```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### Configure the way how to expose Logstash

- **Ingress**: The ingress controller must be installed in the Kubernetes cluster. Set `ingress.enabled=true` to expose Logstash through Ingress.
- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster. Set `logstash.service.type=ClusterIP` to choose this service type.
- **NodePort**: Exposes the service on each Node's IP at a static port (the NodePort). You’ll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`. Set `logstash.service.type=NodePort` to choose this service type.
- **LoadBalancer**: Exposes the service externally using a cloud provider's load balancer. Set `logstash.service.type=LoadBalancer` to choose this service type.

### Using custom configuration

By default, this Helm chart provides a very basic configuration for Logstash, which listen HTTP requests on port 8080 and writes them to stdout.

You can achieve any Logstash configuration by providing your custom configuration files. To do so, this helm chart supports to customize every configuration file.

Add your custom configuration files to "files/conf" in your working directory. These files will be mounted as a configMap to the containers and they will be used for configuring Logstash.

Alternatively, you can specify the Logstash configuration using the `logstash.input`, `logstash.filter`, and `logstash.output` parameters. Each of them, allows you to specify the Input Plugins, Filter Plugins, and Output Plugins configuration, respectively.

In addition to these options, you can also set an external ConfigMap with all the configuration files. This is done by setting the `logstash.existingConfiguration` parameter. Note that this will override the two previous options.

### Adding extra environment variables

In case you want to add extra environment variables, you can use the `logstash.extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ELASTICSEARCH_HOST
    value: "x.y.z"
```
